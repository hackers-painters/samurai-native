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

#import "Samurai_CSSNumberCm.h"
#import "Samurai_CSSParser.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_HtmlUserAgent.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiCSSObject(NumberCm)

- (BOOL)isCm
{
	return NO;
}

@end

#pragma mark -

@implementation SamuraiCSSNumberCm

+ (instancetype)parseValue:(KatanaValue *)value
{
	if ( NULL == value )
		return nil;
	
	SamuraiCSSNumberCm * result = nil;
	
	if ( KATANA_VALUE_CM == value->unit )
	{
		result = [[SamuraiCSSNumberCm alloc] init];
		result.value = value->fValue;
	}
	
	return result;
}

#pragma mark -

+ (instancetype)cm:(CGFloat)value
{
	SamuraiCSSNumberCm * result = [[SamuraiCSSNumberCm alloc] init];
	result.value = value;
	return result;
}

#pragma mark -

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.value = 0.0f;
		self.unit = @"cm";
	}
	return self;
}

- (void)dealloc
{
}

#pragma mark -

- (NSString *)description
{
	return [NSString stringWithFormat:@"Cm( %.2f )", self.value];
}

- (BOOL)isCm
{
	return YES;
}

- (BOOL)isAbsolute
{
	return YES;
}

- (CGFloat)computeValue:(CGFloat)value
{
	// 8.56cm = 85.6mm = 3.37in

	return self.value * (16.0f * 6.0f * (3.37f / 8.56f));	// in to px
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, CSSNumberCm )

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
