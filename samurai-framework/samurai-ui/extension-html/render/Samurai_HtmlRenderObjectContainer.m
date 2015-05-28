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

- (BOOL)store_isValid
{
	return YES;
}

- (BOOL)store_hasChildren
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

- (BOOL)layoutShouldBoundsToWindow
{
	return [super layoutShouldBoundsToWindow];
}

- (BOOL)layoutShouldCenteringInRow
{
	return [super layoutShouldCenteringInRow];
}

- (BOOL)layoutShouldCenteringInCol
{
	return [super layoutShouldCenteringInCol];
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

- (CGRect)computeFrame:(CGSize)bound origin:(CGPoint)origin
{
	DEBUG_RENDERER_LAYOUT( self );

	if ( HtmlRenderDisplay_None == self.display )
	{
		return [self zerolizeFrame];
	}

// compute min/max size
	
	CGFloat minWidth = INVALID_VALUE;
	CGFloat maxWidth = INVALID_VALUE;
	CGFloat minHeight = INVALID_VALUE;
	CGFloat maxHeight = INVALID_VALUE;
	
	if ( self.style.minWidth )
	{
		minWidth = [self.style.minWidth computeValue:bound.width];
	}
	
	if ( self.style.minHeight )
	{
		minHeight = [self.style.minHeight computeValue:bound.height];
	}
	
	if ( self.style.maxWidth )
	{
		maxWidth = [self.style.maxWidth computeValue:bound.width];
	}
	
	if ( self.style.maxHeight )
	{
		maxHeight = [self.style.maxHeight computeValue:bound.height];
	}

// compute width/height
	
	CGSize computedSize = bound;
	
	if ( self.style.width )
	{
		if ( [self.style.width isNumber] )
		{
			computedSize.width = [self.style.width computeValue:bound.width];
		}
	}
	
	if ( self.style.height )
	{
		if ( [self.style.height isNumber] )
		{
			computedSize.height = [self.style.height computeValue:bound.height];
		}
	}

// compute function

	if ( self.style.width )
	{
		if ( [self.style.width isFunction:@"equals"] )
		{
			NSString * firstParam = [[self.style.width params] firstObject];
			
			if ( [firstParam isEqualToString:@"height"] )
			{
				computedSize.width = computedSize.height;
			}
		}
	}
	
	if ( self.style.height )
	{
		if ( [self.style.height isFunction:@"equals"] )
		{
			NSString * firstParam = [[self.style.height params] firstObject];
			
			if ( [firstParam isEqualToString:@"width"] )
			{
				computedSize.height = computedSize.width;
			}
		}
	}
	
// compute min/max size
	
	if ( self.style.minWidth )
	{
		if ( INVALID_VALUE != minWidth && computedSize.width < minWidth )
		{
			computedSize.width = minWidth;
		}
	}
	
	if ( self.style.minHeight )
	{
		if ( INVALID_VALUE != minHeight && computedSize.height < minHeight )
		{
			computedSize.height = minHeight;
		}
	}
	
	if ( self.style.maxWidth )
	{
		if ( INVALID_VALUE != maxWidth && computedSize.width > maxWidth )
		{
			computedSize.width = maxWidth;
		}
	}
	
	if ( self.style.maxHeight )
	{
		if ( INVALID_VALUE != maxHeight && computedSize.height > maxHeight )
		{
			computedSize.height = maxHeight;
		}
	}

// compute border/margin/padding
	
	UIEdgeInsets computedInset = [self computeInset:computedSize];
	UIEdgeInsets computedBorder = [self computeBorder:computedSize];
	UIEdgeInsets computedMargin = [self computeMargin:computedSize];
	UIEdgeInsets computedPadding = [self computePadding:computedSize];
	
// compute size

	CGRect oriWindow = CGRectMake( 0, 0, computedSize.width, computedSize.height );
	CGRect relWindow = oriWindow;
	CGRect maxWindow;
	
	maxWindow.origin = oriWindow.origin;
	maxWindow.size = CGSizeZero;

//	oriWindow.origin.x += computedMargin.left;
//	oriWindow.origin.y += computedMargin.top;
//	oriWindow.origin.x += computedBorder.left;
//	oriWindow.origin.y += computedBorder.top;
//	oriWindow.origin.x += computedPadding.left;
//	oriWindow.origin.y += computedPadding.top;

	maxWindow.size.width = 0.0f;
	maxWindow.size.height = 0.0f;

	NSInteger			childColumn = 0;
	NSMutableArray *	childLine = [NSMutableArray array];
	NSMutableArray *	childLines = [NSMutableArray array];
	NSEnumerator *		childEnumerator = nil;

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
			[child zerolizeFrame];
			continue;
		}
		
		switch ( child.position )
		{
		case HtmlRenderPosition_Static:
		case HtmlRenderPosition_Relative:
			{
				CGRect	childWindow;
				CGPoint	childOrigin;
				CGSize	childBoundSize;

				if ( [child layoutShouldWrapBefore] )
				{
					relWindow.origin.x = CGRectGetMinX( maxWindow );
					relWindow.origin.y = CGRectGetMaxY( maxWindow );
					
					if ( [childLine count] )
					{
						[childLines addObject:childLine];

						childLine = [NSMutableArray nonRetainingArray];
						childColumn = 0;
					}
				}

				[childLine addObject:child];
				
				childOrigin.x = relWindow.origin.x - oriWindow.origin.x;
				childOrigin.x += computedPadding.left;
				childOrigin.x += computedBorder.left;
				
				childOrigin.y = relWindow.origin.y - oriWindow.origin.y;
				childOrigin.y += computedPadding.top;
				childOrigin.y += computedBorder.top;
				
				childBoundSize.width = self.style.maxWidth ? maxWidth : relWindow.size.width;
				childBoundSize.height = self.style.maxHeight ? maxHeight : relWindow.size.height;
				
				childWindow = [child computeFrame:childBoundSize origin:childOrigin];

				if ( [child layoutShouldWrapLine] )
				{
					BOOL shouldBreakLine = NO;

					if ( 0 != childColumn )
					{
						if ( INVALID_VALUE != computedSize.width )
						{
							if ( computedSize.width > childWindow.size.width )
							{
								if ( relWindow.origin.x > computedSize.width )
								{
									shouldBreakLine = YES;
								}
							}
						}
						
						if ( INVALID_VALUE != maxWidth )
						{
							if ( maxWidth > childWindow.size.width )
							{
								if ( relWindow.origin.x > maxWidth )
								{
									shouldBreakLine = YES;
								}
							}
						}

						if ( INVALID_VALUE != childBoundSize.width )
						{
							if ( CGRectGetMaxX( childWindow ) > childBoundSize.width )
							{
								shouldBreakLine = YES;
							}
						}

						if ( shouldBreakLine )
						{
							relWindow.origin.x = CGRectGetMinX( oriWindow );
							relWindow.origin.y = CGRectGetMaxY( maxWindow );

							[childLines addObject:childLine];
							
							childLine = [NSMutableArray nonRetainingArray];
							childColumn = 0;

							childOrigin.x = relWindow.origin.x - oriWindow.origin.x;
//							childOrigin.x += computedPadding.left;
//							childOrigin.x += computedBorder.left;
							
							childOrigin.y = relWindow.origin.y - oriWindow.origin.y;
//							childOrigin.y += computedPadding.top;
//							childOrigin.y += computedBorder.top;

							childBoundSize.width = self.style.maxWidth ? maxWidth : relWindow.size.width;
							childBoundSize.height = self.style.maxHeight ? maxHeight : relWindow.size.height;

							childWindow = [child computeFrame:childBoundSize origin:childOrigin];
						}
					}
				}
				
				if ( [child layoutShouldWrapAfter] )
				{
					relWindow.origin.x = oriWindow.origin.x;
					relWindow.origin.y += childWindow.size.height;

					[childLines addObject:childLine];

					childLine = [NSMutableArray nonRetainingArray];
					childColumn = 0;
				}
				else
				{
					if ( [self layoutShouldArrangedInRow] )
					{
						relWindow.origin.x += childWindow.size.width;
					}
					else if ( [self layoutShouldArrangedInCol] )
					{
						relWindow.origin.y += childWindow.size.height;
					}
					else
					{
						relWindow.origin.x += childWindow.size.width;
					}
					
					childColumn += 1;
				}
				
			// compute max width
				
				if ( INVALID_VALUE == maxWindow.size.width )
				{
					maxWindow.size.width = childWindow.size.width;
				}
				
				if ( CGRectGetMaxX( childWindow ) > CGRectGetMaxX( maxWindow ) )
				{
					maxWindow.size.width = CGRectGetMaxX( childWindow );
				}
				
				if ( childWindow.size.width > maxWindow.size.width )
				{
					maxWindow.size.width = childWindow.size.width;
				}

				if ( childOrigin.x + childWindow.size.width > maxWindow.size.width )
				{
					maxWindow.size.width = childOrigin.x + childWindow.size.width;
				}

			// compute max height
				
				if ( INVALID_VALUE == maxWindow.size.height )
				{
					maxWindow.size.height = childWindow.size.height;
				}
				
				if ( CGRectGetMaxY( childWindow ) > CGRectGetMaxY( maxWindow ) )
				{
					maxWindow.size.height = CGRectGetMaxY( childWindow );
				}
				
				if ( childWindow.size.height > maxWindow.size.height )
				{
					maxWindow.size.height = childWindow.size.height;
				}
				
				if ( childOrigin.y + childWindow.size.height > maxWindow.size.height )
				{
					maxWindow.size.height = childOrigin.y + childWindow.size.height;
				}
			}
			break;

		case HtmlRenderPosition_Absolute:
		case HtmlRenderPosition_Fixed:
		default:
			break;
		}
	}

	if ( NO == [childLines containsObject:childLine] )
	{
		if ( [childLine count] )
		{
			[childLines addObject:childLine];
		}
	}

	if ( [self layoutShouldBoundsToWindow] )
	{
		computedSize.width = maxWindow.size.width;
		computedSize.height = maxWindow.size.height;
	}
	else
	{
		if ( [self.style isAutoWidth] )
		{
			computedSize.width = maxWindow.size.width;
		}
		
		if ( [self.style isAutoHeight] )
		{
			computedSize.height = maxWindow.size.height;
		}
	}

