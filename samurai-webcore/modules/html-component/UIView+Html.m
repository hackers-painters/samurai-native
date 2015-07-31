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

#import "Samurai_HtmlLayoutObject.h"
#import "Samurai_HtmlRenderStyle.h"
#import "Samurai_HtmlRenderObject.h"
#import "Samurai_HtmlRenderStoreScope.h"
#import "Samurai_HtmlUserAgent.h"

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

+ (CSSViewHierarchy)style_viewHierarchy
{
	return CSSViewHierarchy_Tree;
}

#pragma mark -

- (void)html_applyBorder:(SamuraiHtmlRenderStyle *)style
{
	CGFloat	borderTopSize = [style computeBorderTopSize:self.frame.size.width defaultSize:0.0f];
	CGFloat	borderLeftSize = [style computeBorderLeftSize:self.frame.size.width defaultSize:0.0f];
	CGFloat	borderRightSize = [style computeBorderRightSize:self.frame.size.width defaultSize:0.0f];
	CGFloat	borderBottomSize = [style computeBorderBottomSize:self.frame.size.width defaultSize:0.0f];

	CSSBorderStyle borderTopStyle = [style computeBorderTopStyle:CSSBorderStyle_None];
	CSSBorderStyle borderLeftStyle = [style computeBorderLeftStyle:CSSBorderStyle_None];
	CSSBorderStyle borderRightStyle = [style computeBorderRightStyle:CSSBorderStyle_None];
	CSSBorderStyle borderBottomStyle = [style computeBorderBottomStyle:CSSBorderStyle_None];

	UIColor * borderTopColor = [style computeBorderTopColor:[UIColor blackColor]];
	UIColor * borderLeftColor = [style computeBorderLeftColor:[UIColor blackColor]];
	UIColor * borderRightColor = [style computeBorderRightColor:[UIColor blackColor]];
	UIColor * borderBottomColor = [style computeBorderBottomColor:[UIColor blackColor]];

	CGFloat borderTopLeftRadius = [style computeBorderTopLeftRadius:self.frame.size.width defaultRadius:0.0f];
	CGFloat borderTopRightRadius = [style computeBorderTopRightRadius:self.frame.size.width defaultRadius:0.0f];
	CGFloat borderBottomLeftRadius = [style computeBorderBottomLeftRadius:self.frame.size.width defaultRadius:0.0f];
	CGFloat borderBottomRightRadius = [style computeBorderBottomRightRadius:self.frame.size.width defaultRadius:0.0f];
	
	borderTopSize = NORMALIZE_VALUE( borderTopSize );
	borderLeftSize = NORMALIZE_VALUE( borderLeftSize );
	borderRightSize = NORMALIZE_VALUE( borderRightSize );
	borderBottomSize = NORMALIZE_VALUE( borderBottomSize );

	borderTopLeftRadius = NORMALIZE_VALUE( borderTopLeftRadius );
	borderTopRightRadius = NORMALIZE_VALUE( borderTopRightRadius );
	borderBottomLeftRadius = NORMALIZE_VALUE( borderBottomLeftRadius );
	borderBottomRightRadius = NORMALIZE_VALUE( borderBottomRightRadius );
	
	if ( borderTopSize <= 0.0f )
	{
		if ( CSSBorderStyle_None != borderTopStyle && CSSBorderStyle_Inherit != borderTopStyle )
		{
			borderTopSize = [SamuraiHtmlUserAgent sharedInstance].mediumSize;
		}
	}

	if ( borderLeftSize <= 0.0f )
	{
		if ( CSSBorderStyle_None != borderLeftStyle && CSSBorderStyle_Inherit != borderLeftStyle )
		{
			borderLeftSize = [SamuraiHtmlUserAgent sharedInstance].mediumSize;
		}
	}

	if ( borderRightSize <= 0.0f )
	{
		if ( CSSBorderStyle_None != borderRightStyle && CSSBorderStyle_Inherit != borderRightStyle )
		{
			borderRightSize = [SamuraiHtmlUserAgent sharedInstance].mediumSize;
		}
	}

	if ( borderBottomSize <= 0.0f )
	{
		if ( CSSBorderStyle_None != borderBottomStyle && CSSBorderStyle_Inherit != borderBottomStyle )
		{
			borderBottomSize = [SamuraiHtmlUserAgent sharedInstance].mediumSize;
		}
	}

	BOOL separatedBorder = NO;
	
	if ( borderTopSize != borderLeftSize || borderTopSize != borderRightSize || borderTopSize != borderBottomSize )
	{
		separatedBorder = YES;
	}
	else if ( borderTopLeftRadius != borderTopRightRadius || borderTopLeftRadius != borderBottomLeftRadius || borderTopLeftRadius != borderBottomRightRadius )
	{
		separatedBorder = YES;
	}
	else if ( NO == [borderTopColor isEqual:borderLeftColor] || NO == [borderTopColor isEqual:borderRightColor] || NO == [borderTopColor isEqual:borderBottomColor] )
	{
		separatedBorder = YES;
	}
	
	if ( NO == separatedBorder )
	{
		CSSBorderStyle	borderStyle = borderTopStyle;

		if ( CSSBorderStyle_None == borderStyle || CSSBorderStyle_Hidden == borderStyle )
		{
			self.layer.borderWidth = 0.0f;
			self.layer.borderColor = [[UIColor clearColor] CGColor];
			self.layer.cornerRadius = 0.0f;
			self.layer.masksToBounds = NO;
		}
		else
		{
			CGFloat		borderSize = NORMALIZE_VALUE( borderTopSize );
			CGFloat		borderRadius = NORMALIZE_VALUE( borderTopLeftRadius ) + NORMALIZE_VALUE( borderTopSize );
			UIColor *	borderColor = borderTopColor;
			CGFloat		maskRadius = 0.0f;
			
			if ( borderRadius > borderSize )
			{
				maskRadius = borderRadius - borderSize;
			//	maskRadius -= self.htmlRenderer.layout.computedBorder.left;
			//	maskRadius -= self.htmlRenderer.layout.computedBorder.right;
			}

			if ( maskRadius )
			{
				self.layer.cornerRadius = maskRadius;
				self.layer.masksToBounds = YES;
			}
			else
			{
				self.layer.cornerRadius = 0.0f;
				self.layer.masksToBounds = NO;
			}
			
			self.layer.borderWidth = borderSize;
			self.layer.borderColor = [borderColor CGColor];
		}
		
		self.topBorder.hidden = YES;
		self.leftBorder.hidden = YES;
		self.rightBorder.hidden = YES;
		self.bottomBorder.hidden = YES;
	}
	else
	{
		self.layer.cornerRadius = 0.0f;
		self.layer.masksToBounds = NO;

	// border-top
		{
			BOOL borderHidden = NO;
			
			if ( CSSBorderStyle_None == borderTopStyle || CSSBorderStyle_Hidden == borderTopStyle )
			{
				borderHidden = YES;
			}
			
			if ( borderHidden || INVALID_VALUE == borderTopSize )
			{
				self.topBorder.hidden = YES;
			}
			else if ( borderTopSize > 0.0f )
			{
				if ( nil == self.topBorder )
				{
					self.topBorder = [[UIBorderView alloc] initWithFrame:CGRectZero];
					self.topBorder.layer.masksToBounds = YES;
					
					[self addSubview:self.topBorder];
				}
				
				self.topBorder.backgroundColor = borderTopColor ?: [UIColor blackColor];
				self.topBorder.lineWidth = borderTopSize;
				self.topBorder.hidden = NO;
				
				[self html_applyTopBorderFrame];
			}
			else
			{
				self.leftBorder.hidden = YES;
			}
		}

	// border-left
		{
			BOOL borderHidden = NO;
			
			if ( CSSBorderStyle_None == borderLeftStyle || CSSBorderStyle_Hidden == borderLeftStyle )
			{
				borderHidden = YES;
			}
			
			if ( borderHidden || INVALID_VALUE == borderLeftSize )
			{
				self.leftBorder.hidden = YES;
			}
			else if ( borderLeftSize > 0.0f )
			{
				if ( nil == self.leftBorder )
				{
					self.leftBorder = [[UIBorderView alloc] initWithFrame:CGRectZero];
					self.leftBorder.layer.masksToBounds = YES;
					
					[self addSubview:self.leftBorder];
				}
				
				self.leftBorder.backgroundColor = borderLeftColor ?: [UIColor blackColor];
				self.leftBorder.lineWidth = borderLeftSize;
				self.leftBorder.hidden = NO;
				
				[self html_applyLeftBorderFrame];
			}
			else
			{
				self.leftBorder.hidden = YES;
			}
		}
		
	// border-right
		{
			BOOL borderHidden = NO;
			
			if ( CSSBorderStyle_None == borderRightStyle || CSSBorderStyle_Hidden == borderRightStyle )
			{
				borderHidden = YES;
			}
			
			if ( borderHidden || INVALID_VALUE == borderRightSize )
			{
				self.rightBorder.hidden = YES;
			}
			else if ( borderRightSize > 0.0f )
			{
				if ( nil == self.rightBorder )
				{
					self.rightBorder = [[UIBorderView alloc] initWithFrame:CGRectZero];
					self.rightBorder.layer.masksToBounds = YES;
					
					[self addSubview:self.rightBorder];
				}
				
				self.rightBorder.backgroundColor = borderRightColor ?: [UIColor blackColor];
				self.rightBorder.lineWidth = borderRightSize;
				self.rightBorder.hidden = NO;
				
				[self html_applyRightBorderFrame];
			}
			else
			{
				self.rightBorder.hidden = YES;
			}
		}
		
	// border-bottom
		{
			BOOL borderHidden = NO;
			
			if ( CSSBorderStyle_None == borderBottomStyle || CSSBorderStyle_Hidden == borderBottomStyle )
			{
				borderHidden = YES;
			}
			
			if ( borderHidden || INVALID_VALUE == borderBottomSize )
			{
				self.bottomBorder.hidden = YES;
			}
			else if ( borderBottomSize > 0.0f )
			{
				if ( nil == self.bottomBorder )
				{
					self.bottomBorder = [[UIBorderView alloc] initWithFrame:CGRectZero];
					self.bottomBorder.layer.masksToBounds = YES;
					
					[self addSubview:self.bottomBorder];
				}
				
				self.bottomBorder.backgroundColor = borderBottomColor ?: [UIColor blackColor];
				self.bottomBorder.lineWidth = borderBottomSize;
				self.bottomBorder.hidden = NO;
				
				[self html_applyBottomBorderFrame];
			}
			else
			{
				self.bottomBorder.hidden = YES;
			}
		}
	}
}

