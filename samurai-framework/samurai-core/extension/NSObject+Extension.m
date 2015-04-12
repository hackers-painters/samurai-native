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

#import "NSObject+Extension.h"
#import "NSDate+Extension.h"
#import "NSObject+Extension.h"
#import "NSDictionary+Extension.h"
#import "NSMutableDictionary+Extension.h"

#import "Samurai_Encoding.h"
#import "Samurai_Log.h"
#import "Samurai_UnitTest.h"

#import "_pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSObject(Extension)

+ (Class)baseClass
{
	return [NSObject class];
}

+ (id)unserializeForUnknownValue:(id)value
{
	UNUSED( value )
	
	return nil;
}

+ (id)serializeForUnknownValue:(id)value
{
	UNUSED( value )
	
	return nil;
}

- (void)deepEqualsTo:(id)obj
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
			
			if ( [SamuraiEncoding isReadOnly:attr] )
			{
				continue;
			}
			
			NSString * propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
			NSObject * propertyValue = [obj valueForKey:propertyName];

			[self setValue:propertyValue forKey:propertyName];
		}
		
		free( properties );
		
		clazzType = class_getSuperclass( clazzType );
		if ( nil == clazzType )
			break;
	}
}

- (void)deepCopyFrom:(id)obj
{
	if ( nil == obj )
	{
		return;
	}
	
	Class baseClass = [[obj class] baseClass];
	if ( nil == baseClass )
	{
		baseClass = [NSObject class];
	}
	
	for ( Class clazzType = [obj class]; clazzType != baseClass; )
	{
		unsigned int		propertyCount = 0;
		objc_property_t *	properties = class_copyPropertyList( clazzType, &propertyCount );
		
		for ( NSUInteger i = 0; i < propertyCount; i++ )
		{
			const char *	name = property_getName(properties[i]);
			const char *	attr = property_getAttributes(properties[i]);
			
			if ( [SamuraiEncoding isReadOnly:attr] )
			{
				continue;
			}
			
			NSString * propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
			NSObject * propertyValue = [obj valueForKey:propertyName];
			
			[self setValue:propertyValue forKey:propertyName];
		}
		
		free( properties );
		
		clazzType = class_getSuperclass( clazzType );
		if ( nil == clazzType )
			break;
	}
}

+ (id)unserialize:(id)obj
{
	return [self unserialize:obj withClass:self];
}

