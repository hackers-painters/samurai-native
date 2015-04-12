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

#import "NSArray+Extension.h"
#import "NSObject+Extension.h"

#import "Samurai_UnitTest.h"

#import "_pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSArray(Extension)

- (id)serialize
{
	if ( 0 == [self count] )
		return nil;
	
	NSMutableArray * array = [NSMutableArray array];
	
	for ( NSObject * element in self )
	{
		[array addObject:[element serialize]];
	}
	
	return array;
}

- (void)unserialize:(id)obj
{
}

- (void)zerolize
{
}

- (NSArray *)head:(NSUInteger)count
{
	if ( 0 == self.count || 0 == count )
	{
		return nil;
	}
	
	if ( self.count < count )
	{
		return self;
	}

	NSRange range;
	range.location = 0;
	range.length = count;

	return [self subarrayWithRange:range];
}

- (NSArray *)tail:(NSUInteger)count
{	
	if ( 0 == self.count || 0 == count )
	{
		return nil;
	}
	
	if ( self.count < count )
	{
		return self;
	}

	NSRange range;
	range.location = self.count - count;
	range.length = count;

	return [self subarrayWithRange:range];
}

- (NSString *)join
{
	return [self join:nil];
}

- (NSString *)join:(NSString *)delimiter
{
	if ( 0 == self.count )
	{
		return @"";
	}
	else if ( 1 == self.count )
	{
		return [[self objectAtIndex:0] description];
	}
	else
	{
		NSMutableString * result = [NSMutableString string];
		
		for ( NSUInteger i = 0; i < self.count; ++i )
		{
			[result appendString:[[self objectAtIndex:i] description]];
			
			if ( delimiter )
			{
				if ( i + 1 < self.count )
				{
					[result appendString:delimiter];
				}
			}
		}
		
		return result;
	}
}

#pragma mark -

- (id)safeObjectAtIndex:(NSUInteger)index
{
	if ( index >= self.count )
		return nil;

	return [self objectAtIndex:index];
}

- (id)safeSubarrayWithRange:(NSRange)range
{
	if ( 0 == self.count )
		return [NSArray array];

	if ( range.location >= self.count )
		return [NSArray array];

	range.length = MIN( range.length, self.count - range.location );
	if ( 0 == range.length )
		return [NSArray array];
	
	return [self subarrayWithRange:NSMakeRange(range.location, range.length)];
}

- (id)safeSubarrayFromIndex:(NSUInteger)index
{
	if ( 0 == self.count )
		return [NSArray array];
	
	if ( index >= self.count )
		return [NSArray array];
	
	return [self safeSubarrayWithRange:NSMakeRange(index, self.count - index)];
}

- (id)safeSubarrayWithCount:(NSUInteger)count
{
	if ( 0 == self.count )
		return [NSArray array];
	
	return [self safeSubarrayWithRange:NSMakeRange(0, count)];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( Core, NSArray_Extension )
{
	NSArray * _testArray;
}

DESCRIBE( before )
{
	_testArray = @[ @"1", @"2", @"3", @"4", @"5", @"6" ];
}

DESCRIBE( head/tail )
{
	NSArray * head4 = [_testArray head:4];
	
	EXPECTED( head4.count == 4 );
	EXPECTED( [head4[0] isEqualToString:@"1"] );
	EXPECTED( [head4[1] isEqualToString:@"2"] );
	EXPECTED( [head4[2] isEqualToString:@"3"] );
	EXPECTED( [head4[3] isEqualToString:@"4"] );

	NSArray * tail4 = [_testArray tail:4];
	
	EXPECTED( tail4.count == 4 );
	EXPECTED( [tail4[0] isEqualToString:@"3"] );
	EXPECTED( [tail4[1] isEqualToString:@"4"] );
	EXPECTED( [tail4[2] isEqualToString:@"5"] );
	EXPECTED( [tail4[3] isEqualToString:@"6"] );
}

DESCRIBE( join )
{
	NSString * string = [_testArray join];
	
	EXPECTED( string.length == 6 );
	EXPECTED( [string isEqualToString:@"123456"] );

	NSString * string2 = [_testArray join:@"_"];
	
	EXPECTED( string2.length == 11 );
	EXPECTED( [string2 isEqualToString:@"1_2_3_4_5_6"] );
}

DESCRIBE( empty )
{
	NSArray * empty = [NSArray array];
	
	EXPECTED( nil == [empty safeObjectAtIndex:0] );
	EXPECTED( nil == [empty safeObjectAtIndex:99] );
}

DESCRIBE( sub array )
{
	EXPECTED( nil != [_testArray safeObjectAtIndex:0] );
	EXPECTED( nil != [_testArray safeObjectAtIndex:1] );
	EXPECTED( nil != [_testArray safeObjectAtIndex:2] );
	EXPECTED( nil != [_testArray safeObjectAtIndex:3] );
	EXPECTED( nil != [_testArray safeObjectAtIndex:4] );
	EXPECTED( nil != [_testArray safeObjectAtIndex:5] );
	
	EXPECTED( nil == [_testArray safeObjectAtIndex:6] );
	EXPECTED( nil == [_testArray safeObjectAtIndex:7] );

	NSArray * subArray = [_testArray safeSubarrayWithRange:NSMakeRange(0, 6)];
	
	EXPECTED( subArray.count == 6 );
	EXPECTED( [subArray[0] isEqualToString:@"1"] );
	EXPECTED( [subArray[1] isEqualToString:@"2"] );
	EXPECTED( [subArray[2] isEqualToString:@"3"] );
	EXPECTED( [subArray[3] isEqualToString:@"4"] );
	EXPECTED( [subArray[4] isEqualToString:@"5"] );
	EXPECTED( [subArray[5] isEqualToString:@"6"] );

	NSArray * subArray2 = [_testArray safeSubarrayWithRange:NSMakeRange(0, 99)];
	
	EXPECTED( subArray2.count == 6 );
	EXPECTED( [subArray2[0] isEqualToString:@"1"] );
	EXPECTED( [subArray2[1] isEqualToString:@"2"] );
	EXPECTED( [subArray2[2] isEqualToString:@"3"] );
	EXPECTED( [subArray2[3] isEqualToString:@"4"] );
	EXPECTED( [subArray2[4] isEqualToString:@"5"] );
	EXPECTED( [subArray2[5] isEqualToString:@"6"] );

	NSArray * subArray3 = [_testArray safeSubarrayWithRange:NSMakeRange(5, 99)];
	
	EXPECTED( subArray3.count == 1 );
	EXPECTED( [subArray3[0] isEqualToString:@"6"] );

	NSArray * subArray4 = [_testArray safeSubarrayWithRange:NSMakeRange(6, 99)];
	
	EXPECTED( subArray4.count == 0 );

	NSArray * subArray5 = [_testArray safeSubarrayWithRange:NSMakeRange(99, 99)];
	
	EXPECTED( subArray5.count == 0 );
}

DESCRIBE( after )
{
	_testArray = nil;
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#import "_pragma_pop.h"
