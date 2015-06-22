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

#import "Samurai_HtmlMediaQuery.h"
#import "Samurai_HtmlStyle.h"
#import "Samurai_CSSParser.h"
#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiHtmlMediaQuery

@def_singleton( SamuraiHtmlMediaQuery )

- (BOOL)test:(NSString *)condition
{
	if ( nil == condition )
		return YES;
	
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
        return YES;
    
    BOOL passed = YES;
        
    for ( int i=0; i<medias->length; i++ )
    {
        KatanaMediaQuery * mediaQuery = medias->data[i];

        if ( NULL == mediaQuery->expressions )
            return YES;
        
        for ( int i = 0; i < mediaQuery->expressions->length; i++ )
        {
            BOOL matches = [self testMediaQueryExpression:mediaQuery->expressions->data[i]];
            
            switch ( mediaQuery->restrictor )
            {
                case KatanaMediaQueryRestrictorNot:
                    passed = passed && !matches;
                    break;

                default:
                    passed = passed && matches;
                    break;
            }
            
            if ( !passed )
                return NO;
        }
    }

    return YES;
}

- (BOOL)testMediaQueryExpression:(KatanaMediaQueryExp *)mediaQueryExp
{
    NSString * feature = [NSString stringWithUTF8String:mediaQueryExp->feature];

    KatanaValue * value = *mediaQueryExp->values->data;
    
    if ( [feature isEqualToString:@"device-width"] )
    {
        return [[UIScreen mainScreen] bounds].size.width == value->fValue;
    }
    else if ( [feature isEqualToString:@"min-device-width"] )
    {
        return [[UIScreen mainScreen] bounds].size.width >= value->fValue;
    }
    else if ( [feature isEqualToString:@"max-device-width"] )
    {
        return [[UIScreen mainScreen] bounds].size.width <= value->fValue;
    }
    else if ( [feature isEqualToString:@"device-height"] )
    {
        return [[UIScreen mainScreen] bounds].size.height == value->fValue;
    }
    else if ( [feature isEqualToString:@"min-device-height"] )
    {
        return [[UIScreen mainScreen] bounds].size.height >= value->fValue;
    }
    else if ( [feature isEqualToString:@"max-device-height"] )
    {
        return [[UIScreen mainScreen] bounds].size.height <= value->fValue;
    }
    else if ( [feature isEqualToString:@"scale"] )
    {
        return [[UIScreen mainScreen] scale] == value->fValue;
    }
    else if ( [feature isEqualToString:@"min-scale"] )
    {
        return [[UIScreen mainScreen] scale] >= value->fValue;
    }
    else if ( [feature isEqualToString:@"max-scale"] )
    {
        return [[UIScreen mainScreen] scale] <= value->fValue;
    }
    else if ( [feature isEqualToString:@"orientation"] )
    {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        NSString *userValue = [NSString stringWithUTF8String:value->string];
        switch (orientation) {
            case UIInterfaceOrientationLandscapeLeft:
            case UIInterfaceOrientationLandscapeRight:
                return [userValue isEqualToString:@"landscape"];
                
            case UIInterfaceOrientationPortrait:
            case UIDeviceOrientationPortraitUpsideDown:
                return [userValue isEqualToString:@"portrait"];
                
            default:
                return NO;
        }
    }
    // else if ( [feature isEqualToString:@"device"] )
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

TEST_CASE( WebCore, HtmlMediaQuery )

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
