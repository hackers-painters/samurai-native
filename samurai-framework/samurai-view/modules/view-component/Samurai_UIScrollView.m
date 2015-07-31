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

#import "Samurai_UIScrollView.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_Metric.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiUIScrollViewAgent

@def_prop_assign( BOOL,				scrollEventsEnabled )
@def_prop_unsafe( UIScrollView *,	scrollView )

// any offset changes
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if ( self.scrollEventsEnabled )
	{
		[self.scrollView sendSignal:UIScrollView.eventDidScroll];
	}
}

// any zoom scale changes
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
	if ( self.scrollEventsEnabled )
	{
		[self.scrollView sendSignal:UIScrollView.eventDidZoom];
	}
}

// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	if ( self.scrollEventsEnabled )
	{
		[self.scrollView sendSignal:UIScrollView.eventWillBeginDragging];
	}
}

// called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
	if ( self.scrollEventsEnabled )
	{
		[self.scrollView sendSignal:UIScrollView.eventWillEndDragging];
	}
}

// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if ( self.scrollEventsEnabled )
	{
		[self.scrollView sendSignal:UIScrollView.eventDidEndDragging];
	}
}

// called on finger up as we are moving
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
	if ( self.scrollEventsEnabled )
	{
		[self.scrollView sendSignal:UIScrollView.eventWillBeginDecelerating];
	}
}

// called when scroll view grinds to a halt
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	if ( self.scrollEventsEnabled )
	{
		[self.scrollView sendSignal:UIScrollView.eventDidEndDecelerating];
	}
}

// called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
	if ( self.scrollEventsEnabled )
	{
		[self.scrollView sendSignal:UIScrollView.eventDidEndScrolling];
	}
}

// return a view that will be scaled. if delegate returns nil, nothing happens
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return nil;
}

// called before the scroll view begins zooming its content
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
	if ( self.scrollEventsEnabled )
	{
		[self.scrollView sendSignal:UIScrollView.eventWillBeginZooming];
	}
}

// scale between minimum and maximum. called after any 'bounce' animations
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
	if ( self.scrollEventsEnabled )
	{
		[self.scrollView sendSignal:UIScrollView.eventDidEndZooming];
	}
}

// return a yes if you want to scroll to the top. if not defined, assumes YES
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
	return YES;
}

// called when scrolling animation finished. may be called immediately if already at top
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
	if ( self.scrollEventsEnabled )
	{
		[self.scrollView sendSignal:UIScrollView.eventDidScrollToTop];
	}
}

@end

#pragma mark -

@implementation UIScrollView(Samurai)

@def_signal( eventDidScroll );
@def_signal( eventDidZoom );

@def_signal( eventWillBeginDragging );
@def_signal( eventWillEndDragging );
@def_signal( eventDidEndDragging );

@def_signal( eventWillBeginDecelerating );
@def_signal( eventDidEndDecelerating );
@def_signal( eventDidEndScrolling );

@def_signal( eventWillBeginZooming );
@def_signal( eventDidEndZooming );
@def_signal( eventDidScrollToTop );

#pragma mark -

+ (id)createInstanceWithRenderer:(SamuraiRenderObject *)renderer identifier:(NSString *)identifier
{
	UIScrollView * scrollView = [[self alloc] initWithFrame:CGRectZero];
	
	scrollView.renderer = renderer;
	[scrollView scrollViewAgent];
	
	return scrollView;
}

#pragma mark -

- (SamuraiUIScrollViewAgent *)scrollViewAgent
{
	SamuraiUIScrollViewAgent * agent = [self getAssociatedObjectForKey:"UIScrollView.agent"];
	
	if ( nil == agent )
	{
		agent = [[SamuraiUIScrollViewAgent alloc] init];
		agent.scrollView = self;

		self.delegate = agent;

		[self retainAssociatedObject:agent forKey:"UIScrollView.agent"];
	}
	
	return agent;
}

#pragma mark -

+ (BOOL)supportTapGesture
{
	return YES;
}

+ (BOOL)supportSwipeGesture
{
	return YES;
}

+ (BOOL)supportPinchGesture
{
	return YES;
}

+ (BOOL)supportPanGesture
{
	return YES;
}

#pragma mark -

- (id)serialize
{
	return nil;
}

- (void)unserialize:(id)obj
{
}

- (void)zerolize
{
}

#pragma mark -

- (void)applyDom:(SamuraiDomNode *)dom
{
	[super applyDom:dom];
}

- (void)applyStyle:(SamuraiRenderStyle *)style
{
	[super applyStyle:style];
}

- (void)applyFrame:(CGRect)frame
{
	[super applyFrame:frame];
}

#pragma mark -

- (CGSize)computeSizeBySize:(CGSize)size
{
	return [super computeSizeBySize:size];
}

- (CGSize)computeSizeByWidth:(CGFloat)width
{
	return [super computeSizeByWidth:width];
}

- (CGSize)computeSizeByHeight:(CGFloat)height
{
	return [super computeSizeByHeight:height];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, UIScrollView )

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
