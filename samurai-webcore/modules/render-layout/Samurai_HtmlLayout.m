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

#import "Samurai_HtmlLayout.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_HtmlRenderObject.h"
#import "Samurai_HtmlStyle.h"
#import "Samurai_UIView.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

void htmlComputeInset( SamuraiHtmlLayoutContext * context )
{
	UIEdgeInsets inset = UIEdgeInsetsZero;
	
	inset.top		= [context->style computeInsetTopSize:context->computedSize.height defaultSize:INVALID_VALUE];
	inset.left		= [context->style computeInsetLeftSize:context->computedSize.width defaultSize:INVALID_VALUE];
	inset.right		= [context->style computeInsetRightSize:context->computedSize.width defaultSize:INVALID_VALUE];
	inset.bottom	= [context->style computeInsetBottomSize:context->computedSize.height defaultSize:INVALID_VALUE];
	
	inset.top		= NORMALIZE_VALUE( inset.top );
	inset.left		= NORMALIZE_VALUE( inset.left );
	inset.right		= NORMALIZE_VALUE( inset.right );
	inset.bottom	= NORMALIZE_VALUE( inset.bottom );
	
	context->computedInset = inset;
}

void htmlComputeMargin( SamuraiHtmlLayoutContext * context )
{
	UIEdgeInsets margin = UIEdgeInsetsZero;
	
	margin.top		= [context->style computeMarginTopSize:context->computedSize.height defaultSize:INVALID_VALUE];
	margin.left		= [context->style computeMarginLeftSize:context->computedSize.width defaultSize:INVALID_VALUE];
	margin.right	= [context->style computeMarginRightSize:context->computedSize.width defaultSize:INVALID_VALUE];
	margin.bottom	= [context->style computeMarginBottomSize:context->computedSize.height defaultSize:INVALID_VALUE];

	margin.top		= NORMALIZE_VALUE( margin.top );
	margin.left		= NORMALIZE_VALUE( margin.left );
	margin.right	= NORMALIZE_VALUE( margin.right );
	margin.bottom	= NORMALIZE_VALUE( margin.bottom );
	
	context->computedMargin = margin;
}

void htmlComputeBorder( SamuraiHtmlLayoutContext * context )
{
	UIEdgeInsets border = UIEdgeInsetsZero;

	border.top		= [context->style computeBorderTopSize:context->computedSize.height defaultSize:INVALID_VALUE];
	border.left		= [context->style computeBorderLeftSize:context->computedSize.width defaultSize:INVALID_VALUE];
	border.right	= [context->style computeBorderRightSize:context->computedSize.width defaultSize:INVALID_VALUE];
	border.bottom	= [context->style computeBorderBottomSize:context->computedSize.height defaultSize:INVALID_VALUE];

	border.top		= NORMALIZE_VALUE( border.top );
	border.left		= NORMALIZE_VALUE( border.left );
	border.right	= NORMALIZE_VALUE( border.right );
	border.bottom	= NORMALIZE_VALUE( border.bottom );
	
	context->computedBorder = border;
}

void htmlComputePadding( SamuraiHtmlLayoutContext * context )
{
	UIEdgeInsets padding = UIEdgeInsetsZero;

	padding.top		= [context->style computePaddingTopSize:context->computedSize.height defaultSize:INVALID_VALUE];
	padding.left	= [context->style computePaddingLeftSize:context->computedSize.width defaultSize:INVALID_VALUE];
	padding.right	= [context->style computePaddingRightSize:context->computedSize.width defaultSize:INVALID_VALUE];
	padding.bottom	= [context->style computePaddingBottomSize:context->computedSize.height defaultSize:INVALID_VALUE];

	padding.top		= NORMALIZE_VALUE( padding.top );
	padding.left	= NORMALIZE_VALUE( padding.left );
	padding.right	= NORMALIZE_VALUE( padding.right );
	padding.bottom	= NORMALIZE_VALUE( padding.bottom );
	
	context->computedPadding = padding;
}

