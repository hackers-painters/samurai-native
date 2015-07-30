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

#import "Samurai_ActivityStackGroup.h"
#import "Samurai_Intent.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation UIWindow(ActivityStackGroup)

@def_prop_dynamic( SamuraiActivityStackGroup *, rootStackGroup );

- (SamuraiActivityStackGroup *)rootStackGroup
{
	if ( self.rootViewController && [self.rootViewController isKindOfClass:[SamuraiActivityStackGroup class]] )
	{
		return (SamuraiActivityStackGroup *)self.rootViewController;
	}
	
	return nil;
}

- (void)setRootStackGroup:(SamuraiActivityStackGroup *)group
{
	self.rootViewController = group;
}

@end

#pragma mark -

@interface SamuraiActivityStackGroupItem : NSObject

@prop_assign( NSUInteger,				order );
@prop_strong( NSString *,				name );
@prop_strong( UIViewController *,		instance );
@prop_strong( Class,					classType );

- (id)createInstance;

@end

#pragma mark -

@implementation SamuraiActivityStackGroupItem

@def_prop_assign( NSUInteger,			order );
@def_prop_strong( NSString *,			name );
@def_prop_strong( UIViewController *,	instance );
@def_prop_strong( Class,				classType );

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
	self.name = nil;
	self.instance = nil;
	self.classType = nil;
}

- (id)createInstance
{
	if ( nil == self.instance )
	{
		self.instance = [[self.classType alloc] init];
	}
	return self.instance;
}

@end

#pragma mark -

@implementation SamuraiActivityStackGroup
{
	NSString *				_name;
	NSMutableDictionary *	_mapping;
}

BASE_CLASS( SamuraiActivityStackGroup )

@def_prop_dynamic( SamuraiActivity *,		activity );
@def_prop_dynamic( SamuraiActivityStack *,	stack );

+ (SamuraiActivityStackGroup *)stackGroup
{
	return [[self alloc] init];
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		_name = nil;
		_mapping = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)dealloc
{
	_name = nil;
	
	[_mapping removeAllObjects];
	_mapping = nil;
}

#pragma mark -

- (SamuraiActivity *)activity
{
	if ( nil == _name )
		return nil;
	
	SamuraiActivityStackGroupItem * item = [_mapping objectForKey:_name];
	if ( nil == item || nil == item.instance )
		return nil;
	
	if ( NO == [item.instance isKindOfClass:[SamuraiActivity class]] )
		return nil;
	
	return (SamuraiActivity *)item.instance;
}

- (SamuraiActivityStack *)stack
{
	if ( nil == _name )
		return nil;
	
	SamuraiActivityStackGroupItem * item = [_mapping objectForKey:_name];
	if ( nil == item || nil == item.instance )
		return nil;
	
	if ( NO == [item.instance isKindOfClass:[SamuraiActivityStack class]] )
		return nil;

	return (SamuraiActivityStack *)item.instance;
}

#pragma mark -

- (void)map:(NSString *)name forClass:(Class)classType
{
	INFO( @"StackGroup '%p', map '%@'", self, name );
	
	if ( nil == name || nil == classType )
		return;
	
	SamuraiActivityStackGroupItem * item = [_mapping objectForKey:name];
	if ( nil == item )
	{
		item = [[SamuraiActivityStackGroupItem alloc] init];

		item.order = _mapping.count;
		item.name = name;
		item.classType = classType;

		[_mapping setObject:item forKey:name];
	}
}

- (void)map:(NSString *)name forActivity:(SamuraiActivity *)activity
{
	INFO( @"StackGroup '%p', map '%@'", self, name );
	
	if ( nil == name || nil == activity )
		return;
	
	SamuraiActivityStackGroupItem * item = [_mapping objectForKey:name];
	if ( nil == item )
	{
		item = [[SamuraiActivityStackGroupItem alloc] init];
		
		item.order = _mapping.count;
		item.name = name;
		item.instance = activity;
		
		[_mapping setObject:item forKey:name];
	}
}

