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

#import "NSString+Extension.h"
#import "NSData+Extension.h"
#import "NSObject+Extension.h"

#import "Samurai_Encoding.h"
#import "Samurai_System.h"
#import "Samurai_UnitTest.h"

#import "_pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSString(Extension)

@def_prop_dynamic( NSString *,				MD5String );
@def_prop_dynamic( NSData *,				MD5Data );

@def_prop_dynamic( NSString *,				SHA1String );
@def_prop_dynamic( NSData *,				SHA1Data );

@def_prop_dynamic( NSData *,				BASE64Decrypted );

- (NSString *)MD5String
{
	return [[NSData dataWithBytes:[self UTF8String] length:[self length]] MD5String];
}

- (NSData *)MD5Data
{
	return [[NSData dataWithBytes:[self UTF8String] length:[self length]] MD5Data];
}

- (NSString *)SHA1String
{
	return [[NSData dataWithBytes:[self UTF8String] length:[self length]] SHA1String];
}

- (NSData *)SHA1Data
{
	return [[NSData dataWithBytes:[self UTF8String] length:[self length]] SHA1Data];
}

- (NSData *)BASE64Decrypted
{
	static char * __base64EncodingTable = (char *)"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
	static char * __base64DecodingTable = nil;

	// copy from THREE20
	
	if ( 0 == [self length] )
	{
		return [NSData data];
	}
	
	if ( NULL == __base64DecodingTable )
	{
		__base64DecodingTable = (char *)malloc( 256 );
		if ( NULL == __base64DecodingTable )
		{
			return nil;
		}
		
		memset( __base64DecodingTable, CHAR_MAX, 256 );
		
		for ( int i = 0; i < 64; i++)
		{
			__base64DecodingTable[(short)__base64EncodingTable[i]] = (char)i;
		}
	}
	
	const char * characters = [self cStringUsingEncoding:NSASCIIStringEncoding];
	if ( NULL == characters )     //  Not an ASCII string!
	{
		return nil;
	}
	
	char * bytes = (char *)malloc( ([self length] + 3) * 3 / 4 );
	if ( NULL == bytes )
	{
		return nil;
	}
	
	NSUInteger length = 0;
	NSUInteger i = 0;
	
	while ( 1 )
	{
		char	buffer[4] = { 0 };
		short	bufferLength = 0;
		
		for ( bufferLength = 0; bufferLength < 4; i++ )
		{
			if ( characters[i] == '\0' )
			{
				break;
			}
			
			if ( isspace(characters[i]) || characters[i] == '=' )
			{
				continue;
			}
			
			buffer[bufferLength] = __base64DecodingTable[(short)characters[i]];
			if ( CHAR_MAX == buffer[bufferLength++] )
			{
				free(bytes);
				return nil;
			}
		}
		
		if ( 0 == bufferLength )
		{
			break;
		}
		
		if ( 1 == bufferLength )
		{
			// At least two characters are needed to produce one byte!
			
			free(bytes);
			return nil;
		}
		
        //  Decode the characters in the buffer to bytes.
		
		bytes[length++] = (char)((buffer[0] << 2) | (buffer[1] >> 4));
		
		if (bufferLength > 2)
		{
			bytes[length++] = (char)((buffer[1] << 4) | (buffer[2] >> 2));
		}
		
		if (bufferLength > 3)
		{
			bytes[length++] = (char)((buffer[2] << 6) | buffer[3]);
		}
	}
	
	realloc( bytes, length );
	
	return [NSData dataWithBytesNoCopy:bytes length:length];
}

- (NSArray *)allURLs
{
	NSMutableArray * array = [NSMutableArray array];
	NSCharacterSet * charSet = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789$-_.+!*'():/"] invertedSet];

	for ( NSUInteger stringIndex = 0; stringIndex < self.length; )
	{
		NSRange searchRange = NSMakeRange(stringIndex, self.length - stringIndex);
		NSRange httpRange = [self rangeOfString:@"http://" options:NSCaseInsensitiveSearch range:searchRange];
		NSRange httpsRange = [self rangeOfString:@"https://" options:NSCaseInsensitiveSearch range:searchRange];
		
		NSRange startRange;
		if ( httpRange.location == NSNotFound )
		{
			startRange = httpsRange;
		}
		else if ( httpsRange.location == NSNotFound )
		{
			startRange = httpRange;
		}
		else
		{
			startRange = (httpRange.location < httpsRange.location) ? httpRange : httpsRange;
		}
		
		if (startRange.location == NSNotFound)
		{
			break;			
		}
		else
		{
			NSRange beforeRange = NSMakeRange( searchRange.location, startRange.location - searchRange.location );
			if ( beforeRange.length )
			{
//				NSString * text = [string substringWithRange:beforeRange];
//				[array addObject:text];
			}

			NSRange subSearchRange = NSMakeRange(startRange.location, self.length - startRange.location);
//			NSRange endRange = [self rangeOfString:@" " options:NSCaseInsensitiveSearch range:subSearchRange];
			NSRange endRange = [self rangeOfCharacterFromSet:charSet options:NSCaseInsensitiveSearch range:subSearchRange];
			if ( endRange.location == NSNotFound)
			{
				NSString * url = [self substringWithRange:subSearchRange];
				[array addObject:url];
				break;				
			}
			else
			{
				NSRange URLRange = NSMakeRange(startRange.location, endRange.location - startRange.location);
				NSString * url = [self substringWithRange:URLRange];
				[array addObject:url];
				
				stringIndex = endRange.location;
			}
		}
	}
	
	return array;
}

