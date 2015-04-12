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

#import "Samurai_Sandbox.h"
#import "Samurai_UnitTest.h"

#import "_pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiSandbox

@def_prop_strong( NSString *,	appPath );
@def_prop_strong( NSString *,	docPath );
@def_prop_strong( NSString *,	libPrefPath );
@def_prop_strong( NSString *,	libCachePath );
@def_prop_strong( NSString *,	tmpPath );

@def_singleton( SamuraiSandbox )

+ (void)classAutoLoad
{
	[SamuraiSandbox sharedInstance];
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		NSString *	execName = [[NSBundle mainBundle] infoDictionary][@"CFBundleExecutable"];
		NSString *	execPath = [[NSHomeDirectory() stringByAppendingPathComponent:execName] stringByAppendingPathExtension:@"app"];

		NSArray *	docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSArray *	libPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
		NSString *	prefPath = [[libPaths objectAtIndex:0] stringByAppendingFormat:@"/Preference"];
		NSString *	cachePath = [[libPaths objectAtIndex:0] stringByAppendingFormat:@"/Caches"];
		NSString *	tmpPath = [[libPaths objectAtIndex:0] stringByAppendingFormat:@"/tmp"];

		self.appPath = execPath;
		self.docPath = [docPaths objectAtIndex:0];
		self.tmpPath = tmpPath;

		self.libPrefPath = prefPath;
		self.libCachePath = cachePath;
		
		[self touch:self.docPath];
		[self touch:self.tmpPath];
		[self touch:self.libPrefPath];
		[self touch:self.libCachePath];
	}
	return self;
}

- (BOOL)touch:(NSString *)path
{
	if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:path] )
	{
		return [[NSFileManager defaultManager] createDirectoryAtPath:path
										 withIntermediateDirectories:YES
														  attributes:nil
															   error:NULL];
	}
	
	return YES;
}

- (BOOL)touchFile:(NSString *)file
{
	if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:file] )
	{
		return [[NSFileManager defaultManager] createFileAtPath:file
													   contents:[NSData data]
													 attributes:nil];
	}
	
	return YES;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( Core, Sandbox )
{
}

DESCRIBE( paths )
{
	EXPECTED( nil != [[SamuraiSandbox sharedInstance] appPath] );
	EXPECTED( nil != [[SamuraiSandbox sharedInstance] docPath] );
	EXPECTED( nil != [[SamuraiSandbox sharedInstance] libPrefPath] );
	EXPECTED( nil != [[SamuraiSandbox sharedInstance] libCachePath] );
	EXPECTED( nil != [[SamuraiSandbox sharedInstance] tmpPath] );
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#import "_pragma_pop.h"