+ (id)unserialize:(id)obj withClass:(Class)clazz
{
	if ( nil == obj )
	{
		return nil;
	}
	
	if ( nil == clazz )
	{
		return obj;
	}
	else if ( [obj isKindOfClass:clazz] )
	{
		return obj;
	}
	
	EncodingType type = [SamuraiEncoding typeOfObject:obj];
	
	if ( EncodingType_Array == type )
	{
		NSMutableArray * result = [NSMutableArray array];
		
		for ( id elem in (NSArray *)obj )
		{
			id subResult = [self unserialize:elem withClass:clazz];
			if ( subResult )
			{
				[result addObject:subResult];
			}
		}
		
		return result;
	}
	else if ( EncodingType_Dict == type )
	{
		NSDictionary * dict = (NSDictionary *)obj;
		if ( 0 == dict.count )
		{
			return nil;
		}
		
		id result = [[clazz alloc] init];
		if ( nil == result )
		{
			return nil;
		}
		
		Class baseClass = [[obj class] baseClass];
		if ( nil == baseClass )
		{
			baseClass = [NSObject class];
		}
		
		for ( Class clazzType = clazz; clazzType != baseClass; )
		{
			if ( [SamuraiEncoding isAtomClass:clazzType] )
			{
				break;
			}
			
			unsigned int		propertyCount = 0;
			objc_property_t *	properties = class_copyPropertyList( clazzType, &propertyCount );
			
			for ( NSUInteger i = 0; i < propertyCount; i++ )
			{
				const char *	name = property_getName(properties[i]);
				const char *	attr = property_getAttributes(properties[i]);
				
				BOOL readonly = [SamuraiEncoding isReadOnly:attr];
				if ( readonly )
					continue;
				
				NSString *	propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
				NSObject *	tempValue = [dict objectForKey:propertyName];
				NSObject *	value = nil;

				if ( tempValue )
				{
					NSInteger propertyType = [SamuraiEncoding typeOfAttribute:attr];
					
					if ( EncodingType_Null == propertyType )
					{
						value = nil;
					}
					else if ( EncodingType_Number == propertyType )
					{
						value = [tempValue toNumber];
					}
					else if ( EncodingType_String == propertyType )
					{
						value = [tempValue toString];
					}
					else if ( EncodingType_Array == propertyType )
					{
						value = tempValue;
						
						__autoreleasing Class convertClass = nil;

						if ( nil == convertClass )
						{
							SEL convertSelector = NSSelectorFromString( [NSString stringWithFormat:@"convertClass_%@", propertyName] );
							if ( [clazz respondsToSelector:convertSelector] )
							{
//								convertClass = [clazz performSelector:convertSelector];

								NSMethodSignature * signature = [clazz methodSignatureForSelector:convertSelector];
								NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];
								
								[invocation setTarget:clazz];
								[invocation setSelector:convertSelector];
								[invocation invoke];
								[invocation getReturnValue:&convertClass];
							}
						}

						if ( nil == convertClass )
						{
							NSString * convertClassName = [clazzType extentionForProperty:propertyName stringValueWithKey:@"Class"];
							if ( convertClassName )
							{
								convertClass = NSClassFromString( convertClassName );
							}
						}

						if ( convertClass )
						{
							NSMutableArray * arrayTemp = [NSMutableArray array];
							
							for ( NSObject * tempObject in (NSArray *)tempValue )
							{
								id elem = [convertClass unserialize:tempObject];
								if ( elem )
								{
									[arrayTemp addObject:elem];
								}
							}
							
							value = arrayTemp;
						}
					}
					else if ( EncodingType_Dict == propertyType )
					{
						value = tempValue;
					}
					else if ( EncodingType_Date == propertyType )
					{
						value = [tempValue toDate];
					}
					else if ( EncodingType_Data == propertyType )
					{
						value = [tempValue toData];
					}
					else if ( EncodingType_Url == propertyType )
					{
						value = [tempValue toURL];
					}
					else
					{
						Class classType = [SamuraiEncoding classOfAttribute:attr];
						if ( classType )
						{
							if ( [tempValue isKindOfClass:classType] )
							{
								value = tempValue;
							}
							else
							{
								value = [classType unserialize:tempValue];
								if ( nil == value )
								{
									value = [classType unserializeForUnknownValue:tempValue];
								}
							}
						}
					}
				}
				
				NSArray * policyValues = [clazzType extentionForProperty:propertyName arrayValueWithKey:@"Policy"];

				if ( policyValues )
				{
					BOOL isSave = NO;
					BOOL isLoad = NO;
					BOOL isClear = NO;

					for ( NSString * policyValue in policyValues )
					{
						if ( NSOrderedSame == [policyValue compare:@"save" options:NSCaseInsensitiveSearch] )
						{
							isSave = YES;
						}
						else if ( NSOrderedSame == [policyValue compare:@"load" options:NSCaseInsensitiveSearch] )
						{
							isLoad = YES;
						}
						else if ( NSOrderedSame == [policyValue compare:@"clear" options:NSCaseInsensitiveSearch] )
						{
							isClear = YES;
						}
					}

					if ( NO == isLoad )
						continue;
				}

				if ( nil != value )
				{
					[result setValue:value forKey:propertyName];
				}
			}
			
			free( properties );
			
			clazzType = class_getSuperclass( clazzType );
			if ( nil == clazzType )
				break;
		}
		
		return result;
	}
	
	return nil;
}

