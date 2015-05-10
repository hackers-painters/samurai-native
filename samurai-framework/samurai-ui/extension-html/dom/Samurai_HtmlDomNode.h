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

#import "Samurai_UIConfig.h"
#import "Samurai_ViewCore.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_CSSProtocol.h"

#pragma mark -

@interface SamuraiHtmlDomNode : SamuraiDomNode<SamuraiCSSProtocol>

@prop_assign( BOOL,	implied );

@prop_unsafe( SamuraiHtmlDomNode *,			parent );
@prop_unsafe( SamuraiHtmlDomNode *,			prev );
@prop_unsafe( SamuraiHtmlDomNode *,			next );

@prop_unsafe( SamuraiHtmlDomNode *,			shadowHost );
@prop_strong( SamuraiHtmlDomNode *,			shadowRoot );

- (SamuraiHtmlDomNode *)getFirstElementById:(NSString *)domId;
- (SamuraiHtmlDomNode *)getFirstElementByName:(NSString *)domName;
- (SamuraiHtmlDomNode *)getFirstElementByTagName:(NSString *)domTag;

@end

#pragma mark -

#if __SAMURAI_DEBUG__

#undef	DEBUG_HTML_DOM
#define DEBUG_HTML_DOM( __x ) \
		if ( [__x.domAttributes hasObjectForKey:@"debug"] || [__x.domAttributes hasObjectForKey:@"debug-dom"] ) \
		{ \
			INFO( @"Debug dom at >>" ); \
			[__x dump]; \
			TRAP(); \
		}

#undef	DEBUG_HTML_CSS
#define DEBUG_HTML_CSS( __x ) \
		if ( [__x.domAttributes hasObjectForKey:@"debug"] || [__x.domAttributes hasObjectForKey:@"debug-css"] ) \
		{ \
			INFO( @"Debug style at >>" ); \
			[__x dump]; \
			TRAP(); \
		} \

#else	// #if __SAMURAI_DEBUG__

#undef	DEBUG_HTML_DOM
#define DEBUG_HTML_DOM( __x )

#undef	DEBUG_HTML_CSS
#define DEBUG_HTML_CSS( __x )

#endif	// #if __SAMURAI_DEBUG__

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