+ (NSString *)queryStringFromDictionary:(NSDictionary *)dict
{
    return [self queryStringFromDictionary:dict encoding:YES];
}

+ (NSString *)queryStringFromDictionary:(NSDictionary *)dict encoding:(BOOL)encoding
{
    NSMutableArray * pairs = [NSMutableArray array];
	for ( NSString * key in dict.allKeys )
	{
		NSString * value = [((NSObject *)[dict objectForKey:key]) toString];
		NSString * urlEncoding = encoding ? [value URLEncoding] : value;
		[pairs addObject:[NSString stringWithFormat:@"%@=%@", key, urlEncoding]];
	}
	
	return [pairs componentsJoinedByString:@"&"];
}

+ (NSString *)queryStringFromArray:(NSArray *)array
{
    return [self queryStringFromArray:array encoding:YES];
}

+ (NSString *)queryStringFromArray:(NSArray *)array encoding:(BOOL)encoding
{
	NSMutableArray *pairs = [NSMutableArray array];
	
	for ( NSUInteger i = 0; i < [array count]; i += 2 )
	{
		NSObject * obj1 = [array objectAtIndex:i];
		NSObject * obj2 = [array objectAtIndex:i + 1];
		
		NSString * key = nil;
		NSString * value = nil;
		
		if ( [obj1 isKindOfClass:[NSNumber class]] )
		{
			key = [(NSNumber *)obj1 stringValue];
		}
		else if ( [obj1 isKindOfClass:[NSString class]] )
		{
			key = (NSString *)obj1;
		}
		else
		{
			continue;
		}
		
		if ( [obj2 isKindOfClass:[NSNumber class]] )
		{
			value = [(NSNumber *)obj2 stringValue];
		}
		else if ( [obj1 isKindOfClass:[NSString class]] )
		{
			value = (NSString *)obj2;
		}
		else
		{
			continue;
		}
		
		NSString * urlEncoding = encoding ? [value URLEncoding] : value;
		[pairs addObject:[NSString stringWithFormat:@"%@=%@", key, urlEncoding]];
	}
	
	return [pairs componentsJoinedByString:@"&"];
}

+ (NSString *)queryStringFromKeyValues:(id)first, ...
{
	NSMutableDictionary * dict = [NSMutableDictionary dictionary];
	
	va_list args;
	va_start( args, first );
	
	for ( ;; )
	{
		NSObject<NSCopying> * key = [dict count] ? va_arg( args, NSObject * ) : first;
		if ( nil == key )
			break;
		
		NSObject * value = va_arg( args, NSObject * );
		if ( nil == value )
			break;
		
		[dict setObject:value forKey:key];
	}
	va_end( args );
	return [NSString queryStringFromDictionary:dict];
}

- (NSString *)urlByAppendingDict:(NSDictionary *)params
{
    return [self urlByAppendingDict:params encoding:YES];
}

- (NSString *)urlByAppendingDict:(NSDictionary *)params encoding:(BOOL)encoding
{
    NSURL * parsedURL = [NSURL URLWithString:self];
	NSString * queryPrefix = parsedURL.query ? @"&" : @"?";
	NSString * query = [NSString queryStringFromDictionary:params encoding:encoding];
	return [NSString stringWithFormat:@"%@%@%@", self, queryPrefix, query];	
}

- (NSString *)urlByAppendingArray:(NSArray *)params
{
    return [self urlByAppendingArray:params encoding:YES];
}

