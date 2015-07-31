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
#import "Samurai_Event.h"
#import "Samurai_ViewConfig.h"

#import "Samurai_ViewCore.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

#undef	intent
#define intent( name ) \
		static_property( name )

#undef	def_intent
#define def_intent( name ) \
		def_static_property2( name, @"intent", NSStringFromClass([self class]) )

#undef	def_intent_alias
#define def_intent_alias( name, alias ) \
		alias_static_property( name, alias )

#undef	makeIntent
#define	makeIntent( ... ) \
		macro_string( macro_join(intent, __VA_ARGS__) )

#undef	handleIntent
#define	handleIntent( ... ) \
		- (void) macro_join( handleIntent, __VA_ARGS__):(SamuraiIntent *)intent

#pragma mark -

typedef NSObject *	(^ SamuraiIntentObserverBlock )( NSString * name, id object );

#pragma mark -

typedef enum
{
	IntentState_Inited = 0,
	IntentState_Arrived,
	IntentState_Succeed,
	IntentState_Failed,
	IntentState_Cancelled
} IntentState;

#pragma mark -

@class SamuraiIntent;

@interface NSObject(IntentResponder)

@prop_readonly( SamuraiIntentObserverBlock, onIntent );

- (void)handleIntent:(SamuraiIntent *)that;

@end

#pragma mark -

@interface SamuraiIntent : NSObject<NSDictionaryProtocol, NSMutableDictionaryProtocol>

@joint( stateChanged );

@prop_strong( NSString *,					action );
@prop_strong( NSMutableDictionary *,		input );
@prop_strong( NSMutableDictionary *,		output );

@prop_unsafe( id,							source );
@prop_unsafe( id,							target );

@prop_copy( BlockType,						stateChanged );
@prop_assign( IntentState,					state );
@prop_assign( BOOL,							arrived );
@prop_assign( BOOL,							succeed );
@prop_assign( BOOL,							failed );
@prop_assign( BOOL,							cancelled );

+ (SamuraiIntent *)intent;
+ (SamuraiIntent *)intent:(NSString *)name;
+ (SamuraiIntent *)intent:(NSString *)name params:(NSDictionary *)params;

- (BOOL)is:(NSString *)name;

- (BOOL)changeState:(IntentState)newState;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
