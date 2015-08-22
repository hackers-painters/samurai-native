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

#import "Samurai_CSSArray.h"
#import "Samurai_CSSValue.h"
#import "Samurai_CSSParser.h"
#import "Samurai_CSSObject.h"
#import "Samurai_CSSObjectCache.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiCSSObject(Array)

- (BOOL)isArray
{
	return NO;
}

- (NSArray *)array
{
	return nil;
}

- (NSUInteger)count
{
	return 0;
}

- (id)objectAtIndex:(NSUInteger)index
{
	return nil;
}

- (void)addObject:(__unused id)anObject
{

}

- (void)insertObject:(__unused id)anObject atIndex:(__unused NSUInteger)index
{
	
}

- (void)removeLastObject
{
	
}

- (void)removeObjectAtIndex:(__unused NSUInteger)index
{
	
}

- (void)replaceObjectAtIndex:(__unused NSUInteger)index withObject:(__unused id)anObject
{
	
}

- (SamuraiCSSValue *)top
{
	return nil;
}

- (SamuraiCSSValue *)left
{
	return nil;
}

- (SamuraiCSSValue *)right
{
	return nil;
}

- (SamuraiCSSValue *)bottom
{
	return nil;
}

@end

#pragma mark -

@implementation SamuraiCSSArray

@def_prop_strong( NSMutableArray *,		array );
@def_prop_dynamic( SamuraiCSSValue *,	top );
@def_prop_dynamic( SamuraiCSSValue *,	left );
@def_prop_dynamic( SamuraiCSSValue *,	right );
@def_prop_dynamic( SamuraiCSSValue *,	bottom );

+ (instancetype)parseArray:(KatanaArray *)array
{
	if ( NULL == array || 0 == array->length )
		return nil;
	
	SamuraiCSSArray * result = nil;
	
	for ( size_t i = 0; i < array->length; ++i )
	{
		SamuraiCSSValue * elem = [SamuraiCSSValue parseValue:array->data[i]];
		
		if ( nil == elem )
			continue;
		
		if ( nil == result )
		{
			result = [[SamuraiCSSArray alloc] init];
		}
		
		[result.array addObject:elem];
	}
	
	return result;
}

+ (instancetype)parseString:(NSString *)string
{
	if ( nil == string || 0 == [string length] )
		return nil;
	
	SamuraiCSSArray * result = [[SamuraiCSSObjectCache sharedInstance].cache objectForKey:string];

	if ( nil == result )
	{
		KatanaOutput * output = [[SamuraiCSSParser sharedInstance] parseValue:string];
		if ( output )
		{
			result = [self parseArray:output->values];
			katana_destroy_output( output );
		}
		
		if ( result )
		{
			[[SamuraiCSSObjectCache sharedInstance].cache setObject:result forKey:string];
		}
	}

	return result;
}

#pragma mark -

+ (instancetype)array:(NSArray *)array
{
	if ( nil == array || 0 == [array count] )
		return nil;
	
	SamuraiCSSArray * result = [[SamuraiCSSArray alloc] init];
	[result.array setArray:array];
	return result;
}

#pragma mark -

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.array = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[self.array removeAllObjects];
	self.array = nil;
}

#pragma mark -

- (NSString *)description
{
	return [NSString stringWithFormat:@"Array( %@ )", [self.array join:@" "]];
}

- (BOOL)isInherit
{
	if ( 1 == [self.array count] )
	{
		return [[self.array objectAtIndex:0] isInherit];
	}
	else
	{
		return NO;
	}
}

- (BOOL)isArray
{
	return YES;
}

- (NSUInteger)count
{
	return [self.array count];
}

- (id)objectAtIndex:(NSUInteger)index
{
	return [self.array safeObjectAtIndex:index];
}

- (void)addObject:(id)anObject
{
	[self.array addObject:anObject];
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index
{
	[self.array insertObject:anObject atIndex:index];
}

- (void)removeLastObject
{
	[self.array removeLastObject];
}

- (void)removeObjectAtIndex:(NSUInteger)index
{
	[self.array removeObjectAtIndex:index];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
	[self.array replaceObjectAtIndex:index withObject:anObject];
}

#pragma mark -

- (SamuraiCSSValue *)top
{
	if ( 1 == self.array.count )
	{
		return [self.array objectAtIndex:0];
	}
	else if ( 2 == self.array.count )
	{
		return [self.array objectAtIndex:0];
	}
	else if ( 3 == self.array.count )
	{
		return [self.array objectAtIndex:0];
	}
	else if ( self.array.count >= 4 )
	{
		return [self.array objectAtIndex:0];
	}
	
	return nil;
}

- (SamuraiCSSValue *)right
{
	if ( 1 == self.array.count )
	{
		return [self.array objectAtIndex:0];
	}
	else if ( 2 == self.array.count )
	{
		return [self.array objectAtIndex:1];
	}
	else if ( 3 == self.array.count )
	{
		return [self.array objectAtIndex:1];
	}
	else if ( self.array.count >= 4 )
	{
		return [self.array objectAtIndex:1];
	}
	
	return nil;
}

- (SamuraiCSSValue *)bottom
{
	if ( 1 == self.array.count )
	{
		return [self.array objectAtIndex:0];
	}
	else if ( 2 == self.array.count )
	{
		return [self.array objectAtIndex:0];
	}
	else if ( 3 == self.array.count )
	{
		return [self.array objectAtIndex:2];
	}
	else if ( self.array.count >= 4 )
	{
		return [self.array objectAtIndex:2];
	}
	
	return nil;
}

- (SamuraiCSSValue *)left
{
	if ( 1 == self.array.count )
	{
		return [self.array objectAtIndex:0];
	}
	else if ( 2 == self.array.count )
	{
		return [self.array objectAtIndex:1];
	}
	else if ( 3 == self.array.count )
	{
		return [self.array objectAtIndex:1];
	}
	else if ( self.array.count >= 4 )
	{
		return [self.array objectAtIndex:3];
	}
	
	return nil;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, CSSArray )

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
