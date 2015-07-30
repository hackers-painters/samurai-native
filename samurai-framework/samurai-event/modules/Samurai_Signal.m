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

#import "Samurai_Signal.h"
#import "Samurai_SignalBus.h"

#import "_pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSObject(SignalResponder)

@def_prop_dynamic( SamuraiEventBlock,	onSignal );
@def_prop_dynamic( NSMutableArray *,	userResponders );

#pragma mark -

- (SamuraiSignalBlock)onSignal
{
	@weakify( self );
	
	SamuraiSignalBlock block = ^ NSObject * ( NSString * name, id signalBlock )
	{
		@strongify( self );
		
		name = [name stringByReplacingOccurrencesOfString:@"signal." withString:@"handleSignal____"];
		name = [name stringByReplacingOccurrencesOfString:@"signal____" withString:@"handleSignal____"];
		name = [name stringByReplacingOccurrencesOfString:@"-" withString:@"____"];
		name = [name stringByReplacingOccurrencesOfString:@"." withString:@"____"];
		name = [name stringByReplacingOccurrencesOfString:@"/" withString:@"____"];
		name = [name stringByAppendingString:@":"];

		if ( signalBlock )
		{
			[self addBlock:signalBlock forName:name];
		}
		else
		{
			[self removeBlockForName:name];
		}

		return self;
	};
	
	return [block copy];
}

#pragma mark -

- (id)signalResponders
{
	return [self userResponders];
}

- (id)signalAlias
{
	return nil;
}

- (NSString *)signalNamespace
{
	return NSStringFromClass([self class]);
}

- (NSString *)signalTag
{
	return nil;
}

- (NSString *)signalDescription
{
	return [NSString stringWithFormat:@"%@", [[self class] description]];
}

#pragma mark -

- (id)userRespondersOrCreate
{
	const char * storeKey = "NSObject.userResponders";
	
	NSMutableArray * responders = [self getAssociatedObjectForKey:storeKey];
	
	if ( nil == responders )
	{
		responders = [NSMutableArray nonRetainingArray];
		
		[self retainAssociatedObject:responders forKey:storeKey];
	}
	return responders;
}

- (NSMutableArray *)userResponders
{
	const char * storeKey = "NSObject.userResponders";
	
	return [self getAssociatedObjectForKey:storeKey];
}

#pragma mark -

- (BOOL)hasSignalResponder:(id)obj
{
	NSMutableArray * responders = [self userResponders];
	
	if ( nil == responders )
	{
		return NO;
	}

	for ( id responder in responders )
	{
		if ( responder == obj )
		{
			return YES;
		}
	}

	return NO;
}

- (void)addSignalResponder:(id)obj
{
	NSMutableArray * responders = [self userRespondersOrCreate];
	
	if ( responders && NO == [responders containsObject:obj] )
	{
		[responders addObject:obj];
	}
}

- (void)removeSignalResponder:(id)obj
{
	NSMutableArray * responders = [self userResponders];
	
	if ( responders && [responders containsObject:obj] )
	{
		[responders removeObject:obj];
	}
}

- (void)removeAllSignalResponders
{
	NSMutableArray * responders = [self userResponders];
	
	if ( responders )
	{
		[responders removeAllObjects];
	}
}

#pragma mark -

- (void)handleSignal:(SamuraiSignal *)that
{
	UNUSED( that );
}

@end

#pragma mark -

@implementation NSObject(SignalSender)

- (SamuraiSignal *)sendSignal:(NSString *)name
{
	return [self sendSignal:name from:self withObject:nil];
}

- (SamuraiSignal *)sendSignal:(NSString *)name withObject:(NSObject *)object
{
	return [self sendSignal:name from:self withObject:object];
}

- (SamuraiSignal *)sendSignal:(NSString *)name from:(id)source
{
	return [self sendSignal:name from:source withObject:nil];
}

- (SamuraiSignal *)sendSignal:(NSString *)name from:(id)source withObject:(NSObject *)object
{
	SamuraiSignal * signal = [SamuraiSignal signal];
	
	signal.source = source ? source : self;
	signal.target = self;
	signal.name = name;
	signal.object = object;
	
	[signal send];
	
	return signal;
}

@end

#pragma mark -

@implementation SamuraiSignal

@def_joint( stateChanged );

//@def_prop_unsafe( id,						foreign );
//@def_prop_strong( NSString *,				prefix );

@def_prop_unsafe( id,						source );
@def_prop_unsafe( id,						target );