// compute function

	if ( self.style.width )
	{
		if ( [self.style.width isFunction:@"equals"] )
		{
			NSString * firstParam = [[self.style.width params] firstObject];
			
			if ( [firstParam isEqualToString:@"height"] )
			{
				computedSize.width = computedSize.height;
			}
		}
	}

	if ( self.style.height )
	{
		if ( [self.style.height isFunction:@"equals"] )
		{
			NSString * firstParam = [[self.style.height params] firstObject];
			
			if ( [firstParam isEqualToString:@"width"] )
			{
				computedSize.height = computedSize.width;
			}
		}
	}
	
// normalize value
	
	computedSize.width = NORMALIZE_VALUE( computedSize.width );
	computedSize.height = NORMALIZE_VALUE( computedSize.height );
	
// compute min/max size
	
	if ( self.style.minWidth )
	{
		if ( INVALID_VALUE != minWidth && computedSize.width < minWidth )
		{
			computedSize.width = minWidth;
		}
	}
	
	if ( self.style.minHeight )
	{
		if ( INVALID_VALUE != minHeight && computedSize.height < minHeight )
		{
			computedSize.height = minHeight;
		}
	}
	
	if ( self.style.maxWidth )
	{
		if ( INVALID_VALUE != maxWidth && computedSize.width > maxWidth )
		{
			computedSize.width = maxWidth;
		}
	}
	
	if ( self.style.maxHeight )
	{
		if ( INVALID_VALUE != maxHeight && computedSize.height > maxHeight )
		{
			computedSize.height = maxHeight;
		}
	}
	
