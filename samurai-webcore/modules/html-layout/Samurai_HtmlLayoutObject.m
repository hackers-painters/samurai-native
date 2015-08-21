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

#import "Samurai_HtmlLayoutObject.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_HtmlRenderObject.h"
#import "Samurai_HtmlRenderStyle.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiHtmlLayoutObject

@def_prop_unsafe( SamuraiHtmlRenderObject *,	source );

@def_prop_assign( UIEdgeInsets,					collapse );
@def_prop_assign( CGSize,						stretch );
@def_prop_assign( CGSize,						bounds );
@def_prop_assign( CGPoint,						origin );

@def_prop_assign( CGFloat,						computedMinWidth );
@def_prop_assign( CGFloat,						computedMaxWidth );
@def_prop_assign( CGFloat,						computedMinHeight );
@def_prop_assign( CGFloat,						computedMaxHeight );
@def_prop_assign( UIEdgeInsets,					computedInset );
@def_prop_assign( UIEdgeInsets,					computedBorder );
@def_prop_assign( UIEdgeInsets,					computedMargin );
@def_prop_assign( UIEdgeInsets,					computedPadding );
@def_prop_assign( UIEdgeInsets,					computedOffset );
@def_prop_assign( CGSize,						computedSize );
@def_prop_assign( CGSize,						computedBounds );
@def_prop_assign( CGFloat,						computedLineHeight );
@def_prop_assign( CGFloat,						computedBorderSpacing );
@def_prop_assign( CGFloat,						computedCellSpacing );
@def_prop_assign( CGFloat,						computedCellPadding );

@def_prop_assign( CGRect,						frame );

+ (instancetype)layout
{
	return [[self alloc] init];
}

+ (instancetype)layout:(SamuraiHtmlRenderObject *)target
{
	SamuraiHtmlLayoutObject * layout = [[self alloc] init];
	layout.source = target;
	return layout;
}

#pragma mark -

- (BOOL)begin:(BOOL)reset
{
	if ( nil == self.source )
	{
		return NO;
	}

	DEBUG_RENDERER_LAYOUT( self.source );

	if ( reset )
	{
		self.computedMinWidth		= INVALID_VALUE;
		self.computedMaxWidth		= INVALID_VALUE;
		self.computedMinHeight		= INVALID_VALUE;
		self.computedMaxHeight		= INVALID_VALUE;
		
		self.computedSize			= CGSizeZero;
		self.computedInset			= UIEdgeInsetsZero;
		self.computedBorder			= UIEdgeInsetsZero;
		self.computedMargin			= UIEdgeInsetsZero;
		self.computedPadding		= UIEdgeInsetsZero;
		
		self.computedLineHeight		= INVALID_VALUE;
		self.computedCellSpacing	= INVALID_VALUE;
		self.computedCellPadding	= INVALID_VALUE;
		self.computedBorderSpacing	= INVALID_VALUE;
		
		self.frame = CGRectZero;

		if ( self.source.style )
		{
			[self computeSize];
			[self computeOffset];
			
			[self computeInset];
			[self computeMargin];
			[self computeBorder];
			[self computePadding];
			
			[self computeWidthShrink];
			[self computeMarginCollpase];
			
			[self computeBorderSpacing];
			[self computeCellPadding];
			[self computeCellSpacing];
			[self computeLineHeight];
		}
	}
	
	return ( CSSDisplay_None == self.source.display ) ? NO : YES;
}

- (BOOL)offset:(CGPoint)point
{
	if ( NO == CGPointEqualToPoint( point, self.origin ) )
	{
		self.origin = point;
		
//		[self computeBounds];
//		[self computeFrame];
		
		return YES;
	}
	else
	{
		return NO;
	}
}

- (BOOL)stretchWidth:(CGFloat)width
{	
	if ( self.stretch.width == width )
		return NO;
	
	self.stretch = CGSizeMake( width, self.stretch.height );
	return YES;
}

- (BOOL)stretchHeight:(CGFloat)height
{
	if ( self.stretch.height == height )
		return NO;
	
	self.stretch = CGSizeMake( self.stretch.width, height );
	return YES;
}

