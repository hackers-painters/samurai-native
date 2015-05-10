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

@implementation UIBorderView

@def_prop_assign( CGFloat,	lineWidth );

@end

#pragma mark -

@implementation UIView(Html)

@def_prop_dynamic_strong( UIBorderView *,	topBorder, setTopBorder );
@def_prop_dynamic_strong( UIBorderView *,	leftBorder, setLeftBorder );
@def_prop_dynamic_strong( UIBorderView *,	rightBorder, setRightBorder );
@def_prop_dynamic_strong( UIBorderView *,	bottomBorder, setBottomBorder );

+ (HtmlRenderModel)html_defaultRenderModel
{
	return HtmlRenderModel_Element;
}

- (void)html_applyBorder:(SamuraiHtmlStyle *)style
{
	CGFloat thinSize = 1.0f;
	CGFloat mediumSize = 3.0f;
	CGFloat thickSize = 5.0f;
	
// border:5px solid red

	{
		SamuraiHtmlArray *			border = style.border;
		SamuraiHtmlStyleObject *	borderWidth = style.borderWidth;
		SamuraiHtmlStyleObject *	borderColor = style.borderColor;
		SamuraiHtmlStyleObject *	borderStyle = style.borderStyle;
		SamuraiHtmlStyleObject *	borderRadius = style.borderRadius;
		
		for ( SamuraiHtmlStyleObject * borderItem in border.items )
		{
			if ( [borderItem isNumber] )
			{
				borderWidth = borderWidth ?: borderItem;
			}
			else if ( [borderItem isColor] )
			{
				borderColor = borderColor ?: borderItem;
			}
			else if ( [borderItem inStrings:@[@"none", @"hidden", @"dotted",
											  @"dashed", @"solid", @"double",
											  @"groove", @"ridge", @"inset",
											  @"outset", @"inherit"]] )
			{
				borderStyle = borderStyle ?: borderItem;
			}
		}
		
		BOOL		aroundHidden = NO;
		CGFloat		aroundWidth = 0.0f;
		CGFloat		aroundRadius = 0.0f;
		UIColor *	aroundColor = [UIColor clearColor];
		
		if ( borderStyle )
		{
			if ( [borderStyle inStrings:@[ @"none", @"hidden" ]] )
			{
				aroundHidden = YES;
			}
		}
		
		if ( borderWidth )
		{
			if ( [borderWidth isNumber] )
			{
				aroundWidth = [borderWidth computeValue:fminf( self.frame.size.width, self.frame.size.height )];
			}
			else if ( [borderWidth isString:@"thin"] )
			{
				aroundWidth = thinSize;
			}
			else if ( [borderWidth isString:@"medium"] )
			{
				aroundWidth = mediumSize;
			}
			else if ( [borderWidth isString:@"thick"] )
			{
				aroundWidth = thickSize;
			}
		}
		
		if ( [borderRadius isNumber] )
		{
			aroundRadius = [borderRadius computeValue:fminf(self.frame.size.width, self.frame.size.height)];
		}
		
		if ( [borderColor isColor] )
		{
			aroundColor = ((SamuraiHtmlColor *)borderColor).value;
		}
		
		if ( aroundWidth <= 0.0f )
		{
			if ( borderStyle || borderColor )
			{
				aroundWidth = mediumSize;
			}
		}
		
		if ( NO == aroundHidden && aroundWidth > 0.0f )
		{
			self.layer.borderColor = [aroundColor CGColor];
			self.layer.borderWidth = aroundWidth;
		}
		else
		{
			self.layer.borderColor = [[UIColor clearColor] CGColor];
			self.layer.borderWidth = 0.0f;
		}
		
		if ( aroundRadius > 0.0f )
		{
			self.layer.cornerRadius = (aroundRadius > aroundWidth) ? (aroundRadius - aroundWidth) : 0.0f;
			self.layer.masksToBounds = YES;
		}
		else
		{
			self.layer.cornerRadius = 0.0f;
		}
	}

// border-radius
	
	{
	//	SamuraiHtmlStyleObject * borderTopLeftRadius = style.borderTopLeftRadius ?: borderRadius;
	//	SamuraiHtmlStyleObject * borderTopRightRadius = style.borderTopRightRadius ?: borderRadius;
	//	SamuraiHtmlStyleObject * borderBottomLeftRadius = style.borderBottomLeftRadius ?: borderRadius;
	//	SamuraiHtmlStyleObject * borderBottomRightRadius = style.borderBottomRightRadius ?: borderRadius;
	}

// border-top

	{
		SamuraiHtmlArray *			borderTop = style.borderTop;
		SamuraiHtmlStyleObject *	borderTopWidth = style.borderTopWidth;
		SamuraiHtmlStyleObject *	borderTopColor = style.borderTopColor;
		SamuraiHtmlStyleObject *	borderTopStyle = style.borderTopStyle;
		
		for ( SamuraiHtmlStyleObject * borderItem in borderTop.items )
		{
			if ( [borderItem isNumber] )
			{
				borderTopWidth = borderTopWidth ?: borderItem;
			}
			else if ( [borderItem isColor] )
			{
				borderTopColor = borderTopColor ?: borderItem;
			}
			else if ( [borderItem inStrings:@[@"none", @"hidden", @"dotted",
											  @"dashed", @"solid", @"double",
											  @"groove", @"ridge", @"inset",
											  @"outset", @"inherit"]] )
			{
				borderTopStyle = borderTopStyle ?: borderItem;
			}
		}
		
		BOOL		topHidden = NO;
		CGFloat		topWidth = 0.0f;
		UIColor *	topColor = [UIColor clearColor];
		
		if ( borderTopStyle )
		{
			if ( [borderTopStyle inStrings:@[ @"none", @"hidden" ]] )
			{
				topHidden = YES;
			}
		}
		
		if ( borderTopWidth )
		{
			if ( [borderTopWidth isNumber] )
			{
				topWidth = [borderTopWidth computeValue:self.frame.size.width];
			}
			else if ( [borderTopWidth isString:@"thin"] )
			{
				topWidth = thinSize;
			}
			else if ( [borderTopWidth isString:@"medium"] )
			{
				topWidth = mediumSize;
			}
			else if ( [borderTopWidth isString:@"thick"] )
			{
				topWidth = thickSize;
			}
		}
		
		if ( [borderTopColor isColor] )
		{
			topColor = ((SamuraiHtmlColor *)borderTopColor).value;
		}

		if ( topWidth <= 0.0f )
		{
			if ( borderTopStyle || borderTopColor )
			{
				topWidth = mediumSize;
			}
		}
		
		if ( NO == topHidden && topWidth > 0.0f )
		{
			if ( nil == self.topBorder )
			{
				self.topBorder = [[UIBorderView alloc] initWithFrame:CGRectZero];
				self.topBorder.layer.masksToBounds = YES;
				
				[self addSubview:self.topBorder];
			}

			self.topBorder.backgroundColor = topColor;
			self.topBorder.lineWidth = topWidth;
			self.topBorder.hidden = NO;
		}
		else
		{
			if ( self.topBorder )
			{
				self.topBorder.hidden = YES;
			}
		}
	}

// border-left
	
	{
		SamuraiHtmlArray *			borderLeft = style.borderLeft;
		SamuraiHtmlStyleObject *	borderLeftWidth = style.borderLeftWidth;
		SamuraiHtmlStyleObject *	borderLeftColor = style.borderLeftColor;
		SamuraiHtmlStyleObject *	borderLeftStyle = style.borderLeftStyle;
		
		for ( SamuraiHtmlStyleObject * borderItem in borderLeft.items )
		{
			if ( [borderItem isNumber] )
			{
				borderLeftWidth = borderLeftWidth ?: borderItem;
			}
			else if ( [borderItem isColor] )
			{
				borderLeftColor = borderLeftColor ?: borderItem;
			}
			else if ( [borderItem inStrings:@[@"none", @"hidden", @"dotted",
											  @"dashed", @"solid", @"double",
											  @"groove", @"ridge", @"inset",
											  @"outset", @"inherit"]] )
			{
				borderLeftStyle = borderLeftStyle ?: borderItem;
			}
		}
		
		BOOL		leftHidden = NO;
		CGFloat		leftWidth = 0.0f;
		UIColor *	leftColor = [UIColor clearColor];
		
		if ( borderLeftStyle )
		{
			if ( [borderLeftStyle inStrings:@[ @"none", @"hidden" ]] )
			{
				leftHidden = YES;
			}
		}
		
		if ( borderLeftWidth )
		{
			if ( [borderLeftWidth isNumber] )
			{
				leftWidth = [borderLeftWidth computeValue:self.frame.size.width];
			}
			else if ( [borderLeftWidth isString:@"thin"] )
			{
				leftWidth = thinSize;
			}
			else if ( [borderLeftWidth isString:@"medium"] )
			{
				leftWidth = mediumSize;
			}
			else if ( [borderLeftWidth isString:@"thick"] )
			{
				leftWidth = thickSize;
			}
		}
		
		if ( [borderLeftColor isColor] )
		{
			leftColor = ((SamuraiHtmlColor *)borderLeftColor).value;
		}
		
		if ( leftWidth <= 0.0f )
		{
			if ( borderLeftStyle || borderLeftColor )
			{
				leftWidth = mediumSize;
			}
		}
		
		if ( NO == leftHidden && leftWidth > 0.0f )
		{
			if ( nil == self.leftBorder )
			{
				self.leftBorder = [[UIBorderView alloc] initWithFrame:CGRectZero];
				self.leftBorder.layer.masksToBounds = YES;
				
				[self addSubview:self.leftBorder];
			}
			
			self.leftBorder.backgroundColor = leftColor;
			self.leftBorder.lineWidth = leftWidth;
			self.leftBorder.hidden = NO;
		}
		else
		{
			if ( self.leftBorder )
			{
				self.leftBorder.hidden = YES;
			}
		}
	}
	
// border-right
	
	{
		SamuraiHtmlArray *			borderRight = style.borderRight;
		SamuraiHtmlStyleObject *	borderRightWidth = style.borderRightWidth;
		SamuraiHtmlStyleObject *	borderRightColor = style.borderRightColor;
		SamuraiHtmlStyleObject *	borderRightStyle = style.borderRightStyle;
		
		for ( SamuraiHtmlStyleObject * borderItem in borderRight.items )
		{
			if ( [borderItem isNumber] )
			{
				borderRightWidth = borderRightWidth ?: borderItem;
			}
			else if ( [borderItem isColor] )
			{
				borderRightColor = borderRightColor ?: borderItem;
			}
			else if ( [borderItem inStrings:@[@"none", @"hidden", @"dotted",
											  @"dashed", @"solid", @"double",
											  @"groove", @"ridge", @"inset",
											  @"outset", @"inherit"]] )
			{
				borderRightStyle = borderRightStyle ?: borderItem;
			}
		}
		
		BOOL		rightHidden = NO;
		CGFloat		rightWidth = 0.0f;
		UIColor *	rightColor = [UIColor clearColor];
		
		if ( borderRightStyle )
		{
			if ( [borderRightStyle inStrings:@[ @"none", @"hidden" ]] )
			{
				rightHidden = YES;
			}
		}
		
		if ( borderRightWidth )
		{
			if ( [borderRightWidth isNumber] )
			{
				rightWidth = [borderRightWidth computeValue:self.frame.size.width];
			}
			else if ( [borderRightWidth isString:@"thin"] )
			{
				rightWidth = thinSize;
			}
			else if ( [borderRightWidth isString:@"medium"] )
			{
				rightWidth = mediumSize;
			}
			else if ( [borderRightWidth isString:@"thick"] )
			{
				rightWidth = thickSize;
			}
		}
		
		if ( [borderRightColor isColor] )
		{
			rightColor = ((SamuraiHtmlColor *)borderRightColor).value;
		}
		
		if ( rightWidth <= 0.0f )
		{
			if ( borderRightStyle || borderRightColor )
			{
				rightWidth = mediumSize;
			}
		}
		
		if ( NO == rightHidden && rightWidth > 0.0f )
		{
			if ( nil == self.rightBorder )
			{
				self.rightBorder = [[UIBorderView alloc] initWithFrame:CGRectZero];
				self.rightBorder.layer.masksToBounds = YES;
				
				[self addSubview:self.rightBorder];
			}
			
			self.rightBorder.backgroundColor = rightColor;
			self.rightBorder.lineWidth = rightWidth;
			self.rightBorder.hidden = NO;
		}
		else
		{
			if ( self.rightBorder )
			{
				self.rightBorder.hidden = YES;
			}
		}
	}

// border-bottom

	{
		SamuraiHtmlArray *			borderBottom = style.borderBottom;
		SamuraiHtmlStyleObject *	borderBottomWidth = style.borderBottomWidth;
		SamuraiHtmlStyleObject *	borderBottomColor = style.borderBottomColor;
		SamuraiHtmlStyleObject *	borderBottomStyle = style.borderBottomStyle;
		
		for ( SamuraiHtmlStyleObject * borderItem in borderBottom.items )
		{
			if ( [borderItem isNumber] )
			{
				borderBottomWidth = borderBottomWidth ?: borderItem;
			}
			else if ( [borderItem isColor] )
			{
				borderBottomColor = borderBottomColor ?: borderItem;
			}
			else if ( [borderItem inStrings:@[@"none", @"hidden", @"dotted",
											  @"dashed", @"solid", @"double",
											  @"groove", @"ridge", @"inset",
											  @"outset", @"inherit"]] )
			{
				borderBottomStyle = borderBottomStyle ?: borderItem;
			}
		}
		
		BOOL		bottomHidden = NO;
		CGFloat		bottomWidth = 0.0f;
		UIColor *	bottomColor = [UIColor clearColor];
		
		if ( borderBottomStyle )
		{
			if ( [borderBottomStyle inStrings:@[ @"none", @"hidden" ]] )
			{
				bottomHidden = YES;
			}
		}
		
		if ( borderBottomWidth )
		{
			if ( [borderBottomWidth isNumber] )
			{
				bottomWidth = [borderBottomWidth computeValue:self.frame.size.width];
			}
			else if ( [borderBottomWidth isString:@"thin"] )
			{
				bottomWidth = thinSize;
			}
			else if ( [borderBottomWidth isString:@"medium"] )
			{
				bottomWidth = mediumSize;
			}
			else if ( [borderBottomWidth isString:@"thick"] )
			{
				bottomWidth = thickSize;
			}
		}
		
		if ( [borderBottomColor isColor] )
		{
			bottomColor = ((SamuraiHtmlColor *)borderBottomColor).value;
		}
		
		if ( bottomWidth <= 0.0f )
		{
			if ( borderBottomStyle || borderBottomColor )
			{
				bottomWidth = mediumSize;
			}
		}
		
		if ( NO == bottomHidden && bottomWidth > 0.0f )
		{
			if ( nil == self.bottomBorder )
			{
				self.bottomBorder = [[UIBorderView alloc] initWithFrame:CGRectZero];
				self.bottomBorder.layer.masksToBounds = YES;
				
				[self addSubview:self.bottomBorder];
			}
			
			self.bottomBorder.backgroundColor = bottomColor;
			self.bottomBorder.lineWidth = bottomWidth;
			self.bottomBorder.hidden = NO;
		}
		else
		{
			if ( self.bottomBorder )
			{
				self.bottomBorder.hidden = YES;
			}
		}
	}
}

