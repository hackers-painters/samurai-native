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

#import "Samurai_HtmlNumber.h"
#import "Samurai_HtmlNumberAutomatic.h"
#import "Samurai_HtmlNumberCm.h"
#import "Samurai_HtmlNumberEm.h"
#import "Samurai_HtmlNumberQem.h"
#import "Samurai_HtmlNumberEx.h"
#import "Samurai_HtmlNumberIn.h"
#import "Samurai_HtmlNumberMm.h"
#import "Samurai_HtmlNumberPc.h"
#import "Samurai_HtmlNumberPercentage.h"
#import "Samurai_HtmlNumberPt.h"
#import "Samurai_HtmlNumberPx.h"
#import "Samurai_HtmlNumberConstant.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiHtmlStyleObject(Function)

- (BOOL)isNumber
{
	return NO;
}

- (BOOL)isNumber:(CGFloat)value
{
	return NO;
}

- (BOOL)isAbsolute
{
	return NO;
}

- (CGFloat)computeValue
{
	return [self computeValue:INVALID_VALUE];
}

- (CGFloat)computeValue:(CGFloat)value
{
	return INVALID_VALUE;
}

@end

#pragma mark -

@implementation SamuraiHtmlNumber

@def_prop_assign( CGFloat,		value );
@def_prop_strong( NSString *,	unit );

+ (instancetype)object:(id)any
{
	if ( [any isKindOfClass:[NSString class]] )
	{
		NSString * str = any;
		
		if ( 0 == str.length )
			return nil;
		
		if ( [str hasPrefix:@"'"] || [str hasPrefix:@"\""] )
			return nil;

		static dispatch_once_t	once;
		static NSMutableArray * valueClasses;
		
		dispatch_once( &once, ^
		{
			valueClasses = [[NSMutableArray alloc] init];

			[valueClasses addObject:[SamuraiHtmlNumberAutomatic class]];
			[valueClasses addObject:[SamuraiHtmlNumberPercentage class]];
			[valueClasses addObject:[SamuraiHtmlNumberPx class]];
			[valueClasses addObject:[SamuraiHtmlNumberCm class]];
			[valueClasses addObject:[SamuraiHtmlNumberEm class]];
			[valueClasses addObject:[SamuraiHtmlNumberEx class]];
			[valueClasses addObject:[SamuraiHtmlNumberIn class]];
			[valueClasses addObject:[SamuraiHtmlNumberMm class]];
			[valueClasses addObject:[SamuraiHtmlNumberPc class]];
			[valueClasses addObject:[SamuraiHtmlNumberPt class]];
			[valueClasses addObject:[SamuraiHtmlNumberQem class]];
			[valueClasses addObject:[SamuraiHtmlNumberConstant class]]; // default type
		});
		
		for ( Class valueClass in valueClasses )
		{
			SamuraiHtmlNumber * value = [valueClass object:str];

			if ( value )
			{
				return value;
			}
		}
	}
	else if ( [any isKindOfClass:[NSNumber class]] )
	{
		NSNumber * rawNumber = any;
		
		if ( INVALID_VALUE == rawNumber.floatValue )
		{
			return [SamuraiHtmlNumberAutomatic object];
		}
		else
		{
			return [SamuraiHtmlNumberConstant number:[rawNumber floatValue]];
		}
	}

	return nil; // [super object:any];
}

+ (instancetype)number:(CGFloat)value
{
	return [SamuraiHtmlNumberConstant number:value];
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
	self.unit = nil;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%.1f%@", self.value, self.unit];
}

- (BOOL)isNumber
{
	return YES;
}

- (BOOL)isNumber:(CGFloat)value
{
	return self.value == value ? YES : NO;
}

- (CGFloat)computeValue
{
	return [self computeValue:INVALID_VALUE];
}

- (CGFloat)computeValue:(CGFloat)value
{
	return INVALID_VALUE;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlNumber )

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
