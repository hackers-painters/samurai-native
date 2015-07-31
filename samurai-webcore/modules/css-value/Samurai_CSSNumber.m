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

#import "Samurai_CSSNumber.h"
#import "Samurai_CSSParser.h"

#import "Samurai_CSSNumberAutomatic.h"
#import "Samurai_CSSNumberChs.h"
#import "Samurai_CSSNumberCm.h"
#import "Samurai_CSSNumberDeg.h"
#import "Samurai_CSSNumberDpcm.h"
#import "Samurai_CSSNumberDpi.h"
#import "Samurai_CSSNumberDppx.h"
#import "Samurai_CSSNumberEm.h"
#import "Samurai_CSSNumberQem.h"
#import "Samurai_CSSNumberEx.h"
#import "Samurai_CSSNumberFr.h"
#import "Samurai_CSSNumberGRad.h"
#import "Samurai_CSSNumberHz.h"
#import "Samurai_CSSNumberIn.h"
#import "Samurai_CSSNumberKhz.h"
#import "Samurai_CSSNumberMm.h"
#import "Samurai_CSSNumberMs.h"
#import "Samurai_CSSNumberPc.h"
#import "Samurai_CSSNumberPercentage.h"
#import "Samurai_CSSNumberPt.h"
#import "Samurai_CSSNumberPx.h"
#import "Samurai_CSSNumberQem.h"
#import "Samurai_CSSNumberRad.h"
#import "Samurai_CSSNumberRems.h"
#import "Samurai_CSSNumberS.h"
#import "Samurai_CSSNumberTurn.h"
#import "Samurai_CSSNumberVh.h"
#import "Samurai_CSSNumberVmax.h"
#import "Samurai_CSSNumberVmin.h"
#import "Samurai_CSSNumberVw.h"
#import "Samurai_CSSNumberConstant.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiCSSObject(Function)

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

- (CGFloat)value
{
	return 0.0f;
}

- (CGFloat)computeValue:(CGFloat)value
{
	return INVALID_VALUE;
}

@end

#pragma mark -

@implementation SamuraiCSSNumber

@def_prop_assign( CGFloat,		value );
@def_prop_strong( NSString *,	unit );

+ (instancetype)parseValue:(KatanaValue *)value
{
	if ( NULL == value )
		return nil;
	
	static dispatch_once_t	once;
	static NSArray *		classes;
	
	dispatch_once( &once, ^
	{
		classes = [NSArray arrayWithObjects:
					[SamuraiCSSNumberAutomatic class],
					[SamuraiCSSNumberPercentage class],
					[SamuraiCSSNumberPx class],
				    [SamuraiCSSNumberChs class],
					[SamuraiCSSNumberCm class],
				    [SamuraiCSSNumberDeg class],
				    [SamuraiCSSNumberDpcm class],
				    [SamuraiCSSNumberDpi class],
				    [SamuraiCSSNumberDppx class],
					[SamuraiCSSNumberEm class],
					[SamuraiCSSNumberEx class],
				    [SamuraiCSSNumberFr class],
				    [SamuraiCSSNumberGRad class],
				    [SamuraiCSSNumberHz class],
					[SamuraiCSSNumberIn class],
				    [SamuraiCSSNumberKhz class],
					[SamuraiCSSNumberMm class],
				    [SamuraiCSSNumberMs class],
					[SamuraiCSSNumberPc class],
					[SamuraiCSSNumberPt class],
				    [SamuraiCSSNumberRad class],
				    [SamuraiCSSNumberRems class],
				    [SamuraiCSSNumberS class],
				    [SamuraiCSSNumberTurn class],
				    [SamuraiCSSNumberVh class],
				    [SamuraiCSSNumberVmax class],
				    [SamuraiCSSNumberVmin class],
				    [SamuraiCSSNumberVw class],
					[SamuraiCSSNumberQem class],
					[SamuraiCSSNumberConstant class],
					nil];
	});
	
	SamuraiCSSNumber * result = nil;

	for ( Class valueClass in classes )
	{
		result = [valueClass parseValue:value];
		
		if ( result )
			break;
	}

	return result;
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
	self.unit = nil;
}

#pragma mark -

- (NSString *)description
{
	return [NSString stringWithFormat:@"Number( %.2f%@ )", self.value, self.unit];
}

- (BOOL)isNumber
{
	return YES;
}

- (BOOL)isNumber:(CGFloat)value
{
	return self.value == value ? YES : NO;
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

TEST_CASE( WebCore, CSSNumber )

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