- (void)map:(NSString *)name forActivityStack:(SamuraiActivityStack *)activityStack
{
	INFO( @"StackGroup '%p', map '%@'", self, name );
	
	if ( nil == name || nil == activityStack )
		return;
	
	SamuraiActivityStackGroupItem * item = [_mapping objectForKey:name];
	if ( nil == item )
	{
		item = [[SamuraiActivityStackGroupItem alloc] init];
		
		item.order = _mapping.count;
		item.name = name;
		item.instance = activityStack;

		[_mapping setObject:item forKey:name];
	}
}

- (BOOL)open:(NSString *)name
{
	INFO( @"StackGroup '%p', open '%@'", self, name );
	
	if ( 0 == name.length )
		return NO;

	if ( _name && [_name isEqualToString:name] )
		return NO;

	SamuraiActivityStackGroupItem * prevItem = _name ? [_mapping objectForKey:_name] : nil;
	SamuraiActivityStackGroupItem * currItem = [_mapping objectForKey:name];

	if ( prevItem == currItem )
		return NO;

	CATransition * transition = [CATransition animation];
	[transition setDuration:0.3f];
	[transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
	[transition setType:kCATransitionFade];
	[self.view.layer addAnimation:transition forKey:nil];

	for ( SamuraiActivityStackGroupItem * item in _mapping.allValues )
	{
		if ( NO == [item.name isEqualToString:name] )
		{
			UIViewController * controller = (UIViewController *)item.instance;
			if ( controller )
			{
				[controller.view setHidden:YES];
			}
		}
	}

//	if ( prevItem )
//	{
//		UIViewController * prevController = (UIViewController *)prevItem.instance;
//		if ( prevController )
//		{
//			[prevController viewWillDisappear:NO];
//			[prevController viewDidDisappear:NO];
//		}
//	}

	_name = name;

	if ( currItem )
	{
		UIViewController * currController = (UIViewController *)[currItem createInstance];
		if ( currController )
		{
			if ( currController.view != self.view )
			{
//				[currController.view removeFromSuperview];
				[self.view addSubview:currController.view];
			}
			
//			[currController viewWillAppear:NO];
//			[currController viewDidAppear:NO];
		}
	}
	
//	[self viewWillAppear:NO];
//	[self viewDidAppear:NO];
	
	return YES;
}

#pragma mark -

- (void)setView:(UIView *)newView
{
	[super setView:newView];
	
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

- (void)loadView
{
	[super loadView];
	
	self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	for ( SamuraiActivityStackGroupItem * item in _mapping.allValues )
	{
		UIViewController * controller = (UIViewController *)item.instance;
		if ( controller )
		{
			controller.view.frame = self.view.bounds;
			[controller willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
		}
	}
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
	
	for ( SamuraiActivityStackGroupItem * item in _mapping.allValues )
	{
		UIViewController * controller = (UIViewController *)item.instance;
		if ( controller && [controller isViewLoaded] )
		{
			controller.view.frame = self.view.bounds;
			[controller viewDidLayoutSubviews];
		}
	}
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	for ( SamuraiActivityStackGroupItem * item in _mapping.allValues )
	{
		UIViewController * controller = (UIViewController *)item.instance;
		if ( controller && [controller isViewLoaded] )
		{
			[controller viewWillAppear:animated];
		}
	}
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	for ( SamuraiActivityStackGroupItem * item in _mapping.allValues )
	{
		UIViewController * controller = (UIViewController *)item.instance;
		if ( controller && [controller isViewLoaded] )
		{
			[controller viewDidAppear:animated];
		}
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	for ( SamuraiActivityStackGroupItem * item in _mapping.allValues )
	{
		UIViewController * controller = (UIViewController *)item.instance;
		if ( controller && [controller isViewLoaded] )
		{
			[controller viewWillDisappear:animated];
		}
	}
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	for ( SamuraiActivityStackGroupItem * item in _mapping.allValues )
	{
		UIViewController * controller = (UIViewController *)item.instance;
		if ( controller && [controller isViewLoaded] )
		{
			[controller viewDidDisappear:animated];
		}
	}
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, ActivityStackGroup )

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
