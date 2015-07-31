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

#import "Samurai_IntentBus.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiIntentBus
{
	NSMutableDictionary * _handlers;
}

@def_singleton( SamuraiIntentBus )

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

- (void)routes:(SamuraiIntent *)intent target:(id)target
{
	if ( nil == target )
	{
//		ERROR( @"No intent target" );
		return;
	}
	
	NSMutableArray * classes = [NSMutableArray nonRetainingArray];
	
	for ( Class clazz = [target class]; nil != clazz; clazz = class_getSuperclass(clazz) )
	{
		[classes addObject:clazz];
	}
	
	NSString *	intentClass = nil;
	NSString *	intentMethod = nil;

	if ( intent.action )
	{
		if ( [intent.action hasPrefix:@"intent."] )
		{
			NSArray * array = [intent.action componentsSeparatedByString:@"."];

			intentClass = (NSString *)[array safeObjectAtIndex:1];
			intentMethod = (NSString *)[array safeObjectAtIndex:2];
		}
		else
		{
			NSArray * array = [intent.action componentsSeparatedByString:@"/"];

			intentClass = (NSString *)[array safeObjectAtIndex:0];
			intentMethod = (NSString *)[array safeObjectAtIndex:1];

			if ( intentMethod )
			{
				intentMethod = [intentMethod stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
				intentMethod = [intentMethod stringByReplacingOccurrencesOfString:@"." withString:@"_"];
				intentMethod = [intentMethod stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
			}
		}
	}
	
	for ( Class targetClass in classes )
	{
		NSString * cacheName = [NSString stringWithFormat:@"%@/%@", intent.action, [targetClass description]];
		NSString * cachedSelectorName = [_handlers objectForKey:cacheName];
		
		if ( cachedSelectorName )
		{
			SEL cachedSelector = NSSelectorFromString( cachedSelectorName );
			if ( cachedSelector )
			{
				BOOL hit = [self intent:intent perform:cachedSelector class:targetClass target:target];
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
			
			// eg. handleIntent( Class, Intent )

			if ( intentClass && intentMethod )
			{
				selectorName = [NSString stringWithFormat:@"handleIntent____%@____%@:", intentClass, intentMethod];
				selector = NSSelectorFromString( selectorName );
				
				performed = [self intent:intent perform:selector class:targetClass target:target];
				if ( performed )
				{
					[_handlers setObject:selectorName forKey:cacheName];
					break;
				}

				// eg. handleIntent( intent )
				
				if ( [[targetClass description] isEqualToString:intentClass] )
				{
					selectorName = [NSString stringWithFormat:@"handleIntent____%@:", intentMethod];
					selector = NSSelectorFromString( selectorName );
					
					performed = [self intent:intent perform:selector class:targetClass target:target];
					if ( performed )
					{
						[_handlers setObject:selectorName forKey:cacheName];
						break;
					}
				}
			}

			// eg. handleIntent( Class )

			if ( intentClass )
			{
				selectorName = [NSString stringWithFormat:@"handleIntent____%@:", intentClass];
				selector = NSSelectorFromString( selectorName );
				
				performed = [self intent:intent perform:selector class:targetClass target:target];
				if ( performed )
				{
					[_handlers setObject:selectorName forKey:cacheName];
					break;
				}
			}

			// eg. handleIntent( helloWorld )
			
			if ( [intent.action hasPrefix:@"intent____"] )
			{
				selectorName = [intent.action stringByReplacingOccurrencesOfString:@"intent____" withString:@"handleIntent____"];
			}
			else
			{
				selectorName = [NSString stringWithFormat:@"handleIntent____%@:", intent.action];
			}

			selectorName = [selectorName stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
			selectorName = [selectorName stringByReplacingOccurrencesOfString:@"." withString:@"_"];
			selectorName = [selectorName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
			
			if ( NO == [selectorName hasSuffix:@":"] )
			{
				selectorName = [selectorName stringByAppendingString:@":"];
			}

			selector = NSSelectorFromString( selectorName );
			
			performed = [self intent:intent perform:selector class:targetClass target:target];
			if ( performed )
			{
				[_handlers setObject:selectorName forKey:cacheName];
				break;
			}

			// eg. handleIntent()
			
			if ( NO == performed )
			{
				selectorName = @"handleIntent____:";
				selector = NSSelectorFromString( selectorName );
				
				performed = [self intent:intent perform:selector class:targetClass target:target];
				if ( performed )
				{
					[_handlers setObject:selectorName forKey:cacheName];
					break;
				}
			}
			
			// eg. handleIntent:

			if ( NO == performed )
			{
				selectorName = @"handleIntent:";
				selector = NSSelectorFromString( selectorName );
				
				performed = [self intent:intent perform:selector class:targetClass target:target];
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

- (BOOL)intent:(SamuraiIntent *)intent perform:(SEL)sel class:(Class)clazz target:(id)target
{
	ASSERT( nil != intent );
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
			BOOL found = [handler trigger:[NSString stringWithUTF8String:sel_getName(sel)] withObject:intent];
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
				imp( target, sel, (__bridge void *)intent );

				performed = YES;
			}
		}
	}

	return performed;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, IntentBus )

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

//#endif
