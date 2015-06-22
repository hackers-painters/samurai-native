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

#import "Samurai_HtmlRenderObject.h"
#import "Samurai_HtmlRenderWorkflow.h"
#import "Samurai_HtmlUserAgent.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_HtmlLayout.h"
#import "Samurai_HtmlRenderObject.h"
#import "Samurai_HtmlStyle.h"

#import "Samurai_HtmlRenderScope.h"
#import "Samurai_HtmlRenderStore.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

#define HTML_DEFAULT_WRAP		HtmlRenderWrap_Wrap
#define HTML_DEFAULT_ALIGN		HtmlRenderAlign_None
#define HTML_DEFAULT_CLEAR		HtmlRenderClear_None
#define HTML_DEFAULT_DISPLAY	HtmlRenderDisplay_InlineBlock
#define HTML_DEFAULT_FLOATING	HtmlRenderFloating_None
#define HTML_DEFAULT_POSITION	HtmlRenderPosition_Relative
#define HTML_DEFAULT_DIRECTION	HtmlRenderDirection_Row
#define HTML_DEFAULT_VALIGN		HtmlRenderVerticalAlign_Baseline

#pragma mark -

@implementation NSObject(HtmlSupport)

+ (HtmlRenderModel)html_defaultRenderModel
{
	return HtmlRenderModel_Unknown;
}

- (void)html_applyDom:(SamuraiHtmlDomNode *)dom
{
	[self applyDom:dom];
}

- (void)html_applyStyle:(SamuraiHtmlStyle *)style
{
	[self applyStyle:style];
}

- (void)html_applyFrame:(CGRect)newFrame
{
	[self applyFrame:newFrame];
}

- (void)html_forView:(UIView *)hostView
{
}

@end

#pragma mark -

@implementation SamuraiHtmlRenderObject
{
	SamuraiHtmlRenderWorkflow_UpdateFrame *	_relayout;
	SamuraiHtmlRenderWorkflow_UpdateStyle *	_restyle;
	SamuraiHtmlRenderWorkflow_UpdateChain *	_rechain;
}

@def_prop_strong( NSMutableArray *,				customStyleClasses );
@def_prop_strong( NSMutableDictionary *,		customStyleComputed );
@def_prop_strong( SamuraiHtmlStyle *,			customStyle );

@def_prop_assign( HtmlRenderWrap,				wrap );
@def_prop_assign( HtmlRenderAlign,				align );
@def_prop_assign( HtmlRenderClear,				clear );
@def_prop_assign( HtmlRenderDisplay,			display );
@def_prop_assign( HtmlRenderFloating,			floating );
@def_prop_assign( HtmlRenderPosition,			position );
@def_prop_assign( HtmlRenderDirection,			direction );
@def_prop_assign( HtmlRenderVerticalAlign,		verticalAlign );

@def_prop_assign( NSInteger,					tableRow );
@def_prop_assign( NSInteger,					tableCol );
@def_prop_assign( NSInteger,					tableRowSpan );
@def_prop_assign( NSInteger,					tableColSpan );

BASE_CLASS( SamuraiHtmlRenderObject )

+ (instancetype)renderObjectWithDom:(SamuraiHtmlDomNode *)dom andStyle:(SamuraiHtmlStyle *)style
{
	SamuraiHtmlRenderObject * renderObject = [super renderObjectWithDom:dom andStyle:style];

	[renderObject computeTabIndex];
	[renderObject computeProperties];

	return renderObject;
}

#pragma mark -

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.customStyleClasses = [[NSMutableArray alloc] init];
		self.customStyleComputed = [[NSMutableDictionary alloc] init];
		self.customStyle = [[SamuraiHtmlStyle alloc] init];

		self.wrap			= HTML_DEFAULT_WRAP;
		self.align			= HTML_DEFAULT_ALIGN;
		self.display		= HTML_DEFAULT_DISPLAY;
		self.floating		= HTML_DEFAULT_FLOATING;
		self.position		= HTML_DEFAULT_POSITION;
		self.direction		= HTML_DEFAULT_DIRECTION;
		self.verticalAlign	= HTML_DEFAULT_VALIGN;
		
		self.tableCol		= -1;
		self.tableRow		= -1;
		self.tableRowSpan	= 0;
		self.tableColSpan	= 0;
	}
	return self;
}

