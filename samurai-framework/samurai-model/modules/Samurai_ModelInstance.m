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

#import "Samurai_ModelInstance.h"
#import "Samurai_ModelManager.h"

#import "_pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#import "Samurai_ModelManager.h"

#pragma mark -

@implementation SamuraiModel

BASE_CLASS( SamuraiModel )

+ (instancetype)model
{
	return [[self alloc] init];
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		[[SamuraiModelManager sharedInstance] addModel:self];

	//	[self modelLoad];
	}
	return self;
}

- (void)dealloc
{
//	[self modelSave];
	
	[[SamuraiModelManager sharedInstance] removeModel:self];
}

#pragma mark -

- (id)valueForUndefinedKey:(NSString *)key
{
	UNUSED( key )
	
	return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
	UNUSED( value )
	
	ERROR( @"undefined key '%@'", key );
}

#pragma mark -

- (BOOL)hasObjectForKey:(id)key
{
	return [self objectForKey:key] ? YES : NO;
}

- (id)objectForKey:(id)key
{
	INFO( @"Model '%p', read '%@'", self, key );
	
	Class baseClass = [[self class] baseClass];
	if ( nil == baseClass )
	{
		baseClass = [NSObject class];
	}
	
	id result = nil;
	
	for ( Class clazzType = [self class]; clazzType != baseClass; )
	{
		objc_property_t prop = class_getProperty( clazzType, [key UTF8String] );
		if ( prop )
		{
			result = [self valueForKey:key];
			
			free( prop );
			break;
		}
	}

	return result;
}

- (void)setObject:(id)object forKey:(id)key
{
	if ( nil == key || nil == object )
		return;
	
	INFO( @"Model '%p', write '%@'", self, key );

	Class baseClass = [[self class] baseClass];
	if ( nil == baseClass )
	{
		baseClass = [NSObject class];
	}
	
	BOOL changed = NO;
	
	for ( Class clazzType = [self class]; clazzType != baseClass; )
	{
		objc_property_t prop = class_getProperty( clazzType, [key UTF8String] );
		if ( prop )
		{
			const char * attr = property_getAttributes( prop );
			if ( attr )
			{
				if ( NO == [SamuraiEncoding isReadOnly:attr] )
				{
					[self setValue:object forKey:key];
					
					changed = YES;
				}
			}

			free( prop );
			break;
		}
	}

	if ( changed )
	{
	//	[self modelSave];
	}
}

- (void)removeObjectForKey:(NSString *)key
{
	INFO( @"Model '%p', remove '%@'", self, key );
	
	Class baseClass = [[self class] baseClass];
	if ( nil == baseClass )
	{
		baseClass = [NSObject class];
	}
	
	BOOL changed = NO;

	for ( Class clazzType = [self class]; clazzType != baseClass; )
	{
		objc_property_t prop = class_getProperty( clazzType, [key UTF8String] );
		if ( prop )
		{
			const char * attr = property_getAttributes( prop );
			if ( attr )
			{
				if ( NO == [SamuraiEncoding isReadOnly:attr] )
				{
					[self setValue:nil forKey:key];
					
					changed = YES;
				}
			}

			free( prop );
			break;
		}
	}

	if ( changed )
	{
	//	[self modelSave];
	}
}

- (void)removeAllObjects
{
	[self modelClear];
}

#pragma mark -

- (id)objectForKeyedSubscript:(id)key
{
	return [self objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key
{
	[self setObject:obj forKey:key];
}

#pragma mark -

- (void)modelLoad
{
}

- (void)modelSave
{
}

- (void)modelClear
{
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

@interface __TestModel : SamuraiModel

@prop_strong( NSNumber *,			number );
@prop_strong( NSArray *,			array );
@prop_strong( NSDictionary *,		dict );

@singleton( __TestModel )

@end

@implementation __TestModel

@def_prop_strong( NSNumber *,		number,	Policy => save|load|clear );
@def_prop_strong( NSArray *,		array,	Policy => save|load|clear,	Class => NSNumber );
@def_prop_strong( NSDictionary *,	dict,	Policy => save|load|clear );

@def_singleton( __TestModel )

@end

TEST_CASE( Model, ModelInstance )

DESCRIBE( becore )
{
}

DESCRIBE( test )
{
	@autoreleasepool
	{
		__TestModel * model = [[__TestModel alloc] init];
		
		[model modelClear];
		
		model.number = @1;
		model.array = @[@1, @2, @3];
		model.dict = @{ @"hello": @"world" };

		[model modelSave];
	}
}
	
DESCRIBE( after )
{
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#import "_pragma_pop.h"