- (BOOL)resize:(CGSize)size
{
	CGSize newSize = size;
	
	if ( [self.source.style isWidthEqualsToHeight] )
	{
		newSize.width = size.height;
	}
	
	if ( [self.source.style isHeightEqualsToWidth] )
	{
		newSize.height = size.width;
	}
	
	newSize.width	= NORMALIZE_VALUE( newSize.width );
	newSize.height	= NORMALIZE_VALUE( newSize.height );
	
	if ( INVALID_VALUE != self.computedMinWidth && newSize.width < self.computedMinWidth )
	{
		newSize.width = self.computedMinWidth;
	}
	
	if ( INVALID_VALUE != self.computedMinHeight && newSize.height < self.computedMinHeight )
	{
		newSize.height = self.computedMinHeight;
	}
	
	if ( INVALID_VALUE != self.computedMaxWidth && newSize.width > self.computedMaxWidth )
	{
		newSize.width = self.computedMaxWidth;
	}
	
	if ( INVALID_VALUE != self.computedMaxHeight && newSize.height > self.computedMaxHeight )
	{
		newSize.height = self.computedMaxHeight;
	}
	
	if ( NO == CGSizeEqualToSize( newSize, self.computedSize ) )
	{
		self.computedSize = newSize;

//		[self computeBounds];
//		[self computeFrame];
		
		return YES;
	}
	else
	{
		return NO;
	}
}

- (void)layout
{
}

- (void)finish
{
	DEBUG_RENDERER_LAYOUT( self.source );

	[self computeBounds];
	[self computeFrame];
}

#pragma mark -

- (void)computeInset
{
	UIEdgeInsets inset = UIEdgeInsetsZero;
	
	inset.top		= [self.source.style computeInsetTopSize:self.bounds.width /* self.bounds.height */ defaultSize:INVALID_VALUE];
	inset.left		= [self.source.style computeInsetLeftSize:self.bounds.width defaultSize:INVALID_VALUE];
	inset.right		= [self.source.style computeInsetRightSize:self.bounds.width defaultSize:INVALID_VALUE];
	inset.bottom	= [self.source.style computeInsetBottomSize:self.bounds.width /* self.bounds.height */ defaultSize:INVALID_VALUE];
	
	inset.top		= NORMALIZE_VALUE( inset.top );
	inset.left		= NORMALIZE_VALUE( inset.left );
	inset.right		= NORMALIZE_VALUE( inset.right );
	inset.bottom	= NORMALIZE_VALUE( inset.bottom );

	self.computedInset = inset;
}

- (void)computeMargin
{
	UIEdgeInsets margin = UIEdgeInsetsZero;
	
	margin.top		= [self.source.style computeMarginTopSize:self.bounds.width /* self.bounds.height */ defaultSize:INVALID_VALUE];
	margin.left		= [self.source.style computeMarginLeftSize:self.bounds.width defaultSize:INVALID_VALUE];
	margin.right	= [self.source.style computeMarginRightSize:self.bounds.width defaultSize:INVALID_VALUE];
	margin.bottom	= [self.source.style computeMarginBottomSize:self.bounds.width /* self.bounds.height */ defaultSize:INVALID_VALUE];

	margin.top		= NORMALIZE_VALUE( margin.top );
	margin.left		= NORMALIZE_VALUE( margin.left );
	margin.right	= NORMALIZE_VALUE( margin.right );
	margin.bottom	= NORMALIZE_VALUE( margin.bottom );
	
	self.computedMargin = margin;
}

- (void)computeBorder
{
	UIEdgeInsets border = UIEdgeInsetsZero;
	
	border.top		= [self.source.style computeBorderTopSize:self.bounds.width /* self.bounds.height */ defaultSize:INVALID_VALUE];
	border.left		= [self.source.style computeBorderLeftSize:self.bounds.width defaultSize:INVALID_VALUE];
	border.right	= [self.source.style computeBorderRightSize:self.bounds.width defaultSize:INVALID_VALUE];
	border.bottom	= [self.source.style computeBorderBottomSize:self.bounds.width /* self.bounds.height */ defaultSize:INVALID_VALUE];
	
	border.top		= NORMALIZE_VALUE( border.top );
	border.left		= NORMALIZE_VALUE( border.left );
	border.right	= NORMALIZE_VALUE( border.right );
	border.bottom	= NORMALIZE_VALUE( border.bottom );
	
	self.computedBorder = border;
}

- (void)computePadding
{
	UIEdgeInsets padding = UIEdgeInsetsZero;
	
	padding.top		= [self.source.style computePaddingTopSize:self.bounds.width /* self.bounds.height */ defaultSize:INVALID_VALUE];
	padding.left	= [self.source.style computePaddingLeftSize:self.bounds.width defaultSize:INVALID_VALUE];
	padding.right	= [self.source.style computePaddingRightSize:self.bounds.width defaultSize:INVALID_VALUE];
	padding.bottom	= [self.source.style computePaddingBottomSize:self.bounds.width /* self.bounds.height */ defaultSize:INVALID_VALUE];
	
	padding.top		= NORMALIZE_VALUE( padding.top );
	padding.left	= NORMALIZE_VALUE( padding.left );
	padding.right	= NORMALIZE_VALUE( padding.right );
	padding.bottom	= NORMALIZE_VALUE( padding.bottom );
	
	self.computedPadding = padding;
}

