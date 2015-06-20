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

#import "ViewController+Binding.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation UIViewController(Binding)

- (id)getViewData
{
	SamuraiRenderStoreScope * scope = [SamuraiRenderStoreScope storeScope:[self.view renderer]];
	
	return [scope getData];
}

- (id)getViewDataWithPath:(NSString *)path
{
	SamuraiRenderStoreScope * scope = [SamuraiRenderStoreScope storeScope:[self.view renderer]];
	
	return [scope getDataWithPath:path];
}

- (void)setViewData:(NSObject *)data
{
	SamuraiRenderStoreScope * scope = [SamuraiRenderStoreScope storeScope:[self.view renderer]];
	
	[scope setData:data];
}

- (void)setViewData:(NSObject *)data withPath:(NSString *)path
{
	SamuraiRenderStoreScope * scope = [SamuraiRenderStoreScope storeScope:[self.view renderer]];
	
	[scope setData:data withPath:path];
}

- (void)clearViewData
{
	SamuraiRenderStoreScope * scope = [SamuraiRenderStoreScope storeScope:[self.view renderer]];
	
	[scope clearData];
}

- (void)clearViewDataWithPath:(NSString *)path
{
	SamuraiRenderStoreScope * scope = [SamuraiRenderStoreScope storeScope:[self.view renderer]];
	
	[scope clearDataWithPath:path];
}

#pragma mark -

- (id)objectForKey:(id)key
{
	return [self getViewDataWithPath:key];
}

- (BOOL)hasObjectForKey:(id)key
{
	return [self getViewDataWithPath:key] ? YES : NO;
}

- (void)setObject:(id)value forKey:(id)key
{
	if ( nil == value )
	{
		[self clearViewDataWithPath:key];
	}
	else
	{
		[self setViewData:value withPath:key];
	}
}

- (void)removeObjectForKey:(id)key
{
	[self clearViewDataWithPath:key];
}

- (void)removeAllObjects
{
	[self clearViewData];
}

#pragma mark -

- (id)objectForKeyedSubscript:(id)key;
{
	return [self objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key
{
	[self setObject:obj forKey:key];
}

#pragma mark -

- (id)serialize
{
	return nil;
}

- (void)unserialize:(id)obj
{
}

- (void)zerolize
{
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, ViewController_Binding )

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
