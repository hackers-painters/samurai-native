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

#import "Samurai_CSSFunction.h"
#import "Samurai_CSSParser.h"
#import "Samurai_CSSValue.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiCSSObject(Function)

- (BOOL)isFunction
{
	return NO;
}

- (BOOL)isFunction:(NSString *)function
{
	return NO;
}

- (NSString *)method
{
	return nil;
}

- (NSArray *)params;
{
	return nil;
}

@end

#pragma mark -

@implementation SamuraiCSSFunction

@def_prop_strong( NSString *,		method )
@def_prop_strong( NSMutableArray *,	params )

+ (instancetype)parseValue:(KatanaValue *)value
{
	if ( NULL == value )
		return nil;
	
	SamuraiCSSFunction * result = nil;
	
	if ( KATANA_VALUE_PARSER_FUNCTION == value->unit )
	{
		if ( NULL == value->function || NULL == value->function->name )
			return nil;

		result = [[SamuraiCSSFunction alloc] init];

		result.method = [NSString stringWithUTF8String:value->function->name];
			
		for ( size_t i = 0; i < value->function->args->length; ++i )
		{
			SamuraiCSSValue * param = [SamuraiCSSValue parseValue:value->function->args->data[0]];

			if ( param )
			{
				[result.params addObject:param];
			}
		}
	}
	
	return result;
}

#pragma mark -

+ (instancetype)function:(NSString *)method
{
	if ( nil == method )
		return nil;
	
	SamuraiCSSFunction * function = [[SamuraiCSSFunction alloc] init];
	function.method = method;
	return function;
}

+ (instancetype)function:(NSString *)method params:(NSArray *)params
{
	if ( nil == method )
		return nil;
	
	SamuraiCSSFunction * function = [[SamuraiCSSFunction alloc] init];
	function.method = method;
	return function;
}

#pragma mark -

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.params = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc
{
	self.method = nil;
	self.params = nil;
}

#pragma mark -

- (NSString *)description
{
	return [NSString stringWithFormat:@"Function( %@, %@ )", self.method, [self.params join:@", "]];
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

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, CSSFunction )

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
