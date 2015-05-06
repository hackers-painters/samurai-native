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

#import "Samurai_NotificationCenter.h"
#import "Samurai_NotificationBus.h"

#import "_pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark - 

@implementation SamuraiNotificationCenter
{
	NSMutableDictionary * _map;
}

@def_singleton( SamuraiNotificationCenter )

- (id)init
{
	self = [super init];
	if ( self )
	{
		_map = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[_map removeAllObjects];
	_map = nil;
}

#pragma mark -

- (void)postNotification:(NSString *)name
{
	[self postNotification:name object:nil];
}

- (void)postNotification:(NSString *)name object:(id)object
{
	INFO( @"Notification '%@'", [name stringByReplacingOccurrencesOfString:@"notification." withString:@""] );
	
	[[NSNotificationCenter defaultCenter] postNotificationName:name object:object];
}

- (void)addObserver:(id)observer forNotification:(NSString *)name
{
	if ( nil == observer )
		return;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:name object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:name object:nil];

	NSMutableArray * observers = [_map objectForKey:name];
	
	if ( nil == observers )
	{
		observers = [NSMutableArray nonRetainingArray];

		[_map setObject:observers forKey:name];
	}
	
	if ( NO == [observers containsObject:observer] )
	{
		[observers addObject:observer];
	}
}

- (void)removeObserver:(id)observer forNotification:(NSString *)name
{
	NSMutableArray * observers = [_map objectForKey:name];
	
	if ( observers )
	{
		[observers removeObject:observer];
	}
	
	if ( nil == observers || 0 == observers.count )
	{
		[_map removeObjectForKey:name];

		[[NSNotificationCenter defaultCenter] removeObserver:self name:name object:nil];
	}
}

- (void)removeObserver:(id)observer
{
	for ( NSMutableArray * observers in _map.allValues )
	{
		[observers removeObject:observer];
	}

	[[NSNotificationCenter defaultCenter] removeObserver:observer];
}

- (void)handleNotification:(SamuraiNotification *)notification
{
	NSMutableArray * observers = [_map objectForKey:notification.name];

	if ( observers && observers.count )
	{
		for ( NSObject * observer in observers )
		{
			[[SamuraiNotificationBus sharedInstance] routes:notification target:observer];
		}
	}
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( Event, NotificationCenter )

DESCRIBE( before )
{
}

DESCRIBE( after )
{
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#import "_pragma_pop.h"
