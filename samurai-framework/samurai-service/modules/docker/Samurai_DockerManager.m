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

#import "Samurai_DockerManager.h"
#import "Samurai_DockerView.h"
#import "Samurai_DockerWindow.h"

#import "_pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiService(Docker)

- (void)openDocker
{
	if ( [self conformsToProtocol:@protocol(ManagedDocker)] )
	{
		[[SamuraiDockerManager sharedInstance] openDockerForService:(SamuraiService<ManagedDocker> *)self];
	}
}

- (void)closeDocker
{
	if ( [self conformsToProtocol:@protocol(ManagedDocker)] )
	{
		[[SamuraiDockerManager sharedInstance] closeDockerForService:(SamuraiService<ManagedDocker> *)self];
	}
}

@end

#pragma mark -

@implementation SamuraiDockerManager
{
	SamuraiDockerWindow * _dockerWindow;
}

@def_singleton( SamuraiDockerManager )

- (id)init
{
	self = [super init];
	if ( self )
	{
	}
	return self;
}

- (void)dealloc
{
	_dockerWindow = nil;
}

- (void)installDockers
{
	NSArray * services = [SamuraiServiceLoader sharedInstance].services;
	
	for ( SamuraiService * service in services )
	{
		if ( [service conformsToProtocol:@protocol(ManagedDocker)] )
		{
			SamuraiDockerView * dockerView = [[SamuraiDockerView alloc] init];
			[dockerView setImageOpened:[service.bundle imageForResource:@"docker-open.png"]];
			[dockerView setImageClosed:[service.bundle imageForResource:@"docker-close.png"]];
			[dockerView setService:(SamuraiService<ManagedDocker> *)service];
            
            if ( nil == _dockerWindow )
            {
                _dockerWindow = [[SamuraiDockerWindow alloc] init];
                _dockerWindow.alpha = 0.0f;
                _dockerWindow.hidden = NO;
            }
            
			[_dockerWindow addDockerView:dockerView];
		}
	}

    if ( _dockerWindow )
    {
        [_dockerWindow relayoutAllDockerViews];
    //	[_dockerWindow setHidden:NO];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];

        _dockerWindow.alpha = 1.0f;

        [UIView commitAnimations];
    }
}

- (void)uninstallDockers
{
	_dockerWindow = nil;
}

- (void)openDockerForService:(SamuraiService<ManagedDocker> *)service
{
	for ( UIView * subview in _dockerWindow.subviews )
	{
		if ( [subview isKindOfClass:[SamuraiDockerView class]] )
		{
			SamuraiDockerView * dockerView = (SamuraiDockerView *)subview;
			if ( dockerView.service == service )
			{
				[dockerView open];
			}
		}
	}
}

- (void)closeDockerForService:(SamuraiService<ManagedDocker> *)service
{
	for ( UIView * subview in _dockerWindow.subviews )
	{
		if ( [subview isKindOfClass:[SamuraiDockerView class]] )
		{
			SamuraiDockerView * dockerView = (SamuraiDockerView *)subview;
			if ( dockerView.service == service )
			{
				[dockerView close];
			}
		}
	}
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( Service, DockerManager )

DESCRIBE( before )
{
}

DESCRIBE( after )
{
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#import "_pragma_pop.h"
