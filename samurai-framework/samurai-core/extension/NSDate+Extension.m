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

#import "NSDate+Extension.h"

#import "Samurai_UnitTest.h"

#import "_pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSDate(Extension)

@def_prop_dynamic( NSInteger,	year );
@def_prop_dynamic( NSInteger,	month );
@def_prop_dynamic( NSInteger,	day );
@def_prop_dynamic( NSInteger,	hour );
@def_prop_dynamic( NSInteger,	minute );
@def_prop_dynamic( NSInteger,	second );
@def_prop_dynamic( NSInteger,	weekday );

- (NSInteger)year
{
#ifdef __IPHONE_8_0
	return [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self].year;
#else
	return [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:self].year;
#endif
}

- (NSInteger)month
{
#ifdef __IPHONE_8_0
	return [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self].year;
#else
	return [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:self].month;
#endif
}

- (NSInteger)day
{
#ifdef __IPHONE_8_0
	return [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self].year;
#else
	return [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:self].day;
#endif
}

- (NSInteger)hour
{
#ifdef __IPHONE_8_0
	return [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self].year;
#else
	return [[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:self].hour;
#endif
}

- (NSInteger)minute
{
#ifdef __IPHONE_8_0
	return [[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self].year;
#else
	return [[NSCalendar currentCalendar] components:NSMinuteCalendarUnit fromDate:self].minute;
#endif
}

- (NSInteger)second
{
#ifdef __IPHONE_8_0
	return [[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self].year;
#else
	return [[NSCalendar currentCalendar] components:NSSecondCalendarUnit fromDate:self].second;
#endif
}

- (WeekdayType)weekday
{
#ifdef __IPHONE_8_0
	return (WeekdayType)[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self].weekday;
#else
	return (WeekdayType)[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:self].weekday;
#endif
}

+ (NSTimeInterval)unixTime
{
	return [[NSDate date] timeIntervalSince1970];
}

+ (NSString *)unixDate
{
	return [[NSDate date] toString:@"yyyy/MM/dd HH:mm:ss z"];
}

+ (NSDate *)fromString:(NSString *)string
{
	if ( nil == string || 0 == string.length )
		return nil;
	
	NSDate * date = [[NSDate format:@"yyyy/MM/dd HH:mm:ss z"] dateFromString:string];
	if ( nil == date )
	{
		date = [[NSDate format:@"yyyy-MM-dd HH:mm:ss z"] dateFromString:string];
		if ( nil == date )
		{
			date = [[NSDate format:@"yyyy-MM-dd HH:mm:ss"] dateFromString:string];
			if ( nil == date )
			{
				date = [[NSDate format:@"yyyy/MM/dd HH:mm:ss"] dateFromString:string];
			}
		}
	}
	
	return date;
}

+ (NSDateFormatter *)format
{
	return [self format:@"yyyy/MM/dd HH:mm:ss z"];
}

+ (NSDateFormatter *)format:(NSString *)format
{
	return [self format:format timeZoneGMT:[[NSTimeZone defaultTimeZone] secondsFromGMT]];
}

+ (NSDateFormatter *)format:(NSString *)format timeZoneGMT:(NSInteger)seconds
{
	static __strong NSMutableDictionary * __formatters = nil;
	
	if ( nil == __formatters )
	{
		__formatters = [[NSMutableDictionary alloc] init];
	}
	
	NSString * key = [NSString stringWithFormat:@"%@ %ld", format, (long)seconds];
	NSDateFormatter * formatter = [__formatters objectForKey:key];
	if ( nil == formatter )
	{
		formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:format];
		[formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:seconds]];
		[__formatters setObject:formatter forKey:key];
	}
	
	return formatter;
}

+ (NSDateFormatter *)format:(NSString *)format timeZoneName:(NSString *)name
{
	static __strong NSMutableDictionary * __formatters = nil;
	
	if ( nil == __formatters )
	{
		__formatters = [[NSMutableDictionary alloc] init];
	}
	
	NSString * key = [NSString stringWithFormat:@"%@ %@", format, name];
	NSDateFormatter * formatter = [__formatters objectForKey:key];
	if ( nil == formatter )
	{
		formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:format];
		[formatter setTimeZone:[NSTimeZone timeZoneWithName:name]];
		[__formatters setObject:formatter forKey:key];
	}
	
	return formatter;
}

