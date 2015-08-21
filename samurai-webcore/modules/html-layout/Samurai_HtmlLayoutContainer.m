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

#import "Samurai_HtmlLayoutContainer.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_HtmlRenderObject.h"
#import "Samurai_HtmlRenderStyle.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiHtmlRenderObject(ContainerLayout)

- (BOOL)block_isInline
{
	return [self block_isBlock] ? NO : YES;
}

- (BOOL)block_isBlock
{
	switch ( self.display )
	{
		case CSSDisplay_Inline:				return NO;
		case CSSDisplay_Block:				return YES;
		case CSSDisplay_InlineBlock:		return NO;
		case CSSDisplay_Flex:				return YES;
		case CSSDisplay_InlineFlex:			return NO;
		case CSSDisplay_ListItem:			return YES;
		case CSSDisplay_Table:				return YES;
		case CSSDisplay_InlineTable:		return NO;
		case CSSDisplay_TableRowGroup:		return YES;
		case CSSDisplay_TableHeaderGroup:	return YES;
		case CSSDisplay_TableFooterGroup:	return YES;
		case CSSDisplay_TableRow:			return YES;
		case CSSDisplay_TableColumnGroup:	return YES;
		case CSSDisplay_TableColumn:		return YES;
		case CSSDisplay_TableCell:			return YES;
		case CSSDisplay_TableCaption:		return YES;
		default:							return YES;
	}
	
	return NO;
}

- (BOOL)block_isTable
{
	switch ( self.display )
	{
		case CSSDisplay_Inline:				return NO;
		case CSSDisplay_Block:				return NO;
		case CSSDisplay_InlineBlock:		return NO;
		case CSSDisplay_Flex:				return NO;
		case CSSDisplay_InlineFlex:			return NO;
		case CSSDisplay_ListItem:			return NO;
		case CSSDisplay_Table:				return YES;
		case CSSDisplay_InlineTable:		return YES;
		case CSSDisplay_TableRowGroup:		return YES;
		case CSSDisplay_TableHeaderGroup:	return YES;
		case CSSDisplay_TableFooterGroup:	return YES;
		case CSSDisplay_TableRow:			return YES;
		case CSSDisplay_TableColumnGroup:	return YES;
		case CSSDisplay_TableColumn:		return YES;
		case CSSDisplay_TableCell:			return YES;
		case CSSDisplay_TableCaption:		return YES;
		default:							return YES;
	}
	
	return NO;
}

- (BOOL)block_isFloating
{
	if ( CSSFloating_Left == self.floating || CSSFloating_Right == self.floating )
	{
		return YES;
	}
	else
	{
		return NO;
	}
}

- (BOOL)block_isClearLeft
{
	if ( self.prev )
	{
		if ( CSSClear_Right == self.prev.clear )
		{
			return YES;
		}
	}
	
	if ( CSSClear_Left == self.clear )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)block_isClearRight
{
	if ( self.next )
	{
		if ( CSSClear_Left == self.next.clear )
		{
			return YES;
		}
	}
	
	if ( CSSClear_Right == self.clear )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)block_shouldWrapLine
{
	return YES;
}

- (BOOL)block_shouldWrapBefore
{
	// 当非float的元素和float的元素在一起的时候，如果非float元素在先，那么float的元素将被排斥
	
	BOOL prevFloating = [self.prev block_isFloating];
	BOOL selfFloating = [self block_isFloating];
	
	if ( NO == prevFloating && NO == selfFloating )
	{
		// 正常文档流
		
		return [self block_isBlock];
	}
	else if ( YES == prevFloating && YES == selfFloating )
	{
		// Float流
		
		return [self block_isClearLeft];
	}
	else if ( YES == prevFloating && NO == selfFloating )
	{
		// Float流
		
		return [self block_isClearLeft];
	}
	else if ( NO == prevFloating && YES == selfFloating )
	{
		// 强制排挤
		
		return YES;
	}
	else
	{
		// 正常文档流
		
		return [self block_isBlock];
	}
}

- (BOOL)block_shouldWrapAfter
{
	// 当非float的元素和float的元素在一起的时候，如果非float元素在先，那么float的元素将被排斥
	
	BOOL nextFloating = [self.next block_isFloating];
	BOOL selfFloating = [self block_isFloating];
	
	if ( NO == nextFloating && NO == selfFloating )
	{
		// 正常文档流
		
		return [self block_isBlock];
	}
	else if ( YES == nextFloating && YES == selfFloating )
	{
		// Float流
		
		return [self block_isClearRight];
	}
	else if ( YES == nextFloating && NO == selfFloating )
	{
		// 强制排挤
		
		return YES;
	}
	else if ( NO == nextFloating && YES == selfFloating )
	{
		// Float流
		
		return [self block_isClearRight];
	}
	else
	{
		// 正常文档流
		
		return [self block_isBlock];
	}
}

