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

#import "Samurai_HtmlRenderWorklet_30UpdateFrame.h"

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

@implementation SamuraiHtmlRenderWorklet_30UpdateFrame

- (BOOL)processWithContext:(SamuraiHtmlRenderObject *)renderObject
{
	if ( NO == CGSizeEqualToSize( renderObject.view.frame.size, CGSizeZero ) )
	{
		renderObject.layout.bounds		= renderObject.view.frame.size,
		renderObject.layout.origin		= renderObject.view.frame.origin;
		renderObject.layout.stretch		= CGSizeMake( INVALID_VALUE, INVALID_VALUE );
		renderObject.layout.collapse	= UIEdgeInsetsZero;

		if ( [renderObject.layout begin:YES] )
		{
			[renderObject.layout layout];
			[renderObject.layout finish];
		}

		if ( NO == CGRectEqualToRect( renderObject.layout.computedBounds, CGRectZero ) )
		{
			[self applyViewFrameForRender:renderObject];
		}
		else
		{
			[self clearViewFrameForRender:renderObject];
		}
		
	#if __SAMURAI_DEBUG__
		[renderObject dump];
	#endif	// #if __SAMURAI_DEBUG__
	}

	return YES;
}

#pragma mark -

- (void)applyViewFrameForRender:(SamuraiHtmlRenderObject *)renderObject
{
	if ( renderObject.view )
	{
		DEBUG_RENDERER_FRAME( renderObject );

		[renderObject.view html_applyFrame:renderObject.layout.frame];
		
		DEBUG_RENDERER_STYLE( renderObject );

		[renderObject.view html_applyStyle:renderObject.style];
	}
	
	for ( SamuraiHtmlRenderObject * childRender in renderObject.childs )
	{
		[self applyViewFrameForRender:childRender];
	}
}

- (void)clearViewFrameForRender:(SamuraiHtmlRenderObject *)renderObject
{
	if ( renderObject.view )
	{
		[renderObject.view html_applyFrame:CGRectZero];
		[renderObject.view html_applyStyle:renderObject.style];
	}
	
	for ( SamuraiHtmlRenderObject * childRender in renderObject.childs )
	{
		[self applyViewFrameForRender:childRender];
	}
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlRenderWorklet_30UpdateFrame )

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
