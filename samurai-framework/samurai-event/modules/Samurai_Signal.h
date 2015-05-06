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

#import "Samurai_Core.h"
#import "Samurai_EventConfig.h"

#pragma mark -

#undef	signal
#define signal( name ) \
		static_property( name )

#undef	def_signal
#define def_signal( name ) \
		def_static_property2( name, @"signal", NSStringFromClass([self class]) )

#undef	def_signal_alias
#define def_signal_alias( name, alias ) \
		alias_static_property( name, alias )

#undef	makeSignal
#define	makeSignal( ... ) \
		macro_string( macro_join(signal, __VA_ARGS__) )

#undef	handleSignal
#define	handleSignal( ... ) \
		- (void) macro_join( handleSignal, __VA_ARGS__):(SamuraiSignal *)signal

#pragma mark -

typedef NSObject *	(^ SamuraiSignalBlock )( NSString * name, id object );

#pragma mark -

typedef enum
{
	SignalState_Inited = 0,
	SignalState_Sending,
	SignalState_Arrived,
	SignalState_Dead
} SignalState;

#pragma mark -

@class SamuraiSignal;

@interface NSObject(SignalResponder)

@prop_readonly( SamuraiSignalBlock, onSignal );
@prop_readonly( NSMutableArray *,	userResponders );

- (id)signalResponders;				// override point
- (id)signalAlias;					// override point
- (NSString *)signalNamespace;		// override point
- (NSString *)signalTag;			// override point
- (NSString *)signalDescription;	// override point

- (BOOL)hasSignalResponder:(id)obj;
- (void)addSignalResponder:(id)obj;
- (void)removeSignalResponder:(id)obj;
- (void)removeAllSignalResponders;

- (void)handleSignal:(SamuraiSignal *)that;

@end

#pragma mark -

@interface NSObject(SignalSender)

- (SamuraiSignal *)sendSignal:(NSString *)name;
- (SamuraiSignal *)sendSignal:(NSString *)name withObject:(NSObject *)object;
- (SamuraiSignal *)sendSignal:(NSString *)name from:(id)source;
- (SamuraiSignal *)sendSignal:(NSString *)name from:(id)source withObject:(NSObject *)object;

@end

#pragma mark -

@interface SamuraiSignal : NSObject<NSDictionaryProtocol, NSMutableDictionaryProtocol>

@joint( stateChanged );

//@prop_unsafe( id,						foreign );
//@prop_strong( NSString *,				prefix );

@prop_unsafe( id,						source );
@prop_unsafe( id,						target );

@prop_copy( BlockType,					stateChanged );
@prop_assign( SignalState,				state );
@prop_assign( BOOL,						sending );
@prop_assign( BOOL,						arrived );
@prop_assign( BOOL,						dead );

@prop_assign( BOOL,						hit );
@prop_assign( NSUInteger,				hitCount );
@prop_readonly( NSString *,				prettyName );

@prop_strong( NSString *,				name );
@prop_strong( id,						object );
@prop_strong( NSMutableDictionary *,	input );
@prop_strong( NSMutableDictionary *,	output );

@prop_assign( NSTimeInterval,			initTimeStamp );
@prop_assign( NSTimeInterval,			sendTimeStamp );
@prop_assign( NSTimeInterval,			arriveTimeStamp );

@prop_readonly( NSTimeInterval,			timeElapsed );
@prop_readonly( NSTimeInterval,			timeCostPending );
@prop_readonly( NSTimeInterval,			timeCostExecution );

@prop_assign( NSInteger,				jumpCount );
@prop_strong( NSMutableArray *,			jumpPath );

+ (SamuraiSignal *)signal;
+ (SamuraiSignal *)signal:(NSString *)name;

- (BOOL)is:(NSString *)name;

- (BOOL)send;
- (BOOL)forward;
- (BOOL)forward:(id)target;

- (void)log:(id)source;

- (BOOL)changeState:(SignalState)newState;

@end
