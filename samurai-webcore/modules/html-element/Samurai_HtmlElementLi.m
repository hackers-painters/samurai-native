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

#import "Samurai_HtmlElementLi.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_HtmlRenderStyle.h"
#import "Samurai_HtmlRenderObject.h"
#import "Samurai_HtmlRenderStoreScope.h"
#import "Samurai_HtmlUserAgent.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiHtmlElementLi

@def_prop_strong( UILabel *,	listIcon )
@def_prop_assign( HtmlListType,	listType )
@def_prop_assign( NSUInteger,	listIndex )

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		self.listType = HtmlListType_None;
		self.listIndex = 0;
	}
	return self;
}

- (void)dealloc
{
	[self.listIcon removeFromSuperview];
	self.listIcon = nil;
}

#pragma mark -

- (void)html_applyDom:(SamuraiHtmlDomNode *)dom
{
	[super html_applyDom:dom];
	
	self.listIndex = 0;

	if ( dom.parent )
	{
		for ( SamuraiHtmlDomNode * sibling in dom.parent.childs )
		{
			if ( sibling == dom )
				break;

			if ( NSOrderedSame == [sibling.tag compare:dom.tag] )
			{
				self.listIndex += 1;
			}
		}
	}
}

- (void)html_applyStyle:(SamuraiHtmlRenderStyle *)style
{
	[super html_applyStyle:style];
	
	SamuraiCSSValue * listStyleType = style.listStyleType;
//	SamuraiCSSValue * listStyleImage = style.listStyleImage;
//	SamuraiCSSValue * listStylePosition = style.listStylePosition;

	TODO( "list-style-image" );
	TODO( "list-style-position" );
	
	if ( listStyleType )
	{
		if ( [listStyleType isString:@"disc"] )
		{
			self.listType = HtmlListType_Disc;
		}
		else if ( [listStyleType isString:@"circle"] )
		{
			self.listType = HtmlListType_Circle;
		}
		else if ( [listStyleType isString:@"square"] )
		{
			self.listType = HtmlListType_Square;
		}
		else if ( [listStyleType isString:@"decimal"] )
		{
			self.listType = HtmlListType_Decimal;
		}
		else if ( [listStyleType isString:@"decimal-leading-zero"] )
		{
			self.listType = HtmlListType_Decimal;
		}
		else if ( [listStyleType isString:@"lower-roman"] )
		{
			// 小写罗马数字(i, ii, iii, iv, v, 等。)
			
			self.listType = HtmlListType_Decimal;
		}
		else if ( [listStyleType isString:@"upper-roman"] )
		{
			// 大写罗马数字(I, II, III, IV, V, 等。)
			
			self.listType = HtmlListType_Decimal;
		}
		else if ( [listStyleType isString:@"lower-alpha"] )
		{
			// 小写英文字母The marker is lower-alpha (a, b, c, d, e, 等。)
			
			self.listType = HtmlListType_Decimal;
		}
		else if ( [listStyleType isString:@"upper-alpha"] )
		{
			// 大写英文字母The marker is upper-alpha (A, B, C, D, E, 等。)
			
			self.listType = HtmlListType_Decimal;
		}
		else if ( [listStyleType isString:@"lower-greek"] )
		{
			// 小写希腊字母(alpha, beta, gamma, 等。)
			
			self.listType = HtmlListType_Decimal;
		}
		else if ( [listStyleType isString:@"lower-latin"] )
		{
			// 小写拉丁字母(a, b, c, d, e, 等。)
			
			self.listType = HtmlListType_Decimal;
		}
		else if ( [listStyleType isString:@"upper-latin"] )
		{
			// 大写拉丁字母(A, B, C, D, E, 等。)
			
			self.listType = HtmlListType_Decimal;
		}
		else if ( [listStyleType isString:@"hebrew"] )
		{
			// 传统的希伯来编号方式
			
			self.listType = HtmlListType_Decimal;
		}
		else if ( [listStyleType isString:@"armenian"] )
		{
			// 传统的亚美尼亚编号方式
			
			self.listType = HtmlListType_Decimal;
		}
		else if ( [listStyleType isString:@"georgian"] )
		{
			// 传统的乔治亚编号方式(an, ban, gan, 等。)
			
			self.listType = HtmlListType_Decimal;
		}
		else if ( [listStyleType isString:@"cjk-ideographic"] )
		{
			// 简单的表意数字
			
			self.listType = HtmlListType_Decimal;
		}
		else if ( [listStyleType isString:@"hiragana"] )
		{
			// 标记是：a, i, u, e, o, ka, ki, 等。（日文片假名）
			
			self.listType = HtmlListType_Decimal;
		}
		else if ( [listStyleType isString:@"katakana"] )
		{
			// 标记是：A, I, U, E, O, KA, KI, 等。（日文片假名）
			
			self.listType = HtmlListType_Decimal;
		}
		else if ( [listStyleType isString:@"hiragana-iroha"] )
		{
			// 标记是：i, ro, ha, ni, ho, he, to, 等。（日文片假名）
			
			self.listType = HtmlListType_Decimal;
		}
		else if ( [listStyleType isString:@"katakana-iroha"] )
		{
			// 标记是：I, RO, HA, NI, HO, HE, TO, 等。（日文片假名）
			
			self.listType = HtmlListType_Decimal;
		}
		else if ( [listStyleType isString:@"none"] )
		{
			self.listType = HtmlListType_None;
		}
		else
		{
			self.listType = HtmlListType_None;
		}
	}
	else
	{
		self.listType = HtmlListType_None;
	}
}

