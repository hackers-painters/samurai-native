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

#import "Samurai_HtmlLayout.h"
#import "Samurai_HtmlDomNode.h"
#import "Samurai_HtmlStyle.h"

#pragma mark -

typedef enum
{
	HtmlRenderModel_Unknown = 0,
	HtmlRenderModel_Hidden,
	HtmlRenderModel_Inline,
	HtmlRenderModel_Element,
	HtmlRenderModel_Table,
	HtmlRenderModel_Container,
} HtmlRenderModel;

#pragma mark -

@class SamuraiHtmlRenderObject;

@interface NSObject(HtmlSupport)

+ (HtmlRenderModel)html_defaultRenderModel;

- (void)html_applyDom:(SamuraiHtmlDomNode *)dom;	// override point
- (void)html_applyStyle:(SamuraiHtmlStyle *)style;	// override point
- (void)html_applyFrame:(CGRect)newFrame;			// override point

- (void)html_forView:(UIView *)hostView;			// override point, for="id"

@end

#pragma mark -

@interface SamuraiHtmlRenderObject : SamuraiRenderObject<SamuraiCSSProtocol>

@prop_strong( NSMutableArray *,				customStyleClasses );
@prop_strong( NSMutableDictionary *,		customStyleComputed );
@prop_strong( SamuraiHtmlStyle *,			customStyle );

@prop_assign( HtmlRenderWrap,				wrap );
@prop_assign( HtmlRenderAlign,				align );
@prop_assign( HtmlRenderClear,				clear );
@prop_assign( HtmlRenderDisplay,			display );
@prop_assign( HtmlRenderFloating,			floating );
@prop_assign( HtmlRenderPosition,			position );
@prop_assign( HtmlRenderDirection,			direction );
@prop_assign( HtmlRenderVerticalAlign,		verticalAlign );

@prop_assign( NSInteger,					tableRow );
@prop_assign( NSInteger,					tableCol );
@prop_assign( NSInteger,					tableRowSpan );
@prop_assign( NSInteger,					tableColSpan );

@prop_unsafe( SamuraiHtmlDomNode *,			dom );		// override
@prop_strong( SamuraiHtmlStyle *,			style );	// override

@prop_readonly( SamuraiHtmlRenderObject *,	root );		// override
@prop_unsafe( SamuraiHtmlRenderObject *,	parent );	// override
@prop_unsafe( SamuraiHtmlRenderObject *,	prev );		// override
@prop_unsafe( SamuraiHtmlRenderObject *,	next );		// override

- (void)renderWillLoad;						// override point
- (void)renderDidLoad;						// override point

- (BOOL)layoutShouldWrapLine;				// override point
- (BOOL)layoutShouldWrapBefore;				// override point
- (BOOL)layoutShouldWrapAfter;				// override point

- (BOOL)layoutShouldAutoSizing;				// override point
- (BOOL)layoutShouldCenteringInRow;			// override point
- (BOOL)layoutShouldCenteringInCol;			// override point
- (BOOL)layoutShouldLeftJustifiedInRow;		// override point
- (BOOL)layoutShouldRightJustifiedInRow;	// override point

- (BOOL)layoutShouldPositioningChildren;	// override point

- (BOOL)layoutShouldArrangedInRow;			// override point
- (BOOL)layoutShouldArrangedInCol;			// override point
- (BOOL)layoutShouldArrangedReverse;		// override point

- (BOOL)layoutShouldHorizontalAlign;		// override point
- (BOOL)layoutShouldHorizontalAlignLeft;	// override point
- (BOOL)layoutShouldHorizontalAlignRight;	// override point
- (BOOL)layoutShouldHorizontalAlignCenter;	// override point

- (BOOL)layoutShouldVerticalAlign;			// override point
- (BOOL)layoutShouldVerticalAlignBaseline;	// override point
- (BOOL)layoutShouldVerticalAlignTop;		// override point
- (BOOL)layoutShouldVerticalAlignMiddle;	// override point
- (BOOL)layoutShouldVerticalAlignBottom;	// override point

- (void)computeTabIndex;
- (void)computeProperties;

- (CGRect)layoutWithContext:(SamuraiHtmlLayoutContext *)context
			  parentContext:(SamuraiHtmlLayoutContext *)parentContext;	// override point

@end

#pragma mark -

#if __SAMURAI_DEBUG__

#undef	DEBUG_RENDERER_DOM
#define DEBUG_RENDERER_DOM( __x ) \
		if ( [__x.dom.attributes hasObjectForKey:@"debug"] || [__x.dom.attributes hasObjectForKey:@"debug-dom"] ) \
		{ \
			PRINT( @">>>> Debug layout at >>" ); \
			[__x dump]; \
			TRAP(); \
		}

#undef	DEBUG_RENDERER_LAYOUT
#define DEBUG_RENDERER_LAYOUT( __x ) \
		if ( [__x.dom.attributes hasObjectForKey:@"debug"] || [__x.dom.attributes hasObjectForKey:@"debug-layout"] ) \
		{ \
			PRINT( @">>>> Debug layout at >>" ); \
			[__x dump]; \
			TRAP(); \
		}

#undef	DEBUG_RENDERER_STYLE
#define DEBUG_RENDERER_STYLE( __x ) \
		if ( [__x.dom.attributes hasObjectForKey:@"debug"] || [__x.dom.attributes hasObjectForKey:@"debug-style"] ) \
		{ \
			PRINT( @">>>> Debug style at >>" ); \
			[__x dump]; \
			TRAP(); \
		}

#undef	DEBUG_RENDERER_FRAME
#define DEBUG_RENDERER_FRAME( __x ) \
		if ( [__x.dom.attributes hasObjectForKey:@"debug"] || [__x.dom.attributes hasObjectForKey:@"debug-frame"] ) \
		{ \
			PRINT( @">>>> Debug frame at >>" ); \
			[__x dump]; \
			TRAP(); \
		}

#else	// #if __SAMURAI_DEBUG__

#undef	DEBUG_RENDERER_LAYOUT
#define DEBUG_RENDERER_LAYOUT( __x )

#undef	DEBUG_RENDERER_STYLE
#define DEBUG_RENDERER_STYLE( __x )

#undef	DEBUG_RENDERER_FRAME
#define DEBUG_RENDERER_FRAME( __x )

#endif	// #if __SAMURAI_DEBUG__

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
