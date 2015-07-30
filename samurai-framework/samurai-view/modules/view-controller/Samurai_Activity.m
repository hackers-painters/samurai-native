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

#import "Samurai_Activity.h"
#import "Samurai_Intent.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation UIWindow(Activity)

@def_prop_dynamic( SamuraiActivity *, rootActivity );

- (SamuraiActivity *)rootActivity
{
	if ( self.rootViewController && [self.rootViewController isKindOfClass:[SamuraiActivity class]] )
	{
		return (SamuraiActivity *)self.rootViewController;
	}
	
	return nil;
}

- (void)setRootActivity:(SamuraiActivity *)activity
{
	self.rootViewController = activity;
}

@end

#pragma mark -

@implementation SamuraiActivity
{
	BOOL	_inited;
	BOOL	_booted;
	BOOL	_presented;
	BOOL	_viewBuilt;
	BOOL	_viewDirty;
}

BASE_CLASS( SamuraiActivity )

@def_joint( stateChanged );

@def_prop_strong( SamuraiIntent *,				intent );
@def_prop_assign( BOOL,							animated );
@def_prop_assign( UIInterfaceOrientation,		orientation );
@def_prop_assign( UIInterfaceOrientationMask,	orientationMask );

@def_prop_copy( BlockType,						stateChanged );
@def_prop_assign( ActivityState,				state );
@def_prop_dynamic( BOOL,						created );
@def_prop_dynamic( BOOL,						deactivated );
@def_prop_dynamic( BOOL,						deactivating );
@def_prop_dynamic( BOOL,						activating );
@def_prop_dynamic( BOOL,						activated );
@def_prop_dynamic( BOOL,						destroyed );

static NSMutableArray * __activities = nil;

#pragma mark -

+ (instancetype)activity
{
	return [[[self class] alloc] init];
}

+ (instancetype)activityWithNibName:(NSString *)nibNameOrNil
{
	return [[self alloc] initWithNibName:nibNameOrNil bundle:nil];
}

