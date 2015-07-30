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

#import "BaseActivity.h"
#import "ThemeConfig.h"

#pragma mark -

@implementation BaseActivity
{
	BOOL			_themeChanged;
	MBProgressHUD *	_hud;
	MBProgressHUD *	_error;
}

- (void)onCreate
{
	[self observeNotification:ThemeConfig.ThemeWillChange];
	[self observeNotification:ThemeConfig.ThemeDidChanged];

	[self reloadTemplate];
}

- (void)onDestroy
{
	[self hideLoading];

	[self unloadTemplate];
	[self unobserveAllNotifications];
}

- (void)onStart
{
	if ( _themeChanged )
	{
		[self reloadTemplate];
		
		_themeChanged = NO;
	}
}

- (void)onResume
{
	[self relayout];
}

- (void)onPause
{
}

- (void)onStop
{
}

- (void)onLayout
{
	[self relayout];
}

#pragma mark -

- (void)onBackPressed
{
	
}

- (void)onDonePressed
{
}

#pragma mark -

- (void)onTemplateLoading
{
}

- (void)onTemplateLoaded
{
}

- (void)onTemplateFailed
{
}

- (void)onTemplateCancelled
{
}

#pragma mark -

- (void)showLoading
{
	if ( nil == _hud )
	{
		_hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
		_hud.labelText = @"Loading...";
		_hud.delegate = self;
		_hud.removeFromSuperViewOnHide = YES;
		
		[self.navigationController.view addSubview:_hud];
		
		[_hud show:YES];
	}
}

- (void)hideLoading
{
	if ( _hud )
	{
		[_hud hide:YES];
		_hud = nil;
	}
}

#pragma mark -

- (NSString *)templateName
{
	return nil;
}

- (void)reloadTemplate
{
	[self unloadTemplate];
	
	NSString * theme = [ThemeConfig sharedInstance].theme;
	NSString * name = [self templateName];
	NSString * path = [NSString stringWithFormat:@"/www/html/%@/%@", theme, name];
	
	[self loadTemplate:path];
}

#pragma mark -

handleNotification( ThemeConfig, ThemeWillChange )
{
	
}

handleNotification( ThemeConfig, ThemeDidChanged )
{
	if ( self.activated )
	{
		_themeChanged = NO;
		
		[self reloadTemplate];
	}
	else
	{
		_themeChanged = YES;
	}
}

@end
