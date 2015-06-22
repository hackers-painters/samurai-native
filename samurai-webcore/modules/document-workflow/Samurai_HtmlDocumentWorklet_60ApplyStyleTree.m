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

#import "Samurai_HtmlDocumentWorklet_60ApplyStyleTree.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_HtmlRenderObject.h"
#import "Samurai_HtmlRenderObjectContainer.h"
#import "Samurai_HtmlRenderObjectElement.h"
#import "Samurai_HtmlRenderObjectText.h"
#import "Samurai_HtmlRenderObjectViewport.h"

#import "Samurai_HtmlStyle.h"
#import "Samurai_HtmlMediaQuery.h"

#import "Samurai_HtmlUserAgent.h"

#import "Samurai_CSSParser.h"
#import "Samurai_CSSStyleSheet.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiHtmlDocumentWorklet_60ApplyStyleTree

- (BOOL)processWithContext:(SamuraiHtmlDocument *)document
{
	if ( document.domTree )
	{
		[self mergeStyleForDomNode:document.domTree];
	}

	return YES;
}

- (NSMutableDictionary *)computeStyleForDomNode:(SamuraiHtmlDomNode *)domNode
{
	NSMutableDictionary * styleProperties = [[NSMutableDictionary alloc] init];

	[styleProperties addEntriesFromDictionary:[SamuraiHtmlUserAgent sharedInstance].defaultCSSValue];

// style inherition

	if ( domNode.parent )
	{
		for ( NSString * key in [SamuraiHtmlUserAgent sharedInstance].defaultCSSInherition )
		{
			NSString * value = [domNode.parent.domStyleComputed objectForKey:key];

			if ( value )
			{
				[styleProperties setObject:value forKey:key];
			}
		}
	}
	
// match style - tag {} / .class {} / #id {}
	
	NSDictionary * matchedStyle = [domNode.document.styleTree queryForObject:domNode];

	if ( matchedStyle && [matchedStyle count] )
	{
		[styleProperties addEntriesFromDictionary:matchedStyle];
	}
	
// attributed style
	
	for ( NSArray * pair in [SamuraiHtmlUserAgent sharedInstance].defaultDOMAttributed )
	{
		NSString * attrName1 = [pair objectAtIndex:0];
		NSString * attrName2 = [pair objectAtIndex:1];

		NSString * attrValue = [domNode.attributes objectForKey:attrName1];

		if ( attrValue )
		{
			[styleProperties setObject:attrValue forKey:attrName2];
		}
	}

// inline style - <tag style=""/>
	
	if ( domNode.domStyleInline && domNode.domStyleInline.length )
	{
		NSDictionary * inlineStyle = [[SamuraiCSSParser sharedInstance] parseDeclaration:domNode.domStyleInline];
		
		if ( inlineStyle && [inlineStyle count] )
		{
			[styleProperties addEntriesFromDictionary:inlineStyle];
		}
	}

// style inherition
	
	if ( domNode.parent )
	{
		for ( NSString * key in styleProperties.allKeys )
		{
			NSObject *	value = [styleProperties objectForKey:key];
			NSString *	string = nil;
			
			if ( [value isKindOfClass:[NSString class]] )
			{
				string = (NSString *)value;
			}
			else if ( [value isKindOfClass:[SamuraiCSSValueWrapper class]] )
			{
				string = [(SamuraiCSSValueWrapper *)value rawValue];
			}
			else if ( [value isKindOfClass:[SamuraiHtmlStyleObject class]] )
			{
				string = [(SamuraiHtmlStyleObject *)value stringValue];
			}
			else
			{
				string = [value description];
			}
			
			if ( string && [string isEqualToString:@"inherit"] )
			{
				NSObject * inheritedValue = [domNode.parent.domStyleComputed objectForKey:key];
				
				if ( inheritedValue )
				{
					[styleProperties setObject:inheritedValue forKey:key];
				}
				else
				{
					[styleProperties removeObjectForKey:key];
				}
			}
		}
	}

	return styleProperties;
}

- (void)mergeStyleForDomNode:(SamuraiHtmlDomNode *)domNode
{
	DEBUG_HTML_CSS( domNode );
	
	if ( nil == domNode.document )
		return;
	
	NSMutableDictionary * domStyle = [self computeStyleForDomNode:domNode];

	[domNode.domStyleComputed removeAllObjects];
	[domNode.domStyleComputed addEntriesFromDictionary:domStyle];

	for ( SamuraiHtmlDomNode * childDom in domNode.childs )
	{
		[self mergeStyleForDomNode:childDom];
	}

	if ( domNode.shadowRoot )
	{
		NSMutableDictionary * shadowStyle = [self computeStyleForDomNode:domNode.shadowRoot];
		
		[shadowStyle addEntriesFromDictionary:domStyle];

		[domNode.shadowRoot.domStyleComputed removeAllObjects];
		[domNode.shadowRoot.domStyleComputed addEntriesFromDictionary:shadowStyle];
		
		for ( SamuraiHtmlDomNode * childDom in domNode.shadowRoot.childs )
		{
			[self mergeStyleForDomNode:childDom];
		}
	}
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlDocumentWorklet_60ApplyStyleTree )

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
