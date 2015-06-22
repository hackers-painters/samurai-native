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

#pragma mark -

#undef	HTML_LAYOUT_MAX_LINES
#define HTML_LAYOUT_MAX_LINES	(512)

#pragma mark -

@class SamuraiHtmlStyle;
@class SamuraiHtmlRenderObject;

typedef struct
{
	__unsafe_unretained SamuraiHtmlStyle *	IN style;

	CGSize					IN	bounds;
	CGPoint					IN	origin;
	UIEdgeInsets			IN	collapse;

	CGFloat					OUT	computedMinWidth;
	CGFloat					OUT	computedMaxWidth;
	CGFloat					OUT	computedMinHeight;
	CGFloat					OUT	computedMaxHeight;
	
	UIEdgeInsets			OUT	computedInset;
	UIEdgeInsets			OUT	computedBorder;
	UIEdgeInsets			OUT	computedMargin;
	UIEdgeInsets			OUT	computedPadding;
	UIEdgeInsets			OUT computedOffset;

	CGSize					OUT	computedSize;
	CGRect					OUT	computedBounds;

	CGFloat					OUT	computedLineHeight;
	CGFloat					OUT	computedBorderSpacing;
	CGFloat					OUT	computedCellSpacing;
	CGFloat					OUT	computedCellPadding;
	
} SamuraiHtmlLayoutContext;

#pragma mark -

extern void htmlComputeInset( SamuraiHtmlLayoutContext * context );
extern void htmlComputeMargin( SamuraiHtmlLayoutContext * context );
extern void htmlComputeBorder( SamuraiHtmlLayoutContext * context );
extern void htmlComputePadding( SamuraiHtmlLayoutContext * context );
extern void htmlComputeCollpase( SamuraiHtmlLayoutContext * context );

extern void htmlComputeSize( SamuraiHtmlLayoutContext * context );
extern void htmlComputeMinMax( SamuraiHtmlLayoutContext * context );
extern void htmlComputeOffset( SamuraiHtmlLayoutContext * context );
extern void htmlComputeBounds( SamuraiHtmlLayoutContext * context );

extern void htmlComputeLineHeight( SamuraiHtmlLayoutContext * context, CGFloat fontHeight );
extern void htmlComputeBorderSpacing( SamuraiHtmlLayoutContext * context );
extern void htmlComputeCellSpacing( SamuraiHtmlLayoutContext * context );
extern void htmlComputeCellPadding( SamuraiHtmlLayoutContext * context );

#pragma mark -

extern void htmlLayoutInit( SamuraiHtmlLayoutContext * context );
extern void htmlLayoutBegin( SamuraiHtmlLayoutContext * context );
extern void htmlLayoutResize( SamuraiHtmlLayoutContext * context, CGSize newSize );
extern void htmlLayoutFinish( SamuraiHtmlLayoutContext * context );

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
