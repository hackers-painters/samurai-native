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

#import "UILabel+Html.h"

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

@implementation UILabel(Html)

+ (CSSViewHierarchy)style_viewHierarchy
{
	return CSSViewHierarchy_Leaf;
}

#pragma mark -

- (void)html_applyDom:(SamuraiHtmlDomNode *)dom
{
	[super html_applyDom:dom];

	[self unserialize:[dom computeInnerText]];
}

- (void)html_applyStyle:(SamuraiHtmlRenderStyle *)style
{
	[super html_applyStyle:style];

	self.font = [style computeFont:[SamuraiHtmlUserAgent sharedInstance].defaultFont];
	self.textColor = [style computeColor:self.textColor];
	self.textAlignment = [style computeTextAlignment:self.textAlignment];
	self.baselineAdjustment = [style computeBaselineAdjustment:self.baselineAdjustment];
	self.lineBreakMode = [style computeLineBreakMode:self.lineBreakMode];
	
	CSSWhiteSpace whiteSpace = [style computeWhiteSpace:CSSWhiteSpace_Normal];
	
	if ( CSSWhiteSpace_Normal == whiteSpace )
	{
		self.numberOfLines = 0;
	}
	else if ( CSSWhiteSpace_NoWrap == whiteSpace )
	{
		self.numberOfLines = 1;
	}
	else
	{
		TODO( "support more white-space" );
		
		self.numberOfLines = 0;
	}
	
	self.headIndent = [style computeTextIndent:INVALID_VALUE];
	self.lineHeight = [style computeLineHeight:self.font.lineHeight defaultSize:INVALID_VALUE];
	self.letterSpacing = [style computeLetterSpacing:INVALID_VALUE];
	self.textDecoration = [style computeTextDecoration:UITextDecoration_None];

// text
	
	if ( self.text )
	{
		[self unserialize:[self.text copy]];
	}
	else if ( self.attributedText )
	{
		[self unserialize:[self.attributedText.string copy]];
	}
	else
	{
		[self zerolize];
	}
}

- (void)html_applyFrame:(CGRect)newFrame
{
	[super html_applyFrame:newFrame];
}

- (void)html_forView:(UIView *)hostView
{
	if ( [hostView isKindOfClass:[UISlider class]] )
	{
		UISlider * control = (UISlider *)hostView;
		
		[control addTarget:self action:@selector(UISlider_valueChanged:) forControlEvents:UIControlEventValueChanged];
	}
	else if ( [hostView isKindOfClass:[UISwitch class]] )
	{
		UISwitch * control = (UISwitch *)hostView;
		
		[control addTarget:self action:@selector(UISwitch_valueChanged:) forControlEvents:UIControlEventValueChanged];
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

#pragma mark -

- (void)UISlider_valueChanged:(UIView *)hostView;
{
	UISlider * control = (UISlider *)hostView;
	NSString * content = [NSString stringWithFormat:@"%f", control.value];
	
	[self unserialize:content];
}

- (void)UISwitch_valueChanged:(UIView *)hostView;
{
	UISwitch * control = (UISwitch *)hostView;
	NSNumber * content = control.on ? @(YES) : @(NO);

	[self unserialize:content];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, UILabel_Html )

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
