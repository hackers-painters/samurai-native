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

#import "ServiceTapspotView.h"

// ----------------------------------
// Source code
// ----------------------------------

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

@implementation ServiceTapspotView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		self.backgroundColor = [UIColor clearColor];
		self.userInteractionEnabled = NO;
		self.contentMode = UIViewContentModeCenter;
	}
	return self;
}

- (void)dealloc
{
}

- (void)didAppearingAnimationStopped
{
	[self removeFromSuperview];
}

- (void)startAnimation
{
	self.alpha = 1.0f;
	self.transform = CGAffineTransformMakeScale( 0.5f, 0.5f );
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:0.6f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(didAppearingAnimationStopped)];
	
	self.alpha = 0.0f;
	self.transform = CGAffineTransformIdentity;
	
	[UIView commitAnimations];
}

- (void)stopAnimation
{
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	if ( context )
	{
		CGContextSaveGState( context );
		
		CGContextSetFillColorWithColor( context, [[UIColor clearColor] CGColor] );
		CGContextFillRect( context, rect );
		
		CGRect bound;
		bound.origin = CGPointZero;
		bound.size = rect.size;
		
		CGContextAddEllipseInRect( context, bound );
		CGContextSetFillColorWithColor( context, [[UIColor lightGrayColor] CGColor] );
		CGContextFillPath( context );

		CGContextAddEllipseInRect( context, CGRectInset(bound, 5, 5) );
		CGContextSetFillColorWithColor( context, [[UIColor whiteColor] CGColor] );
		CGContextFillPath( context );

		CGContextRestoreGState( context );
	}
	
	[super drawRect:rect];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
