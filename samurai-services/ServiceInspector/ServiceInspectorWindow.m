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

#import "ServiceInspectorWindow.h"

#pragma mark -

#undef	Degree2Radian
#define Degree2Radian( __degree ) (M_PI / 180.0f * __degree)

#undef	MAX_DEPTH
#define MAX_DEPTH	(36)

#pragma mark -

@interface UIView(Capture)
- (UIImage *)capture;
@end

#pragma mark -

@implementation UIView(Capture)

- (UIImage *)capture
{
	NSMutableArray * temp = [NSMutableArray nonRetainingArray];
	
	for ( UIView * subview in self.subviews )
	{
		if ( NO == subview.hidden )
		{
			subview.hidden = YES;
			
			[temp addObject:subview];
		}
	}
	
	CGSize screenSize = [UIScreen mainScreen].bounds.size;
	CGRect captureBounds = CGRectZero;
	
	captureBounds.size = self.bounds.size;
	
	if ( captureBounds.size.width > screenSize.width )
	{
		captureBounds.size.width = screenSize.width;
	}
	
	if ( captureBounds.size.height > screenSize.height )
	{
		captureBounds.size.height = screenSize.height;
	}

	UIImage * image = nil;
	
	UIGraphicsBeginImageContextWithOptions( captureBounds.size, NO, [UIScreen mainScreen].scale );
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	if ( context )
	{
		CGContextTranslateCTM( context, -captureBounds.origin.x, -captureBounds.origin.y );
		
//		CGContextScaleCTM(context, 0.5, 0.5);
		[self.layer renderInContext:context];
		
//		if ( self.renderer )
//		{
//			if ( self.renderer.dom.domId )
//			{
//				NSString *		renderTips = [NSString stringWithFormat:@" #%@ ", self.renderer.dom.domId];
//				NSDictionary *	renderAttr = [NSDictionary dictionaryWithObjectsAndKeys:
//											  [UIFont systemFontOfSize:12.0f], NSFontAttributeName,
//											  [UIColor yellowColor], NSForegroundColorAttributeName,
//											  [[UIColor blackColor] colorWithAlphaComponent:0.5f], NSBackgroundColorAttributeName,
//											  nil];
//				
//				[renderTips drawAtPoint:CGPointZero withAttributes:renderAttr];
//			}
//			else if ( self.renderer.dom.domTag )
//			{
//				NSString *		renderTips = [NSString stringWithFormat:@" <%@/> ", self.renderer.dom.domTag];
//				NSDictionary *	renderAttr = [NSDictionary dictionaryWithObjectsAndKeys:
//											  [UIFont systemFontOfSize:12.0f], NSFontAttributeName,
//											  [UIColor whiteColor], NSForegroundColorAttributeName,
//											  [[UIColor blackColor] colorWithAlphaComponent:0.5f], NSBackgroundColorAttributeName,
//											  nil];
//				
//				[renderTips drawAtPoint:CGPointZero withAttributes:renderAttr];
//			}
//		}
		
		image = UIGraphicsGetImageFromCurrentImageContext();
	}
	
	UIGraphicsEndImageContext();
	
	for ( UIView * subview in temp )
	{
		subview.hidden = NO;
	}
	
	return image;
}

@end

#pragma mark -

@interface ServiceImageView : UIImageView

@prop_assign( NSUInteger,	depth );
@prop_assign( UIView *,		view );
@prop_assign( CGRect,		viewFrame );

@end

#pragma mark -

@implementation ServiceImageView

@def_prop_assign( NSUInteger,	depth );
@def_prop_assign( UIView *,		view );
@def_prop_assign( CGRect,		viewFrame );

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
	}
	return self;
}

- (void)dealloc
{
}

@end

#pragma mark -

@implementation ServiceInspectorWindow
{
	BOOL						_dragging;
	NSTimer *					_timer;
	
	CGFloat						_rotateX;
    CGFloat						_rotateY;
    CGFloat						_distance;
	BOOL						_animating;
	CGPoint						_panOffset;
	UIPanGestureRecognizer *	_panGesture;
	CGFloat						_pinchOffset;
	UIPinchGestureRecognizer *	_pinchGesture;
}