@def_prop_copy( BlockType,					stateChanged );
@def_prop_assign( SignalState,				state );
@def_prop_dynamic( BOOL,					sending );
@def_prop_dynamic( BOOL,					arrived );
@def_prop_dynamic( BOOL,					dead );

@def_prop_assign( BOOL,						hit );
@def_prop_assign( NSUInteger,				hitCount );
@def_prop_dynamic( NSString *,				prettyName );

@def_prop_strong( NSString *,				name );
@def_prop_strong( id,						object );
@def_prop_strong( NSMutableDictionary *,	input );
@def_prop_strong( NSMutableDictionary *,	output );

@def_prop_assign( NSTimeInterval,			initTimeStamp );
@def_prop_assign( NSTimeInterval,			sendTimeStamp );
@def_prop_assign( NSTimeInterval,			arriveTimeStamp );

@def_prop_dynamic( NSTimeInterval,			timeElapsed );
@def_prop_dynamic( NSTimeInterval,			timeCostPending );
@def_prop_dynamic( NSTimeInterval,			timeCostExecution );

@def_prop_assign( NSInteger,				jumpCount );
@def_prop_strong( NSArray *,				jumpPath );

BASE_CLASS( SamuraiSignal )

#pragma mark -

+ (SamuraiSignal *)signal
{
	return [[SamuraiSignal alloc] init];
}

+ (SamuraiSignal *)signal:(NSString *)name
{
	SamuraiSignal * signal = [[SamuraiSignal alloc] init];
	signal.name = name;
	return signal;
}

- (id)init
{
	static NSUInteger __seed = 0;

	self = [super init];
	if ( self )
	{
		self.name = [NSString stringWithFormat:@"signal-%lu", (unsigned long)__seed++];

		_state = SignalState_Inited;

		_initTimeStamp = [NSDate timeIntervalSinceReferenceDate];
		_sendTimeStamp = _initTimeStamp;
		_arriveTimeStamp = _initTimeStamp;
	}
	return self;
}

- (void)dealloc
{
	self.jumpPath = nil;
	self.stateChanged = nil;

	self.name = nil;
//	self.prefix = nil;
	self.object = nil;
	
	self.input = nil;
	self.output = nil;
}

- (void)deepCopyFrom:(SamuraiSignal *)right
{
//	[super deepCopyFrom:right];
	
//	self.foreign			= right.foreign;
	self.source				= right.source;
	self.target				= right.target;
	
	self.state				= right.state;
	
	self.name				= [right.name copy];
//	self.prefix				= [right.prefix copy];
	self.object				= right.object;

	self.initTimeStamp		= right.initTimeStamp;
	self.sendTimeStamp		= right.sendTimeStamp;
	self.arriveTimeStamp	= right.arriveTimeStamp;
	
	self.jumpCount			= right.jumpCount;
	self.jumpPath			= [right.jumpPath mutableCopy];
}

- (NSString *)prettyName
{
//	NSString * name = [self.name stringByReplacingOccurrencesOfString:@"signal." withString:@""];
//	NSString * normalizedName = name;
//	normalizedName = [normalizedName stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
//	normalizedName = [normalizedName stringByReplacingOccurrencesOfString:@":" withString:@"_"];
//	return normalizedName;

	return self.name;
}

- (NSString *)description
{
#if __SAMURAI_DEBUG__
	return [NSString stringWithFormat:@"[%@] > %@", self.prettyName, [self.jumpPath join:@" > "]];
#else
	return self.name;
#endif
}

- (BOOL)is:(NSString *)name
{
	return [self.name isEqualToString:name];
}

- (BOOL)isSentFrom:(id)source
{
	return (self.source == source) ? YES : NO;
}

- (SignalState)state
{
	return _state;
}

- (void)setState:(SignalState)newState
{
	[self changeState:newState];
}

- (BOOL)sending
{
	return SignalState_Sending == _state ? YES : NO;
}

- (void)setSending:(BOOL)flag
{
	if ( flag )
	{
		[self changeState:SignalState_Sending];
	}
}

- (BOOL)arrived
{
	return SignalState_Arrived == _state ? YES : NO;
}

- (void)setArrived:(BOOL)flag
{
	if ( flag )
	{
		[self changeState:SignalState_Arrived];
	}
}

- (BOOL)dead
{
	return SignalState_Dead == _state ? YES : NO;
}

- (void)setDead:(BOOL)flag
{
	if ( flag )
	{
		[self changeState:SignalState_Dead];
	}
}