void htmlComputeMinMax( SamuraiHtmlLayoutContext * context )
{
	context->computedMinWidth	= [context->style computeMinWidth:context->bounds.width defaultSize:INVALID_VALUE];
	context->computedMaxWidth	= [context->style computeMaxWidth:context->bounds.width defaultSize:INVALID_VALUE];
	context->computedMinHeight	= [context->style computeMinHeight:context->bounds.height defaultSize:INVALID_VALUE];
	context->computedMaxHeight	= [context->style computeMaxHeight:context->bounds.height defaultSize:INVALID_VALUE];
}

void htmlComputeSize( SamuraiHtmlLayoutContext * context )
{
	CGSize result = CGSizeZero;
 
	result.width	= [context->style computeWidth:context->bounds.width defaultSize:INVALID_VALUE];
	result.height	= [context->style computeHeight:context->bounds.height defaultSize:INVALID_VALUE];

	if ( [context->style isWidthEqualsToHeight] )
	{
		result.width = result.height;
	}
	
	if ( [context->style isHeightEqualsToWidth] )
	{
		result.height = result.width;
	}

//	result.width	= NORMALIZE_VALUE( result.width );
//	result.height	= NORMALIZE_VALUE( result.height );
	
	if ( INVALID_VALUE != context->computedMinWidth && result.width < context->computedMinWidth )
	{
		result.width = context->computedMinWidth;
	}
	
	if ( INVALID_VALUE != context->computedMinHeight && result.height < context->computedMinHeight )
	{
		result.height = context->computedMinHeight;
	}
	
	if ( INVALID_VALUE != context->computedMaxWidth && result.width > context->computedMaxWidth )
	{
		result.width = context->computedMaxWidth;
	}
	
	if ( INVALID_VALUE != context->computedMaxHeight && result.height > context->computedMaxHeight )
	{
		result.height = context->computedMaxHeight;
	}
	
	context->computedSize = result;
}

void htmlComputeOffset( SamuraiHtmlLayoutContext * context )
{
	UIEdgeInsets offset = UIEdgeInsetsZero;
	
	offset.top		= [context->style computeTop:context->bounds.height defaultSize:INVALID_VALUE];
	offset.left		= [context->style computeLeft:context->bounds.width defaultSize:INVALID_VALUE];
	offset.right	= [context->style computeRight:context->bounds.width defaultSize:INVALID_VALUE];
	offset.bottom	= [context->style computeBottom:context->bounds.height defaultSize:INVALID_VALUE];
	
	offset.top		= NORMALIZE_VALUE( offset.top );
	offset.left		= NORMALIZE_VALUE( offset.left );
	offset.right	= NORMALIZE_VALUE( offset.right );
	offset.bottom	= NORMALIZE_VALUE( offset.bottom );

	context->computedOffset = offset;
}

void htmlComputeCollpase( SamuraiHtmlLayoutContext * context )
{
	if ( 0.0f == context->computedBorder.top && 0.0f != context->collapse.top )
	{
		if ( context->computedMargin.top <= context->collapse.top )
		{
			context->computedMargin.top = 0.0f;
		}
		else
		{
			context->computedMargin.top = context->computedMargin.top - context->collapse.top;
		}
	}
	
	if ( 0.0f == context->computedBorder.bottom && 0.0f != context->collapse.bottom )
	{
		if ( context->computedMargin.bottom <= context->collapse.bottom )
		{
			context->computedMargin.bottom = 0.0f;
		}
		else
		{
			context->computedMargin.bottom = context->computedMargin.bottom - context->collapse.bottom;
		}
	}
}

void htmlComputeBounds( SamuraiHtmlLayoutContext * context )
{
	CGRect result;
	
	result.origin = context->origin;
	
	result.size.width = context->computedSize.width;
	result.size.width += context->computedPadding.left;
	result.size.width += context->computedPadding.right;
	result.size.width += context->computedBorder.left;
	result.size.width += context->computedBorder.right;
	result.size.width += context->computedMargin.left;
	result.size.width += context->computedMargin.right;
	
	result.size.height = context->computedSize.height;
	result.size.height += context->computedPadding.top;
	result.size.height += context->computedPadding.bottom;
	result.size.height += context->computedBorder.top;
	result.size.height += context->computedBorder.bottom;
	result.size.height += context->computedMargin.top;
	result.size.height += context->computedMargin.bottom;
	
	context->computedBounds = result;
}

