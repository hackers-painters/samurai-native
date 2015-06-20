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

#import "Samurai_EventSwipeGesture.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@interface __SwipeGestureRecognizer : UISwipeGestureRecognizer
@end

@implementation __SwipeGestureRecognizer
@end

#pragma mark -

@implementation UIView(EventSwipeGesture)

@def_prop_dynamic_strong( NSString *,	swipeUpSignalName,		setSwipeUpSignalName );
@def_prop_dynamic_strong( NSString *,	swipeDownSignalName,	setSwipeDownSignalName );
@def_prop_dynamic_strong( NSString *,	swipeLeftSignalName,	setSwipeLeftSignalName );
@def_prop_dynamic_strong( NSString *,	swipeRightSignalName,	setSwipeRightSignalName );

@def_signal( eventSwipeLeft );
@def_signal( eventSwipeRight );
@def_signal( eventSwipeUp );
@def_signal( eventSwipeDown );

#pragma mark -

+ (BOOL)supportSwipeGesture
{
	return YES;
}

#pragma mark -

- (void)__swipeGestureInternalCallback:(__SwipeGestureRecognizer *)gesture
{
	if ( UIGestureRecognizerStatePossible == gesture.state )
	{
		// the recognizer has not yet recognized its gesture, but may be evaluating touch events. this is the default state
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

		if ( UISwipeGestureRecognizerDirectionUp == gesture.direction )
		{
			if ( self.swipeUpSignalName )
			{
				[self sendSignal:self.swipeUpSignalName];
			}
			else
			{
				[self sendSignal:UIView.eventSwipeUp];
			}
		}
		else if ( UISwipeGestureRecognizerDirectionDown == gesture.direction )
		{
			if ( self.swipeDownSignalName )
			{
				[self sendSignal:self.swipeDownSignalName];
			}
			else
			{
				[self sendSignal:UIView.eventSwipeDown];
			}
		}
		else if ( UISwipeGestureRecognizerDirectionLeft == gesture.direction )
		{
			if ( self.swipeLeftSignalName )
			{
				[self sendSignal:self.swipeLeftSignalName];
			}
			else
			{
				[self sendSignal:UIView.eventSwipeLeft];
			}
		}
		else if ( UISwipeGestureRecognizerDirectionRight == gesture.direction )
		{
			if ( self.swipeRightSignalName )
			{
				[self sendSignal:self.swipeRightSignalName];
			}
			else
			{
				[self sendSignal:UIView.eventSwipeRight];
			}
		}
	}
	else if ( UIGestureRecognizerStateCancelled == gesture.state )
	{
		// the recognizer has received touches resulting in the cancellation of the gesture. the action method will be called at the next turn of the run loop. the recognizer will be reset to UIGestureRecognizerStatePossible
	}
	else if ( UIGestureRecognizerStateFailed == gesture.state )
	{
		// the recognizer has received a touch sequence that can not be recognized as the gesture. the action method will not be called and the recognizer will be reset to UIGestureRecognizerStatePossible
		
	}
}

- (__SwipeGestureRecognizer *)swipeGesture
{
	__SwipeGestureRecognizer * swipeGesture = nil;
	
	for ( UIGestureRecognizer * gesture in self.gestureRecognizers )
	{
		if ( [gesture isKindOfClass:[__SwipeGestureRecognizer class]] )
		{
			swipeGesture = (__SwipeGestureRecognizer *)gesture;
			break;
		}
	}
	
	return swipeGesture;
}

#pragma mark -

- (void)enableSwipeDirection:(UISwipeGestureRecognizerDirection)direction withSignal:(NSString *)signal
{
	if ( NO == [[self class] supportSwipeGesture] )
	{
		return;
	}
	
	__SwipeGestureRecognizer * swipeGesture = [self swipeGesture];

	if ( nil == swipeGesture )
	{
		swipeGesture = [[__SwipeGestureRecognizer alloc] initWithTarget:self action:@selector(__swipeGestureInternalCallback:)];

		swipeGesture.direction = direction;
		swipeGesture.numberOfTouchesRequired = 1;
		swipeGesture.cancelsTouchesInView = NO;
		swipeGesture.delaysTouchesBegan = NO;
		swipeGesture.delaysTouchesEnded = NO;

		[self addGestureRecognizer:swipeGesture];
	}

	if ( swipeGesture )
	{
		swipeGesture.enabled = YES;

		if ( UISwipeGestureRecognizerDirectionUp == swipeGesture.direction )
		{
			self.swipeUpSignalName = signal;
		}
		else if ( UISwipeGestureRecognizerDirectionDown == swipeGesture.direction )
		{
			self.swipeDownSignalName = signal;
		}
		else if ( UISwipeGestureRecognizerDirectionLeft == swipeGesture.direction )
		{
			self.swipeLeftSignalName = signal;
		}
		else if ( UISwipeGestureRecognizerDirectionRight == swipeGesture.direction )
		{
			self.swipeRightSignalName = signal;
		}
		
		if ( NO == self.userInteractionEnabled )
		{
			self.userInteractionEnabled = YES;
		}
	}
}

- (void)enableSwipeGesture:(UISwipeGestureRecognizerDirection)direction
{
	[self enableSwipeGesture:direction withSignal:nil];
}

- (void)enableSwipeGesture:(UISwipeGestureRecognizerDirection)direction withSignal:(NSString *)signal
{
	if ( direction & UISwipeGestureRecognizerDirectionUp )
	{
		[self enableSwipeDirection:UISwipeGestureRecognizerDirectionUp withSignal:signal];
	}

	if ( direction & UISwipeGestureRecognizerDirectionDown )
	{
		[self enableSwipeDirection:UISwipeGestureRecognizerDirectionDown withSignal:signal];
	}

	if ( direction & UISwipeGestureRecognizerDirectionLeft )
	{
		[self enableSwipeDirection:UISwipeGestureRecognizerDirectionLeft withSignal:signal];
	}

	if ( direction & UISwipeGestureRecognizerDirectionRight )
	{
		[self enableSwipeDirection:UISwipeGestureRecognizerDirectionRight withSignal:signal];
	}
}

- (void)disableSwipeGesture
{
	for ( UIGestureRecognizer * gesture in [self.gestureRecognizers copy] )
	{
		if ( [gesture isKindOfClass:[__SwipeGestureRecognizer class]] )
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

TEST_CASE( UI, EventSwipeGesture )

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
