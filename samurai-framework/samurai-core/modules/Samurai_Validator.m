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

#import "Samurai_Validator.h"
#import "Samurai_Encoding.h"
#import "Samurai_Property.h"
#import "Samurai_UnitTest.h"

#import "NSArray+Extension.h"
#import "NSString+Extension.h"
#import "NSObject+Extension.h"

#import "_pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSObject(Validation)

- (BOOL)validate
{
	return [[SamuraiValidator sharedInstance] validateObject:self];
}

- (BOOL)validate:(NSString *)prop
{
	return [[SamuraiValidator sharedInstance] validateObject:self property:prop];
}

@end

#pragma mark -

@implementation SamuraiValidator

@def_singleton( SamuraiValidator )

@def_prop_strong( NSString *,	lastProperty );
@def_prop_strong( NSString *,	lastError );

static __strong NSMutableDictionary * __rules = nil;

+ (void)classAutoLoad
{
	[[SamuraiValidator sharedInstance] loadRules];
}

- (void)loadRules
{
	if ( nil == __rules )
	{
		__rules = [[NSMutableDictionary alloc] init];
			
		[__rules setObject:@(ValidatorRule_Regex)		forKey:@"regex"];
		[__rules setObject:@(ValidatorRule_Accepted)	forKey:@"accepted"];
		[__rules setObject:@(ValidatorRule_In)			forKey:@"in"];
		[__rules setObject:@(ValidatorRule_NotIn)		forKey:@"notin"];
		[__rules setObject:@(ValidatorRule_Alpha)		forKey:@"alpha"];
		[__rules setObject:@(ValidatorRule_Numeric)		forKey:@"numeric"];
		[__rules setObject:@(ValidatorRule_AlphaNum)	forKey:@"alpha_num"];
		[__rules setObject:@(ValidatorRule_AlphaDash)	forKey:@"alpha_dash"];
		[__rules setObject:@(ValidatorRule_URL)			forKey:@"url"];
		[__rules setObject:@(ValidatorRule_Email)		forKey:@"email"];
//		[__rules setObject:@(ValidatorRule_Tel)			forKey:@"tel"];
		[__rules setObject:@(ValidatorRule_Integer)		forKey:@"integer"];
		[__rules setObject:@(ValidatorRule_IP)			forKey:@"ip"];
		[__rules setObject:@(ValidatorRule_Before)		forKey:@"before"];
		[__rules setObject:@(ValidatorRule_After)		forKey:@"after"];
		[__rules setObject:@(ValidatorRule_Between)		forKey:@"between"];
		[__rules setObject:@(ValidatorRule_Same)		forKey:@"same"];
		[__rules setObject:@(ValidatorRule_Size)		forKey:@"size"];
		[__rules setObject:@(ValidatorRule_Date)		forKey:@"date"];
		[__rules setObject:@(ValidatorRule_DateFormat)	forKey:@"dateformat"];
		[__rules setObject:@(ValidatorRule_Different)	forKey:@"different"];
		[__rules setObject:@(ValidatorRule_Min)			forKey:@"min"];
		[__rules setObject:@(ValidatorRule_Max)			forKey:@"max"];
		[__rules setObject:@(ValidatorRule_Required)	forKey:@"required"];
	}
}

- (ValidatorRule)typeFromString:(NSString *)string
{
	string = [[string trim] unwrap];
	
	NSNumber * ruleType = [__rules objectForKey:string];
	if ( ruleType )
	{
		return (ValidatorRule)ruleType.integerValue;
	}
	
	return ValidatorRule_Unknown;
}

- (BOOL)validate:(NSObject *)value rule:(NSString *)rule
{
	NSUInteger offset = 0;
	
	if ( NSNotFound != [rule rangeOfString:@":"].location )
	{
		NSString * ruleName = [[rule substringFromIndex:0 untilString:@":" endOffset:&offset] trim];
		NSString * ruleValue = [[[rule substringFromIndex:offset] trim] unwrap];		

		return [self validate:value ruleName:ruleName ruleValue:ruleValue];
	}
	else
	{
		return [self validate:value ruleName:rule ruleValue:nil];
	}
}