- (void)unserialize:(id)obj
{
	if ( nil == obj )
		return;

	EncodingType type = [SamuraiEncoding typeOfObject:obj];
	
	if ( EncodingType_Array == type )
	{
		TODO( "does not support array" );
		return;
	}
	else if ( EncodingType_Dict == type )
	{
		NSDictionary * dict = (NSDictionary *)obj;
		if ( 0 == dict.count )
			return;
		
		Class baseClass = [[obj class] baseClass];
		if ( nil == baseClass )
		{
			baseClass = [NSObject class];
		}
		
		for ( Class clazzType = [self class]; clazzType != baseClass; )
		{
			if ( [SamuraiEncoding isAtomClass:clazzType] )
			{
				break;
			}
			
			unsigned int		propertyCount = 0;
			objc_property_t *	properties = class_copyPropertyList( clazzType, &propertyCount );
			
			for ( NSUInteger i = 0; i < propertyCount; i++ )
			{
				const char *	name = property_getName(properties[i]);
				const char *	attr = property_getAttributes(properties[i]);
				
				BOOL readonly = [SamuraiEncoding isReadOnly:attr];
				if ( readonly )
					continue;
				
				NSString *	propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
				NSObject *	tempValue = [dict objectForKey:propertyName];
				NSObject *	value = nil;
				
				if ( tempValue )
				{
					NSInteger propertyType = [SamuraiEncoding typeOfAttribute:attr];
					
					if ( EncodingType_Null == propertyType )
					{
						value = nil;
					}
					else if ( EncodingType_Number == propertyType )
					{
						value = [tempValue toNumber];
					}
					else if ( EncodingType_String == propertyType )
					{
						value = [tempValue toString];
					}
					else if ( EncodingType_Array == propertyType )
					{
						value = tempValue;
						
						__autoreleasing Class convertClass = nil;
						
						if ( nil == convertClass )
						{
							SEL convertSelector = NSSelectorFromString( [NSString stringWithFormat:@"convertClass_%@", propertyName] );
							if ( [[self class] respondsToSelector:convertSelector] )
							{
//								convertClass = [[self class] performSelector:convertSelector];
								
								NSMethodSignature * signature = [[self class] methodSignatureForSelector:convertSelector];
								NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];
								
								[invocation setTarget:[self class]];
								[invocation setSelector:convertSelector];
								[invocation invoke];
								[invocation getReturnValue:&convertClass];
							}
						}
						
						if ( nil == convertClass )
						{
							NSString * convertClassName = [clazzType extentionForProperty:propertyName stringValueWithKey:@"Class"];

							if ( convertClassName )
							{
								convertClass = NSClassFromString( convertClassName );
							}
						}
						
						if ( convertClass )
						{
							NSMutableArray * arrayTemp = [NSMutableArray array];
							
							for ( NSObject * tempObject in (NSArray *)tempValue )
							{
								id elem = [convertClass unserialize:tempObject];
								if ( elem )
								{
									[arrayTemp addObject:elem];
								}
							}
							
							value = arrayTemp;
						}
					}
					else if ( EncodingType_Dict == propertyType )
					{
						value = tempValue;
					}
					else if ( EncodingType_Date == propertyType )
					{
						value = [tempValue toDate];
					}
					else if ( EncodingType_Data == propertyType )
					{
						value = [tempValue toData];
					}
					else if ( EncodingType_Url == propertyType )
					{
						value = [tempValue toURL];
					}
					else
					{
						Class classType = [SamuraiEncoding classOfAttribute:attr];
						if ( classType )
						{
							if ( [tempValue isKindOfClass:classType] )
							{
								value = tempValue;
							}
							else
							{
								value = [classType unserialize:tempValue];
								if ( nil == value )
								{
									value = [classType unserializeForUnknownValue:tempValue];
								}
							}
						}
					}
				}

				NSArray * policyValues = [clazzType extentionForProperty:propertyName arrayValueWithKey:@"Policy"];
				
				if ( policyValues )
				{
					BOOL isSave = NO;
					BOOL isLoad = NO;
					BOOL isClear = NO;
					
					for ( NSString * policyValue in policyValues )
					{
						if ( NSOrderedSame == [policyValue compare:@"save" options:NSCaseInsensitiveSearch] )
						{
							isSave = YES;
						}
						else if ( NSOrderedSame == [policyValue compare:@"load" options:NSCaseInsensitiveSearch] )
						{
							isLoad = YES;
						}
						else if ( NSOrderedSame == [policyValue compare:@"clear" options:NSCaseInsensitiveSearch] )
						{
							isClear = YES;
						}
					}
					
					if ( NO == isLoad )
						continue;
				}
				
				if ( nil != value )
				{
					[self setValue:value forKey:propertyName];
				}
			}
			
			free( properties );
			
			clazzType = class_getSuperclass( clazzType );
			if ( nil == clazzType )
				break;
		}
	}
}

