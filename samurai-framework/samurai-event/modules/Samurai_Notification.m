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

#import "Samurai_Notification.h"
#import "Samurai_NotificationCenter.h"

#import "_pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSNotification(Extension)

@def_prop_dynamic( NSString *,	prettyName );

#pragma mark -

- (NSString *)prettyName
{
	return [self.name stringByReplacingOccurrencesOfString:@"notification." withString:@""];
}

- (BOOL)is:(NSString *)value
{
	return [self.name isEqualToString:value];
}

@end

#pragma mark - 

@implementation NSObject(NotificationResponder)

@def_prop_dynamic( SamuraiEventBlock, onNotification );

#pragma mark -

- (SamuraiNotificationBlock)onNotification
{
	@weakify( self );
	
	SamuraiNotificationBlock block = ^ NSObject * ( NSString * name, id notificationBlock )
	{
		@strongify( self );

		if ( notificationBlock )
		{
			[[SamuraiNotificationCenter sharedInstance] addObserver:self forNotification:name];
		}
		else
		{
			[[SamuraiNotificationCenter sharedInstance] removeObserver:self forNotification:name];
		}

		name = [name stringByReplacingOccurrencesOfString:@"notification." withString:@"handleNotification____"];
		name = [name stringByReplacingOccurrencesOfString:@"notification____" withString:@"handleNotification____"];
		name = [name stringByReplacingOccurrencesOfString:@"-" withString:@"____"];
		name = [name stringByReplacingOccurrencesOfString:@"." withString:@"____"];
		name = [name stringByReplacingOccurrencesOfString:@"/" withString:@"____"];
		name = [name stringByAppendingString:@":"];

		if ( notificationBlock )
		{
			[self addBlock:notificationBlock forName:name];
		}
		else
		{
			[self removeBlockForName:name];
		}

		return self;
	};
	
	return [block copy];
}

- (void)observeNotification:(NSString *)name
{
	[[SamuraiNotificationCenter sharedInstance] addObserver:self forNotification:name];
}

- (void)unobserveNotification:(NSString *)name
{
	[[SamuraiNotificationCenter sharedInstance] removeObserver:self forNotification:name];
}

- (void)observeAllNotifications
{
	NSArray * methods = [[self class] methodsWithPrefix:@"handleNotification____" untilClass:[NSObject class]];
	
	if ( methods && methods.count )
	{
		NSMutableArray * names = [NSMutableArray array];
		
		for ( NSString * method in methods )
		{
			NSString * notificationName = method;
			
			notificationName = [notificationName stringByReplacingOccurrencesOfString:@"handleNotification" withString:@"notification"];
			notificationName = [notificationName stringByReplacingOccurrencesOfString:@"____" withString:@"."];

			if ( [notificationName hasSuffix:@":"] )
			{
				notificationName = [notificationName substringToIndex:(notificationName.length - 1)];
			}

			[[SamuraiNotificationCenter sharedInstance] addObserver:self forNotification:notificationName];
			
			[names addObject:notificationName];
		}

		[self retainAssociatedObject:names forKey:"notificationNames"];
	}
}

- (void)unobserveAllNotifications
{
	NSArray * names = [self getAssociatedObjectForKey:"notificationNames"];
	
	if ( names && names.count )
	{
		for ( NSString * name in names )
		{
			[[SamuraiNotificationCenter sharedInstance] removeObserver:self forNotification:name];
		}
		
		[self removeAssociatedObjectForKey:"notificationNames"];
	}
	
	[[SamuraiNotificationCenter sharedInstance] removeObserver:self];
}

- (void)handleNotification:(SamuraiNotification *)notification
{
	UNUSED( notification )
}

@end

#pragma mark -

@implementation NSObject(NotificationSender)

+ (void)notify:(NSString *)name
{
	[[SamuraiNotificationCenter sharedInstance] postNotification:name object:nil];
}

- (void)notify:(NSString *)name
{
	[[SamuraiNotificationCenter sharedInstance] postNotification:name object:nil];
}

+ (void)notify:(NSString *)name withObject:(NSObject *)object
{
	[[SamuraiNotificationCenter sharedInstance] postNotification:name object:object];
}

- (void)notify:(NSString *)name withObject:(NSObject *)object
{
	[[SamuraiNotificationCenter sharedInstance] postNotification:name object:object];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

static NSInteger __value = 0;

@interface __TestNotification : NSObject

@notification( TEST )

@end

@implementation __TestNotification

@def_notification( TEST )

@end

TEST_CASE( Event, Notification )
{
	
}

DESCRIBE( before )
{
	[self observeAllNotifications];
	
	EXPECTED( 0 == __value );
}

DESCRIBE( Send notification )
{
	__TestNotification * obj = [[__TestNotification alloc] init];
	
	EXPECTED( 0 == __value );
	
	TIMES( 100 )
	{
		[obj notify:__TestNotification.TEST];
	}
	
	EXPECTED( 100 == __value );

	TIMES( 100 )
	{
		[obj notify:obj.TEST];
	}
	
	EXPECTED( 200 == __value );
}

handleNotification( __TestNotification, TEST )
{
	EXPECTED( [notification.name isEqualToString:__TestNotification.TEST] );
	
	__value += 1;
}

DESCRIBE( Handle notification )
{
	TIMES( 100 )
	{
		__block BOOL block1Executed = NO;
		__block BOOL block2Executed = NO;

		self.onNotification( __TestNotification.TEST, ^( SamuraiNotification * notification ){
			UNUSED( notification );
			block1Executed = YES;
		});
		
		self.onNotification( makeNotification(__TestNotification,xxx), ^( SamuraiNotification * notification ){
			UNUSED( notification );
			block2Executed = YES;
		});
		
		[self notify:__TestNotification.TEST];
		[self notify:makeNotification(__TestNotification,xxx)];

		EXPECTED( block1Executed == YES );
		EXPECTED( block2Executed == YES );
	}
}

DESCRIBE( after )
{
	[self unobserveAllNotifications];
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#import "_pragma_pop.h"
