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

#import "Samurai_HtmlRenderStoreScope.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiHtmlRenderStoreScope

@def_prop_dynamic( NSObject *,				content );
@def_prop_strong( SamuraiHtmlRenderStore *,	storeTree );

BASE_CLASS( SamuraiHtmlRenderStoreScope )

+ (SamuraiHtmlRenderStoreScope *)scope:(id)sourceOrTarget
{
	SamuraiHtmlRenderObject * renderer = nil;
	
	if ( [sourceOrTarget isKindOfClass:[UIViewController class]] )
	{
		renderer = (SamuraiHtmlRenderObject *)[[sourceOrTarget view] renderer];
	}
	else if ( [sourceOrTarget isKindOfClass:[UIView class]] )
	{
		renderer = (SamuraiHtmlRenderObject *)[sourceOrTarget renderer];
	}
	else if ( [sourceOrTarget isKindOfClass:[SamuraiHtmlRenderObject class]] )
	{
		renderer = sourceOrTarget;
	}
	
	if ( nil == renderer )
		return nil;

	SamuraiHtmlRenderStoreScope * scope = [[self alloc] init];
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

- (void)attach:(SamuraiHtmlRenderObject *)renderer
{
	self.storeTree = [SamuraiHtmlRenderStore store];
	
	[self attach:renderer forStore:self.storeTree];
}

- (void)attach:(SamuraiHtmlRenderObject *)renderer forStore:(SamuraiHtmlRenderStore *)parentStore
{
	SamuraiHtmlRenderStore * thisStore = nil;
	
	if ( renderer.dom.attrName && renderer.dom.attrName.length )
	{
		thisStore = [SamuraiHtmlRenderStore store:renderer];

		[parentStore appendNode:thisStore];
	}
	
	if ( nil == thisStore )
	{
		thisStore = parentStore;
	}

	if ( [renderer store_hasChildren] )
	{
		for ( SamuraiHtmlRenderObject * child in renderer.childs )
		{
			[self attach:child forStore:thisStore];
		}
	}
}

#pragma mark -

- (NSObject *)content
{
	return [self getData];
}

- (void)setContent:(NSObject *)obj
{
	if ( obj )
	{
		[self setData:obj];
	}
	else
	{
		[self clearData];
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
		NSArray * nodes = [self.storeTree find:path];
		
		if ( nil == nodes || 0 == nodes.count )
		{
			return nil;
		}
		
		if ( 1 == nodes.count )
		{
			return [self getDataFromStore:[nodes firstObject]];
		}
		else
		{
			NSMutableArray * array = [NSMutableArray array];
			
			for ( SamuraiHtmlRenderStore * child in nodes)
			{
				NSObject * childData = [self getDataFromStore:child];
				
				if ( childData )
				{
					[array addObject:childData];
				}
			}
			
			return array;
		}
	}
}

- (id)getDataFromStore:(SamuraiHtmlRenderStore *)store
{
	if ( nil == store )
		return nil;

	if ( store.childs.count )
	{
		NSMutableDictionary * dict = [NSMutableDictionary dictionary];

		for ( SamuraiHtmlRenderStore * child in store.childs )
		{
			if ( [child.source.dom.attrName hasSuffix:@"[]"] )
			{
				NSString * childPath = nil;
				
				childPath = child.source.dom.attrName;
				childPath = [childPath substringToIndex:childPath.length - 2];

				NSMutableArray * array = [dict objectForKey:childPath];
				
				if ( nil == array )
				{
					array = [[NSMutableArray alloc] init];
					
					[dict setObject:array forKey:childPath];
				}
				
				NSObject * value = [self getDataFromStore:child];
				if ( value )
				{
					[array addObject:value];
				}
			}
			else
			{
				NSObject * value = [self getDataFromStore:child];
				if ( value )
				{
					[dict setObject:value forKey:child.source.dom.attrName];
				}
			}
		}

		return dict;
	}
	else
	{
		PERF( @"RenderScope '%p', serialize '%@'", self, store.source.dom.attrName );
		
		return [store.source store_serialize];
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
		
		NSArray * nodes = [self.storeTree find:path];
		
		if ( nil == nodes || 0 == nodes.count )
		{
			return;
		}
		
		if ( 1 == nodes.count )
		{
			if ( data )
			{
				[self setData:data forStore:[nodes firstObject]];
			}
			else
			{
				[self setData:nil forStore:[nodes firstObject]];
			}
		}
		else
		{
			if ( [data isKindOfClass:[NSArray class]] || [data conformsToProtocol:@protocol(NSArrayProtocol)] )
			{
				for ( SamuraiHtmlRenderStore * child in nodes)
				{
					NSObject * childData = [(NSArray *)data safeObjectAtIndex:[nodes indexOfObject:child]];
					
					if ( childData )
					{
						[self setData:childData forStore:child];
					}
					else
					{
						[self clearDataForStore:child];
					}
				}
			}
			else
			{
				for ( SamuraiHtmlRenderStore * child in nodes)
				{
					if ( 0 == [nodes indexOfObject:child] )
					{
						[self setData:data forStore:child];
					}
					else
					{
						[self clearDataForStore:child];
					}
				}
			}
		}
	}
}

- (void)setData:(NSObject *)data forStore:(SamuraiHtmlRenderStore *)store
{
	if ( nil == store )
		return;

	if ( store.source && store.source.dom.attrName )
	{
		PERF( @"RenderScope '%p', unserialize '%@'", self, store.source.dom.attrName );
		
		if ( data )
		{
			[store.source store_unserialize:data];
		}
//		else
//		{
//			[store.source store_zerolize];
//		}
	}

	NSMutableDictionary * arrayIndexes = nil;

	for ( SamuraiHtmlRenderStore * child in store.childs )
	{
		if ( child.source )
		{
			NSObject * value = nil;
			
			if ( [child.source.dom.attrName hasSuffix:@"[]"] )
			{
				NSString * childPath = nil;

				childPath = child.source.dom.attrName;
				childPath = [childPath substringToIndex:childPath.length - 2];

				if ( [data isKindOfClass:[NSDictionary class]] || [data conformsToProtocol:@protocol(NSDictionaryProtocol)] )
				{
					value = [(NSDictionary *)data objectForKey:child.source.dom.attrName];
					
					if ( nil == value )
					{
						value = [(NSDictionary *)data objectForKey:childPath];
					}
				}
				else
				{
					value = [(NSObject *)data valueForKey:child.source.dom.attrName];

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
					value = [(NSDictionary *)data objectForKey:child.source.dom.attrName];
				}
				else
				{
					value = [(NSObject *)data valueForKey:child.source.dom.attrName];
				}
			}
			
			[self setData:value forStore:child];
		}
		else
		{
			[self setData:data forStore:child];
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
		NSArray * nodes = [self.storeTree find:path];
		
		for ( SamuraiHtmlRenderStore * child in nodes )
		{
			[self clearDataForStore:child];
		}
	}
}

- (void)clearDataForStore:(SamuraiHtmlRenderStore *)store
{
	if ( nil == store )
	{
		return;
	}

	if ( store.source && store.source.dom.attrName )
	{
		PERF( @"RenderScope '%p', zerolize '%@'", self, store.source.dom.attrName );
		
		[store.source store_zerolize];
	}

	for ( SamuraiHtmlRenderStore * child in store.childs )
	{
		[self clearDataForStore:child];
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

#pragma mark -

- (id)objectForKey:(id)key
{
	return [self getDataWithPath:key];
}

- (BOOL)hasObjectForKey:(id)key
{
	return [self getDataWithPath:key] ? YES : NO;
}

- (id)objectForKeyedSubscript:(id)key
{
	return [self getDataWithPath:key];
}

- (void)setObject:(id)object forKey:(id)key
{
	[self setData:object withPath:key];
}

- (void)removeObjectForKey:(id)key
{
	[self clearDataWithPath:key];
}

- (void)removeAllObjects
{
	[self clearData];
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key
{
	[self setData:obj withPath:key];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlRenderStoreScope )

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
