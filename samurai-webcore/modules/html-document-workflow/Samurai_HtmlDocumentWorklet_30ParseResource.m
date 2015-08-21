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

#import "Samurai_HtmlDocumentWorklet_30ParseResource.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_HtmlDomNode.h"
#import "Samurai_HtmlDocument.h"
#import "Samurai_HtmlUserAgent.h"

#import "Samurai_CSSStyleSheet.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

typedef enum
{
	ParseDomain_Document = 0,
	ParseDomain_Head,
	ParseDomain_Body
} ParseDomain;

#pragma mark -

@implementation SamuraiHtmlDocumentWorklet_30ParseResource
{
	ParseDomain _domain;
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		_domain = ParseDomain_Document;
	}
	return self;
}

- (void)dealloc
{
}

- (BOOL)processWithContext:(SamuraiHtmlDocument *)document
{
	if ( document.domTree )
	{
		[document.externalScripts removeAllObjects];
		[document.externalStylesheets removeAllObjects];

		[self parseDomNode:document.domTree forDocument:document];
	}

	return YES;
}

#pragma mark -

- (void)parseDomNode:(SamuraiHtmlDomNode *)domNode forDocument:(SamuraiHtmlDocument *)document
{
	if ( nil == domNode || nil == document )
		return;
	
	ParseDomain prevDomain = _domain;

	if ( NSOrderedSame == [domNode.tag compare:document.rootTag options:NSCaseInsensitiveSearch] )
	{
		_domain = ParseDomain_Document;
	}
	else if ( NSOrderedSame == [domNode.tag compare:document.headTag options:NSCaseInsensitiveSearch] )
	{
		_domain = ParseDomain_Head;
	}
	else if ( NSOrderedSame == [domNode.tag compare:document.bodyTag options:NSCaseInsensitiveSearch] )
	{
		_domain = ParseDomain_Body;
	}

	if ( DomNodeType_Document == domNode.type )
	{
		[self parseDomNodeDocument:domNode forDocument:document];
	}
	else if ( DomNodeType_Element == domNode.type )
	{
		[self parseDomNodeElement:domNode forDocument:document];
	}
	else if ( DomNodeType_Text == domNode.type )
	{
		[self parseDomNodeText:domNode forDocument:document];
	}
	else if ( DomNodeType_Data == domNode.type )
	{
		[self parseDomNodeData:domNode forDocument:document];
	}
	
	_domain = prevDomain;
}

- (void)parseDomNodeDocument:(SamuraiHtmlDomNode *)domNode forDocument:(SamuraiHtmlDocument *)document
{
	for ( SamuraiHtmlDomNode * childNode in domNode.childs )
	{
		[self parseDomNode:childNode forDocument:document];
	}
}

- (void)parseDomNodeElement:(SamuraiHtmlDomNode *)domNode forDocument:(SamuraiHtmlDocument *)document
{
	if ( [domNode.tag isEqualToString:@"link"] )
	{
		NSString * rel = domNode.attrRel;
		
		if ( [rel isEqualToString:@"stylesheet"] )
		{
		// <link rel="stylsheet" href="" media=""/>

			SamuraiResource * resource = [self parseStyleSheet:domNode basePath:document.resPath];
			if ( resource )
			{
				[document.externalStylesheets addObject:resource];
			}
		}
		else if ( [rel isEqualToString:@"import"] )
		{
		// <link rel="import" href=""/>

			SamuraiResource * resource = [self parseImport:domNode basePath:document.resPath];
			if ( resource )
			{
				[document.externalImports addObject:resource];
			}
		}
	}
	else if ( [domNode.tag isEqualToString:@"style"] )
	{
	// <style type="text/css"></style>
		
		SamuraiStyleSheet * resource = [self parseStyleSheet:domNode basePath:document.resPath];
		if ( resource )
		{
			[document.externalStylesheets addObject:resource];
		}
	}

	for ( SamuraiHtmlDomNode * childNode in domNode.childs )
	{
		[self parseDomNode:childNode forDocument:document];
	}
}

- (void)parseDomNodeText:(SamuraiHtmlDomNode *)domNode forDocument:(SamuraiHtmlDocument *)document
{
}

- (void)parseDomNodeData:(SamuraiHtmlDomNode *)domNode forDocument:(SamuraiHtmlDocument *)document
{
}

#pragma mark -