- (NSString *)urlByAppendingArray:(NSArray *)params encoding:(BOOL)encoding
{
    NSURL * parsedURL = [NSURL URLWithString:self];
	NSString * queryPrefix = parsedURL.query ? @"&" : @"?";
	NSString * query = [NSString queryStringFromArray:params encoding:encoding];
	return [NSString stringWithFormat:@"%@%@%@", self, queryPrefix, query];		
}

- (NSString *)urlByAppendingKeyValues:(id)first, ...
{
	NSMutableDictionary * dict = [NSMutableDictionary dictionary];
	
	va_list args;
	va_start( args, first );
	
	for ( ;; )
	{
		NSObject<NSCopying> * key = [dict count] ? va_arg( args, NSObject * ) : first;
		if ( nil == key )
			break;
		
		NSObject * value = va_arg( args, NSObject * );
		if ( nil == value )
			break;

		[dict setObject:value forKey:key];
	}
    va_end( args );
	return [self urlByAppendingDict:dict];
}

- (NSString *)URLEncoding
{
	return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"]];
}

- (NSString *)URLDecoding
{
	NSMutableString * string = [NSMutableString stringWithString:self];

	[string replaceOccurrencesOfString:@"+"
							withString:@" "  
							   options:NSLiteralSearch  
								 range:NSMakeRange(0, [string length])];

	return [string stringByRemovingPercentEncoding];
}

- (NSString *)trim
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)flat
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
}

- (NSString *)unwrap
{
	if ( self.length >= 2 )
	{
		if ( [self hasPrefix:@"\""] && [self hasSuffix:@"\""] )
		{
			return [self substringWithRange:NSMakeRange(1, self.length - 2)];
		}

		if ( [self hasPrefix:@"'"] && [self hasSuffix:@"'"] )
		{
			return [self substringWithRange:NSMakeRange(1, self.length - 2)];
		}
	}

	return self;
}

