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

#import "Samurai_EventPanGesture.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@interface __PanGestureRecognizer : UIPanGestureRecognizer
@end

@implementation __PanGestureRecognizer
@end

#pragma mark -

@implementation UIView(EventPanGesture)

@def_signal( eventPanBegin );		/// 开始
@def_signal( eventPanChanged );		/// 移动
@def_signal( eventPanEnded );		/// 结束
@def_signal( eventPanCancelled );	/// 取消

@def_prop_dynamic_strong( NSString *,	panSignalName, setPanSignalName );

@def_prop_dynamic( CGPoint,	panOffset );
@def_prop_dynamic( CGPoint,	panVelocity );

#pragma mark -

+ (BOOL)supportPanGesture
{
	return YES;
}

#pragma mark -

- (void)__panGestureInternalCallback:(__PanGestureRecognizer *)gesture
{
	if ( UIGestureRecognizerStatePossible == gesture.state )
	{
		// the recognizer has not yet recognized its gesture, but may be evaluating touch events. this is the default state
	}
	else if ( UIGestureRecognizerStateBegan == gesture.state )
	{
		// the recognizer has received touches recognized as the gesture. the action method will be called at the next turn of the run loop

		if ( self.panSignalName )
		{
			[self sendSignal:self.panSignalName];
		}
		else
		{
			[self sendSignal:UIView.eventPanBegin];
		}
	}
	else if ( UIGestureRecognizerStateChanged == gesture.state )
	{
		// the recognizer has received touches recognized as a change to the gesture. the action method will be called at the next turn of the run loop
		
		if ( self.panSignalName )
		{
			[self sendSignal:self.panSignalName];
		}
		else
		{
			[self sendSignal:UIView.eventPanChanged];
		}
	}
	else if ( UIGestureRecognizerStateEnded == gesture.state )
	{
		// the recognizer has received touches recognized as the end of the gesture. the action method will be called at the next turn of the run loop and the recognizer will be reset to UIGestureRecognizerStatePossible
		
		if ( self.panSignalName )
		{
			[self sendSignal:self.panSignalName];
		}
		else
		{
			[self sendSignal:UIView.eventPanEnded];
		}
	}
	else if ( UIGestureRecognizerStateCancelled == gesture.state )
	{
		// the recognizer has received touches resulting in the cancellation of the gesture. the action method will be called at the next turn of the run loop. the recognizer will be reset to UIGestureRecognizerStatePossible
		
		if ( self.panSignalName )
		{
			[self sendSignal:self.panSignalName];
		}
		else
		{
			[self sendSignal:UIView.eventPanCancelled];
		}
	}
	else if ( UIGestureRecognizerStateFailed == gesture.state )
	{
		// the recognizer has received a touch sequence that can not be recognized as the gesture. the action method will not be called and the recognizer will be reset to UIGestureRecognizerStatePossible
	}
}

- (CGPoint)panOffset
{
	__PanGestureRecognizer * panGesture = [self panGesture];
	
	return [panGesture translationInView:self];
}

- (CGPoint)panVelocity
{
	__PanGestureRecognizer * panGesture = [self panGesture];
	
	return [panGesture velocityInView:self];
}

- (__PanGestureRecognizer *)panGesture
{
	__PanGestureRecognizer * panGesture = nil;
	
	for ( UIGestureRecognizer * gesture in self.gestureRecognizers )
	{
		if ( [gesture isKindOfClass:[__PanGestureRecognizer class]] )
		{
			panGesture = (__PanGestureRecognizer *)gesture;
			break;
		}
	}

	return panGesture;
}

#pragma mark -

- (void)enablePanGesture
{
	[self enablePanGestureWithSignal:nil];
}

- (void)enablePanGestureWithSignal:(NSString *)signal
{
	if ( NO == [[self class] supportPanGesture] )
	{
		return;
	}

	__PanGestureRecognizer * panGesture = [self panGesture];
	
	if ( nil == panGesture )
	{
		panGesture = [[__PanGestureRecognizer alloc] initWithTarget:self action:@selector(__panGestureInternalCallback:)];
		panGesture.cancelsTouchesInView = NO;
		panGesture.delaysTouchesBegan = NO;
		panGesture.delaysTouchesEnded = NO;

		[self addGestureRecognizer:panGesture];
	}
	
	if ( panGesture )
	{
		panGesture.enabled = YES;
		
		self.panSignalName = signal;

		if ( NO == self.userInteractionEnabled )
		{
			self.userInteractionEnabled = YES;
		}
	}
}

- (void)disablePanGesture
{
	for ( UIGestureRecognizer * gesture in [self.gestureRecognizers copy] )
	{
		if ( [gesture isKindOfClass:[__PanGestureRecognizer class]] )
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

TEST_CASE( UI, EventPanGesture )

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
