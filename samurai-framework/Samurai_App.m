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

#import "Samurai_App.h"
#import "Samurai_ClassLoader.h"
#import "Samurai_Service.h"
#import "Samurai_Vendor.h"

#import "Samurai_Activity.h"
#import "Samurai_ActivityRouter.h"
#import "Samurai_ActivityStack.h"
#import "Samurai_ActivityStackGroup.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

static __strong id __applicationInstance = nil;

#pragma mark -

@implementation SamuraiApp

@def_notification( PushEnabled )
@def_notification( PushError )

@def_notification( LocalNotification )
@def_notification( RemoteNotification )

@def_notification( EnterBackground );
@def_notification( EnterForeground );

@def_notification( Ready )

@def_prop_strong( UIWindow *,			window );
@def_prop_strong( NSString *,			pushToken );
@def_prop_strong( NSError *,			pushError );
@def_prop_strong( NSString *,			sourceUrl );
@def_prop_strong( NSString *,			sourceBundleId );

@def_prop_dynamic( BOOL,				active );
@def_prop_dynamic( BOOL,				inactive );
@def_prop_dynamic( BOOL,				background );

#pragma mark -

+ (instancetype)sharedInstance
{
	return __applicationInstance;
}

- (instancetype)sharedInstance
{
	return __applicationInstance;
}

#pragma mark -

- (id)init
{
	self = [super init];
	if ( self )
	{
		[self load];
	}
	return self;
}

- (void)dealloc
{
	[self unload];

	self.window = nil;
	self.sourceUrl = nil;
	self.sourceBundleId = nil;
	self.pushToken = nil;

	__applicationInstance = nil;
}

#pragma mark -

- (void)load
{
}

- (void)unload
{
}

- (void)main
{
}

#pragma mark -

- (BOOL)active
{
	return (UIApplicationStateActive == [UIApplication sharedApplication].applicationState) ? YES : NO;
}

- (BOOL)inactive
{
	return (UIApplicationStateInactive == [UIApplication sharedApplication].applicationState) ? YES : NO;
}

- (BOOL)background
{
	return (UIApplicationStateBackground == [UIApplication sharedApplication].applicationState) ? YES : NO;
}

#pragma mark -

- (SamuraiActivity *)activityFromString:(NSString *)string
{
	string = [string trim];
	
	INFO( @"Application '%p', create activity '%@'", self, string );

	SamuraiActivity * activity = [[SamuraiActivityRouter sharedInstance] activityForURL:string];
	
	if ( nil == activity )
	{
		Class runtimeClass = NSClassFromString( string );
		
		if ( runtimeClass && [runtimeClass isSubclassOfClass:[SamuraiActivity class]] )
		{
			activity = (SamuraiActivity *)[[runtimeClass alloc] init];
		}
	}

	return activity;
}

- (SamuraiActivityStack *)activityStackFromArray:(NSArray *)array
{
	INFO( @"Application '%p', create stack", self, [[self class] description] );
	
	SamuraiActivityStack * stack = [SamuraiActivityStack stack];

	for ( NSString * name in array )
	{
		SamuraiActivity * activity = [self activityFromString:name];
		if ( activity )
		{
			[stack pushActivity:activity animated:NO];
		}
	}
	
	return stack;
}

- (SamuraiActivityStackGroup *)activityStackGroupFromDictionary:(NSDictionary *)dict
{
	INFO( @"Application '%p', create stack-group", self, [[self class] description] );
	
	SamuraiActivityStackGroup * stackGroup = [SamuraiActivityStackGroup stackGroup];

	for ( NSString * key in dict.allKeys )
	{
		NSObject * value = [dict objectForKey:key];
		if ( nil == value )
			continue;
		
		INFO( @"Application '%p', create stackGroup item '%@'", self, [[self class] description], key );
		
		if ( [value isKindOfClass:[NSString class]] )
		{
			SamuraiActivity * activity = [self activityFromString:(NSString *)value];
			if ( activity )
			{
				[stackGroup map:(NSString *)key forActivity:activity];
			}
		}
		else if ( [value isKindOfClass:[NSArray class]] )
		{
			SamuraiActivityStack * activityStack = [self activityStackFromArray:(NSArray *)value];
			if ( activityStack )
			{
				[stackGroup map:(NSString *)key forActivityStack:activityStack];
			}
		}
	}
	
	return stackGroup;
}

#pragma mark -