- (id)serialize
{
	id obj = self;
	
	if ( nil == obj )
	{
		return nil;
	}
	
	EncodingType type = [SamuraiEncoding typeOfObject:obj];
	
	if ( EncodingType_Null == type )
	{
		return obj;
	}
	else if ( EncodingType_Number == type )
	{
		return obj;
	}
	else if ( EncodingType_String == type )
	{
		return obj;
	}
	else if ( EncodingType_Date == type )
	{
		return [(NSDate *)obj toString:@"yyyy/MM/dd HH:mm:ss z"];
	}
	else if ( EncodingType_Data == type )
	{
		return obj;
	}
	else if ( EncodingType_Url == type )
	{
		return [obj toString];
	}
	else if ( EncodingType_Array == type )
	{
		NSMutableArray * result = [NSMutableArray array];
		
		for ( id elem in (NSArray *)obj )
		{
			id subResult = [elem serialize];
			if ( subResult )
			{
				[result addObject:subResult];
			}
		}
		
		return result;
	}
	else if ( EncodingType_Dict == type )
	{
		NSMutableDictionary * result = [NSMutableDictionary dictionary];
		
		for ( NSString * key in [(NSDictionary *)obj allKeys] )
		{
			NSObject * value = [(NSDictionary *)obj objectForKey:key];
			if ( value )
			{
				id subResult = [value serialize];
				if ( subResult )
				{
					[result setObject:subResult forKey:key];
				}
			}
		}
		
		return result;
	}
	else
	{
		NSMutableDictionary * result = [NSMutableDictionary dictionary];
		
		Class baseClass = [[obj class] baseClass];
		if ( nil == baseClass )
		{
			baseClass = [NSObject class];
		}
		
		for ( Class clazzType = [self class]; clazzType != baseClass; )
		{
			if ( [SamuraiEncoding isAtomClass:clazzType] )
			{
				break;
			}
			
			unsigned int		propertyCount = 0;
			objc_property_t *	properties = class_copyPropertyList( clazzType, &propertyCount );
			
			for ( NSUInteger i = 0; i < propertyCount; i++ )
			{
				const char *	name = property_getName(properties[i]);
//				const char *	attr = property_getAttributes(properties[i]);
				NSString *		propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];

				NSArray * policyValues = [clazzType extentionForProperty:propertyName arrayValueWithKey:@"Policy"];
				
				if ( policyValues )
				{
					BOOL isSave = NO;
					BOOL isLoad = NO;
					BOOL isClear = NO;
					
					for ( NSString * policyValue in policyValues )
					{
						if ( NSOrderedSame == [policyValue compare:@"save" options:NSCaseInsensitiveSearch] )
						{
							isSave = YES;
						}
						else if ( NSOrderedSame == [policyValue compare:@"load" options:NSCaseInsensitiveSearch] )
						{
							isLoad = YES;
						}
						else if ( NSOrderedSame == [policyValue compare:@"clear" options:NSCaseInsensitiveSearch] )
						{
							isClear = YES;
						}
					}

					if ( NO == isSave )
						continue;
				}

				NSObject * value = [self valueForKey:propertyName];
				
				if ( value )
				{
					id subResult = [value serialize];
					if ( subResult )
					{
						[result setObject:subResult forKey:propertyName];
					}
				}
			}
			
			free( properties );
			
			clazzType = class_getSuperclass( clazzType );
			if ( nil == clazzType )
				break;
		}
		
		return result.count ? result : nil;
	}
	
	return nil;
}