- (void)computeWidthShrink
{
	if ( [self.source.style isFixedWidth] )
		return;

	CGFloat boundsWidth = self.bounds.width;
	
	if ( INVALID_VALUE != boundsWidth )
	{
		CGFloat sizeWidth = self.computedSize.width;
		
		if ( INVALID_VALUE != sizeWidth )
		{
			CGFloat edgeWidth = 0.0f;

			edgeWidth += self.computedMargin.left;
			edgeWidth += self.computedBorder.left;
			edgeWidth += self.computedPadding.left;

			edgeWidth += self.computedMargin.right;
			edgeWidth += self.computedBorder.right;
			edgeWidth += self.computedPadding.right;

			if ( edgeWidth > 0.0f && sizeWidth + edgeWidth > boundsWidth )
			{
				CGSize newSize = self.computedSize;
				
				newSize.width = boundsWidth - edgeWidth;
				
				self.computedSize = newSize;
			}
		}
	}
}

- (void)computeMarginCollpase
{
	UIEdgeInsets margin = self.computedMargin;
	
	if ( 0.0f == self.computedBorder.top && 0.0f == self.computedPadding.top )
	{
		if ( 0.0f != self.collapse.top )
		{
			if ( margin.top <= self.collapse.top )
			{
				margin.top = 0.0f;
			}
			else
			{
				margin.top = margin.top - self.collapse.top;
			}
		}
	}
	
	if ( 0.0f == self.computedBorder.bottom && 0.0f == self.computedPadding.bottom )
	{
		if ( 0.0f != self.collapse.bottom )
		{
			if ( margin.bottom <= self.collapse.bottom )
			{
				margin.bottom = 0.0f;
			}
			else
			{
				margin.bottom = margin.bottom - self.collapse.bottom;
			}
		}
	}
	
	self.computedMargin = margin;
}

- (void)computeSize
{
	CGSize result = CGSizeZero;
 
	result.width	= [self.source.style computeWidth:self.bounds.width defaultSize:INVALID_VALUE];
	result.height	= [self.source.style computeHeight:self.bounds.height defaultSize:INVALID_VALUE];

	if ( [self.source.style isWidthEqualsToHeight] )
	{
		result.width = result.height;
	}
	
	if ( [self.source.style isHeightEqualsToWidth] )
	{
		result.height = result.width;
	}
	
//	result.width	= NORMALIZE_VALUE( result.width );
//	result.height	= NORMALIZE_VALUE( result.height );

	self.computedMinWidth	= [self.source.style computeMinWidth:self.bounds.width defaultSize:INVALID_VALUE];
	self.computedMaxWidth	= [self.source.style computeMaxWidth:self.bounds.width defaultSize:INVALID_VALUE];
	self.computedMinHeight	= [self.source.style computeMinHeight:self.bounds.height defaultSize:INVALID_VALUE];
	self.computedMaxHeight	= [self.source.style computeMaxHeight:self.bounds.height defaultSize:INVALID_VALUE];

	if ( INVALID_VALUE != self.computedMinWidth && result.width < self.computedMinWidth )
	{
		result.width = self.computedMinWidth;
	}
	
	if ( INVALID_VALUE != self.computedMinHeight && result.height < self.computedMinHeight )
	{
		result.height = self.computedMinHeight;
	}
	
	if ( INVALID_VALUE != self.computedMaxWidth && result.width > self.computedMaxWidth )
	{
		result.width = self.computedMaxWidth;
	}
	
	if ( INVALID_VALUE != self.computedMaxHeight && result.height > self.computedMaxHeight )
	{
		result.height = self.computedMaxHeight;
	}
	
	self.computedSize = result;
}

- (void)computeOffset
{
	UIEdgeInsets offset = UIEdgeInsetsZero;
	
	offset.top		= [self.source.style computeTop:self.bounds.height defaultSize:INVALID_VALUE];
	offset.left		= [self.source.style computeLeft:self.bounds.width defaultSize:INVALID_VALUE];
	offset.right	= [self.source.style computeRight:self.bounds.width defaultSize:INVALID_VALUE];
	offset.bottom	= [self.source.style computeBottom:self.bounds.height defaultSize:INVALID_VALUE];
	
	offset.top		= NORMALIZE_VALUE( offset.top );
	offset.left		= NORMALIZE_VALUE( offset.left );
	offset.right	= NORMALIZE_VALUE( offset.right );
	offset.bottom	= NORMALIZE_VALUE( offset.bottom );
	
	self.computedOffset = offset;
}