- (SamuraiStyleSheet *)parseStyleSheet:(SamuraiHtmlDomNode *)node basePath:(NSString * )basePath
{
	NSString * type = node.attrType;
	NSString * href = node.attrHref;
	NSString * media = node.attrMedia;
	NSString * content = [node computeInnerText];
	
	if ( nil == type || 0 == [type length] )
	{
		type = @"text/css";
	}

	SamuraiCSSStyleSheet * styleSheet = nil;
	
	if ( [type isEqualToString:@"text/css"] )
	{
		if ( href && href.length )
		{
			NSString *	fileName = [[href lastPathComponent] stringByDeletingPathExtension];
			NSString *	fileExt = [[href lastPathComponent] pathExtension];
			NSString *	filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileExt];
				
			if ( filePath && [[NSFileManager defaultManager] fileExistsAtPath:filePath] )
			{
				styleSheet = [SamuraiCSSStyleSheet resourceAtPath:filePath];
			}
			else if ( [href hasPrefix:@"http://"] || [href hasPrefix:@"https://"] )
			{
				styleSheet = [SamuraiCSSStyleSheet resourceWithURL:href];
			}
			else if ( [href hasPrefix:@"//"] )
			{
				styleSheet = [SamuraiCSSStyleSheet resourceWithURL:[@"http:" stringByAppendingString:href]];
			}
			else if ( [basePath hasPrefix:@"http://"] || [basePath hasPrefix:@"https://"] )
			{
				NSURL * url = [NSURL URLWithString:href relativeToURL:[NSURL URLWithString:basePath]];
				
				styleSheet = [SamuraiCSSStyleSheet resourceWithURL:[url absoluteString]];
			}
			else
			{
				NSString * cssPath;
				cssPath = [basePath stringByDeletingLastPathComponent];
				cssPath = [cssPath stringByAppendingPathComponent:href];
				cssPath = [cssPath stringByStandardizingPath];
				
				styleSheet = [SamuraiCSSStyleSheet resourceAtPath:cssPath];
			}
		}
		else if ( content && content.length )
		{
			styleSheet = [SamuraiCSSStyleSheet resourceWithString:content type:type baseURL:basePath];
		}
		else
		{
			WARN( @"Failed to load css stylesheet" );
		}
	}
	else
	{
		TODO( "Support more style type" )
	}
	
	if ( nil == styleSheet )
		return nil;
	
	styleSheet.href = href;
	styleSheet.type = type;
	styleSheet.media = media;
	
	if ( ParseDomain_Document == _domain )
	{
		styleSheet.resPolicy = ResourcePolicy_Preload;
	}
	else if ( ParseDomain_Head == _domain )
	{
		styleSheet.resPolicy = ResourcePolicy_Preload;
	}
	else if ( ParseDomain_Body == _domain )
	{
		styleSheet.resPolicy = ResourcePolicy_Lazyload;
	}
	else
	{
		styleSheet.resPolicy = ResourcePolicy_Default;
	}
	
	return styleSheet;
}

- (SamuraiDocument *)parseImport:(SamuraiHtmlDomNode *)node basePath:(NSString * )basePath
{
	NSString * href = node.attrHref;

	SamuraiHtmlDocument * document = nil;

	if ( href && href.length )
	{
		if ( [href hasPrefix:@"http://"] || [href hasPrefix:@"https://"] )
		{
			document = [SamuraiHtmlDocument resourceWithURL:href];
		}
		else if ( [href hasPrefix:@"//"] )
		{
			document = [SamuraiHtmlDocument resourceWithURL:[@"http:" stringByAppendingString:href]];
		}
		else
		{
			if ( [basePath hasPrefix:@"http://"] || [basePath hasPrefix:@"https://"] )
			{
				NSURL * url = [NSURL URLWithString:href relativeToURL:[NSURL URLWithString:basePath]];
				
				document = [SamuraiHtmlDocument resourceWithURL:[url absoluteString]];
			}
			else
			{
				NSString * htmlPath;
				htmlPath = [basePath stringByDeletingLastPathComponent];
				htmlPath = [htmlPath stringByAppendingPathComponent:href];
				htmlPath = [htmlPath stringByStandardizingPath];
				
				document = [SamuraiHtmlDocument resourceAtPath:htmlPath];
			}
		}
	}

	if ( nil == document )
		return nil;
	
	document.href = href;
	document.type = @"text/html";
	document.media = nil;

	document.rootTag = @"element";
	document.headTag = nil;
	document.bodyTag = @"template";

	if ( ParseDomain_Document == _domain )
	{
		document.resPolicy = ResourcePolicy_Preload;
	}
	else if ( ParseDomain_Head == _domain )
	{
		document.resPolicy = ResourcePolicy_Preload;
	}
	else if ( ParseDomain_Body == _domain )
	{
		document.resPolicy = ResourcePolicy_Lazyload;
	}
	else
	{
		document.resPolicy = ResourcePolicy_Default;
	}

	return document;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlDocumentWorklet_30ParseResource )

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
