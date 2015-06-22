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

#import "Samurai_HtmlRenderStore.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiHtmlRenderStore

@def_prop_strong( SamuraiRenderObject *, renderer );

+ (SamuraiHtmlRenderStore *)store
{
	return [[self alloc] init];
}

+ (SamuraiHtmlRenderStore *)store:(SamuraiRenderObject *)object
{
	SamuraiHtmlRenderStore * store = [[self alloc] init];
	store.renderer = object;
	return store;
}

#pragma mark -

- (id)init
{
	self = [super init];
	if ( self )
	{
	}
	return self;
}

- (void)dealloc
{
	self.renderer = nil;
}

#pragma mark -

- (NSArray *)find:(NSString *)dataPath
{
	if ( nil == dataPath )
		return nil;

	NSArray * subPaths = [dataPath componentsSeparatedByString:@"."];
	NSMutableArray * result = [NSMutableArray array];

	[self matchFirstOf:subPaths atIndex:0 toResult:result];

	return result;
}

- (BOOL)match:(NSString *)dataPath
{
	NSString * leftDataPath = self.renderer.dom.domName ?: self.renderer.dom.domTag;
	NSString * rightDataPath = dataPath;
	
	if ( [leftDataPath hasSuffix:@"[]"] )
	{
		leftDataPath = [leftDataPath substringToIndex:leftDataPath.length - 2];
	}
	
	if ( [rightDataPath hasSuffix:@"[]"] )
	{
		rightDataPath = [rightDataPath substringToIndex:rightDataPath.length - 2];
	}
	
	return [leftDataPath isEqualToString:rightDataPath];
}

- (void)matchFirstOf:(NSArray *)dataPaths atIndex:(NSUInteger)index toResult:(NSMutableArray *)result
{
	if ( [self match:[dataPaths objectAtIndex:index]] )
	{
		if ( (index + 1) >= dataPaths.count )
		{
			[result addObject:self];
		}
		else
		{
			for ( SamuraiHtmlRenderStore * childStore in self.childs )
			{
				[childStore matchFirstOf:dataPaths atIndex:(index + 1) toResult:result];
			}
		}
	}
	else
	{
		for ( SamuraiHtmlRenderStore * childStore in self.childs )
		{
			[childStore matchFirstOf:dataPaths atIndex:index toResult:result];
		}
	}
}

#pragma mark -

- (NSString *)description
{
	[[SamuraiLogger sharedInstance] outputCapture];
	
	[self dump];
	
	[[SamuraiLogger sharedInstance] outputRelease];
	
	return [SamuraiLogger sharedInstance].output;
}

- (void)dump
{
	if ( self.renderer && self.renderer.dom.domName )
	{
		PRINT( @"<%@ name='%@'>", self.renderer.dom.domTag, self.renderer.dom.domName );
		
		[[SamuraiLogger sharedInstance] indent];
	}

	for ( SamuraiRenderObject * child in self.childs )
	{
		[child dump];
	}
	
	if ( self.renderer && self.renderer.dom.domName )
	{
		[[SamuraiLogger sharedInstance] unindent];

		PRINT( @"</%@>", self.renderer.dom.domTag, self.renderer.dom.domName );
	}
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlRenderStore )

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
