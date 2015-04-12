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

@implementation NSObject(Model)

hookBefore( load, Model )
{
	if ( [self conformsToProtocol:@protocol(ManagedModel)] )
	{
		Class baseClass = [[self class] baseClass];
		if ( nil == baseClass )
		{
			baseClass = [NSObject class];
		}

		for ( Class clazzType = [self class]; clazzType != baseClass; )
		{
			unsigned int		propertyCount = 0;
			objc_property_t *	properties = class_copyPropertyList( clazzType, &propertyCount );
			
			for ( NSUInteger i = 0; i < propertyCount; i++ )
			{
				const char *	name = property_getName(properties[i]);
				const char *	attr = property_getAttributes(properties[i]);
				NSString *		propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];

				if ( [SamuraiEncoding isReadOnly:attr] )
					continue;

				Class fieldClass = [SamuraiEncoding classOfAttribute:attr];
				if ( [fieldClass isSubclassOfClass:[SamuraiModel class]] )
				{
					SamuraiModel * instance = nil;
					
					BOOL isNewInstance = NO;
					BOOL isSharedInstance = NO;

					NSArray * policyValues = [clazzType extentionForProperty:propertyName arrayValueWithKey:@"Policy"];
					
					if ( policyValues )
					{
						for ( NSString * policyValue in policyValues )
						{
							if ( NSOrderedSame == [policyValue compare:@"new" options:NSCaseInsensitiveSearch] )
							{
								isNewInstance = YES;
							}
							else if ( NSOrderedSame == [policyValue compare:@"share" options:NSCaseInsensitiveSearch] )
							{
								isSharedInstance = YES;
							}
						}
					}
					
					if ( isNewInstance )
					{
						instance = [[fieldClass alloc] init];
					}
					else if ( isSharedInstance )
					{
						instance = [fieldClass sharedInstance];
					}
					else
					{
						instance = [fieldClass sharedInstance];

						if ( nil == instance )
						{
							instance = [[fieldClass alloc] init];
						}
					}

					if ( instance )
					{
						[self setValue:instance forKey:propertyName];

						[instance addSignalResponder:self];
					}
				}
			}
			
			free( properties );
			
			clazzType = class_getSuperclass( clazzType );
			if ( nil == clazzType )
				break;
		}
	}
}

hookAfter( unload, Model )
{
	if ( [self conformsToProtocol:@protocol(ManagedModel)] )
	{
		Class baseClass = [[self class] baseClass];
		if ( nil == baseClass )
		{
			baseClass = [NSObject class];
		}

		for ( Class clazzType = [self class]; clazzType != baseClass; )
		{
			unsigned int		propertyCount = 0;
			objc_property_t *	properties = class_copyPropertyList( clazzType, &propertyCount );
			
			for ( NSUInteger i = 0; i < propertyCount; i++ )
			{
				const char *	name = property_getName(properties[i]);
				const char *	attr = property_getAttributes(properties[i]);
				NSString *		propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
				
				if ( [SamuraiEncoding isReadOnly:attr] )
					continue;

				Class fieldClass = [SamuraiEncoding classOfAttribute:attr];
				if ( [fieldClass isSubclassOfClass:[SamuraiModel class]] )
				{
					SamuraiModel * instance = [self valueForKey:propertyName];
					if ( instance )
					{
						[instance removeSignalResponder:self];

						[self setValue:nil forKey:propertyName];
					}
				}
			}

			free( properties );

			clazzType = class_getSuperclass( clazzType );
			if ( nil == clazzType )
				break;
		}
	}
}

@end

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

@interface __TestMyClass : NSObject<ManagedObject, ManagedModel>

@model( __TestModel *, model1 );
@model( __TestModel *, model2 );

@end

@implementation __TestMyClass

@def_model( __TestModel *, model1, Policy => new );
@def_model( __TestModel *, model2, Policy => share );

@end

TEST_CASE( Model, ModelInstance )
{
	
}

DESCRIBE( test1 )
{
	@autoreleasepool
	{
		__TestMyClass * test = [[__TestMyClass alloc] init];
		
		EXPECTED( nil != test.model1 );
		EXPECTED( nil != test.model2 );
		EXPECTED( YES == [test.model1 hasSignalResponder:test] );
		EXPECTED( YES == [test.model2 hasSignalResponder:test] );
		
		EXPECTED( test.model1 != test.model2 );
	}
}

DESCRIBE( test2 )
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
	
DESCRIBE( test3 )
{
//	__TestModel * model = [[__TestModel alloc] init];
//	
//	[model modelLoad];
//	
//	EXPECTED( [model.number isEqualToNumber:@1] );
//	EXPECTED( [model.array[0] isEqualToNumber:@1] );
//	EXPECTED( [model.array[1] isEqualToNumber:@2] );
//	EXPECTED( [model.array[2] isEqualToNumber:@3] );
//	EXPECTED( [model.dict[@"hello"] isEqualToString:@"world"] );
//	
//	[model modelClear];
//	
//	EXPECTED( nil == model.number );
//	EXPECTED( nil == model.array );
//	EXPECTED( nil == model.dict );
//	
//	[model modelLoad];
//	
//	EXPECTED( nil == model.number );
//	EXPECTED( nil == model.array );
//	EXPECTED( nil == model.dict );
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#import "_pragma_pop.h"
