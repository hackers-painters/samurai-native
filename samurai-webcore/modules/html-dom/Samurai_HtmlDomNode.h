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

#import "Samurai.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_CSSProtocol.h"

#pragma mark -

#undef	dom_attr
#define	dom_attr( name ) \
		property (nonatomic, strong) NSString * name

#undef	def_dom_attr
#define	def_dom_attr( getter, setter, key ) \
		dynamic getter; \
		- (NSString *)getter { return [self objectForKey:key]; } \
		- (void)setter:(NSString *)value { [self setObject:value forKey:key]; }

#pragma mark -

@interface SamuraiHtmlDomNode : SamuraiDomNode<SamuraiCSSProtocol>

@prop_assign( BOOL,						implied );
@prop_strong( NSMutableDictionary *,	computedStyle );
@prop_unsafe( SamuraiHtmlDomNode *,		parent );
@prop_unsafe( SamuraiHtmlDomNode *,		prev );
@prop_unsafe( SamuraiHtmlDomNode *,		next );
@prop_unsafe( SamuraiHtmlDomNode *,		shadowHost );
@prop_strong( SamuraiHtmlDomNode *,		shadowRoot );

@dom_attr( attrId );
@dom_attr( attrFor );
@dom_attr( attrRel );
@dom_attr( attrSrc );
@dom_attr( attrName );
@dom_attr( attrType );
@dom_attr( attrHref );
@dom_attr( attrMedia );
@dom_attr( attrStyle );
@dom_attr( attrClass );
@dom_attr( attrContent );
@dom_attr( attrValue );
@dom_attr( attrMin );
@dom_attr( attrMax );
@dom_attr( attrSelected );
@dom_attr( attrRowSpan );
@dom_attr( attrColSpan );
@dom_attr( attrTabindex );
@dom_attr( attrIsLarge );
@dom_attr( attrIsAnimating );
@dom_attr( attrIsStatic );
@dom_attr( attrColumns );
@dom_attr( attrIsVertical );
@dom_attr( attrIsHorizontal );
@dom_attr( attrStickTop );
@dom_attr( attrStickBottom );
@dom_attr( attrFixedTop );
@dom_attr( attrFixedBottom );
@dom_attr( attrIsColumn );
@dom_attr( attrIsRow );
@dom_attr( attrLayout );
@dom_attr( attrPages );
@dom_attr( attrCurrent );
@dom_attr( attrIsBar );
@dom_attr( attrIsPaging );
@dom_attr( attrIsContinuous );
@dom_attr( attrStep );
@dom_attr( attrIsOn );
@dom_attr( attrIsOff );

@dom_attr( attrPlaceholder );
@dom_attr( attrAutoCapitalization );
@dom_attr( attrAutoCorrection );
@dom_attr( attrAutoClears );
@dom_attr( attrSpellChecking );
@dom_attr( attrKeyboardType );
@dom_attr( attrKeyboardAppearance );
@dom_attr( attrReturnKeyType );
@dom_attr( attrIsSecure );

@dom_attr( attrOnClick );
@dom_attr( attrOnSwipe );
@dom_attr( attrOnSwipeLeft );
@dom_attr( attrOnSwipeRight );
@dom_attr( attrOnSwipeUp );
@dom_attr( attrOnSwipeDown );
@dom_attr( attrOnPinch );
@dom_attr( attrOnPan );

- (NSString *)computeInnerText;
- (NSString *)computeOuterText;

- (NSArray *)getElementsById:(NSString *)domId;
- (NSArray *)getElementsByName:(NSString *)domName;
- (NSArray *)getElementsByTagName:(NSString *)domTag;

- (SamuraiHtmlDomNode *)getFirstElementById:(NSString *)domId;
- (SamuraiHtmlDomNode *)getFirstElementByName:(NSString *)domName;
- (SamuraiHtmlDomNode *)getFirstElementByTagName:(NSString *)domTag;

@end

#pragma mark -

#if __SAMURAI_DEBUG__

#undef	DEBUG_HTML_DOM
#define DEBUG_HTML_DOM( __x ) \
		if ( [__x.attr hasObjectForKey:@"debug"] || [__x.attr hasObjectForKey:@"debug-dom"] ) \
		{ \
			PRINT( @">>>> Debug dom at >>" ); \
			[__x dump]; \
			TRAP(); \
		}

#undef	DEBUG_HTML_STYLE
#define DEBUG_HTML_STYLE( __x ) \
		if ( [__x.attr hasObjectForKey:@"debug"] || [__x.attr hasObjectForKey:@"debug-style"] ) \
		{ \
			PRINT( @">>>> Debug style at >>" ); \
			[__x dump]; \
			TRAP(); \
		} \

#undef	DEBUG_HTML_RENDER
#define DEBUG_HTML_RENDER( __x ) \
		if ( [__x.attr hasObjectForKey:@"debug"] || [__x.attr hasObjectForKey:@"debug-render"] ) \
		{ \
			PRINT( @">>>> Debug render at >>" ); \
			[__x dump]; \
			TRAP(); \
		} \

#else	// #if __SAMURAI_DEBUG__

#undef	DEBUG_HTML_DOM
#define DEBUG_HTML_DOM( __x )

#undef	DEBUG_HTML_CSS
#define DEBUG_HTML_CSS( __x )

#undef	DEBUG_HTML_STYLE
#define DEBUG_HTML_STYLE( __x )

#undef	DEBUG_HTML_RENDER
#define DEBUG_HTML_RENDER( __x )

#endif	// #if __SAMURAI_DEBUG__

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
