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

#import "Samurai_HtmlNumberQem.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_HtmlUserAgent.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiHtmlStyleObject(NumberQem)

- (BOOL)isQem
{
	return NO;
}

@end

#pragma mark -

@implementation SamuraiHtmlNumberQem

+ (instancetype)object:(id)any
{
	if ( [any isKindOfClass:[NSString class]] )
	{
		NSString * str = any;
		
		if ( 0 == str.length )
			return nil;

		NSString * unit = @"__qem";
		
		BOOL matched = [str isNumberWithUnit:unit];
		if ( matched )
		{
			SamuraiHtmlNumberQem * value = [[self alloc] init];
			
			value.value = [[str substringToIndex:(str.length - unit.length)] floatValue];
			value.unit = [str substringFromIndex:(str.length - unit.length)];
			
			return value;
		}
	}
	else if ( [any isKindOfClass:[NSNumber class]] )
	{
		NSNumber * num = any;
		
		SamuraiHtmlNumberQem * value = [[self alloc] init];
		
		value.value = [num floatValue];
		value.unit = @"__qem";
		
		return value;
	}

	return nil; // [super object:any];
}

+ (instancetype)number:(CGFloat)value
{
	SamuraiHtmlNumberQem * number = [[self alloc] init];
	number.value = value;
	return number;
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.value = 0.0f;
		self.unit = @"__qem";
	}
	return self;
}

- (void)dealloc
{
}

- (NSString *)description
{
	return [super description];
}

- (BOOL)isQem
{
	return YES;
}

- (BOOL)isAbsolute
{
	return YES;
}

- (CGFloat)computeValue:(CGFloat)value
{
	CGFloat lineHeight = [SamuraiHtmlUserAgent sharedInstance].defaultFont.lineHeight;

	return self.value * lineHeight;	// qem to px
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlNumberQem )

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