- (void)computeFrame
{
	CGRect frame;

	frame.origin = self.origin;
	frame.size = self.computedSize;

	frame.origin.x += self.computedInset.left;
	frame.origin.y += self.computedInset.top;
	frame.size.width -= self.computedInset.left;
	frame.size.width -= self.computedInset.right;
	frame.size.height -= self.computedInset.top;
	frame.size.height -= self.computedInset.bottom;

	frame.origin.x += self.computedMargin.left;
	frame.origin.y += self.computedMargin.top;
//	frame.size.width += self.computedMargin.left;
//	frame.size.width += self.computedMargin.right;
//	frame.size.height += self.computedMargin.top;
//	frame.size.height += self.computedMargin.bottom;

	frame.size.width += self.computedBorder.left;
	frame.size.width += self.computedBorder.right;
	frame.size.height += self.computedBorder.top;
	frame.size.height += self.computedBorder.bottom;

	frame.size.width += self.computedPadding.left;
	frame.size.width += self.computedPadding.right;
	frame.size.height += self.computedPadding.top;
	frame.size.height += self.computedPadding.bottom;

//	frame.origin.x = ceilf( frame.origin.x );
//	frame.origin.y = ceilf( frame.origin.y );
//	frame.size.width = ceilf( frame.size.width );
//	frame.size.height = ceilf( frame.size.height );
	
	self.frame = frame;
}

- (void)computeBounds
{
	CGRect bounds;
	
	bounds.origin = self.origin;

	bounds.size.width = self.computedSize.width;
	bounds.size.width += self.computedPadding.left;
	bounds.size.width += self.computedPadding.right;
	bounds.size.width += self.computedBorder.left;
	bounds.size.width += self.computedBorder.right;
	bounds.size.width += self.computedMargin.left;
	bounds.size.width += self.computedMargin.right;
	
	bounds.size.height = self.computedSize.height;
	bounds.size.height += self.computedPadding.top;
	bounds.size.height += self.computedPadding.bottom;
	bounds.size.height += self.computedBorder.top;
	bounds.size.height += self.computedBorder.bottom;
	bounds.size.height += self.computedMargin.top;
	bounds.size.height += self.computedMargin.bottom;
	
//	bounds.origin.x = ceilf( bounds.origin.x );
//	bounds.origin.y = ceilf( bounds.origin.y );
//	bounds.size.width = ceilf( bounds.size.width );
//	bounds.size.height = ceilf( bounds.size.height );

	self.computedBounds = bounds;
}

- (void)computeLineHeight
{
	CGFloat lineHeight = INVALID_VALUE;
	
	if ( self.source && [self.source.view respondsToSelector:@selector(font)] )
	{
		UIFont * font = [self.source.view performSelector:@selector(font) withObject:nil];
		
		if ( font )
		{
			lineHeight = [self.source.style computeLineHeight:font.lineHeight defaultSize:INVALID_VALUE];
		}
		else
		{
			lineHeight = [self.source.style computeLineHeight:self.bounds.height defaultSize:INVALID_VALUE];
		}
	}
	else
	{
		lineHeight = [self.source.style computeLineHeight:self.bounds.height defaultSize:INVALID_VALUE];
	}
	
	lineHeight = NORMALIZE_VALUE( lineHeight );
	
	self.computedLineHeight = lineHeight;
}

- (void)computeCellSpacing
{
	CGFloat cellSpacing = [self.source.style computeCellSpacing:self.bounds.width defaultSize:0.0f];
	
	cellSpacing = NORMALIZE_VALUE( cellSpacing );
	
	self.computedCellSpacing = cellSpacing;
}

- (void)computeCellPadding
{
	CGFloat cellPadding = [self.source.style computeCellPadding:self.bounds.width defaultSize:0.0f];

	cellPadding = NORMALIZE_VALUE( cellPadding );

	self.computedCellPadding = cellPadding;
}

- (void)computeBorderSpacing
{
	CGFloat borderSpacing = [self.source.style computeBorderSpacing:self.bounds.width defaultSize:0.0f];
	
	borderSpacing = NORMALIZE_VALUE( borderSpacing );
	
	self.computedBorderSpacing = borderSpacing;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlLayoutObject )

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
