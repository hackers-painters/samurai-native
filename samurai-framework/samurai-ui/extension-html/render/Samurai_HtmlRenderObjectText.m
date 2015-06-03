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

#import "HtmlText.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiHtmlRenderObjectText

+ (instancetype)renderObjectWithDom:(SamuraiHtmlDomNode *)dom andStyle:(SamuraiHtmlStyle *)style
{
	SamuraiHtmlRenderObjectText * renderObject = [super renderObjectWithDom:dom andStyle:style];
	
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
	return [HtmlText class];
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

- (CGRect)computeFrame:(CGSize)bound origin:(CGPoint)origin;
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
	
	CGSize textSize = CGSizeZero;
	
	if ( INVALID_VALUE == computedSize.width && INVALID_VALUE == computedSize.height )
	{
		textSize = [self.view computeSizeBySize:computedSize];
	}
	else if ( INVALID_VALUE == computedSize.width )
	{
		textSize = [self.view computeSizeByHeight:computedSize.height];
	}
	else if ( INVALID_VALUE == computedSize.height )
	{
		textSize = [self.view computeSizeByWidth:computedSize.width];
	}
	else
	{
		textSize = [self.view computeSizeBySize:computedSize];
		textSize.width	= fminf( computedSize.width, textSize.width );
		textSize.height	= fminf( computedSize.height, textSize.height );
	}
	
	if ( self.parent )
	{
		CGFloat lineHeight = INVALID_VALUE;
		
		if ( [self.view respondsToSelector:@selector(font)] )
		{
			UIFont * font = [self.view performSelector:@selector(font) withObject:nil];
			
			if ( font )
			{
				lineHeight = [self.parent computeLineHeight:font.lineHeight];
			}
			else
			{
				lineHeight = [self.parent computeLineHeight:bound.height];
			}
		}
		else
		{
			lineHeight = [self.parent computeLineHeight:bound.height];
		}
		
		if ( INVALID_VALUE != lineHeight )
		{
			if ( textSize.height < lineHeight )
			{
				textSize.height = lineHeight;
			}
		}	
	}
	
	computedSize = textSize;

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
	
	if ( INVALID_VALUE != minWidth )
	{
		if ( computedSize.width < minWidth )
		{
			computedSize.width = minWidth;
		}
	}
	
	if ( INVALID_VALUE != minHeight )
	{
		if ( computedSize.height < minHeight )
		{
			computedSize.height = minHeight;
		}
	}
	
	if ( INVALID_VALUE != maxWidth )
	{
		if ( computedSize.width > maxWidth )
		{
			computedSize.width = maxWidth;
		}
	}
	
	if ( INVALID_VALUE != maxHeight )
	{
		if ( computedSize.height > maxHeight )
		{
			computedSize.height = maxHeight;
		}
	}

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
