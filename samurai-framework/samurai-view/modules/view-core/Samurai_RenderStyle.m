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

#import "Samurai_RenderStyle.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiRenderStyle

@def_prop_strong( NSMutableDictionary *, properties );

BASE_CLASS( SamuraiRenderStyle )

+ (instancetype)renderStyle
{
	return [[self alloc] init];
}

+ (instancetype)renderStyle:(NSDictionary *)props
{
	SamuraiRenderStyle * style = [[self alloc] init];

	[style mergeProperties:props];

	return style;
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.properties = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[self.properties removeAllObjects];
	self.properties = nil;
}

- (void)deepCopyFrom:(SamuraiRenderStyle *)right
{
//	[super deepCopyFrom:right];
	
	[self.properties addEntriesFromDictionary:right.properties];
}

#pragma mark -

- (id)objectForKey:(id)key
{
	return [self.properties objectForKey:key];
}

- (BOOL)hasObjectForKey:(id)key
{
	return [self.properties hasObjectForKey:key];
}

- (id)objectForKeyedSubscript:(id)key
{
	return [self objectForKey:key];
}

#pragma mark -

- (void)setObject:(id)object forKey:(id)key
{
	[self.properties setObject:object forKey:key];
}

- (void)removeObjectForKey:(id)key
{
	[self.properties removeObjectForKey:key];
}

- (void)removeAllObjects
{
	[self.properties removeAllObjects];
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key
{
	[self setObject:obj forKey:key];
}

#pragma mark -

- (void)clearProperties
{
	[self removeAllObjects];
}

- (void)mergeProperties:(NSDictionary *)properties
{
	for ( NSString * key in [properties.allKeys copy] )
	{
		[self setObject:[properties objectForKey:key] forKey:key];
	}	
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, RenderStyle )

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