- (void)html_applyFrame:(CGRect)newFrame
{
	[super html_applyFrame:newFrame];

	SamuraiHtmlRenderObject * renderer = (SamuraiHtmlRenderObject *)self.renderer;
	
	if ( renderer && CSSDisplay_ListItem != renderer.display )
	{
		self.listIcon.hidden = YES;
		return;
	}
	
	if ( HtmlListType_None == self.listType )
	{
		self.listIcon.hidden = YES;
		return;
	}

	if ( nil == self.listIcon )
	{
		self.listIcon = [[UILabel alloc] init];
		
		[self addSubview:self.listIcon];
		[self bringSubviewToFront:self.listIcon];
	}
	
	if ( HtmlListType_Disc == self.listType )
	{
		CGRect iconFrame;
		
		iconFrame.size.width = 6.0f;
		iconFrame.size.height = 6.0f;
		iconFrame.origin.x = -iconFrame.size.width - 10.0f;
		iconFrame.origin.y = 6.0f; // (newFrame.size.height - iconFrame.size.height) / 2.0f;
		
		self.listIcon.frame = iconFrame;
		self.listIcon.hidden = NO;
		self.listIcon.layer.borderColor = [[UIColor clearColor] CGColor];
		self.listIcon.layer.borderWidth = 0.0f;
		self.listIcon.layer.cornerRadius = 3.0f;
		self.listIcon.layer.masksToBounds = YES;
		self.listIcon.backgroundColor = [UIColor darkGrayColor];
		
		self.listIcon.text = nil;
	}
	else if ( HtmlListType_Circle == self.listType )
	{
		CGRect iconFrame;
		
		iconFrame.size.width = 6.0f;
		iconFrame.size.height = 6.0f;
		iconFrame.origin.x = -iconFrame.size.width - 10.0f;
		iconFrame.origin.y = 6.0f; // (newFrame.size.height - iconFrame.size.height) / 2.0f;

		self.listIcon.frame = iconFrame;
		self.listIcon.hidden = NO;
		self.listIcon.layer.borderColor = [[UIColor clearColor] CGColor];
		self.listIcon.layer.borderWidth = 3.0f;
		self.listIcon.layer.cornerRadius = 3.0f;
		self.listIcon.layer.masksToBounds = YES;
		self.listIcon.backgroundColor = [UIColor darkGrayColor];
		
		self.listIcon.text = nil;
	}
	else if ( HtmlListType_Square == self.listType )
	{
		CGRect iconFrame;
		
		iconFrame.size.width = 6.0f;
		iconFrame.size.height = 6.0f;
		iconFrame.origin.x = -iconFrame.size.width - 10.0f;
		iconFrame.origin.y = 6.0f; // (newFrame.size.height - iconFrame.size.height) / 2.0f;
		
		self.listIcon.frame = iconFrame;
		self.listIcon.hidden = NO;
		self.listIcon.layer.borderColor = [[UIColor clearColor] CGColor];
		self.listIcon.layer.borderWidth = 0.0f;
		self.listIcon.layer.cornerRadius = 0.0f;
		self.listIcon.layer.masksToBounds = YES;
		self.listIcon.backgroundColor = [UIColor darkGrayColor];
		
		self.listIcon.text = nil;
	}
	else if ( HtmlListType_Decimal == self.listType )
	{
		CGRect iconFrame;
		
		iconFrame.size.width = 40.0f;
		iconFrame.size.height = 12.0f;
		iconFrame.origin.x = -iconFrame.size.width - 10.0f;
		iconFrame.origin.y = 4.0f; // (newFrame.size.height - iconFrame.size.height) / 2.0f;
		
		self.listIcon.frame = iconFrame;
		self.listIcon.hidden = NO;
		self.listIcon.layer.borderColor = [[UIColor clearColor] CGColor];
		self.listIcon.layer.borderWidth = 0.0f;
		self.listIcon.layer.cornerRadius = 0.0f;
		self.listIcon.layer.masksToBounds = YES;
		self.listIcon.backgroundColor = [UIColor clearColor];

		self.listIcon.font = [SamuraiHtmlUserAgent sharedInstance].defaultFont;
		self.listIcon.textColor = [UIColor darkGrayColor];
		self.listIcon.textAlignment = NSTextAlignmentRight;
		self.listIcon.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		self.listIcon.lineBreakMode = NSLineBreakByClipping;
		self.listIcon.numberOfLines = 1;

		self.listIcon.text = [NSString stringWithFormat:@"%lu.", (unsigned long)self.listIndex + 1];
	}
	else
	{
		self.listIcon.hidden = YES;
	}
}

#pragma mark -

- (id)store_serialize
{
	return [super store_serialize];
}

- (void)store_unserialize:(id)obj
{
	[super store_unserialize:obj];
}

- (void)store_zerolize
{
	[super store_zerolize];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlElementLi )

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