- (void)zerolize
{
	id obj = self;
	
	Class baseClass = [[obj class] baseClass];
	if ( nil == baseClass )
	{
		baseClass = [NSObject class];
	}
	
	if ( [SamuraiEncoding isAtomObject:self] )
	{
		return;
	}
	
	for ( Class clazzType = [self class]; clazzType != baseClass; )
	{
		if ( [SamuraiEncoding isAtomClass:clazzType] )
		{
			break;
		}

		unsigned int		propertyCount = 0;
		objc_property_t *	properties = class_copyPropertyList( clazzType, &propertyCount );
		
		for ( NSUInteger i = 0; i < propertyCount; i++ )
		{
			const char *	name = property_getName(properties[i]);
			const char *	attr = property_getAttributes(properties[i]);

			NSString *		propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
			EncodingType	propertyType = [SamuraiEncoding typeOfAttribute:attr];

			NSArray * policyValues = [clazzType extentionForProperty:propertyName arrayValueWithKey:@"Policy"];

			if ( policyValues )
			{
				BOOL isSave = NO;
				BOOL isLoad = NO;
				BOOL isClear = NO;
				
				for ( NSString * policyValue in policyValues )
				{
					if ( NSOrderedSame == [policyValue compare:@"save" options:NSCaseInsensitiveSearch] )
					{
						isSave = YES;
					}
					else if ( NSOrderedSame == [policyValue compare:@"load" options:NSCaseInsensitiveSearch] )
					{
						isLoad = YES;
					}
					else if ( NSOrderedSame == [policyValue compare:@"clear" options:NSCaseInsensitiveSearch] )
					{
						isClear = YES;
					}
				}

				if ( NO == isClear )
					continue;
			}

			if ( EncodingType_Number == propertyType )
			{
				[self setValue:nil forKey:propertyName];
			}
			else if ( EncodingType_String == propertyType )
			{
				[self setValue:nil forKey:propertyName];
			}
			else if ( EncodingType_Date == propertyType )
			{
				[self setValue:nil forKey:propertyName];
			}
			else if ( EncodingType_Data == propertyType )
			{
				[self setValue:nil forKey:propertyName];
			}
			else if ( EncodingType_Url == propertyType )
			{
				[self setValue:nil forKey:propertyName];
			}
			else if ( EncodingType_Array == propertyType )
			{
				[self setValue:[NSMutableArray array] forKey:propertyName];
			}
			else if ( EncodingType_Dict == propertyType )
			{
				[self setValue:[NSMutableDictionary dictionary] forKey:propertyName];
			}
			else
			{
				Class clazz = [SamuraiEncoding classOfAttribute:attr];
				if ( clazz )
				{
					NSObject * newObj = [[clazz alloc] init];
					if ( newObj )
					{
						[self setValue:newObj forKey:propertyName];
					}
					else
					{
						[self setValue:nil forKey:propertyName];
					}
				}
				else
				{
					[self setValue:nil forKey:propertyName];
				}
			}
		}
		
		free( properties );
		
		clazzType = class_getSuperclass( clazzType );
		if ( nil == clazzType )
		{
			break;
		}
	}
}

- (id)clone
{
	id newObject = [[[self class] alloc] init];

	if ( newObject )
	{
		[newObject deepCopyFrom:self];
	}

	return newObject;
}

#pragma mark -

- (id)JSONEncoded
{
	NSError * error = nil;
	NSData * result = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
	if ( nil == result )
	{
		ERROR( @"%@", error );
		return nil;
	}
	
	return result;
}

