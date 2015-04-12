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

#import "ServiceGestureViewPinch.h"
#import "ServiceGesture.h"

// ----------------------------------
// Source code
// ----------------------------------

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

@implementation ServiceGestureViewPinch
{
	BOOL						_animating;
	UIPinchGestureRecognizer *	_gesture;
	UIImageView *				_circle;
	UIImageView *				_finger1;
	UIImageView *				_finger2;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		self.layer.masksToBounds = NO;

		_circle = [[UIImageView alloc] init];
		_circle.backgroundColor = [UIColor clearColor];
		_circle.contentMode = UIViewContentModeScaleAspectFit;
		_circle.alpha = 0.0f;
		[self addSubview:_circle];

		_finger1 = [[UIImageView alloc] init];
		_finger1.backgroundColor = [UIColor clearColor];
		_finger1.contentMode = UIViewContentModeScaleAspectFit;
		_finger1.alpha = 0.0f;
		[self addSubview:_finger1];

		_finger2 = [[UIImageView alloc] init];
		_finger2.backgroundColor = [UIColor clearColor];
		_finger2.contentMode = UIViewContentModeScaleAspectFit;
		_finger2.alpha = 0.0f;
		[self addSubview:_finger2];
	}
	return self;
}

- (void)dealloc
{
	[_circle removeFromSuperview];
	_circle = nil;
	
	[_finger1 removeFromSuperview];
	_finger1 = nil;

	[_finger2 removeFromSuperview];
	_finger2 = nil;
}

- (void)setGesture:(UIGestureRecognizer *)gesture
{
	_gesture = (UIPinchGestureRecognizer *)gesture;
	
	_circle.image = [[ServiceGesture instance].bundle imageForResource:@"gesture-circle.png"];
	_finger1.image = [[ServiceGesture instance].bundle imageForResource:@"gesture-pinch.png"];
	_finger2.image = [[ServiceGesture instance].bundle imageForResource:@"gesture-spread.png"];
}

- (void)setFrame:(CGRect)newFrame
{
	[super setFrame:newFrame];

	CGRect circleFrame;
	circleFrame.origin = CGPointZero;
	circleFrame.size = newFrame.size;
	_circle.frame = circleFrame;

	CGRect fingerFrame1;
	fingerFrame1.origin = CGPointZero;
	fingerFrame1.size = newFrame.size;
	_finger1.frame = CGRectInset( fingerFrame1, -20.0f, -20.0f );

	CGRect fingerFrame2;
	fingerFrame2.origin = CGPointZero;
	fingerFrame2.size = newFrame.size;
	_finger2.frame = CGRectInset( fingerFrame2, -20.0f, -20.0f );
}

- (void)startAnimation
{
	[self performSelector:@selector(startAnimationStep1) withObject:nil afterDelay:0.6f];
}

- (void)startAnimationStep1
{
	if ( NO == _animating )
	{
		CGAffineTransform transform;
		
		transform = CGAffineTransformIdentity;
		transform = CGAffineTransformScale( transform, 0.3f, 0.3f );
		_circle.transform = transform;
		_circle.alpha = 0.0f;
		
		_finger1.transform = CGAffineTransformIdentity;
		_finger2.transform = CGAffineTransformIdentity;
		
		_finger1.alpha = 0.0f;
		_finger2.alpha = 0.0f;
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.6f];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(startAnimationStep2)];
		
		_circle.alpha = 0.6f;
		_finger1.alpha = 1.0f;
		_finger2.alpha = 0.0f;
		
		[UIView commitAnimations];
		
		_animating = YES;
	}
}

- (void)startAnimationStep2
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.6f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(startAnimationStep3)];

	CGAffineTransform transform;
	transform = CGAffineTransformIdentity;
	transform = CGAffineTransformScale( transform, 1.0f, 1.0f );
	_circle.transform = transform;
	_circle.alpha = 1.0f;

	_finger1.alpha = 0.0f;
	_finger2.alpha = 1.0f;

	[UIView commitAnimations];
}

- (void)startAnimationStep3
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.6f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(startAnimationStep4)];
	
	CGAffineTransform transform;
	transform = CGAffineTransformIdentity;
	transform = CGAffineTransformScale( transform, 0.3f, 0.3f );
	_circle.transform = transform;
	_circle.alpha = 0.6f;
	
	_finger1.alpha = 1.0f;
	_finger2.alpha = 0.0f;
	
	[UIView commitAnimations];
}

- (void)startAnimationStep4
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.6f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(startAnimationStep5)];
	
	_circle.alpha = 0.0f;
	_finger1.alpha = 0.0f;
	_finger2.alpha = 0.0f;
	
	[UIView commitAnimations];
}

- (void)startAnimationStep5
{
	_animating = NO;
	
	[self startAnimation];
}

- (void)stopAnimation
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