- (BOOL)validate:(NSObject *)value ruleName:(NSString *)ruleName ruleValue:(NSString *)ruleValue
{
	ValidatorRule ruleType = [self typeFromString:ruleName];
	
	if ( ValidatorRule_Unknown == ruleType )
	{
	#if __ENABLE_STRICT_VALIDATION__
		return YES;
	#else
		return NO;
	#endif
	}

	return [self validate:value ruleType:ruleType ruleValue:ruleValue];
}

- (BOOL)validate:(NSObject *)value ruleType:(ValidatorRule)ruleType ruleValue:(NSString *)ruleValue
{
	switch ( ruleType )
	{
	case ValidatorRule_Regex:
		{
			NSString * textValue = [value toString];
			if ( nil == textValue )
			{
				return NO;
			}

			BOOL matched = [textValue match:ruleValue];
			if ( NO == matched )
			{
				return NO;
			}
		}
		break;

	case ValidatorRule_Accepted:
		{
			BOOL accepted = [[value toNumber] boolValue];
			if ( NO == accepted )
			{
				return NO;
			}
		}
		break;

	case ValidatorRule_In:
		{
			BOOL			matched = NO;
			EncodingType	encoding = [SamuraiEncoding typeOfObject:value];
			
			NSArray * list = [ruleValue componentsSeparatedByString:@","];
			for ( NSString * item in list )
			{
				NSString * filter = [[item trim] unwrap];
				NSObject * value2 = [filter converToType:encoding];

				if ( value2 && [value2 isEqual:value] )
				{
					matched = YES;
					break;
				}
			}
			
			if ( NO == matched )
			{
				return NO;
			}
		}
		break;

	case ValidatorRule_NotIn:
		{
			BOOL			matched = NO;
			EncodingType	encoding = [SamuraiEncoding typeOfObject:value];
			
			NSArray * list = [ruleValue componentsSeparatedByString:@","];
			for ( NSString * item in list )
			{
				NSString * filter = [[item trim] unwrap];
				NSObject * value2 = [filter converToType:encoding];
				
				if ( value2 && [value2 isEqual:value] )
				{
					matched = YES;
					break;
				}
			}

			if ( matched )
			{
				return NO;
			}
		}
		break;

	case ValidatorRule_Alpha:
		{
			NSString * textValue = [value toString];
			if ( nil == textValue )
			{
				return NO;
			}

			if ( NO == [textValue match:@"^([a-zA-Z]+)$"] )
			{
				return NO;
			}
		}
		break;

	case ValidatorRule_Numeric:
		{
			NSString * textValue = [value toString];
			if ( nil == textValue )
			{
				return NO;
			}
			
			if ( NO == [textValue match:@"^([+\\-\\.0-9]+)$"] )
			{
				return NO;
			}
		}
		break;

	case ValidatorRule_AlphaNum:
		{
			NSString * textValue = [value toString];
			if ( nil == textValue )
			{
				return NO;
			}
			
			if ( NO == [textValue match:@"^([a-zA-Z0-9]+)$"] )
			{
				return NO;
			}
		}
		break;

	case ValidatorRule_AlphaDash:
		{
			NSString * textValue = [value toString];
			if ( nil == textValue )
			{
				return NO;
			}

			if ( NO == [textValue match:@"^([a-zA-Z_]+)$"] )
			{
				return NO;
			}
		}
		break;

	case ValidatorRule_URL:
		{
			NSString * textValue = [value toString];
			if ( nil == textValue )
			{
				return NO;
			}
			
			if ( NO == [textValue isUrl] )
			{
				return NO;
			}
		}
		break;

	case ValidatorRule_Email:
		{
			NSString * textValue = [value toString];
			if ( nil == textValue )
			{
				return NO;
			}
			
			if ( NO == [textValue isEmail] )
			{
				return NO;
			}
		}
		break;

//	case ValidatorRule_Tel:
//		{
//			NSString * textValue = [value toString];
//			if ( nil == textValue )
//			{
//				return NO;
//			}
//			
//			if ( NO == [textValue isTelephone] )
//			{
//				return NO;
//			}
//		}
//		break;

	case ValidatorRule_Image:
		{
			if ( NO == [value isKindOfClass:[UIImage class]] )
			{
				return NO;
			}
		}
		break;

	case ValidatorRule_Integer:
		{
			EncodingType encoding = [SamuraiEncoding typeOfObject:value];

			if ( EncodingType_Number != encoding )
			{
				return NO;
			}
		}
		break;

	case ValidatorRule_IP:
		{
			NSString * textValue = [value toString];
			if ( nil == textValue )
			{
				return NO;
			}

			if ( NO == [textValue isIPAddress] )
			{
				return NO;
			}
		}
		break;

	case ValidatorRule_Before:
		{
			NSDate * dateValue = [value toDate];
			NSDate * dateValue2 = [ruleValue toDate];
			
			if ( nil == dateValue || nil == dateValue2 )
			{
				return NO;
			}

			if ( NSOrderedAscending != [dateValue compare:dateValue2] )
			{
				return NO;
			}
		}
		break;

	case ValidatorRule_After:
		{
			NSDate * dateValue = [value toDate];
			NSDate * dateValue2 = [ruleValue toDate];
			
			if ( nil == dateValue || nil == dateValue2 )
			{
				return NO;
			}

			if ( NSOrderedDescending != [dateValue compare:dateValue2] )
			{
				return NO;
			}
		}
		break;

	case ValidatorRule_Between:
		{
			NSNumber * numberValue = [value toNumber];
			if ( nil == numberValue )
			{
				return NO;
			}
			
			NSArray *	array = [ruleValue componentsSeparatedByString:@","];
			NSNumber *	value1 = [[[array safeObjectAtIndex:0] trim] toNumber];
			NSNumber *	value2 = [[[array safeObjectAtIndex:1] trim] toNumber];
			
			if ( nil == value1 || nil == value2 )
			{
				return NO;
			}
			
			if ( NSOrderedDescending != [numberValue compare:value1] )
			{
				return NO;
			}

			if ( NSOrderedAscending != [numberValue compare:value2] )
			{
				return NO;
			}
		}
		break;

	case ValidatorRule_Same:
		{
			TODO( "same: xxx" );
		}
		break;

	case ValidatorRule_Size:
		{
			EncodingType encoding = [SamuraiEncoding typeOfObject:value];
			
			if ( EncodingType_Number == encoding )
			{
				NSNumber * numberValue = (NSNumber *)value;
				
				if ( NSOrderedSame != [numberValue compare:[[ruleValue trim] toNumber]] )
				{
					return NO;
				}
			}
			else if ( EncodingType_String == encoding )
			{
				NSString * stringValue = (NSString *)value;
				
				if ( [stringValue length] != (NSUInteger)[ruleValue integerValue] )
				{
					return NO;
				}
			}
			else if ( EncodingType_Data == encoding )
			{
				NSData * dataValue = (NSData *)value;
				
				if ( [dataValue length] != (NSUInteger)[ruleValue integerValue] )
				{
					return NO;
				}
			}
			else if ( EncodingType_Url == encoding )
			{
				NSString * stringValue = [value toString];

				if ( [stringValue length] != (NSUInteger)[ruleValue integerValue] )
				{
					return NO;
				}
			}
			else if ( EncodingType_Array == encoding )
			{
				NSArray * arrayValue = (NSArray *)value;
				
				if ( [arrayValue count] != (NSUInteger)[ruleValue integerValue] )
				{
					return NO;
				}
			}
			else if ( EncodingType_Dict == encoding )
			{
				NSDictionary * dictValue = (NSDictionary *)value;
				
				if ( [dictValue count] != (NSUInteger)[ruleValue integerValue] )
				{
					return NO;
				}
			}
		}
		break;

	case ValidatorRule_Date:
		{
			EncodingType encoding = [SamuraiEncoding typeOfObject:value];

			if ( EncodingType_Date != encoding )
			{
				NSDate * date = [value toDate];
				if ( nil == date )
				{
					return NO;
				}
			}
		}
		break;

	case ValidatorRule_DateFormat:
		{
			TODO( "data_format: xxx" );
		}
		break;

	case ValidatorRule_Different:
		{
			TODO( "different: xxx" );
		}
		break;

	case ValidatorRule_Min:
		{
			EncodingType encoding = [SamuraiEncoding typeOfObject:value];
			
			if ( EncodingType_Number == encoding )
			{
				NSNumber * numberValue = (NSNumber *)value;
				
				if ( NSOrderedAscending == [numberValue compare:[[ruleValue trim] toNumber]] )
				{
					return NO;
				}
			}
			else if ( EncodingType_String == encoding )
			{
				NSString * stringValue = (NSString *)value;
				
				if ( [stringValue length] < (NSUInteger)[ruleValue integerValue] )
				{
					return NO;
				}
			}
			else if ( EncodingType_Data == encoding )
			{
				NSData * dataValue = (NSData *)value;
				
				if ( [dataValue length] < (NSUInteger)[ruleValue integerValue] )
				{
					return NO;
				}
			}
			else if ( EncodingType_Url == encoding )
			{
				NSString * stringValue = [value toString];
				
				if ( [stringValue length] < (NSUInteger)[ruleValue integerValue] )
				{
					return NO;
				}
			}
			else if ( EncodingType_Array == encoding )
			{
				NSArray * arrayValue = (NSArray *)value;
				
				if ( [arrayValue count] < (NSUInteger)[ruleValue integerValue] )
				{
					return NO;
				}
			}
			else if ( EncodingType_Dict == encoding )
			{
				NSDictionary * dictValue = (NSDictionary *)value;
				
				if ( [dictValue count] < (NSUInteger)[ruleValue integerValue] )
				{
					return NO;
				}
			}
		}
		break;

	case ValidatorRule_Max:
		{
			EncodingType encoding = [SamuraiEncoding typeOfObject:value];
			
			if ( EncodingType_Number == encoding )
			{
				NSNumber * numberValue = (NSNumber *)value;
				
				if ( NSOrderedDescending == [numberValue compare:[[ruleValue trim] toNumber]] )
				{
					return NO;
				}
			}
			else if ( EncodingType_String == encoding )
			{
				NSString * stringValue = (NSString *)value;
				
				if ( [stringValue length] > (NSUInteger)[ruleValue integerValue] )
				{
					return NO;
				}
			}
			else if ( EncodingType_Data == encoding )
			{
				NSData * dataValue = (NSData *)value;
				
				if ( [dataValue length] > (NSUInteger)[ruleValue integerValue] )
				{
					return NO;
				}
			}
			else if ( EncodingType_Url == encoding )
			{
				NSString * stringValue = [value toString];
				
				if ( [stringValue length] > (NSUInteger)[ruleValue integerValue] )
				{
					return NO;
				}
			}
			else if ( EncodingType_Array == encoding )
			{
				NSArray * arrayValue = (NSArray *)value;
				
				if ( [arrayValue count] > (NSUInteger)[ruleValue integerValue] )
				{
					return NO;
				}
			}
			else if ( EncodingType_Dict == encoding )
			{
				NSDictionary * dictValue = (NSDictionary *)value;
				
				if ( [dictValue count] > (NSUInteger)[ruleValue integerValue] )
				{
					return NO;
				}
			}
		}
		break;

	case ValidatorRule_Required:
		{
			if ( nil == value )
			{
				return NO;
			}
		}
		break;

	default:
		break;
	}
	
	return YES;
}