- (BOOL)changeState:(SignalState)newState
{
//	static const char * __states[] = {
//		"!Inited",
//		"!Sending",
//		"!Arrived",
//		"!Dead"
//	};
	
	if ( newState == _state )
		return NO;

	triggerBefore( self, stateChanged );

	PERF( @"Signal '%@', state %d -> %d", self.prettyName, _state, newState );

	_state = newState;

	if ( SignalState_Sending == _state )
	{
		_sendTimeStamp = [NSDate timeIntervalSinceReferenceDate];
	}
	else if ( SignalState_Arrived == _state )
	{
		_arriveTimeStamp = [NSDate timeIntervalSinceReferenceDate];
	}
	else if ( SignalState_Dead == _state )
	{
		_arriveTimeStamp = [NSDate timeIntervalSinceReferenceDate];
	}
	
	if ( self.stateChanged )
	{
		((BlockTypeVarg)self.stateChanged)( self );
	}

	triggerAfter( self, stateChanged );

	return YES;
}

- (BOOL)send
{
	@autoreleasepool
	{
		return [[SamuraiSignalBus sharedInstance] send:self];
	};
}

- (BOOL)forward
{
	@autoreleasepool
	{
		return [[SamuraiSignalBus sharedInstance] forward:self];
	};
}

- (BOOL)forward:(id)target
{
	@autoreleasepool
	{
		return [[SamuraiSignalBus sharedInstance] forward:self to:target];
	};
}

- (NSTimeInterval)timeElapsed
{
	return _arriveTimeStamp - _initTimeStamp;
}

- (NSTimeInterval)timeCostPending
{
	return _sendTimeStamp - _initTimeStamp;
}

- (NSTimeInterval)timeCostExecution
{
	return _arriveTimeStamp - _sendTimeStamp;
}

- (void)log:(id)target
{
	if ( self.arrived || self.dead )
		return;

#if __SAMURAI_DEBUG__
	if ( target )
	{
		if ( nil == self.jumpPath )
		{
			self.jumpPath = [[NSMutableArray alloc] init];
		}

		[self.jumpPath addObject:[target signalDescription]];
	}
#endif

	_jumpCount += 1;
}

#pragma mark -

- (NSMutableDictionary *)inputOrOutput
{
	if ( SignalState_Inited == _state )
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

static NSInteger __value = 0;

@interface __TestSignal : NSObject

@signal( TEST )

@end

@interface __TestSignal2 : __TestSignal
@end
@interface __TestSignal3 : __TestSignal2
@end

@implementation __TestSignal

@def_signal( TEST )

handleSignal( __TestSignal )
{
	UNUSED( signal );
	
	__value += 1;
}

handleSignal( __TestSignal, TEST )
{
	UNUSED( signal );
	
	__value += 1;
}

@end

@implementation __TestSignal2

handleSignal( __TestSignal, TEST )
{
	UNUSED( signal );
	
	__value += 1;
}

@end

@implementation __TestSignal3

handleSignal( __TestSignal, TEST )
{
	UNUSED( signal );
	
	__value += 1;
}

@end

TEST_CASE( Event, Signal )
{
}

DESCRIBE( before )
{
	EXPECTED( 0 == __value );
}

DESCRIBE( Send signal )
{
	__TestSignal3 * obj = [[__TestSignal3 alloc] init];
	
	EXPECTED( 0 == __value );
	
	TIMES( 100 )
	{
		[obj sendSignal:__TestSignal.TEST];
	}
	
	EXPECTED( 100 == __value );
	
	TIMES( 100 )
	{
		[obj sendSignal:__TestSignal.TEST];
	}
	
	EXPECTED( 200 == __value );
}

DESCRIBE( Handle signal )
{
	TIMES( 100 )
	{
		__block BOOL block1Executed = NO;
		__block BOOL block2Executed = NO;
		
		self.onSignal( __TestSignal.TEST, ^( SamuraiSignal * signal ){
			UNUSED( signal );
			block1Executed = YES;
		});

		self.onSignal( makeSignal(__TestSignal,xxx,yyy), ^( SamuraiSignal * signal ){
			UNUSED( signal );
			block2Executed = YES;
		});

		[self sendSignal:__TestSignal.TEST];
		[self sendSignal:makeSignal(__TestSignal,xxx,yyy)];

		EXPECTED( block1Executed == YES );
		EXPECTED( block2Executed == YES );
	}
}

DESCRIBE( after )
{
	
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#import "_pragma_pop.h"
