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

#import "Samurai_SignalBus.h"

#import "_pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiSignalBus
{
	NSMutableDictionary * _handlers;
}

@def_singleton( SamuraiSignalBus )

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

- (BOOL)send:(SamuraiSignal *)signal
{
	if ( signal.dead )
	{
		ERROR( @"signal '%@', already dead", signal.prettyName );
		return NO;
	}

#if __SAMURAI_DEBUG__
#if __SIGNAL_CALLSTACK__

	PRINT( @"" );
	PERF( @"signal '%@'", signal.prettyName );
	
#endif
#endif

//// Check if foreign source
//
//	if ( signal.name )
//	{
//		signal.foreign = nil;
//		
//		NSArray * nameComponents = [signal.name componentsSeparatedByString:@"."];
//		if ( nameComponents.count > 2 && [[nameComponents objectAtIndex:0] isEqualToString:@"signal"] )
//		{
//			NSString * sourceName = [[signal.source class] description];
//			NSString * namePrefix = [nameComponents objectAtIndex:1];
//			
//			if ( NO == [sourceName isEqualToString:namePrefix] )
//			{
//				signal.prefix = namePrefix;
//				signal.foreign = signal.source;
//			}
//		}
//	}

// Routes signal
	
	if ( signal.target )
	{
		signal.sending = YES;

		[self routes:signal];
	}
	else
	{
		signal.arrived = YES;
	}

#if __SAMURAI_DEBUG__
#if __SAMURAI_LOGGING__
	NSString * newline = @"\n   > ";
#endif	// #if __SAMURAI_LOGGING__
#endif	// #if __SAMURAI_DEBUG__

	if ( signal.arrived )
	{
		if ( signal.jumpPath )
		{
			PERF( @"Signal '%@'%@%@%@[Done]", signal.prettyName, newline, [signal.jumpPath join:newline], newline );
		}
		else
		{
			PERF( @"Signal '%@'%@[Done]", signal.prettyName, newline );
		}
	}
	else if ( signal.dead )
	{
		if ( signal.jumpPath )
		{
			PERF( @"Signal '%@'%@%@%@[Dead]", signal.prettyName, newline, [signal.jumpPath join:newline], newline );
		}
		else
		{
			PERF( @"Signal '%@'%s[Dead]", signal.prettyName, newline );
		}
	}

	return signal.arrived;
}

- (BOOL)forward:(SamuraiSignal *)signal
{
	return [self forward:signal to:nil];
}

- (BOOL)forward:(SamuraiSignal *)signal to:(id)target
{
	if ( signal.dead )
	{
		ERROR( @"signal '%@', already dead", signal.prettyName );
		return NO;
	}

	if ( nil == signal.target )
	{
		ERROR( @"signal '%@', no target", signal.prettyName );
		return NO;
	}

//	if ( nil == target )
//	{
//		if ( [signal.target isKindOfClass:[UIView class]] )
//		{
//			target = ((UIView *)signal.target).superview;
//		}
//	}

	[signal log:signal.target];

	if ( nil == target )
	{
		signal.arrived = YES;
		return YES;
	}
	
//// Check if foreign source
//
//	if ( signal.foreign && signal.source == signal.foreign )
//	{
//		NSString * targetName = [[target class] description];
//		
//		if ( [targetName isEqualToString:signal.prefix] )
//		{
//			signal.source = target;
//		}
////		else
////		{
////			Class targetClass = NSClassFromString( targetName );
////			Class sourceClass = NSClassFromString( signal.prefix );
////
////			if ( sourceClass == targetClass || [targetClass isSubclassOfClass:sourceClass] )
////			{
////				signal.source = target;
////			}
////		}
//	}
	
// Routes signal
	
	signal.target = target;
	signal.sending = YES;
	
	[self routes:signal];

	return signal.arrived;
}

