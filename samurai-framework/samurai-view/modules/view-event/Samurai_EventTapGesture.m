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

@interface __TapGestureRecognizer : UITapGestureRecognizer<UIGestureRecognizerDelegate>
@end

#pragma mark -

@implementation __TapGestureRecognizer
@end

#pragma mark -

@implementation UIView(EventTapGesture)

@def_signal( eventTapPressing );	/// 按下
@def_signal( eventTapRaised );		/// 抬起
@def_signal( eventTapCancelled );	/// 取消

@def_prop_dynamic_strong( NSString *,	tapSignalName, setTapSignalName );

#pragma mark -

+ (BOOL)supportTapGesture
{
	return YES;
}

#pragma mark -

- (void)__tapGestureInternalCallback:(__TapGestureRecognizer *)gesture
{
	if ( UIGestureRecognizerStatePossible == gesture.state )
	{
		// the recognizer has not yet recognized its gesture, but may be evaluating touch events. this is the default state
		
		[self sendSignal:UIView.eventTapPressing];
	}
	else if ( UIGestureRecognizerStateBegan == gesture.state )
	{
		// the recognizer has received touches recognized as the gesture. the action method will be called at the next turn of the run loop
	}
	else if ( UIGestureRecognizerStateChanged == gesture.state )
	{
		// the recognizer has received touches recognized as a change to the gesture. the action method will be called at the next turn of the run loop
		
	}
	else if ( UIGestureRecognizerStateEnded == gesture.state )
	{
		// the recognizer has received touches recognized as the end of the gesture. the action method will be called at the next turn of the run loop and the recognizer will be reset to UIGestureRecognizerStatePossible
		
		if ( self.tapSignalName )
		{
			[self sendSignal:self.tapSignalName];
		}
		else
		{
			[self sendSignal:UIView.eventTapRaised];
		}
	}
	else if ( UIGestureRecognizerStateCancelled == gesture.state )
	{
		// the recognizer has received touches resulting in the cancellation of the gesture. the action method will be called at the next turn of the run loop. the recognizer will be reset to UIGestureRecognizerStatePossible
		
		[self sendSignal:UIView.eventTapCancelled];
	}
	else if ( UIGestureRecognizerStateFailed == gesture.state )
	{
		// the recognizer has received a touch sequence that can not be recognized as the gesture. the action method will not be called and the recognizer will be reset to UIGestureRecognizerStatePossible
		
	}
}

- (__TapGestureRecognizer *)tapGesture
{
	__TapGestureRecognizer * tapGesture = nil;
	
	for ( UIGestureRecognizer * gesture in self.gestureRecognizers )
	{
		if ( [gesture isKindOfClass:[__TapGestureRecognizer class]] )
		{
			tapGesture = (__TapGestureRecognizer *)gesture;
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
	if ( NO == [[self class] supportTapGesture] )
	{
		return;
	}
	
	__TapGestureRecognizer * tapGesture = [self tapGesture];

	if ( nil == tapGesture )
	{
		tapGesture = [[__TapGestureRecognizer alloc] initWithTarget:self action:@selector(__tapGestureInternalCallback:)];
		
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