void htmlComputeBorderSpacing( SamuraiHtmlLayoutContext * context )
{
	CGFloat borderSpacing = [context->style computeBorderSpacing:context->bounds.width defaultSize:0.0f];
	borderSpacing = NORMALIZE_VALUE( borderSpacing );
	context->computedBorderSpacing = borderSpacing;
}

void htmlComputeCellSpacing( SamuraiHtmlLayoutContext * context )
{
	CGFloat cellSpacing = [context->style computeCellSpacing:context->bounds.width defaultSize:0.0f];
	cellSpacing = NORMALIZE_VALUE( cellSpacing );
	context->computedCellSpacing = cellSpacing;
}

void htmlComputeCellPadding( SamuraiHtmlLayoutContext * context )
{
	CGFloat cellPadding = [context->style computeCellPadding:context->bounds.width defaultSize:0.0f];
	cellPadding = NORMALIZE_VALUE( cellPadding );
	context->computedCellPadding = cellPadding;
}

void htmlComputeLineHeight( SamuraiHtmlLayoutContext * context, CGFloat fontHeight )
{
	CGFloat lineHeight = [context->style computeLineHeight:fontHeight defaultSize:0.0f];
	lineHeight = NORMALIZE_VALUE( lineHeight );
	context->computedLineHeight = lineHeight;
}

#pragma mark -

void htmlLayoutInit( SamuraiHtmlLayoutContext * context )
{
	context->computedMinWidth		= INVALID_VALUE;
	context->computedMaxWidth		= INVALID_VALUE;
	context->computedMinHeight		= INVALID_VALUE;
	context->computedMaxHeight		= INVALID_VALUE;
	
	context->computedSize			= CGSizeZero;
	context->computedBounds			= CGRectZero;
	
	context->computedInset			= UIEdgeInsetsZero;
	context->computedBorder			= UIEdgeInsetsZero;
	context->computedMargin			= UIEdgeInsetsZero;
	context->computedPadding		= UIEdgeInsetsZero;

	context->computedLineHeight		= INVALID_VALUE;
	context->computedBorderSpacing	= INVALID_VALUE;
	context->computedCellSpacing	= INVALID_VALUE;
	context->computedCellPadding	= INVALID_VALUE;
}

void htmlLayoutResize( SamuraiHtmlLayoutContext * context, CGSize newSize )
{
	CGSize result = newSize;
	
	if ( [context->style isWidthEqualsToHeight] )
	{
		result.width = newSize.height;
	}
	
	if ( [context->style isHeightEqualsToWidth] )
	{
		result.height = newSize.width;
	}
	
	result.width	= NORMALIZE_VALUE( result.width );
	result.height	= NORMALIZE_VALUE( result.height );

	if ( INVALID_VALUE != context->computedMinWidth && result.width < context->computedMinWidth )
	{
		result.width = context->computedMinWidth;
	}

	if ( INVALID_VALUE != context->computedMinHeight && result.height < context->computedMinHeight )
	{
		result.height = context->computedMinHeight;
	}

	if ( INVALID_VALUE != context->computedMaxWidth && result.width > context->computedMaxWidth )
	{
		result.width = context->computedMaxWidth;
	}

	if ( INVALID_VALUE != context->computedMaxHeight && result.height > context->computedMaxHeight )
	{
		result.height = context->computedMaxHeight;
	}

	context->computedSize = result;
}

void htmlLayoutBegin( SamuraiHtmlLayoutContext * context )
{
	if ( nil == context->style )
		return;
	
	htmlComputeMinMax( context );
	htmlComputeSize( context );
	htmlComputeInset( context );
	htmlComputeMargin( context );
	htmlComputeBorder( context );
	htmlComputePadding( context );
	htmlComputeCollpase( context );
}

void htmlLayoutFinish( SamuraiHtmlLayoutContext * context )
{
	htmlComputeBounds( context );
}

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlLayout )

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
