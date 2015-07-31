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

#import "Samurai_DockerWindow.h"

#import "_pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiDockerWindow

- (id)init
{
	self = [super init];
	if ( self )
	{
	//	self.alpha = 0.75f;
		self.backgroundColor = [UIColor clearColor];
		self.windowLevel = UIWindowLevelStatusBar + 2.0f;
        self.rootViewController = [[UIViewController alloc] init];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(orientationWillChange)
													 name:UIApplicationWillChangeStatusBarOrientationNotification
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(orientationDidChanged)
													 name:UIApplicationDidChangeStatusBarOrientationNotification
												   object:nil];
	}
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addDockerView:(SamuraiDockerView *)docker
{
	[self addSubview:docker];
}

- (void)removeDockerView:(SamuraiDockerView *)docker
{
	if ( docker.superview == self )
	{
		[docker removeFromSuperview];
	}
}

- (void)removeAllDockerViews
{
	// TODO:
}

- (void)relayoutAllDockerViews
{
	NSMutableArray * dockerViews = [NSMutableArray nonRetainingArray];
	
	for ( UIView * subview in self.subviews )
	{
		if ( [subview isKindOfClass:[SamuraiDockerView class]] )
		{
			[dockerViews addObject:subview];
		}
	}
	
#define DOCKER_RIGHT	10.0f
#define DOCKER_BOTTOM	64.0f
#define DOCKER_MARGIN	4.0f
#define DOCKER_HEIGHT	30.0f
	
	CGRect windowBound;
	windowBound.size.width = DOCKER_HEIGHT;
	windowBound.size.height = dockerViews.count * (DOCKER_HEIGHT + DOCKER_MARGIN);
	windowBound.origin.x = [UIScreen mainScreen].bounds.size.width - windowBound.size.width - DOCKER_RIGHT;
	windowBound.origin.y = [UIScreen mainScreen].bounds.size.height - windowBound.size.height - DOCKER_BOTTOM;
	self.frame = windowBound;

	for ( SamuraiDockerView * dockerView in dockerViews )
	{
		CGRect dockerFrame;
		dockerFrame.size.width = DOCKER_HEIGHT;
		dockerFrame.size.height = DOCKER_HEIGHT;
		dockerFrame.origin.x = 0.0f;
		dockerFrame.origin.y = (DOCKER_HEIGHT + DOCKER_MARGIN) * [dockerViews indexOfObject:dockerView];
		dockerView.frame = dockerFrame;
	}
}

- (void)setFrame:(CGRect)newFrame
{
	[super setFrame:newFrame];
}

- (void)orientationWillChange
{
	[self relayoutAllDockerViews];
}

- (void)orientationDidChanged
{
	[self relayoutAllDockerViews];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( Service, DockerWindow )

DESCRIBE( before )
{
}

DESCRIBE( after )
{
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#import "_pragma_pop.h"
