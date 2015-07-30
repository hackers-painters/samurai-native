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

@interface SamuraiHtmlRenderObject(ContainerLayout)

- (BOOL)isWrap;
- (BOOL)isBlock;
- (BOOL)isFloating;
- (BOOL)isClearLeft;
- (BOOL)isClearRight;

- (BOOL)layoutShouldWrapLine;
- (BOOL)layoutShouldWrapBefore;
- (BOOL)layoutShouldWrapAfter;
- (BOOL)layoutShouldCenteringInRow;
- (BOOL)layoutShouldCenteringInCol;
- (BOOL)layoutShouldLeftJustifiedInRow;
- (BOOL)layoutShouldRightJustifiedInRow;
- (BOOL)layoutShouldAutoSizing;
- (BOOL)layoutShouldPositioningChildren;
- (BOOL)layoutShouldStretchContentSize;
- (BOOL)layoutShouldArrangedInRow;
- (BOOL)layoutShouldArrangedInCol;
- (BOOL)layoutShouldArrangedReverse;
- (BOOL)layoutShouldHorizontalAlign;
- (BOOL)layoutShouldHorizontalAlignLeft;
- (BOOL)layoutShouldHorizontalAlignRight;
- (BOOL)layoutShouldHorizontalAlignCenter;
- (BOOL)layoutShouldVerticalAlign;
- (BOOL)layoutShouldVerticalAlignBaseline;
- (BOOL)layoutShouldVerticalAlignTop;
- (BOOL)layoutShouldVerticalAlignMiddle;
- (BOOL)layoutShouldVerticalAlignBottom;
- (BOOL)layoutShouldMarginCollapse;

@end

#pragma mark -

@implementation SamuraiHtmlRenderObject(ContainerLayout)

- (BOOL)isWrap
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
		case CSSDisplay_TableRowGroup:		return NO;
		case CSSDisplay_TableHeaderGroup:	return NO;
		case CSSDisplay_TableFooterGroup:	return NO;
		case CSSDisplay_TableRow:			return YES;
		case CSSDisplay_TableColumnGroup:	return NO;
		case CSSDisplay_TableColumn:		return NO;
		case CSSDisplay_TableCell:			return NO;
		case CSSDisplay_TableCaption:		return NO;
		default:							return NO;
	}

	return NO;
}

