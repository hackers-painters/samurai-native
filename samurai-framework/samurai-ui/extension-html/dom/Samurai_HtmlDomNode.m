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

#import "Samurai_HtmlDomNode.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_HtmlDocument.h"

#import "Samurai_CSSParser.h"
#import "Samurai_CSSStyleSheet.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiHtmlDomNode

@def_prop_assign( BOOL,	implied );

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
}

#pragma mark -

- (NSString *)cssId
{
	return self.domId;
}

- (NSString *)cssTag
{
	return self.domTag;
}

- (NSArray *)cssClasses
{
	return self.domStyleClasses;
}

- (NSArray *)cssPseudos
{
	return nil;
}

- (NSObject *)cssParent
{
	return self.parent;
}

- (id<SamuraiCSSProtocol>)cssPreviousSibling
{
	return nil;
}

- (id<SamuraiCSSProtocol>)cssFollowingSibling
{
	return nil;
}

- (id<SamuraiCSSProtocol>)cssSiblingAtIndex:(NSInteger)index
{
	if ( nil == self.parent )
	{
		return nil;
	}
	else
	{
		return [self.parent.childs safeObjectAtIndex:index];
	}
}

- (NSArray *)cssChildren
{
	return self.childs;
}

- (NSArray *)cssPreviousSiblings
{
	NSMutableArray * array = [NSMutableArray array];
	
	SamuraiDomNode * domNode = self.prev;
	
	while ( domNode )
	{
		[array addObject:domNode];
		
		domNode = domNode.prev;
	}
	
	return array;
}

- (NSArray *)cssFollowingSiblings
{
	NSMutableArray * array = [NSMutableArray array];
	
	SamuraiDomNode * domNode = self.next;
	
	while ( domNode )
	{
		[array addObject:domNode];
		
		domNode = domNode.next;
	}
	
	return array;
}

- (BOOL)cssIsElement
{
	return YES;
}

- (BOOL)cssIsFirstChild
{
	if ( nil == self.parent )
	{
		return YES;
	}
	else
	{
		return ([self.parent.childs firstObject] == self) ? YES : NO;
	}
}

- (BOOL)cssIsLastChild
{
	if ( nil == self.parent )
	{
		return YES;
	}
	else
	{
		return ([self.parent.childs lastObject] == self) ? YES : NO;
	}
}

- (BOOL)cssIsNthChild:(NSUInteger)index
{
	if ( nil == self.parent )
	{
		return YES;
	}
	else
	{
		return ([self.parent.childs indexOfObject:self] == index) ? YES : NO;
	}
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, HtmlDomNode )

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