- (id)JSONDecoded
{
	NSError * error = nil;
	NSObject * result = [NSJSONSerialization JSONObjectWithData:[self toData] options:NSJSONReadingAllowFragments error:&error];
	if ( nil == result )
	{
		ERROR( @"%@", error );
		return nil;
	}
	
	return result;
}

- (BOOL)toBool
{
	return [[self toNumber] boolValue];
}

- (float)toFloat
{
	return [[self toNumber] floatValue];
}

- (double)toDouble
{
	return [[self toNumber] doubleValue];
}

- (NSInteger)toInteger
{
	return [[self toNumber] integerValue];
}

- (NSUInteger)toUnsignedInteger
{
	return [[self toNumber] unsignedIntegerValue];
}

- (NSURL *)toURL
{
	NSString * string = [self toString];
	if ( nil == string )
	{
		return nil;
	}
	
	return [NSURL URLWithString:string];
}

- (NSDate *)toDate
{
	EncodingType encoding = [SamuraiEncoding typeOfObject:self];
	
	if ( EncodingType_Null == encoding )
	{
		return nil;
	}
	else if ( EncodingType_Number == encoding )
	{
		NSNumber * number = (NSNumber *)self;
		return [NSDate dateWithTimeIntervalSince1970:[number doubleValue]];
	}
	else if ( EncodingType_String == encoding )
	{
		return [NSDate fromString:(NSString *)self];
	}
	else if ( EncodingType_Date == encoding )
	{
		return (NSDate *)self;
	}
	else if ( EncodingType_Data == encoding )
	{
		NSData *	data = (NSData *)self;
		NSString *	string = [[NSString alloc] initWithBytes:data.bytes length:data.length encoding:NSUTF8StringEncoding];
		
		return [NSDate fromString:string];
	}
	else if ( EncodingType_Url == encoding )
	{
		return nil;
	}
	else if ( EncodingType_Array == encoding )
	{
		return nil;
	}
	else if ( EncodingType_Dict == encoding )
	{
		return nil;
	}
	
	return nil;
}

- (NSData *)toData
{
	EncodingType encoding = [SamuraiEncoding typeOfObject:self];
	
	if ( EncodingType_Null == encoding )
	{
		return nil;
	}
	else if ( EncodingType_Number == encoding )
	{
		NSString * string = [(NSNumber *)self description];
		return [string dataUsingEncoding:NSUTF8StringEncoding];
	}
	else if ( EncodingType_String == encoding )
	{
		NSString * string = (NSString *)self;
		return [string dataUsingEncoding:NSUTF8StringEncoding];
	}
	else if ( EncodingType_Date == encoding )
	{
		NSString * string = [(NSDate *)self toString:@"yyyy/MM/dd HH:mm:ss z"];
		return [string dataUsingEncoding:NSUTF8StringEncoding];
	}
	else if ( EncodingType_Data == encoding )
	{
		return (NSData *)self;
	}
	else if ( EncodingType_Url == encoding )
	{
		NSURL * url = (NSURL *)self;
		return [[url absoluteString] dataUsingEncoding:NSUTF8StringEncoding];
	}
	else if ( EncodingType_Array == encoding )
	{
		NSMutableArray * array = [NSMutableArray array];
		
		for ( NSObject * elem in (NSArray *)self )
		{
			id serializedObject = [elem serialize];
			if ( serializedObject )
			{
				[array addObject:serializedObject];
			}
		}
		
		return [NSJSONSerialization dataWithJSONObject:array options:kNilOptions error:NULL];
	}
	else if ( EncodingType_Dict == encoding )
	{
		id serializedObject = [self serialize];
		if ( serializedObject )
		{
			return [NSJSONSerialization dataWithJSONObject:serializedObject options:kNilOptions error:NULL];
		}
	}
	else
	{
		id serializedObject = [self serialize];
		if ( serializedObject )
		{
			return [NSJSONSerialization dataWithJSONObject:serializedObject options:kNilOptions error:NULL];
		}
	}
	
	return nil;
}