- (void)dealloc
{
	_relayout = nil;
	_restyle = nil;
	_rechain = nil;

	self.customStyleClasses = nil;
	self.customStyleComputed = nil;
	self.customStyle = nil;
}

#pragma mark -

- (void)deepCopyFrom:(SamuraiHtmlRenderObject *)right
{
	[super deepCopyFrom:right];

	[self.customStyleClasses removeAllObjects];
	[self.customStyleClasses addObjectsFromArray:right.customStyleClasses];
	
	[self.customStyleComputed removeAllObjects];
	[self.customStyleComputed setDictionary:right.customStyleComputed];

	[self.customStyle clearProperties];
	[self.customStyle mergeProperties:right.customStyle.properties];

	[self.style clearProperties];
	[self.style mergeProperties:right.style.properties];
	
	self.wrap = right.wrap;
	self.align = right.align;
	self.display = right.display;
	self.floating = right.floating;
	self.position = right.position;
	self.direction = right.direction;
	self.verticalAlign = right.verticalAlign;
}

#pragma mark -

- (void)renderWillLoad
{
}

- (void)renderDidLoad
{
}

#pragma mark -

- (BOOL)layoutShouldWrapLine
{
//	if ( HtmlRenderFloating_None != self.floating )
//	{
//		return NO;
//	}

	if ( self.parent ) // flex
	{
		if ( HtmlRenderDisplay_Flex == self.parent.display || HtmlRenderDisplay_Flex == self.parent.display )
		{
			if ( HtmlRenderWrap_NoWrap == self.parent.wrap )
			{
				return NO;
			}
		}
	}

	return YES;
}

- (BOOL)layoutShouldWrapBefore
{
	if ( HtmlRenderFloating_None != self.floating )
	{
		return NO;
	}
	
	if ( self.parent ) // flex
	{
		if ( HtmlRenderDisplay_Flex == self.parent.display || HtmlRenderDisplay_Flex == self.parent.display )
		{
			return NO;
		}
	}
	
	if ( self.prev )
	{
		if ( HtmlRenderClear_Right == self.prev.clear || HtmlRenderClear_Both == self.prev.clear )
		{
			return YES;
		}
		
		if ( HtmlRenderFloating_Left == self.prev.floating || HtmlRenderFloating_Right == self.prev.floating )
		{
			return NO;
		}
	}

	if ( HtmlRenderDisplay_Inline == self.display ) // inline
	{
		return NO;
	}
	else if ( HtmlRenderDisplay_Block == self.display ) // block
	{
		return YES;
	}
	else if ( HtmlRenderDisplay_InlineBlock == self.display ) // inline-block
	{
		return NO;
	}
	else if ( HtmlRenderDisplay_Flex == self.display ) // flex
	{
		return YES;
	}
	else if ( HtmlRenderDisplay_InlineFlex == self.display ) // inline-flex
	{
		return NO;
	}
	else if ( HtmlRenderDisplay_ListItem == self.display )
	{
		return YES;
	}
	else if ( HtmlRenderDisplay_Table == self.display ) // table
	{
		return YES;
	}
	else if ( HtmlRenderDisplay_InlineTable == self.display ) // inline-table
	{
		return NO;
	}
	else if ( HtmlRenderDisplay_TableRowGroup == self.display ) // table-row-group
	{
		return NO;
	}
	else if ( HtmlRenderDisplay_TableHeaderGroup == self.display ) // table-header-group
	{
		return NO;
	}
	else if ( HtmlRenderDisplay_TableFooterGroup == self.display ) // table-footer-group
	{
		return NO;
	}
	else if ( HtmlRenderDisplay_TableRow == self.display ) // table-row
	{
		return YES;
	}
	else if ( HtmlRenderDisplay_TableColumnGroup == self.display ) // table-column-group
	{
		return NO;
	}
	else if ( HtmlRenderDisplay_TableColumn == self.display ) // table-column
	{
		return NO;
	}
	else if ( HtmlRenderDisplay_TableCell == self.display ) // table-cell
	{
		return NO;
	}
	else if ( HtmlRenderDisplay_TableCaption == self.display ) // table-caption
	{
		return NO;
	}
	else
	{
		return NO;
	}
}

