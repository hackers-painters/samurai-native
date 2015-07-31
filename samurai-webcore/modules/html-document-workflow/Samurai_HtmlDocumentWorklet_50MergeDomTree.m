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

#import "Samurai_HtmlDocumentWorklet_50MergeDomTree.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_HtmlRenderObject.h"
#import "Samurai_HtmlRenderContainer.h"
#import "Samurai_HtmlRenderElement.h"
#import "Samurai_HtmlRenderText.h"
#import "Samurai_HtmlRenderViewport.h"
#import "Samurai_HtmlRenderStyle.h"

#import "Samurai_CSSParser.h"
#import "Samurai_CSSStyleSheet.h"
#import "Samurai_CSSMediaQuery.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiHtmlDocumentWorklet_50MergeDomTree

- (BOOL)processWithContext:(SamuraiHtmlDocument *)document
{
	if ( document.domTree )
	{
		[self parseDocument:document];
	}
	
	return YES;
}

- (void)parseDocument:(SamuraiHtmlDocument *)document
{
	NSMutableDictionary * elementMap = [[NSMutableDictionary alloc] init];
	
	for ( SamuraiResource * resource in [document.externalImports copy] )
	{
		if ( [resource isKindOfClass:[SamuraiHtmlDocument class]] )
		{
			[self parseDocument:(SamuraiHtmlDocument *)resource];

			SamuraiHtmlDomNode * rootElement = [(SamuraiHtmlDocument *)resource getRootDomNode];

			if ( rootElement && rootElement.attrName )
			{
				[elementMap setObject:resource forKey:rootElement.attrName];
			}
		}
	}

	[self mergeDomTree:document.domTree withElements:elementMap];
}

- (void)mergeDomTree:(SamuraiHtmlDomNode *)domNode withElements:(NSDictionary *)elementMap
{
	SamuraiHtmlDocument * shadowElement = [elementMap objectForKey:domNode.tag];

	if ( shadowElement && shadowElement.domTree )
	{
		domNode.shadowRoot = [[shadowElement getBodyDomNode] clone];
		domNode.shadowRoot.shadowHost = domNode;

		[domNode.shadowRoot attach:shadowElement];
	}

	for ( SamuraiHtmlDomNode * childDom in domNode.childs )
	{
		[self mergeDomTree:childDom withElements:elementMap];
	}
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlDocumentWorklet_50MergeDomTree )

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
