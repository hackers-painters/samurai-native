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

#import "Samurai_HtmlLayoutContainerFlex.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

#undef	HTML_FLEX_MAX_LINES
#define HTML_FLEX_MAX_LINES	(128)

#pragma mark -

typedef struct
{
	CGFloat	grow;
	CGFloat	shrink;
	CGFloat	main;
	CGFloat	cross;
	CGFloat	offset;
	CGFloat	stretch;
} FlexLine;

#pragma mark -

@implementation SamuraiHtmlLayoutContainerFlex

- (void)layout
{
	DEBUG_RENDERER_LAYOUT( self.source );
	
	CGPoint				childPosition = CGPointZero;
	NSMutableArray *	childLines = [NSMutableArray array];
	NSMutableArray *	childLine = [NSMutableArray array];
	NSMutableArray *	childCopy = [NSMutableArray array];

	[childLines addObject:childLine];

	[childCopy addObjectsFromArray:self.source.childs];
	[childCopy sortUsingComparator:^NSComparisonResult( SamuraiHtmlRenderObject * obj1, SamuraiHtmlRenderObject * obj2 ) {
		return obj1.order > obj2.order;
	}];

//	BOOL	arrangedInRow = [self.source flex_shouldArrangedInRow];
	BOOL	arrangedInCol = [self.source flex_shouldArrangedInCol];

	CGSize	maxLayoutSize = CGSizeZero;
	
	CGFloat	maxBoundsRight = 0.0f;
	CGFloat	maxBoundsBottom = 0.0f;

	if ( INVALID_VALUE == self.computedSize.width )
	{
		maxBoundsRight = self.bounds.width;
		
		if ( INVALID_VALUE != maxBoundsRight )
		{
			maxBoundsRight += self.computedPadding.left;
			maxBoundsRight += self.computedBorder.left;
		}
	}
	else
	{
		maxBoundsRight = self.computedSize.width;
	}

	if ( INVALID_VALUE == self.computedSize.height )
	{
		maxBoundsBottom = self.bounds.height;

		if ( INVALID_VALUE != maxBoundsBottom )
		{
			maxBoundsBottom += self.computedPadding.top;
			maxBoundsBottom += self.computedBorder.top;
		}
	}
	else
	{
		maxBoundsBottom = self.computedSize.height;
	}

	for ( SamuraiHtmlRenderObject * child in childCopy )
	{
		CGRect			childFrame = CGRectZero;
		CGPoint			childOrigin = CGPointZero;
		CGSize			childBounds = CGSizeZero;
		UIEdgeInsets	childMargin = UIEdgeInsetsZero;
		
		BOOL			childShouldWrap = NO;
		BOOL			childShouldReverse = NO;
		
		childBounds = self.computedSize;

		if ( arrangedInCol )
		{
			if ( INVALID_VALUE == childBounds.height )
			{
				childBounds.height = self.bounds.height;
			}
		}
		else /* if ( arrangedInRow ) */
		{
			if ( INVALID_VALUE == childBounds.width )
			{
				childBounds.width = self.bounds.width;
			}
		}
		
		childOrigin.x = childPosition.x;
		childOrigin.x += self.computedPadding.left;
		childOrigin.x += self.computedBorder.left;
		
		childOrigin.y = childPosition.y;
		childOrigin.y += self.computedPadding.top;
		childOrigin.y += self.computedBorder.top;

		child.layout.bounds		= childBounds;
		child.layout.origin		= childOrigin;
		child.layout.stretch	= CGSizeMake( INVALID_VALUE, INVALID_VALUE );
		child.layout.collapse	= childMargin;

		if ( [child.layout begin:YES] )
		{
			if ( INVALID_VALUE != child.flexBasis )
			{
				CGSize childSize = child.layout.computedSize;

				if ( arrangedInCol )
				{
					childSize.height = child.flexBasis;

					CGFloat stretchHeight = childSize.height;
					
//					stretchHeight -= child.layout.computedMargin.top;
//					stretchHeight -= child.layout.computedMargin.bottom;
//					stretchHeight -= child.layout.computedBorder.top;
//					stretchHeight -= child.layout.computedBorder.bottom;
//					stretchHeight -= child.layout.computedPadding.top;
//					stretchHeight -= child.layout.computedPadding.bottom;

					[child.layout stretchHeight:stretchHeight];
				}
				else /* if ( arrangedInRow ) */
				{
					childSize.width = child.flexBasis;
					
					CGFloat stretchWidth = childSize.width;
					
//					stretchWidth -= child.layout.computedMargin.left;
//					stretchWidth -= child.layout.computedMargin.right;
//					stretchWidth -= child.layout.computedBorder.left;
//					stretchWidth -= child.layout.computedBorder.right;
//					stretchWidth -= child.layout.computedPadding.left;
//					stretchWidth -= child.layout.computedPadding.right;
					
					[child.layout stretchWidth:stretchWidth];
				}

				[child.layout resize:childSize];
			}

			[child.layout layout];
			[child.layout finish];
		}
		
		childFrame = child.layout.computedBounds;

		if ( [self.source flex_shouldWrap] )
		{
			if ( arrangedInCol )
			{
				if ( INVALID_VALUE != maxBoundsBottom )
				{
					BOOL	childIndex = [childLine indexOfObject:child];
					CGFloat childBottom = CGRectGetMaxY( childFrame );
					
					if ( 0 != childIndex && childBottom > maxBoundsBottom )
					{
						childShouldWrap = YES;
						childShouldReverse = [self.source flex_shouldWrapReverse];
					}
				}
			}
			else /* if ( arrangedInRow ) */
			{
				if ( INVALID_VALUE != maxBoundsRight )
				{
					BOOL	childIndex = [childLine indexOfObject:child];
					CGFloat childRight = CGRectGetMaxX( childFrame );
					
					if ( 0 != childIndex && childRight > maxBoundsRight )
					{
						childShouldWrap = YES;
						childShouldReverse = [self.source flex_shouldWrapReverse];
					}
				}
			}
		}

		if ( childShouldWrap )
		{
			if ( [childLine count] )
			{
				childLine = [NSMutableArray array];
				
				if ( childShouldReverse )
				{
					[childLines insertObject:childLine atIndex:0];
				}
				else
				{
					[childLines addObject:childLine];
				}
			}

			[childLine addObject:child];
			
			childBounds = self.computedSize;

			if ( arrangedInCol )
			{
				childPosition.x = maxLayoutSize.width;
				childPosition.y = 0.0f;

				if ( INVALID_VALUE == childBounds.width )
				{
					childBounds.width = self.bounds.width;
				}
			}
			else
			{
				childPosition.x = 0.0f;
				childPosition.y = maxLayoutSize.height;
				
				if ( INVALID_VALUE == childBounds.width )
				{
					childBounds.width = self.bounds.width;
				}
			}

			childOrigin.x = childPosition.x;
			childOrigin.x += self.computedPadding.left;
			childOrigin.x += self.computedBorder.left;
			
			childOrigin.y = childPosition.y;
			childOrigin.y += self.computedPadding.top;
			childOrigin.y += self.computedBorder.top;

			child.layout.bounds		= childBounds;
			child.layout.origin		= childOrigin;
			child.layout.stretch	= CGSizeMake( INVALID_VALUE, INVALID_VALUE );
			child.layout.collapse	= childMargin;

			if ( [child.layout begin:YES] )
			{
				if ( INVALID_VALUE != child.flexBasis )
				{
					CGSize childSize = child.layout.computedSize;
					
					if ( arrangedInCol )
					{
						childSize.height = child.flexBasis;
						
						CGFloat stretchHeight = childSize.height;
						
//						stretchHeight -= child.layout.computedMargin.top;
//						stretchHeight -= child.layout.computedMargin.bottom;
//						stretchHeight -= child.layout.computedBorder.top;
//						stretchHeight -= child.layout.computedBorder.bottom;
//						stretchHeight -= child.layout.computedPadding.top;
//						stretchHeight -= child.layout.computedPadding.bottom;
							
						[child.layout stretchHeight:stretchHeight];
					}
					else /* if ( arrangedInRow ) */
					{
						childSize.width = child.flexBasis;
						
						CGFloat stretchWidth = childSize.width;
						
//						stretchWidth -= child.layout.computedMargin.left;
//						stretchWidth -= child.layout.computedMargin.right;
//						stretchWidth -= child.layout.computedBorder.left;
//						stretchWidth -= child.layout.computedBorder.right;
//						stretchWidth -= child.layout.computedPadding.left;
//						stretchWidth -= child.layout.computedPadding.right;
						
						[child.layout stretchWidth:stretchWidth];
					}
					
					[child.layout resize:childSize];
				}

				[child.layout layout];
				[child.layout finish];
			}

			childFrame = child.layout.computedBounds;
		}
		else
		{
			[childLine addObject:child];
		}
		
		if ( arrangedInCol )
		{
			childPosition.y += childFrame.size.height;
		}
		else /* if ( arrangedInRow ) */
		{
			childPosition.x += childFrame.size.width;
		}

		maxLayoutSize.width = fmaxf( CGRectGetMaxX(childFrame), maxLayoutSize.width );
		maxLayoutSize.height = fmaxf( CGRectGetMaxY(childFrame), maxLayoutSize.height );
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

		if ( INVALID_VALUE != self.stretch.height )
		{
			contentSize.height = self.stretch.height;
		}
		else
		{
			contentSize.height = maxLayoutSize.height;
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
				if ( INVALID_VALUE != self.bounds.width )
				{
					contentSize.width = self.bounds.width;
				}
				else
				{
					contentSize.width = maxLayoutSize.width;
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
			}
		}
	}

	if ( INVALID_VALUE != self.bounds.width )
	{
		if ( contentSize.width > self.bounds.width )
		{
			contentSize.width = self.bounds.width;
		}
	}

	if ( INVALID_VALUE != contentSize.width )
	{
		contentSize.width -= self.computedBorder.left;
		contentSize.width -= self.computedBorder.right;
		contentSize.width -= self.computedPadding.left;
		contentSize.width -= self.computedPadding.right;
	}

//	if ( INVALID_VALUE != contentSize.height )
//	{
//		contentSize.height -= self.computedBorder.top;
//		contentSize.height -= self.computedBorder.bottom;
//		contentSize.height -= self.computedPadding.top;
//		contentSize.height -= self.computedPadding.bottom;
//	}

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
	
// compute cross size

	CGFloat		flexCross = 0.0f;
	FlexLine	flexLines[HTML_FLEX_MAX_LINES] = { 0 };
	
	for ( NSMutableArray * line in childLines )
	{
		NSUInteger index = [childLines indexOfObject:line];
		
		if ( 0 == [line count] )
			continue;

		CGFloat	lineGrow = 0.0f;
		CGFloat	lineShrink = 0.0f;
		CGFloat	lineMainSize = 0.0f;
		CGFloat	lineCrossSize = 0.0f;
		
		for ( SamuraiHtmlRenderObject * child in line )
		{
			lineGrow += child.flexGrow;
			lineShrink += child.flexShrink;
			
			if ( arrangedInCol )
			{
				lineMainSize += child.layout.computedBounds.size.height;
				lineCrossSize = fmaxf( child.layout.computedBounds.size.width, lineCrossSize );
			}
			else /* if ( arrangedInRow ) */
			{
				lineMainSize += child.layout.computedBounds.size.width;
				lineCrossSize = fmaxf( child.layout.computedBounds.size.height, lineCrossSize );
			}
		}
		
		flexCross += lineCrossSize;

		flexLines[index].grow		= lineGrow;
		flexLines[index].shrink		= lineShrink;
		flexLines[index].main		= lineMainSize;
		flexLines[index].cross		= lineCrossSize;
		flexLines[index].offset		= 0.0f;
		flexLines[index].stretch	= lineCrossSize;
	}

// align content
	
	CGFloat contentTop = 0.0f;
	CGFloat contentLeft = 0.0f;
	CGFloat contentRight = 0.0f;
	CGFloat contentBottom = 0.0f;
	
	contentTop += self.computedBorder.top;
	contentTop += self.computedPadding.top;
	
	contentLeft += self.computedBorder.left;
	contentLeft += self.computedPadding.left;
	
	contentRight += contentSize.width;
	contentRight += self.computedPadding.left;
	contentRight += self.computedBorder.left;
	
	contentBottom += contentSize.height;
	contentBottom += self.computedPadding.top;
	contentBottom += self.computedBorder.top;

	if ( CSSAlignContent_FlexStart == self.source.alignContent )
	{
		CGFloat lineOffset = 0.0f;
		
		for ( NSMutableArray * line in childLines )
		{
			NSUInteger index = [childLines indexOfObject:line];
			
			if ( 0 == [line count] )
				continue;

			flexLines[index].offset = lineOffset;
			
			lineOffset += flexLines[index].cross;
		}
	}
	else if ( CSSAlignContent_FlexEnd == self.source.alignContent )
	{
		CGFloat lineOffset = contentBottom;
		
		for ( NSMutableArray * line in [childLines reverseObjectEnumerator] )
		{
			NSUInteger index = [childLines indexOfObject:line];
			
			if ( 0 == [line count] )
				continue;

			flexLines[index].offset = lineOffset - flexLines[index].cross;

			lineOffset -= flexLines[index].cross;
		}
	}
	else if ( CSSAlignContent_Center == self.source.alignContent )
	{
		CGFloat lineOffset = 0.0f;
		
		if ( arrangedInCol )
		{
			lineOffset = (contentSize.width - flexCross) / 2.0f;
		}
		else
		{
			lineOffset = (contentSize.height - flexCross) / 2.0f;
		}

		for ( NSMutableArray * line in childLines )
		{
			NSUInteger index = [childLines indexOfObject:line];
			
			if ( 0 == [line count] )
				continue;

			flexLines[index].offset = lineOffset;
			
			lineOffset += flexLines[index].cross;
		}
	}
	else if ( CSSAlignContent_Stretch == self.source.alignContent )
	{
		CGFloat crossSpace = 0.0f;
		
		if ( [childLines count] > 0 )
		{
			if ( arrangedInCol )
			{
				crossSpace = (contentSize.width - flexCross) / [childLines count];
			}
			else /* if ( arrangedInRow ) */
			{
				crossSpace = (contentSize.height - flexCross) / [childLines count];
			}
			
			if ( crossSpace < 0.0f  )
			{
				crossSpace = 0.0f;
			}
		}
		
		CGFloat lineOffset = 0.0f;
		
		for ( NSMutableArray * line in childLines )
		{
			NSUInteger index = [childLines indexOfObject:line];
			
			if ( 0 == [line count] )
				continue;

			flexLines[index].offset = lineOffset;
			flexLines[index].stretch = flexLines[index].cross + crossSpace;

			lineOffset += flexLines[index].cross;
			lineOffset += crossSpace;
		}
	}
	else if ( CSSAlignContent_SpaceBetween == self.source.alignContent )
	{
		CGFloat crossSpace = 0.0f;
		
		if ( [childLines count] > 1 )
		{
			if ( arrangedInCol )
			{
				crossSpace = (contentSize.width - flexCross) / ([childLines count] - 1);
			}
			else /* if ( arrangedInRow ) */
			{
				crossSpace = (contentSize.height - flexCross) / ([childLines count] - 1);
			}
			
			if ( crossSpace < 0.0f  )
			{
				crossSpace = 0.0f;
			}
		}
		
		CGFloat lineOffset = 0.0f;
		
		for ( NSMutableArray * line in childLines )
		{
			NSUInteger index = [childLines indexOfObject:line];
			
			if ( 0 == [line count] )
				continue;
			
			flexLines[index].offset = lineOffset;

			lineOffset += flexLines[index].cross;
			lineOffset += crossSpace;
		}
	}
	else if ( CSSAlignContent_SpaceAround == self.source.alignContent )
	{
		CGFloat crossSpace = 0.0f;
		
		if ( arrangedInCol )
		{
			crossSpace = (contentSize.width - flexCross) / ([childLines count] * 2);
		}
		else /* if ( arrangedInRow ) */
		{
			crossSpace = (contentSize.height - flexCross) / ([childLines count] * 2);
		}
		
		if ( crossSpace < 0.0f  )
		{
			crossSpace = 0.0f;
		}
		
		CGFloat lineOffset = crossSpace;
		
		for ( NSMutableArray * line in childLines )
		{
			NSUInteger index = [childLines indexOfObject:line];
			
			if ( 0 == [line count] )
				continue;
			
			flexLines[index].offset = lineOffset;
			
			lineOffset += flexLines[index].cross;
			lineOffset += crossSpace * 2.0f;
		}
	}

// align items
	
	for ( NSMutableArray * line in childLines )
	{
		NSUInteger index = [childLines indexOfObject:line];

		if ( 0 == [line count] )
			continue;
		
		CGFloat	mainSpace = 0.0f;
		CGFloat	growSpace = 0.0f;
		CGFloat	shrinkSpace = 0.0f;

		if ( arrangedInCol )
		{
			mainSpace = contentSize.height - flexLines[index].main;
		}
		else /* if ( arrangedInRow ) */
		{
			mainSpace = contentSize.width - flexLines[index].main;
		}

		if ( mainSpace > 0.0f )
		{
			if ( flexLines[index].grow > 0.0f )
			{
				growSpace = fabs( mainSpace ) / flexLines[index].grow;
			}
		}
		else if ( mainSpace < 0.0f )
		{
			if ( flexLines[index].shrink > 0.0f )
			{
				shrinkSpace = fabs( mainSpace ) / flexLines[index].shrink;
			}
		}

		CGFloat alignTop = contentTop;
		CGFloat alignLeft = contentLeft;
		CGFloat alignRight = contentRight;
		CGFloat alignBottom = contentBottom;

		for ( SamuraiHtmlRenderObject * child in line )
		{
			CGPoint childOffset = child.layout.origin;
			CGSize	childSize = child.layout.computedBounds.size;

		// remain space grow

			if ( mainSpace > 0.0f )
			{
				CGFloat childGrowSpace = growSpace * child.flexGrow;
				
				if ( arrangedInCol )
				{
					childSize.height += childGrowSpace;
					
					CGFloat stretchHeight = childSize.height;
					
					stretchHeight -= child.layout.computedMargin.top;
					stretchHeight -= child.layout.computedMargin.bottom;
					stretchHeight -= child.layout.computedBorder.top;
					stretchHeight -= child.layout.computedBorder.bottom;
					stretchHeight -= child.layout.computedPadding.top;
					stretchHeight -= child.layout.computedPadding.bottom;
					
					if ( stretchHeight < 0.0f )
					{
						stretchHeight = 0.0f;
					}

					[child.layout stretchHeight:stretchHeight];
				}
				else /* if ( arrangedInRow ) */
				{
					childSize.width += childGrowSpace;
					
					CGFloat stretchWidth = childSize.width;

					stretchWidth -= child.layout.computedMargin.left;
					stretchWidth -= child.layout.computedMargin.right;
					stretchWidth -= child.layout.computedBorder.left;
					stretchWidth -= child.layout.computedBorder.right;
					stretchWidth -= child.layout.computedPadding.left;
					stretchWidth -= child.layout.computedPadding.right;
					
					if ( stretchWidth < 0.0f )
					{
						stretchWidth = 0.0f;
					}

					[child.layout stretchWidth:stretchWidth];
				}

				mainSpace -= childGrowSpace;
			}
			else if ( mainSpace < 0.0f )
			{
				CGFloat childShrinkSpace = shrinkSpace * child.flexShrink;
				
				if ( arrangedInCol )
				{
					childSize.height -= childShrinkSpace;
					
					CGFloat stretchHeight = childSize.height;
					
					stretchHeight -= child.layout.computedMargin.top;
					stretchHeight -= child.layout.computedMargin.bottom;
					stretchHeight -= child.layout.computedBorder.top;
					stretchHeight -= child.layout.computedBorder.bottom;
					stretchHeight -= child.layout.computedPadding.top;
					stretchHeight -= child.layout.computedPadding.bottom;
					
					if ( stretchHeight < 0.0f )
					{
						stretchHeight = 0.0f;
					}

//					if ( INVALID_VALUE != child.flexBasis && stretchHeight < child.flexBasis )
//					{
//						stretchHeight = child.flexBasis;
//					}

					[child.layout stretchHeight:stretchHeight];
				}
				else /* if ( arrangedInRow ) */
				{
					childSize.width -= childShrinkSpace;
					
					CGFloat stretchWidth = childSize.width;
					
					stretchWidth -= child.layout.computedMargin.left;
					stretchWidth -= child.layout.computedMargin.right;
					stretchWidth -= child.layout.computedBorder.left;
					stretchWidth -= child.layout.computedBorder.right;
					stretchWidth -= child.layout.computedPadding.left;
					stretchWidth -= child.layout.computedPadding.right;
					
					if ( stretchWidth < 0.0f )
					{
						stretchWidth = 0.0f;
					}
					
//					if ( INVALID_VALUE != child.flexBasis && stretchWidth < child.flexBasis )
//					{
//						stretchWidth = child.flexBasis;
//					}

					[child.layout stretchWidth:stretchWidth];
				}

				mainSpace += childShrinkSpace;
			}

		// align by cross axis

			if ( CSSAlignSelf_Auto == child.alignSelf )
			{
				if ( CSSAlignItems_FlexStart == self.source.alignItems )
				{
					if ( arrangedInCol )
					{
						childOffset.x = alignLeft;
					}
					else /* if ( arrangedInRow ) */
					{
						childOffset.y = alignTop;
					}
				}
				else if ( CSSAlignItems_FlexEnd == self.source.alignItems )
				{
					if ( arrangedInCol )
					{
						childOffset.x = alignRight - childSize.width;
					}
					else /* if ( arrangedInRow ) */
					{
						childOffset.y = alignBottom - childSize.height;
					}
				}
				else if ( CSSAlignItems_Center == self.source.alignItems )
				{
					if ( arrangedInCol )
					{
						childOffset.x = (flexLines[index].stretch - childSize.width) / 2.0f;
					}
					else /* if ( arrangedInRow ) */
					{
						childOffset.y = (flexLines[index].stretch - childSize.height) / 2.0f;
					}
				}
				else if ( CSSAlignItems_Baseline == self.source.alignItems )
				{
					if ( arrangedInCol )
					{
						childOffset.x = (flexLines[index].stretch - childSize.width) / 2.0f;
					}
					else /* if ( arrangedInRow ) */
					{
						childOffset.y = (flexLines[index].stretch - childSize.height) / 2.0f;
					}
				}
				else if ( CSSAlignItems_Stretch == self.source.alignItems )
				{
					if ( arrangedInCol )
					{
						childOffset.x = alignLeft;
						
						if ( nil == child.style.width || [child.style.width isAutomatic] )
						{
							childSize.width = flexLines[index].stretch;
							
							CGFloat stretchWidth = childSize.width;
							
							stretchWidth -= child.layout.computedMargin.left;
							stretchWidth -= child.layout.computedMargin.right;
							stretchWidth -= child.layout.computedBorder.left;
							stretchWidth -= child.layout.computedBorder.right;
							stretchWidth -= child.layout.computedPadding.left;
							stretchWidth -= child.layout.computedPadding.right;
							
							if ( stretchWidth < 0.0f )
							{
								stretchWidth = 0.0f;
							}

							[child.layout stretchWidth:stretchWidth];
						}
					}
					else /* if ( arrangedInRow ) */
					{
						childOffset.y = alignTop;
						
						if ( nil == child.style.height || [child.style.height isAutomatic] )
						{
							childSize.height = flexLines[index].stretch;
							
							CGFloat stretchHeight = childSize.height;
							
							stretchHeight -= child.layout.computedMargin.top;
							stretchHeight -= child.layout.computedMargin.bottom;
							stretchHeight -= child.layout.computedBorder.top;
							stretchHeight -= child.layout.computedBorder.bottom;
							stretchHeight -= child.layout.computedPadding.top;
							stretchHeight -= child.layout.computedPadding.bottom;
							
							if ( stretchHeight < 0.0f )
							{
								stretchHeight = 0.0f;
							}

							[child.layout stretchHeight:stretchHeight];
						}
					}
				}
			}
			else if ( CSSAlignSelf_FlexStart == child.alignSelf )
			{
				if ( arrangedInCol )
				{
					childOffset.x = alignLeft;
				}
				else /* if ( arrangedInRow ) */
				{
					childOffset.y = alignTop;
				}
			}
			else if ( CSSAlignSelf_FlexEnd == child.alignSelf )
			{
				if ( arrangedInCol )
				{
					childOffset.x = alignRight - childSize.width;
				}
				else /* if ( arrangedInRow ) */
				{
					childOffset.y = alignBottom - childSize.height;
				}
			}
			else if ( CSSAlignSelf_Center == child.alignSelf )
			{
				if ( arrangedInCol )
				{
					childOffset.x = (flexLines[index].stretch - childSize.width) / 2.0f;
				}
				else /* if ( arrangedInRow ) */
				{
					childOffset.y = (flexLines[index].stretch - childSize.height) / 2.0f;
				}
			}
			else if ( CSSAlignSelf_Baseline == child.alignSelf )
			{
				if ( arrangedInCol )
				{
					childOffset.x = (flexLines[index].stretch - childSize.width) / 2.0f;
				}
				else /* if ( arrangedInRow ) */
				{
					childOffset.y = (flexLines[index].stretch - childSize.height) / 2.0f;
				}
			}
			else if ( CSSAlignSelf_Stretch == child.alignSelf )
			{
				if ( arrangedInCol )
				{
					childOffset.x = alignLeft;

					childSize.width = flexLines[index].stretch;
					
					CGFloat stretchWidth = childSize.width;
					
					stretchWidth -= child.layout.computedMargin.left;
					stretchWidth -= child.layout.computedMargin.right;
					stretchWidth -= child.layout.computedBorder.left;
					stretchWidth -= child.layout.computedBorder.right;
					stretchWidth -= child.layout.computedPadding.left;
					stretchWidth -= child.layout.computedPadding.right;
					
					if ( stretchWidth < 0.0f )
					{
						stretchWidth = 0.0f;
					}

					[child.layout stretchWidth:stretchWidth];
				}
				else /* if ( arrangedInRow ) */
				{
					childOffset.y = alignTop;
					
					childSize.height = flexLines[index].stretch;
					
					CGFloat stretchHeight = childSize.height;
					
					stretchHeight -= child.layout.computedMargin.top;
					stretchHeight -= child.layout.computedMargin.bottom;
					stretchHeight -= child.layout.computedBorder.top;
					stretchHeight -= child.layout.computedBorder.bottom;
					stretchHeight -= child.layout.computedPadding.top;
					stretchHeight -= child.layout.computedPadding.bottom;
					
					if ( stretchHeight < 0.0f )
					{
						stretchHeight = 0.0f;
					}

					[child.layout stretchHeight:stretchHeight];
				}
			}

		// align by main axis

			if ( CSSJustifyContent_FlexStart == self.source.justifyContent )
			{
				if ( [self.source flex_shouldArrangedReverse] )
				{
					if ( arrangedInCol )
					{
						childOffset.y = alignBottom - childSize.height;
						
						alignBottom -= childSize.height;
					}
					else /* if ( arrangedInRow ) */
					{
						childOffset.x = alignRight - childSize.width;
						
						alignRight -= childSize.width;
					}
				}
				else
				{
					if ( arrangedInCol )
					{
						childOffset.y = alignTop;
						
						alignTop += childSize.height;
					}
					else /* if ( arrangedInRow ) */
					{
						childOffset.x = alignLeft;
						
						alignLeft += childSize.width;
					}
				}
			}
			else if ( CSSJustifyContent_FlexEnd == self.source.justifyContent )
			{
				if ( arrangedInCol )
				{
					childOffset.y = alignBottom - childSize.height;
					
					alignBottom -= childSize.height;
				}
				else /* if ( arrangedInRow ) */
				{
					childOffset.x = alignRight - childSize.width;

					alignRight -= childSize.width;
				}
			}
			else if ( CSSJustifyContent_Center == self.source.justifyContent )
			{
				if ( arrangedInCol )
				{
					childOffset.y = mainSpace / 2.0f + alignTop;

					alignTop += childSize.height;
				}
				else /* if ( arrangedInRow ) */
				{
					childOffset.x = mainSpace / 2.0f + alignLeft;
					
					alignLeft += childSize.width;
				}
			}
			else if ( CSSJustifyContent_SpaceBetween == self.source.justifyContent )
			{
				CGFloat spaceBetween = [line count] > 1 ? (mainSpace / ([line count] - 1)) : 0.0f;
				
				if ( arrangedInCol )
				{
					childOffset.y = alignTop;
					
					alignTop += childSize.height;
					alignTop += spaceBetween;
				}
				else /* if ( arrangedInRow ) */
				{
					childOffset.x = alignLeft;
					
					alignLeft += childSize.width;
					alignLeft += spaceBetween;
				}
			}
			else if ( CSSJustifyContent_SpaceAround == self.source.justifyContent )
			{
				CGFloat spaceAround = mainSpace / ([line count] * 2);

				if ( arrangedInCol )
				{
					childOffset.y = spaceAround + alignTop;
					
					alignTop += childSize.height;
					alignTop += spaceAround * 2;
				}
				else /* if ( arrangedInRow ) */
				{
					childOffset.x = spaceAround + alignLeft;
					
					alignLeft += childSize.width;
					alignLeft += spaceAround * 2;
				}
			}

			if ( arrangedInCol )
			{
				childOffset.x += flexLines[index].offset;
			}
			else
			{
				childOffset.y += flexLines[index].offset;
			}

		// relayout

			if ( [child.layout begin:NO] )
			{
				[child.layout offset:childOffset];

				BOOL changed = [child.layout resize:childSize];
				if ( changed )
				{
					[child.layout layout];
				}
				
				[child.layout finish];
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

TEST_CASE( WebCore, HtmlLayoutContainerFlex )

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