// compute floating & align
	
	DEBUG_RENDERER_LAYOUT( self );
	
	if ( [self layoutShouldPositioningChildren] )
	{
		for ( NSMutableArray * line in childLines )
		{
			CGFloat lineWidth = computedSize.width;
			CGFloat lineHeight = 0.0f;
			
			CGFloat lineTop = INVALID_VALUE;
			CGFloat lineBottom = INVALID_VALUE;
			
			CGFloat	leftWidth = 0.0f;
			CGFloat	rightWidth = 0.0f;
			CGFloat	centerWidth = 0.0f;
			
			lineWidth += computedPadding.left;
			lineWidth += computedPadding.right;
			lineWidth += computedBorder.left;
			lineWidth += computedBorder.right;
			lineWidth += computedMargin.left;
			lineWidth += computedMargin.right;
			
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
		
			CGFloat floatingLeft = 0.0f;
			CGFloat floatingRight = lineWidth;

			floatingLeft += computedBorder.left;
			floatingLeft += computedMargin.left;
			floatingLeft += computedPadding.left;

			floatingRight -= computedBorder.right;
			floatingRight -= computedMargin.right;
			floatingRight -= computedPadding.right;

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
			
		// normal flow

			CGFloat contentLeft = 0.0f;
			CGFloat contentRight = lineWidth;

			if ( [leftFlow count] )
			{
				contentLeft = floatingLeft;
			}
			else
			{
				contentLeft += computedBorder.left;
				contentLeft += computedMargin.left;
				contentLeft += computedPadding.left;
			}
			
			if ( [rightFlow count] )
			{
				contentRight = floatingRight;
			}
			else
			{
				contentRight -= computedBorder.right;
				contentRight -= computedMargin.right;
				contentRight -= computedPadding.right;
			}

			if ( [leftFlow count] || [rightFlow count] )
			{
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
						childBounds.origin.x = alignRight - childBounds.size.width;
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
		}

	// compute offset
		
		for ( SamuraiHtmlRenderObject * child in self.childs )
		{
			if ( HtmlRenderDisplay_None == child.display )
				continue;

			switch ( child.position )
			{
			case HtmlRenderPosition_Relative:
				{
					UIEdgeInsets	childOffset = [child computeOffset:computedSize];
//					UIEdgeInsets	childMargin = [child computeMargin:computedSize];
					
					childOffset.top = NORMALIZE_VALUE( childOffset.top );
					childOffset.left = NORMALIZE_VALUE( childOffset.left );
					childOffset.right = NORMALIZE_VALUE( childOffset.right );
					childOffset.bottom = NORMALIZE_VALUE( childOffset.bottom );
					
					CGRect childBounds = child.bounds;
					
					childBounds.origin.x += childOffset.left;
					childBounds.origin.x -= childOffset.right;
					childBounds.origin.y += childOffset.top;
					childBounds.origin.y -= childOffset.bottom;
					
//					childBounds.origin.x += computedPadding.left;
//					childBounds.origin.y += computedPadding.top;
//					childBounds.origin.x += computedBorder.left;
//					childBounds.origin.y += computedBorder.top;

					child.bounds = childBounds;
				}
				break;
					
			case HtmlRenderPosition_Absolute:
				{
					CGPoint childOrigin;
					
					childOrigin.x = computedMargin.left;
					childOrigin.y = computedMargin.top;
					
					childOrigin.x += computedPadding.left;
					childOrigin.y += computedPadding.top;
					
					childOrigin.x += computedBorder.left;
					childOrigin.y += computedBorder.top;
					
					CGRect			childBounds = [child computeFrame:computedSize origin:childOrigin];
					UIEdgeInsets	childOffset = [child computeOffset:computedSize];
					UIEdgeInsets	childMargin = [child computeMargin:computedSize];

					childBounds.origin.x = NORMALIZE_VALUE( childBounds.origin.x );
					childBounds.origin.y = NORMALIZE_VALUE( childBounds.origin.y );
					childBounds.size.width = NORMALIZE_VALUE( childBounds.size.width );
					childBounds.size.height = NORMALIZE_VALUE( childBounds.size.height );
					
					childOffset.top = NORMALIZE_VALUE( childOffset.top );
					childOffset.left = NORMALIZE_VALUE( childOffset.left );
					childOffset.right = NORMALIZE_VALUE( childOffset.right );
					childOffset.bottom = NORMALIZE_VALUE( childOffset.bottom );
					
					childMargin.top = NORMALIZE_VALUE( childMargin.top );
					childMargin.left = NORMALIZE_VALUE( childMargin.left );
					childMargin.right = NORMALIZE_VALUE( childMargin.right );
					childMargin.bottom = NORMALIZE_VALUE( childMargin.bottom );

					if ( child.style.left )
					{
						childBounds.origin.x = childOffset.left;
						childBounds.origin.x += computedPadding.left;
						childBounds.origin.x += computedBorder.left;
					}
					else if ( child.style.right )
					{
						childBounds.origin.x = computedSize.width - (childMargin.right + childBounds.size.width + childOffset.right);
						childBounds.origin.x -= computedPadding.right;
						childBounds.origin.x -= computedBorder.right;
					}
					
					if ( child.style.top )
					{
						childBounds.origin.y = childOffset.top;
						childBounds.origin.y += computedPadding.top;
						childBounds.origin.y += computedBorder.top;
					}
					else if ( child.style.bottom )
					{
						childBounds.origin.y = computedSize.height - (childMargin.bottom + childBounds.size.height + childOffset.bottom);
						childBounds.origin.y -= computedPadding.bottom;
						childBounds.origin.y -= computedBorder.bottom;
					}
					
					child.bounds = childBounds;
				}
				break;
					
			case HtmlRenderPosition_Fixed:
				{
					TODO( "fixed" )
				}
				break;
				
			case HtmlRenderPosition_Static:
			default:
				break;
			}
		}

	// compute margin: 0 auto
		
		CGSize autoSize = computedSize;

		autoSize.width += computedPadding.left;
		autoSize.width += computedPadding.right;
		autoSize.height += computedPadding.top;
		autoSize.height += computedPadding.bottom;
		
		autoSize.width += computedBorder.left;
		autoSize.width += computedBorder.right;
		autoSize.height += computedBorder.top;
		autoSize.height += computedBorder.bottom;

		for ( SamuraiHtmlRenderObject * child in self.childs )
		{
			if ( HtmlRenderFloating_None != child.floating )
				continue;
			
			if ( HtmlRenderDisplay_None == child.display )
				continue;
			
			CGRect childBounds = child.bounds;
			
			if ( [child layoutShouldCenteringInRow] )
			{
				childBounds.origin.x = (autoSize.width - childBounds.size.width) / 2.0f;
			}
			
			if ( [child layoutShouldCenteringInCol] )
			{
				childBounds.origin.y = (autoSize.height - childBounds.size.height) / 2.0f;
			}

			child.bounds = childBounds;
		}
	}

	DEBUG_RENDERER_LAYOUT( self );

// compute inset / border / margin /padding
	
	self.inset = computedInset;
	self.border = computedBorder;
	self.margin = computedMargin;
	self.padding = computedPadding;

// compute bounds

	CGRect computedBounds;
	
	computedBounds.origin = origin;
	
	computedBounds.size.width = computedSize.width;
	computedBounds.size.width += computedPadding.left;
	computedBounds.size.width += computedPadding.right;
	computedBounds.size.width += computedBorder.left;
	computedBounds.size.width += computedBorder.right;
	computedBounds.size.width += computedMargin.left;
	computedBounds.size.width += computedMargin.right;

	computedBounds.size.height = computedSize.height;
	computedBounds.size.height += computedPadding.top;
	computedBounds.size.height += computedPadding.bottom;
	computedBounds.size.height += computedBorder.top;
	computedBounds.size.height += computedBorder.bottom;
	computedBounds.size.height += computedMargin.top;
	computedBounds.size.height += computedMargin.bottom;

	self.bounds = computedBounds;
	
	return computedBounds;
}

#pragma mark -

- (id)serialize
{
	if ( 0 == [self.childs count] )
	{
		return nil;
	}
	
	if ( 1 == [self.childs count] )
	{
		return [[self.childs firstObject] serialize];
	}
	else
	{
		return [self.childs serialize];
	}
}

- (void)unserialize:(id)obj
{
	if ( 1 == [self.childs count] )
	{
		SamuraiRenderObject * childRender = [self.childs firstObject];
		
		if ( DomNodeType_Text == childRender.dom.type )
		{
			[childRender unserialize:obj];
		}
	}
}

- (void)zerolize
{
	for ( SamuraiRenderObject * child in self.childs )
	{
		[child zerolize];
	}
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, HtmlRenderContainer )

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
