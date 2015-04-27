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
#import "Samurai_CoreConfig.h"

#import "Samurai_Property.h"
#import "Samurai_Singleton.h"

#undef	TEST_CASE
#define	TEST_CASE( __module, __name ) \
		@interface __TestCase__##__module##_##__name : SamuraiTestCase \
		@end \
		@implementation __TestCase__##__module##_##__name

#undef	TEST_CASE_END
#define	TEST_CASE_END \
		@end

#undef	DESCRIBE
#define	DESCRIBE( ... ) \
		- (void) macro_concat( runTest_, __LINE__ )

#undef	REPEAT
#define REPEAT( __n ) \
		for ( int __i_##__LINE__ = 0; __i_##__LINE__ < __n; ++__i_##__LINE__ )

#undef	EXPECTED
#define EXPECTED( ... ) \
		if ( !(__VA_ARGS__) ) \
		{ \
			@throw [SamuraiTestFailure expr:#__VA_ARGS__ file:__FILE__ line:__LINE__]; \
		}

#undef	TIMES
#define TIMES( __n ) \
		/* [[SamuraiUnitTest sharedInstance] writeLog:@"Loop %d times @ %@(#%d)", __n, [@(__FILE__) lastPathComponent], __LINE__]; */ \
		for ( int __i_##__LINE__ = 0; __i_##__LINE__ < __n; ++__i_##__LINE__ )

#undef	TEST
#define	TEST( __name, __block ) \
		[[SamuraiUnitTest sharedInstance] writeLog:@"> %@", @(__name)]; \
		__block

#pragma mark -

@interface SamuraiTestFailure : NSException

@prop_strong( NSString *,	expr );
@prop_strong( NSString *,	file );
@prop_assign( NSInteger,	line );

+ (SamuraiTestFailure *)expr:(const char *)expr file:(const char *)file line:(int)line;

@end

#pragma mark -

@interface SamuraiTestCase : NSObject
@end

#pragma mark -

@interface SamuraiUnitTest : NSObject

@singleton( SamuraiUnitTest )

@prop_assign( NSUInteger,	failedCount );
@prop_assign( NSUInteger,	succeedCount );

- (void)run;

- (void)writeLog:(NSString *)format, ...;
- (void)flushLog;

@end
