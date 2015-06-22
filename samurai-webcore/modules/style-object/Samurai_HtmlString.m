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

#import "Samurai_HtmlString.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiHtmlStyleObject(String)

- (BOOL)isString
{
	return NO;
}

- (BOOL)isString:(NSString *)other
{
	return NO;
}

- (BOOL)inStrings:(NSArray *)set
{
	return NO;
}

- (NSString *)stringValue
{
	return nil;
}

@end

#pragma mark -

@implementation SamuraiHtmlString

@def_prop_strong( NSString *,	value );

+ (instancetype)object:(id)any
{
	if ( [any isKindOfClass:[NSString class]] )
	{
		NSString * str = any;
		
		if ( 0 == str.length )
			return nil;

		SamuraiHtmlString * value = [[self alloc] init];
		value.value = str;
		return value;
	}

	return nil; // [super object:any];
}

+ (instancetype)string:(NSString *)string
{
	return [self object:string];
}

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
	self.value = nil;
}

- (NSString *)description
{
	return self.value;
}

- (BOOL)isString
{
	return YES;
}

- (BOOL)isString:(NSString *)other
{
	if ( NSOrderedSame == [self.value compare:other options:NSCaseInsensitiveSearch] )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)inStrings:(NSArray *)set
{
	for ( NSString * other in set )
	{
		if ( NSOrderedSame == [self.value compare:other options:NSCaseInsensitiveSearch] )
		{
			return YES;
		}
	}
	
	return NO;
}

- (NSString *)stringValue
{
	return self.value;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlString )

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
