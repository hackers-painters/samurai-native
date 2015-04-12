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

#import "DribbbleApp.h"

#import "model.h"
#import "view.h"
#import "view-controller.h"

#pragma mark -

@implementation DribbbleApp

- (void)load
{
}

- (void)unload
{
}

- (void)main
{
	if ( [UINavigationBar instancesRespondToSelector:@selector(setShadowImage:)] )
	{
		CGRect rect = CGRectMake( 0, 0, [UIScreen mainScreen].bounds.size.width, 1.0f );
		
		UIGraphicsBeginImageContext(rect.size);
		
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		CGContextSetFillColorWithColor( context, [[UIColor clearColor] CGColor] );
		CGContextFillRect( context, rect );
		
		UIImage * shadowImage = UIGraphicsGetImageFromCurrentImageContext();
		
		UIGraphicsEndImageContext();
		
		[[UINavigationBar appearance] setShadowImage:shadowImage];
	}
	
	UINavigationBar * navigationBar = self.window.rootStack.navigationBar;
	
	[navigationBar setTintColor:[UIColor whiteColor]];
	[navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor whiteColor] }];
	[navigationBar setBackgroundColor:[UIColor whiteColor]];
	[navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar.png"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];

//	[self.window.rootStackGroup open:@"tab1"];
}

@end
