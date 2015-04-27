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

#import "Samurai_HtmlRenderObjectText.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@interface __HtmlTextView : UILabel
@end
@implementation __HtmlTextView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		self.textAlignment = NSTextAlignmentLeft;
		self.lineBreakMode = NSLineBreakByCharWrapping;
	}
	return self;
}

- (void)dealloc
{
}

@end

#pragma mark -

@implementation SamuraiHtmlRenderObjectText

+ (Class)defaultViewClass
{
	return [__HtmlTextView class];
}

#pragma mark -

- (BOOL)store_isValid
{
	return YES;
}

- (BOOL)store_hasChildren
{
	return NO;
}

#pragma mark -

- (CGRect)computeFrame:(CGSize)bound origin:(CGPoint)origin;
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
	
	if ( [self.parent.style isAutoWidth] && [self.parent.style isAutoHeight] )
	{
		computedFrame.size = [self.view computeSizeBySize:bound];
	}
	else if ( [self.parent.style isAutoWidth] )
	{
		computedFrame.size.width = [self.view computeSizeByHeight:bound.height].width;
		computedFrame.size.height = bound.height;
	}
	else if ( [self.parent.style isAutoHeight] )
	{
		computedFrame.size.width = bound.width;
		computedFrame.size.height = [self.view computeSizeByWidth:bound.width].height;
	}
	else
	{
		computedFrame.size = bound;
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
	
	outerBound.origin = CGPointZero;
	
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
	return [self.view serialize];
}

- (void)unserialize:(id)obj
{
	[self.view unserialize:obj];
}

- (void)zerolize
{
	[self.view zerolize];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, HtmlRenderObjectText )

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
