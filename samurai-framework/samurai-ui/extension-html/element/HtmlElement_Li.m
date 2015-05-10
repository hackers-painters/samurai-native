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

#import "HtmlElement_Li.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_HtmlStyle.h"
#import "Samurai_HtmlRenderObject.h"
#import "Samurai_HtmlUserAgent.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@interface __HtmlArrow : UILabel

- (void)setDiscType;
- (void)setCircleType;
- (void)setSquareType;
- (void)setTextType:(NSString *)text;

@end

#pragma mark -

@implementation __HtmlArrow

- (void)setDiscType
{
	self.frame = CGRectMake( self.frame.origin.x, self.frame.origin.y, 6.0f, 6.0f );
	self.layer.borderColor = [[UIColor clearColor] CGColor];
	self.layer.borderWidth = 0.0f;
	self.layer.cornerRadius = 4.0f;
	self.layer.masksToBounds = YES;
	self.backgroundColor = [UIColor darkGrayColor];
	self.text = nil;
}

- (void)setCircleType
{
	self.frame = CGRectMake( self.frame.origin.x, self.frame.origin.y, 4.0f, 4.0f );
	self.layer.borderColor = [[UIColor darkGrayColor] CGColor];
	self.layer.borderWidth = 2.0f;
	self.layer.cornerRadius = 3.0f;
	self.layer.masksToBounds = YES;
	self.backgroundColor = [UIColor clearColor];
	self.text = nil;
}

- (void)setSquareType
{
	self.frame = CGRectMake( self.frame.origin.x, self.frame.origin.y, 6.0f, 6.0f );
	self.layer.borderColor = [[UIColor clearColor] CGColor];
	self.layer.borderWidth = 0.0f;
	self.layer.cornerRadius = 0.0f;
	self.layer.masksToBounds = YES;
	self.backgroundColor = [UIColor darkGrayColor];
	self.text = nil;
}

- (void)setTextType:(NSString *)text
{
	self.frame = CGRectMake( self.frame.origin.x, self.frame.origin.y, 60.0f, 12.0f );
	self.layer.borderColor = [[UIColor clearColor] CGColor];
	self.layer.borderWidth = 0.0f;
	self.layer.cornerRadius = 0.0f;
	self.text = nil;
	self.font = [SamuraiHtmlUserAgent sharedInstance].defaultFont;
	self.textColor = [UIColor darkGrayColor];
	self.textAlignment = NSTextAlignmentRight;
	self.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
	self.lineBreakMode = NSLineBreakByClipping;
	self.numberOfLines = 1;
}

- (void)setDecimal:(NSUInteger)index
{
	[self setTextType:[NSString stringWithFormat:@"%lu.", index]];
}

- (void)setDecimalLeadingZero:(NSUInteger)index
{
	[self setTextType:[NSString stringWithFormat:@"0%lu.", index]];
}

@end

#pragma mark -

@implementation HtmlElement_Li
{
	NSUInteger		_index;
	CGFloat			_lineHeight;
	__HtmlArrow *	_arrow;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		self.layer.masksToBounds = NO;
	}
	return self;
}

- (void)dealloc
{
}

- (void)html_applyDom:(SamuraiHtmlDomNode *)dom
{
	[super html_applyDom:dom];
	
	_index = 0;

	if ( dom.parent )
	{
		for ( SamuraiHtmlDomNode * sibling in dom.parent.childs )
		{
			if ( sibling == dom )
				break;

			if ( NSOrderedSame == [sibling.domTag compare:dom.domTag] )
			{
				_index += 1;
			}
		}
	}
}

