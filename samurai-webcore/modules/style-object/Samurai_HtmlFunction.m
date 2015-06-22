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

#import "Samurai_HtmlFunction.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiHtmlStyleObject(Function)

- (BOOL)isFunction
{
	return NO;
}

- (BOOL)isFunction:(NSString *)function
{
	return NO;
}

- (NSArray *)params
{
	return nil;
}

@end

#pragma mark -

@implementation SamuraiHtmlFunction

@def_prop_strong( NSString *,	method )
@def_prop_strong( NSString *,	param )

+ (instancetype)object:(id)any
{
	if ( [any isKindOfClass:[NSString class]] )
	{
		NSString * str = any;
		
		if ( 0 == str.length )
			return nil;

		NSString * prefix = @"(";
		NSString * suffix = @")";
		
		if ( [str hasSuffix:suffix] )
		{
			NSRange range = [str rangeOfString:prefix];

			if ( NSNotFound != range.location )
			{
				SamuraiHtmlFunction * value = [[self alloc] init];

				value.method = [[str substringToIndex:range.location] trim];
				value.param = [[str substringWithRange:NSMakeRange(range.location + range.length, str.length - (range.location + range.length) - suffix.length)] trim];

				return value;
			}
		}
	}
//	else if ( is block )
//	{
//		
//	}
//	else if ( is NSInvocation )
//	{
//
//	}

	return nil; // [super object:any];
}

+ (instancetype)function:(NSString *)string
{
	return [self object:string];
}

+ (instancetype)method:(NSString *)method
{
	SamuraiHtmlFunction * value = [[self alloc] init];
	
	value.method = method;
	value.param = nil;
	
	return value;
}

+ (instancetype)method:(NSString *)method param:(NSString *)param
{
	SamuraiHtmlFunction * value = [[self alloc] init];
	
	value.method = method;
	value.param = param;

	return value;
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
	self.method = nil;
	self.param = nil;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@()", self.method];
}

- (BOOL)isFunction
{
	return YES;
}

- (BOOL)isFunction:(NSString *)function
{
	if ( [self.method isEqualToString:function] )
	{
		return YES;
	}
	
	return NO;
}

- (NSArray *)params
{
	return [self.param componentsSeparatedByString:@","];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlFunction )

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