- (NSNumber *)toNumber
{
	EncodingType encoding = [SamuraiEncoding typeOfObject:self];
	
	if ( EncodingType_Null == encoding )
	{
		return [NSNumber numberWithInt:0];
	}
	else if ( EncodingType_Number == encoding )
	{
		return (NSNumber *)self;
	}
	else if ( EncodingType_String == encoding )
	{
		NSString * string = (NSString *)self;
		
		if ( NSOrderedSame == [string compare:@"yes" options:NSCaseInsensitiveSearch] ||
			NSOrderedSame == [string compare:@"true" options:NSCaseInsensitiveSearch] ||
			NSOrderedSame == [string compare:@"on" options:NSCaseInsensitiveSearch] ||
			NSOrderedSame == [string compare:@"1" options:NSCaseInsensitiveSearch] )
		{
			return [NSNumber numberWithBool:YES];
		}
		else if ( NSOrderedSame == [string compare:@"no" options:NSCaseInsensitiveSearch] ||
				 NSOrderedSame == [string compare:@"off" options:NSCaseInsensitiveSearch] ||
				 NSOrderedSame == [string compare:@"false" options:NSCaseInsensitiveSearch] ||
				 NSOrderedSame == [string compare:@"0" options:NSCaseInsensitiveSearch] )
		{
			return [NSNumber numberWithBool:NO];
		}
		else
		{
			return [NSNumber numberWithInteger:[string integerValue]];
		}
	}
	else if ( EncodingType_Date == encoding )
	{
		NSDate * date = (NSDate *)self;
		return [NSNumber numberWithDouble:[date timeIntervalSince1970]];
	}
	else if ( EncodingType_Data == encoding )
	{
		NSData * data = (NSData *)self;
		NSString * string = [[NSString alloc] initWithBytes:data.bytes length:data.length encoding:NSUTF8StringEncoding];
		if ( string )
		{
			return [NSNumber numberWithInteger:[string integerValue]];
		}
	}
	else if ( EncodingType_Url == encoding )
	{
		return nil;
	}
	else if ( EncodingType_Array == encoding )
	{
		return nil;
	}
	else if ( EncodingType_Dict == encoding )
	{
		return nil;
	}
	
	return nil;
}

