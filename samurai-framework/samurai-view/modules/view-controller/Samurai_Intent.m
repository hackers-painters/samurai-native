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

#import "Samurai_Intent.h"
#import "Samurai_IntentBus.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSObject(IntentResponder)

@def_prop_dynamic( SamuraiIntentObserverBlock, onIntent );

#pragma mark -

- (SamuraiIntentObserverBlock)onIntent
{
	@weakify( self );

	SamuraiIntentObserverBlock block = ^ NSObject * ( NSString * action, id intentBlock )
	{
		@strongify( self );
		
		action = [action stringByReplacingOccurrencesOfString:@"intent." withString:@"handleIntent____"];
		action = [action stringByReplacingOccurrencesOfString:@"intent____" withString:@"handleIntent____"];
		action = [action stringByReplacingOccurrencesOfString:@"-" withString:@"____"];
		action = [action stringByReplacingOccurrencesOfString:@"." withString:@"____"];
		action = [action stringByReplacingOccurrencesOfString:@"/" withString:@"____"];
		action = [action stringByAppendingString:@":"];
		
		if ( intentBlock )
		{
			[self addBlock:intentBlock forName:action];
		}
		else
		{
			[self removeBlockForName:action];
		}
		
		return self;
	};
	
	return [block copy];
}

- (void)handleIntent:(SamuraiIntent *)that
{
	UNUSED( that );
}

@end

#pragma mark -

@implementation SamuraiIntent

@def_joint( stateChanged );

@def_prop_strong( NSString *,					action );
@def_prop_strong( NSMutableDictionary *,		input );
@def_prop_strong( NSMutableDictionary *,		output );

@def_prop_unsafe( id,							source );
@def_prop_unsafe( id,							target );

@def_prop_copy( BlockType,						stateChanged );
@def_prop_assign( IntentState,					state );
@def_prop_dynamic( BOOL,						arrived );
@def_prop_dynamic( BOOL,						succeed );
@def_prop_dynamic( BOOL,						failed );
@def_prop_dynamic( BOOL,						cancelled );

#pragma mark -

+ (SamuraiIntent *)intent
{
	return [[SamuraiIntent alloc] init];
}

+ (SamuraiIntent *)intent:(NSString *)action
{
	SamuraiIntent * intent = [[SamuraiIntent alloc] init];
	intent.action = action;
	return intent;
}

+ (SamuraiIntent *)intent:(NSString *)action params:(NSDictionary *)params
{
	SamuraiIntent * intent = [[SamuraiIntent alloc] init];
	intent.action = action;
	
	if ( params )
	{
		[intent.input setDictionary:params];
	}
	
	return intent;
}

- (id)init
{
	static NSUInteger __seed = 0;
	
	self = [super init];
	if ( self )
	{
		self.action = [NSString stringWithFormat:@"intent-%lu", (unsigned long)__seed++];
		self.input = [NSMutableDictionary dictionary];
		self.output = [NSMutableDictionary dictionary];
		
		_state = IntentState_Inited;
	}
	return self;
}

- (void)dealloc
{
	self.stateChanged = nil;
	
	self.action = nil;
	self.input = nil;
	self.output = nil;
}

- (NSString *)prettyName
{
	return [self.action stringByReplacingOccurrencesOfString:@"intent." withString:@""];
}

- (BOOL)is:(NSString *)action
{
	return [self.action isEqualToString:action];
}

- (IntentState)state
{
	return _state;
}

- (void)setState:(IntentState)newState
{
	[self changeState:newState];
}

- (BOOL)arrived
{
	return IntentState_Arrived == _state ? YES : NO;
}

- (void)setArrived:(BOOL)flag
{
	if ( flag )
	{
		[self changeState:IntentState_Arrived];
	}
}

- (BOOL)succeed
{
	return IntentState_Succeed == _state ? YES : NO;
}

- (void)setSucceed:(BOOL)flag
{
	if ( flag )
	{
		[self changeState:IntentState_Succeed];
	}
}

- (BOOL)failed
{
	return IntentState_Failed == _state ? YES : NO;
}

- (void)setFailed:(BOOL)flag
{
	if ( flag )
	{
		[self changeState:IntentState_Failed];
	}
}

- (BOOL)cancelled
{
	return IntentState_Cancelled == _state ? YES : NO;
}

- (void)setCancelled:(BOOL)flag
{
	if ( flag )
	{
		[self changeState:IntentState_Cancelled];
	}
}

- (BOOL)changeState:(IntentState)newState
{
//	static const char * __states[] = {
//		"!Inited",
//		"!Arrived",
//		"!Succeed",
//		"!Failed",
//		"!Cancelled"
//	};

	if ( newState == _state )
		return NO;
	
	triggerBefore( self, stateChanged );
	
	PERF( @"Intent '%@', state %d -> %d", self.prettyName, _state, newState );

	_state = newState;

	if ( self.stateChanged )
	{
		((BlockTypeVarg)self.stateChanged)( self );
	}

	if ( IntentState_Arrived == _state )
	{
		[[SamuraiIntentBus sharedInstance] routes:self target:self.target];
	}
	else if ( IntentState_Succeed == _state )
	{
		[[SamuraiIntentBus sharedInstance] routes:self target:self.source];
	}
	else if ( IntentState_Failed == _state )
	{
		[[SamuraiIntentBus sharedInstance] routes:self target:self.source];
	}
	else if ( IntentState_Cancelled == _state )
	{
		[[SamuraiIntentBus sharedInstance] routes:self target:self.source];
	}

	triggerAfter( self, stateChanged );
	
	return YES;
}

#pragma mark -

- (NSMutableDictionary *)inputOrOutput
{
	if ( IntentState_Inited == _state )
	{
		if ( nil == self.input )
		{
			self.input = [NSMutableDictionary dictionary];
		}
		
		return self.input;
	}
	else
	{
		if ( nil == self.output )
		{
			self.output = [NSMutableDictionary dictionary];
		}
		
		return self.output;
	}
}

- (id)objectForKey:(id)key
{
	NSMutableDictionary * objects = [self inputOrOutput];
	return [objects objectForKey:key];
}

- (BOOL)hasObjectForKey:(id)key
{
	NSMutableDictionary * objects = [self inputOrOutput];
	return [objects objectForKey:key] ? YES : NO;
}

- (void)setObject:(id)value forKey:(id)key
{
	NSMutableDictionary * objects = [self inputOrOutput];
	[objects setObject:value forKey:key];
}

- (void)removeObjectForKey:(id)key
{
	NSMutableDictionary * objects = [self inputOrOutput];
	[objects removeObjectForKey:key];
}

- (void)removeAllObjects
{
	NSMutableDictionary * objects = [self inputOrOutput];
	[objects removeAllObjects];
}

- (id)objectForKeyedSubscript:(id)key;
{
	return [self objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key
{
	[self setObject:obj forKey:key];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, Intent )

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