- (void)html_applyBackground:(SamuraiHtmlStyle *)style
{
//	#00FF00 url(bgimage.gif) no-repeat fixed top
	
	SamuraiHtmlArray *			background = style.background;
	SamuraiHtmlStyleObject *	backgroundColor = style.backgroundColor;
	SamuraiHtmlStyleObject *	backgroundImage = style.backgroundImage;
	
	for ( SamuraiHtmlStyleObject * backgroundItem in background.items )
	{
		if ( [backgroundItem isColor] )
		{
			backgroundColor = backgroundColor ?: backgroundItem;
		}
		else if ( [backgroundItem isUrl] )
		{
			backgroundImage = backgroundImage ?: backgroundItem;
		}
	}

	if ( backgroundImage )
	{
		TODO( "background-image" );
	}
	else if ( backgroundColor )
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

	UIBorderView * topBorder = self.topBorder;
	UIBorderView * leftBorder = self.leftBorder;
	UIBorderView * rightBorder = self.rightBorder;
	UIBorderView * bottomBorder = self.bottomBorder;
	
	if ( topBorder )
	{
		CGRect topFrame;
		
		topFrame.origin.x = 0.0f;
		topFrame.origin.y = -1.0f * topBorder.lineWidth;
		topFrame.size.width = newFrame.size.width;
		topFrame.size.height = topBorder.lineWidth;
		
		topBorder.frame = topFrame;
		
		[topBorder.superview bringSubviewToFront:topBorder];
		[topBorder setNeedsDisplay];
	}

	if ( bottomBorder )
	{
		CGRect bottomFrame;
		
		bottomFrame.origin.x = 0.0f;
		bottomFrame.origin.y = newFrame.size.height;
		bottomFrame.size.width = newFrame.size.width;
		bottomFrame.size.height = bottomBorder.lineWidth;
		
		bottomBorder.frame = bottomFrame;
		
		[bottomBorder.superview bringSubviewToFront:bottomBorder];
		[bottomBorder setNeedsDisplay];
	}

	if ( leftBorder )
	{
		CGRect leftFrame;
		
		leftFrame.origin.x = -1.0f * leftBorder.lineWidth;
		leftFrame.origin.y = 0.0f;
		leftFrame.size.width = leftBorder.lineWidth;
		leftFrame.size.height = newFrame.size.height;
		
		leftBorder.frame = leftFrame;
		
		[leftBorder.superview bringSubviewToFront:leftBorder];
		[leftBorder setNeedsDisplay];
	}

	if ( rightBorder )
	{
		CGRect rightFrame;
		
		rightFrame.origin.x = newFrame.size.width;
		rightFrame.origin.y = 0.0f;
		rightFrame.size.width = rightBorder.lineWidth;
		rightFrame.size.height = newFrame.size.height;
		
		rightBorder.frame = rightFrame;
		
		[rightBorder.superview bringSubviewToFront:rightBorder];
		[rightBorder setNeedsDisplay];
	}
}

- (void)html_forView:(UIView *)hostView
{
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
