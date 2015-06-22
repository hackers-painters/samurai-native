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

#import "Samurai_HtmlArray.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiHtmlStyleObject(Array)

- (BOOL)isArray
{
	return NO;
}

- (NSUInteger)count
{
	return 0;
}

- (id)objectAtIndex:(NSUInteger)index
{
	return nil;
}

- (void)addObject:(id)anObject
{

}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index
{
	
}

- (void)removeLastObject
{
	
}

- (void)removeObjectAtIndex:(NSUInteger)index
{
	
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
	
}

@end

#pragma mark -

@implementation SamuraiHtmlArray

@def_prop_strong( NSMutableArray *,	items );

+ (instancetype)object:(id)any
{
	if ( nil == any )
		return nil;

	if ( [any isKindOfClass:[NSString class]] )
	{
		NSString * str = any;
		
		if ( nil == str || 0 == str.length )
			return nil;

		SamuraiHtmlArray * array = nil;

		NSArray * components = [str componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		if ( 0 != components.count )
		{
			for ( NSString * component in components )
			{
				SamuraiHtmlValue * value = [SamuraiHtmlValue object:component];
				
				if ( value )
				{
					array = array ?: [[self alloc] init];
					
					[array.items addObject:value];
				}
			}
		}
		
		return array;
	}
	else if ( [any isKindOfClass:[NSArray class]] )
	{
		NSArray * arr = any;
		
		SamuraiHtmlArray * array = nil;
		
		for ( NSObject * elem in arr )
		{
			SamuraiHtmlValue * value = [SamuraiHtmlValue object:elem];

			if ( value )
			{
				array = array ?: [[self alloc] init];
				
				[array.items addObject:value];
			}
		}

		return array;
	}
	else if ( [any isKindOfClass:[SamuraiHtmlStyleObject class]] )
	{
		SamuraiHtmlArray * array = [[self alloc] init];
		
		[array.items addObject:any];

		return array;
	}
	
	return nil; // [super object:any];
}

+ (instancetype)array:(NSArray *)array
{
	return [self object:array];
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.items = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[self.items removeAllObjects];
	self.items = nil;
}

- (BOOL)isArray
{
	return YES;
}

- (NSUInteger)count
{
	return [self.items count];
}

- (id)objectAtIndex:(NSUInteger)index
{
	return [self.items safeObjectAtIndex:index];
}

- (void)addObject:(id)anObject
{
	[self.items addObject:anObject];
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index
{
	[self.items insertObject:anObject atIndex:index];
}

- (void)removeLastObject
{
	[self.items removeLastObject];
}

- (void)removeObjectAtIndex:(NSUInteger)index
{
	[self.items removeObjectAtIndex:index];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
	[self.items replaceObjectAtIndex:index withObject:anObject];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlArray )

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