- (void)routes:(SamuraiSignal *)signal
{
	NSMutableArray * classes = [NSMutableArray nonRetainingArray];

	for ( Class clazz = [signal.target class]; nil != clazz; clazz = class_getSuperclass(clazz) )
	{
		[classes addObject:clazz];
	}

	[self routes:signal to:signal.target forClasses:classes];
	
	if ( NO == signal.arrived )
	{
		NSObject *		object = [signal.target signalResponders];
		EncodingType	objectType = [SamuraiEncoding typeOfObject:object];
		
		if ( nil == object )
		{
			signal.arrived = YES;
		}
		else
		{
			if ( EncodingType_Array == objectType )
			{
				NSArray * responders = (NSArray *)object;
				
				if ( 1 == responders.count )
				{
					if ( NO == signal.dead )
					{
						[signal log:signal.target];
						
						signal.target = [responders objectAtIndex:0];
						signal.sending = YES;
					
						[self routes:signal];
					}
					
				//	[self forward:signal to:[responders objectAtIndex:0]];
				}
				else
				{
					for ( NSObject * responder in responders )
					{
						SamuraiSignal * clonedSignal = [signal clone];
						
						if ( clonedSignal )
						{
							if ( NO == clonedSignal.dead )
							{
								[clonedSignal log:clonedSignal.target];
								
								clonedSignal.target = responder;
								clonedSignal.sending = YES;
								
								[self routes:clonedSignal];
							}

						//	[self forward:clonedSignal to:responder];
						}
					}
				}
			}
			else
			{
				if ( NO == signal.dead )
				{
					[signal log:signal.target];
					
					signal.target = object;
					signal.sending = YES;
					
					[self routes:signal];
				}
				
			//	[self forward:signal to:object];
			}
		}
	}
}

