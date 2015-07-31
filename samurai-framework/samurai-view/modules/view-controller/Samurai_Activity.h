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

#pragma mark -

@class SamuraiActivity;
@class SamuraiIntent;

@interface UIWindow(Activity)

@prop_strong( SamuraiActivity *, rootActivity );

@end

#pragma mark -

#undef	activity
#define	activity( __name, ... ) \
		interface __name : SamuraiActivity< __VA_ARGS__ > \
		@end \
		@implementation __name

#undef	activity_extend
#define	activity_extend( __name, __parent, ... ) \
		interface __name : __parent< __VA_ARGS__ > \
		@end \
		@implementation __name

#pragma mark -

typedef enum
{
	ActivityState_Inited = 0,
	ActivityState_Created,
	ActivityState_Activating,
	ActivityState_Activated,
	ActivityState_Deactivating,
	ActivityState_Deactivated,
	ActivityState_Destroyed
} ActivityState;

#pragma mark -

@interface SamuraiActivity : UIViewController

@joint( stateChanged );

@prop_strong( SamuraiIntent *,				intent );
@prop_assign( BOOL,							animated );
@prop_assign( UIInterfaceOrientation,		orientation );
@prop_assign( UIInterfaceOrientationMask,	orientationMask );

@prop_copy( BlockType,						stateChanged );
@prop_assign( ActivityState,				state );
@prop_readonly( BOOL,						created );
@prop_readonly( BOOL,						deactivated );
@prop_readonly( BOOL,						deactivating );
@prop_readonly( BOOL,						activating );
@prop_readonly( BOOL,						activated );
@prop_readonly( BOOL,						destroyed );

+ (instancetype)activity;
+ (instancetype)activityWithNibName:(NSString *)nibNameOrNil;
+ (instancetype)activityWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

+ (NSArray *)activities;

- (void)changeState:(ActivityState)value;

- (void)onCreate;	// override point
- (void)onDestroy;	// override point
- (void)onStart;	// override point
- (void)onResume;	// override point
- (void)onLayout;	// override point
- (void)onPause;	// override point
- (void)onStop;		// override point

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
