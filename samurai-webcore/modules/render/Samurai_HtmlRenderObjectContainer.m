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

#import "Samurai_HtmlRenderObjectContainer.h"
#import "Samurai_HtmlRenderObjectViewport.h"
#import "Samurai_HtmlRenderObjectElement.h"
#import "Samurai_HtmlRenderObjectTable.h"
#import "Samurai_HtmlRenderObjectText.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "HtmlContainer.h"

#import "Samurai_HtmlRenderScope.h"
#import "Samurai_HtmlRenderStore.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiHtmlRenderObjectContainer

+ (instancetype)renderObjectWithDom:(SamuraiHtmlDomNode *)dom andStyle:(SamuraiHtmlStyle *)style
{
	SamuraiHtmlRenderObjectContainer * renderObject = [super renderObjectWithDom:dom andStyle:style];
	
	return renderObject;
}

#pragma mark -

- (id)init
{
	self = [super init];
	if ( self )
	{
	}
	return self;
}

- (void)dealloc
{
}

#pragma mark -

+ (Class)defaultViewClass
{
	return [HtmlContainer class];
}

#pragma mark -

- (UIView *)createViewWithIdentifier:(NSString *)identifier
{
	return [super createViewWithIdentifier:identifier];
}

#pragma mark -

- (BOOL)html_hasChildren
{
	return YES;
}

#pragma mark -

- (void)renderWillLoad
{
	[super renderWillLoad];
}

- (void)renderDidLoad
{
	[super renderDidLoad];
}

#pragma mark -

- (BOOL)layoutShouldWrapLine
{
	return [super layoutShouldWrapLine];
}

- (BOOL)layoutShouldWrapBefore
{
	return [super layoutShouldWrapBefore];
}

- (BOOL)layoutShouldWrapAfter
{
	return [super layoutShouldWrapAfter];
}

- (BOOL)layoutShouldAutoSizing
{
	return [super layoutShouldAutoSizing];
}

- (BOOL)layoutShouldCenteringInRow
{
	return [super layoutShouldCenteringInRow];
}

- (BOOL)layoutShouldCenteringInCol
{
	return [super layoutShouldCenteringInCol];
}

- (BOOL)layoutShouldLeftJustifiedInRow
{
	return [super layoutShouldLeftJustifiedInRow];
}

- (BOOL)layoutShouldRightJustifiedInRow
{
	return [super layoutShouldRightJustifiedInRow];
}

- (BOOL)layoutShouldPositioningChildren
{
	return [super layoutShouldPositioningChildren];
}

- (BOOL)layoutShouldArrangedInRow
{
	return [super layoutShouldArrangedInRow];
}

- (BOOL)layoutShouldArrangedInCol
{
	return [super layoutShouldArrangedInCol];
}

- (BOOL)layoutShouldArrangedReverse
{
	return [super layoutShouldArrangedReverse];
}

- (BOOL)layoutShouldHorizontalAlign
{
	return [super layoutShouldHorizontalAlign];
}

- (BOOL)layoutShouldHorizontalAlignLeft
{
	return [super layoutShouldHorizontalAlignLeft];
}

- (BOOL)layoutShouldHorizontalAlignRight
{
	return [super layoutShouldHorizontalAlignRight];
}

- (BOOL)layoutShouldHorizontalAlignCenter
{
	return [super layoutShouldHorizontalAlignCenter];
}

- (BOOL)layoutShouldVerticalAlign
{
	return [super layoutShouldVerticalAlign];
}

- (BOOL)layoutShouldVerticalAlignTop
{
	return [super layoutShouldVerticalAlignTop];
}

- (BOOL)layoutShouldVerticalAlignMiddle
{
	return [super layoutShouldVerticalAlignMiddle];
}

- (BOOL)layoutShouldVerticalAlignBottom
{
	return [super layoutShouldVerticalAlignBottom];
}

#pragma mark -