- (id)init
{
	CGRect screenBound = [UIScreen mainScreen].bounds;

	self = [super initWithFrame:screenBound];
	if ( self )
	{
		self.backgroundColor = [UIColor blackColor];
		self.windowLevel = UIWindowLevelStatusBar + 1.0f;
		self.rootViewController = [[UIViewController alloc] init];

		_panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
		[self addGestureRecognizer:_panGesture];

		_pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(didPinch:)];
		[self addGestureRecognizer:_pinchGesture];
	}
	return self;
}

- (void)dealloc
{
	[self removeLayers];
	
	[self removeGestureRecognizer:_panGesture];
	[self removeGestureRecognizer:_pinchGesture];
	
	_panGesture = nil;
	_pinchGesture = nil;
}

- (UIView *)findContainerView:(UIView *)view
{
	for ( UIView * subview in view.subviews )
	{
		if ( [subview isKindOfClass:NSClassFromString(@"UILayoutContainerView")] )
		{
			return subview;
		}
		else
		{
			UIView * result = [self findContainerView:subview];
			if ( result )
			{
				return result;
			}
		}
	}
	
	return nil;
}

- (UIView *)findWrapperView:(UIView *)view
{
	for ( UIView * subview in view.subviews )
	{
		if ( [subview isKindOfClass:NSClassFromString(@"UIViewControllerWrapperView")] )
		{
			return subview;
		}
		else
		{
			UIView * result = [self findWrapperView:subview];
			if ( result )
			{
				return result;
			}
		}
	}
	
	return nil;
}

- (UIView *)findNavigationBar:(UIView *)view
{
	for ( UIView * subview in view.subviews )
	{
		if ( [subview isKindOfClass:NSClassFromString(@"UINavigationBar")] )
		{
			return subview;
		}
		else
		{
			UIView * result = [self findNavigationBar:subview];
			if ( result )
			{
				return result;
			}
		}
	}
	
	return nil;
}

- (void)buildLayers
{
	UIView * rootView = [UIApplication sharedApplication].keyWindow;
//	UIView * container = [self findContainerView:rootView];
//	UIView * wrapperView = [self findWrapperView:container];
//	UIView * navigationBar = [self findNavigationBar:container];

	CGFloat depth = 0;

	depth = [self buildSublayersForView:rootView origin:CGPointZero depth:depth];
//	depth = [self buildSublayersForView:container origin:CGPointZero depth:depth];
//	depth = [self buildSublayersForView:wrapperView origin:CGPointZero depth:depth];
//	depth = [self buildSublayersForView:navigationBar origin:CGPointZero depth:depth];

	[self transformLayers:YES];
}

