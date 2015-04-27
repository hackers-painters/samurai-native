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

#import "NSBundle+Extension.h"
#import "NSObject+Extension.h"

#import "Samurai_System.h"
#import "Samurai_Encoding.h"
#import "Samurai_UnitTest.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSBundle(Exntension)

@def_prop_dynamic( NSString *,	bundleName );
@def_prop_dynamic( NSString *,	extensionName );

- (NSString *)bundleName
{
	return [[self.resourcePath lastPathComponent] stringByDeletingPathExtension];
}

- (NSString *)extensionName
{
	return [self.resourcePath pathExtension];
}

- (id)dataForResource:(NSString *)resName
{
	NSString *	path = [NSString stringWithFormat:@"%@/%@", self.resourcePath, resName];
	NSData *	data = [NSData dataWithContentsOfFile:path];

	return data;
}

- (id)textForResource:(NSString *)resName
{
	NSString *	path = [NSString stringWithFormat:@"%@/%@", self.resourcePath, resName];
	NSString *	data = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
	
	return data;
}

- (id)imageForResource:(NSString *)resName
{
	NSString *	extensionName = [resName pathExtension];
	NSString *	resourceName = [resName substringToIndex:(resName.length - extensionName.length - 1)];

	UIImage *	image = nil;

	if ( nil == image && [[SamuraiSystem sharedInstance] isScreen640x1136] )
	{
		NSString *	path = [NSString stringWithFormat:@"%@/%@-568h@2x.%@", self.resourcePath, resourceName, extensionName];
		NSString *	path2 = [NSString stringWithFormat:@"%@/%@-568h.%@", self.resourcePath, resourceName, extensionName];
		
		image = [[UIImage alloc] initWithContentsOfFile:path];
		if ( nil == image )
		{
			image = [[UIImage alloc] initWithContentsOfFile:path2];
		}
	}

	if ( nil == image )
	{
		NSString *	path = [NSString stringWithFormat:@"%@/%@@2x.%@", self.resourcePath, resourceName, extensionName];
		NSString *	path2 = [NSString stringWithFormat:@"%@/%@.%@", self.resourcePath, resourceName, extensionName];

		image = [[UIImage alloc] initWithContentsOfFile:path];
		if ( nil == image )
		{
			image = [[UIImage alloc] initWithContentsOfFile:path2];
		}
	}
	
	return image;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( Core, NSBundle_Extension )

DESCRIBE( before )
{
}

DESCRIBE( after )
{
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "_pragma_pop.h"
