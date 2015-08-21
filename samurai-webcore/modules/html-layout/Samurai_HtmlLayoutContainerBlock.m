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

#import "Samurai_HtmlLayoutContainerBlock.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiHtmlLayoutContainerBlock

- (void)layout
{
	DEBUG_RENDERER_LAYOUT( self.source );

	CGSize				maxLayoutSize = CGSizeZero;

	NSInteger			childRow = 0;
	NSInteger			childColumn = 0;
	CGPoint				childPosition = CGPointZero;
	CGFloat				childFloatWidth = 0.0f;

	NSMutableArray *	childLines = [NSMutableArray array];
	NSMutableArray *	childLine = [NSMutableArray array];
	
	CGFloat				thisBottom = 0.0f;
	CGFloat				lastBottom = 0.0f;

	for ( SamuraiHtmlRenderObject * child in self.source.childs )
	{
		if ( CSSPosition_Static == child.position || CSSPosition_Relative == child.position )
		{
			CGRect			childFrame = CGRectZero;
			CGPoint			childOrigin = CGPointZero;
			CGSize			childBounds = CGSizeZero;
			UIEdgeInsets	childMargin = UIEdgeInsetsZero;

			if ( [child block_shouldWrapBefore] )
			{
				childFloatWidth = 0.0f;
				childPosition.x = 0.0f;
				childPosition.y = maxLayoutSize.height;
				
				if ( [childLine count] )
				{
					[childLines addObject:childLine];
					
					childLine = [NSMutableArray array];
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
				if ( [self.source block_shouldMarginCollapse] && [child block_shouldMarginCollapse] )
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

			childMargin.left += self.computedMargin.left;
			childMargin.left += self.computedBorder.left;
			childMargin.left += self.computedPadding.left;

			childMargin.right += self.computedMargin.right;
			childMargin.right += self.computedBorder.right;
			childMargin.right += self.computedPadding.right;

			childBounds = self.computedSize;

			if ( INVALID_VALUE == childBounds.width )
			{
				childBounds.width = self.bounds.width;
			}

			if ( NO == [child block_isFloating] )
			{
				childBounds.width -= childFloatWidth;
			}
			
			child.layout.bounds		= childBounds;
			child.layout.origin		= childOrigin;
			child.layout.stretch	= CGSizeMake( INVALID_VALUE, INVALID_VALUE );
			child.layout.collapse	= childMargin;

			if ( [child.layout begin:YES] )
			{
				[child.layout layout];
				[child.layout finish];
			}

			childFrame = child.layout.computedBounds;
			thisBottom = fmaxf( thisBottom, child.layout.computedMargin.bottom );

		// compute wrap line
			
			if ( [child block_shouldWrapLine] )
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
							
							childLine = [NSMutableArray array];
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
							if ( [self.source block_shouldMarginCollapse] && [child block_shouldMarginCollapse] )
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

						childMargin.left += self.computedMargin.left;
						childMargin.left += self.computedBorder.left;
						childMargin.left += self.computedPadding.left;
						
						childMargin.right += self.computedMargin.right;
						childMargin.right += self.computedBorder.right;
						childMargin.right += self.computedPadding.right;

						childBounds = self.computedSize;
						
						if ( INVALID_VALUE == childBounds.width )
						{
							childBounds.width = self.bounds.width;
						}
						
						if ( NO == [child block_isFloating] )
						{
							childBounds.width -= childFloatWidth;
						}

						child.layout.bounds		= childBounds;
						child.layout.origin		= childOrigin;
						child.layout.stretch	= CGSizeMake( INVALID_VALUE, INVALID_VALUE );
						child.layout.collapse	= childMargin;
						
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

			if ( [child block_isFloating] )
			{
				childFloatWidth += child.layout.computedBounds.size.width;
			}

			if ( NO == [childLine containsObject:child] )
			{
				[childLine addObject:child];
			}

			if ( [child block_shouldWrapAfter] )
			{
				childFloatWidth = 0.0f;
				childPosition.x = 0.0f;
				childPosition.y += childFrame.size.height;

				if ( [childLine count] )
				{
					[childLines addObject:childLine];

					childLine = [NSMutableArray array];
					childRow += 1;
					childColumn = 0;
					
					lastBottom = thisBottom;
					thisBottom = 0.0f;
				}
			}
			else
			{
				TODO( "ACID1 bug" )

				childPosition.x += childFrame.size.width;
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

// compute content size
	
	CGSize contentSize;
	
	if ( [self.source block_shouldAutoSizing] )
	{
		if ( INVALID_VALUE != self.stretch.width )
		{
			contentSize.width = self.stretch.width;
		}
		else
		{
			contentSize.width = maxLayoutSize.width;
		}
		
		if ( INVALID_VALUE != contentSize.width )
		{
			contentSize.width -= self.computedBorder.left;
			contentSize.width -= self.computedPadding.left;
		}

		if ( INVALID_VALUE != self.stretch.height )
		{
			contentSize.width = self.stretch.height;
		}
		else
		{
			contentSize.height = maxLayoutSize.height;
		}
		
		if ( INVALID_VALUE != contentSize.height )
		{
			contentSize.height -= self.computedBorder.top;
			contentSize.height -= self.computedPadding.top;
		}
	}
	else
	{
		contentSize = self.computedSize;
	
		if ( INVALID_VALUE != self.stretch.width )
		{
			contentSize.width = self.stretch.width;
		}
		else
		{
			if ( [self.source block_shouldAutoWidth] )
			{
				contentSize.width = maxLayoutSize.width;
				
				if ( INVALID_VALUE != contentSize.width )
				{
					contentSize.width -= self.computedBorder.left;
					contentSize.width -= self.computedPadding.left;
				}
			}
		}

		if ( INVALID_VALUE != self.stretch.height )
		{
			contentSize.height = self.stretch.height;
		}
		else
		{
			if ( [self.source block_shouldAutoHeight] )
			{
				contentSize.height = maxLayoutSize.height;
				
				if ( INVALID_VALUE != contentSize.height )
				{
					contentSize.height -= self.computedBorder.top;
					contentSize.height -= self.computedPadding.top;
				}
			}
		}
	}
	
	if ( INVALID_VALUE != self.computedMinWidth && contentSize.width < self.computedMinWidth )
	{
		contentSize.width = self.computedMinWidth;
	}
	
	if ( INVALID_VALUE != self.computedMinHeight && contentSize.height < self.computedMinHeight )
	{
		contentSize.height = self.computedMinHeight;
	}
	
	if ( INVALID_VALUE != self.computedMaxWidth && contentSize.width > self.computedMaxWidth )
	{
		contentSize.width = self.computedMaxWidth;
	}
	
	if ( INVALID_VALUE != self.computedMaxHeight && contentSize.height > self.computedMaxHeight )
	{
		contentSize.height = self.computedMaxHeight;
	}

// compute floating & align

	if ( [self.source block_shouldPositioningChildren] )
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
			
			NSMutableArray * leftFlow = [NSMutableArray array];
			NSMutableArray * rightFlow = [NSMutableArray array];
			NSMutableArray * normalFlow = [NSMutableArray array];
			
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

					if ( [child.layout begin:NO] )
					{
						[child.layout offset:childOffset];
						[child.layout finish];
					}

					floatCenter += child.layout.computedBounds.size.width;
				}
			}

		// align flow

			if ( [self.source block_shouldHorizontalAlign] )
			{
				if ( [self.source block_shouldHorizontalAlignLeft] )
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

						if ( [child.layout begin:NO] )
						{
							[child.layout offset:childOffset];
							[child.layout finish];
						}

						alignLeft += child.layout.computedBounds.size.width;
					}
				}
				else if ( [self.source block_shouldHorizontalAlignRight] )
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

						if ( [child.layout begin:NO] )
						{
							[child.layout offset:childOffset];
							[child.layout finish];
						}

						alignRight -= child.layout.computedBounds.size.width;
					}
				}
				else if ( [self.source block_shouldHorizontalAlignCenter] )
				{
					CGFloat alignCenter = contentLeft + ((contentRight - contentLeft) - centerWidth) / 2.0f;
					
					for ( SamuraiHtmlRenderObject * child in normalFlow )
					{
						CGPoint childOffset;

						childOffset.x = alignCenter;
						childOffset.y = child.layout.origin.y;

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
				if ( [child block_shouldLeftJustifiedInRow] )
				{
					CGPoint childOffset;
					
					childOffset.x = contentLeft;
					childOffset.y = child.layout.origin.y;

					if ( [child.layout begin:NO] )
					{
						[child.layout offset:childOffset];
						[child.layout finish];
					}
				}
				else if ( [child block_shouldRightJustifiedInRow] )
				{
					CGPoint childOffset;
					
					childOffset.x = contentRight - child.layout.computedBounds.size.width;
					childOffset.y = child.layout.origin.y;

					if ( [child.layout begin:NO] )
					{
						[child.layout offset:childOffset];
						[child.layout finish];
					}
				}
				else if ( [child block_shouldCenteringInRow] )
				{
					CGPoint childOffset;

					childOffset.x = contentLeft + ((contentRight - contentLeft) - centerWidth) / 2.0f;
					childOffset.y = child.layout.origin.y;
					
					if ( [child.layout begin:NO] )
					{
						[child.layout offset:childOffset];
						[child.layout finish];
					}
				}
			}
			
		// vertical align flow
			
			if ( [self.source block_shouldVerticalAlign] )
			{
				if ( [self.source block_shouldVerticalAlignTop] )
				{
					for ( SamuraiHtmlRenderObject * child in normalFlow )
					{
						CGPoint childOffset;
						
						childOffset.x = child.layout.origin.x;
						childOffset.y = lineTop;

						if ( [child.layout begin:NO] )
						{
							[child.layout offset:childOffset];
							[child.layout finish];
						}
					}
				}
				else if ( [self.source block_shouldVerticalAlignBottom] )
				{
					for ( SamuraiHtmlRenderObject * child in normalFlow )
					{
						CGPoint childOffset;
						
						childOffset.x = child.layout.origin.x;
						childOffset.y = lineBottom - child.layout.computedBounds.size.height;

						if ( [child.layout begin:NO] )
						{
							[child.layout offset:childOffset];
							[child.layout finish];
						}
					}
				}
				else if ( [self.source block_shouldVerticalAlignMiddle] )
				{
					for ( SamuraiHtmlRenderObject * child in normalFlow )
					{
						CGPoint childOffset;
						
						childOffset.x = child.layout.origin.x;
						childOffset.y = lineTop + (lineHeight - child.layout.computedBounds.size.height) / 2.0f;

						if ( [child.layout begin:NO] )
						{
							[child.layout offset:childOffset];
							[child.layout finish];
						}
					}
				}
				else if ( [self.source block_shouldVerticalAlignBaseline] )
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

				child.layout.bounds		= contentSize;
				child.layout.origin		= childOrigin;
				child.layout.stretch	= CGSizeMake( INVALID_VALUE, INVALID_VALUE );
				child.layout.collapse	= UIEdgeInsetsZero;

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

TEST_CASE( WebCore, HtmlLayoutContainerBlock )

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
