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
#import "Samurai_HtmlRenderObjectTable.h"
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
		else
		{
			[document.renderTree dump];
		}
	}

	return YES;
}

- (SamuraiHtmlRenderObject *)renderDomNode:(SamuraiHtmlDomNode *)domNode forContainer:(SamuraiHtmlRenderObject *)container
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

- (SamuraiHtmlRenderObject *)renderDomNodeDocument:(SamuraiHtmlDomNode *)domNode forContainer:(SamuraiHtmlRenderObject *)container
{
	SamuraiHtmlRenderObject * rootObject = [SamuraiHtmlRenderObjectViewport renderObjectWithDom:nil andStyle:nil];
	
	if ( rootObject )
	{
		[rootObject renderWillLoad];

		[rootObject computeProperties];

		[self renderDomNodeElement:domNode forContainer:rootObject];
		
		[rootObject renderDidLoad];
	}
	
	return rootObject;
}

- (SamuraiHtmlRenderObject *)renderDomNodeElement:(SamuraiHtmlDomNode *)domNode forContainer:(SamuraiHtmlRenderObject *)container
{
	if ( domNode.shadowRoot )
	{
	// shadow dom
		
		SamuraiHtmlStyle *			thisStyle = [SamuraiHtmlStyle renderStyle:domNode.shadowRoot.domStyleComputed];
		SamuraiHtmlRenderObject *	thisObject = [SamuraiHtmlRenderObjectContainer renderObjectWithDom:domNode andStyle:thisStyle];

		if ( thisObject )
		{
			[thisObject renderWillLoad];

			if ( container )
			{
				[container appendNode:thisObject];
			}
			
			[thisObject computeProperties];
			
			for ( SamuraiHtmlDomNode * childDom in domNode.shadowRoot.childs )
			{
				[self renderDomNode:childDom forContainer:thisObject];
			}
			
			[thisObject renderDidLoad];
		}
		
		return thisObject;
	}
	else
	{
	// normal dom
		
        SamuraiHtmlStyle *			thisStyle = [SamuraiHtmlStyle renderStyle:domNode.domStyleComputed];
		SamuraiHtmlRenderObject *	thisObject = nil;
		
		SamuraiHtmlString *			renderClass = thisStyle.samuraiRenderClass;
        SamuraiHtmlString *			renderModel = thisStyle.samuraiRenderModel;

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
			else if ( [renderModel isString:@"table"] )
			{
				computedRenderModel = HtmlRenderModel_Table;
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
			for ( SamuraiHtmlDomNode * childDom in domNode.childs )
			{
				[self renderDomNode:childDom forContainer:container];
			}
		}
		else if ( HtmlRenderModel_Element == computedRenderModel )
		{
			thisObject = [SamuraiHtmlRenderObjectElement renderObjectWithDom:domNode andStyle:thisStyle];

			if ( thisObject )
			{
				[thisObject renderWillLoad];
				
				if ( container )
				{
					[container appendNode:thisObject];
				}
				
				[thisObject computeProperties];
				
				[thisObject renderDidLoad];
			}
		}
		else if ( HtmlRenderModel_Container == computedRenderModel )
		{
			thisObject = [SamuraiHtmlRenderObjectContainer renderObjectWithDom:domNode andStyle:thisStyle];

			if ( thisObject )
			{
				[thisObject renderWillLoad];

				if ( container )
				{
					[container appendNode:thisObject];
				}
				
				[thisObject computeProperties];
				
				for ( SamuraiHtmlDomNode * childDom in domNode.childs )
				{
					[self renderDomNode:childDom forContainer:thisObject];
				}
				
				[thisObject renderDidLoad];
			}
		}
		else if ( HtmlRenderModel_Table == computedRenderModel )
		{
			thisObject = [SamuraiHtmlRenderObjectTable renderObjectWithDom:domNode andStyle:thisStyle];

			if ( thisObject )
			{
				[thisObject renderWillLoad];
				
				if ( container )
				{
					[container appendNode:thisObject];
				}
				
				[thisObject computeProperties];
				
				for ( SamuraiHtmlDomNode * childDom in domNode.childs )
				{
					[self renderDomNode:childDom forContainer:thisObject];
				}
				
				[thisObject renderDidLoad];
			}
		}
		else
		{
			PERF( @"unknown tag '%@'", domNode.domTag );
		}
		
		return thisObject;
	}
}

- (SamuraiHtmlRenderObject *)renderDomNodeText:(SamuraiHtmlDomNode *)domNode forContainer:(SamuraiHtmlRenderObject *)container
{
	SamuraiHtmlStyle *			thisStyle = [SamuraiHtmlStyle renderStyle:domNode.domStyleComputed];
	SamuraiHtmlRenderObject *	thisObject = [SamuraiHtmlRenderObjectText renderObjectWithDom:domNode andStyle:thisStyle];

	if ( thisObject )
	{
		[thisObject renderWillLoad];

		if ( container )
		{
			[container appendNode:thisObject];
		}
		
		[thisObject computeProperties];
		
		[thisObject renderDidLoad];
	}
	
	return thisObject;
}

- (SamuraiHtmlRenderObject *)renderDomNodeData:(SamuraiHtmlDomNode *)domNode forContainer:(SamuraiHtmlRenderObject *)container
{
	// TODO:
	
	return nil;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlDocumentWorklet_70BuildRenderTree )

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