- (BOOL)layoutShouldWrapAfter
{
	if ( HtmlRenderFloating_None != self.floating )
	{
		return NO;
	}
	
	if ( self.parent ) // flex
	{
		if ( HtmlRenderDisplay_Flex == self.parent.display || HtmlRenderDisplay_InlineFlex == self.parent.display )
		{
			return NO;
		}
	}
	
	if ( self.next )
	{
		if ( HtmlRenderClear_Left == self.next.clear || HtmlRenderClear_Both == self.next.clear )
		{
			return YES;
		}
		
		if ( HtmlRenderFloating_Left == self.next.floating || HtmlRenderFloating_Right == self.next.floating )
		{
			return NO;
		}
	}

	if ( HtmlRenderDisplay_Inline == self.display ) // inline
	{
		return NO;
	}
	else if ( HtmlRenderDisplay_Block == self.display ) // block
	{
		return YES;
	}
	else if ( HtmlRenderDisplay_InlineBlock == self.display ) // inline-block
	{
		return NO;
	}
	else if ( HtmlRenderDisplay_Flex == self.display ) // flex
	{
		return YES;
	}
	else if ( HtmlRenderDisplay_InlineFlex == self.display ) // inline-flex
	{
		return NO;
	}
	else if ( HtmlRenderDisplay_ListItem == self.display ) // table
	{
		return YES;
	}
	else if ( HtmlRenderDisplay_Table == self.display ) // table
	{
		return YES;
	}
	else if ( HtmlRenderDisplay_InlineTable == self.display ) // inline-table
	{
		return NO;
	}
	else if ( HtmlRenderDisplay_TableRowGroup == self.display ) // table-row-group
	{
		return NO;
	}
	else if ( HtmlRenderDisplay_TableHeaderGroup == self.display ) // table-header-group
	{
		return NO;
	}
	else if ( HtmlRenderDisplay_TableFooterGroup == self.display ) // table-footer-group
	{
		return NO;
	}
	else if ( HtmlRenderDisplay_TableRow == self.display ) // table-row
	{
		return YES;
	}
	else if ( HtmlRenderDisplay_TableColumnGroup == self.display ) // table-column-group
	{
		return NO;
	}
	else if ( HtmlRenderDisplay_TableColumn == self.display ) // table-column
	{
		return NO;
	}
	else if ( HtmlRenderDisplay_TableCell == self.display ) // table-cell
	{
		return NO;
	}
	else if ( HtmlRenderDisplay_TableCaption == self.display ) // table-caption
	{
		return NO;
	}
	else
	{
		return NO;
	}
}

- (BOOL)layoutShouldCenteringInRow
{
	if ( HtmlRenderFloating_None != self.floating )
	{
		return NO;
	}
	
	if ( HtmlRenderDisplay_Block != self.display )
	{
		return NO;
	}

	if ( [self.style isAutoMarginLeft] && [self.style isAutoMarginRight] )
	{
		return YES;
	}

	return NO;
}

- (BOOL)layoutShouldCenteringInCol
{
	if ( HtmlRenderFloating_None != self.floating )
	{
		return NO;
	}
	
	if ( HtmlRenderDisplay_Block != self.display )
	{
		return NO;
	}
	
	if ( [self.style isAutoMarginTop] && [self.style isAutoMarginBottom] )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)layoutShouldLeftJustifiedInRow
{
	if ( HtmlRenderFloating_None != self.floating )
	{
		return NO;
	}
	
	if ( HtmlRenderDisplay_Block != self.display )
	{
		return NO;
	}
	
	if ( NO == [self.style isAutoMarginLeft] && [self.style isAutoMarginRight] )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)layoutShouldRightJustifiedInRow
{
	if ( HtmlRenderFloating_None != self.floating )
	{
		return NO;
	}
	
	if ( HtmlRenderDisplay_Block != self.display )
	{
		return NO;
	}
	
	if ( [self.style isAutoMarginLeft] && NO == [self.style isAutoMarginRight] )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)layoutShouldAutoSizing
{
	if ( HtmlRenderDisplay_Inline == self.display )
	{
		return YES;
	}
	
	if ( nil == self.style.width && nil == self.style.height )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)layoutShouldPositioningChildren
{
	if ( HtmlRenderDisplay_Block == self.display || HtmlRenderDisplay_InlineBlock == self.display )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)layoutShouldArrangedInRow
{
	if ( HtmlRenderDisplay_Flex == self.display || HtmlRenderDisplay_InlineFlex == self.display ) // flex
	{
		if ( HtmlRenderDirection_Row == self.direction || HtmlRenderDirection_RowReverse == self.direction )
		{
			return YES;
		}
	}
	
	return NO;
}

