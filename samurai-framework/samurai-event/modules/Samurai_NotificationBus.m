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

//#if __has_feature(objc_arc)
//
//#error "Please add compile option '-fno-objc-arc' for this file in 'Build phases'."
//
//#else

#import "Samurai_NotificationBus.h"

#import "_pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiNotificationBus
{
	NSMutableDictionary * _handlers;
}

@def_singleton( SamuraiNotificationBus )

- (id)init
{
	self = [super init];
	if ( self )
	{
		_handlers = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[_handlers removeAllObjects];
	_handlers = nil;
}

- (void)routes:(SamuraiNotification *)notification target:(id)target
{
	if ( nil == target )
	{
		ERROR( @"No notification target" );
		return;
	}

	NSMutableArray * classes = [NSMutableArray nonRetainingArray];
	
	for ( Class clazz = [target class]; nil != clazz; clazz = class_getSuperclass(clazz) )
	{
		[classes addObject:clazz];
	}
	
	NSString *	notificationClass = nil;
	NSString *	notificationMethod = nil;
	
	if ( notification.name )
	{
		if ( [notification.name hasPrefix:@"notification."] )
		{
			NSArray * array = [notification.name componentsSeparatedByString:@"."];
	
			notificationClass = (NSString *)[array safeObjectAtIndex:1];
			notificationMethod = (NSString *)[array safeObjectAtIndex:2];
		}
		else
		{
			NSArray * array = [notification.name componentsSeparatedByString:@"/"];
			
			notificationClass = (NSString *)[array safeObjectAtIndex:0];
			notificationMethod = (NSString *)[array safeObjectAtIndex:1];
			
			if ( notificationMethod )
			{
				notificationMethod = [notificationMethod stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
				notificationMethod = [notificationMethod stringByReplacingOccurrencesOfString:@"." withString:@"_"];
				notificationMethod = [notificationMethod stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
			}
		}
	}
	
	for ( Class targetClass in classes )
	{
		NSString * cacheName = [NSString stringWithFormat:@"%@/%@", notification.name, [targetClass description]];
		NSString * cachedSelectorName = [_handlers objectForKey:cacheName];
		
		if ( cachedSelectorName )
		{
			SEL cachedSelector = NSSelectorFromString( cachedSelectorName );
			if ( cachedSelector )
			{
				BOOL hit = [self notification:notification perform:cachedSelector class:targetClass target:target];
				if ( hit )
				{
//					continue;
					break;
				}
			}
		}
		
//		do
		{
			NSString *	selectorName = nil;
			SEL			selector = nil;
			BOOL		performed = NO;
			
			// eg. handleNotification( Class, Motification )
			
			if ( notificationClass && notificationMethod )
			{
				selectorName = [NSString stringWithFormat:@"handleNotification____%@____%@:", notificationClass, notificationMethod];
				selector = NSSelectorFromString( selectorName );
				
				performed = [self notification:notification perform:selector class:targetClass target:target];
				if ( performed )
				{
					[_handlers setObject:selectorName forKey:cacheName];
					break;
				}
				
				// eg. handleNotification( Notification )
				
				if ( [[targetClass description] isEqualToString:notificationClass] )
				{
					selectorName = [NSString stringWithFormat:@"handleNotification____%@:", notificationMethod];
					selector = NSSelectorFromString( selectorName );
					
					performed = [self notification:notification perform:selector class:targetClass target:target];
					if ( performed )
					{
						[_handlers setObject:selectorName forKey:cacheName];
						break;
					}
				}
			}
			
			// eg. handleNotification( Class )
			
			if ( notificationClass )
			{
				selectorName = [NSString stringWithFormat:@"handleNotification____%@:", notificationClass];
				selector = NSSelectorFromString( selectorName );
				
				performed = [self notification:notification perform:selector class:targetClass target:target];
				if ( performed )
				{
					[_handlers setObject:selectorName forKey:cacheName];
					break;
				}
			}
			
			// eg. handleNotification( helloWorld )
			
			if ( [notification.name hasPrefix:@"notification____"] )
			{
				selectorName = [notification.name stringByReplacingOccurrencesOfString:@"notification____" withString:@"handleNotification____"];
			}
			else
			{
				selectorName = [NSString stringWithFormat:@"handleNotification____%@:", notification.name];
			}
			
			selectorName = [selectorName stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
			selectorName = [selectorName stringByReplacingOccurrencesOfString:@"." withString:@"_"];
			selectorName = [selectorName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
			
			if ( NO == [selectorName hasSuffix:@":"] )
			{
				selectorName = [selectorName stringByAppendingString:@":"];
			}
			
			selector = NSSelectorFromString( selectorName );
			
			performed = [self notification:notification perform:selector class:targetClass target:target];
			if ( performed )
			{
				[_handlers setObject:selectorName forKey:cacheName];
				break;
			}
			
			// eg. handleNotification()
			
			if ( NO == performed )
			{
				selectorName = @"handleNotification____:";
				selector = NSSelectorFromString( selectorName );
				
				performed = [self notification:notification perform:selector class:targetClass target:target];
				if ( performed )
				{
					[_handlers setObject:selectorName forKey:cacheName];
					break;
				}
			}
			
			// eg. handleNotification:
			
			if ( NO == performed )
			{
				selectorName = @"handleNotification:";
				selector = NSSelectorFromString( selectorName );
				
				performed = [self notification:notification perform:selector class:targetClass target:target];
				if ( performed )
				{
					[_handlers setObject:selectorName forKey:cacheName];
					break;
				}
			}
		}
//		while ( 0 );
	}
}

- (BOOL)notification:(SamuraiNotification *)notification perform:(SEL)sel class:(Class)clazz target:(id)target
{
	ASSERT( nil != notification );
	ASSERT( nil != target );
	ASSERT( nil != sel );
	ASSERT( nil != clazz );
	
	BOOL performed = NO;
	
	// try block
	
	if ( NO == performed )
	{
		SamuraiHandler * handler = [target blockHandler];
		if ( handler )
		{
			BOOL found = [handler trigger:[NSString stringWithUTF8String:sel_getName(sel)] withObject:notification];
			if ( found )
			{
				performed = YES;
			}
		}
	}
	
	// try selector
	
	if ( NO == performed )
	{
		Method method = class_getInstanceMethod( clazz, sel );
		if ( method )
		{
			ImpFuncType imp = (ImpFuncType)method_getImplementation( method );
			if ( imp )
			{
				imp( target, sel, (__bridge void *)notification );

				performed = YES;
			}
		}
	}
	
#if __SAMURAI_DEBUG__
#if __NOTIFICATION_CALLSTACK__
	
	NSString * selName = [NSString stringWithUTF8String:sel_getName(sel)];
	NSString * className = [clazz description];
	
	if ( NSNotFound != [selName rangeOfString:@"____"].location )
	{
		selName = [selName stringByReplacingOccurrencesOfString:@"handleNotification____" withString:@"handleNotification( "];
		selName = [selName stringByReplacingOccurrencesOfString:@"____" withString:@", "];
		selName = [selName stringByReplacingOccurrencesOfString:@":" withString:@""];
		selName = [selName stringByAppendingString:@" )"];
	}
	
	PERF( @"  %@ %@::%@", performed ? @"✔" : @"✖", className, selName );
	
#endif
#endif

	return performed;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( Event, NotificationBus )

DESCRIBE( before )
{
}

DESCRIBE( after )
{
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#import "_pragma_pop.h"

//#endif