- (BOOL)block_shouldCenteringInRow
{
	if ( [self block_isFloating] )
	{
		return NO;
	}
	
	if ( [self block_isBlock] )
	{
		if ( [self.style isAutoMarginLeft] && [self.style isAutoMarginRight] )
		{
			return YES;
		}
	}
	
	return NO;
}

- (BOOL)block_shouldCenteringInCol
{
	if ( [self block_isFloating] )
	{
		return NO;
	}
	
	if ( [self block_isBlock] )
	{
		if ( [self.style isAutoMarginTop] && [self.style isAutoMarginBottom] )
		{
			return YES;
		}
	}
	
	return NO;
}

- (BOOL)block_shouldLeftJustifiedInRow
{
	if ( [self block_isFloating] )
	{
		return NO;
	}
	
	if ( [self block_isBlock] )
	{
		if ( NO == [self.style isAutoMarginLeft] && [self.style isAutoMarginRight] )
		{
			return YES;
		}
	}
	
	return NO;
}

- (BOOL)block_shouldRightJustifiedInRow
{
	if ( [self block_isFloating] )
	{
		return NO;
	}
	
	if ( [self block_isBlock] )
	{
		if ( [self.style isAutoMarginLeft] && NO == [self.style isAutoMarginRight] )
		{
			return YES;
		}
	}
	
	return NO;
}

- (BOOL)block_shouldAutoSizing
{
	if ( CSSDisplay_Inline == self.display )
	{
		return YES;
	}
	
	if ( nil == self.style.width && nil == self.style.height )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)block_shouldAutoWidth
{
	if ( nil == self.style.width || [self.style isAutoWidth] )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)block_shouldAutoHeight
{
	if ( nil == self.style.height || [self.style isAutoHeight] )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)block_shouldPositioningChildren
{
	if ( [self block_isBlock] )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)block_shouldStretchContentSize
{
	if ( [self block_isFloating] )
	{
		return NO;
	}
	
	return YES;
}

- (BOOL)block_shouldHorizontalAlign
{
	if ( CSSAlign_None == self.align || CSSAlign_Inherit == self.align )
	{
		return NO;
	}
	
	return YES;
}

- (BOOL)block_shouldHorizontalAlignLeft
{
	if ( CSSAlign_Left == self.align )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)block_shouldHorizontalAlignRight
{
	if ( CSSAlign_Right == self.align )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)block_shouldHorizontalAlignCenter
{
	if ( CSSAlign_Center == self.align )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)block_shouldVerticalAlign
{
	if ( CSSVerticalAlign_None == self.verticalAlign || CSSVerticalAlign_Inherit == self.verticalAlign )
	{
		return NO;
	}
	
	return YES;
}

- (BOOL)block_shouldVerticalAlignBaseline
{
	if ( CSSVerticalAlign_Baseline == self.verticalAlign )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)block_shouldVerticalAlignTop
{
	if ( CSSVerticalAlign_Top == self.verticalAlign ||
		CSSVerticalAlign_Super == self.verticalAlign ||
		CSSVerticalAlign_TextTop == self.verticalAlign )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)block_shouldVerticalAlignMiddle
{
	if ( CSSVerticalAlign_Middle == self.verticalAlign )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)block_shouldVerticalAlignBottom
{
	if ( CSSVerticalAlign_Bottom == self.verticalAlign ||
		CSSVerticalAlign_Sub == self.verticalAlign ||
		CSSVerticalAlign_TextBottom == self.verticalAlign )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)block_shouldMarginCollapse
{
	if ( [self block_isFloating] )
	{
		return NO;
	}
	
	if ( CSSPosition_Relative == self.position || CSSPosition_Static == self.position )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)flex_shouldWrap
{
	if ( CSSFlexWrap_Wrap == self.flexWrap || CSSFlexWrap_WrapReverse == self.flexWrap )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)flex_shouldWrapReverse
{
	if ( CSSFlexWrap_WrapReverse == self.flexWrap )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)flex_shouldArrangedInRow
{
	if ( CSSFlexDirection_Row == self.flexDirection || CSSFlexDirection_RowReverse == self.flexDirection )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)flex_shouldArrangedInCol
{
	if ( CSSFlexDirection_Column == self.flexDirection || CSSFlexDirection_ColumnReverse == self.flexDirection )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)flex_shouldArrangedReverse
{
	if ( CSSFlexDirection_RowReverse == self.flexDirection || CSSFlexDirection_ColumnReverse == self.flexDirection )
	{
		return YES;
	}
	
	return NO;
}

@end

#pragma mark -

@implementation SamuraiHtmlLayoutContainer

- (void)layout
{
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlLayoutContainer )

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
