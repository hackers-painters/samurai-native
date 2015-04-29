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

#import "Samurai_HtmlDomNode.h"
#import "Samurai_HtmlStyle.h"

#pragma mark -

typedef enum
{
	HtmlRenderModel_Unknown = 0,
	HtmlRenderModel_Hidden,
	HtmlRenderModel_Inline,
	HtmlRenderModel_Element,
	HtmlRenderModel_Container
} HtmlRenderModel;

#pragma mark -

@class SamuraiHtmlRenderObject;

@interface NSObject(HtmlSupport)

+ (HtmlRenderModel)html_defaultRenderModel;

- (void)html_applyDom:(SamuraiHtmlDomNode *)dom;	// override point
- (void)html_applyStyle:(SamuraiHtmlStyle *)style;	// override point
- (void)html_applyFrame:(CGRect)newFrame;			// override point

@end

#pragma mark -

@interface UIView(HtmlSupport)

@prop_strong( SamuraiHtmlStyle *,	customStyle );
@prop_strong( NSArray *,			customStyleClasses );

@end

#pragma mark -

@interface SamuraiHtmlRenderObject : SamuraiRenderObject<SamuraiCSSProtocol>

@prop_strong( NSMutableArray *,				customStyleClasses );
@prop_strong( NSMutableDictionary *,		customStyleComputed );
@prop_strong( SamuraiHtmlStyle *,			customStyle );

@prop_unsafe( SamuraiHtmlDomNode *,			dom );
@prop_strong( SamuraiHtmlStyle *,			style );

@prop_assign( RenderWrap,					wrap );
@prop_assign( RenderDisplay,				display );
@prop_assign( RenderFloating,				floating );
@prop_assign( RenderPosition,				position );
@prop_assign( RenderDirection,				direction );

@prop_readonly( SamuraiHtmlRenderObject *,	root );
@prop_unsafe( SamuraiHtmlRenderObject *,	parent );
@prop_unsafe( SamuraiHtmlRenderObject *,	prev );
@prop_unsafe( SamuraiHtmlRenderObject *,	next );

- (BOOL)layoutShouldWrapLine;				// override point
- (BOOL)layoutShouldWrapBefore;				// override point
- (BOOL)layoutShouldWrapAfter;				// override point
- (BOOL)layoutShouldBoundsToWindow;			// override point
- (BOOL)layoutShouldCenteringInRow;			// override point
- (BOOL)layoutShouldCenteringInCol;			// override point
- (BOOL)layoutShouldPositioningChildren;	// override point
- (BOOL)layoutShouldArrangedInRow;			// override point
- (BOOL)layoutShouldArrangedInCol;			// override point
- (BOOL)layoutShouldArrangedReverse;		// override point

- (UIEdgeInsets)computeInset:(CGSize)size;
- (UIEdgeInsets)computeBorder:(CGSize)size;
- (UIEdgeInsets)computeMargin:(CGSize)size;
- (UIEdgeInsets)computeOffset:(CGSize)size;
- (UIEdgeInsets)computePadding:(CGSize)size;

- (void)applyStyle;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
