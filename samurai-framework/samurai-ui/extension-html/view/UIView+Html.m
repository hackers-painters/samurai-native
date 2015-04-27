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

#import "UIView+Html.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_HtmlStyle.h"
#import "Samurai_HtmlRenderObject.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation UIView(Html)

+ (HtmlRenderModel)html_defaultRenderModel
{
	return HtmlRenderModel_Element;
}

- (void)html_applyBorder:(SamuraiHtmlStyle *)style
{
// border:5px solid red

	SamuraiHtmlStyleObject * borderWidth = style.borderWidth ?: [style.border objectAtIndex:0];
//	SamuraiHtmlStyleObject * borderStyle = style.borderStyle ?: [style.border objectAtIndex:1];
	SamuraiHtmlStyleObject * borderColor = style.borderColor ?: [style.border objectAtIndex:2];
	SamuraiHtmlStyleObject * borderRadius = style.borderRadius;

	CGFloat		width = 0.0f;
	CGFloat		radius = 0.0f;
	UIColor *	color = nil;
	
	if ( borderWidth )
	{
		if ( [borderWidth isNumber] )
		{
			width = [borderWidth computeValue:fminf( self.frame.size.width, self.frame.size.height )];
		}
//		else if ( [borderWidth isFunction] )
//		{
//			TODO( "" )
//		}
//		else if ( [borderWidth isString] )
//		{
//			TODO( "" )
//		}
	}

	if ( borderRadius )
	{
		if ( [borderRadius isNumber] )
		{
			radius = [borderRadius computeValue:fminf(self.frame.size.width, self.frame.size.height)];
		}
//		else if ( [borderRadius isFunction] )
//		{
//			TODO( "" )
//		}
//		else if ( [borderRadius isString] )
//		{
//			TODO( "" )
//		}
	}

	if ( borderColor )
	{
		if ( [borderColor isColor] )
		{
			color = ((SamuraiHtmlColor *)borderColor).value;
		}
	}

	self.layer.borderColor = color ? [color CGColor] : [[UIColor clearColor] CGColor];
	self.layer.borderWidth = width;
	self.layer.cornerRadius = (radius > width) ? (radius - width) : 0.0f;
	
	if ( radius )
	{
		self.layer.masksToBounds = YES;
	}
//	else
//	{
//		self.layer.masksToBounds = NO;
//	}
}

- (void)html_applyBackground:(SamuraiHtmlStyle *)style
{
//	SamuraiHtmlStyleObject * background = style.background;
	SamuraiHtmlStyleObject * backgroundColor = style.backgroundColor;
//	SamuraiHtmlStyleObject * backgroundImage = style.backgroundImage;
	
	if ( backgroundColor )
	{
		if ( [backgroundColor isColor] )
		{
			self.backgroundColor = ((SamuraiHtmlColor *)backgroundColor).value;
		}
		else
		{
			self.backgroundColor = [UIColor clearColor];
		}
	}
	else
	{
		self.backgroundColor = [UIColor clearColor];
	}

	TODO( "background & background-image" );
}

- (void)html_applyShadow:(SamuraiHtmlStyle *)style
{
	SamuraiHtmlArray * shadow = style.boxShadow ?: style.textShadow;

// box-shadow: 5px 5px 5px #FF0000;
// text-shadow: 5px 5px 5px #FF0000;

	if ( shadow )
	{
		if ( 4 == [shadow.items count] )
		{
			SamuraiHtmlStyleObject * xOffset = [shadow objectAtIndex:0];
			SamuraiHtmlStyleObject * yOffset = [shadow objectAtIndex:1];
			SamuraiHtmlStyleObject * size = [shadow objectAtIndex:2];
			SamuraiHtmlStyleObject * color = [shadow objectAtIndex:3];

			UIColor *	shadowColor = nil;
			CGFloat		shadowRadius = 0.0f;
			CGSize		shadowOffset = CGSizeZero;

			if ( color && [color isColor] )
			{
				shadowColor = ((SamuraiHtmlColor *)color).value;
			}
			else
			{
				shadowColor = [UIColor blackColor];
			}

			if ( size )
			{
				if ( [size isNumber] )
				{
					shadowRadius = [size computeValue:fminf(self.frame.size.width, self.frame.size.height)];
				}
//				else if ( [xOffset isFunction] )
//				{
//					TODO( "" )
//				}
//				else if ( [xOffset isString] )
//				{
//					TODO( "" )
//				}
			}
			
			if ( xOffset )
			{
				if ( [xOffset isNumber] )
				{
					shadowOffset.width = [xOffset computeValue:self.frame.size.width];
				}
//				else if ( [xOffset isFunction] )
//				{
//					TODO( "" )
//				}
//				else if ( [xOffset isString] )
//				{
//					TODO( "" )
//				}
			}

			if ( yOffset )
			{
				if ( [xOffset isNumber] )
				{
					shadowOffset.height = [yOffset computeValue:self.frame.size.height];
				}
//				else if ( [xOffset isFunction] )
//				{
//					TODO( "" )
//				}
//				else if ( [xOffset isString] )
//				{
//					TODO( "" )
//				}
			}

			shadowOffset.width = (INVALID_VALUE == shadowOffset.width) ? 0.0f : shadowOffset.width;
			shadowOffset.height = (INVALID_VALUE == shadowOffset.height) ? 0.0f : shadowOffset.height;
			
			shadowRadius = (INVALID_VALUE == shadowRadius) ? 0.0f : shadowRadius;
			
			self.layer.shadowOffset = shadowOffset;
			self.layer.shadowRadius = shadowRadius;
			self.layer.shadowOpacity = 0.5f;
			self.layer.masksToBounds = YES;
		}
	}
}

