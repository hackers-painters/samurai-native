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

#import "Samurai_HtmlLayoutObject.h"
#import "Samurai_HtmlRenderObject.h"
#import "Samurai_HtmlRenderStyle.h"

#pragma mark -

@interface SamuraiHtmlRenderObject(ContainerLayout)

- (BOOL)block_isInline;
- (BOOL)block_isBlock;
- (BOOL)block_isTable;

- (BOOL)block_isFloating;
- (BOOL)block_isClearLeft;
- (BOOL)block_isClearRight;

- (BOOL)block_shouldWrapLine;
- (BOOL)block_shouldWrapBefore;
- (BOOL)block_shouldWrapAfter;

- (BOOL)block_shouldCenteringInRow;
- (BOOL)block_shouldCenteringInCol;
- (BOOL)block_shouldLeftJustifiedInRow;
- (BOOL)block_shouldRightJustifiedInRow;

- (BOOL)block_shouldAutoSizing;
- (BOOL)block_shouldAutoWidth;
- (BOOL)block_shouldAutoWidthByContent;
- (BOOL)block_shouldAutoHeight;

- (BOOL)block_shouldPositioningChildren;
- (BOOL)block_shouldStretchContentSize;

- (BOOL)block_shouldHorizontalAlign;
- (BOOL)block_shouldHorizontalAlignLeft;
- (BOOL)block_shouldHorizontalAlignRight;
- (BOOL)block_shouldHorizontalAlignCenter;
- (BOOL)block_shouldVerticalAlign;
- (BOOL)block_shouldVerticalAlignBaseline;
- (BOOL)block_shouldVerticalAlignTop;
- (BOOL)block_shouldVerticalAlignMiddle;
- (BOOL)block_shouldVerticalAlignBottom;
- (BOOL)block_shouldMarginCollapse;

- (BOOL)flex_shouldWrap;
- (BOOL)flex_shouldWrapReverse;

- (BOOL)flex_shouldArrangedInRow;
- (BOOL)flex_shouldArrangedInCol;
- (BOOL)flex_shouldArrangedReverse;

@end

#pragma mark -

@interface SamuraiHtmlLayoutContainer : SamuraiHtmlLayoutObject
@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
