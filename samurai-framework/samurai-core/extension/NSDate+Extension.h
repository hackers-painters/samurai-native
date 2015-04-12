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

#import "Samurai_Config.h"
#import "Samurai_Property.h"

#pragma mark -

#define SECOND		(1)
#define MINUTE		(60 * SECOND)
#define HOUR		(60 * MINUTE)
#define DAY			(24 * HOUR)
#define MONTH		(30 * DAY)
#define YEAR		(12 * MONTH)
#define NOW			[NSDate date]

#pragma mark -

typedef enum
{
	WeekdayType_Sunday = 1,
	WeekdayType_Monday,
	WeekdayType_Tuesday,
	WeekdayType_Wednesday,
	WeekdayType_Thursday,
	WeekdayType_Friday,
	WeekdayType_Saturday
} WeekdayType;

#pragma mark -

@interface NSDate(Extension)

@prop_readonly( NSInteger,		year );
@prop_readonly( NSInteger,		month );
@prop_readonly( NSInteger,		day );
@prop_readonly( NSInteger,		hour );
@prop_readonly( NSInteger,		minute );
@prop_readonly( NSInteger,		second );
@prop_readonly( WeekdayType,	weekday );

+ (NSTimeInterval)unixTime;
+ (NSString *)unixDate;

+ (NSDate *)fromString:(NSString *)string;

+ (NSDateFormatter *)format;
+ (NSDateFormatter *)format:(NSString *)format;
+ (NSDateFormatter *)format:(NSString *)format timeZoneGMT:(NSInteger)hours;
+ (NSDateFormatter *)format:(NSString *)format timeZoneName:(NSString *)name;

- (NSString *)toString:(NSString *)format;
- (NSString *)toString:(NSString *)format timeZoneGMT:(NSInteger)hours;
- (NSString *)toString:(NSString *)format timeZoneName:(NSString *)name;

@end