- (BOOL)layoutShouldArrangedInCol
{
	if ( HtmlRenderDisplay_Flex == self.display || HtmlRenderDisplay_InlineFlex == self.display ) // flex
	{
		if ( HtmlRenderDirection_Column == self.direction || HtmlRenderDirection_ColumnReverse == self.direction )
		{
			return YES;
		}
	}
	
	return NO;
}

- (BOOL)layoutShouldArrangedReverse
{
	if ( HtmlRenderDisplay_Flex == self.display || HtmlRenderDisplay_InlineFlex == self.display ) // flex
	{
		if ( HtmlRenderDirection_RowReverse == self.direction || HtmlRenderDirection_ColumnReverse == self.direction )
		{
			return YES;
		}
	}

	return NO;
}

- (BOOL)layoutShouldHorizontalAlign
{
	if ( HtmlRenderAlign_None == self.align || HtmlRenderAlign_Inherit == self.align )
	{
		return NO;
	}
	
	return YES;
}

- (BOOL)layoutShouldHorizontalAlignLeft
{
	if ( HtmlRenderAlign_Left == self.align )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)layoutShouldHorizontalAlignRight
{
	if ( HtmlRenderAlign_Right == self.align )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)layoutShouldHorizontalAlignCenter
{
	if ( HtmlRenderAlign_Center == self.align )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)layoutShouldVerticalAlign
{
	if ( HtmlRenderVerticalAlign_None == self.verticalAlign || HtmlRenderVerticalAlign_Inherit == self.verticalAlign )
	{
		return NO;
	}
	
	return YES;
}

- (BOOL)layoutShouldVerticalAlignBaseline
{
	if ( HtmlRenderVerticalAlign_Baseline == self.verticalAlign )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)layoutShouldVerticalAlignTop
{
	if ( HtmlRenderVerticalAlign_Top == self.verticalAlign ||
		HtmlRenderVerticalAlign_Super == self.verticalAlign ||
		HtmlRenderVerticalAlign_TextTop == self.verticalAlign )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)layoutShouldVerticalAlignMiddle
{
	if ( HtmlRenderVerticalAlign_Middle == self.verticalAlign )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)layoutShouldVerticalAlignBottom
{
	if ( HtmlRenderVerticalAlign_Bottom == self.verticalAlign ||
		HtmlRenderVerticalAlign_Sub == self.verticalAlign ||
		HtmlRenderVerticalAlign_TextBottom == self.verticalAlign )
	{
		return YES;
	}
	
	return NO;
}

#pragma mark -

- (id)html_serialize
{
	return [super serialize];
}

- (void)html_unserialize:(id)obj
{
	[super unserialize:obj];
}

- (void)html_zerolize
{
	[super zerolize];
}

#pragma mark -

