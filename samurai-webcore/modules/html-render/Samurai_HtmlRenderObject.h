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

#import "Samurai_HtmlLayoutObject.h"
#import "Samurai_HtmlDomNode.h"
#import "Samurai_HtmlRenderStyle.h"

#pragma mark -

@class SamuraiHtmlRenderObject;

@interface NSObject(HtmlSupport)

@prop_readonly( SamuraiHtmlRenderObject *,	htmlRenderer );

- (void)html_applyDom:(SamuraiHtmlDomNode *)dom;			// override point
- (void)html_applyStyle:(SamuraiHtmlRenderStyle *)style;	// override point
- (void)html_applyFrame:(CGRect)newFrame;					// override point
- (void)html_forView:(UIView *)hostView;					// override point, for="id"

@end

#pragma mark -

@interface SamuraiHtmlRenderObject : SamuraiRenderObject<SamuraiCSSProtocol>

@prop_strong( NSMutableArray *,				customClasses );
@prop_strong( SamuraiHtmlRenderStyle *,		customStyle );

@prop_assign( CSSWrap,						wrap );
@prop_assign( CSSAlign,						align );
@prop_assign( CSSClear,						clear );
@prop_assign( CSSDisplay,					display );
@prop_assign( CSSFloating,					floating );
@prop_assign( CSSPosition,					position );
@prop_assign( CSSVerticalAlign,				verticalAlign );

@prop_assign( CSSBoxAlign,					boxAlign );
@prop_assign( CSSBoxOrient,					boxOrient );
@prop_assign( CSSBoxDirection,				boxDirection );
@prop_assign( CSSBoxLines,					boxLines );
@prop_assign( CSSBoxPack,					boxPack );

@prop_assign( CSSFlexWrap,					flexWrap );
@prop_assign( CSSFlexDirection,				flexDirection );

@prop_assign( CSSAlignSelf,					alignSelf );
@prop_assign( CSSAlignItems,				alignItems );
@prop_assign( CSSAlignContent,				alignContent );
@prop_assign( CSSJustifyContent,			justifyContent );

@prop_assign( CGFloat,						zIndex );
@prop_assign( CGFloat,						order );

@prop_assign( CGFloat,						flexGrow );
@prop_assign( CGFloat,						flexBasis );
@prop_assign( CGFloat,						flexShrink );

@prop_assign( NSInteger,					tableRow );
@prop_assign( NSInteger,					tableCol );
@prop_assign( NSInteger,					tableRowSpan );
@prop_assign( NSInteger,					tableColSpan );

@prop_unsafe( SamuraiHtmlDomNode *,			dom );		// overrided
@prop_strong( SamuraiHtmlRenderStyle *,		style );	// overrided
@prop_strong( SamuraiHtmlLayoutObject *,	layout );

@prop_readonly( SamuraiHtmlRenderObject *,	root );		// overrided
@prop_unsafe( SamuraiHtmlRenderObject *,	parent );	// overrided
@prop_unsafe( SamuraiHtmlRenderObject *,	prev );		// overrided
@prop_unsafe( SamuraiHtmlRenderObject *,	next );		// overrided

+ (Class)defaultLayoutClass;							// override point
+ (Class)defaultViewClass;								// override point

- (void)renderWillLoad;									// override point
- (void)renderDidLoad;									// override point
- (void)computeProperties;								// override point

- (SamuraiHtmlRenderObject *)queryById:(NSString *)domId;
- (SamuraiHtmlRenderObject *)queryByDom:(SamuraiDomNode *)domNode;
- (SamuraiHtmlRenderObject *)queryByName:(NSString *)name;

@end

#pragma mark -

#if __SAMURAI_DEBUG__

#undef	DEBUG_RENDERER_DOM
#define DEBUG_RENDERER_DOM( __x ) \
		if ( [__x.dom.attr hasObjectForKey:@"debug"] || [__x.dom.attr hasObjectForKey:@"debug-dom"] ) \
		{ \
			PRINT( @">>>> Debug layout at >>" ); \
			[__x dump]; \
			TRAP(); \
		}

#undef	DEBUG_RENDERER_LAYOUT
#define DEBUG_RENDERER_LAYOUT( __x ) \
		if ( [__x.dom.attr hasObjectForKey:@"debug"] || [__x.dom.attr hasObjectForKey:@"debug-layout"] ) \
		{ \
			PRINT( @">>>> Debug layout at >>" ); \
			[__x dump]; \
			TRAP(); \
		}

#undef	DEBUG_RENDERER_STYLE
#define DEBUG_RENDERER_STYLE( __x ) \
		if ( [__x.dom.attr hasObjectForKey:@"debug"] || [__x.dom.attr hasObjectForKey:@"debug-style"] ) \
		{ \
			PRINT( @">>>> Debug style at >>" ); \
			[__x dump]; \
			TRAP(); \
		}

#undef	DEBUG_RENDERER_FRAME
#define DEBUG_RENDERER_FRAME( __x ) \
		if ( [__x.dom.attr hasObjectForKey:@"debug"] || [__x.dom.attr hasObjectForKey:@"debug-frame"] ) \
		{ \
			PRINT( @">>>> Debug frame at >>" ); \
			[__x dump]; \
			TRAP(); \
		}

#else	// #if __SAMURAI_DEBUG__

#undef	DEBUG_RENDERER_DOM
#define DEBUG_RENDERER_DOM( __x )

#undef	DEBUG_RENDERER_LAYOUT
#define DEBUG_RENDERER_LAYOUT( __x )

#undef	DEBUG_RENDERER_STYLE
#define DEBUG_RENDERER_STYLE( __x )

#undef	DEBUG_RENDERER_FRAME
#define DEBUG_RENDERER_FRAME( __x )

#endif	// #if __SAMURAI_DEBUG__

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