- (NSString *)normalize
{
//	return [self stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
//	return [self stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];

	NSArray * lines = [self componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	
	if ( lines && lines.count )
	{
		NSMutableString * mergedString = [NSMutableString string];
		
		for ( NSString * line in lines )
		{
			NSString * trimed = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			
			if ( trimed && trimed.length )
			{
				[mergedString appendString:trimed];
			}
		}
		
		return mergedString;
	}

	return nil;
}

- (NSString *)repeat:(NSUInteger)count
{
	if ( 0 == count )
		return @"";

	NSMutableString * text = [NSMutableString string];
	
	for ( NSUInteger i = 0; i < count; ++i )
	{
		[text appendString:self];
	}
	
	return text;
}

- (NSString *)strongify
{
	return [self stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
}

- (BOOL)match:(NSString *)expression
{
	NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:expression
																			options:NSRegularExpressionCaseInsensitive
																			  error:nil];
	if ( nil == regex )
		return NO;
	
	NSUInteger numberOfMatches = [regex numberOfMatchesInString:self
														options:0
														  range:NSMakeRange(0, self.length)];
	if ( 0 == numberOfMatches )
		return NO;
	
	return YES;
}

- (BOOL)matchAnyOf:(NSArray *)array
{
	for ( NSString * str in array )
	{
		if ( NSOrderedSame == [self compare:str options:NSCaseInsensitiveSearch] )
		{
			return YES;
		}
	}
	
	return NO;
}

- (BOOL)empty
{
	return [self length] > 0 ? NO : YES;
}

- (BOOL)notEmpty
{
	return [self length] > 0 ? YES : NO;
}

- (BOOL)eq:(NSString *)other
{
	return [self isEqualToString:other];
}

- (BOOL)equal:(NSString *)other
{
	return [self isEqualToString:other];
}

- (BOOL)is:(NSString *)other
{
	return [self isEqualToString:other];
}

- (BOOL)isNot:(NSString *)other
{
	return NO == [self isEqualToString:other];
}

- (BOOL)isValueOf:(NSArray *)array
{
	return [self isValueOf:array caseInsens:NO];
}

- (BOOL)isValueOf:(NSArray *)array caseInsens:(BOOL)caseInsens
{
	NSStringCompareOptions option = caseInsens ? NSCaseInsensitiveSearch : 0;
	
	for ( NSObject * obj in array )
	{
		if ( NO == [obj isKindOfClass:[NSString class]] )
			continue;
		
		if ( NSOrderedSame == [(NSString *)obj compare:self options:option] )
			return YES;
	}
	
	return NO;
}

- (BOOL)isNumber
{
	NSString *		regex = @"-?[0-9.]+";
	NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	
	return [pred evaluateWithObject:self];
}

- (BOOL)isNumberWithUnit:(NSString *)unit
{
	NSString *		regex = [NSString stringWithFormat:@"-?[0-9.]+%@", unit];
	NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	
	return [pred evaluateWithObject:self];
}

- (BOOL)isEmail
{
	NSString *		regex = @"[A-Z0-9a-z._\%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}";
	NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

	return [pred evaluateWithObject:[self lowercaseString]];
}

- (BOOL)isUrl
{
	return ([self hasPrefix:@"http://"] || [self hasPrefix:@"https://"]) ? YES : NO;
}

- (BOOL)isIPAddress
{
	NSArray *			components = [self componentsSeparatedByString:@"."];
	NSCharacterSet *	invalidCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];

	if ( [components count] == 4 )
	{
		NSString *part1 = [components objectAtIndex:0];
		NSString *part2 = [components objectAtIndex:1];
		NSString *part3 = [components objectAtIndex:2];
		NSString *part4 = [components objectAtIndex:3];
		
		if ( 0 == [part1 length] ||
			0 == [part2 length] ||
			0 == [part3 length] ||
			0 == [part4 length] )
		{
			return NO;
		}
		
		if ( [part1 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound &&
			[part2 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound &&
			[part3 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound &&
			[part4 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound )
		{
			if ( [part1 intValue] <= 255 &&
				[part2 intValue] <= 255 &&
				[part3 intValue] <= 255 &&
				[part4 intValue] <= 255 )
			{
				return YES;
			}
		}
	}
	
	return NO;
}

- (NSString *)substringFromIndex:(NSUInteger)from untilString:(NSString *)string
{
	return [self substringFromIndex:from untilString:string endOffset:NULL];
}

- (NSString *)substringFromIndex:(NSUInteger)from untilString:(NSString *)string endOffset:(NSUInteger *)endOffset
{
	if ( 0 == self.length )
		return nil;
	
	if ( from >= self.length )
		return nil;
	
	NSRange range = NSMakeRange( from, self.length - from );
	NSRange range2 = [self rangeOfString:string options:NSCaseInsensitiveSearch range:range];
	
	if ( NSNotFound == range2.location )
	{
		if ( endOffset )
		{
			*endOffset = range.location + range.length;
		}
		
		return [self substringWithRange:range];
	}
	else
	{
		if ( endOffset )
		{
			*endOffset = range2.location + range2.length;
		}
		
		return [self substringWithRange:NSMakeRange(from, range2.location - from)];
	}
}

- (NSString *)substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet *)charset
{
	return [self substringFromIndex:from untilCharset:charset endOffset:NULL];
}

- (NSString *)substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet *)charset endOffset:(NSUInteger *)endOffset
{
	if ( 0 == self.length )
		return nil;
	
	if ( from >= self.length )
		return nil;

	NSRange range = NSMakeRange( from, self.length - from );
	NSRange range2 = [self rangeOfCharacterFromSet:charset options:NSCaseInsensitiveSearch range:range];

	if ( NSNotFound == range2.location )
	{
		if ( endOffset )
		{
			*endOffset = range.location + range.length;
		}
		
		return [self substringWithRange:range];
	}
	else
	{
		if ( endOffset )
		{
			*endOffset = range2.location + range2.length;
		}

		return [self substringWithRange:NSMakeRange(from, range2.location - from)];
	}
}

- (NSUInteger)countFromIndex:(NSUInteger)from inCharset:(NSCharacterSet *)charset
{
	if ( 0 == self.length )
		return 0;
	
	if ( from >= self.length )
		return 0;
	
	NSCharacterSet * reversedCharset = [charset invertedSet];

	NSRange range = NSMakeRange( from, self.length - from );
	NSRange range2 = [self rangeOfCharacterFromSet:reversedCharset options:NSCaseInsensitiveSearch range:range];

	if ( NSNotFound == range2.location )
	{
		return self.length - from;
	}
	else
	{
		return range2.location - from;		
	}
}

- (NSArray *)pairSeparatedByString:(NSString *)separator
{
	if ( nil == separator )
		return nil;
	
	NSUInteger	offset = 0;
	NSString *	key = [self substringFromIndex:0 untilCharset:[NSCharacterSet characterSetWithCharactersInString:separator] endOffset:&offset];
	NSString *	val = nil;

	if ( nil == key || offset >= self.length )
		return nil;
	
	val = [self substringFromIndex:offset];
	if ( nil == val )
		return nil;

	return [NSArray arrayWithObjects:key, val, nil];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( Core, NSString_Extension )

DESCRIBE( before )
{
}

DESCRIBE( after )
{
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#import "_pragma_pop.h"