- (UIView *)createViewWithIdentifier:(NSString *)identifier
{
	UIView * newView = [super createViewWithIdentifier:identifier];
	
	if ( newView )
	{
		if ( self.dom.domTag )
		{
			PERF( @"RenderObject '%p', create view '%@' for <%@/>", self, self.viewClass, self.dom.domTag );
		}
		else
		{
			PERF( @"RenderObject '%p', create view '%@' for \"%@ ...\"", self, self.viewClass, self.dom.domText.length > 20 ? [self.dom.domText substringToIndex:20] : self.dom.domText );
		}

		DEBUG_RENDERER_DOM( self );

		[newView html_applyDom:self.dom];
		
		DEBUG_RENDERER_STYLE( self );

		[newView html_applyStyle:self.style];	// TODO: useless code
	}
	else
	{
		if ( self.dom.domTag )
		{
			ERROR( @"RenderObject '%p', failed to create view '%@' for <%@/>", self, self.viewClass, self.dom.domTag );
		}
		else
		{
			ERROR( @"RenderObject '%p', failed to create view '%@' for \"%@ ...\"", self, self.viewClass, self.dom.domText.length > 20 ? [self.dom.domText substringToIndex:20] : self.dom.domText );
		}
	}

	return newView;
}

#pragma mark -

- (void)bindView:(UIView *)view
{
	[super bindView:view];
	
	if ( self.view )
	{
		[self.view html_applyDom:self.dom];
		[self.view html_applyStyle:self.style];	// TODO: useless code
	}
}

- (void)unbindView
{
	[super unbindView];
}

- (void)bindDom:(SamuraiHtmlDomNode *)newDom
{
	[super bindDom:newDom];
}

- (void)unbindDom
{
	[super unbindDom];
}

- (void)bindStyle:(SamuraiHtmlStyle *)newStyle
{
	[super bindStyle:newStyle];
}

- (void)unbindStyle
{
	[super unbindStyle];
}

#pragma mark -

- (NSString *)cssId
{
	return nil;
}

- (NSString *)cssTag
{
	return nil;
}

- (NSArray *)cssClasses
{
	return self.customStyleClasses;
}

- (NSDictionary *)cssAttributes
{
    return self.dom.attributes;
}

- (NSArray *)cssPseudos
{
	return nil;
}

- (NSString *)cssShadowPseudoId
{
    return nil;
}

- (id<SamuraiCSSProtocol>)cssParent
{
	return self.parent;
}

- (id<SamuraiCSSProtocol>)cssPreviousSibling
{
	return self.prev;
}

- (id<SamuraiCSSProtocol>)cssFollowingSibling
{
	return self.next;
}

- (id<SamuraiCSSProtocol>)cssSiblingAtIndex:(NSInteger)index
{
	if ( nil == self.parent )
	{
		return nil;
	}
	else
	{
		return [self.parent.childs safeObjectAtIndex:index];
	}
}

- (NSArray *)cssChildren
{
	return self.childs;
}

- (NSArray *)cssPreviousSiblings
{
	NSMutableArray * array = [NSMutableArray array];
	
	SamuraiRenderObject * domNode = self.prev;
	
	while ( domNode )
	{
		[array addObject:domNode];
		
		domNode = domNode.prev;
	}
	
	return array;
}

- (NSArray *)cssFollowingSiblings
{
	NSMutableArray * array = [NSMutableArray array];
	
	SamuraiRenderObject * domNode = self.next;

	while ( domNode )
	{
		[array addObject:domNode];
		
		domNode = domNode.next;
	}
	
	return array;
}

- (BOOL)cssIsElement
{
	return YES;
}

- (BOOL)cssIsFirstChild
{
	if ( nil == self.parent )
	{
		return YES;
	}
	else
	{
		return ([self.parent.childs firstObject] == self) ? YES : NO;
	}
}

- (BOOL)cssIsLastChild
{
	if ( nil == self.parent )
	{
		return YES;
	}
	else
	{
		return ([self.parent.childs lastObject] == self) ? YES : NO;
	}
}

- (BOOL)cssIsNthChild:(NSUInteger)index
{
	if ( nil == self.parent )
	{
		return YES;
	}
	else
	{
		return ([self.parent.childs indexOfObject:self] == index) ? YES : NO;
	}
}

#pragma mark -

- (void)relayout
{
	if ( nil == _relayout )
	{
		_relayout = [SamuraiHtmlRenderWorkflow_UpdateFrame workflowWithContext:self];
	}
	
	[_relayout process];
}

- (void)restyle
{
	if ( nil == _restyle )
	{
		_restyle = [SamuraiHtmlRenderWorkflow_UpdateStyle workflowWithContext:self];
	}

	[_restyle process];
}