- (NSString *)toString:(NSString *)format
{
	return [self toString:format timeZoneGMT:[[NSTimeZone defaultTimeZone] secondsFromGMT]];
}

- (NSString *)toString:(NSString *)format timeZoneGMT:(NSInteger)seconds
{
	return [[NSDate format:format timeZoneGMT:seconds] stringFromDate:self];
}

- (NSString *)toString:(NSString *)format timeZoneName:(NSString *)name
{
	return [[NSDate format:format timeZoneName:name] stringFromDate:self];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( Core, NSDate_Extension )
{
	
}

DESCRIBE( before )
{
}

DESCRIBE( Format1 )
{
	NSDate * date = [NSDate fromString:@"1983/08/15 15:15:00 GMT+8"];
	EXPECTED( date.year == 1983 );
	EXPECTED( date.month == 8 );
	EXPECTED( date.day == 15 );
	EXPECTED( date.hour == 15 );
	EXPECTED( date.minute == 15 );
	EXPECTED( date.second == 0 );
	EXPECTED( date.weekday == WeekdayType_Monday );

	NSString * string = [date toString:@"yyyy/MM/dd HH:mm:ss z" timeZoneGMT:8 * HOUR];
	EXPECTED( [string isEqualToString:@"1983/08/15 15:15:00 GMT+8"] );
}

DESCRIBE( Format2 )
{
	NSDate * date = [NSDate fromString:@"1983-08-15 15:15:00 GMT+8"];
	EXPECTED( date.year == 1983 );
	EXPECTED( date.month == 8 );
	EXPECTED( date.day == 15 );
	EXPECTED( date.hour == 15 );
	EXPECTED( date.minute == 15 );
	EXPECTED( date.second == 0 );
	EXPECTED( date.weekday == WeekdayType_Monday );

	NSString * string = [date toString:@"yyyy-MM-dd HH:mm:ss z" timeZoneGMT:8 * HOUR];
	EXPECTED( [string isEqualToString:@"1983-08-15 15:15:00 GMT+8"] );
}

DESCRIBE( Format3 )
{
	NSDate * date = [NSDate fromString:@"1983/08/15 15:15:00"];
	EXPECTED( date.year == 1983 );
	EXPECTED( date.month == 8 );
	EXPECTED( date.day == 15 );
	EXPECTED( date.hour == 15 );
	EXPECTED( date.minute == 15 );
	EXPECTED( date.second == 0 );
	EXPECTED( date.weekday == WeekdayType_Monday );

	NSString * string = [date toString:@"yyyy/MM/dd HH:mm:ss" timeZoneGMT:8 * HOUR];
	EXPECTED( [string isEqualToString:@"1983/08/15 15:15:00"] );
}

DESCRIBE( Format4 )
{
	NSDate * date = [NSDate fromString:@"1983-08-15 15:15:00"];
	EXPECTED( date.year == 1983 );
	EXPECTED( date.month == 8 );
	EXPECTED( date.day == 15 );
	EXPECTED( date.hour == 15 );
	EXPECTED( date.minute == 15 );
	EXPECTED( date.second == 0 );
	EXPECTED( date.weekday == WeekdayType_Monday );

	NSString * string = [date toString:@"yyyy-MM-dd HH:mm:ss" timeZoneGMT:8 * HOUR];
	EXPECTED( [string isEqualToString:@"1983-08-15 15:15:00"] );
}

DESCRIBE( Unix format )
{
	NSTimeInterval unixTime = [NSDate unixTime];
	EXPECTED( unixTime >= NSTimeIntervalSince1970 );

	NSString * unixDateString = [NSDate unixDate];
	EXPECTED( unixDateString );

	NSDate * unixDate = [NSDate fromString:unixDateString];
	EXPECTED( nil != unixDate );

	NSString * unixDateString2 = [unixDate toString:@"yyyy/MM/dd HH:mm:ss z" timeZoneGMT:8 * HOUR];
	EXPECTED( [unixDateString2 isEqualToString:unixDateString] );
}

DESCRIBE( after )
{
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#import "_pragma_pop.h"