- (NSString *)toString
{
	EncodingType encoding = [SamuraiEncoding typeOfObject:self];
	
	if ( EncodingType_Null == encoding )
	{
		return nil;
	}
	else if ( EncodingType_Number == encoding )
	{
		return [self description];
	}
	else if ( EncodingType_String == encoding )
	{
		return (NSString *)self;
	}
	else if ( EncodingType_Date == encoding )
	{
		return [(NSDate *)self toString:@"yyyy/MM/dd HH:mm:ss z"];
	}
	else if ( EncodingType_Data == encoding )
	{
		NSData *	data = (NSData *)self;
		NSString *	text = nil;
		
		text = [[NSString alloc] initWithBytes:data.bytes length:data.length encoding:NSUTF8StringEncoding];
		if ( nil == text )
		{
			text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
			if ( nil == text )
			{
				text = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
			}
		}
		
		return text;
	}
	else if ( EncodingType_Url == encoding )
	{
		NSURL * url = (NSURL *)self;
		return [url absoluteString];
	}
	else if ( EncodingType_Array == encoding )
	{
		NSMutableArray * array = [NSMutableArray array];
		
		for ( NSObject * elem in (NSArray *)self )
		{
			id serializedObject = [elem serialize];
			if ( serializedObject )
			{
				[array addObject:serializedObject];
			}
		}
		
		NSData * result = [NSJSONSerialization dataWithJSONObject:array options:kNilOptions error:NULL];
		if ( result )
		{
			return [result toString];
		}
	}
	else if ( EncodingType_Dict == encoding )
	{
		id serializedObject = [self serialize];
		if ( serializedObject )
		{
			NSData * result = [NSJSONSerialization dataWithJSONObject:serializedObject options:kNilOptions error:NULL];
			if ( result )
			{
				return [result toString];
			}
		}
	}
	else
	{
		id serializedObject = [self serialize];
		if ( serializedObject )
		{
			NSData * result = [NSJSONSerialization dataWithJSONObject:serializedObject options:kNilOptions error:NULL];
			if ( result )
			{
				return [result toString];
			}
		}
	}
	
	return nil;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

@interface __SimpleClass : NSObject
@prop_strong( NSNumber *,			number );
@prop_strong( NSString *,			string );
@prop_strong( NSDate *,				date );
@prop_strong( NSData *,				data );
@prop_strong( NSURL *,				url );
@end

@interface __ComplexClass : __SimpleClass
@prop_strong( NSArray *,			array1 );
@prop_strong( NSArray *,			array2 );
@prop_strong( NSArray *,			array3 );
@prop_strong( NSDictionary *,		dict );
@prop_strong( __SimpleClass *,		object1 );
@prop_strong( __ComplexClass *,		object2 );
@end

@implementation __SimpleClass
@def_prop_strong( NSNumber *,		number );
@def_prop_strong( NSString *,		string );
@def_prop_strong( NSDate *,			date );
@def_prop_strong( NSData *,			data );
@def_prop_strong( NSURL *,			url );
@end

@implementation __ComplexClass
@def_prop_strong( NSArray *,		array1 );
@def_prop_strong( NSArray *,		array2,		Class => __SimpleClass );
@def_prop_strong( NSArray *,		array3,		Class => __ComplexClass );
@def_prop_strong( NSDictionary *,	dict );
@def_prop_strong( __SimpleClass *,	object1 );
@def_prop_strong( __ComplexClass *,	object2 );

BASE_CLASS( NSObject )

//CONVERT_CLASS( array2, __SimpleClass )
//CONVERT_CLASS( array3, __ComplexClass )

@end

TEST_CASE( Core, NSObject_Extension )
{
	
}

DESCRIBE( before )
{
}

DESCRIBE( serialize )
{
	__SimpleClass * simple = [[__SimpleClass alloc] init];
	simple.number = @1;
	simple.string = @"2";
	simple.date = [NSDate date];
//	simple.data = [NSData dataWithBytes:"123456" length:6];
	simple.url = [NSURL URLWithString:@"http://www.geek-zoo.com"];
	
	__ComplexClass * complex = [[__ComplexClass alloc] init];
	__ComplexClass * complex2 = [[__ComplexClass alloc] init];
	
	complex2.number = @1;
	complex2.string = @"2";
	complex2.date = [NSDate date];
//	complex2.data = [NSData dataWithBytes:"123456" length:6];
	complex2.url = [NSURL URLWithString:@"http://www.geek-zoo.com"];

	complex.number = @1;
	complex.string = @"2";
	complex.date = [NSDate date];
//	complex.data = [NSData dataWithBytes:"123456" length:6];
	complex.url = [NSURL URLWithString:@"http://www.geek-zoo.com"];
	
	complex.array1 = @[simple.number, simple.string, simple.date, /*simple.data,*/ simple.url];
	complex.array2 = @[simple, simple];
	complex.array3 = @[complex2, complex2];
	complex.dict = @{@"k1":simple.number,
					 @"k2":simple.string,
					 @"k3":simple.date,
					 //					 @"k4":simple.data,
					 @"k5":simple.url,
					 @"k6":complex.array1,
					 @"k7":complex.array2,
					 @"k8":complex.array3,
					 @"k9":simple,
					 @"k10":complex2};
	complex.object1 = simple;
	complex.object2 = complex2;
		
	id obj1 = [simple serialize];
	id obj2 = [complex serialize];
	
	NSString * obj1JSON = [[obj1 JSONEncoded] toString];
	NSString * obj2JSON = [[obj2 JSONEncoded] toString];
	
	EXPECTED( obj1 )
	EXPECTED( obj2 )
	EXPECTED( obj1JSON )
	EXPECTED( obj2JSON )
}

DESCRIBE( after )
{
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#import "_pragma_pop.h"