- (void)rechain
{
	if ( nil == _rechain )
	{
		_rechain = [SamuraiHtmlRenderWorkflow_UpdateChain workflowWithContext:self];
	}
	
	[_rechain process];
}

#pragma mark -

- (void)computeTabIndex
{
//	renderObject.layer = 0;
//	renderObject.zIndex = 0;

	NSString * tabIndex = [self.dom.attributes objectForKey:@"tabindex"];
	
	if ( tabIndex )
	{
		self.index = [tabIndex integerValue];
	}
	else
	{
		self.index = 0;
	}
}

- (void)computeProperties
{
	Class classType = nil;
	
	classType = classType ?: NSClassFromString( self.style.samuraiRenderClass.value );
	classType = classType ?: NSClassFromString( self.dom.domTag );
	classType = classType ?: [[self class] defaultViewClass];
	
	self.viewClass = classType;
	
	self.wrap = [self.style computeWrap:HTML_DEFAULT_WRAP];
	self.align = [self.style computeAlign:HTML_DEFAULT_ALIGN];
	self.clear = [self.style computeClear:HTML_DEFAULT_CLEAR];
	self.display = [self.style computeDisplay:HTML_DEFAULT_DISPLAY];
	self.floating = [self.style computeFloating:HTML_DEFAULT_FLOATING];
	self.position = [self.style computePosition:HTML_DEFAULT_POSITION];
	self.direction = [self.style computeDirection:HTML_DEFAULT_DIRECTION];
	self.verticalAlign = [self.style computeVerticalAlign:HTML_DEFAULT_VALIGN];

	self.wrap = (HtmlRenderWrap_Inherit == self.wrap) ? HTML_DEFAULT_WRAP : self.wrap;
	self.align = (HtmlRenderAlign_Inherit == self.align) ? HTML_DEFAULT_ALIGN : self.align;
//	self.clear = (HtmlRenderClear_Inherit == self.clear) ? HTML_DEFAULT_CLEAR : self.clear;
	self.display = (HtmlRenderDisplay_Inherit == self.display) ? HTML_DEFAULT_DISPLAY : self.display;
	self.floating = (HtmlRenderFloating_Inherit == self.floating) ? HTML_DEFAULT_FLOATING : self.floating;
	self.position = (HtmlRenderPosition_Inherit == self.position) ? HTML_DEFAULT_POSITION : self.position;
	self.direction = (HtmlRenderDirection_Inherit == self.direction) ? HTML_DEFAULT_DIRECTION : self.direction;
	self.verticalAlign = (HtmlRenderVerticalAlign_Inherit == self.verticalAlign) ? HTML_DEFAULT_VALIGN : self.verticalAlign;
}

#pragma mark -

- (CGSize)computeSize:(CGSize)bound
{
	SamuraiHtmlLayoutContext context = {
		.style		= self.style,
		.bounds		= bound,
		.origin		= CGPointZero,
		.collapse	= UIEdgeInsetsZero
	};

	[self layoutWithContext:&context parentContext:NULL];

	return context.computedBounds.size;
}

- (CGFloat)computeWidth:(CGFloat)height
{
	SamuraiHtmlLayoutContext context = {
		.style		= self.style,
		.bounds		= { INVALID_VALUE, height },
		.origin		= CGPointZero,
		.collapse	= UIEdgeInsetsZero
	};

	[self layoutWithContext:&context parentContext:NULL];
	
	return context.computedBounds.size.width;
}

- (CGFloat)computeHeight:(CGFloat)width
{
	SamuraiHtmlLayoutContext context = {
		.style		= self.style,
		.bounds		= { width, INVALID_VALUE },
		.origin		= CGPointZero,
		.collapse	= UIEdgeInsetsZero
	};

	[self layoutWithContext:&context parentContext:NULL];
	
	return context.computedBounds.size.height;
}

#pragma mark -

- (CGRect)layoutWithContext:(__unused SamuraiHtmlLayoutContext *)context
			  parentContext:(SamuraiHtmlLayoutContext *)parentContext
{
	return CGRectZero;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlRenderObject )

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