- (CGFloat)buildSublayersForView:(UIView *)view origin:(CGPoint)origin depth:(CGFloat)depth
{
	if ( depth >= MAX_DEPTH )
		return depth;
	
	if ( view.hidden )
		return depth;
	
	CGRect screenBound = [UIScreen mainScreen].bounds;
	CGRect viewFrame;
	
	viewFrame.origin.x = origin.x + view.frame.origin.x;
	viewFrame.origin.y = origin.y + view.frame.origin.y;
	viewFrame.size.width = view.frame.size.width;
	viewFrame.size.height = view.frame.size.height;
	
	if ( [view isKindOfClass:[UIScrollView class]] )
	{
		__unsafe_unretained UIScrollView * scrollView = (UIScrollView *)view;
		
		viewFrame.origin.x -= scrollView.contentOffset.x;
		viewFrame.origin.y -= scrollView.contentOffset.y;
	}
	
	CGFloat nextDepth = depth;

	if ( view.frame.size.width && view.frame.size.height )
	{
		ServiceImageView * capturedView = [[ServiceImageView alloc] init];

		capturedView.layer.cornerRadius = view.layer.cornerRadius;
		capturedView.layer.masksToBounds = view.layer.masksToBounds;
		
		CGPoint anchor;
		anchor.x = (screenBound.size.width / 2.0f - viewFrame.origin.x) / viewFrame.size.width;
		anchor.y = (screenBound.size.height / 2.0f - viewFrame.origin.y) / viewFrame.size.height;
		
		capturedView.depth = depth;
		capturedView.view = view;
		capturedView.viewFrame = viewFrame;
		
		capturedView.image = [view capture];
		capturedView.frame = viewFrame;
		capturedView.layer.anchorPoint = anchor;
		capturedView.layer.anchorPointZ = depth * -40.0f;

		if ( view.renderer )
		{
			if ( [view.renderer.childs count] )
			{
				nextDepth += 0.75f;

				capturedView.alpha = 0.5f;
				capturedView.backgroundColor = view.backgroundColor;
				capturedView.layer.borderColor = [HEX_RGBA(0x999999, 0.75) CGColor];
				capturedView.layer.borderWidth = 1.0f;
			}
			else
			{
				nextDepth += 1.0f;

				capturedView.alpha = 1.0f;
				capturedView.backgroundColor = view.backgroundColor;
				capturedView.layer.borderColor = [HEX_RGBA(0xd22042, 0.75) CGColor];
				capturedView.layer.borderWidth = 1.5f;
			}
		}
		else
		{
			nextDepth += 0.5f;

			capturedView.alpha = 1.0f;
			capturedView.backgroundColor = view.backgroundColor;
			capturedView.layer.borderColor = [HEX_RGBA(0x999999, 0.5) CGColor];
			capturedView.layer.borderWidth = 1.0f;
		}
		
		[self addSubview:capturedView];
		
		UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClicked:)];
		if ( gesture )
		{
			[capturedView setUserInteractionEnabled:YES];
			[capturedView addGestureRecognizer:gesture];
		}
	}
	
	CGFloat maxDepth = depth;

	for ( UIView * subview in [view.subviews reverseObjectEnumerator] )
	{
		CGFloat subDepth = [self buildSublayersForView:subview origin:viewFrame.origin depth:nextDepth];
		
		if ( subDepth > maxDepth )
		{
			maxDepth = subDepth;
		}
	}

	return maxDepth;
}

- (void)removeLayers
{
	NSArray * subviewsCopy = [NSArray arrayWithArray:self.subviews];

	for ( UIView * subview in subviewsCopy )
	{
		if ( [subview isKindOfClass:[ServiceImageView class]] )
		{
			[subview removeFromSuperview];
		}
	}
}

- (void)transformLayers:(BOOL)setFrames
{
    CATransform3D transform2 = CATransform3DIdentity;
    transform2.m34 = -0.002;
	transform2 = CATransform3DTranslate( transform2, _rotateY * -3.0f, 0, 0 );
	transform2 = CATransform3DTranslate( transform2, 0, _rotateX * 3.0f, 0 );

    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DMakeTranslation( 0, 0, _distance * 1000 );
    transform = CATransform3DConcat( CATransform3DMakeRotation(Degree2Radian(_rotateX), 1, 0, 0), transform );
    transform = CATransform3DConcat( CATransform3DMakeRotation(Degree2Radian(_rotateY), 0, 1, 0), transform );
    transform = CATransform3DConcat( CATransform3DMakeRotation(Degree2Radian(0), 0, 0, 1), transform );
    transform = CATransform3DConcat( transform, transform2 );

	NSArray * subviewsCopy = [NSArray arrayWithArray:self.subviews];

	for ( ServiceImageView * subview in subviewsCopy )
	{
		if ( [subview isKindOfClass:[ServiceImageView class]] )
		{
			subview.frame = CGRectInset( subview.viewFrame, 1, 1 );

			if ( _animating )
			{
				subview.layer.transform = CATransform3DIdentity;
			}
			else
			{
				subview.layer.transform = transform;
			}

			[subview setNeedsDisplay];
		}
	}
}

#pragma mark -

- (void)show
{
	[self showStep1];
}

- (void)showStep1
{
	_rotateX = 0.0f;
	_rotateY = 0.0f;
	_distance = 0.0f;
	_animating = YES;
	
	self.hidden = NO;
	self.alpha = 0.0f;
	
	[self removeLayers];
	[self buildLayers];
	
	[self transformLayers:YES];
	
	[UIView beginAnimations:@"showStep1" context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.2f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(showStep2)];
	
	self.alpha = 1.0f;
	self.hidden = NO;
	
	[UIView commitAnimations];
}

