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

#import "Samurai_EventPinchGesture.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@interface __PinchGestureRecognizer : UIPinchGestureRecognizer
@end

@implementation __PinchGestureRecognizer
@end

#pragma mark -

@implementation UIView(EventPinchGesture)

@def_signal( eventPinchBegin );
@def_signal( eventPinchChanged );
@def_signal( eventPinchEnded );
@def_signal( eventPinchCancelled );

@def_prop_dynamic_strong( NSString *,	pinchSignalName, setPinchSignalName );

@def_prop_dynamic( CGFloat,	pinchScale );
@def_prop_dynamic( CGFloat,	pinchVelocity );

#pragma mark -

+ (BOOL)supportPinchGesture
{
	return YES;
}

#pragma mark -

- (void)__pinchGestureInternalCallback:(__PinchGestureRecognizer *)gesture
{
	if ( UIGestureRecognizerStatePossible == gesture.state )
	{
		// the recognizer has not yet recognized its gesture, but may be evaluating touch events. this is the default state
	}
	else if ( UIGestureRecognizerStateBegan == gesture.state )
	{
		// the recognizer has received touches recognized as the gesture. the action method will be called at the next turn of the run loop

		if ( self.pinchSignalName )
		{
			[self sendSignal:self.pinchSignalName];
		}
		else
		{
			[self sendSignal:UIView.eventPinchBegin];
		}
	}
	else if ( UIGestureRecognizerStateChanged == gesture.state )
	{
		// the recognizer has received touches recognized as a change to the gesture. the action method will be called at the next turn of the run loop

		if ( self.pinchSignalName )
		{
			[self sendSignal:self.pinchSignalName];
		}
		else
		{
			[self sendSignal:UIView.eventPinchChanged];
		}
	}
	else if ( UIGestureRecognizerStateEnded == gesture.state )
	{
		// the recognizer has received touches recognized as the end of the gesture. the action method will be called at the next turn of the run loop and the recognizer will be reset to UIGestureRecognizerStatePossible

		if ( self.pinchSignalName )
		{
			[self sendSignal:self.pinchSignalName];
		}
		else
		{
			[self sendSignal:UIView.eventPinchEnded];
		}
	}
	else if ( UIGestureRecognizerStateCancelled == gesture.state )
	{
		// the recognizer has received touches resulting in the cancellation of the gesture. the action method will be called at the next turn of the run loop. the recognizer will be reset to UIGestureRecognizerStatePossible

		if ( self.pinchSignalName )
		{
			[self sendSignal:self.pinchSignalName];
		}
		else
		{
			[self sendSignal:UIView.eventPinchCancelled];
		}
	}
	else if ( UIGestureRecognizerStateFailed == gesture.state )
	{
		// the recognizer has received a touch sequence that can not be recognized as the gesture. the action method will not be called and the recognizer will be reset to UIGestureRecognizerStatePossible
	}
}

- (CGFloat)pinchScale
{
	__PinchGestureRecognizer * pinchGesture = [self pinchGesture];
	
	if ( nil == pinchGesture )
		return 0.0f;

	return pinchGesture.scale;
}

- (CGFloat)pinchVelocity
{
	__PinchGestureRecognizer * pinchGesture = [self pinchGesture];
	
	if ( nil == pinchGesture )
		return 0.0f;

	return pinchGesture.velocity;
}

- (__PinchGestureRecognizer *)pinchGesture
{
	__PinchGestureRecognizer * pinchGesture = nil;
	
	for ( UIGestureRecognizer * gesture in self.gestureRecognizers )
	{
		if ( [gesture isKindOfClass:[__PinchGestureRecognizer class]] )
		{
			pinchGesture = (__PinchGestureRecognizer *)gesture;
			break;
		}
	}

	return pinchGesture;
}

#pragma mark -

- (void)enablePinchGesture
{
	[self enablePinchGestureWithSignal:nil];
}

- (void)enablePinchGestureWithSignal:(NSString *)signal
{
	if ( NO == [[self class] supportPinchGesture] )
	{
		return;
	}

	__PinchGestureRecognizer * pinchGesture = [self pinchGesture];
	
	if ( nil == pinchGesture )
	{
		pinchGesture = [[__PinchGestureRecognizer alloc] initWithTarget:self action:@selector(__pinchGestureInternalCallback:)];
		pinchGesture.cancelsTouchesInView = NO;
		pinchGesture.delaysTouchesBegan = NO;
		pinchGesture.delaysTouchesEnded = NO;

		[self addGestureRecognizer:pinchGesture];
	}
	
	if ( pinchGesture )
	{
		pinchGesture.enabled = YES;

		self.pinchSignalName = signal;

		if ( NO == self.userInteractionEnabled )
		{
			self.userInteractionEnabled = YES;
		}
	}
}

- (void)disablePinchGesture
{
	for ( UIGestureRecognizer * gesture in [self.gestureRecognizers copy] )
	{
		if ( [gesture isKindOfClass:[__PinchGestureRecognizer class]] )
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

TEST_CASE( UI, EventPinchGesture )

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
