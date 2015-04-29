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

#import "Samurai_SignalKVO.h"
#import "Samurai_SignalBus.h"
#import "Samurai_Signal.h"

#import "_pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiKVObserver
{
	NSMutableDictionary * _properties;
}

@def_prop_unsafe( id, source );

- (id)init
{
	self = [super init];
	if ( self )
	{
		_properties = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[self unobserveAllProperties];
	
	[_properties removeAllObjects];
	_properties = nil;
}

- (void)observeProperty:(NSString *)property
{
	if ( nil == property )
		return;
	
	if ( [_properties objectForKey:property] )
		return;

	NSKeyValueObservingOptions options = 0;

	NSArray * observerValues = [self.source extentionForProperty:property arrayValueWithKey:@"Observer"];
	
	if ( observerValues )
	{
		for ( NSString * value in observerValues )
		{
			if ( [value isEqualToString:@"old"] )
			{
				options |= NSKeyValueObservingOptionOld;
			}
			else if ( [value isEqualToString:@"new"] )
			{
				options |= NSKeyValueObservingOptionOld;
			}
		}
	}
	
	if ( 0 == options )
	{
		options = NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew;
	}

	[self.source addObserver:self forKeyPath:property options:options context:NULL];

	[_properties setObject:[NSNumber numberWithInt:(int)options] forKey:property];
}

- (void)unobserveProperty:(NSString *)property
{
	if ( [_properties objectForKey:property] )
	{
		[self.source removeObserver:self forKeyPath:property];
		
		[_properties removeObjectForKey:property];
	}
}

- (void)unobserveAllProperties
{
	for ( NSString * property in _properties.allKeys )
	{
		[self.source removeObserver:self forKeyPath:property];
	}

	[_properties removeAllObjects];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	NSObject * oldValue = [change objectForKey:@"old"];
	NSObject * newValue = [change objectForKey:@"new"];
	
	if ( oldValue )
	{
		SamuraiSignal * signal = [SamuraiSignal signal];
		
		signal.name = [NSString stringWithFormat:@"signal.%@.%@.valueChanging", [[object class] description], keyPath];
		signal.source = object;
		signal.target = self.source;
		signal.object = [oldValue isKindOfClass:[NSNull class]] ? nil : oldValue;
		
		[signal send];
	}
	
	if ( newValue )
	{
		SamuraiSignal * signal = [SamuraiSignal signal];

		signal.name = [NSString stringWithFormat:@"signal.%@.%@.valueChanged", [[object class] description], keyPath];
		signal.source = object;
		signal.target = self.source;
		signal.object = [newValue isKindOfClass:[NSNull class]] ? nil : newValue;

		[signal send];
	}
}

@end

#pragma mark -

@implementation NSObject(KVObserver)

@def_prop_dynamic( SamuraiKVOBlock, onValueChanging );
@def_prop_dynamic( SamuraiKVOBlock, onValueChanged );

- (SamuraiKVObserver *)KVObserverOrCreate
{
	SamuraiKVObserver * observer = [self getAssociatedObjectForKey:"KVObserver"];
	
	if ( nil == observer )
	{
		observer = [[SamuraiKVObserver alloc] init];
		observer.source = self;
		
		[self retainAssociatedObject:observer forKey:"KVObserver"];
	}
	
	return observer;
}

- (SamuraiKVObserver *)KVObserver
{
	return [self getAssociatedObjectForKey:"KVObserver"];
}

#pragma mark -

- (SamuraiKVOBlock)onValueChanging
{
	@weakify( self );
	
	SamuraiKVOBlock block = ^ NSObject * ( id nameOrObject, id propertyOrBlock, ... )
	{
		@strongify( self );

		EncodingType encoding = [SamuraiEncoding typeOfObject:nameOrObject];

		if ( EncodingType_String == encoding )
		{
			NSString * name = nameOrObject;

			ASSERT( nil != name );
			
			name = [name stringByReplacingOccurrencesOfString:@"signal." withString:@"handleSignal____"];
			name = [name stringByReplacingOccurrencesOfString:@"signal____" withString:@"handleSignal____"];
			name = [name stringByReplacingOccurrencesOfString:@"-" withString:@"____"];
			name = [name stringByReplacingOccurrencesOfString:@"." withString:@"____"];
			name = [name stringByReplacingOccurrencesOfString:@"/" withString:@"____"];
			name = [name stringByAppendingString:@"____valueChanging:"];
			
			if ( propertyOrBlock )
			{
				[self addBlock:propertyOrBlock forName:name];
			}
			else
			{
				[self removeBlockForName:name];
			}
		}
		else
		{
			va_list args;
			va_start( args, propertyOrBlock );
			
			NSObject *	object = (NSObject *)nameOrObject;
			NSString *	property = (NSString *)propertyOrBlock;
			
			ASSERT( nil != object );
			ASSERT( nil != property );

			[object observeProperty:property];
			[object addSignalResponder:self];
			
			NSString *	signalName = [NSString stringWithFormat:@"handleSignal____%@____%@____valueChanging:", [[object class] description], property ];
			id			signalBlock = va_arg( args, id );

			if ( signalBlock )
			{
				[self addBlock:signalBlock forName:signalName];
			}
			else
			{
				[self removeBlockForName:signalName];
			}
		}

		return self;
	};
	
	return [block copy];
}

- (SamuraiKVOBlock)onValueChanged
{
	@weakify( self );
	
	SamuraiKVOBlock block = ^ NSObject * ( id nameOrObject, id propertyOrBlock, ... )
	{
		@strongify( self );
		
		EncodingType encoding = [SamuraiEncoding typeOfObject:nameOrObject];
		if ( EncodingType_String == encoding )
		{
			NSString * name = nameOrObject;
			
			ASSERT( nil != name );
			
			name = [name stringByReplacingOccurrencesOfString:@"signal." withString:@"handleSignal____"];
			name = [name stringByReplacingOccurrencesOfString:@"signal____" withString:@"handleSignal____"];
			name = [name stringByReplacingOccurrencesOfString:@"-" withString:@"____"];
			name = [name stringByReplacingOccurrencesOfString:@"." withString:@"____"];
			name = [name stringByReplacingOccurrencesOfString:@"/" withString:@"____"];
			name = [name stringByAppendingString:@"____valueChanged:"];
			
			if ( propertyOrBlock )
			{
				[self addBlock:propertyOrBlock forName:name];
			}
			else
			{
				[self removeBlockForName:name];
			}
		}
		else
		{
			va_list args;
			va_start( args, propertyOrBlock );
			
			NSObject *	object = (NSObject *)nameOrObject;
			NSString *	property = (NSString *)propertyOrBlock;
			
			ASSERT( nil != object );
			ASSERT( nil != property );
			
			[object observeProperty:property];
			[object addSignalResponder:self];
			
			NSString *	signalName = [NSString stringWithFormat:@"handleSignal____%@____%@____valueChanged:", [[object class] description], property ];
			id			signalBlock = va_arg( args, id );

			if ( signalBlock )
			{
				[self addBlock:signalBlock forName:signalName];
			}
			else
			{
				[self removeBlockForName:signalName];
			}
		}
		
		return self;
	};
	
	return [block copy];
}

#pragma mark -

- (void)observeProperty:(NSString *)property
{
	SamuraiKVObserver * observer = [self KVObserverOrCreate];
	if ( observer )
	{
		[observer observeProperty:property];
	}
}

- (void)unobserveProperty:(NSString *)property
{
	SamuraiKVObserver * observer = [self KVObserver];
	if ( observer )
	{
		[observer unobserveProperty:property];
	}
}

- (void)unobserveAllProperties
{
	SamuraiKVObserver * observer = [self getAssociatedObjectForKey:"KVObserver"];
	
	if ( observer )
	{
		[observer unobserveAllProperties];
		
		[self removeAssociatedObjectForKey:"KVObserver"];
	}
}

- (void)signalValueChanging:(NSString *)property
{
	[self signalValueChanging:property value:nil];
}

- (void)signalValueChanging:(NSString *)property value:(id)value
{
	SamuraiSignal * signal = [SamuraiSignal signal];
	
	signal.name = [NSString stringWithFormat:@"signal.%@.%@.valueChanging", [[self class] description], property];
	signal.source = self;
	signal.target = self;
	signal.object = [value isKindOfClass:[NSNull class]] ? nil : value;
	
	[signal send];
}

- (void)signalValueChanged:(NSString *)property
{
	[self signalValueChanged:property value:nil];
}

- (void)signalValueChanged:(NSString *)property value:(id)value
{
	SamuraiSignal * signal = [SamuraiSignal signal];
	
	signal.name = [NSString stringWithFormat:@"signal.%@.%@.valueChanged", [[self class] description], property];
	signal.source = self;
	signal.target = self;
	signal.object = [value isKindOfClass:[NSNull class]] ? nil : value;
	
	[signal send];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

static int __value = 0;
static int __value2 = 0;

@interface __TestKVObject : NSObject

@prop_strong( NSString *,			text );
@prop_strong( NSArray *,			array );
@prop_strong( NSDictionary *,		dict );

@end

@implementation __TestKVObject

@def_prop_strong( NSString *,		text );
@def_prop_strong( NSArray *,		array );
@def_prop_strong( NSDictionary *,	dict );

@end

@interface __TestKVObserver : NSObject
@end

@implementation __TestKVObserver
@end

TEST_CASE( Event, KVObserver )
{
}

DESCRIBE( before )
{
}

DESCRIBE( Manually )
{
	@autoreleasepool
	{
		__TestKVObject *	object = [[__TestKVObject alloc] init];
		__TestKVObserver *	observer = [[__TestKVObserver alloc] init];
		
		[object observeProperty:@"text"];
		[object observeProperty:@"array"];
		[object observeProperty:@"dict"];
		[object addSignalResponder:observer];
		
		observer
		
		.onValueChanging( makeSignal(__TestKVObject, text),	^{ __value += 1; })
		.onValueChanging( makeSignal(__TestKVObject, array),	^{ __value += 1; })
		.onValueChanging( makeSignal(__TestKVObject, dict),	^{ __value += 1; })
		
		.onValueChanged( makeSignal(__TestKVObject, text),	^{ __value += 1; })
		.onValueChanged( makeSignal(__TestKVObject, array),	^{ __value += 1; })
		.onValueChanged( makeSignal(__TestKVObject, dict),	^{ __value += 1; });

		object.text = @"123";
		object.array = @[];
		object.dict = @{};
		
		EXPECTED( 6 == __value );

		[object unobserveAllProperties];
	};
}

DESCRIBE( Automatic )
{
	@autoreleasepool
	{
		__TestKVObject *	object = [[__TestKVObject alloc] init];
		__TestKVObserver *	observer = [[__TestKVObserver alloc] init];

		observer
		
		.onValueChanging( object, @"text",	^{ __value2 += 1; })
		.onValueChanging( object, @"array",	^{ __value2 += 1; })
		.onValueChanging( object, @"dict",	^{ __value2 += 1; })
		
		.onValueChanged( object, @"text",	^{ __value2 += 1; })
		.onValueChanged( object, @"array",	^{ __value2 += 1; })
		.onValueChanged( object, @"dict",	^{ __value2 += 1; });

		object.text = @"123";
		object.array = @[];
		object.dict = @{};
		
		EXPECTED( 6 == __value2 );
		
		[object unobserveAllProperties];
	};
}

DESCRIBE( after )
{
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#import "_pragma_pop.h"