- (BOOL)validateObject:(NSObject *)obj
{
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
			NSString *		propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
			NSObject *		propertyValue = [obj valueForKey:propertyName];
			NSArray *		ruleValues = [obj extentionForProperty:propertyName arrayValueWithKey:@"Rule"];
			
			for ( NSString * ruleValue in ruleValues )
			{
				BOOL passes = [self validate:propertyValue rule:ruleValue];
				if ( NO == passes )
				{
					self.lastProperty	= propertyName;
					self.lastError		= @"Unknown";

					return NO;
				}
			}
		}
		
		free( properties );
		
		clazzType = class_getSuperclass( clazzType );
		if ( nil == clazzType )
			break;
	}
	
	return YES;
}

- (BOOL)validateObject:(NSObject *)obj property:(NSString *)property
{
	if ( nil == property )
		return NO;
	
	NSString *		propertyName = property;
	NSObject *		propertyValue = [obj valueForKey:propertyName];
	NSArray *		ruleValues = [obj extentionForProperty:propertyName arrayValueWithKey:@"Rule"];

	for ( NSString * ruleValue in ruleValues )
	{
		BOOL passes = [self validate:propertyValue rule:ruleValue];
		if ( NO == passes )
		{
			self.lastProperty	= propertyName;
			self.lastError		= @"Unknown";

			return NO;
		}
	}
	
	return YES;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

@interface __ValidatorTestClass : NSObject
@prop_dynamic( NSString *, value );
@end

@implementation __ValidatorTestClass
@def_prop_strong( NSString *, value, Rule => required );
@end

TEST_CASE( Core, Validator )
{
	__ValidatorTestClass * obj1;
	__ValidatorTestClass * obj2;
}

DESCRIBE( before )
{
	obj1 = [[__ValidatorTestClass alloc] init];
	obj2 = [[__ValidatorTestClass alloc] init];
}

DESCRIBE( validator )
{
	obj1.value = nil;
	obj2.value = @"Hello";

	EXPECTED( [obj1 validate] == NO );
	EXPECTED( [obj2 validate] == YES );
}

DESCRIBE( regex: )
{
	BOOL valid;

	valid = [[SamuraiValidator sharedInstance] validate:@"1234" rule:@"regex:^([0-9]+)$"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"abcd" rule:@"regex:^([0-9]+)$"];
	EXPECTED( NO == valid );
}

DESCRIBE( accepted )
{
	BOOL valid;

	valid = [[SamuraiValidator sharedInstance] validate:@"YES" rule:@"accepted"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"ON" rule:@"accepted"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"TRUE" rule:@"accepted"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"1" rule:@"accepted"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@(YES) rule:@"accepted"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@(1) rule:@"accepted"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@(1234) rule:@"accepted"];
	EXPECTED( YES == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:@"1234" rule:@"accepted"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"NO" rule:@"accepted"];
	EXPECTED( NO == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"OFF" rule:@"accepted"];
	EXPECTED( NO == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"FALSE" rule:@"accepted"];
	EXPECTED( NO == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"0" rule:@"accepted"];
	EXPECTED( NO == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@(NO) rule:@"accepted"];
	EXPECTED( NO == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@(0) rule:@"accepted"];
	EXPECTED( NO == valid );

	valid = [[SamuraiValidator sharedInstance] validate:obj1 rule:@"accepted"];
	EXPECTED( NO == valid );
}

DESCRIBE( in: )
{
	BOOL valid;
	
	valid = [[SamuraiValidator sharedInstance] validate:@"abc" rule:@"in:abc,123,def"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"123" rule:@"in:abc,123,def"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"def" rule:@"in:abc,123,def"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@(123) rule:@"in:abc,123,def"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"456" rule:@"in:abc,123,def"];
	EXPECTED( NO == valid );
}

DESCRIBE( notin: )
{
	BOOL valid;
	
	valid = [[SamuraiValidator sharedInstance] validate:@"abc" rule:@"notin:abc,123,def"];
	EXPECTED( NO == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:@"123" rule:@"notin:abc,123,def"];
	EXPECTED( NO == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:@"def" rule:@"notin:abc,123,def"];
	EXPECTED( NO == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:@(123) rule:@"notin:abc,123,def"];
	EXPECTED( NO == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:@"456" rule:@"notin:abc,123,def"];
	EXPECTED( YES == valid );
}

DESCRIBE( alpha )
{
	BOOL valid;

	valid = [[SamuraiValidator sharedInstance] validate:@"abc" rule:@"alpha"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"123" rule:@"alpha"];
	EXPECTED( NO == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"!@#$%^" rule:@"alpha"];
	EXPECTED( NO == valid );
}

DESCRIBE( numberic )
{
	BOOL valid;
	
	valid = [[SamuraiValidator sharedInstance] validate:@"abc" rule:@"numeric"];
	EXPECTED( NO == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:@"123" rule:@"numeric"];
	EXPECTED( YES == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:@"!@#$%^" rule:@"numeric"];
	EXPECTED( NO == valid );
}

DESCRIBE( alpha_num )
{
	BOOL valid;
	
	valid = [[SamuraiValidator sharedInstance] validate:@"abc123" rule:@"alpha_num"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"123abc" rule:@"alpha_num"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"!@#$%^" rule:@"alpha_num"];
	EXPECTED( NO == valid );
}

DESCRIBE( alpha_dash )
{
	BOOL valid;
	
	valid = [[SamuraiValidator sharedInstance] validate:@"_" rule:@"alpha_dash"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"abc_" rule:@"alpha_dash"];
	EXPECTED( YES == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:@"_abc" rule:@"alpha_dash"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"_a_b_c_" rule:@"alpha_dash"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"!@#$%^" rule:@"alpha_dash"];
	EXPECTED( NO == valid );
}

DESCRIBE( url )
{
	BOOL valid;
	
	valid = [[SamuraiValidator sharedInstance] validate:@"http://qq" rule:@"url"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"http://qq.com" rule:@"url"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"http://www.qq.com" rule:@"url"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"https://www.qq.com" rule:@"url"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"https://www.qq.com?a=b&c=d" rule:@"url"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"qq" rule:@"url"];
	EXPECTED( NO == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:@"qq.com" rule:@"url"];
	EXPECTED( NO == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:@"www.qq.com" rule:@"url"];
	EXPECTED( NO == valid );
}

DESCRIBE( email )
{
	BOOL valid;
	
	valid = [[SamuraiValidator sharedInstance] validate:@"a@b.c" rule:@"email"];
	EXPECTED( NO == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"a@b.co" rule:@"email"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"gavinkwoe@gmail.com" rule:@"email"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"abc123!@gmail.com" rule:@"email"];
	EXPECTED( NO == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"abc@123" rule:@"email"];
	EXPECTED( NO == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"abc" rule:@"email"];
	EXPECTED( NO == valid );
}

DESCRIBE( tel )
{
	BOOL valid;
	
//	valid = [[SamuraiValidator sharedInstance] validate:@"13520351350" rule:@"tel"];
//	EXPECTED( YES == valid );
//
//	valid = [[SamuraiValidator sharedInstance] validate:@"02482510205" rule:@"tel"];
//	EXPECTED( YES == valid );
//
//	valid = [[SamuraiValidator sharedInstance] validate:@"+86 024 82510205" rule:@"tel"];
//	EXPECTED( NO == valid );
}

DESCRIBE( integer )
{
	BOOL valid;
	
	valid = [[SamuraiValidator sharedInstance] validate:@(0) rule:@"integer"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@(123) rule:@"integer"];
	EXPECTED( YES == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:@"abc" rule:@"integer"];
	EXPECTED( NO == valid );

	valid = [[SamuraiValidator sharedInstance] validate:obj1 rule:@"integer"];
	EXPECTED( NO == valid );
}

DESCRIBE( ip )
{
	BOOL valid;
	
	valid = [[SamuraiValidator sharedInstance] validate:@"0.0.0.0" rule:@"ip"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"10.0.0.0" rule:@"ip"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"255.255.255.255" rule:@"ip"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"123.456.789.124" rule:@"ip"];
	EXPECTED( NO == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"1" rule:@"ip"];
	EXPECTED( NO == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"1.1" rule:@"ip"];
	EXPECTED( NO == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"1.1.1" rule:@"ip"];
	EXPECTED( NO == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"1...1" rule:@"ip"];
	EXPECTED( NO == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"abc" rule:@"ip"];
	EXPECTED( NO == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:obj1 rule:@"ip"];
	EXPECTED( NO == valid );
}

DESCRIBE( before:/after: )
{
	BOOL valid;
	
	valid = [[SamuraiValidator sharedInstance] validate:@"2014/05/11 00:00:00" rule:@"before:2014/05/11 00:00:01"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"2014/05/11 00:00:00" rule:@"after:2014/05/10 23:59:59"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:[@"2014/05/11 00:00:00" toDate] rule:@"before:2014/05/11 00:00:01"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:[@"2014/05/11 00:00:00" toDate] rule:@"after:2014/05/10 23:59:59"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"2014/05/11 00:00:00" rule:@"before:2014/05/10 23:59:59"];
	EXPECTED( NO == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:@"2014/05/11 00:00:00" rule:@"after:2014/05/11 00:00:01"];
	EXPECTED( NO == valid );

	valid = [[SamuraiValidator sharedInstance] validate:[@"2014/05/11 00:00:00" toDate] rule:@"before:2014/05/10 23:59:59"];
	EXPECTED( NO == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:[@"2014/05/11 00:00:00" toDate] rule:@"after:2014/05/11 00:00:01"];
	EXPECTED( NO == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:@"2014/05/11 00:00:00" rule:@"before:2014/05/11 00:00:00"];
	EXPECTED( NO == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:@"2014/05/11 00:00:00" rule:@"after:2014/05/11 00:00:00"];
	EXPECTED( NO == valid );
}

DESCRIBE( between: )
{
	BOOL valid;
	
	valid = [[SamuraiValidator sharedInstance] validate:@"2" rule:@"between:1,3"];
	EXPECTED( YES == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:@(2) rule:@"between:1,3"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@(1) rule:@"between:1,3"];
	EXPECTED( NO == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@(3) rule:@"between:1,3"];
	EXPECTED( NO == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@(0) rule:@"between:1,3"];
	EXPECTED( NO == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:@(4) rule:@"between:1,3"];
	EXPECTED( NO == valid );
}

DESCRIBE( same: )
{
	BOOL valid;
	
	TODO( "same:xxx" );
}

DESCRIBE( size: )
{
	BOOL valid;
	
	valid = [[SamuraiValidator sharedInstance] validate:@(1234) rule:@"size:1234"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@(1234) rule:@"size:123"];
	EXPECTED( NO == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"1234" rule:@"size:4"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"" rule:@"size:4"];
	EXPECTED( NO == valid );

	valid = [[SamuraiValidator sharedInstance] validate:[@"1234" toData] rule:@"size:4"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:[NSData data] rule:@"size:4"];
	EXPECTED( NO == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:[NSURL URLWithString:@"http://www.qq.com"] rule:@"size:17"];
	EXPECTED( YES == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:[NSURL URLWithString:@"http://qq"] rule:@"size:17"];
	EXPECTED( NO == valid );

	valid = [[SamuraiValidator sharedInstance] validate:[NSURL URLWithString:@"http://www.qq.com"] rule:@"size:32"];
	EXPECTED( NO == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@[@1,@2,@3] rule:@"size:3"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@[] rule:@"size:3"];
	EXPECTED( NO == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@{@"1":@"1", @"2":@"2", @"3":@"3"} rule:@"size:3"];
	EXPECTED( YES == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:@{} rule:@"size:3"];
	EXPECTED( NO == valid );
}

DESCRIBE( date )
{
	BOOL valid;
	
	valid = [[SamuraiValidator sharedInstance] validate:[NSDate date] rule:@"date"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"1983/08/15 15:15:00 GMT+8" rule:@"date"];
	EXPECTED( YES == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:@"1983-08-15 15:15:00 GMT+8" rule:@"date"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"1983/08/15 15:15:00" rule:@"date"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"1983-08-15 15:15:00" rule:@"date"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"1983/08/15" rule:@"date"];
	EXPECTED( NO == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"1983-08-15" rule:@"date"];
	EXPECTED( NO == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"00:00:00" rule:@"date"];
	EXPECTED( NO == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"" rule:@"date"];
	EXPECTED( NO == valid );
}

DESCRIBE( dateformat: )
{
	BOOL valid;
	
	TODO( "dateformat:xxx" );
}

DESCRIBE( different: )
{
	BOOL valid;
	
	TODO( "different:xxx" );
}

DESCRIBE( min: )
{
	BOOL valid;
	
	valid = [[SamuraiValidator sharedInstance] validate:@(2) rule:@"min:2"];
	EXPECTED( YES == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:@(1) rule:@"min:2"];
	EXPECTED( NO == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:@"abc" rule:@"min:2"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"ab" rule:@"min:2"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@"a" rule:@"min:2"];
	EXPECTED( NO == valid );

	valid = [[SamuraiValidator sharedInstance] validate:[NSData data] rule:@"min:2"];
	EXPECTED( NO == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:[NSURL URLWithString:@"http://www.qq.com"] rule:@"min:10"];
	EXPECTED( YES == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:[NSURL URLWithString:@"http://qq"] rule:@"min:10"];
	EXPECTED( NO == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:[NSURL URLWithString:@"http://www.qq.com"] rule:@"min:20"];
	EXPECTED( NO == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:@[@1,@2,@3] rule:@"min:2"];
	EXPECTED( YES == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:@[] rule:@"min:2"];
	EXPECTED( NO == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:@{@"1":@"1", @"2":@"2", @"3":@"3"} rule:@"min:2"];
	EXPECTED( YES == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:@{} rule:@"min:2"];
	EXPECTED( NO == valid );
}

DESCRIBE( max: )
{
	BOOL valid;
	
	valid = [[SamuraiValidator sharedInstance] validate:@(2) rule:@"max:2"];
	EXPECTED( YES == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:@(3) rule:@"max:2"];
	EXPECTED( NO == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:@"abc" rule:@"max:2"];
	EXPECTED( NO == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:@"ab" rule:@"max:2"];
	EXPECTED( YES == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:@"a" rule:@"max:2"];
	EXPECTED( YES == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:[NSData data] rule:@"max:2"];
	EXPECTED( YES == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:[NSURL URLWithString:@"http://www.qq.com"] rule:@"max:10"];
	EXPECTED( NO == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:[NSURL URLWithString:@"http://qq"] rule:@"max:10"];
	EXPECTED( YES == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:[NSURL URLWithString:@"http://www.qq.com"] rule:@"max:20"];
	EXPECTED( YES == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:@[@1,@2,@3] rule:@"max:2"];
	EXPECTED( NO == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:@[] rule:@"max:2"];
	EXPECTED( YES == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:@{@"1":@"1", @"2":@"2", @"3":@"3"} rule:@"max:2"];
	EXPECTED( NO == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:@{} rule:@"max:2"];
	EXPECTED( YES == valid );
}

DESCRIBE( required: )
{
	BOOL valid;
	
	valid = [[SamuraiValidator sharedInstance] validate:@(1) rule:@"required"];
	EXPECTED( YES == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:@"abc" rule:@"required"];
	EXPECTED( YES == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:[NSData data] rule:@"required"];
	EXPECTED( YES == valid );
	
	valid = [[SamuraiValidator sharedInstance] validate:[NSURL URLWithString:@"http://www.qq.com"] rule:@"required"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@[] rule:@"required"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:@{} rule:@"required"];
	EXPECTED( YES == valid );

	valid = [[SamuraiValidator sharedInstance] validate:nil rule:@"required"];
	EXPECTED( NO == valid );
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#import "_pragma_pop.h"
