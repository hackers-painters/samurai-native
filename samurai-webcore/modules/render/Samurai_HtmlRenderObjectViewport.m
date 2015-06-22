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

#import "Samurai_HtmlRenderObjectContainer.h"
#import "Samurai_HtmlRenderObjectViewport.h"
#import "Samurai_HtmlRenderObjectElement.h"
#import "Samurai_HtmlRenderObjectTable.h"
#import "Samurai_HtmlRenderObjectText.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "HtmlViewport.h"

#import "Samurai_HtmlRenderScope.h"
#import "Samurai_HtmlRenderStore.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiHtmlRenderObjectViewport

+ (instancetype)renderObjectWithDom:(SamuraiHtmlDomNode *)dom andStyle:(SamuraiHtmlStyle *)style
{
	SamuraiHtmlRenderObjectViewport * renderObject = [super renderObjectWithDom:dom andStyle:style];
	
	return renderObject;
}

#pragma mark -

- (id)init
{
	self = [super init];
	if ( self )
	{
	}
	return self;
}

- (void)dealloc
{
}

#pragma mark -

+ (Class)defaultViewClass
{
	return [HtmlViewport class];
}

#pragma mark -

- (UIView *)createViewWithIdentifier:(NSString *)identifier
{
	return [super createViewWithIdentifier:identifier];
}

#pragma mark -

- (BOOL)html_hasChildren
{
	return YES;
}

#pragma mark -

- (void)renderWillLoad
{
	[super renderWillLoad];
}

- (void)renderDidLoad
{
	[super renderDidLoad];
}

#pragma mark -

- (BOOL)layoutShouldWrapLine
{
	return [super layoutShouldWrapLine];
}

- (BOOL)layoutShouldWrapBefore
{
	return [super layoutShouldWrapBefore];
}

- (BOOL)layoutShouldWrapAfter
{
	return [super layoutShouldWrapAfter];
}

- (BOOL)layoutShouldAutoSizing
{
	return [super layoutShouldAutoSizing];
}

- (BOOL)layoutShouldCenteringInRow
{
	return [super layoutShouldCenteringInRow];
}

- (BOOL)layoutShouldCenteringInCol
{
	return [super layoutShouldCenteringInCol];
}

- (BOOL)layoutShouldLeftJustifiedInRow
{
	return [super layoutShouldLeftJustifiedInRow];
}

- (BOOL)layoutShouldRightJustifiedInRow
{
	return [super layoutShouldRightJustifiedInRow];
}

- (BOOL)layoutShouldPositioningChildren
{
	return [super layoutShouldPositioningChildren];
}

- (BOOL)layoutShouldArrangedInRow
{
	return [super layoutShouldArrangedInRow];
}

- (BOOL)layoutShouldArrangedInCol
{
	return [super layoutShouldArrangedInCol];
}

- (BOOL)layoutShouldArrangedReverse
{
	return [super layoutShouldArrangedReverse];
}

- (BOOL)layoutShouldHorizontalAlign
{
	return [super layoutShouldHorizontalAlign];
}

- (BOOL)layoutShouldHorizontalAlignLeft
{
	return [super layoutShouldHorizontalAlignLeft];
}

- (BOOL)layoutShouldHorizontalAlignRight
{
	return [super layoutShouldHorizontalAlignRight];
}

- (BOOL)layoutShouldHorizontalAlignCenter
{
	return [super layoutShouldHorizontalAlignCenter];
}

- (BOOL)layoutShouldVerticalAlign
{
	return [super layoutShouldVerticalAlign];
}

- (BOOL)layoutShouldVerticalAlignTop
{
	return [super layoutShouldVerticalAlignTop];
}

- (BOOL)layoutShouldVerticalAlignMiddle
{
	return [super layoutShouldVerticalAlignMiddle];
}

- (BOOL)layoutShouldVerticalAlignBottom
{
	return [super layoutShouldVerticalAlignBottom];
}

#pragma mark -

- (CGRect)layoutWithContext:(SamuraiHtmlLayoutContext *)context
			  parentContext:(SamuraiHtmlLayoutContext *)parentContext
{
	DEBUG_RENDERER_LAYOUT( self );
	
	htmlLayoutInit( context );
	
	if ( HtmlRenderDisplay_None != self.display )
	{
		htmlLayoutBegin( context );
		htmlLayoutResize( context, context->bounds );

		for ( SamuraiHtmlRenderObject * child in self.childs )
		{
			if ( HtmlRenderDisplay_None == child.display )
			{
				SamuraiHtmlLayoutContext childContext = {
					.style		= child.style,
					.bounds		= CGSizeZero,
					.origin		= CGPointZero,
					.collapse	= context->computedMargin
				};
				
				[child layoutWithContext:&childContext parentContext:NULL];
			}
			else
			{
				SamuraiHtmlLayoutContext childContext = {
					.style		= child.style,
					.bounds		= context->bounds,
					.origin		= CGPointZero,
					.collapse	= context->computedMargin
				};
				
				[child layoutWithContext:&childContext parentContext:NULL];
			}
		}

		htmlLayoutFinish( context );
	}

	self.lines		= 1;
	self.start		= CGPointMake( CGRectGetMinX( context->computedBounds ), CGRectGetMinY( context->computedBounds ) );
	self.end		= CGPointMake( CGRectGetMaxX( context->computedBounds ), CGRectGetMinY( context->computedBounds ) );

	self.inset		= context->computedInset;
	self.border		= context->computedBorder;
	self.margin		= context->computedMargin;
	self.padding	= context->computedPadding;
	self.bounds		= context->computedBounds;
	
	return self.bounds;
}

#pragma mark -

- (id)html_serialize
{
	if ( 0 == [self.childs count] )
	{
		return nil;
	}
	
	if ( 1 == [self.childs count] )
	{
		return [[self.childs firstObject] html_serialize];
	}
	else
	{
		NSMutableArray * array = [NSMutableArray array];
		
		for ( SamuraiRenderObject * child in self.childs )
		{
			[array addObject:[child html_serialize]];
		}
		
		return array;
	}
}

- (void)html_unserialize:(id)obj
{
	if ( 1 == [self.childs count] )
	{
		SamuraiRenderObject * childRender = [self.childs firstObject];
		
		if ( DomNodeType_Text == childRender.dom.type )
		{
			[childRender html_unserialize:obj];
		}
	}
	else
	{
		int __break = 0;
	}
}

- (void)zerolize
{
	for ( SamuraiRenderObject * child in self.childs )
	{
		[child html_zerolize];
	}
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlRenderViewport )

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