- (CGRect)layoutWithContext:(SamuraiHtmlLayoutContext *)context
			  parentContext:(SamuraiHtmlLayoutContext *)parentContext
{
	DEBUG_RENDERER_LAYOUT( self );
	
	htmlLayoutInit( context );

	NSMutableArray * childLines = [NSMutableArray array];
	
	if ( HtmlRenderDisplay_None != self.display )
	{
		htmlLayoutBegin( context );

		CGSize				maxLayoutSize = CGSizeZero;
//		CGSize				maxContentSize = CGSizeZero;

		NSInteger			childRow = 0;
		NSInteger			childColumn = 0;
		CGPoint				childPosition = CGPointZero;

		NSMutableArray *	childLine = [NSMutableArray array];
		NSEnumerator *		childEnumerator = nil;
		
		CGFloat				thisBottom = 0.0f;
		CGFloat				lastBottom = 0.0f;
		
		if ( [self layoutShouldArrangedReverse] )
		{
			childEnumerator = [self.childs reverseObjectEnumerator];
		}
		else
		{
			childEnumerator = [self.childs objectEnumerator];
		}
		
		for ( SamuraiHtmlRenderObject * child in childEnumerator )
		{
			if ( HtmlRenderDisplay_None == child.display )
			{
				SamuraiHtmlLayoutContext hiddenContext = {
					.style		= child.style,
					.bounds		= CGSizeZero,
					.origin		= CGPointZero,
					.collapse	= UIEdgeInsetsZero
				};

				[child layoutWithContext:&hiddenContext parentContext:context];
				continue;
			}
			
//			SamuraiHtmlRenderObject * prevSibling = child.prev;
//			SamuraiHtmlRenderObject * nextSibling = child.next;

			if ( HtmlRenderPosition_Static == child.position || HtmlRenderPosition_Relative == child.position )
			{
				CGRect			childFrame = CGRectZero;
				CGPoint			childOrigin = CGPointZero;
				CGSize			childBounds = CGSizeZero;
				UIEdgeInsets	childMargin = UIEdgeInsetsZero;

				if ( [child layoutShouldWrapBefore] )
				{
					BOOL shouldWrapBefore = YES;
					
//					if ( prevSibling && prevSibling.floating == child.floating )
//					{
//						shouldWrapBefore = YES;
//					}
					
					if ( shouldWrapBefore )
					{
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
				}

				childOrigin.x = childPosition.x;
				childOrigin.x += context->computedPadding.left;
				childOrigin.x += context->computedBorder.left;

				childOrigin.y = childPosition.y;
				childOrigin.y += context->computedPadding.top;
				childOrigin.y += context->computedBorder.top;

				if ( 0 == childRow )
				{
					childMargin.top = parentContext ? parentContext->computedMargin.top : 0.0f;
				}
				else
				{
					childMargin.top = lastBottom;
				}
				
				childBounds = context->computedSize;
				
				if ( INVALID_VALUE == childBounds.width )
				{
					childBounds.width = context->bounds.width;
				}

				SamuraiHtmlLayoutContext childContext = {
					.style		= child.style,
					.bounds		= childBounds,
					.origin		= childOrigin,
					.collapse	= childMargin
				};

				childFrame = [child layoutWithContext:&childContext parentContext:context];
				thisBottom = fmaxf( thisBottom, childContext.computedMargin.bottom );

			// compute wrap line
				
				if ( [child layoutShouldWrapLine] )
				{
					BOOL shouldBreakLine = NO;

					if ( 0 != childColumn )
					{
						if ( INVALID_VALUE != childBounds.width )
						{
							if ( CGRectGetMaxX( childFrame ) > childBounds.width )
							{
								shouldBreakLine = YES;
							}
						}

						if ( shouldBreakLine )
						{
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
							childOrigin.x += context->computedPadding.left;
							childOrigin.x += context->computedBorder.left;
							
							childOrigin.y = childPosition.y;
							childOrigin.y += context->computedPadding.top;
							childOrigin.y += context->computedBorder.top;

							if ( 0 == childRow )
							{
								childMargin.top = parentContext ? parentContext->computedMargin.top : 0.0f;
							}
							else
							{
								childMargin.top = lastBottom;
							}

							childBounds = context->computedSize;
							
							if ( INVALID_VALUE == childBounds.width )
							{
								childBounds.width = context->bounds.width;
							}

							SamuraiHtmlLayoutContext recalcContext = {
								.style		= child.style,
								.bounds		= childBounds,
								.origin		= childOrigin,
								.collapse	= childMargin
							};

							childFrame = [child layoutWithContext:&recalcContext parentContext:context];
							thisBottom = fmaxf( thisBottom, recalcContext.computedMargin.bottom );
							
							childContext = recalcContext;
						}
					}
				}
				
				if ( NO == [childLine containsObject:child] )
				{
					[childLine addObject:child];
				}

				if ( [child layoutShouldWrapAfter] )
				{
					BOOL shouldWrapAfter = YES;
					
//					if ( nextSibling && nextSibling.floating == child.floating )
//					{
//						shouldWrapAfter = YES;
//					}
					
					if ( shouldWrapAfter )
					{
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
				}
				else
				{
					if ( [self layoutShouldArrangedInRow] )
					{
						childPosition.x += childFrame.size.width;
						
					//	childPosition.x = fminf( childPosition.x + childFrame.size.width, child.end.x );
					//	childPosition.y = fminf( childPosition.y + childFrame.size.height, child.end.y );
					}
					else if ( [self layoutShouldArrangedInCol] )
					{
						childPosition.y += childFrame.size.height;
					}
					else
					{
					//	childPosition.x = fminf( childPosition.x + childFrame.size.width, child.end.x );
					//	childPosition.y = fminf( childPosition.y + childFrame.size.height, child.end.y );

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
			}
			else if ( HtmlRenderPosition_Absolute == child.position )
			{
			//	TODO( "absolute" )
			}
			else if ( HtmlRenderPosition_Fixed == child.position )
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

	// resize

		DEBUG_RENDERER_LAYOUT( self );

		if ( [self layoutShouldAutoSizing] )
		{
			htmlLayoutResize( context, maxLayoutSize );
		}
		else
		{
			CGSize layoutSize = context->computedSize;

			if ( [self.style isAutoWidth] )
			{
				layoutSize.width = maxLayoutSize.width;
			}
			
			if ( [self.style isAutoHeight] )
			{
				layoutSize.height = maxLayoutSize.height;
			}
			
			htmlLayoutResize( context, layoutSize );
		}

	// compute floating & align

		if ( [self layoutShouldPositioningChildren] )
		{
			for ( NSMutableArray * line in childLines )
			{
				CGFloat lineWidth = context->computedSize.width;
				CGFloat lineHeight = 0.0f;
				
				CGFloat lineTop = INVALID_VALUE;
				CGFloat lineBottom = INVALID_VALUE;
				
				CGFloat	leftWidth = 0.0f;
				CGFloat	rightWidth = 0.0f;
				CGFloat	centerWidth = 0.0f;
				
				lineWidth += context->computedPadding.left;
				lineWidth += context->computedPadding.right;
				lineWidth += context->computedBorder.left;
				lineWidth += context->computedBorder.right;
			//	lineWidth += context->computedMargin.left;
			//	lineWidth += context->computedMargin.right;

				CGFloat contentLeft = 0.0f;
				CGFloat contentRight = lineWidth;
				
				NSMutableArray * leftFlow = [NSMutableArray nonRetainingArray];
				NSMutableArray * rightFlow = [NSMutableArray nonRetainingArray];
				NSMutableArray * normalFlow = [NSMutableArray nonRetainingArray];
				
				for ( SamuraiHtmlRenderObject * child in line )
				{
					if ( HtmlRenderDisplay_None == child.display )
						continue;

					if ( INVALID_VALUE == lineTop )
					{
						lineTop = child.bounds.origin.y;
					}
					else
					{
						lineTop = fmin( lineTop, child.bounds.origin.y );
					}

					if ( INVALID_VALUE == lineBottom )
					{
						lineBottom = child.bounds.origin.y + child.bounds.size.height;
					}
					else
					{
						lineBottom = fmin( lineTop, child.bounds.origin.y + child.bounds.size.height );
					}

					lineHeight = fmax( lineHeight, child.bounds.size.height );

					if ( HtmlRenderFloating_Left == child.floating )
					{
						leftWidth += child.bounds.size.width;
						
						[leftFlow addObject:child];
					}
					else if ( HtmlRenderFloating_Right == child.floating )
					{
						rightWidth += child.bounds.size.width;
						
						[rightFlow addObject:child];
					}
					else if ( HtmlRenderFloating_None == child.floating )
					{
						centerWidth += child.bounds.size.width;
						
						[normalFlow addObject:child];
					}
				}
				
			// floating flow

				if ( [leftFlow count] || [rightFlow count] )
				{
					CGFloat floatingLeft = 0.0f;
					CGFloat floatingRight = lineWidth;

					floatingLeft += context->computedBorder.left;
				//	floatingLeft += context->computedMargin.left;
					floatingLeft += context->computedPadding.left;

					floatingRight -= context->computedBorder.right;
				//	floatingRight -= context->computedMargin.right;
					floatingRight -= context->computedPadding.right;

					for ( SamuraiHtmlRenderObject * child in leftFlow )
					{
						CGRect childBounds = child.bounds;
						childBounds.origin.x = floatingLeft;
						child.bounds = childBounds;

						floatingLeft += childBounds.size.width;
					}

					for ( SamuraiHtmlRenderObject * child in rightFlow )
					{
						CGRect childBounds = child.bounds;
						childBounds.origin.x = floatingRight - childBounds.size.width;
						child.bounds = childBounds;

						floatingRight -= childBounds.size.width;
					}
					
					if ( [leftFlow count] )
					{
						contentLeft = floatingLeft;
					}
					else
					{
						contentLeft += context->computedBorder.left;
					//	contentLeft += context->computedMargin.left;
						contentLeft += context->computedPadding.left;
					}
					
					if ( [rightFlow count] )
					{
						contentRight = floatingRight;
					}
					else
					{
						contentRight -= context->computedBorder.right;
					//	contentRight -= context->computedMargin.right;
						contentRight -= context->computedPadding.right;
					}

					CGFloat floatCenter = contentLeft;

					for ( SamuraiHtmlRenderObject * child in normalFlow )
					{
						CGRect childBounds = child.bounds;
						childBounds.origin.x = floatCenter;
						child.bounds = childBounds;
						
						floatCenter += childBounds.size.width;
					}
				}

			// align flow
				
				if ( [self layoutShouldHorizontalAlign] )
				{
					if ( [self layoutShouldHorizontalAlignLeft] )
					{
						CGFloat alignLeft = contentLeft;

						for ( SamuraiHtmlRenderObject * child in normalFlow )
						{
							CGRect childBounds = child.bounds;
							
							childBounds.origin.x = alignLeft;
							childBounds.origin.x += context->computedBorder.left;
						//	childBounds.origin.x += context->computedMargin.left;
							childBounds.origin.x += context->computedPadding.left;

							child.bounds = childBounds;
							
							alignLeft += childBounds.size.width;
						}
					}
					else if ( [self layoutShouldHorizontalAlignRight] )
					{
						CGFloat alignRight = contentRight;
						
						for ( SamuraiHtmlRenderObject * child in normalFlow )
						{
							CGRect childBounds = child.bounds;
							
							childBounds.origin.x = alignRight;
							childBounds.origin.x -= childBounds.size.width;
							childBounds.origin.x -= context->computedBorder.right;
						//	childBounds.origin.x -= context->computedMargin.right;
							childBounds.origin.x -= context->computedPadding.right;
							
							child.bounds = childBounds;
							
							alignRight -= childBounds.size.width;
						}
					}
					else if ( [self layoutShouldHorizontalAlignCenter] )
					{
						CGFloat alignCenter = contentLeft + ((contentRight - contentLeft) - centerWidth) / 2.0f;
						
						for ( SamuraiHtmlRenderObject * child in normalFlow )
						{
							CGRect childBounds = child.bounds;
							childBounds.origin.x = alignCenter;
							child.bounds = childBounds;

							alignCenter += childBounds.size.width;
						}
					}
				}

			// compute margin: 0 auto
				
				for ( SamuraiHtmlRenderObject * child in normalFlow )
				{
					if ( [child layoutShouldLeftJustifiedInRow] )
					{
						CGRect childBounds = child.bounds;
						childBounds.origin.x = contentLeft;
						child.bounds = childBounds;
					}
					else if ( [child layoutShouldRightJustifiedInRow] )
					{
						CGRect childBounds = child.bounds;
						childBounds.origin.x = contentRight - childBounds.size.width;
						child.bounds = childBounds;
					}
					else if ( [child layoutShouldCenteringInRow] )
					{
						CGRect childBounds = child.bounds;
						childBounds.origin.x = contentLeft + ((contentRight - contentLeft) - centerWidth) / 2.0f;
						child.bounds = childBounds;
					}
				}
				
			// vertical align flow
				
				if ( [self layoutShouldVerticalAlign] )
				{
					if ( [self layoutShouldVerticalAlignTop] )
					{
						for ( SamuraiHtmlRenderObject * child in normalFlow )
						{
							CGRect childBounds = child.bounds;
							childBounds.origin.y = lineTop;
							child.bounds = childBounds;
						}
					}
					else if ( [self layoutShouldVerticalAlignBottom] )
					{
						for ( SamuraiHtmlRenderObject * child in normalFlow )
						{
							CGRect childBounds = child.bounds;
							childBounds.origin.y = lineBottom - childBounds.size.height;
							child.bounds = childBounds;
						}
					}
					else if ( [self layoutShouldVerticalAlignMiddle] )
					{
						for ( SamuraiHtmlRenderObject * child in normalFlow )
						{
							CGRect childBounds = child.bounds;
							childBounds.origin.y = lineTop + (lineHeight - childBounds.size.height) / 2.0f;
							child.bounds = childBounds;
						}
					}
					else if ( [self layoutShouldVerticalAlignBaseline] )
					{
						TODO( "baseline" );
						
	//					for ( SamuraiHtmlRenderObject * child in normalFlow )
	//					{
	//						CGRect childBounds = child.bounds;
	//						childBounds.origin.y = lineTop + (lineHeight - childBounds.size.height) / 2.0f;
	//						child.bounds = childBounds;
	//					}
					}
				}
	
			// compute margin: auto 0;
					
				TODO( "margin: auto 0;" )
			}

		// compute offset
			
			for ( SamuraiHtmlRenderObject * child in self.childs )
			{
				if ( HtmlRenderDisplay_None == child.display )
					continue;

				if ( HtmlRenderPosition_Relative == child.position )
				{
					SamuraiHtmlLayoutContext relativeContext = {
						.style		= child.style,
						.bounds		= context->computedSize,
						.origin		= CGPointZero,
						.collapse	= UIEdgeInsetsZero
					};

					htmlComputeOffset( &relativeContext );
					
					CGRect childBounds = child.bounds;
					
					childBounds.origin.x += relativeContext.computedOffset.left;
					childBounds.origin.x -= relativeContext.computedOffset.right;
					childBounds.origin.y += relativeContext.computedOffset.top;
					childBounds.origin.y -= relativeContext.computedOffset.bottom;

//					childBounds.origin.x += computedPadding.left;
//					childBounds.origin.y += computedPadding.top;
//					childBounds.origin.x += computedBorder.left;
//					childBounds.origin.y += computedBorder.top;

					child.bounds = childBounds;
				}
				else if ( HtmlRenderPosition_Absolute == child.position )
				{
					CGPoint childOrigin;
					
					childOrigin.x = context->computedMargin.left;
					childOrigin.y = context->computedMargin.top;
					
					childOrigin.x += context->computedPadding.left;
					childOrigin.y += context->computedPadding.top;
					
					childOrigin.x += context->computedBorder.left;
					childOrigin.y += context->computedBorder.top;
					
					SamuraiHtmlLayoutContext absoluteContext = {
						.style		= child.style,
						.bounds		= context->computedSize,
						.origin		= childOrigin,
						.collapse	= UIEdgeInsetsZero
					};

					[child layoutWithContext:&absoluteContext parentContext:context];

					CGRect childBounds = absoluteContext.computedBounds;

					htmlComputeMargin( &absoluteContext );
					htmlComputeOffset( &absoluteContext );

					if ( child.style.left )
					{
						childBounds.origin.x = absoluteContext.computedOffset.left;
						childBounds.origin.x += context->computedPadding.left;
						childBounds.origin.x += context->computedBorder.left;
					}
					else if ( child.style.right )
					{
						CGFloat childWidth = absoluteContext.computedBounds.size.width;
						childWidth += absoluteContext.computedOffset.right;
						childWidth += absoluteContext.computedMargin.right;

						childBounds.origin.x = context->computedSize.width - childWidth;
						childBounds.origin.x -= context->computedPadding.right;
						childBounds.origin.x -= context->computedBorder.right;
					}
					
					if ( child.style.top )
					{
						childBounds.origin.y = absoluteContext.computedOffset.top;
						childBounds.origin.y += context->computedPadding.top;
						childBounds.origin.y += context->computedBorder.top;
					}
					else if ( child.style.bottom )
					{
						CGFloat childHeight = absoluteContext.computedBounds.size.height;
						childHeight += absoluteContext.computedOffset.bottom;
						childHeight += absoluteContext.computedMargin.bottom;

						childBounds.origin.y = context->computedSize.height - childHeight;
						childBounds.origin.y -= context->computedPadding.bottom;
						childBounds.origin.y -= context->computedBorder.bottom;
					}
					
					child.bounds = childBounds;
				}
				else if ( HtmlRenderPosition_Fixed == child.position )
				{
					TODO( "fixed" )
				}
				else if ( HtmlRenderPosition_Static == child.position )
				{
					
				}
			}
		}

		DEBUG_RENDERER_LAYOUT( self );

		htmlLayoutFinish( context );
	}

	CGPoint startPoint = CGPointMake( INVALID_VALUE, INVALID_VALUE );
	CGPoint endPoint = CGPointMake( INVALID_VALUE, INVALID_VALUE );
	
	for ( SamuraiHtmlRenderObject * child in [childLines firstObject] )
	{
		if ( INVALID_VALUE == startPoint.x )
		{
			startPoint.x = CGRectGetMinX( child.bounds );
		}
		else
		{
			startPoint.x = fminf( startPoint.x, CGRectGetMinX( child.bounds ) );
		}

		if ( INVALID_VALUE == startPoint.y )
		{
			startPoint.y = CGRectGetMinY( child.bounds );
		}
		else
		{
			startPoint.y = fminf( startPoint.y, CGRectGetMinY( child.bounds ) );
		}
	}

	for ( SamuraiHtmlRenderObject * child in [childLines lastObject] )
	{
		if ( INVALID_VALUE == endPoint.x )
		{
			endPoint.x = CGRectGetMaxX( child.bounds );
		}
		else
		{
			endPoint.x = fmaxf( endPoint.x, CGRectGetMaxX( child.bounds ) );
		}
		
		if ( INVALID_VALUE == endPoint.y )
		{
			endPoint.y = CGRectGetMinY( child.bounds );
		}
		else
		{
			endPoint.y = fminf( endPoint.y, CGRectGetMinY( child.bounds ) );
		}
	}

	self.lines		= [childLines count];
	self.start		= startPoint;
	self.end		= endPoint;

	self.inset		= context->computedInset;
	self.border		= context->computedBorder;
	self.margin		= context->computedMargin;
	self.padding	= context->computedPadding;
	self.bounds		= context->computedBounds;

	return self.bounds;
}

#pragma mark -

- (id)html_serialize
{
	if ( 0 == [self.childs count] )
	{
		return nil;
	}
	
	if ( 1 == [self.childs count] )
	{
		return [[self.childs firstObject] html_serialize];
	}
	else
	{
		NSMutableArray * array = [NSMutableArray array];
		
		for ( SamuraiRenderObject * child in self.childs )
		{
			[array addObject:[child html_serialize]];
		}
		
		return array;
	}
}

- (void)html_unserialize:(id)obj
{
	if ( 1 == [self.childs count] )
	{
		SamuraiRenderObject * childRender = [self.childs firstObject];
		
		if ( DomNodeType_Text == childRender.dom.type )
		{
			[childRender html_unserialize:obj];
		}
	}
}

- (void)zerolize
{
	for ( SamuraiRenderObject * child in self.childs )
	{
		[child html_zerolize];
	}
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlRenderContainer )

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
