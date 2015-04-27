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

#import "Samurai_Encoding.h"
#import "Samurai_Assert.h"
#import "Samurai_UnitTest.h"
#import "Samurai_Runtime.h"

#import "NSObject+Extension.h"
#import "NSDate+Extension.h"
#import "NSDictionary+Extension.h"
#import "NSMutableDictionary+Extension.h"

#import "_pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSObject(Encoding)

- (NSObject *)converToType:(EncodingType)type
{
	if ( EncodingType_Null == type )
	{
		return [NSNull null];
	}
	else if ( EncodingType_Number == type )
	{
		return [self toNumber];
	}
	else if ( EncodingType_String == type )
	{
		return [self toString];
	}
	else if ( EncodingType_Date == type )
	{
		return [self toDate];
	}
	else if ( EncodingType_Data == type )
	{
		return [self toData];
	}
	else if ( EncodingType_Url == type )
	{
		return [self toURL];
	}
	else if ( EncodingType_Array == type )
	{
		return nil;
	}
	else if ( EncodingType_Dict == type )
	{
		return nil;
	}
	else
	{
		return nil;
	}
}

@end

#pragma mark -

@implementation SamuraiEncoding

+ (BOOL)isReadOnly:(const char *)attr
{
	if ( strstr(attr, "_ro") || strstr(attr, ",R") )
	{
		return YES;
	}
	
	return NO;
}

#pragma mark -

+ (EncodingType)typeOfAttribute:(const char *)attr
{
	if ( NULL == attr )
	{
		return EncodingType_Unknown;
	}

	if ( attr[0] != 'T' )
		return EncodingType_Unknown;
	
	const char * type = &attr[1];
	if ( type[0] == '@' )
	{
		if ( type[1] != '"' )
			return EncodingType_Unknown;
		
		char typeClazz[128] = { 0 };
		
		const char * clazzBegin = &type[2];
		const char * clazzEnd = strchr( clazzBegin, '"' );
		
		if ( clazzEnd && clazzBegin != clazzEnd )
		{
			unsigned int size = (unsigned int)(clazzEnd - clazzBegin);
			strncpy( &typeClazz[0], clazzBegin, size );
		}
		
		return [self typeOfClassName:typeClazz];
	}
	else if ( type[0] == '[' )
	{
		return EncodingType_Unknown;
	}
	else if ( type[0] == '{' )
	{
		return EncodingType_Unknown;
	}
	else
	{
		if ( type[0] == 'c' || type[0] == 'C' )
		{
			return EncodingType_Unknown;
		}
		else if ( type[0] == 'i' || type[0] == 's' || type[0] == 'l' || type[0] == 'q' )
		{
			return EncodingType_Unknown;
		}
		else if ( type[0] == 'I' || type[0] == 'S' || type[0] == 'L' || type[0] == 'Q' )
		{
			return EncodingType_Unknown;
		}
		else if ( type[0] == 'f' )
		{
			return EncodingType_Unknown;
		}
		else if ( type[0] == 'd' )
		{
			return EncodingType_Unknown;
		}
		else if ( type[0] == 'B' )
		{
			return EncodingType_Unknown;
		}
		else if ( type[0] == 'v' )
		{
			return EncodingType_Unknown;
		}
		else if ( type[0] == '*' )
		{
			return EncodingType_Unknown;
		}
		else if ( type[0] == ':' )
		{
			return EncodingType_Unknown;
		}
		else if ( 0 == strcmp(type, "bnum") )
		{
			return EncodingType_Unknown;
		}
		else if ( type[0] == '^' )
		{
			return EncodingType_Unknown;
		}
		else if ( type[0] == '?' )
		{
			return EncodingType_Unknown;
		}
		else
		{
			return EncodingType_Unknown;
		}
	}
	
	return EncodingType_Unknown;
}

+ (EncodingType)typeOfClass:(Class)typeClazz
{
	if ( nil == typeClazz )
	{
		return EncodingType_Unknown;
	}

	const char * className = [[typeClazz description] UTF8String];
	return [self typeOfClassName:className];
}