- (void)routes:(SamuraiSignal *)signal to:(NSObject *)target forClasses:(NSArray *)classes
{
	if ( 0 == classes.count )
	{
		return;
	}

	if ( nil == signal.source || nil == signal.target )
	{
		ERROR( @"No signal source/target" );
		return;
	}

	NSObject *	prioAlias = nil;
	NSString *	prioSelector = nil;
	NSString *	nameSpace = nil;
	NSString *	tagString = nil;
	
	NSString *	signalPrefix = nil;
	NSString *	signalClass = nil;
	NSString *	signalMethod = nil;
	NSString *	signalMethod2 = nil;
	
	if ( signal.name && [signal.name hasPrefix:@"signal."] )
	{
		NSArray * array = [signal.name componentsSeparatedByString:@"."];
		if ( array && array.count > 1 )
		{
			signalPrefix = (NSString *)[array safeObjectAtIndex:0];
			signalClass = (NSString *)[array safeObjectAtIndex:1];
			signalMethod = (NSString *)[array safeObjectAtIndex:2];
			signalMethod2 = (NSString *)[array safeObjectAtIndex:3];
			
			ASSERT( [signalPrefix isEqualToString:@"signal"] );
		}
	}

	if ( signal.source )
	{
		nameSpace = [signal.source signalNamespace];
		if ( nameSpace && nameSpace.length )
		{
			nameSpace = [nameSpace stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
			nameSpace = [nameSpace stringByReplacingOccurrencesOfString:@":" withString:@"_"];
		}
		
		tagString = [signal.source signalTag];
		if ( tagString && tagString.length )
		{
			tagString = [tagString stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
			tagString = [tagString stringByReplacingOccurrencesOfString:@":" withString:@"_"];
		}
		
//		if ( nameSpace || tagString )
		{
			if ( nameSpace && tagString )
			{
				prioSelector = [NSString stringWithFormat:@"%@_%@", nameSpace, tagString];
			}
//			else if ( nameSpace )
//			{
//				prioSelector = nameSpace;
//			}
//			else if ( tagString )
//			{
//				prioSelector = tagString;
//			}
		}
		
		prioAlias = [signal.source signalAlias];
	}
	
	for ( Class targetClass in classes )
	{
		NSString *	cacheName = nil;
		NSString *	cachedSelectorName = nil;
		SEL			cachedSelector = nil;

		if ( prioSelector )
		{
			cacheName = [NSString stringWithFormat:@"%@/%@/%@", signal.name, [targetClass description], prioSelector];
		}
		else
		{
			cacheName = [NSString stringWithFormat:@"%@/%@", signal.name, [targetClass description]];
		}
		
		cachedSelectorName = [_handlers objectForKey:cacheName];

		if ( cachedSelectorName )
		{
			cachedSelector = NSSelectorFromString( cachedSelectorName );

			if ( cachedSelector )
			{
				BOOL hit = [self signal:signal perform:cachedSelector class:targetClass target:target];
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

		// native selector

			if ( [signal.name hasPrefix:@"signal."] )
			{
				if ( NO == performed )
				{
					selectorName = [signal.name substringFromIndex:@"signal.".length];
					selectorName = [selectorName stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
					selectorName = [selectorName stringByReplacingOccurrencesOfString:@"." withString:@"_"];
					selectorName = [selectorName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
					
					selector = NSSelectorFromString( selectorName );
					
					performed = [self signal:signal perform:selector class:targetClass target:target];
					if ( performed )
					{
						[_handlers setObject:selectorName forKey:cacheName];
						break;
					}
				}
			}
			
			if ( [signal.name hasPrefix:@"selector."] )
			{
				if ( NO == performed )
				{
					selectorName = [signal.name substringFromIndex:@"selector.".length];
//					selectorName = [selectorName stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
//					selectorName = [selectorName stringByReplacingOccurrencesOfString:@"." withString:@"_"];
//					selectorName = [selectorName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
					
					selector = NSSelectorFromString( selectorName );
					
					performed = [self signal:signal perform:selector class:targetClass target:target];
					if ( performed )
					{
						[_handlers setObject:selectorName forKey:cacheName];
						break;
					}
				}
			}

			if ( NO == performed )
			{
				if ( [signal.name hasSuffix:@":"] )
				{
					selectorName = signal.name;
				}
				else
				{
					selectorName = [NSString stringWithFormat:@"%@:", signal.name];
				}
				
				selectorName = [selectorName stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
				selectorName = [selectorName stringByReplacingOccurrencesOfString:@"." withString:@"_"];
				selectorName = [selectorName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
				
				selector = NSSelectorFromString( selectorName );
				
				performed = [self signal:signal perform:selector class:targetClass target:target];
				if ( performed )
				{
					[_handlers setObject:selectorName forKey:cacheName];
					break;
				}
			}
			
		// high priority selector
			
			if ( prioAlias )
			{
				if ( [prioAlias isKindOfClass:[NSArray class]] )
				{
					for ( NSString * alias in (NSArray *)prioAlias )
					{
						selectorName = [NSString stringWithFormat:@"handleSignal____%@:", alias];
						selector = NSSelectorFromString( selectorName );

						performed = [self signal:signal perform:selector class:targetClass target:target];
						if ( performed )
						{
							[_handlers setObject:selectorName forKey:cacheName];
							break;
						}

						if ( signalMethod && signalMethod2 )
						{
							selectorName = [NSString stringWithFormat:@"handleSignal____%@____%@____%@:", alias, signalMethod, signalMethod2];
							selector = NSSelectorFromString( selectorName );
							
							performed = [self signal:signal perform:selector class:targetClass target:target];
							if ( performed )
							{
								[_handlers setObject:selectorName forKey:cacheName];
								break;
							}
						}

						if ( signalMethod )
						{
							selectorName = [NSString stringWithFormat:@"handleSignal____%@____%@:", alias, signalMethod];
							selector = NSSelectorFromString( selectorName );
							
							performed = [self signal:signal perform:selector class:targetClass target:target];
							if ( performed )
							{
								[_handlers setObject:selectorName forKey:cacheName];
								break;
							}
						}
					}
				}
				else
				{
					selectorName = [NSString stringWithFormat:@"handleSignal____%@:", prioAlias];
					selector = NSSelectorFromString( selectorName );
					
					performed = [self signal:signal perform:selector class:targetClass target:target];
					if ( performed )
					{
						[_handlers setObject:selectorName forKey:cacheName];
						break;
					}
					
					if ( signalMethod && signalMethod2 )
					{
						selectorName = [NSString stringWithFormat:@"handleSignal____%@____%@____%@:", prioAlias, signalMethod, signalMethod2];
						selector = NSSelectorFromString( selectorName );
						
						performed = [self signal:signal perform:selector class:targetClass target:target];
						if ( performed )
						{
							[_handlers setObject:selectorName forKey:cacheName];
							break;
						}
					}
					
					if ( signalMethod )
					{
						selectorName = [NSString stringWithFormat:@"handleSignal____%@____%@:", prioAlias, signalMethod];
						selector = NSSelectorFromString( selectorName );
						
						performed = [self signal:signal perform:selector class:targetClass target:target];
						if ( performed )
						{
							[_handlers setObject:selectorName forKey:cacheName];
							break;
						}
					}
				}
			}
			
			if ( performed )
			{
				break;
			}
			
		// signal selector

			if ( prioSelector )
			{
			// eg. handleSignal( Class, tag )
				
				selectorName = [NSString stringWithFormat:@"handleSignal____%@:", prioSelector];
				selector = NSSelectorFromString( selectorName );
				
				performed = [self signal:signal perform:selector class:targetClass target:target];
				if ( performed )
				{
					[_handlers setObject:selectorName forKey:cacheName];
					break;
				}
			}

			// eg. handleSignal( Class, Signal, State )
			
			if ( signalClass && signalMethod && signalMethod2 )
			{
				selectorName = [NSString stringWithFormat:@"handleSignal____%@____%@____%@:", signalClass, signalMethod, signalMethod2];
				selector = NSSelectorFromString( selectorName );
				
				performed = [self signal:signal perform:selector class:targetClass target:target];
				if ( performed )
				{
					[_handlers setObject:selectorName forKey:cacheName];
					break;
				}
			}

			// eg. handleSignal( Class, Signal )
			
			if ( signalClass && signalMethod )
			{
				selectorName = [NSString stringWithFormat:@"handleSignal____%@____%@:", signalClass, signalMethod];
				selector = NSSelectorFromString( selectorName );
				
				performed = [self signal:signal perform:selector class:targetClass target:target];
				if ( performed )
				{
					[_handlers setObject:selectorName forKey:cacheName];
					break;
				}
			}
			
			// eg. handleSignal( Class )
			
			if ( signalClass )
			{
				selectorName = [NSString stringWithFormat:@"handleSignal____%@:", signalClass];
				selector = NSSelectorFromString( selectorName );
				
				performed = [self signal:signal perform:selector class:targetClass target:target];
				if ( performed )
				{
					[_handlers setObject:selectorName forKey:cacheName];
					break;
				}
			}
			
			// eg. handleSignal( Class, Signal )
			
			if ( [signal.name hasPrefix:@"signal____"] )
			{
				selectorName = [signal.name stringByReplacingOccurrencesOfString:@"signal____" withString:@"handleSignal____"];
			}
			else
			{
				selectorName = [NSString stringWithFormat:@"handleSignal____%@:", signal.name];
			}
			
			selectorName = [selectorName stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
			selectorName = [selectorName stringByReplacingOccurrencesOfString:@"." withString:@"_"];
			selectorName = [selectorName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
			
			if ( NO == [selectorName hasSuffix:@":"] )
			{
				selectorName = [selectorName stringByAppendingString:@":"];
			}

			selector = NSSelectorFromString( selectorName );
			
			performed = [self signal:signal perform:selector class:targetClass target:target];
			if ( performed )
			{
				[_handlers setObject:selectorName forKey:cacheName];
				break;
			}
			
			for ( Class rtti = [signal.source class]; nil != rtti && rtti != [NSObject class]; rtti = class_getSuperclass(rtti) )
			{
				// eg. handleSignal( Class, Signal, State )
				
				if ( (signalMethod && signalMethod.length) && signalMethod2 && signalMethod2.length )
				{
					selectorName = [NSString stringWithFormat:@"handleSignal____%@____%@____%@:", [rtti description], signalMethod, signalMethod2];
					selector = NSSelectorFromString( selectorName );
					
					performed = [self signal:signal perform:selector class:targetClass target:target];
					if ( performed )
					{
						[_handlers setObject:selectorName forKey:cacheName];
						break;
					}
				}

				// eg. handleSignal( Class, Signal )
				
				if ( signalMethod && signalMethod.length )
				{
					selectorName = [NSString stringWithFormat:@"handleSignal____%@____%@:", [rtti description], signalMethod];
					selector = NSSelectorFromString( selectorName );
					
					performed = [self signal:signal perform:selector class:targetClass target:target];
					if ( performed )
					{
						[_handlers setObject:selectorName forKey:cacheName];
						break;
					}
				}
				
				// eg. handleSignal( Class, tag )
				
				if ( tagString && tagString.length )
				{
					selectorName = [NSString stringWithFormat:@"handleSignal____%@____%@:", [rtti description], tagString];
					selector = NSSelectorFromString( selectorName );
					
					performed = [self signal:signal perform:selector class:targetClass target:target];
					if ( performed )
					{
						[_handlers setObject:selectorName forKey:cacheName];
						break;
					}

					selectorName = [NSString stringWithFormat:@"handleSignal____%@:", tagString];
					selector = NSSelectorFromString( selectorName );
					
					performed = [self signal:signal perform:selector class:targetClass target:target];
					if ( performed )
					{
						[_handlers setObject:selectorName forKey:cacheName];
						break;
					}
				}
				
				// eg. handleSignal( Class )
				
				selectorName = [NSString stringWithFormat:@"handleSignal____%@:", [rtti description]];
				selector = NSSelectorFromString( selectorName );
				
				performed = [self signal:signal perform:selector class:targetClass target:target];
				if ( performed )
				{
					[_handlers setObject:selectorName forKey:cacheName];
					break;
				}
			}
			
			if ( NO == performed )
			{
				selectorName = @"handleSignal____:";
				selector = NSSelectorFromString( selectorName );
				
				performed = [self signal:signal perform:selector class:targetClass target:target];
				if ( performed )
				{
					[_handlers setObject:selectorName forKey:cacheName];
					break;
				}
			}
			
			if ( NO == performed )
			{
				selectorName = @"handleSignal:";
				selector = NSSelectorFromString( selectorName );
				
				performed = [self signal:signal perform:selector class:targetClass target:target];
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

- (BOOL)signal:(SamuraiSignal *)signal perform:(SEL)sel class:(Class)clazz target:(id)target
{
	ASSERT( nil != signal );
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
			BOOL found = [handler trigger:[NSString stringWithUTF8String:sel_getName(sel)] withObject:signal];
			if ( found )
			{
				signal.hit = YES;
				signal.hitCount += 1;

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
				imp( target, sel, (__bridge void *)signal );

				signal.hit = YES;
				signal.hitCount += 1;

				performed = YES;
			}
		}
	}
	
#if __SAMURAI_DEBUG__
#if __SIGNAL_CALLSTACK__
	
	NSString * selName = [NSString stringWithUTF8String:sel_getName(sel)];
	NSString * className = [clazz description];
	
	if ( NSNotFound != [selName rangeOfString:@"____"].location )
	{
		selName = [selName stringByReplacingOccurrencesOfString:@"handleSignal____" withString:@"handleSignal( "];
		selName = [selName stringByReplacingOccurrencesOfString:@"____" withString:@", "];
		selName = [selName stringByReplacingOccurrencesOfString:@":" withString:@""];
		selName = [selName stringByAppendingString:@" )"];
	}
	
	PERF( @"  %@ [%d] %@::%@", performed ? @"✔" : @"✖", signal.jumpCount, className, selName );
	
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

TEST_CASE( Event, SignalBus )

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
