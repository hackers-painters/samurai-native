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

#import "UITableViewCell+Html.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#import "Samurai_HtmlRenderStyle.h"
#import "Samurai_HtmlRenderObject.h"
#import "Samurai_HtmlRenderStoreScope.h"

#pragma mark -

@implementation UITableViewCell(Html)

+ (CSSViewHierarchy)style_viewHierarchy
{
	return CSSViewHierarchy_Tree;
}

#pragma mark -

- (void)html_applyDom:(SamuraiHtmlDomNode *)dom
{
	[super html_applyDom:dom];
}

- (void)html_applyStyle:(SamuraiHtmlRenderStyle *)style
{
	[super html_applyStyle:style];
}

- (void)html_applyFrame:(CGRect)newFrame
{
	[super html_applyFrame:newFrame];
}

#pragma mark -

- (id)store_serialize
{
	id data = [super store_serialize];
	if ( nil != data )
		return data;
	
	SamuraiHtmlRenderObject * renderObject = (SamuraiHtmlRenderObject *)[self renderer];
	if ( nil == renderObject )
		return nil;
	
	return [[SamuraiHtmlRenderStoreScope scope:renderObject] getData];
}

- (void)store_unserialize:(id)obj
{
	[super store_unserialize:obj];
	
	SamuraiHtmlRenderObject * renderObject = (SamuraiHtmlRenderObject *)[self renderer];
	if ( nil == renderObject )
		return;
	
	[self dataWillChange];
	
	for ( SamuraiHtmlRenderObject * childRender in renderObject.childs )
	{
		[[SamuraiHtmlRenderStoreScope scope:childRender] setData:obj];
	}
	
	[self dataDidChanged];
}

- (void)store_zerolize
{
	[super store_zerolize];
	
	SamuraiHtmlRenderObject * renderObject = (SamuraiHtmlRenderObject *)[self renderer];
	if ( nil == renderObject )
		return;
	
	[self dataWillChange];

	[[SamuraiHtmlRenderStoreScope scope:renderObject] clearData];
	
	[self dataDidChanged];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, UITableViewCell_Html )

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
