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

#import "Samurai_HtmlRenderWorklet_20UpdateStyle.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_HtmlRenderObject.h"
#import "Samurai_HtmlRenderStyle.h"
#import "Samurai_HtmlUserAgent.h"

#import "Samurai_CSSParser.h"
#import "Samurai_CSSStyleSheet.h"
#import "Samurai_CSSMediaQuery.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiHtmlRenderWorklet_20UpdateStyle

- (BOOL)processWithContext:(SamuraiHtmlRenderObject *)renderObject
{
	[self updateStyleForRenderObject:renderObject];
	
	return YES;
}

- (NSMutableSet *)diffStyle:(NSDictionary *)style1 withStyle:(NSDictionary *)style2
{
	NSMutableSet * diffKeys = [NSMutableSet set];
	NSMutableSet * allKeys = [NSMutableSet set];
	
	[allKeys addObjectsFromArray:style1.allKeys];
	[allKeys addObjectsFromArray:style2.allKeys];
	
	for ( NSString * key in allKeys )
	{
		NSString * value1 = [style1 objectForKey:key];
		NSString * value2 = [style2 objectForKey:key];
		
		if ( NO == [[value1 description] isEqualToString:[value2 description]] )
		{
			[diffKeys addObject:key];
		}
	}
	
	return diffKeys;
}

- (void)updateStyleForRenderObject:(SamuraiHtmlRenderObject *)renderObject
{
	if ( renderObject.view )
	{
		NSDictionary * mergedStyle = [self computeStyleForForRenderObject:renderObject];

		[renderObject.style clearProperties];
		[renderObject.style mergeProperties:mergedStyle];

		[renderObject computeProperties];

		DEBUG_RENDERER_STYLE( renderObject );

		[renderObject.view html_applyStyle:renderObject.style];
	}

	for ( SamuraiHtmlRenderObject * child in renderObject.childs )
	{
		[self updateStyleForRenderObject:child];
	}
}

#pragma mark -

- (NSMutableDictionary *)computeStyleForForRenderObject:(SamuraiHtmlRenderObject *)renderObject
{
	NSMutableDictionary * styleProperties = [[NSMutableDictionary alloc] init];

// default dom style

	[styleProperties addEntriesFromDictionary:renderObject.dom.computedStyle];
	
// match style - tag {} / .class {} / #id {}
	
	NSDictionary * matchedStyle = [renderObject.dom.document.styleTree queryForObject:renderObject];
	
	for ( NSString * key in matchedStyle )
	{
		NSObject * value = [matchedStyle objectForKey:key];
		
		if ( value )
		{
			[styleProperties setObject:value forKey:key];
		}
	}

// inherits from parent

	if ( renderObject.parent )
	{
		for ( NSString * key in [SamuraiHtmlUserAgent sharedInstance].defaultCSSInherition )
		{
			NSString * value = [renderObject.parent.customStyle objectForKey:key];

			if ( value )
			{
				[styleProperties setObject:value forKey:key];
			}
		}
	}

// custom style properties

	for ( NSString * key in renderObject.customStyle.properties )
	{
		NSObject * value = [renderObject.customStyle.properties objectForKey:key];
		
		if ( value )
		{
			[styleProperties setObject:value forKey:key];
		}
	}

	return styleProperties;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlRenderWorklet_20UpdateStyle )

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
