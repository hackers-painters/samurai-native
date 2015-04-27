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

#import "Samurai_UnitTest.h"
#import "Samurai_Debug.h"
#import "Samurai_Log.h"
#import "Samurai_Runtime.h"

#import "_pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

#undef	MAX_UNITTEST_LOGS
#define	MAX_UNITTEST_LOGS	(100)

#pragma mark -

@implementation SamuraiTestFailure

@def_prop_strong( NSString *,	expr );
@def_prop_strong( NSString *,	file );
@def_prop_assign( NSInteger,	line );

+ (SamuraiTestFailure *)expr:(const char *)expr file:(const char *)file line:(int)line
{
	SamuraiTestFailure * failure = [[SamuraiTestFailure alloc] initWithName:@"UnitTest" reason:nil userInfo:nil];
	failure.expr = @(expr);
	failure.file = [@(file) lastPathComponent];
	failure.line = line;
	return failure;
}

@end

#pragma mark -

@implementation SamuraiTestCase
@end

#pragma mark -

@implementation SamuraiUnitTest
{
	__strong NSMutableArray * _logs;
}

@def_singleton( SamuraiUnitTest )

@def_prop_assign( NSUInteger,	failedCount );
@def_prop_assign( NSUInteger,	succeedCount );

- (id)init
{
	self = [super init];
	if ( self )
	{
		_logs = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc
{
	_logs = nil;
}

- (void)run
{
	fprintf( stderr, "  =============================================================\n" );
	fprintf( stderr, "   Unit testing ...\n" );
	fprintf( stderr, "  -------------------------------------------------------------\n" );

	NSArray *	classes = [SamuraiTestCase subClasses];
	LogLevel	filter = [SamuraiLogger sharedInstance].filter;

	[SamuraiLogger sharedInstance].filter = LogLevel_Warn;
//	[SamuraiLogger sharedInstance].filter = LogLevel_All;
	
	CFTimeInterval beginTime = CACurrentMediaTime();
	
	for ( NSString * className in classes )
	{
		Class classType = NSClassFromString( className );
		
		if ( nil == classType )
			continue;

		NSString * testCaseName;
		testCaseName = [classType description];
		testCaseName = [testCaseName stringByReplacingOccurrencesOfString:@"__TestCase__" withString:@"  TEST_CASE( "];
		testCaseName = [testCaseName stringByAppendingString:@" )"];

		NSString * formattedName = [testCaseName stringByPaddingToLength:48 withString:@" " startingAtIndex:0];

//		[[SamuraiLogger sharedInstance] disable];

		fprintf( stderr, "%s", [formattedName UTF8String] );

		CFTimeInterval time1 = CACurrentMediaTime();
		
		BOOL testCasePassed = YES;
		
	//	@autoreleasepool
		{
			@try
			{
				SamuraiTestCase * testCase = [[classType alloc] init];

				NSArray * selectorNames = [classType methodsWithPrefix:@"runTest_" untilClass:[SamuraiTestCase class]];
				
				if ( selectorNames && [selectorNames count] )
				{
					for ( NSString * selectorName in selectorNames )
					{
						SEL selector = NSSelectorFromString( selectorName );
						if ( selector && [testCase respondsToSelector:selector] )
						{
							NSMethodSignature * signature = [testCase methodSignatureForSelector:selector];
							NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];
							
							[invocation setTarget:testCase];
							[invocation setSelector:selector];
							[invocation invoke];
						}
					}
				}
			}
			@catch ( NSException * e )
			{
				if ( [e isKindOfClass:[SamuraiTestFailure class]] )
				{
					SamuraiTestFailure * failure = (SamuraiTestFailure *)e;
					
					[self writeLog:
						   @"                        \n"
							"    %@ (#%lu)           \n"
							"                        \n"
							"    {                   \n"
							"        EXPECTED( %@ ); \n"
							"                  ^^^^^^          \n"
							"                  Assertion failed\n"
							"    }                   \n"
							"                        \n", failure.file, failure.line, failure.expr];
				}
				else
				{
					[self writeLog:@"\nUnknown exception '%@'", e.reason];
					[self writeLog:@"%@", e.callStackSymbols];
				}

				testCasePassed = NO;
			}
			@finally
			{
			}
		};
		
		CFTimeInterval time2 = CACurrentMediaTime();
		CFTimeInterval time = time2 - time1;
		
//		[[SamuraiLogger sharedInstance] enable];

		if ( testCasePassed )
		{
			_succeedCount += 1;

			fprintf( stderr, "[ OK ]   %.003fs\n", time );
		}
		else
		{
			_failedCount += 1;

			fprintf( stderr, "[FAIL]   %.003fs\n", time );
		}
		
		[self flushLog];
	}
	
	CFTimeInterval endTime = CACurrentMediaTime();
	CFTimeInterval totalTime = endTime - beginTime;

	float passRate = (_succeedCount * 1.0f) / ((_succeedCount + _failedCount) * 1.0f) * 100.0f;
	
	fprintf( stderr, "  -------------------------------------------------------------\n" );
	fprintf( stderr, "  Total %lu cases                               [%.0f%%]   %.003fs\n", (unsigned long)[classes count], passRate, totalTime );
	fprintf( stderr, "  =============================================================\n" );
	fprintf( stderr, "\n" );

	[SamuraiLogger sharedInstance].filter = filter;
}

- (void)writeLog:(NSString *)format, ...
{
	if ( _logs.count >= MAX_UNITTEST_LOGS )
	{
		return;
	}
	
	if ( nil == format || NO == [format isKindOfClass:[NSString class]] )
		return;
	
	va_list args;
	va_start( args, format );
	
	@autoreleasepool
	{
		NSMutableString * content = [[NSMutableString alloc] initWithFormat:(NSString *)format arguments:args];
		[_logs addObject:content];
	};
	
	va_end( args );
}

- (void)flushLog
{
	if ( _logs.count )
	{
		for ( NSString * log in _logs )
		{
			fprintf( stderr, "       %s\n", [log UTF8String] );
		}
		
		if ( _logs.count >= MAX_UNITTEST_LOGS )
		{
			fprintf( stderr, "       ...\n" );
		}

		fprintf( stderr, "\n" );
	}

	[_logs removeAllObjects];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( Core, UnitTest )

DESCRIBE( before )
{
}

DESCRIBE( after )
{
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#import "_pragma_pop.h"