+ (EncodingType)typeOfClassName:(const char *)className
{
	if ( nil == className )
	{
		return EncodingType_Unknown;
	}

#undef	__MATCH_CLASS
#define	__MATCH_CLASS( X ) \
		0 == strcmp((const char *)className, "NS" #X) || \
		0 == strcmp((const char *)className, "NSMutable" #X) || \
		0 == strcmp((const char *)className, "_NSInline" #X) || \
		0 == strcmp((const char *)className, "__NS" #X) || \
		0 == strcmp((const char *)className, "__NSMutable" #X) || \
		0 == strcmp((const char *)className, "__NSCF" #X) || \
		0 == strcmp((const char *)className, "__NSCFConstant" #X)
	
	if ( __MATCH_CLASS( Number ) )
	{
		return EncodingType_Number;
	}
	else if ( __MATCH_CLASS( String ) )
	{
		return EncodingType_String;
	}
	else if ( __MATCH_CLASS( Date ) )
	{
		return EncodingType_Date;
	}
	else if ( __MATCH_CLASS( Array ) )
	{
		return EncodingType_Array;
	}
	else if ( __MATCH_CLASS( Set ) )
	{
		return EncodingType_Array;
	}
	else if ( __MATCH_CLASS( Dictionary ) )
	{
		return EncodingType_Dict;
	}
	else if ( __MATCH_CLASS( Data ) )
	{
		return EncodingType_Data;
	}
	else if ( __MATCH_CLASS( URL ) )
	{
		return EncodingType_Url;
	}
	
	return EncodingType_Unknown;
}

+ (EncodingType)typeOfObject:(id)obj
{
	if ( nil == obj )
	{
		return EncodingType_Unknown;
	}
	
	if ( [obj isKindOfClass:[NSNumber class]] )
	{
		return EncodingType_Number;
	}
	else if ( [obj isKindOfClass:[NSString class]] )
	{
		return EncodingType_String;
	}
	else if ( [obj isKindOfClass:[NSDate class]] )
	{
		return EncodingType_Date;
	}
	else if ( [obj isKindOfClass:[NSArray class]] )
	{
		return EncodingType_Array;
	}
	else if ( [obj isKindOfClass:[NSSet class]] )
	{
		return EncodingType_Array;
	}
	else if ( [obj isKindOfClass:[NSDictionary class]] )
	{
		return EncodingType_Dict;
	}
	else if ( [obj isKindOfClass:[NSData class]] )
	{
		return EncodingType_Data;
	}
	else if ( [obj isKindOfClass:[NSURL class]] )
	{
		return EncodingType_Url;
	}
	else
	{
		const char * className = [[[obj class] description] UTF8String];
		return [self typeOfClassName:className];
	}
}

#pragma mark -

+ (NSString *)classNameOfAttribute:(const char *)attr
{
	if ( NULL == attr )
	{
		return nil;
	}

	if ( attr[0] != 'T' )
		return nil;
	
	const char * type = &attr[1];
	if ( type[0] == '@' )
	{
		if ( type[1] != '"' )
			return nil;
		
		char typeClazz[128] = { 0 };
		
		const char * clazz = &type[2];
		const char * clazzEnd = strchr( clazz, '"' );
		
		if ( clazzEnd && clazz != clazzEnd )
		{
			unsigned int size = (unsigned int)(clazzEnd - clazz);
			strncpy( &typeClazz[0], clazz, size );
		}
		
		return [NSString stringWithUTF8String:typeClazz];
	}
	
	return nil;
}

+ (NSString *)classNameOfClass:(Class)clazz
{
	if ( nil == clazz )
	{
		return nil;
	}

	const char * className = class_getName( clazz );
	if ( className )
	{
		return [NSString stringWithUTF8String:className];
	}
	
	return nil;
}

+ (NSString *)classNameOfObject:(id)obj
{
	if ( nil == obj )
	{
		return nil;
	}

	return [[obj class] description];
}

#pragma mark -

+ (Class)classOfAttribute:(const char *)attr
{
	if ( NULL == attr )
	{
		return nil;
	}

	NSString * className = [self classNameOfAttribute:attr];
	if ( nil == className )
		return nil;
	
	return NSClassFromString( className );
}

#pragma mark -

+ (BOOL)isAtomObject:(id)obj
{
	if ( nil == obj )
	{
		return NO;
	}

	return [self isAtomClass:[obj class]];
}

+ (BOOL)isAtomAttribute:(const char *)attr
{
	if ( NULL == attr )
	{
		return NO;
	}

	NSInteger encoding = [self typeOfAttribute:attr];
	
	if ( EncodingType_Unknown != encoding )
	{
		return YES;
	}
	else
	{
		return NO;
	}
}

+ (BOOL)isAtomClassName:(const char *)clazz
{
	if ( NULL == clazz )
	{
		return NO;
	}

	NSInteger encoding = [self typeOfClassName:clazz];
	
	if ( EncodingType_Unknown != encoding )
	{
		return YES;
	}
	else
	{
		return NO;
	}
}

+ (BOOL)isAtomClass:(Class)clazz
{
	if ( nil == clazz )
	{
		return NO;
	}

	NSInteger encoding = [self typeOfClass:clazz];
	
	if ( EncodingType_Unknown != encoding )
	{
		return YES;
	}
	else
	{
		return NO;
	}
}

@end

// ----------------------------------
// Unit test
// ----------------------------------
	 
#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( Core, Encoding )

DESCRIBE( before )
{
}

DESCRIBE( after )
{
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#import "_pragma_pop.h"
