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

#import "Samurai_EventTapGesture.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@interface __TapGestureRecognizer : UITapGestureRecognizer

@prop_assign( TapState,	tapState );

@end

#pragma mark -

@implementation __TapGestureRecognizer

@def_prop_assign( TapState,	tapState );

- (id)initWithTarget:(id)target action:(SEL)action
{
	self = [super initWithTarget:target action:action];
	if ( self )
	{
		self.tapState = TapState_Idle;
	}
	return self;
}

- (void)dealloc
{
}

#pragma mark -

- (void)reset
{
	if ( TapState_Pressing == self.tapState || TapState_Moving == self.tapState )
	{
		[self changeState:TapState_Cancelled];
	}

	[self changeState:TapState_Idle];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	
	if ( UIGestureRecognizerStatePossible == self.state )
	{
		[self changeState:TapState_Pressing];
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesMoved:touches withEvent:event];
	
	if ( TapState_Pressing == self.tapState )
	{
		[self changeState:TapState_Moving];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
	
	if ( TapState_Pressing == self.tapState || TapState_Moving == self.tapState )
	{
		[self changeState:TapState_Raised];
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesCancelled:touches withEvent:event];

	if ( TapState_Pressing == self.tapState || TapState_Moving == self.tapState )
	{
		[self changeState:TapState_Cancelled];
	}
}

- (void)changeState:(TapState)newState
{
	if ( newState != self.tapState )
	{
		triggerBefore( self.view, tapStateChanged );

		self.tapState = newState;

		if ( TapState_Pressing == self.tapState )
		{
//			if ( self.view.tapSignalName )
//			{
//				[self.view sendSignal:self.view.tapSignalName];
//			}
//			else
			{
				[self.view sendSignal:UIView.eventTapPressing];
			}
		}
		else if ( TapState_Moving == self.tapState )
		{
//			if ( self.view.tapSignalName )
//			{
//				[self.view sendSignal:self.view.tapSignalName];
//			}
//			else
			{
				[self.view sendSignal:UIView.eventTapMoving];
			}
		}
		else if ( TapState_Raised == self.tapState )
		{
			if ( self.view.tapSignalName )
			{
				[self.view sendSignal:self.view.tapSignalName];
			}
			else
			{
				[self.view sendSignal:UIView.eventTapRaised];
			}
		}
		else if ( TapState_Cancelled == self.tapState )
		{
//			if ( self.view.tapSignalName )
//			{
//				[self.view sendSignal:self.view.tapSignalName];
//			}
//			else
			{
				[self.view sendSignal:UIView.eventTapCancelled];
			}
		}

		triggerAfter( self.view, tapStateChanged );
	}
}

@end

#pragma mark -

@implementation UIView(EventTapGesture)

@def_joint( tapStateChanged );

@def_signal( eventTapPressing );	/// 按下
@def_signal( eventTapMoving );		/// 移动
@def_signal( eventTapRaised );		/// 抬起
@def_signal( eventTapCancelled );	/// 取消

@def_prop_dynamic_strong( NSString *,	tapSignalName, setTapSignalName );

@def_prop_dynamic( TapState,	tapState );
@def_prop_dynamic( BOOL,		tapPressing );
@def_prop_dynamic( BOOL,		tapMoving );
@def_prop_dynamic( BOOL,		tapRaised );
@def_prop_dynamic( BOOL,		tapCancelled );

#pragma mark -

- (TapState)tapState
{
	__TapGestureRecognizer * gesture = [self tapGesture];
	
	if ( nil == gesture )
		return TapState_Idle;

	return gesture.tapState;
}

- (BOOL)tapPressing
{
	__TapGestureRecognizer * gesture = [self tapGesture];

	if ( nil == gesture )
		return NO;
	
	return (TapState_Pressing == gesture.tapState) ? YES : NO;
}

- (BOOL)tapMoving
{
	__TapGestureRecognizer * gesture = [self tapGesture];
	
	if ( nil == gesture )
		return NO;

	return (TapState_Moving == gesture.tapState) ? YES : NO;
}

- (BOOL)tapRaised
{
	__TapGestureRecognizer * gesture = [self tapGesture];

	if ( nil == gesture )
		return NO;

	return (TapState_Raised == gesture.tapState) ? YES : NO;
}

- (BOOL)tapCancelled
{
	__TapGestureRecognizer * gesture = [self tapGesture];

	if ( nil == gesture )
		return NO;

	return (TapState_Cancelled == gesture.tapState) ? YES : NO;
}

#pragma mark -

- (__TapGestureRecognizer *)tapGesture
{
	__TapGestureRecognizer * tapGesture = nil;
	
	for ( UIGestureRecognizer * subGesture in self.gestureRecognizers )
	{
		if ( [subGesture isKindOfClass:[__TapGestureRecognizer class]] )
		{
			tapGesture = (__TapGestureRecognizer *)subGesture;
			break;
		}
	}
	
	return tapGesture;
}

#pragma mark -

- (void)enableTapGesture
{
	[self enableTapGestureWithSignal:nil];
}

- (void)enableTapGestureWithSignal:(NSString *)signal
{
	__TapGestureRecognizer * tapGesture = [self tapGesture];
	
	if ( nil == tapGesture )
	{
		tapGesture = [[__TapGestureRecognizer alloc] init];

		tapGesture.numberOfTouchesRequired = 1;
		tapGesture.cancelsTouchesInView = NO;
		tapGesture.delaysTouchesBegan = NO;
		tapGesture.delaysTouchesEnded = NO;

		[self addGestureRecognizer:tapGesture];
	}

	if ( tapGesture )
	{
		tapGesture.enabled = YES;

		self.tapSignalName = signal;
		
		if ( NO == self.userInteractionEnabled )
		{
			self.userInteractionEnabled = YES;
		}
	}
}

- (void)disableTapGesture
{
	for ( UIGestureRecognizer * gesture in [self.gestureRecognizers copy] )
	{
		if ( [gesture isKindOfClass:[__TapGestureRecognizer class]] )
		{
			gesture.enabled = NO;
		}
	}
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, EventTapGesture )

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
