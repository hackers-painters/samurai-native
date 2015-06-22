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

#import "UIView+CSS.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_HtmlRenderObject.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation UIView(CSS)

@def_prop_dynamic( SamuraiHtmlStyle *,	style );
@def_prop_dynamic( NSMutableArray *,	styleClasses );

- (SamuraiHtmlStyle *)style
{
	SamuraiHtmlRenderObject * thisRenderer = (SamuraiHtmlRenderObject *)[self renderer];
	
	if ( thisRenderer && [thisRenderer isKindOfClass:[SamuraiHtmlRenderObject class]] )
	{
		if ( thisRenderer.customStyle )
		{
			return thisRenderer.customStyle;
		}
	}
	
	static dispatch_once_t		once;
	static SamuraiHtmlStyle *	style = nil;
	
	dispatch_once( &once, ^{ style = [[SamuraiHtmlStyle alloc] init]; });
	
	return style;
}

- (void)setStyle:(SamuraiHtmlStyle *)newStyle
{
	SamuraiHtmlRenderObject * thisRenderer = (SamuraiHtmlRenderObject *)[self renderer];
	
	if ( thisRenderer && [thisRenderer isKindOfClass:[SamuraiHtmlRenderObject class]] )
	{
		if ( thisRenderer.customStyle )
		{
			[thisRenderer.customStyle clearProperties];
			[thisRenderer.customStyle mergeProperties:newStyle.properties];
		}
	}
}

- (NSArray *)styleClasses
{
	SamuraiHtmlRenderObject * thisRenderer = (SamuraiHtmlRenderObject *)[self renderer];
	
	if ( thisRenderer && [thisRenderer isKindOfClass:[SamuraiHtmlRenderObject class]] )
	{
		return thisRenderer.customStyleClasses;
	}
	
	return nil;
}

- (void)setStyleClasses:(NSArray *)classes
{
	SamuraiHtmlRenderObject * thisRenderer = (SamuraiHtmlRenderObject *)[self renderer];
	
	if ( thisRenderer && [thisRenderer isKindOfClass:[SamuraiHtmlRenderObject class]] )
	{
		[thisRenderer.customStyleClasses removeAllObjects];
		[thisRenderer.customStyleClasses addObjectsFromArray:classes];
	}
}

#pragma mark -

- (void)style_lock
{
	TODO( "style lock" )
}

- (void)style_unlock
{
	TODO( "style unlock" )
}

- (void)style_attr:(NSString *)key value:(NSString *)value
{
	if ( nil == key )
		return;
	
	if ( nil == value )
	{
		[self.style setProperty:nil forKey:key];
	}
	else
	{
		[self.style setProperty:value forKey:key];
	}
}

- (void)style_setClass:(NSString *)className
{
	if ( nil == className )
		return;
	
	[self.styleClasses removeAllObjects];
	[self.styleClasses addObject:className];
}

- (void)style_setClasses:(NSArray *)classNames
{
	if ( nil == classNames )
		return;
	
	[self.styleClasses setArray:classNames];
}

- (void)style_addClass:(NSString *)className
{
	if ( nil == className )
		return;
	
	if ( NO == [self.styleClasses containsObject:className] )
	{
		[self.styleClasses addObject:className];
	}
}

- (void)style_removeClass:(NSString *)className
{
	if ( nil == className )
		return;
	
	if ( [self.styleClasses containsObject:className] )
	{
		[self.styleClasses removeObject:className];
	}
}

- (void)style_toggleClass:(NSString *)className
{
	if ( nil == className )
		return;
	
	if ( [self.styleClasses containsObject:className] )
	{
		[self.styleClasses removeObject:className];
	}
	else
	{
		[self.styleClasses addObject:className];
	}
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, UIView_CSS )

DESCRIBE( before )
{
}

DESCRIBE( after )
{
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
