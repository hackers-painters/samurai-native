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

#import "Samurai_HtmlDocumentWorklet_20ParseDomTree.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_HtmlDomNode.h"
#import "Samurai_HtmlUserAgent.h"

#import "gumbo.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiHtmlDocumentWorklet_20ParseDomTree

- (BOOL)processWithContext:(SamuraiHtmlDocument *)document
{
	if ( document.resContent && [document.resContent length] )
	{
		document.domTree = [self parseHtml:document.resContent];

		if ( document.domTree )
		{
			[document.domTree attach:document];
		}
	}

	return YES;
}

#pragma mark -

- (SamuraiHtmlDomNode *)parseHtml:(NSString *)html
{
	if ( nil == html || 0 == html.length )
		return nil;
	
	SamuraiHtmlDomNode *	domTree = nil;
	GumboOptions			options = kGumboDefaultOptions;
	GumboOutput *			output = gumbo_parse_with_options( &options, [html UTF8String], strlen([html UTF8String]));
	
	if ( output && output->document )
	{
		const GumboVector * children = &output->document->v.document.children;
		
		for ( int i = 0; i < children->length; ++i )
		{
			GumboNode * child = children->data[i];
			
			if ( GUMBO_NODE_ELEMENT == child->type )
			{
				domTree = [SamuraiHtmlDomNode domNode];
				domTree.type = DomNodeType_Document;
				domTree.implied = YES;

				[self parseAttributes:child forParentNode:domTree];
				[self parseChildren:child forParentNode:domTree];
			}
		}
		
	#if __SAMURAI_DEBUG__
		[domTree dump];
	#endif	// #if __SAMURAI_DEBUG__
		
		gumbo_destroy_output( &options, output );
	}
	
	return domTree;
}

#pragma mark -

- (void)parseNodeElement:(GumboNode *)node forParentNode:(SamuraiHtmlDomNode *)domNode
{
	SamuraiHtmlDomNode * childNode = [SamuraiHtmlDomNode domNode];

	childNode.type = DomNodeType_Element;
	childNode.implied = ( GUMBO_INSERTION_IMPLIED & node->parse_flags ) ? YES : NO;

	[domNode appendNode:childNode];

	[self parseAttributes:node forParentNode:childNode];
	
	DEBUG_HTML_DOM( childNode );

	[self parseChildren:node forParentNode:childNode];
}

- (void)parseNodeText:(GumboNode *)node forParentNode:(SamuraiHtmlDomNode *)domNode
{
	if ( node->v.text.text && strlen(node->v.text.text) )
	{
		NSString * content = [NSString stringWithUTF8String:(const char *)node->v.text.text];
		
		if ( content && content.length )
		{
			SamuraiHtmlDomNode * childNode = [SamuraiHtmlDomNode domNode];

			childNode.type = DomNodeType_Text;
			childNode.implied = ( GUMBO_INSERTION_IMPLIED & node->parse_flags ) ? YES : NO;
			
			childNode.tag = nil;
			childNode.text = content;

			[domNode appendNode:childNode];
			
			DEBUG_HTML_DOM( childNode );
		}
	}
}

- (void)parseNodeCData:(GumboNode *)node forParentNode:(SamuraiHtmlDomNode *)domNode
{
	if ( node->v.text.text && strlen(node->v.text.text) )
	{
		NSString * content = [NSString stringWithUTF8String:(const char *)node->v.text.text];
		
		if ( content && content.length )
		{
			SamuraiHtmlDomNode * childNode = [SamuraiHtmlDomNode domNode];

			childNode.type = DomNodeType_Data;
			childNode.implied = ( GUMBO_INSERTION_IMPLIED & node->parse_flags ) ? YES : NO;
			
			childNode.tag = nil;
			childNode.text = content;

			[domNode appendNode:childNode];
			
			DEBUG_HTML_DOM( childNode );
		}
	}
}

- (void)parseNodeComment:(GumboNode *)node forParentNode:(SamuraiHtmlDomNode *)domNode
{
//	if ( node->v.text.text && strlen(node->v.text.text) )
//	{
//		NSString * content = [NSString stringWithUTF8String:(const char *)node->v.text.text];
//		
//		if ( content && content.length )
//		{
//			SamuraiHtmlDomNode * childNode = [SamuraiHtmlDomNode domNode];
//
//			childNode.type = DomNodeType_Comment;
//			childNode.domText = content;
//
//			[domNode appendNode:childNode];
//
//			DEBUG_HTML_DOM( childNode );
//		}
//	}
}

#pragma mark -

- (void)parseAttributes:(GumboNode *)node forParentNode:(SamuraiHtmlDomNode *)domNode
{
	if ( GUMBO_NODE_ELEMENT != node->type )
		return;
	
	if ( GUMBO_TAG_UNKNOWN == node->v.element.tag )
	{
		gumbo_tag_from_original_text( &node->v.element.original_tag );
		
		if ( node->v.element.original_tag.length )
		{
			char * cstr = malloc( node->v.element.original_tag.length + 1 );
			if ( cstr )
			{
				strncpy( cstr, node->v.element.original_tag.data, node->v.element.original_tag.length );
				cstr[node->v.element.original_tag.length] = 0x0;
				
				domNode.tag = [NSString stringWithUTF8String:cstr];
				
				free( cstr );
			}
		}
	}
	else
	{
		const char * cstr = gumbo_normalized_tagname( node->v.element.tag );
		if ( cstr )
		{
			domNode.tag = [NSString stringWithUTF8String:cstr];
		}
	}
	
	for ( int i = 0; i < node->v.element.attributes.length; ++i )
	{
		GumboAttribute * attr = node->v.element.attributes.data[i];
		
		NSString * name = [NSString stringWithUTF8String:attr->name];
		NSString * value = [NSString stringWithUTF8String:attr->value];
		
		if ( name && value )
		{
			[domNode.attr setObject:value forKey:name];
		}
	}
}

- (void)parseChildren:(GumboNode *)node forParentNode:(SamuraiHtmlDomNode *)domNode
{
	const GumboVector * children = NULL;
	
	if ( GUMBO_NODE_DOCUMENT == node->type )
	{
		children = &node->v.document.children;
	}
	else if ( GUMBO_NODE_ELEMENT == node->type )
	{
		children = &node->v.document.children;
	}
	
	if ( children )
	{
		for ( int i = 0; i < children->length; ++i )
		{
			GumboNode * child = children->data[i];
			
			if ( GUMBO_NODE_ELEMENT == child->type )
			{
				[self parseNodeElement:child forParentNode:domNode];
			}
			else if ( GUMBO_NODE_TEXT == child->type )
			{
				[self parseNodeText:child forParentNode:domNode];
			}
			else if ( GUMBO_NODE_CDATA == child->type )
			{
				[self parseNodeCData:child forParentNode:domNode];
			}
			else if ( GUMBO_NODE_COMMENT == child->type )
			{
				[self parseNodeComment:child forParentNode:domNode];
			}
			else
			{
				// TODO:
			}
		}
	}
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlDocumentWorklet_20ParseDomTree )

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
