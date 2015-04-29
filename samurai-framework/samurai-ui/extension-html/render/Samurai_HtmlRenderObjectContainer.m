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

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@interface __HtmlContainerView : UIView
@end
@implementation __HtmlContainerView
@end

#pragma mark -

@implementation SamuraiHtmlRenderObjectContainer

+ (Class)defaultViewClass
{
	return [__HtmlContainerView class];
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

- (CGRect)computeFrame:(CGSize)bound origin:(CGPoint)origin
{
#if __SAMURAI_DEBUG__
	[self debug];
#endif	// #if __SAMURAI_DEBUG__

	if ( RenderDisplay_None == self.display )
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
	
	CGRect computedFrame;
 
	computedFrame.origin = CGPointZero; // bound.origin;
	computedFrame.size = bound;
	
	if ( [self.style.width isNumber] )
	{
		computedFrame.size.width = [self.style.width computeValue:bound.width];
	}
	
	if ( [self.style.height isNumber] )
	{
		computedFrame.size.height = [self.style.height computeValue:bound.height];
	}
	
// compute function

	if ( [self.style.width isFunction:@"equals"] )
	{
		NSString * firstParam = [[self.style.width params] firstObject];
		
		if ( [firstParam isEqualToString:@"height"] )
		{
			computedFrame.size.width = computedFrame.size.height;
		}
	}
	
	if ( [self.style.height isFunction:@"equals"] )
	{
		NSString * firstParam = [[self.style.height params] firstObject];
		
		if ( [firstParam isEqualToString:@"width"] )
		{
			computedFrame.size.height = computedFrame.size.width;
		}
	}

// compute border/margin/padding
	
	UIEdgeInsets computedInset = [self computeInset:computedFrame.size];
	UIEdgeInsets computedBorder = [self computeBorder:computedFrame.size];
	UIEdgeInsets computedMargin = [self computeMargin:computedFrame.size];
	UIEdgeInsets computedPadding = [self computePadding:computedFrame.size];
	
// compute size

	CGRect oriWindow = computedFrame;
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
	
	NSUInteger column = 0;
	
	NSEnumerator * enumerator = nil;
	
	if ( [self layoutShouldArrangedReverse] )
	{
		enumerator = [self.childs reverseObjectEnumerator];
	}
	else
	{
		enumerator = [self.childs objectEnumerator];
	}
	
	for ( SamuraiHtmlRenderObject * child in enumerator )
	{
		if ( RenderFloating_None != child.floating )
		{
			continue;
		}
		
		if ( RenderDisplay_None == child.display )
		{
			[child zerolizeFrame];
			continue;
		}
		
		switch ( child.position )
		{
		case RenderPosition_Static:
		case RenderPosition_Relative:
			{
				CGPoint	childOrigin;
				CGRect	childWindow;
				
				if ( [child layoutShouldWrapBefore] )
				{
					relWindow.origin.x = CGRectGetMinX( maxWindow );
					relWindow.origin.y = CGRectGetMaxY( maxWindow );
				}
				
				childOrigin.x = relWindow.origin.x - oriWindow.origin.x;
				childOrigin.y = relWindow.origin.y - oriWindow.origin.y;

				childOrigin.x += computedPadding.left;
				childOrigin.y += computedPadding.top;

				CGSize childBoundSize;
				
				childBoundSize.width = self.style.maxWidth ? maxWidth : relWindow.size.width;
				childBoundSize.height = self.style.maxHeight ? maxHeight : relWindow.size.height;
				
				childWindow = [child computeFrame:childBoundSize origin:childOrigin];

				if ( [child layoutShouldWrapLine] )
				{
					if ( 0 != column )
					{
						BOOL breakLine = NO;
						
						if ( NO == [self.style isAutoWidth] )
						{
							if ( computedFrame.size.width > childWindow.size.width )
							{
								if ( relWindow.origin.x > CGRectGetMaxX( computedFrame ) )
								{
									breakLine = YES;
								}
							}
						}
						
						if ( maxWidth > childWindow.size.width )
						{
							if ( INVALID_VALUE != maxWidth )
							{
								if ( relWindow.origin.x > maxWidth )
								{
									breakLine = YES;
								}
							}
						}
						
						if ( breakLine )
						{
							relWindow.origin.x = oriWindow.origin.x;
							relWindow.origin.y += childWindow.size.height;
							
							childOrigin.x = relWindow.origin.x - oriWindow.origin.x;
							childOrigin.y = relWindow.origin.y - oriWindow.origin.y;
							
							childWindow = [child computeFrame:relWindow.size origin:childOrigin];
							
							column = 0;
						}
					}
				}
				
				if ( [child layoutShouldWrapAfter] )
				{
					relWindow.origin.x = oriWindow.origin.x;
					relWindow.origin.y += childWindow.size.height;
					
					column = 0;
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
					
					column += 1;
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

		case RenderPosition_Absolute:
		case RenderPosition_Fixed:
		default:
			break;
		}
	}
	
	if ( [self layoutShouldBoundsToWindow] )
	{
		computedFrame.size.width = maxWindow.size.width;
		computedFrame.size.height = maxWindow.size.height;
	}
	else
	{
		if ( [self.style isAutoWidth] )
		{
			computedFrame.size.width = maxWindow.size.width;
		}
		
		if ( [self.style isAutoHeight] )
		{
			computedFrame.size.height = maxWindow.size.height;
		}
	}

// compute function

	if ( [self.style.width isFunction:@"equals"] )
	{
		NSString * firstParam = [[self.style.width params] firstObject];
		
		if ( [firstParam isEqualToString:@"height"] )
		{
			computedFrame.size.width = computedFrame.size.height;
		}
	}
	
	if ( [self.style.height isFunction:@"equals"] )
	{
		NSString * firstParam = [[self.style.height params] firstObject];
		
		if ( [firstParam isEqualToString:@"width"] )
		{
			computedFrame.size.height = computedFrame.size.width;
		}
	}

// normalize value
	
	computedFrame.origin.x = NORMALIZE_VALUE( computedFrame.origin.x );
	computedFrame.origin.y = NORMALIZE_VALUE( computedFrame.origin.y );
	computedFrame.size.width = NORMALIZE_VALUE( computedFrame.size.width );
	computedFrame.size.height = NORMALIZE_VALUE( computedFrame.size.height );
	
// compute min/max size
	
	if ( INVALID_VALUE != minWidth )
	{
		if ( computedFrame.size.width < minWidth )
		{
			computedFrame.size.width = minWidth;
		}
	}
	
	if ( INVALID_VALUE != minHeight )
	{
		if ( computedFrame.size.height < minHeight )
		{
			computedFrame.size.height = minHeight;
		}
	}
	
	if ( INVALID_VALUE != maxWidth )
	{
		if ( computedFrame.size.width > maxWidth )
		{
			computedFrame.size.width = maxWidth;
		}
	}
	
	if ( INVALID_VALUE != maxHeight )
	{
		if ( computedFrame.size.height > maxHeight )
		{
			computedFrame.size.height = maxHeight;
		}
	}

//// re-compute border/margin/padding
//
//	computedBorder = [self computeBorder:computedFrame.size];
//	computedMargin = [self computeMargin:computedFrame.size];
//	computedPadding = [self computePadding:computedFrame.size];

// re-compute border/margin/padding
	
	if ( [self layoutShouldPositioningChildren] )
	{
	// compute offset
		
		for ( SamuraiHtmlRenderObject * child in self.childs )
		{
			if ( RenderFloating_None != child.floating )
				continue;

			if ( RenderDisplay_None == child.display )
				continue;
			
			if ( RenderPosition_Static == child.position )
				continue;

			if ( RenderPosition_Relative == child.position )
			{
				UIEdgeInsets	childOffset = [child computeOffset:computedFrame.size];
			//	UIEdgeInsets	childMargin = [child computeMargin:computedFrame.size];
				
				childOffset.top = NORMALIZE_VALUE( childOffset.top );
				childOffset.left = NORMALIZE_VALUE( childOffset.left );
				childOffset.right = NORMALIZE_VALUE( childOffset.right );
				childOffset.bottom = NORMALIZE_VALUE( childOffset.bottom );

				CGRect childBounds = child.frame;
				
				childBounds.origin.x += childOffset.left;
				childBounds.origin.x -= childOffset.right;
				childBounds.origin.y += childOffset.top;
				childBounds.origin.y -= childOffset.bottom;
				
//				childBounds.origin.x += computedPadding.left;
//				childBounds.origin.y += computedPadding.top;
//				childBounds.origin.x += computedBorder.left;
//				childBounds.origin.y += computedBorder.top;
				
				child.frame = childBounds;
			}
			else if ( RenderPosition_Absolute == child.position )
			{
				CGPoint childOrigin;
				
				childOrigin.x = computedMargin.left;
				childOrigin.y = computedMargin.top;
				childOrigin.x += computedPadding.left;
				childOrigin.y += computedPadding.top;
				childOrigin.x += computedBorder.left;
				childOrigin.y += computedBorder.top;
				
				CGRect			childBounds = [child computeFrame:computedFrame.size origin:childOrigin];
				UIEdgeInsets	childOffset = [child computeOffset:computedFrame.size];
				UIEdgeInsets	childMargin = [child computeMargin:computedFrame.size];

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
					childBounds.origin.x = computedFrame.origin.x + childOffset.left;
					childBounds.origin.x += computedPadding.left;
					childBounds.origin.x += computedBorder.left;
				}
				else if ( child.style.right )
				{
					childBounds.origin.x = (computedFrame.origin.x + computedFrame.size.width) - (childMargin.right + childBounds.size.width + childOffset.right);
					childBounds.origin.x -= computedPadding.right;
					childBounds.origin.x -= computedBorder.right;
				}
				
				if ( child.style.top )
				{
					childBounds.origin.y = computedFrame.origin.y + childOffset.top;
					childBounds.origin.y += computedPadding.top;
					childBounds.origin.y += computedBorder.top;
				}
				else if ( child.style.bottom )
				{
					childBounds.origin.y = (computedFrame.origin.y + computedFrame.size.height) - (childMargin.bottom + childBounds.size.height + childOffset.bottom);
					childBounds.origin.y -= computedPadding.bottom;
					childBounds.origin.y -= computedBorder.bottom;
				}
				
				child.frame = childBounds;
			}
			else if ( RenderPosition_Fixed == child.position )
			{
				TODO( "fixed" )
			}
		}
		
	// compute floating
		
		CGRect floatingWindow = computedFrame;
		
		floatingWindow.origin.x += computedMargin.left;
		floatingWindow.origin.y += computedMargin.top;
		floatingWindow.origin.x += computedPadding.left;
		floatingWindow.origin.y += computedPadding.top;
		floatingWindow.origin.x += computedBorder.left;
		floatingWindow.origin.y += computedBorder.top;

		CGFloat floatingLeft = floatingWindow.origin.x;
		CGFloat floatingRight = floatingWindow.origin.x + floatingWindow.size.width;
	 
		floatingRight -= (computedPadding.right + computedPadding.left);
		floatingRight -= (computedBorder.right + computedBorder.left);
		
		for ( SamuraiHtmlRenderObject * child in self.childs )
		{
			if ( RenderDisplay_None == child.display )
				continue;
		
			if ( RenderFloating_None == child.floating )
				continue;

			if ( RenderFloating_Left == child.floating )
			{
				CGRect childWindow = [child computeFrame:floatingWindow.size origin:CGPointZero];
				CGRect childBounds = child.frame;
				
				childBounds.origin.x = floatingLeft;
			//	childBounds.origin.y += computedMargin.top;
			//	childBounds.origin.y += computedBorder.top;
				childBounds.origin.y += computedPadding.top;
				
				child.frame = childBounds;
				
				floatingLeft += childWindow.size.width;
			}
			else if ( RenderFloating_Right == child.floating )
			{
				CGRect childWindow = [child computeFrame:floatingWindow.size origin:CGPointZero];
				CGRect childBounds = child.frame;

				floatingRight -= childWindow.size.width;

				childBounds.origin.x = floatingRight;
			//	childBounds.origin.y += computedMargin.top;
			//	childBounds.origin.y += computedBorder.top;
				childBounds.origin.y += computedPadding.top;
				
				child.frame = childBounds;
			}
		}
		
	// compute margin: 0 auto
		
		CGRect alignBound = computedFrame;
		
		alignBound.size.width += computedPadding.left;
		alignBound.size.width += computedPadding.right;
		alignBound.size.height += computedPadding.top;
		alignBound.size.height += computedPadding.bottom;
		
		alignBound.size.width += computedBorder.left;
		alignBound.size.width += computedBorder.right;
		alignBound.size.height += computedBorder.top;
		alignBound.size.height += computedBorder.bottom;
		
		for ( SamuraiHtmlRenderObject * child in self.childs )
		{
			if ( RenderFloating_None != child.floating )
				continue;
			
			if ( RenderDisplay_None == child.display )
				continue;
			
			CGRect childBounds = child.frame;

			if ( [child layoutShouldCenteringInRow] )
			{
				childBounds.origin.x = (alignBound.size.width - childBounds.size.width) / 2.0f;
			}

			if ( [child layoutShouldCenteringInCol] )
			{
				childBounds.origin.y = (alignBound.size.height - childBounds.size.height) / 2.0f;
			}

			child.frame = childBounds;
		}
	}
	
// compute inner bounds
	
	CGRect innerBound = computedFrame;
	
	innerBound.origin.x += origin.x;
	innerBound.origin.y += origin.y;
	innerBound.origin.x += computedMargin.left;
	innerBound.origin.y += computedMargin.top;

	innerBound.size.width += computedPadding.left;
	innerBound.size.width += computedPadding.right;
	innerBound.size.height += computedPadding.top;
	innerBound.size.height += computedPadding.bottom;

	innerBound.size.width += computedBorder.left;
	innerBound.size.width += computedBorder.right;
	innerBound.size.height += computedBorder.top;
	innerBound.size.height += computedBorder.bottom;

	innerBound.origin.x += computedInset.left;
	innerBound.origin.y += computedInset.top;

	innerBound.size.width -= computedInset.left;
	innerBound.size.width -= computedInset.right;
	innerBound.size.height -= computedInset.top;
	innerBound.size.height -= computedInset.bottom;

// compute outer bounds
	
	CGRect outerBound;
	
	outerBound.origin = origin;
	
	outerBound.size.width = computedFrame.origin.x + computedFrame.size.width;
	outerBound.size.height = computedFrame.origin.y + computedFrame.size.height;
	
	outerBound.size.width += computedPadding.left;
	outerBound.size.width += computedPadding.right;
	outerBound.size.height += computedPadding.top;
	outerBound.size.height += computedPadding.bottom;
	
	outerBound.size.width += computedBorder.left;
	outerBound.size.width += computedBorder.right;
	outerBound.size.height += computedBorder.top;
	outerBound.size.height += computedBorder.bottom;
	
	outerBound.size.width += computedMargin.left;
	outerBound.size.width += computedMargin.right;
	outerBound.size.height += computedMargin.top;
	outerBound.size.height += computedMargin.bottom;
	
	self.frame = innerBound;
	self.offset = origin;
	
	self.inset = computedInset;
	self.margin = computedMargin;
	self.padding = computedPadding;
	self.border = computedBorder;
	
	return outerBound;
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
