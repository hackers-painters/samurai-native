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

#import "Samurai_Core.h"
#import "Samurai_Event.h"
#import "Samurai_ViewConfig.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_Tree.h"

#pragma mark -

typedef enum
{
	ResourcePolicy_Default = 0,
	ResourcePolicy_Preload,
	ResourcePolicy_Lazyload
} ResourcePolicy;

#pragma mark -

@interface SamuraiResource : SamuraiTreeNode

@prop_assign( ResourcePolicy,	resPolicy );
@prop_strong( NSString *,		resPath );
@prop_strong( NSString *,		resType );
@prop_strong( NSString *,		resContent );

+ (id)resource;

+ (id)resourceForType:(NSString *)type;
+ (id)resourceForExtension:(NSString *)extension;

+ (id)resourceWithData:(NSData *)data type:(NSString *)type baseURL:(NSString *)path;
+ (id)resourceWithString:(NSString *)string type:(NSString *)type baseURL:(NSString *)path;
+ (id)resourceWithURL:(NSString *)url;
+ (id)resourceWithURL:(NSString *)url type:(NSString *)type;
+ (id)resourceAtPath:(NSString *)path;
+ (id)resourceForClass:(Class)clazz;

+ (NSArray *)supportedTypesForClass:(Class)clazz;
+ (NSArray *)supportedExtensionsForClass:(Class)clazz;

+ (BOOL)supportType:(NSString *)type;
+ (BOOL)supportExtension:(NSString *)ext;

#pragma mark -

+ (NSArray *)supportedTypes;				// override point
+ (NSArray *)supportedExtensions;			// override point
+ (NSString *)baseDirectory;				// override point

- (BOOL)isRemote;
- (BOOL)parse;								// override point

- (void)merge:(SamuraiResource *)another;
- (void)clear;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
