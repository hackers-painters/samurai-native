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

#import "ServiceMonitor.h"
#import "ServiceMonitorStatusBar.h"

#import "ServiceMonitorCPUModel.h"
#import "ServiceMonitorMemoryModel.h"
#import "ServiceMonitorNetworkModel.h"
#import "ServiceMonitorFPSModel.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation ServiceMonitor
{
	NSTimer *						_timer;
	ServiceMonitorCPUModel *		_model1;
	ServiceMonitorMemoryModel *		_model2;
	ServiceMonitorNetworkModel *	_model3;
	ServiceMonitorFPSModel *		_model4;
	ServiceMonitorStatusBar *		_bar;
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
	
	_model1 = [ServiceMonitorCPUModel sharedInstance];
	_model2 = [ServiceMonitorMemoryModel sharedInstance];
	_model3 = [ServiceMonitorNetworkModel sharedInstance];
	_model4 = [ServiceMonitorFPSModel sharedInstance];

	_timer = [NSTimer scheduledTimerWithTimeInterval:1.0f / 10.0f
											  target:self
											selector:@selector(didTimeout)
											userInfo:nil
											 repeats:YES];
	
	[[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)uninstall
{
	_bar = nil;
	_model1 = nil;
	_model2 = nil;
	_model3 = nil;
	_model4 = nil;

	[_timer invalidate];
	_timer = nil;

	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)powerOn
{
}

- (void)powerOff
{
}

#pragma mark -

- (void)didApplicationLaunched
{
	_bar = [[ServiceMonitorStatusBar alloc] init];
	[_bar show];
}

- (void)willApplicationTerminate
{
	_bar = nil;
}

- (void)didTimeout
{
	[_model1 update];
	[_model2 update];
	[_model3 update];
	[_model4 update];

	[_bar update];
}

@end
