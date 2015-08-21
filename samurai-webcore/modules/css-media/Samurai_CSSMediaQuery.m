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

#import "Samurai_CSSMediaQuery.h"
#import "Samurai_CSSParser.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiCSSMediaQuery

@def_singleton( SamuraiCSSMediaQuery )

- (BOOL)test:(NSString *)condition
{
	if ( nil == condition )
	{
		return YES;
	}

    KatanaOutput * output = [[SamuraiCSSParser sharedInstance] parseMedia:condition];
    
    if ( NULL != output )
    {
        BOOL passed = [self testMediaQueries:output->medias];
		
        katana_destroy_output(output);
		
        return passed;
    }
    
    return NO;
}

- (BOOL)testMediaQueries:(KatanaArray *)medias
{
    if ( medias == NULL )
	{
        return YES;
	}
	
    BOOL passed = YES;
        
    for ( int i = 0; i < medias->length; i++ )
    {
        KatanaMediaQuery * mediaQuery = medias->data[i];

        if ( NULL == mediaQuery->expressions || 0 == mediaQuery->expressions->length )
		{
			if ( mediaQuery->type )
			{
				BOOL matches = [self testMediaQueryType:mediaQuery->type];
				
				if ( KatanaMediaQueryRestrictorNot == mediaQuery->restrictor )
				{
					passed = passed && !matches;
				}
				else
				{
					passed = passed && matches;
				}
				
				if ( NO == passed )
				{
					return NO;
				}
			}
			else
			{
				return YES;
			}
		}
		else
		{
			for ( int i = 0; i < mediaQuery->expressions->length; i++ )
			{
				BOOL matches = [self testMediaQueryExpression:mediaQuery->expressions->data[i]];
				
				if ( KatanaMediaQueryRestrictorNot == mediaQuery->restrictor )
				{
					passed = passed && !matches;
				}
				else
				{
					passed = passed && matches;
				}
				
				if ( NO == passed )
				{
					return NO;
				}
			}
		}
    }

    return YES;
}

- (BOOL)testMediaQueryType:(const char *)mediaQueryType
{
	if ( NULL == mediaQueryType )
		return YES;
	
	if ( 0 == strcasecmp( mediaQueryType, "all" ) )
	{
		return YES;
	}
	else if ( 0 == strcasecmp( mediaQueryType, "aural" ) )
	{
		return NO;
	}
	else if ( 0 == strcasecmp( mediaQueryType, "braille" ) )
	{
		return NO;
	}
	else if ( 0 == strcasecmp( mediaQueryType, "handheld" ) )
	{
		return YES;
	}
	else if ( 0 == strcasecmp( mediaQueryType, "print" ) )
	{
		return NO;
	}
	else if ( 0 == strcasecmp( mediaQueryType, "projection" ) )
	{
		return NO;
	}
	else if ( 0 == strcasecmp( mediaQueryType, "screen" ) )
	{
		return YES;
	}
	else if ( 0 == strcasecmp( mediaQueryType, "tty" ) )
	{
		return NO;
	}
	else if ( 0 == strcasecmp( mediaQueryType, "tv" ) )
	{
		return NO;
	}
	else if ( 0 == strcasecmp( mediaQueryType, "embossed" ) )
	{
		return NO;
	}
	else
	{
		return NO;
	}
}

- (BOOL)testMediaQueryExpression:(KatanaMediaQueryExp *)mediaQueryExp
{
	if ( NULL == mediaQueryExp )
		return YES;
	
	KatanaValue * value = mediaQueryExp->values->length ? mediaQueryExp->values->data[0] : NULL;
	
	if ( NULL == value )
		return NO;

	if ( 0 == strcasecmp( mediaQueryExp->feature, "device-width" ) )
    {
        return [[UIScreen mainScreen] bounds].size.width == value->fValue;
    }
    else if ( 0 == strcasecmp( mediaQueryExp->feature, "min-device-width" ) )
    {
        return [[UIScreen mainScreen] bounds].size.width >= value->fValue;
    }
    else if ( 0 == strcasecmp( mediaQueryExp->feature, "max-device-width" ) )
    {
        return [[UIScreen mainScreen] bounds].size.width <= value->fValue;
    }
    else if ( 0 == strcasecmp( mediaQueryExp->feature, "device-height" ) )
    {
        return [[UIScreen mainScreen] bounds].size.height == value->fValue;
    }
    else if ( 0 == strcasecmp( mediaQueryExp->feature, "min-device-height" ) )
    {
        return [[UIScreen mainScreen] bounds].size.height >= value->fValue;
    }
    else if ( 0 == strcasecmp( mediaQueryExp->feature, "max-device-height" ) )
    {
        return [[UIScreen mainScreen] bounds].size.height <= value->fValue;
    }
    else if ( 0 == strcasecmp( mediaQueryExp->feature, "scale" ) )
    {
        return [[UIScreen mainScreen] scale] == value->fValue;
    }
    else if ( 0 == strcasecmp( mediaQueryExp->feature, "min-scale" ) )
    {
        return [[UIScreen mainScreen] scale] >= value->fValue;
    }
    else if ( 0 == strcasecmp( mediaQueryExp->feature, "max-scale" ) )
    {
        return [[UIScreen mainScreen] scale] <= value->fValue;
    }
    else if ( 0 == strcasecmp( mediaQueryExp->feature, "orientation" ) )
    {
		if ( NULL == value->string )
			return NO;

		UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
		
		if ( UIInterfaceOrientationLandscapeLeft == orientation || UIInterfaceOrientationLandscapeRight == orientation )
		{
			return (0 == strcasecmp(value->string, "landscape")) ? YES : NO;
		}
		else if ( UIInterfaceOrientationPortrait == orientation || UIDeviceOrientationPortraitUpsideDown == orientation )
		{
			return (0 == strcasecmp(value->string, "portrait")) ? YES : NO;
		}
		else
		{
			return NO;
		}
    }
// else if ( 0 == strcasecmp( mediaQueryExp->feature, "device"] )
// {
//     return NO;
// }
    
    return NO;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, CSSMediaQuery )

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