+ (instancetype)activityWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	return [[self alloc] initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

#pragma mark -

+ (NSArray *)activities
{
	return __activities;
}

#pragma mark -

- (void)initSelf
{
	if ( NO == _inited )
	{
		if ( nil == __activities )
		{
			__activities = [NSMutableArray nonRetainingArray];
		}
		
		[__activities addObject:self];
		
		self.title = [[self class] description];
		
		_state = ActivityState_Inited;
		_orientation = [UIApplication sharedApplication].statusBarOrientation;
		_orientationMask = UIInterfaceOrientationMaskPortrait;
		
		_inited = YES;
	}
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		[self initSelf];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder // Support story board
{
	self = [super initWithCoder:aDecoder];
	if ( self )
	{
		[self initSelf];
	}
	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil // Support interface builder
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if ( self )
	{
		[self initSelf];
	}
	return self;
}

- (void)dealloc
{
	if ( _viewBuilt )
	{
		[self changeState:ActivityState_Destroyed];

		@autoreleasepool
		{
			NSArray * array = [self.view.subviews copy];
			
			for ( UIView * view in array )
			{
				[view removeFromSuperview];
			}
		}

	// BUG, will create a new view when dealloc
	//	self.view = nil;

		_viewBuilt = NO;
	}

	self.intent = nil;
	self.stateChanged = nil;
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	
	[__activities removeObject:self];
}

#pragma mark -

- (void)changeState:(ActivityState)newState
{
//	static const char * __states[] = {
//		"!Inited",
//		"!Created",
//		"!Activating",
//		"!Activated",
//		"!Deactivating",
//		"!Deactivated",
//		"!Destroyed"
//	};

	if ( _state == newState )
		return;

	PERF( @"Activity '%p', '%@' state %d -> %d", self, [[self class] description], _state, newState );
	
	_state = newState;
	
	triggerBefore( self, stateChanged );
	
	if ( self.stateChanged )
	{
		((BlockTypeVarg)self.stateChanged)( self );
	}

	if ( ActivityState_Created == _state )
	{
	#if __SAMURAI_UI_USE_CALLCHAIN__
		[self performCallChainWithSelector:@selector(onCreate) reversed:YES];
	#else	// #if __SAMURAI_UI_USE_CALLCHAIN__
		[self onCreate];
	#endif	// #if __SAMURAI_UI_USE_CALLCHAIN__
	}
	else if ( ActivityState_Activating == _state )
	{
	#if __SAMURAI_UI_USE_CALLCHAIN__
		[self performCallChainWithSelector:@selector(onStart) reversed:YES];
	#else	// #if __SAMURAI_UI_USE_CALLCHAIN__
		[self onStart];
	#endif	// #if __SAMURAI_UI_USE_CALLCHAIN__
	}
	else if ( ActivityState_Activated == _state )
	{
	#if __SAMURAI_UI_USE_CALLCHAIN__
		[self performCallChainWithSelector:@selector(onResume) reversed:YES];
	#else	// #if __SAMURAI_UI_USE_CALLCHAIN__
		[self onResume];
	#endif	// #if __SAMURAI_UI_USE_CALLCHAIN__
	}
	else if ( ActivityState_Deactivating == _state )
	{
	#if __SAMURAI_UI_USE_CALLCHAIN__
		[self performCallChainWithSelector:@selector(onPause) reversed:YES];
	#else	// #if __SAMURAI_UI_USE_CALLCHAIN__
		[self onPause];
	#endif	// #if __SAMURAI_UI_USE_CALLCHAIN__
	}
	else if ( ActivityState_Deactivated == _state )
	{
	#if __SAMURAI_UI_USE_CALLCHAIN__
		[self performCallChainWithSelector:@selector(onStop) reversed:YES];
	#else	// #if __SAMURAI_UI_USE_CALLCHAIN__
		[self onStop];
	#endif	// #if __SAMURAI_UI_USE_CALLCHAIN__
	}
	else if ( ActivityState_Destroyed == _state )
	{
	#if __SAMURAI_UI_USE_CALLCHAIN__
		[self performCallChainWithSelector:@selector(onDestroy) reversed:NO];
	#else	// #if __SAMURAI_UI_USE_CALLCHAIN__
		[self onDestroy];
	#endif	// #if __SAMURAI_UI_USE_CALLCHAIN__
	}

	triggerAfter( self, stateChanged );
}

- (BOOL)created
{
	return ActivityState_Created == _state ? YES : NO;
}

- (BOOL)activating
{
	return ActivityState_Activating == _state ? YES : NO;
}

- (BOOL)activated
{
	return ActivityState_Activated == _state ? YES : NO;
}

- (BOOL)deactivating
{
	return ActivityState_Deactivating == _state ? YES : NO;
}

- (BOOL)deactivated
{
	return ActivityState_Deactivated == _state ? YES : NO;
}

- (BOOL)destroyed
{
	return ActivityState_Destroyed == _state ? YES : NO;
}

#pragma mark -

- (void)setView:(UIView *)newView
{
	[super setView:newView];
	
	if ( newView )
	{
		if ( IOS7_OR_LATER )
		{
			self.edgesForExtendedLayout = UIRectEdgeNone;
			self.extendedLayoutIncludesOpaqueBars = NO;
			self.modalPresentationCapturesStatusBarAppearance = NO;
			self.automaticallyAdjustsScrollViewInsets = YES;
		}
		
		self.view.userInteractionEnabled = YES;
		self.view.backgroundColor = [UIColor whiteColor];
		self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;	
	}
}

- (void)loadView
{
	PERF( @"Activity '%p', '%@' loadView", self, [[self class] description] );

	[super loadView];

	if ( NO == _viewBuilt )
	{
		[self changeState:ActivityState_Created];
		
		_viewDirty = YES;
		_viewBuilt = YES;
	}
}

- (void)viewDidLoad
{
	PERF( @"Activity '%p', '%@' viewDidLoad", self, [[self class] description] );

	[super viewDidLoad];
	
	if ( NO == _booted )
	{
		if ( self.intent )
		{
			self.intent.target = self;
			self.intent.arrived = YES;
		}
		
		_booted = YES;
	}
}

- (void)viewDidUnload
{
	PERF( @"Activity '%p', '%@' viewDidUnload", self, [[self class] description] );

	if ( _viewBuilt )
	{
		[self changeState:ActivityState_Destroyed];

		@autoreleasepool
		{
			NSArray * array = [self.view.subviews copy];
			
			for ( UIView * view in array )
			{
				[view removeFromSuperview];
			}
		}
		
		_viewBuilt = NO;
	}

	self.view = nil;

    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
	PERF( @"Activity '%p', '%@' didReceiveMemoryWarning", self, [[self class] description] );
	
	[super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
	if ( self.state == ActivityState_Activating )
		return;

	PERF( @"Activity '%p', '%@' viewWillAppear", self, [[self class] description] );
	
	[super viewWillAppear:animated];

	if ( NO == _viewBuilt )
	{
		[self changeState:ActivityState_Created];

		_viewBuilt = YES;
	}

	if ( self.view )
	{
		[self.view addSignalResponder:self];
	}

	_viewDirty = YES;
	
	_animated = animated;
	
	[self changeState:ActivityState_Activating];

	_animated = NO;
	
	[self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidAppear:(BOOL)animated
{
	if ( self.state == ActivityState_Activated )
		return;
	
	PERF( @"Activity '%p', '%@' viewDidAppear", self, [[self class] description] );
	
	[super viewDidAppear:animated];

	_animated = animated;
	
	[self changeState:ActivityState_Activated];

	_animated = NO;
	_presented = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
	if ( self.state == ActivityState_Deactivating )
		return;

	PERF( @"Activity '%p', '%@' viewWillDisappear", self, [[self class] description] );
	
	[super viewWillDisappear:animated];

	_animated = animated;
	
	[self changeState:ActivityState_Deactivating];
	
	_animated = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
	if ( self.state == ActivityState_Deactivated )
		return;

	PERF( @"Activity '%p', '%@' viewDidDisappear", self, [[self class] description] );
	
	[super viewDidDisappear:animated];

	_animated = animated;
	
	[self changeState:ActivityState_Deactivated];

	_animated = NO;
}

- (void)viewWillLayoutSubviews
{
	PERF( @"Activity '%p', '%@' viewWillLayoutSubviews", self, [[self class] description] );

	[super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews
{
//	if ( self.state != ActivityState_Activated )
//		return;

	PERF( @"Activity '%p', '%@' viewDidLayoutSubviews", self, [[self class] description] );

	[super viewDidLayoutSubviews];
	
	if ( _viewDirty )
	{
		_animated = YES;

	#if __SAMURAI_UI_USE_CALLCHAIN__
		[self performCallChainWithSelector:@selector(onLayout) reversed:YES];
	#else	// #if __SAMURAI_UI_USE_CALLCHAIN__
		[self onLayout];
	#endif	// #if __SAMURAI_UI_USE_CALLCHAIN__
		
		_animated = NO;
		
		_viewDirty = NO;
	}
}

#pragma mark -

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (_orientationMask & (1 << interfaceOrientation)) ? YES : NO;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	_viewDirty = YES;
	_orientation = toInterfaceOrientation;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
	return _orientationMask;
}

- (BOOL)shouldAutorotate
{
	return YES;
}

#pragma mark -

- (BOOL)prefersStatusBarHidden
{
	return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleLightContent;
}

#pragma mark -

- (void)onCreate
{
}

- (void)onDestroy
{
}

- (void)onStart
{
}

- (void)onResume
{
}

- (void)onLayout
{
}

- (void)onPause
{
}

- (void)onStop
{
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, Activity )

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