- (void)showStep2
{
	_rotateX = -30.0f;
	_rotateY = 0.0f;
	_distance = -0.45f;
	_animating = NO;

	[UIView beginAnimations:@"showStep2" context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.75f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(showStep3)];
	
	[self transformLayers:NO];
	
	[UIView commitAnimations];
}

- (void)showStep3
{
	_animating = NO;
	
	if ( nil == _timer )
	{
		_timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
												  target:self
												selector:@selector(refreshLayers)
												userInfo:nil
												 repeats:YES];
	}
}

#pragma mark -

- (void)hide
{
	if ( _timer )
	{
		[_timer invalidate];

		_timer = nil;
	}
	
	[self hideStep1];
}

- (void)hideStep1
{
	_rotateX = 0.0f;
	_rotateY = 0.0f;
	_distance = 0.0f;
	_animating = YES;

	[UIView beginAnimations:@"hideStep1" context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.75f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(hideStep2)];
	
	[self transformLayers:YES];
	
	[UIView commitAnimations];
}

- (void)hideStep2
{
	_animating = NO;

	[UIView beginAnimations:@"showStep2" context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(showStep3)];
	
	self.alpha = 0.0f;
	
	[UIView commitAnimations];
}

- (void)hideStep3
{
	_rotateX = 0.0f;
	_rotateY = 0.0f;
	_distance = 0.0f;
	_animating = NO;

	self.alpha = 0.0f;
	self.hidden = YES;
	
	[self removeLayers];
}

#pragma mark -

- (void)refreshLayers
{
	if ( _dragging )
		return;
	
	if ( _animating )
		return;

	[self removeLayers];
	[self buildLayers];
}

#pragma mark -

- (void)didClicked:(UITapGestureRecognizer *)tapGesture
{
//	if ( UIGestureRecognizerStateEnded == tapGesture.state )
//	{
//		if ( tapGesture.view && [tapGesture.view isKindOfClass:[ServiceImageView class]] )
//		{
//			ServiceImageView * view = (ServiceImageView *)tapGesture.view;
//		}
//	}
}

- (void)didPan:(UIPanGestureRecognizer *)panGesture
{
	if ( UIGestureRecognizerStateBegan == panGesture.state )
	{
		_dragging = YES;
		
		_panOffset.x = _rotateY;
		_panOffset.y = _rotateX * -1.0f;
	}
	else if ( UIGestureRecognizerStateChanged == panGesture.state )
	{
		_dragging = YES;

		CGPoint offset = [panGesture translationInView:self];
		
		_rotateY = _panOffset.x + offset.x * 0.5f;
		_rotateX = _panOffset.y * -1.0f - offset.y * 0.5f;
		
		[self transformLayers:NO];
	}
	else if ( UIGestureRecognizerStateEnded == panGesture.state )
	{
		_dragging = NO;

		[self transformLayers:NO];
	}
	else if ( UIGestureRecognizerStateCancelled == panGesture.state )
	{
		_dragging = NO;
		
		[self transformLayers:NO];
	}
}

- (void)didPinch:(UIPinchGestureRecognizer *)pinchGesture
{
	if ( UIGestureRecognizerStateBegan == pinchGesture.state )
	{
		_dragging = YES;
		
		_pinchOffset = _distance;
	}
	else if ( UIGestureRecognizerStateChanged == pinchGesture.state )
	{
		_dragging = YES;

		_distance = _pinchOffset + (pinchGesture.scale - 1.0f);
		_distance = (_distance < -5.0f ? -5.0f : (_distance > 0.5f ? 0.5f : _distance));
		
		[self transformLayers:NO];
	}
	else if ( UIGestureRecognizerStateEnded == pinchGesture.state )
	{
		_dragging = NO;
		
		[self transformLayers:NO];
	}
	else if ( UIGestureRecognizerStateCancelled == pinchGesture.state )
	{
		_dragging = NO;
		
		[self transformLayers:NO];
	}
}

@end
