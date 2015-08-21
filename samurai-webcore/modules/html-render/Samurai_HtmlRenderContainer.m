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

#import "Samurai_HtmlRenderContainer.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_HtmlLayoutContainer.h"
#import "Samurai_HtmlLayoutContainerBlock.h"
#import "Samurai_HtmlLayoutContainerFlex.h"
#import "Samurai_HtmlLayoutContainerTable.h"
#import "Samurai_HtmlLayoutElement.h"

#import "Samurai_HtmlElementDiv.h"

#import "Samurai_HtmlRenderStoreScope.h"
#import "Samurai_HtmlRenderStore.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiHtmlRenderContainer

+ (Class)defaultLayoutClass
{
	return [SamuraiHtmlLayoutContainerBlock class];
}

+ (Class)defaultViewClass
{
	return [SamuraiHtmlElementDiv class];
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

- (void)renderWillLoad
{
	[super renderWillLoad];
}

- (void)renderDidLoad
{
	[super renderDidLoad];
}

#pragma mark -

- (void)computeProperties
{
	[super computeProperties];

// compute layout class

	Class layoutClass = nil;
	
	switch ( self.display )
	{
		case CSSDisplay_Inline:				layoutClass = [SamuraiHtmlLayoutContainerBlock class];	break;
		case CSSDisplay_Block:				layoutClass = [SamuraiHtmlLayoutContainerBlock class];	break;
		case CSSDisplay_InlineBlock:		layoutClass = [SamuraiHtmlLayoutContainerBlock class];	break;
		case CSSDisplay_Flex:				layoutClass = [SamuraiHtmlLayoutContainerFlex class];	break;
		case CSSDisplay_InlineFlex:			layoutClass = [SamuraiHtmlLayoutContainerFlex class];	break;
		case CSSDisplay_ListItem:			layoutClass = [SamuraiHtmlLayoutContainerBlock class];	break;
		case CSSDisplay_Table:				layoutClass = [SamuraiHtmlLayoutContainerTable class];	break;
		case CSSDisplay_TableRowGroup:		layoutClass = [SamuraiHtmlLayoutContainerBlock class];	break;
		case CSSDisplay_TableHeaderGroup:	layoutClass = [SamuraiHtmlLayoutContainerBlock class];	break;
		case CSSDisplay_TableFooterGroup:	layoutClass = [SamuraiHtmlLayoutContainerBlock class];	break;
		case CSSDisplay_TableRow:			layoutClass = [SamuraiHtmlLayoutContainerBlock class];	break;
		case CSSDisplay_TableColumnGroup:	layoutClass = [SamuraiHtmlLayoutContainerBlock class];	break;
		case CSSDisplay_TableColumn:		layoutClass = [SamuraiHtmlLayoutContainerBlock class];	break;
		case CSSDisplay_TableCell:			layoutClass = [SamuraiHtmlLayoutContainerBlock class];	break;
		case CSSDisplay_TableCaption:		layoutClass = [SamuraiHtmlLayoutContainerBlock class];	break;
		default:
			break;
	}

	if ( nil == layoutClass )
	{
		layoutClass = [[self class] defaultLayoutClass];
		
		if ( nil == layoutClass )
		{
			layoutClass = [SamuraiHtmlLayoutElement class];
		}
	}

	if ( nil == self.layout || NO == [self.layout isKindOfClass:layoutClass] )
	{
		self.layout = [layoutClass layout:self];
	}
}

#pragma mark -

- (void)html_applyDom:(SamuraiHtmlDomNode *)dom
{
	[super html_applyDom:dom];
}

- (void)html_applyStyle:(SamuraiHtmlRenderStyle *)style
{
	[super html_applyStyle:style];
}

- (void)html_applyFrame:(CGRect)newFrame
{
	[super html_applyFrame:newFrame];
}

- (void)html_forView:(UIView *)hostView
{
	[super html_forView:hostView];
}

#pragma mark -

- (BOOL)store_hasChildren
{
	return YES;
}

- (id)store_serialize
{
	if ( 0 == [self.childs count] )
	{
		return nil;
	}
	
	if ( 1 == [self.childs count] )
	{
		return [[self.childs firstObject] store_serialize];
	}
	else
	{
		NSMutableArray * array = [NSMutableArray array];
		
		for ( SamuraiHtmlRenderObject * child in self.childs )
		{
			[array addObject:[child store_serialize]];
		}
		
		return array;
	}
}

- (void)store_unserialize:(id)obj
{
	if ( 1 == [self.childs count] )
	{
		SamuraiHtmlRenderObject * childRender = [self.childs firstObject];
		
		if ( DomNodeType_Text == childRender.dom.type )
		{
			[childRender store_unserialize:obj];
		}
	}
}

- (void)store_zerolize
{
	for ( SamuraiHtmlRenderObject * child in self.childs )
	{
		[child store_zerolize];
	}
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlRenderContainer )

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
