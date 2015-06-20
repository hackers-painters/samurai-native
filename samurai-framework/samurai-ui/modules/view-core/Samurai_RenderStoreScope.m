//
//     ____    _                        __     _      _____
//    / ___\  /_\     /\/\    /\ /\    /__\   /_\     \_   \
//    \ \    //_\\   /    \  / / \ \  / \//  //_\\     / /\/
//  /\_\ \  /  _  \ / /\/\ \ \ \_/ / / _  \ /  _  \ /\/ /_
//  \____/  \_/ \_/ \/    \/  \___/  \/ \_/ \_/ \_/ \____/
//
//	Copyright Samurai development team and other contributors
//
//	http://www.samurai-framework.com
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//

#import "Samurai_RenderStoreScope.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_DomNode.h"
#import "Samurai_RenderObject.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSObject(StoreSupport)

- (BOOL)store_isValid
{
	return YES;
}

- (BOOL)store_hasChildren
{
	return YES;
}

@end

#pragma mark -

@implementation SamuraiRenderStoreScope

@def_prop_strong( SamuraiRenderStoreNode *,	storeTree );

BASE_CLASS( SamuraiRenderStoreScope )

+ (SamuraiRenderStoreScope *)storeScope:(id)sourceOrTarget
{
	SamuraiRenderObject * renderer = nil;
	
	if ( [sourceOrTarget isKindOfClass:[UIViewController class]] )
	{
		renderer = [[sourceOrTarget view] renderer];
	}
	else if ( [sourceOrTarget isKindOfClass:[UIView class]] )
	{
		renderer = [sourceOrTarget renderer];
	}
	else if ( [sourceOrTarget isKindOfClass:[SamuraiRenderObject class]] )
	{
		renderer = sourceOrTarget;
	}
	
	if ( nil == renderer )
		return nil;

	SamuraiRenderStoreScope * scope = [[self alloc] init];
	[scope attach:renderer];
	return scope;
}

#pragma mark -

- (id)init
{
	self = [super init];
	if ( self )
	{
	}
	return self;
}

- (void)dealloc
{
	self.storeTree = nil;
}

#pragma mark -

- (void)attach:(SamuraiRenderObject *)renderer
{
	self.storeTree = [SamuraiRenderStoreNode storeNode];
	
	[self attach:renderer forStore:self.storeTree];
}

- (void)attach:(SamuraiRenderObject *)renderer forStore:(SamuraiRenderStoreNode *)parentStore
{
	if ( NO == [renderer store_isValid] )
		return;

	SamuraiRenderStoreNode * thisStore = nil;
	
	if ( renderer.dom.domName && renderer.dom.domName.length )
	{
		thisStore = [SamuraiRenderStoreNode storeNode:renderer];

		[parentStore appendNode:thisStore];
	}
	
	if ( nil == thisStore )
	{
		thisStore = parentStore;
	}

	if ( [renderer store_hasChildren] )
	{
		for ( SamuraiRenderObject * childRenderer in renderer.childs )
		{
			[self attach:childRenderer forStore:thisStore];
		}
	}
}

#pragma mark -

- (id)getData
{
	if ( nil == self.storeTree )
		return nil;
	
	return [self getDataWithPath:nil];
}

- (id)getDataWithPath:(NSString *)path
{
	if ( nil == self.storeTree )
		return nil;

	if ( nil == path )
	{
		return [self getDataFromStore:self.storeTree];
	}
	else
	{
		NSArray * storeNodes = [self.storeTree find:path];
		
		if ( nil == storeNodes || 0 == storeNodes.count )
		{
			return nil;
		}
		
		if ( 1 == storeNodes.count )
		{
			return [self getDataFromStore:[storeNodes firstObject]];
		}
		else
		{
			NSMutableArray * array = [NSMutableArray array];
			
			for ( SamuraiRenderStoreNode * childStore in storeNodes)
			{
				NSObject * childData = [self getDataFromStore:childStore];
				
				if ( childData )
				{
					[array addObject:childData];
				}
			}
			
			return array;
		}
	}
}

- (id)getDataFromStore:(SamuraiRenderStoreNode *)store
{
	if ( nil == store )
		return nil;

	if ( store.childs.count )
	{
		NSMutableDictionary * dict = [NSMutableDictionary dictionary];

		for ( SamuraiRenderStoreNode * childStore in store.childs )
		{
			if ( [childStore.renderer.dom.domName hasSuffix:@"[]"] )
			{
				NSString * childPath = nil;
				
				childPath = childStore.renderer.dom.domName;
				childPath = [childPath substringToIndex:childPath.length - 2];

				NSMutableArray * array = [dict objectForKey:childPath];
				
				if ( nil == array )
				{
					array = [[NSMutableArray alloc] init];
					
					[dict setObject:array forKey:childPath];
				}
				
				NSObject * value = [self getDataFromStore:childStore];
				if ( value )
				{
					[array addObject:value];
				}
			}
			else
			{
				NSObject * value = [self getDataFromStore:childStore];
				if ( value )
				{
					[dict setObject:value forKey:childStore.renderer.dom.domName];
				}
			}
		}

		return dict;
	}
	else
	{
		return [store.renderer serialize];
	}
}

#pragma mark -

- (void)setData:(NSObject *)data
{
	if ( nil == self.storeTree )
		return;
	
	[self setData:data withPath:nil];
}