- (void)html_applyBackground:(SamuraiHtmlRenderStyle *)style
{
//	#00FF00 url(bgimage.gif) no-repeat fixed top
	
	SamuraiCSSArray *	background = style.background;
	SamuraiCSSValue *	backgroundColor = style.backgroundColor;
	SamuraiCSSValue *	backgroundImage = style.backgroundImage;
	
	for ( SamuraiCSSValue * backgroundItem in background.array )
	{
		if ( [backgroundItem isColor] )
		{
			backgroundColor = backgroundColor ?: backgroundItem;
		}
		else if ( [backgroundItem isUri] )
		{
			backgroundImage = backgroundImage ?: backgroundItem;
		}
	}

	if ( backgroundColor )
	{
		if ( [backgroundColor isColor] )
		{
			self.backgroundColor = [backgroundColor color];
		}
		else
		{
			self.backgroundColor = [UIColor clearColor];
		}
	}

	if ( backgroundImage )
	{
		TODO( "background-image" );
		
	//	self.backgroundColor = [UIColor clearColor];
	}
}

- (void)html_applyShadow:(SamuraiHtmlRenderStyle *)style
{
	SamuraiCSSArray * shadow = style.boxShadow ?: style.textShadow;

// box-shadow: 5px 5px 5px #FF0000;
// text-shadow: 5px 5px 5px #FF0000;

	if ( shadow )
	{
		if ( 4 == [shadow.array count] )
		{
			SamuraiCSSValue * xOffset = [shadow objectAtIndex:0];
			SamuraiCSSValue * yOffset = [shadow objectAtIndex:1];
			SamuraiCSSValue * size = [shadow objectAtIndex:2];
			SamuraiCSSValue * color = [shadow objectAtIndex:3];

			UIColor *	shadowColor = nil;
			CGFloat		shadowRadius = 0.0f;
			CGSize		shadowOffset = CGSizeZero;

			if ( color && [color isColor] )
			{
				shadowColor = [color color];
			}
			else
			{
				shadowColor = [UIColor darkGrayColor];
			}

			if ( size )
			{
				if ( [size isNumber] )
				{
					shadowRadius = [size computeValue:self.frame.size.width];
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

- (void)html_applyOpacity:(SamuraiHtmlRenderStyle *)style
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

- (void)html_applyDisplay:(SamuraiHtmlRenderStyle *)style
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

- (void)html_applyContentMode:(SamuraiHtmlRenderStyle *)style
{
	self.contentMode = [style computeContentMode:self.contentMode];
}

- (void)html_applyStyle:(SamuraiHtmlRenderStyle *)style
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

- (NSString *)html_parseEvent:(NSString *)property
{
	if ( nil == property )
		return nil;
	
	NSString * eventName = nil;
	
	eventName = eventName ?: [self html_parseSignal:property];
	eventName = eventName ?: [self html_parseSelector:property];
	eventName = eventName ?: [self html_parseFunction:property];
	
	return eventName;
}

- (NSString *)html_parseSignal:(NSString *)property
{
	property = [property trim];
	
	if ( property && property.length )
	{
		NSString * prefix = @"signal(";
		NSString * suffix = @")";
		
		if ( [property hasPrefix:prefix] && [property hasSuffix:suffix] )
		{
			NSRange		range = NSMakeRange( prefix.length, property.length - prefix.length - suffix.length );
			NSString *	signal = [[property substringWithRange:range] trim];

			return [NSString stringWithFormat:@"signal.%@", signal];
		}
	}
	
	return nil;
}

- (NSString *)html_parseSelector:(NSString *)property
{
	property = [property trim];
	
	if ( property && property.length )
	{
		NSString * prefix = @"@selector(";
		NSString * suffix = @")";
		
		if ( [property hasPrefix:prefix] && [property hasSuffix:suffix] )
		{
			NSRange		range = NSMakeRange( prefix.length, property.length - prefix.length - suffix.length );
			NSString *	selector = [[[[property substringWithRange:range] trim] unwrap] trim];

			return [NSString stringWithFormat:@"selector.%@", selector];
		}
	}

	return nil;
}

- (NSString *)html_parseFunction:(NSString *)property
{
	property = [property trim];
	
	if ( property && property.length )
	{
		NSString * suffix = @"()";
		
		if ( [property hasSuffix:suffix] )
		{
			NSRange		range = NSMakeRange( 0, property.length - suffix.length );
			NSString *	signal = [[[[property substringWithRange:range] trim] unwrap] trim];

			return signal;
		}
	}
	
	return nil;
}

- (void)html_applyDom:(SamuraiHtmlDomNode *)dom
{
	[super html_applyDom:dom];
	
	NSString * onClick		= [self html_parseEvent:dom.attrOnClick];
	NSString * onSwipe		= [self html_parseEvent:dom.attrOnSwipe];
	NSString * onSwipeLeft	= [self html_parseEvent:dom.attrOnSwipeLeft];
	NSString * onSwipeRight	= [self html_parseEvent:dom.attrOnSwipeRight];
	NSString * onSwipeUp	= [self html_parseEvent:dom.attrOnSwipeUp];
	NSString * onSwipeDown	= [self html_parseEvent:dom.attrOnSwipeDown];
	NSString * onPinch		= [self html_parseEvent:dom.attrOnPinch];
	NSString * onPan		= [self html_parseEvent:dom.attrOnPan];

	if ( onClick )
	{
		[self enableTapGestureWithSignal:onClick];
	}

	if ( onSwipe )
	{
		[self enableSwipeGesture:UISwipeGestureRecognizerDirectionUp withSignal:onSwipe];
		[self enableSwipeGesture:UISwipeGestureRecognizerDirectionDown withSignal:onSwipe];
		[self enableSwipeGesture:UISwipeGestureRecognizerDirectionLeft withSignal:onSwipe];
		[self enableSwipeGesture:UISwipeGestureRecognizerDirectionRight withSignal:onSwipe];
	}

	if ( onSwipeLeft )
	{
		[self enableSwipeGesture:UISwipeGestureRecognizerDirectionLeft withSignal:onSwipeLeft];
	}

	if ( onSwipeRight )
	{
		[self enableSwipeGesture:UISwipeGestureRecognizerDirectionRight withSignal:onSwipeRight];
	}

	if ( onSwipeUp )
	{
		[self enableSwipeGesture:UISwipeGestureRecognizerDirectionUp withSignal:onSwipeUp];
	}

	if ( onSwipeDown )
	{
		[self enableSwipeGesture:UISwipeGestureRecognizerDirectionDown withSignal:onSwipeDown];
	}

	if ( onPinch )
	{
		[self enablePinchGestureWithSignal:onPinch];
	}

	if ( onPan )
	{
		[self enablePanGestureWithSignal:onPan];
	}
}

#pragma mark -

- (void)html_applyFrame:(CGRect)newFrame
{
	[super html_applyFrame:newFrame];
	
	[self html_applyTopBorderFrame:newFrame];
	[self html_applyLeftBorderFrame:newFrame];
	[self html_applyRightBorderFrame:newFrame];
	[self html_applyBottomBorderFrame:newFrame];
}

- (void)html_applyTopBorderFrame
{
	[self html_applyTopBorderFrame:self.frame];
}

- (void)html_applyTopBorderFrame:(CGRect)newFrame
{
	UIBorderView * topBorder = self.topBorder;
	
	if ( topBorder )
	{
		CGRect topFrame;
		
		topFrame.origin.x = 0.0f;
		topFrame.origin.y = 0.0f; // -1.0f * topBorder.lineWidth;
		topFrame.size.width = newFrame.size.width;
		topFrame.size.height = topBorder.lineWidth;

		topBorder.frame = topFrame;
		
		[topBorder.superview bringSubviewToFront:topBorder];
		[topBorder setNeedsDisplay];
	}
}

- (void)html_applyBottomBorderFrame
{
	[self html_applyBottomBorderFrame:self.frame];
}

- (void)html_applyBottomBorderFrame:(CGRect)newFrame
{
	UIBorderView * bottomBorder = self.bottomBorder;

	if ( bottomBorder )
	{
		CGRect bottomFrame;
		
		bottomFrame.origin.x = 0.0f;
		bottomFrame.origin.y = newFrame.size.height - bottomBorder.lineWidth; // newFrame.size.height;
		bottomFrame.size.width = newFrame.size.width;
		bottomFrame.size.height = bottomBorder.lineWidth;
		
		bottomBorder.frame = bottomFrame;
		
		[bottomBorder.superview bringSubviewToFront:bottomBorder];
		[bottomBorder setNeedsDisplay];
	}
}

- (void)html_applyLeftBorderFrame
{
	[self html_applyLeftBorderFrame:self.frame];
}

- (void)html_applyLeftBorderFrame:(CGRect)newFrame
{
	UIBorderView * leftBorder = self.leftBorder;
	
	if ( leftBorder )
	{
		CGRect leftFrame;
		
		leftFrame.origin.x = 0.0f; // -1.0f * leftBorder.lineWidth;
		leftFrame.origin.y = 0.0f;
		leftFrame.size.width = leftBorder.lineWidth;
		leftFrame.size.height = newFrame.size.height;
		
		leftBorder.frame = leftFrame;
		
		[leftBorder.superview bringSubviewToFront:leftBorder];
		[leftBorder setNeedsDisplay];
	}
}

- (void)html_applyRightBorderFrame
{
	[self html_applyRightBorderFrame:self.frame];
}

- (void)html_applyRightBorderFrame:(CGRect)newFrame
{
	UIBorderView * rightBorder = self.rightBorder;
	
	if ( rightBorder )
	{
		CGRect rightFrame;
		
		rightFrame.origin.x = newFrame.size.width - rightBorder.lineWidth; // newFrame.size.width;
		rightFrame.origin.y = 0.0f;
		rightFrame.size.width = rightBorder.lineWidth;
		rightFrame.size.height = newFrame.size.height;
		
		rightBorder.frame = rightFrame;
		
		[rightBorder.superview bringSubviewToFront:rightBorder];
		[rightBorder setNeedsDisplay];
	}
}

#pragma mark -

- (id)store_serialize
{
	return [self serialize];
}

- (void)store_unserialize:(id)obj
{
	[self unserialize:obj];
}

- (void)store_zerolize
{
	[self zerolize];
}

#pragma mark -

- (void)html_forView:(UIView *)hostView
{
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, UIView_Html )

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
