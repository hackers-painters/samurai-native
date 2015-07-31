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

#import "Samurai_HtmlDocumentWorklet_40MergeStyleTree.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_HtmlRenderObject.h"
#import "Samurai_HtmlRenderContainer.h"
#import "Samurai_HtmlRenderElement.h"
#import "Samurai_HtmlRenderText.h"
#import "Samurai_HtmlRenderViewport.h"
#import "Samurai_HtmlRenderStyle.h"

#import "Samurai_HtmlUserAgent.h"

#import "Samurai_CSSParser.h"
#import "Samurai_CSSStyleSheet.h"
#import "Samurai_CSSMediaQuery.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiHtmlDocumentWorklet_40MergeStyleTree

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
	document.styleTree = [SamuraiCSSStyleSheet styleSheet];
	
// load default stylesheets

	for ( SamuraiStyleSheet * styleSheet in [SamuraiHtmlUserAgent sharedInstance].defaultStyleSheets )
	{
		BOOL isCompatible = [[SamuraiCSSMediaQuery sharedInstance] test:styleSheet.media];
		if ( isCompatible )
		{
			[document.styleTree merge:styleSheet];
		}
	}

// load document stylesheets

	for ( SamuraiHtmlDocument * thisDocument = document; nil != thisDocument; thisDocument = (SamuraiHtmlDocument *)thisDocument.parent )
	{
		for ( SamuraiStyleSheet * styleSheet in [thisDocument.externalStylesheets copy] )
		{
			BOOL isCompatible = [[SamuraiCSSMediaQuery sharedInstance] test:styleSheet.media];
			if ( isCompatible )
			{
				[document.styleTree merge:styleSheet];
			}
		}
	}

// parse sub documents

	for ( SamuraiResource * resource in [document.externalImports copy] )
	{
		if ( [resource isKindOfClass:[SamuraiHtmlDocument class]] )
		{
			[self parseDocument:(SamuraiHtmlDocument *)resource];
		}
	}
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlDocumentWorklet_40MergeStyleTree )

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
