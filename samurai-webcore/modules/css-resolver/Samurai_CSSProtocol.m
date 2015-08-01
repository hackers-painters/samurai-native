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

#import "Samurai_CSSProtocol.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

NSString * NSStringFromSamuraiCSSProtocolElement(id<SamuraiCSSProtocol> element)
{
    NSMutableString * desc = [NSMutableString string];
    
    if ( element.cssTag ) {
        [desc appendFormat:@"<%@", element.cssTag];
    }
    
//    if ( element.cssId ) {
//        [desc appendFormat:@" id=\"%@\"", element.cssId];
//    }
    
//    if ( element.cssClasses.count ) {
//        [desc appendString:@" class=\""];
//        [element.cssClasses enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
//            [desc appendFormat:@"%@", obj];
//            if ( idx != element.cssClasses.count - 1 ) {
//                [desc appendString:@" "];
//            }
//        }];
//        [desc appendString:@"\""];
//    }
//    
    if ( element.cssAttributes && element.cssAttributes.count ) {
        [element.cssAttributes enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString * obj, BOOL *stop) {
            if ( key && obj && obj.length ) {
                [desc appendFormat:@" %@=\"%@\"", key, obj];
            } else if ( key ) {
                [desc appendFormat:@" %@",key];
            }
        }];
    }
    
    if ( element.cssTag ) {
        [desc appendString:@">"];
    }
    
    if ( desc.length == 0 ) {
        
    }
    
    return desc;
}

#pragma mark -

@implementation SamuraiCSSCondition

@def_prop_strong( NSString *,		cssId );
@def_prop_strong( NSString *,		cssTag );
@def_prop_strong( NSString *,		cssPseudos );
@def_prop_strong( NSString *,		cssShadowPseudoId );
@def_prop_strong( NSArray *,		cssClasses );
@def_prop_strong( NSDictionary *,	cssAttributes );

- (id<SamuraiCSSProtocol>)cssParent
{
	return nil;
}

- (id<SamuraiCSSProtocol>)cssPreviousSibling
{
	return nil;
}

- (id<SamuraiCSSProtocol>)cssFollowingSibling
{
	return nil;
}

- (id<SamuraiCSSProtocol>)cssSiblingAtIndex:(NSInteger)index
{
	return nil;
}

- (NSArray *)cssChildren
{
	return nil;
}

- (NSArray *)cssPreviousSiblings
{
	return nil;
}

- (NSArray *)cssFollowingSiblings
{
	return nil;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, CSSProtocol )

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
