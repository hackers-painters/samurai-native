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

#import "Samurai_HtmlStyle.h"
#import "Samurai_HtmlMediaQuery.h"
#import "Samurai_HtmlUserAgent.h"

#import "Samurai_CSSParser.h"
#import "Samurai_CSSStyleSheet.h"

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
	DEBUG_RENDERER_STYLE( renderObject );

	if ( renderObject.view )
	{
		NSDictionary *	mergedStyle = [self computeStyleForForRenderObject:renderObject];
//		NSSet *			changedKeys = [self diffStyle:mergedStyle withStyle:renderObject.customStyleComputed];

		[renderObject.customStyleComputed removeAllObjects];
		[renderObject.customStyleComputed setDictionary:mergedStyle];
		
		[renderObject.style clearProperties];
		[renderObject.style mergeProperties:mergedStyle];
		
	//	[renderObject computeTabIndex];
		[renderObject computeProperties];
		
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

	[styleProperties addEntriesFromDictionary:renderObject.dom.domStyleComputed];

// inherits from parent

	if ( renderObject.parent )
	{
		for ( NSString * key in [SamuraiHtmlUserAgent sharedInstance].defaultCSSInherition )
		{
			NSString * value = [renderObject.parent.customStyleComputed objectForKey:key];
			
			if ( value )
			{
				[styleProperties setObject:value forKey:key];
			}
		}
	}

// match style - tag {} / .class {} / #id {}
	
	NSDictionary * matchedStyle = [renderObject.dom.document.styleTree queryForObject:renderObject];

	if ( matchedStyle && [matchedStyle count] )
	{
		[styleProperties addEntriesFromDictionary:matchedStyle];
	}
	
// attributed style
	
	for ( NSArray * pair in [SamuraiHtmlUserAgent sharedInstance].defaultDOMAttributed )
	{
		NSString * attrName1 = [pair objectAtIndex:0];
		NSString * attrName2 = [pair objectAtIndex:1];
		
		NSString * attrValue = [renderObject.dom.attributes objectForKey:attrName1];
		
		if ( attrValue )
		{
			[styleProperties setObject:attrValue forKey:attrName2];
		}
	}

// custom style properties
	
	[styleProperties addEntriesFromDictionary:renderObject.customStyle.properties];
	
// style inherition
	
	if ( renderObject.dom.parent )
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
				NSObject * inheritedValue = [renderObject.dom.parent.domStyleComputed objectForKey:key];
				
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