- (void)html_applyOpacity:(SamuraiHtmlStyle *)style
{
	if ( style.opacity && [style.opacity isNumber] )
	{
		self.layer.opacity = [style.opacity computeValue:1.0f];
	}
	else
	{
		self.layer.opacity = 1.0f;
	}
}

- (void)html_applyDisplay:(SamuraiHtmlStyle *)style
{
	if ( [style.display isString:@"none"] )
	{
		self.hidden = YES;
	}
	else
	{
		self.hidden = NO;
	}

	if ( [style.visibility isString:@"hidden"] )
	{
		self.layer.hidden = YES;
	}
	else if ( [style.visibility isString:@"visible"] )
	{
		self.layer.hidden = NO;
	}
	else if ( [style.visibility isString:@"collapse"] )
	{
		self.layer.hidden = YES;
	}
	else
	{
		self.layer.hidden = NO;
	}

//	if ( [style.overflow isString:@"hidden"] )
//	{
//		self.layer.masksToBounds = YES;
//	}
//	else
//	{
//		self.layer.masksToBounds = NO;
//	}
}

- (void)html_applyContentMode:(SamuraiHtmlStyle *)style
{
	self.contentMode = [style computeContentMode:self.contentMode];
}

- (void)html_applyStyle:(SamuraiHtmlStyle *)style
{
	[super html_applyStyle:style];

	[self html_applyBorder:style];
	[self html_applyDisplay:style];
	[self html_applyShadow:style];
	[self html_applyOpacity:style];
	[self html_applyBackground:style];
	[self html_applyContentMode:style];
}

#pragma mark -

- (NSString *)parseSignal:(NSString *)property
{
	NSString * prefix = @"signal(";
	NSString * suffix = @")";
	
	if ( [property hasPrefix:prefix] && [property hasSuffix:suffix] )
	{
		NSRange		range = NSMakeRange( prefix.length, property.length - prefix.length - suffix.length );
		NSString *	signal = [property substringWithRange:range];

		return [[[signal trim] unwrap] trim];
	}

	return nil;
}

- (void)html_applyDom:(SamuraiHtmlDomNode *)dom
{
	[super html_applyDom:dom];
	
	NSString * onClick		= [dom.domAttributes objectForKey:@"onclick"];
	NSString * onSwipe		= [dom.domAttributes objectForKey:@"onswipe"];
	NSString * onSwipeLeft	= [dom.domAttributes objectForKey:@"onswipe-left"];
	NSString * onSwipeRight	= [dom.domAttributes objectForKey:@"onswipe-right"];
	NSString * onSwipeUp	= [dom.domAttributes objectForKey:@"onswipe-up"];
	NSString * onSwipeDown	= [dom.domAttributes objectForKey:@"onswipe-down"];
	NSString * onPinch		= [dom.domAttributes objectForKey:@"onpinch"];
	NSString * onPan		= [dom.domAttributes objectForKey:@"onpan"];

	if ( onClick )
	{
		NSString * signal = [self parseSignal:onClick];
		
		[self enableTapGestureWithSignal:signal];
	}

	if ( onSwipe )
	{
		NSString * signal = [self parseSignal:onSwipe];

		[self enableSwipeGesture:UISwipeGestureRecognizerDirectionUp withSignal:signal];
		[self enableSwipeGesture:UISwipeGestureRecognizerDirectionDown withSignal:signal];
		[self enableSwipeGesture:UISwipeGestureRecognizerDirectionLeft withSignal:signal];
		[self enableSwipeGesture:UISwipeGestureRecognizerDirectionRight withSignal:signal];
	}

	if ( onSwipeLeft )
	{
		NSString * signal = [self parseSignal:onSwipeLeft];
		
		[self enableSwipeGesture:UISwipeGestureRecognizerDirectionLeft withSignal:signal];
	}

	if ( onSwipeRight )
	{
		NSString * signal = [self parseSignal:onSwipeRight];
		
		[self enableSwipeGesture:UISwipeGestureRecognizerDirectionRight withSignal:signal];
	}

	if ( onSwipeUp )
	{
		NSString * signal = [self parseSignal:onSwipeUp];
		
		[self enableSwipeGesture:UISwipeGestureRecognizerDirectionUp withSignal:signal];
	}

	if ( onSwipeDown )
	{
		NSString * signal = [self parseSignal:onSwipeDown];
		
		[self enableSwipeGesture:UISwipeGestureRecognizerDirectionDown withSignal:signal];
	}

	if ( onPinch )
	{
		NSString * signal = [self parseSignal:onPinch];
		
		[self enablePinchGestureWithSignal:signal];
	}

	if ( onPan )
	{
		NSString * signal = [self parseSignal:onPan];
		
		[self enablePanGestureWithSignal:signal];
	}
}

- (void)html_applyFrame:(CGRect)newFrame
{
	[super html_applyFrame:newFrame];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, UIView_Html )

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
