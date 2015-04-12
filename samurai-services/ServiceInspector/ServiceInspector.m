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

#import "ServiceInspector.h"
#import "ServiceInspectorWindow.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation ServiceInspector
{
	ServiceInspectorWindow * _window;
}

- (void)install
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didApplicationLaunched)
												 name:UIApplicationDidFinishLaunchingNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(willApplicationTerminate)
												 name:UIApplicationWillTerminateNotification
											   object:nil];
}

- (void)uninstall
{
	_window = nil;

	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -

- (void)powerOn
{
}

- (void)powerOff
{
}

#pragma mark -

- (void)didApplicationLaunched
{
	if ( nil == _window )
	{
		_window = [[ServiceInspectorWindow alloc] init];
		_window.hidden = YES;
	}
}

- (void)willApplicationTerminate
{
	_window = nil;
}

#pragma mark -

- (void)didDockerOpen
{
	[_window show];
}

- (void)didDockerClose
{
	[_window hide];
}

@end
