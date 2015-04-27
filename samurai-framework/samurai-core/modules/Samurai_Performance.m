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

#import "Samurai_Performance.h"
#import "Samurai_Log.h"
#import "Samurai_UnitTest.h"

#import "NSArray+Extension.h"
#import "NSMutableArray+Extension.h"

#import "_pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiPerformance
{
	NSMutableDictionary * _tags;
}

@def_singleton( SamuraiPerformance );

- (id)init
{
	self = [super init];
	if ( self )
	{
		_tags = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)enter:(NSString *)tag
{
	NSNumber * time = [NSNumber numberWithDouble:CACurrentMediaTime()];
	NSString * name = [NSString stringWithFormat:@"%@ enter", tag];
	
	[_tags setObject:time forKey:name];
}

- (void)leave:(NSString *)tag
{
	@autoreleasepool
	{
		NSString * name1 = [NSString stringWithFormat:@"%@ enter", tag];
		NSString * name2 = [NSString stringWithFormat:@"%@ leave", tag];
	
	#if __SAMURAI_LOGGING__
		
		CFTimeInterval time1 = [[_tags objectForKey:name1] doubleValue];
		CFTimeInterval time2 = CACurrentMediaTime();
		
		PERF( @"Time '%@' = %.0f(ms)", tag, fabs(time2 - time1) );

	#endif	// #if __SAMURAI_LOGGING__

		[_tags removeObjectForKey:name1];
		[_tags removeObjectForKey:name2];
	}
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( Core, Performance )

DESCRIBE( before )
{
}

DESCRIBE( after )
{
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#import "_pragma_pop.h"
