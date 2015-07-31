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

#import "Samurai_Core.h"
#import "Samurai_Event.h"
#import "Samurai_ViewConfig.h"

#import "Samurai_ViewCore.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_Activity.h"

#pragma mark -

@class SamuraiActivityStack;

@interface UIWindow(ActivityStack)

@prop_strong( SamuraiActivityStack *,	rootStack );

@end

#pragma mark -

typedef void (^ IntentCallback )( SamuraiIntent * intent );

#pragma mark -

@interface UIViewController(ActivityStack)

- (SamuraiActivityStack *)stack;

- (void)startActivity:(SamuraiActivity *)activity;
- (void)startActivity:(SamuraiActivity *)activity params:(NSDictionary *)params;
- (void)startActivity:(SamuraiActivity *)activity intent:(SamuraiIntent *)intent;

- (void)presentActivity:(SamuraiActivity *)activity;
- (void)presentActivity:(SamuraiActivity *)activity params:(NSDictionary *)params;
- (void)presentActivity:(SamuraiActivity *)activity intent:(SamuraiIntent *)intent;

- (void)startURL:(NSString *)url, ...;
- (void)startURL:(NSString *)url params:(NSDictionary *)params;
- (void)startURL:(NSString *)url intent:(SamuraiIntent *)intent;
- (void)startURL:(NSString *)url callback:(IntentCallback)callback;

- (void)presentURL:(NSString *)url, ...;
- (void)presentURL:(NSString *)url params:(NSDictionary *)params;
- (void)presentURL:(NSString *)url intent:(SamuraiIntent *)intent;
- (void)presentURL:(NSString *)url callback:(IntentCallback)callback;

@end

#pragma mark -

@interface SamuraiActivityStack : UINavigationController

@prop_readonly( NSArray *,			activities );
@prop_readonly( SamuraiActivity *,	activity );

+ (SamuraiActivityStack *)stack;
+ (SamuraiActivityStack *)stackWithActivity:(SamuraiActivity *)activity;

- (SamuraiActivityStack *)initWithActivity:(SamuraiActivity *)activity;

- (void)pushActivity:(SamuraiActivity *)activity animated:(BOOL)animated;
- (void)popActivityAnimated:(BOOL)animated;
- (void)popToActivity:(SamuraiActivity *)activity animated:(BOOL)animated;
- (void)popToFirstActivityAnimated:(BOOL)animated;
- (void)popAllActivities;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