- (void)html_applyStyle:(SamuraiHtmlStyle *)style
{
	[super html_applyStyle:style];
	
	if ( nil == _arrow )
	{
		_arrow = [[__HtmlArrow alloc] initWithFrame:CGRectZero];
		_arrow.hidden = NO;

		[self addSubview:_arrow];
		[self bringSubviewToFront:_arrow];
	}

	_lineHeight = [style computeFont:_arrow.font].lineHeight;

	SamuraiHtmlValue * listStyleType = style.listStyleType;
	SamuraiHtmlValue * listStyleImage = style.listStyleImage;
	SamuraiHtmlValue * listStylePosition = style.listStylePosition;

	if ( listStyleType )
	{
		if ( [listStyleType isString:@"disc"] )
		{
			_arrow.hidden = NO;

			[_arrow setDiscType];
		}
		else if ( [listStyleType isString:@"circle"] )
		{
			_arrow.hidden = NO;
			
			[_arrow setCircleType];
		}
		else if ( [listStyleType isString:@"square"] )
		{
			_arrow.hidden = NO;
			
			[_arrow setSquareType];
		}
		else if ( [listStyleType isString:@"decimal"] )
		{
			_arrow.hidden = NO;
			
			[_arrow setDecimal:_index];
		}
		else if ( [listStyleType isString:@"decimal-leading-zero"] )
		{
			_arrow.hidden = NO;
			
			[_arrow setDecimalLeadingZero:_index];
		}
		else if ( [listStyleType isString:@"lower-roman"] )
		{
			// 小写罗马数字(i, ii, iii, iv, v, 等。)
			
			_arrow.hidden = NO;
			
			[_arrow setDecimal:_index];
		}
		else if ( [listStyleType isString:@"upper-roman"] )
		{
			// 大写罗马数字(I, II, III, IV, V, 等。)
			
			_arrow.hidden = NO;
			
			[_arrow setDecimal:_index];
		}
		else if ( [listStyleType isString:@"lower-alpha"] )
		{
			// 小写英文字母The marker is lower-alpha (a, b, c, d, e, 等。)
			
			_arrow.hidden = NO;
			
			[_arrow setDecimal:_index];
		}
		else if ( [listStyleType isString:@"upper-alpha"] )
		{
			// 大写英文字母The marker is upper-alpha (A, B, C, D, E, 等。)
			
			_arrow.hidden = NO;
			
			[_arrow setDecimal:_index];
		}
		else if ( [listStyleType isString:@"lower-greek"] )
		{
			// 小写希腊字母(alpha, beta, gamma, 等。)
			
			_arrow.hidden = NO;
			
			[_arrow setDecimal:_index];
		}
		else if ( [listStyleType isString:@"lower-latin"] )
		{
			// 小写拉丁字母(a, b, c, d, e, 等。)
			
			_arrow.hidden = NO;
			
			[_arrow setDecimal:_index];
		}
		else if ( [listStyleType isString:@"upper-latin"] )
		{
			// 大写拉丁字母(A, B, C, D, E, 等。)
			
			_arrow.hidden = NO;
			
			[_arrow setDecimal:_index];
		}
		else if ( [listStyleType isString:@"hebrew"] )
		{
			// 传统的希伯来编号方式
			
			_arrow.hidden = NO;
			
			[_arrow setDecimal:_index];
		}
		else if ( [listStyleType isString:@"armenian"] )
		{
			// 传统的亚美尼亚编号方式
			
			_arrow.hidden = NO;
			
			[_arrow setDecimal:_index];
		}
		else if ( [listStyleType isString:@"georgian"] )
		{
			// 传统的乔治亚编号方式(an, ban, gan, 等。)
			
			_arrow.hidden = NO;
			
			[_arrow setDecimal:_index];
		}
		else if ( [listStyleType isString:@"cjk-ideographic"] )
		{
			// 简单的表意数字
			
			_arrow.hidden = NO;
			
			[_arrow setDecimal:_index];
		}
		else if ( [listStyleType isString:@"hiragana"] )
		{
			// 标记是：a, i, u, e, o, ka, ki, 等。（日文片假名）
			
			_arrow.hidden = NO;
			
			[_arrow setDecimal:_index];
		}
		else if ( [listStyleType isString:@"katakana"] )
		{
			// 标记是：A, I, U, E, O, KA, KI, 等。（日文片假名）
			
			_arrow.hidden = NO;
			
			[_arrow setDecimal:_index];
		}
		else if ( [listStyleType isString:@"hiragana-iroha"] )
		{
			// 标记是：i, ro, ha, ni, ho, he, to, 等。（日文片假名）
			
			_arrow.hidden = NO;
			
			[_arrow setDecimal:_index];
		}
		else if ( [listStyleType isString:@"katakana-iroha"] )
		{
			// 标记是：I, RO, HA, NI, HO, HE, TO, 等。（日文片假名）
			
			_arrow.hidden = NO;
			
			[_arrow setDecimal:_index];
		}
		else if ( [listStyleType isString:@"none"] )
		{
			_arrow.hidden = YES;
		}
		else
		{
			_arrow.hidden = YES;
		}
	}
	else
	{
		_arrow.hidden = NO;
		
		[_arrow setDiscType];
	}
}

- (void)html_applyFrame:(CGRect)newFrame
{
	[super html_applyFrame:newFrame];
	
	CGRect arrowFrame = _arrow.frame;

	arrowFrame.origin.x = -1.0f * arrowFrame.size.width - 10.0f;
	arrowFrame.origin.y = (_lineHeight - arrowFrame.size.height) / 2.0f;

	_arrow.frame = arrowFrame;

	[self bringSubviewToFront:_arrow];
	[self setNeedsDisplay];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, HtmlElement_Li )

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
