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

// object

#undef	html_dom_object
#define	html_dom_object( type, name ) \
		property (nonatomic, readonly) type * name

#undef	def_html_dom_object
#define	def_html_dom_object( type, getter, setter, key ) \
		dynamic getter; \
		- (type *)getter { return [self.attributes objectForKey:key]; } \
		- (void)setter:(type *)obj { [self.attributes setObject:obj forKey:key]; }

// string

#undef	html_dom_string
#define	html_dom_string( name ) \
		html_dom_object( NSString, name )

#undef	def_html_dom_string
#define	def_html_dom_string( getter, setter, key ) \
		def_html_dom_object( NSString, getter, setter, key )

#pragma mark -

@interface SamuraiHtmlDomNode : SamuraiDomNode<SamuraiCSSProtocol>

@html_dom_string( align );
@html_dom_string( width );
@html_dom_string( height );
@html_dom_string( cellSpacing );
@html_dom_string( cellPadding );
@html_dom_string( colSpan );
@html_dom_string( rowSpan );
@html_dom_string( selected );

@html_dom_string( value );
@html_dom_string( min );
@html_dom_string( max );

@prop_assign( BOOL,	implied );

@prop_unsafe( SamuraiHtmlDomNode *,			parent );
@prop_unsafe( SamuraiHtmlDomNode *,			prev );
@prop_unsafe( SamuraiHtmlDomNode *,			next );

@prop_unsafe( SamuraiHtmlDomNode *,			shadowHost );
@prop_strong( SamuraiHtmlDomNode *,			shadowRoot );

@end

#pragma mark -

#if __SAMURAI_DEBUG__

#undef	DEBUG_HTML_DOM
#define DEBUG_HTML_DOM( __x ) \
		if ( [__x.attributes hasObjectForKey:@"debug"] || [__x.attributes hasObjectForKey:@"debug-dom"] ) \
		{ \
			PRINT( @">>>> Debug dom at >>" ); \
			[__x dump]; \
			TRAP(); \
		}

#undef	DEBUG_HTML_CSS
#define DEBUG_HTML_CSS( __x ) \
		if ( [__x.attributes hasObjectForKey:@"debug"] || [__x.attributes hasObjectForKey:@"debug-css"] ) \
		{ \
			PRINT( @">>>> Debug style at >>" ); \
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