- (BOOL)isBlock
{
	switch ( self.display )
	{
		case CSSDisplay_Inline:				return NO;
		case CSSDisplay_Block:				return YES;
		case CSSDisplay_InlineBlock:		return YES;
		case CSSDisplay_Flex:				return YES;
		case CSSDisplay_InlineFlex:			return YES;
		case CSSDisplay_ListItem:			return YES;
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

- (BOOL)isFloating
{
	return (CSSFloating_Left == self.floating || CSSFloating_Right == self.floating) ? YES : NO;
}

- (BOOL)isClearLeft
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

- (BOOL)isClearRight
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

- (BOOL)layoutShouldWrapLine
{
	if ( self.parent )
	{
		if ( CSSDisplay_Flex == self.parent.display || CSSDisplay_InlineFlex == self.parent.display )
		{
			if ( CSSWrap_NoWrap == self.parent.wrap )
			{
				return NO;
			}
		}
	}

	return YES;
}

- (BOOL)layoutShouldWrapBefore
{
	if ( self.parent )
	{
		if ( CSSDisplay_Flex == self.parent.display || CSSDisplay_InlineFlex == self.parent.display )
		{
			if ( CSSWrap_NoWrap == self.parent.wrap )
			{
				return NO;
			}
		}
	}
	
// 当非float的元素和float的元素在一起的时候，如果非float元素在先，那么float的元素将被排斥

	BOOL prevFloating = [self.prev isFloating];
	BOOL selfFloating = [self isFloating];
	
	if ( NO == prevFloating && NO == selfFloating )
	{
		// 正常文档流
		
		return [self isWrap] ? YES : NO;
	}
	else if ( YES == prevFloating && YES == selfFloating )
	{
		// Float流
		
		return [self isClearLeft] ? YES : NO;
	}
	else if ( YES == prevFloating && NO == selfFloating )
	{
		// Float流
		
		return [self isClearLeft] ? YES : NO;
	}
	else if ( NO == prevFloating && YES == selfFloating )
	{
		// 强制排挤
		
		return YES;
	}
	else
	{
		// 正常文档流
		
		return [self isWrap] ? YES : NO;
	}
}

- (BOOL)layoutShouldWrapAfter
{
	if ( self.parent ) // flex
	{
		if ( CSSDisplay_Flex == self.parent.display || CSSDisplay_InlineFlex == self.parent.display )
		{
			if ( CSSWrap_NoWrap == self.parent.wrap )
			{
				return NO;
			}
		}
	}

// 当非float的元素和float的元素在一起的时候，如果非float元素在先，那么float的元素将被排斥
	
	BOOL nextFloating = [self.next isFloating];
	BOOL selfFloating = [self isFloating];
	
	if ( NO == nextFloating && NO == selfFloating )
	{
		// 正常文档流
		
		return [self isWrap] ? YES : NO;
	}
	else if ( YES == nextFloating && YES == selfFloating )
	{
		// Float流
		
		return [self isClearRight] ? YES : NO;
	}
	else if ( YES == nextFloating && NO == selfFloating )
	{
		// 强制排挤
		
		return YES;
	}
	else if ( NO == nextFloating && YES == selfFloating )
	{
		// Float流

		return [self isClearRight] ? YES : NO;
	}
	else
	{
		// 正常文档流
		
		return [self isWrap] ? YES : NO;
	}
}

- (BOOL)layoutShouldCenteringInRow
{
	if ( CSSFloating_None != self.floating )
	{
		return NO;
	}
	
	if ( [self isBlock] )
	{
		if ( [self.style isAutoMarginLeft] && [self.style isAutoMarginRight] )
		{
			return YES;
		}
	}

	return NO;
}

- (BOOL)layoutShouldCenteringInCol
{
	if ( CSSFloating_None != self.floating )
	{
		return NO;
	}
	
	if ( [self isBlock] )
	{
		if ( [self.style isAutoMarginTop] && [self.style isAutoMarginBottom] )
		{
			return YES;
		}
	}
	
	return NO;
}

- (BOOL)layoutShouldLeftJustifiedInRow
{
	if ( CSSFloating_None != self.floating )
	{
		return NO;
	}
	
	if ( [self isBlock] )
	{
		if ( NO == [self.style isAutoMarginLeft] && [self.style isAutoMarginRight] )
		{
			return YES;
		}
	}
	
	return NO;
}

- (BOOL)layoutShouldRightJustifiedInRow
{
	if ( CSSFloating_None != self.floating )
	{
		return NO;
	}
	
	if ( [self isBlock] )
	{
		if ( [self.style isAutoMarginLeft] && NO == [self.style isAutoMarginRight] )
		{
			return YES;
		}
	}
	
	return NO;
}

- (BOOL)layoutShouldAutoSizing
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

- (BOOL)layoutShouldPositioningChildren
{
	if ( [self isBlock] )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)layoutShouldStretchContentSize
{
	if ( CSSFloating_None != self.floating )
	{
		return NO;
	}
	
	return YES;
}

- (BOOL)layoutShouldArrangedInRow
{
	if ( CSSDisplay_Flex == self.display || CSSDisplay_InlineFlex == self.display ) // flex
	{
		if ( CSSDirection_Row == self.direction || CSSDirection_RowReverse == self.direction )
		{
			return YES;
		}
	}
	
	return NO;
}

- (BOOL)layoutShouldArrangedInCol
{
	if ( CSSDisplay_Flex == self.display || CSSDisplay_InlineFlex == self.display ) // flex
	{
		if ( CSSDirection_Column == self.direction || CSSDirection_ColumnReverse == self.direction )
		{
			return YES;
		}
	}
	
	return NO;
}

- (BOOL)layoutShouldArrangedReverse
{
	if ( CSSDisplay_Flex == self.display || CSSDisplay_InlineFlex == self.display ) // flex
	{
		if ( CSSDirection_RowReverse == self.direction || CSSDirection_ColumnReverse == self.direction )
		{
			return YES;
		}
	}
	
	return NO;
}

- (BOOL)layoutShouldHorizontalAlign
{
	if ( CSSAlign_None == self.align || CSSAlign_Inherit == self.align )
	{
		return NO;
	}
	
	return YES;
}

- (BOOL)layoutShouldHorizontalAlignLeft
{
	if ( CSSAlign_Left == self.align )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)layoutShouldHorizontalAlignRight
{
	if ( CSSAlign_Right == self.align )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)layoutShouldHorizontalAlignCenter
{
	if ( CSSAlign_Center == self.align )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)layoutShouldVerticalAlign
{
	if ( CSSVerticalAlign_None == self.verticalAlign || CSSVerticalAlign_Inherit == self.verticalAlign )
	{
		return NO;
	}
	
	return YES;
}

- (BOOL)layoutShouldVerticalAlignBaseline
{
	if ( CSSVerticalAlign_Baseline == self.verticalAlign )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)layoutShouldVerticalAlignTop
{
	if ( CSSVerticalAlign_Top == self.verticalAlign ||
		CSSVerticalAlign_Super == self.verticalAlign ||
		CSSVerticalAlign_TextTop == self.verticalAlign )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)layoutShouldVerticalAlignMiddle
{
	if ( CSSVerticalAlign_Middle == self.verticalAlign )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)layoutShouldVerticalAlignBottom
{
	if ( CSSVerticalAlign_Bottom == self.verticalAlign ||
		CSSVerticalAlign_Sub == self.verticalAlign ||
		CSSVerticalAlign_TextBottom == self.verticalAlign )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)layoutShouldMarginCollapse
{
	if ( CSSFloating_None != self.floating )
	{
		return NO;
	}
	
	if ( CSSPosition_Relative == self.position || CSSPosition_Static == self.position )
	{
		return YES;
	}
	
	return NO;
}

@end

#pragma mark -

@implementation SamuraiHtmlLayoutContainer

#pragma mark -

- (void)layout
{
	DEBUG_RENDERER_LAYOUT( self.source );

	CGSize				maxLayoutSize = CGSizeZero;
	CGSize				maxContentSize = CGSizeZero;

	NSInteger			childRow = 0;
	NSInteger			childColumn = 0;
	CGPoint				childPosition = CGPointZero;
	CGFloat				childFloatWidth = 0.0f;

	NSMutableArray *	childLines = [NSMutableArray array];
	NSMutableArray *	childLine = [NSMutableArray array];
	NSEnumerator *		childEnumerator = nil;
	
	CGFloat				thisBottom = 0.0f;
	CGFloat				lastBottom = 0.0f;

	if ( [self.source layoutShouldArrangedReverse] )
	{
		childEnumerator = [self.source.childs reverseObjectEnumerator];
	}
	else
	{
		childEnumerator = [self.source.childs objectEnumerator];
	}
	
	for ( SamuraiHtmlRenderObject * child in childEnumerator )
	{
		if ( CSSPosition_Static == child.position || CSSPosition_Relative == child.position )
		{
			CGRect			childFrame = CGRectZero;
			CGPoint			childOrigin = CGPointZero;
			CGSize			childBounds = CGSizeZero;
			UIEdgeInsets	childMargin = UIEdgeInsetsZero;
			
			if ( [child layoutShouldWrapBefore] )
			{
				childFloatWidth = 0.0f;
				childPosition.x = 0.0f;
				childPosition.y = maxLayoutSize.height;
				
				if ( [childLine count] )
				{
					[childLines addObject:childLine];
					
					childLine = [NSMutableArray nonRetainingArray];
					childRow += 1;
					childColumn = 0;
				
					lastBottom = thisBottom;
					thisBottom = 0.0f;
				}
			}

			childOrigin.x = childPosition.x;
			childOrigin.x += self.computedPadding.left;
			childOrigin.x += self.computedBorder.left;

			childOrigin.y = childPosition.y;
			childOrigin.y += self.computedPadding.top;
			childOrigin.y += self.computedBorder.top;

			if ( 0 == childRow )
			{
				if ( [self.source layoutShouldMarginCollapse] && [child layoutShouldMarginCollapse] )
				{
					childMargin.top = self.computedMargin.top;
				}
				else
				{
					childMargin.top = 0.0f;
				}
			}
			else
			{
				childMargin.top = lastBottom;
			}
			
			childBounds = self.computedSize;
			
			if ( INVALID_VALUE == childBounds.width )
			{
				childBounds.width = self.bounds.width;
			}

			if ( NO == [child isFloating] )
			{
				childBounds.width -= childFloatWidth;
			}

			child.layout.insetFlags		= UIEdgeFlagsYes;
			child.layout.marginFlags	= UIEdgeFlagsYes;
			child.layout.borderFlags	= UIEdgeFlagsYes;
			child.layout.paddingFlags	= UIEdgeFlagsYes;
			
			child.layout.bounds			= childBounds;
			child.layout.origin			= childOrigin;
			child.layout.collapse		= childMargin;

			if ( [child.layout begin:YES] )
			{
				[child.layout layout];
				[child.layout finish];
			}

			childFrame = child.layout.computedBounds;
			thisBottom = fmaxf( thisBottom, child.layout.computedMargin.bottom );

		// compute wrap line
			
			if ( [child layoutShouldWrapLine] )
			{
				BOOL shouldBreakLine = NO;

				if ( 0 != childColumn )
				{
					CGFloat lineBoundsRight = 0.0f;
					
					if ( INVALID_VALUE == self.computedSize.width )
					{
						lineBoundsRight = self.bounds.width;
						lineBoundsRight += self.computedPadding.left;
					//	lineBoundsRight += self.computedPadding.right;
						lineBoundsRight += self.computedBorder.left;
					//	lineBoundsRight += self.computedBorder.right;
					}
					else
					{
						lineBoundsRight = self.computedSize.width;
					}
					
					if ( INVALID_VALUE != lineBoundsRight )
					{
						CGFloat childRight = CGRectGetMaxX( childFrame );
						
						if ( childRight > lineBoundsRight )
						{
							shouldBreakLine = YES;
						}
					}

					if ( shouldBreakLine )
					{
						childFloatWidth = 0.0f;
						childPosition.x = 0.0f;
						childPosition.y = maxLayoutSize.height;

						if ( [childLine count] )
						{
							[childLines addObject:childLine];
							
							childLine = [NSMutableArray nonRetainingArray];
							childRow += 1;
							childColumn = 0;

							lastBottom = thisBottom;
							thisBottom = 0.0f;
						}

						childOrigin.x = childPosition.x;
						childOrigin.x += self.computedPadding.left;
						childOrigin.x += self.computedBorder.left;

						childOrigin.y = childPosition.y;
					//	childOrigin.y += self.computedPadding.top;
					//	childOrigin.y += self.computedBorder.top;

						if ( 0 == childRow )
						{
							if ( [self.source layoutShouldMarginCollapse] && [child layoutShouldMarginCollapse] )
							{
								childMargin.top = self.computedMargin.top;
							}
							else
							{
								childMargin.top = 0.0f;
							}
						}
						else
						{
							childMargin.top = lastBottom;
						}

						childBounds = self.computedSize;
						
						if ( INVALID_VALUE == childBounds.width )
						{
							childBounds.width = self.bounds.width;
						}
						
						if ( NO == [child isFloating] )
						{
							childBounds.width -= childFloatWidth;
						}

						child.layout.insetFlags		= UIEdgeFlagsYes;
						child.layout.marginFlags	= UIEdgeFlagsYes;
						child.layout.borderFlags	= UIEdgeFlagsYes;
						child.layout.paddingFlags	= UIEdgeFlagsYes;
						
						child.layout.bounds			= childBounds;
						child.layout.origin			= childOrigin;
						child.layout.collapse		= childMargin;
						
						if ( [child.layout begin:YES] )
						{
							[child.layout layout];
							[child.layout finish];
						}
						
						childFrame = child.layout.computedBounds;
						thisBottom = fmaxf( thisBottom, child.layout.computedMargin.bottom );
					}
				}
			}

			if ( [child isFloating] )
			{
				childFloatWidth += child.layout.computedBounds.size.width;
			}

			if ( NO == [childLine containsObject:child] )
			{
				[childLine addObject:child];
			}

			if ( [child layoutShouldWrapAfter] )
			{
				childFloatWidth = 0.0f;
				childPosition.x = 0.0f;
				childPosition.y += childFrame.size.height;

				if ( [childLine count] )
				{
					[childLines addObject:childLine];

					childLine = [NSMutableArray nonRetainingArray];
					childRow += 1;
					childColumn = 0;
					
					lastBottom = thisBottom;
					thisBottom = 0.0f;
				}
			}
			else
			{
				if ( [self.source layoutShouldArrangedInRow] )
				{
					childPosition.x += childFrame.size.width;
				}
				else if ( [self.source layoutShouldArrangedInCol] )
				{
					childPosition.y += childFrame.size.height;
				}
				else
				{
					TODO( "ACID1 bug" )

					childPosition.x += childFrame.size.width;
				}

				childColumn += 1;
			}
			
		// compute max width
			
			if ( INVALID_VALUE == maxLayoutSize.width )
			{
				maxLayoutSize.width = childFrame.size.width;
			}
			else if ( CGRectGetMaxX( childFrame ) > maxLayoutSize.width )
			{
				maxLayoutSize.width = CGRectGetMaxX( childFrame );
			}
			else if ( childFrame.size.width > maxLayoutSize.width )
			{
				maxLayoutSize.width = childFrame.size.width;
			}
			else if ( childOrigin.x + childFrame.size.width > maxLayoutSize.width )
			{
				maxLayoutSize.width = childOrigin.x + childFrame.size.width;
			}

		// compute max height
			
			if ( INVALID_VALUE == maxLayoutSize.height )
			{
				maxLayoutSize.height = childFrame.size.height;
			}
			else if ( CGRectGetMaxY( childFrame ) > maxLayoutSize.height )
			{
				maxLayoutSize.height = CGRectGetMaxY( childFrame );
			}
			else if ( childFrame.size.height > maxLayoutSize.height )
			{
				maxLayoutSize.height = childFrame.size.height;
			}
			else if ( childOrigin.y + childFrame.size.height > maxLayoutSize.height )
			{
				maxLayoutSize.height = childOrigin.y + childFrame.size.height;
			}
			
			maxContentSize.width = maxLayoutSize.width;
			maxContentSize.width -= self.computedBorder.left;
			maxContentSize.width -= self.computedPadding.left;

			maxContentSize.height = maxLayoutSize.height;
			maxContentSize.height -= self.computedBorder.top;
			maxContentSize.height -= self.computedPadding.top;
		}
		else if ( CSSPosition_Absolute == child.position )
		{
		//	TODO( "absolute" )
		}
		else if ( CSSPosition_Fixed == child.position )
		{
		//	TODO( "fixed" )
		}
	}

	if ( NO == [childLines containsObject:childLine] )
	{
		if ( [childLine count] )
		{
			[childLines addObject:childLine];
		}
	}

// compute floating & align

	CGSize contentSize;
	
	if ( [self.source layoutShouldAutoSizing] )
	{
		contentSize = maxContentSize;
	}
	else
	{
		contentSize = self.computedSize;
		
		if ( [self.source.style isAutoWidth] )
		{
			contentSize.width = maxContentSize.width;
		}
		
		if ( [self.source.style isAutoHeight] )
		{
			contentSize.height = maxContentSize.height;
		}
	}

	if ( [self.source layoutShouldPositioningChildren] )
	{
		for ( NSMutableArray * line in childLines )
		{
			CGFloat lineWidth = contentSize.width;
			CGFloat lineHeight = 0.0f;
			
			CGFloat lineTop = INVALID_VALUE;
			CGFloat lineBottom = INVALID_VALUE;
			
			CGFloat	leftWidth = 0.0f;
			CGFloat	rightWidth = 0.0f;
			CGFloat	centerWidth = 0.0f;

			lineWidth += self.computedPadding.left;
			lineWidth += self.computedPadding.right;
			lineWidth += self.computedBorder.left;
			lineWidth += self.computedBorder.right;
		//	lineWidth += self.computedMargin.left;
		//	lineWidth += self.computedMargin.right;
			
			NSMutableArray * leftFlow = [NSMutableArray nonRetainingArray];
			NSMutableArray * rightFlow = [NSMutableArray nonRetainingArray];
			NSMutableArray * normalFlow = [NSMutableArray nonRetainingArray];
			
			for ( SamuraiHtmlRenderObject * child in line )
			{
				if ( CSSDisplay_None == child.display )
					continue;

				if ( INVALID_VALUE == lineTop )
				{
					lineTop = child.layout.computedBounds.origin.y;
				}
				else
				{
					lineTop = fmin( lineTop, child.layout.computedBounds.origin.y );
				}

				if ( INVALID_VALUE == lineBottom )
				{
					lineBottom = CGRectGetMaxY( child.layout.computedBounds );
				}
				else
				{
					lineBottom = fmin( lineTop, CGRectGetMaxY( child.layout.computedBounds ) );
				}

				lineHeight = fmax( lineHeight, child.layout.computedBounds.size.height );

				if ( CSSFloating_Left == child.floating )
				{
					leftWidth += child.layout.computedBounds.size.width;
					
					[leftFlow addObject:child];
				}
				else if ( CSSFloating_Right == child.floating )
				{
					rightWidth += child.layout.computedBounds.size.width;
					
					[rightFlow addObject:child];
				}
				else if ( CSSFloating_None == child.floating )
				{
					centerWidth += child.layout.computedBounds.size.width;
					
					[normalFlow addObject:child];
				}
			}

		// floating flow
			
			CGFloat contentLeft = 0.0f;
			CGFloat contentRight = lineWidth;
			
			DEBUG_RENDERER_FLOAT( self.source );

			if ( [leftFlow count] || [rightFlow count] )
			{
				CGFloat floatingLeft = 0.0f;
				CGFloat floatingRight = lineWidth;

				floatingLeft += self.computedBorder.left;
			//	floatingLeft += self.computedMargin.left;
				floatingLeft += self.computedPadding.left;

				floatingRight -= self.computedBorder.right;
			//	floatingRight -= self.computedMargin.right;
				floatingRight -= self.computedPadding.right;

				for ( SamuraiHtmlRenderObject * child in leftFlow )
				{
					CGPoint childOffset;
					
					childOffset.x = floatingLeft;
					childOffset.y = child.layout.origin.y;

					child.layout.insetFlags		= UIEdgeFlagsYes;
					child.layout.marginFlags	= UIEdgeFlagsYes;
					child.layout.borderFlags	= UIEdgeFlagsYes;
					child.layout.paddingFlags	= UIEdgeFlagsYes;

					if ( [child.layout begin:NO] )
					{
						[child.layout offset:childOffset];
						[child.layout finish];
					}
					
					floatingLeft += child.layout.computedBounds.size.width;
				}

				for ( SamuraiHtmlRenderObject * child in rightFlow )
				{
					CGPoint childOffset;
					
					childOffset.x = floatingRight - child.layout.computedBounds.size.width;
					childOffset.y = child.layout.origin.y;

					child.layout.insetFlags		= UIEdgeFlagsYes;
					child.layout.marginFlags	= UIEdgeFlagsYes;
					child.layout.borderFlags	= UIEdgeFlagsYes;
					child.layout.paddingFlags	= UIEdgeFlagsYes;

					if ( [child.layout begin:NO] )
					{
						[child.layout offset:childOffset];
						[child.layout finish];
					}

					floatingRight -= child.layout.computedBounds.size.width;
				}

				if ( [leftFlow count] )
				{
					contentLeft = floatingLeft;
				}
				else
				{
					contentLeft += self.computedBorder.left;
				//	contentLeft += self.computedMargin.left;
					contentLeft += self.computedPadding.left;
				}
				
				if ( [rightFlow count] )
				{
					contentRight = floatingRight;
				}
				else
				{
					contentRight -= self.computedBorder.right;
				//	contentRight -= self.computedMargin.right;
					contentRight -= self.computedPadding.right;
				}

				CGFloat floatCenter = contentLeft;

				for ( SamuraiHtmlRenderObject * child in normalFlow )
				{
					CGPoint childOffset;
					
					childOffset.x = floatCenter;
					childOffset.y = child.layout.origin.y;

					child.layout.insetFlags		= UIEdgeFlagsYes;
					child.layout.marginFlags	= UIEdgeFlagsYes;
					child.layout.borderFlags	= UIEdgeFlagsYes;
					child.layout.paddingFlags	= UIEdgeFlagsYes;

					if ( [child.layout begin:NO] )
					{
						[child.layout offset:childOffset];
						[child.layout finish];
					}

					floatCenter += child.layout.computedBounds.size.width;
				}
			}

		// align flow
			
			DEBUG_RENDERER_ALIGN( self.source );
			
			if ( [self.source layoutShouldHorizontalAlign] )
			{
				if ( [self.source layoutShouldHorizontalAlignLeft] )
				{
					CGFloat alignLeft = contentLeft;

					for ( SamuraiHtmlRenderObject * child in normalFlow )
					{
						CGPoint childOffset;
						
						childOffset.x = alignLeft;
						childOffset.x += self.computedBorder.left;
					//	childOffset.x += self.computedMargin.left;
						childOffset.x += self.computedPadding.left;
						childOffset.y = child.layout.origin.y;

						child.layout.insetFlags		= UIEdgeFlagsYes;
						child.layout.marginFlags	= UIEdgeFlagsYes;
						child.layout.borderFlags	= UIEdgeFlagsYes;
						child.layout.paddingFlags	= UIEdgeFlagsYes;

						if ( [child.layout begin:NO] )
						{
							[child.layout offset:childOffset];
							[child.layout finish];
						}

						alignLeft += child.layout.computedBounds.size.width;
					}
				}
				else if ( [self.source layoutShouldHorizontalAlignRight] )
				{
					CGFloat alignRight = contentRight;
					
					for ( SamuraiHtmlRenderObject * child in normalFlow )
					{
						CGPoint childOffset;
						
						childOffset.x = alignRight;
						childOffset.x -= child.layout.computedBounds.size.width;
						childOffset.x -= self.computedBorder.right;
					//	childOffset.x -= self.computedMargin.right;
						childOffset.x -= self.computedPadding.right;
						childOffset.y = child.layout.origin.y;

						child.layout.insetFlags		= UIEdgeFlagsYes;
						child.layout.marginFlags	= UIEdgeFlagsYes;
						child.layout.borderFlags	= UIEdgeFlagsYes;
						child.layout.paddingFlags	= UIEdgeFlagsYes;

						if ( [child.layout begin:NO] )
						{
							[child.layout offset:childOffset];
							[child.layout finish];
						}

						alignRight -= child.layout.computedBounds.size.width;
					}
				}
				else if ( [self.source layoutShouldHorizontalAlignCenter] )
				{
					CGFloat alignCenter = contentLeft + ((contentRight - contentLeft) - centerWidth) / 2.0f;
					
					for ( SamuraiHtmlRenderObject * child in normalFlow )
					{
						CGPoint childOffset;

						childOffset.x = alignCenter;
						childOffset.y = child.layout.origin.y;

						child.layout.insetFlags		= UIEdgeFlagsYes;
						child.layout.marginFlags	= UIEdgeFlagsYes;
						child.layout.borderFlags	= UIEdgeFlagsYes;
						child.layout.paddingFlags	= UIEdgeFlagsYes;

						if ( [child.layout begin:NO] )
						{
							[child.layout offset:childOffset];
							[child.layout finish];
						}

						alignCenter += child.layout.computedBounds.size.width;
					}
				}
			}

		// compute margin: 0 auto
			
			for ( SamuraiHtmlRenderObject * child in normalFlow )
			{
				if ( [child layoutShouldLeftJustifiedInRow] )
				{
					CGPoint childOffset;
					
					childOffset.x = contentLeft;
					childOffset.y = child.layout.origin.y;

					child.layout.insetFlags		= UIEdgeFlagsYes;
					child.layout.marginFlags	= UIEdgeFlagsYes;
					child.layout.borderFlags	= UIEdgeFlagsYes;
					child.layout.paddingFlags	= UIEdgeFlagsYes;

					if ( [child.layout begin:NO] )
					{
						[child.layout offset:childOffset];
						[child.layout finish];
					}
				}
				else if ( [child layoutShouldRightJustifiedInRow] )
				{
					CGPoint childOffset;
					
					childOffset.x = contentRight - child.layout.computedBounds.size.width;
					childOffset.y = child.layout.origin.y;

					child.layout.insetFlags		= UIEdgeFlagsYes;
					child.layout.marginFlags	= UIEdgeFlagsYes;
					child.layout.borderFlags	= UIEdgeFlagsYes;
					child.layout.paddingFlags	= UIEdgeFlagsYes;

					if ( [child.layout begin:NO] )
					{
						[child.layout offset:childOffset];
						[child.layout finish];
					}
				}
				else if ( [child layoutShouldCenteringInRow] )
				{
					CGPoint childOffset;

					childOffset.x = contentLeft + ((contentRight - contentLeft) - centerWidth) / 2.0f;
					childOffset.y = child.layout.origin.y;
					
					child.layout.insetFlags		= UIEdgeFlagsYes;
					child.layout.marginFlags	= UIEdgeFlagsYes;
					child.layout.borderFlags	= UIEdgeFlagsYes;
					child.layout.paddingFlags	= UIEdgeFlagsYes;

					if ( [child.layout begin:NO] )
					{
						[child.layout offset:childOffset];
						[child.layout finish];
					}
				}
			}
			
		// vertical align flow
			
			if ( [self.source layoutShouldVerticalAlign] )
			{
				if ( [self.source layoutShouldVerticalAlignTop] )
				{
					for ( SamuraiHtmlRenderObject * child in normalFlow )
					{
						CGPoint childOffset;
						
						childOffset.x = child.layout.origin.x;
						childOffset.y = lineTop;

						child.layout.insetFlags		= UIEdgeFlagsYes;
						child.layout.marginFlags	= UIEdgeFlagsYes;
						child.layout.borderFlags	= UIEdgeFlagsYes;
						child.layout.paddingFlags	= UIEdgeFlagsYes;

						if ( [child.layout begin:NO] )
						{
							[child.layout offset:childOffset];
							[child.layout finish];
						}
					}
				}
				else if ( [self.source layoutShouldVerticalAlignBottom] )
				{
					for ( SamuraiHtmlRenderObject * child in normalFlow )
					{
						CGPoint childOffset;
						
						childOffset.x = child.layout.origin.x;
						childOffset.y = lineBottom - child.layout.computedBounds.size.height;

						child.layout.insetFlags		= UIEdgeFlagsYes;
						child.layout.marginFlags	= UIEdgeFlagsYes;
						child.layout.borderFlags	= UIEdgeFlagsYes;
						child.layout.paddingFlags	= UIEdgeFlagsYes;

						if ( [child.layout begin:NO] )
						{
							[child.layout offset:childOffset];
							[child.layout finish];
						}
					}
				}
				else if ( [self.source layoutShouldVerticalAlignMiddle] )
				{
					for ( SamuraiHtmlRenderObject * child in normalFlow )
					{
						CGPoint childOffset;
						
						childOffset.x = child.layout.origin.x;
						childOffset.y = lineTop + (lineHeight - child.layout.computedBounds.size.height) / 2.0f;
						
						child.layout.insetFlags		= UIEdgeFlagsYes;
						child.layout.marginFlags	= UIEdgeFlagsYes;
						child.layout.borderFlags	= UIEdgeFlagsYes;
						child.layout.paddingFlags	= UIEdgeFlagsYes;

						if ( [child.layout begin:NO] )
						{
							[child.layout offset:childOffset];
							[child.layout finish];
						}
					}
				}
				else if ( [self.source layoutShouldVerticalAlignBaseline] )
				{
					TODO( "baseline" );
				}
			}

		// compute margin: auto 0;

			TODO( "margin: auto 0;" )
		}

	// compute offset
		
		for ( SamuraiHtmlRenderObject * child in self.source.childs )
		{
			if ( CSSDisplay_None == child.display )
				continue;

			if ( CSSPosition_Relative == child.position )
			{
				CGPoint childOffset;
				
				childOffset.x = child.layout.origin.x;
				childOffset.x += child.layout.computedOffset.left;
				childOffset.x -= child.layout.computedOffset.right;
				
				childOffset.y = child.layout.origin.y;
				childOffset.y += child.layout.computedOffset.top;
				childOffset.y -= child.layout.computedOffset.bottom;

				child.layout.insetFlags		= UIEdgeFlagsYes;
				child.layout.marginFlags	= UIEdgeFlagsYes;
				child.layout.borderFlags	= UIEdgeFlagsYes;
				child.layout.paddingFlags	= UIEdgeFlagsYes;

				if ( [child.layout begin:NO] )
				{
					[child.layout offset:childOffset];
					[child.layout finish];
				}
			}
			else if ( CSSPosition_Absolute == child.position )
			{
				CGPoint childOrigin;

				childOrigin.x = self.computedMargin.left;
				childOrigin.x += self.computedBorder.left;
				childOrigin.x += self.computedPadding.left;

				childOrigin.y = self.computedMargin.top;
				childOrigin.y += self.computedBorder.top;
				childOrigin.y += self.computedPadding.top;

				child.layout.insetFlags		= UIEdgeFlagsYes;
				child.layout.marginFlags	= UIEdgeFlagsYes;
				child.layout.borderFlags	= UIEdgeFlagsYes;
				child.layout.paddingFlags	= UIEdgeFlagsYes;

				child.layout.bounds			= contentSize;
				child.layout.origin			= childOrigin;
				child.layout.collapse		= UIEdgeInsetsZero;

				if ( [child.layout begin:YES] )
				{
					[child.layout layout];
					[child.layout finish];
				}

				CGPoint childOffset = child.layout.origin;

				if ( child.style.left )
				{
					childOffset.x = child.layout.computedOffset.left;
					childOffset.x += self.computedPadding.left;
					childOffset.x += self.computedBorder.left;
				}
				else if ( child.style.right )
				{
					CGFloat childWidth;
					
					childWidth = child.layout.computedBounds.size.width;
					childWidth += child.layout.computedOffset.right;
					childWidth += child.layout.computedMargin.right;
					
					childOffset.x = contentSize.width - childWidth;
					childOffset.x -= self.computedPadding.right;
					childOffset.x -= self.computedBorder.right;
				}
				
				if ( child.style.top )
				{
					childOffset.y = child.layout.computedOffset.top;
					childOffset.y += self.computedPadding.top;
					childOffset.y += self.computedBorder.top;
				}
				else if ( child.style.bottom )
				{
					CGFloat childHeight;
					
					childHeight = child.layout.computedBounds.size.height;
					childHeight += child.layout.computedOffset.bottom;
					childHeight += child.layout.computedMargin.bottom;

					childOffset.y = contentSize.height - childHeight;
					childOffset.y -= self.computedPadding.bottom;
					childOffset.y -= self.computedBorder.bottom;
				}

				child.layout.insetFlags		= UIEdgeFlagsYes;
				child.layout.marginFlags	= UIEdgeFlagsYes;
				child.layout.borderFlags	= UIEdgeFlagsYes;
				child.layout.paddingFlags	= UIEdgeFlagsYes;

				if ( [child.layout begin:NO] )
				{
					[child.layout offset:childOffset];
					[child.layout finish];
				}
			}
			else if ( CSSPosition_Fixed == child.position )
			{
				TODO( "fixed" )
			}
			else if ( CSSPosition_Static == child.position )
			{
				
			}
		}
	}

	[self resize:contentSize];
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