- (void)setData:(NSObject *)data withPath:(NSString *)path
{
	if ( nil == self.storeTree )
		return;

	if ( nil == path )
	{
		[self setData:data forStore:self.storeTree];
	}
	else
	{
		[self.storeTree dump];
		
		NSArray * storeNodes = [self.storeTree find:path];
		
		if ( nil == storeNodes || 0 == storeNodes.count )
		{
			return;
		}
		
		if ( 1 == storeNodes.count )
		{
			if ( data )
			{
				[self setData:data forStore:[storeNodes firstObject]];
			}
			else
			{
				[self setData:nil forStore:[storeNodes firstObject]];
			}
		}
		else
		{
			if ( [data isKindOfClass:[NSArray class]] || [data conformsToProtocol:@protocol(NSArrayProtocol)] )
			{
				for ( SamuraiRenderStoreNode * childStore in storeNodes)
				{
					NSObject * childData = [(NSArray *)data safeObjectAtIndex:[storeNodes indexOfObject:childStore]];
					
					if ( childData )
					{
						[self setData:childData forStore:childStore];
					}
					else
					{
						[self clearDataForStore:childStore];
					}
				}
			}
			else
			{
				for ( SamuraiRenderStoreNode * childStore in storeNodes)
				{
					if ( 0 == [storeNodes indexOfObject:childStore] )
					{
						[self setData:data forStore:childStore];
					}
					else
					{
						[self clearDataForStore:childStore];
					}
				}
			}
		}
	}
}

- (void)setData:(NSObject *)data forStore:(SamuraiRenderStoreNode *)store
{
	if ( nil == store )
		return;

	if ( store.renderer && store.renderer.dom.domName )
	{
		INFO( @"Set data for '%@'", store.renderer.dom.domName );
		
		if ( data )
		{
			[store.renderer unserialize:data];
		}
//		else
//		{
//			[store.renderer zerolize];
//		}
	}

	NSMutableDictionary * arrayIndexes = nil;

	for ( SamuraiRenderStoreNode * childStore in store.childs )
	{
		if ( childStore.renderer )
		{
			NSObject * value = nil;
			
			if ( [childStore.renderer.dom.domName hasSuffix:@"[]"] )
			{
				NSString * childPath = nil;

				childPath = childStore.renderer.dom.domName;
				childPath = [childPath substringToIndex:childPath.length - 2];

				if ( [data isKindOfClass:[NSDictionary class]] || [data conformsToProtocol:@protocol(NSDictionaryProtocol)] )
				{
					value = [(NSDictionary *)data objectForKey:childStore.renderer.dom.domName];
					
					if ( nil == value )
					{
						value = [(NSDictionary *)data objectForKey:childPath];
					}
				}
				else
				{
					value = [(NSObject *)data valueForKey:childStore.renderer.dom.domName];

					if ( nil == value )
					{
						value = [(NSObject *)data valueForKey:childPath];
					}
				}
				
				if ( [value isKindOfClass:[NSArray class]] || [value conformsToProtocol:@protocol(NSArrayProtocol)] )
				{
					if ( nil == arrayIndexes )
					{
						arrayIndexes = [NSMutableDictionary dictionary];
					}
					
					NSNumber * childIndex = [arrayIndexes objectForKey:childPath];
					
					if ( nil == childIndex )
					{
						value = [(NSArray *)value safeObjectAtIndex:0];
						
						[arrayIndexes setObject:@(1) forKey:childPath];
					}
					else
					{
						value = [(NSArray *)value safeObjectAtIndex:childIndex.integerValue];
						
						[arrayIndexes setObject:@(childIndex.integerValue + 1) forKey:childPath];
					}
				}
			}
			else
			{
				if ( [data isKindOfClass:[NSDictionary class]] || [data conformsToProtocol:@protocol(NSDictionaryProtocol)] )
				{
					value = [(NSDictionary *)data objectForKey:childStore.renderer.dom.domName];
				}
				else
				{
					value = [(NSObject *)data valueForKey:childStore.renderer.dom.domName];
				}
			}
			
			[self setData:value forStore:childStore];
		}
		else
		{
			[self setData:data forStore:childStore];
		}
	}
}

#pragma mark -

- (void)clearData
{
	if ( nil == self.storeTree )
		return;
	
	[self clearDataWithPath:nil];
}

- (void)clearDataWithPath:(NSString *)path
{
	if ( nil == self.storeTree )
		return;

	if ( nil == path )
	{
		[self clearDataForStore:self.storeTree];
	}
	else
	{
		NSArray * storeNodes = [self.storeTree find:path];
		
		for ( SamuraiRenderStoreNode * childStore in storeNodes )
		{
			[self clearDataForStore:childStore];
		}
	}
}

- (void)clearDataForStore:(SamuraiRenderStoreNode *)store
{
	if ( nil == store )
	{
		return;
	}

	if ( store.renderer && store.renderer.dom.domName )
	{
		[store.renderer zerolize];
	}

	for ( SamuraiRenderStoreNode * childStore in store.childs )
	{
		[self clearDataForStore:childStore];
	}
}

#pragma mark -

- (NSString *)description
{
	[[SamuraiLogger sharedInstance] outputCapture];
	
	[self dump];
	
	[[SamuraiLogger sharedInstance] outputRelease];
	
	return [SamuraiLogger sharedInstance].output;
}

- (void)dump
{
	[self.storeTree dump];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, RenderStoreScope )

DESCRIBE( before )
{
}

DESCRIBE( after )
{
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "_pragma_pop.h"
