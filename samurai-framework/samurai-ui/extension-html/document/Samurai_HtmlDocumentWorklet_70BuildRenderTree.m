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

#import "Samurai_HtmlDocumentWorklet_70BuildRenderTree.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_HtmlRenderObject.h"
#import "Samurai_HtmlRenderObjectContainer.h"
#import "Samurai_HtmlRenderObjectElement.h"
#import "Samurai_HtmlRenderObjectText.h"
#import "Samurai_HtmlRenderObjectViewport.h"

#import "Samurai_HtmlStyle.h"
#import "Samurai_HtmlMediaQuery.h"

#import "Samurai_CSSParser.h"
#import "Samurai_CSSStyleSheet.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiHtmlDocumentWorklet_70BuildRenderTree

- (BOOL)processWithContext:(SamuraiHtmlDocument *)document
{
	if ( document.domTree )
	{
		document.renderTree = [self renderDomNode:document.domTree forContainer:nil];

		if ( nil == document.renderTree )
		{
			ERROR( @"Failed to render document with root dom node '%@'", document.domTree.domTag );
		}
	}

	return YES;
}

- (SamuraiHtmlRenderObject *)renderDomNode:(SamuraiDomNode *)domNode forContainer:(SamuraiHtmlRenderObject *)container
{
	SamuraiHtmlRenderObject * renderObject = nil;

	if ( DomNodeType_Document == domNode.type )
	{
		renderObject = [self renderDomNodeDocument:domNode forContainer:container];
	}
	else if ( DomNodeType_Element == domNode.type )
	{
		renderObject = [self renderDomNodeElement:domNode forContainer:container];
	}
	else if ( DomNodeType_Text == domNode.type )
	{
		renderObject = [self renderDomNodeText:domNode forContainer:container];
	}
	else if ( DomNodeType_Data == domNode.type )
	{
		renderObject = [self renderDomNodeData:domNode forContainer:container];
	}
	else if ( DomNodeType_Comment == domNode.type )
	{
		
	}
	else
	{
		ERROR( @"Unsupport element type for dom node '%@'", domNode.domTag );
	}

	return renderObject;
}

- (SamuraiHtmlRenderObject *)renderDomNodeDocument:(SamuraiDomNode *)domNode forContainer:(SamuraiHtmlRenderObject *)container
{
	SamuraiHtmlRenderObject * rootObject = [SamuraiHtmlRenderObjectViewport renderObjectWithDom:domNode andStyle:nil];
	
	if ( rootObject )
	{
		[rootObject applyStyle];

		[self renderDomNodeElement:domNode forContainer:rootObject];
	}
	
	return rootObject;
}

- (SamuraiHtmlRenderObject *)renderDomNodeElement:(SamuraiDomNode *)domNode forContainer:(SamuraiHtmlRenderObject *)container
{
	if ( domNode.shadowRoot )
	{
	// shadow dom
		
		SamuraiHtmlStyle *			thisStyle = [SamuraiHtmlStyle renderStyle:domNode.shadowRoot.domStyleComputed];
		SamuraiHtmlRenderObject *	thisObject = [SamuraiHtmlRenderObjectContainer renderObjectWithDom:domNode andStyle:thisStyle];

		if ( container )
		{
			[container appendNode:thisObject];
		}

		[thisObject applyStyle];

		for ( SamuraiDomNode * childDom in domNode.shadowRoot.childs )
		{
			[self renderDomNode:childDom forContainer:thisObject];
		}
		
		return thisObject;
	}
	else
	{
        SamuraiHtmlStyle *			thisStyle = [SamuraiHtmlStyle renderStyle:domNode.domStyleComputed];
		SamuraiHtmlString *			renderClass = thisStyle.renderClass;
        SamuraiHtmlString *			renderModel = thisStyle.renderModel;

		HtmlRenderModel computedRenderModel = HtmlRenderModel_Unknown;
		
		if ( renderModel )
		{
			if ( [renderModel isString:@"hidden"] )
			{
				computedRenderModel = HtmlRenderModel_Hidden;
			}
			else if ( [renderModel isString:@"inline"] )
			{
				computedRenderModel = HtmlRenderModel_Inline;
			}
			else if ( [renderModel isString:@"element"] )
			{
				computedRenderModel = HtmlRenderModel_Element;
			}
			else if ( [renderModel isString:@"container"] )
			{
				computedRenderModel = HtmlRenderModel_Container;
			}
		}

		if ( HtmlRenderModel_Unknown == computedRenderModel )
		{
			Class classType = nil;
			
			classType = classType ?: NSClassFromString( renderClass.value );
			classType = classType ?: NSClassFromString( domNode.domTag );
			
			if ( classType )
			{
				computedRenderModel = [classType html_defaultRenderModel];
			}
		}

		if ( HtmlRenderModel_Unknown == computedRenderModel )
		{
			computedRenderModel = HtmlRenderModel_Element;
		}

		if ( HtmlRenderModel_Hidden == computedRenderModel )
		{
		}
		else if ( HtmlRenderModel_Inline == computedRenderModel )
		{
			for ( SamuraiDomNode * childDom in domNode.childs )
			{
				[self renderDomNode:childDom forContainer:container];
			}
		}
		else if ( HtmlRenderModel_Element == computedRenderModel )
		{
			SamuraiHtmlRenderObject *	thisObject = [SamuraiHtmlRenderObjectElement renderObjectWithDom:domNode andStyle:thisStyle];

			if ( container )
			{
				[container appendNode:thisObject];
			}
			
			[thisObject applyStyle];

			return thisObject;
		}
		else if ( HtmlRenderModel_Container == computedRenderModel )
		{
			SamuraiHtmlStyle *			thisStyle = [SamuraiHtmlStyle renderStyle:domNode.domStyleComputed];
			SamuraiHtmlRenderObject *	thisObject = [SamuraiHtmlRenderObjectContainer renderObjectWithDom:domNode andStyle:thisStyle];

			if ( container )
			{
				[container appendNode:thisObject];
			}
			
			[thisObject applyStyle];

			for ( SamuraiDomNode * childDom in domNode.childs )
			{
				[self renderDomNode:childDom forContainer:thisObject];
			}
			
			return thisObject;
		}
		else
		{
			PERF( @"unknown tag '%@'", domNode.domTag );
		}
	}
	
	return nil;
}

- (SamuraiHtmlRenderObject *)renderDomNodeText:(SamuraiDomNode *)domNode forContainer:(SamuraiHtmlRenderObject *)container
{
	SamuraiHtmlStyle *			thisStyle = [SamuraiHtmlStyle renderStyle:domNode.domStyleComputed];
	SamuraiHtmlRenderObject *	thisObject = [SamuraiHtmlRenderObjectText renderObjectWithDom:domNode andStyle:thisStyle];

	if ( container )
	{
		[container appendNode:thisObject];
	}

	[thisObject applyStyle];

	return thisObject;
}

- (SamuraiHtmlRenderObject *)renderDomNodeData:(SamuraiDomNode *)domNode forContainer:(SamuraiHtmlRenderObject *)container
{
	// TODO:
	
	return nil;
}

#pragma mark -

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, HtmlDocumentWorklet_70BuildRenderTree )

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