- (void)loadWindow
{
	if ( nil == self.window )
	{
		self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
		self.window.alpha = 1.0f;
		self.window.backgroundColor = [UIColor whiteColor];
	}

	NSString * fileName = [NSString stringWithFormat:@"%@.manifest", [[self class] description]];
	NSString * fileExt = @"json";
	
	NSString * manifestPath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileExt];
	NSString * manifestData = [NSString stringWithContentsOfFile:manifestPath encoding:NSUTF8StringEncoding error:NULL];
	
	if ( nil == manifestData )
	{
		fileName = @"app.manifest";
		fileExt = @"json";
		
		manifestPath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileExt];
		manifestData = [NSString stringWithContentsOfFile:manifestPath encoding:NSUTF8StringEncoding error:NULL];
	}
	
	if ( manifestData )
	{
		NSDictionary * manifest = [manifestData JSONDecoded];
		
		if ( manifest )
		{
			NSDictionary *	applicationRoutes = [manifest objectAtPath:@"application.routes"];
			NSObject *		applicationMain = [manifest objectAtPath:@"application.main"];
			
			if ( applicationRoutes )
			{
				for ( NSString * key in applicationRoutes.allKeys )
				{
					Class classType = NSClassFromString( [applicationRoutes objectForKey:key] );
					if ( classType )
					{
						[[SamuraiActivityRouter sharedInstance] mapURL:key toActivityClass:classType];
					}
				}
			}
			
			if ( applicationMain )
			{
				if ( [applicationMain isKindOfClass:[NSString class]] )
				{
					self.window.rootViewController = [self activityFromString:(NSString *)applicationMain];
				}
				else if ( [applicationMain isKindOfClass:[NSArray class]] )
				{
					self.window.rootViewController = [self activityStackFromArray:(NSArray *)applicationMain];
				}
				else if ( [applicationMain isKindOfClass:[NSDictionary class]] )
				{
					self.window.rootViewController = [self activityStackGroupFromDictionary:(NSDictionary *)applicationMain];
				}
			}
			else
			{
				self.window.rootViewController = [SamuraiActivityStack stackWithActivity:[self activityFromString:@"/"]];
			}
		}
	}
	
	if ( self.window.rootViewController )
	{
		UNUSED( self.window.rootViewController.view );
	}
	
	[self.window makeKeyAndVisible];
}

#pragma mark -

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	[self application:application didFinishLaunchingWithOptions:nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	__applicationInstance = self;

	UNUSED( application );

	[self loadWindow];
	
	[self main];

	UILocalNotification *	localNotification = nil;
	NSDictionary *			remoteNotification = nil;
	
    if ( nil != launchOptions ) // 从通知启动
	{
		self.sourceUrl		= [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
		self.sourceBundleId	= [launchOptions objectForKey:UIApplicationLaunchOptionsSourceApplicationKey];
		
		localNotification	= [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
		remoteNotification	= [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
	}

	[self notify:SamuraiApp.Ready];

	if ( localNotification )
	{
		[self notify:SamuraiApp.LocalNotification withObject:localNotification.userInfo];
	}

	if ( remoteNotification )
	{
		[self notify:SamuraiApp.RemoteNotification withObject:remoteNotification];
	}
	
    return YES;
}

// Will be deprecated at some point, please replace with application:openURL:sourceApplication:annotation:
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
	return [self application:application openURL:url sourceApplication:nil annotation:nil];
}

// no equiv. notification. return NO if the application can't open for some reason
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [self application:application openURL:url options:nil];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary *)options
{
	self.sourceUrl = url.absoluteString;
//	self.sourceBundleId = sourceApplication;
	
	[self notify:SamuraiApp.Ready];
	
	return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	UNUSED( application )

//	[self.window.rootViewController viewWillAppear:NO];
//	[self.window.rootViewController viewDidAppear:NO];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	UNUSED( application )
	
//	[self.window.rootViewController viewWillDisappear:NO];
//	[self.window.rootViewController viewDidDisappear:NO];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	UNUSED( application )
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	UNUSED( application )
}

#pragma mark -

- (void)application:(UIApplication *)application willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation duration:(NSTimeInterval)duration
{
	UNUSED( application )
}

- (void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation
{
	UNUSED( application )
}

- (void)application:(UIApplication *)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame
{
	UNUSED( application )
}

- (void)application:(UIApplication *)application didChangeStatusBarFrame:(CGRect)oldStatusBarFrame
{
	UNUSED( application )
}

#pragma mark -

// one of these will be called after calling -registerForRemoteNotifications
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
	UNUSED( application )
	
	NSString * token = [deviceToken description];
	token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
	token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
	token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
	
	self.pushToken = token;
	
	[self notify:SamuraiApp.PushEnabled];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
	UNUSED( application )
	
	self.pushError = error;
	
	[self notify:SamuraiApp.PushError];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
	UNUSED( application )

	[self notify:SamuraiApp.RemoteNotification withObject:userInfo];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
	UNUSED( application )
	
	[self notify:SamuraiApp.RemoteNotification withObject:notification.userInfo];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	UNUSED( application )

	[self notify:SamuraiApp.EnterBackground];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	UNUSED( application )

	[self notify:SamuraiApp.EnterForeground];
}

- (void)applicationProtectedDataWillBecomeUnavailable:(UIApplication *)application
{
	UNUSED( application )
}

- (void)applicationProtectedDataDidBecomeAvailable:(UIApplication *)application
{
	UNUSED( application )
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "_pragma_pop.h"
