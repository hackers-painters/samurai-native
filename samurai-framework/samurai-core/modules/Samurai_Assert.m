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

#import "Samurai_Assert.h"
#import "Samurai_Log.h"
#import "Samurai_UnitTest.h"

#import "NSObject+Extension.h"

#import "_pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiAsserter

@def_singleton( SamuraiAsserter );

@def_prop_assign( BOOL,	enabled );

+ (void)classAutoLoad
{
	[SamuraiAsserter sharedInstance];
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		_enabled = YES;
	}
	return self;
}

- (void)toggle
{
	_enabled = _enabled ? NO : YES;
}

- (void)enable
{
	_enabled = YES;
}

- (void)disable
{
	_enabled = NO;
}

- (void)file:(const char *)file line:(NSUInteger)line func:(const char *)func flag:(BOOL)flag expr:(const char *)expr
{
	if ( NO == _enabled )
		return;

	if ( NO == flag )
	{
	#if __SAMURAI_DEBUG__
	
		fprintf( stderr,
				"                        \n"
				"    %s @ %s (#%lu)       \n"
				"    {                   \n"
				"        ASSERT( %s );   \n"
				"        ^^^^^^          \n"
				"        Assertion failed\n"
				"    }                   \n"
				"                        \n", func, [[@(file) lastPathComponent] UTF8String], (unsigned long)line, expr );
		
	#endif
		
		abort();
	}
}

@end

#pragma mark -

#if __cplusplus
extern "C"
#endif
void SamuraiAssert( const char * file, NSUInteger line, const char * func, BOOL flag, const char * expr )
{
	[[SamuraiAsserter sharedInstance] file:file line:line func:func flag:flag expr:expr];
}

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( Core, Asserter )
{
}

DESCRIBE( enable/disable )
{
	[[SamuraiAsserter sharedInstance] enable];
	EXPECTED( [[SamuraiAsserter sharedInstance] enabled] );

	[[SamuraiAsserter sharedInstance] disable];
	EXPECTED( NO == [[SamuraiAsserter sharedInstance] enabled] );

	[[SamuraiAsserter sharedInstance] toggle];
	EXPECTED( [[SamuraiAsserter sharedInstance] enabled] );

	[[SamuraiAsserter sharedInstance] toggle];
	EXPECTED( NO == [[SamuraiAsserter sharedInstance] enabled] );

	[[SamuraiAsserter sharedInstance] enable];
	EXPECTED( [[SamuraiAsserter sharedInstance] enabled] );

	ASSERT( YES );

	[[SamuraiAsserter sharedInstance] disable];
	
	ASSERT( NO );
	
	[[SamuraiAsserter sharedInstance] enable];
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#import "_pragma_pop.h"
