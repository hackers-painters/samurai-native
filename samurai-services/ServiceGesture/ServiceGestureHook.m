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

#import "ServiceGestureHook.h"
#import "ServiceGestureView.h"
#import "ServiceGesture.h"

#import "ServiceGestureViewClick.h"
#import "ServiceGestureViewSwipe.h"
#import "ServiceGestureViewPinch.h"

// ----------------------------------
// Source code
// ----------------------------------

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

static void (* __setFrame)( id, SEL, CGRect ) = NULL;

#pragma mark -

@implementation NSObject(Wireframe)

+ (void)gestureHook
{
	__setFrame = [UIView replaceSelector:@selector(setFrame:) withSelector:@selector(__setFrame:)];
}

- (ServiceGestureView *)createGestureView:(Class)clazz forContainer:(UIView *)container
{
	UIView * gestureView = nil;
	
	for ( UIView * subview in container.subviews )
	{
		if ( [subview isKindOfClass:clazz] )
		{
			gestureView = subview;
			break;
		}
	}
	
	if ( nil == gestureView )
	{
		gestureView = [[clazz alloc] init];
		
		[container addSubview:gestureView];
		[container bringSubviewToFront:gestureView];
	}

	return (ServiceGestureView *)gestureView;
}

- (void)__setFrame:(CGRect)newFrame
{
	if ( __setFrame )
	{
		__setFrame( self, _cmd, newFrame );
	}
	
	if ( NO == [self isKindOfClass:[UIView class]] )
		return;
	
	if ( [self isKindOfClass:[ServiceGestureView class]] )
		return;

	UIView * container = (UIView *)self;
	
	if ( container.window != [UIApplication sharedApplication].keyWindow )
		return;
	
	if ( nil == container.renderer )
		return;
	
	if ( container.gestureRecognizers && container.gestureRecognizers.count )
	{
		for ( UIGestureRecognizer * gesture in container.gestureRecognizers )
		{
			ServiceGestureView * gestureView = nil;

			if ( [gesture isKindOfClass:[UITapGestureRecognizer class]] )
			{
				gestureView = [self createGestureView:[ServiceGestureViewClick class] forContainer:container];
			}
			else if ( [gesture isKindOfClass:[UISwipeGestureRecognizer class]] )
			{
				gestureView = [self createGestureView:[ServiceGestureViewSwipe class] forContainer:container];
			}
			else if ( [gesture isKindOfClass:[UIPinchGestureRecognizer class]] )
			{
				gestureView = [self createGestureView:[ServiceGestureViewPinch class] forContainer:container];
			}
			
			if ( gestureView )
			{
				CGRect gestureFrame;
				gestureFrame.size.width = fminf( fminf( container.frame.size.width, container.frame.size.height ), 60.0f );
				gestureFrame.size.height = gestureFrame.size.width;
				gestureFrame.origin.x = (newFrame.size.width - gestureFrame.size.width) / 2.0f;
				gestureFrame.origin.y = (newFrame.size.height - gestureFrame.size.height) / 2.0f;
				gestureView.frame = gestureFrame;
				
				[gestureView setGesture:gesture];
				[gestureView startAnimation];
			}
		}
	}
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
