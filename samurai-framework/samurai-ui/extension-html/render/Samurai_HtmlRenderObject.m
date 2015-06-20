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

#import "Samurai_HtmlRenderObject.h"
#import "Samurai_HtmlStyle.h"
#import "Samurai_UIView.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

#define HTML_DEFAULT_WRAP		HtmlRenderWrap_Wrap
#define HTML_DEFAULT_ALIGN		HtmlRenderAlign_None
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

@implementation UIView(HtmlSupport)

@def_prop_dynamic( SamuraiHtmlStyle *,	cssStyle );
@def_prop_dynamic( NSMutableArray *,	cssStyleClasses );

- (SamuraiHtmlStyle *)cssStyle
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

- (void)setCssStyle:(SamuraiHtmlStyle *)newStyle
{
	SamuraiHtmlRenderObject * thisRenderer = (SamuraiHtmlRenderObject *)[self renderer];
	
	if ( thisRenderer && [thisRenderer isKindOfClass:[SamuraiHtmlRenderObject class]] )
	{
		if ( thisRenderer.customStyle )
		{
			[thisRenderer.customStyle clear];
			[thisRenderer.customStyle merge:newStyle.properties];
		}
	}
}

- (NSArray *)cssStyleClasses
{
	SamuraiHtmlRenderObject * thisRenderer = (SamuraiHtmlRenderObject *)[self renderer];
	
	if ( thisRenderer && [thisRenderer isKindOfClass:[SamuraiHtmlRenderObject class]] )
	{
		return thisRenderer.customStyleClasses;
	}
	
	return nil;
}

- (void)setCssStyleClasses:(NSArray *)classes
{
	SamuraiHtmlRenderObject * thisRenderer = (SamuraiHtmlRenderObject *)[self renderer];
	
	if ( thisRenderer && [thisRenderer isKindOfClass:[SamuraiHtmlRenderObject class]] )
	{
		[thisRenderer.customStyleClasses removeAllObjects];
		[thisRenderer.customStyleClasses addObjectsFromArray:classes];
	}
}

- (void)attr:(NSString *)key value:(NSString *)value
{
	if ( nil == key )
		return;
	
	if ( nil == value )
	{
		[self.cssStyle setProperty:nil forKey:key];
	}
	else
	{
		[self.cssStyle setProperty:value forKey:key];
	}
}

- (void)addCssStyleClass:(NSString *)className
{
	if ( nil == className )
		return;
	
	if ( NO == [self.cssStyleClasses containsObject:className] )
	{
		[self.cssStyleClasses addObject:className];
	}
}

- (void)removeCssStyleClass:(NSString *)className
{
	if ( nil == className )
		return;

	if ( [self.cssStyleClasses containsObject:className] )
	{
		[self.cssStyleClasses removeObject:className];
	}
}

- (void)toggleCssStyleClass:(NSString *)className
{
	if ( nil == className )
		return;

	if ( [self.cssStyleClasses containsObject:className] )
	{
		[self.cssStyleClasses removeObject:className];
	}
	else
	{
		[self.cssStyleClasses addObject:className];
	}
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
	
//	renderObject.layer = 0;
//	renderObject.zIndex = 0;

	NSString * tabIndex = [dom.attributes objectForKey:@"tabindex"];

	if ( tabIndex )
	{
		renderObject.index = [tabIndex integerValue];
	}

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

	[self.customStyle clear];
	[self.customStyle merge:right.customStyle.properties];

	[self.style clear];
	[self.style merge:right.style.properties];
	
	self.wrap = right.wrap;
	self.align = right.align;
	self.display = right.display;
	self.floating = right.floating;
	self.position = right.position;
	self.direction = right.direction;
	self.verticalAlign = right.verticalAlign;
}

#pragma mark -

- (BOOL)store_isValid
{
	return NO;
}

- (BOOL)store_hasChildren
{
	return NO;
}

#pragma mark -

- (CGRect)computeFrame:(CGSize)bound origin:(CGPoint)origin;
{
	return [super zerolizeFrame];
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

- (BOOL)layoutShouldBoundsToWindow
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

- (id)serialize
{
	return [super serialize];
}

- (void)unserialize:(id)obj
{
	[super unserialize:obj];
}

- (void)zerolize
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

		[newView html_applyDom:self.dom];
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

- (NSArray *)cssAttributes
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

- (void)applyStyle
{
	[self applyStyleInheritesFrom:self.parent];
}

- (void)applyStyleInheritesFrom:(SamuraiHtmlRenderObject * )parent
{
	Class classType = nil;

	classType = classType ?: NSClassFromString( self.style.renderClass.value );
	classType = classType ?: NSClassFromString( self.dom.domTag );
	classType = classType ?: [[self class] defaultViewClass];

	self.viewClass = classType;
	
	self.wrap = [self.style computeWrap:HTML_DEFAULT_WRAP];
	self.align = [self.style computeAlign:HTML_DEFAULT_ALIGN];
	self.display = [self.style computeDisplay:HTML_DEFAULT_DISPLAY];
	self.floating = [self.style computeFloating:HTML_DEFAULT_FLOATING];
	self.position = [self.style computePosition:HTML_DEFAULT_POSITION];
	self.direction = [self.style computeDirection:HTML_DEFAULT_DIRECTION];
	self.verticalAlign = [self.style computeVerticalAlign:HTML_DEFAULT_VALIGN];

	while ( nil != parent )
	{
		self.wrap = (HtmlRenderWrap_Inherit == self.wrap) ? parent.wrap : self.wrap;
		self.align = (HtmlRenderAlign_Inherit == self.align) ? parent.align : self.align;
		self.display = (HtmlRenderDisplay_Inherit == self.display) ? parent.display : self.display;
		self.floating = (HtmlRenderFloating_Inherit == self.floating) ? parent.floating : self.floating;
		self.position = (HtmlRenderPosition_Inherit == self.position) ? parent.position : self.position;
		self.direction = (HtmlRenderDirection_Inherit == self.direction) ? parent.direction : self.direction;
		self.verticalAlign = (HtmlRenderVerticalAlign_Inherit == self.verticalAlign) ? parent.verticalAlign : self.verticalAlign;

		parent = (SamuraiHtmlRenderObject *)parent.parent;
	}

	self.wrap = (HtmlRenderWrap_Inherit == self.wrap) ? HTML_DEFAULT_WRAP : self.wrap;
	self.align = (HtmlRenderAlign_Inherit == self.align) ? HTML_DEFAULT_ALIGN : self.align;
	self.display = (HtmlRenderDisplay_Inherit == self.display) ? HTML_DEFAULT_DISPLAY : self.display;
	self.floating = (HtmlRenderFloating_Inherit == self.floating) ? HTML_DEFAULT_FLOATING : self.floating;
	self.position = (HtmlRenderPosition_Inherit == self.position) ? HTML_DEFAULT_POSITION : self.position;
	self.direction = (HtmlRenderDirection_Inherit == self.direction) ? HTML_DEFAULT_DIRECTION : self.direction;
	self.verticalAlign = (HtmlRenderVerticalAlign_Inherit == self.verticalAlign) ? HTML_DEFAULT_VALIGN : self.verticalAlign;
	
	if ( self.view )
	{
		DEBUG_RENDERER_STYLE( self );

		[self.view html_applyStyle:self.style];
	}
}

#pragma mark -

- (UIEdgeInsets)computeInset:(CGSize)size
{
	UIEdgeInsets inset = UIEdgeInsetsZero;
	
	SamuraiHtmlStyleObject * top = self.style.insetTop ?: self.style.inset.top;
	SamuraiHtmlStyleObject * left = self.style.insetLeft ?: self.style.inset.left;
	SamuraiHtmlStyleObject * right = self.style.insetRight ?: self.style.inset.right;
	SamuraiHtmlStyleObject * bottom = self.style.insetBottom ?: self.style.inset.bottom;
	
	if ( top )
	{
		if ( [top isNumber] )
		{
			inset.top = [top computeValue:size.height];
		}
//		else if ( [top isFunction] )
//		{
//			TODO( "" );
//		}
//		else
//		{
//			TODO( "" );
//		}
	}
	
	if ( bottom )
	{
		if ( [bottom isNumber] )
		{
			inset.bottom = [bottom computeValue:size.height];
		}
//		else if ( [bottom isFunction] )
//		{
//			TODO( "" );
//		}
//		else
//		{
//			TODO( "" );
//		}
	}
	
	if ( left )
	{
		if ( [left isNumber] )
		{
			inset.left = [left computeValue:size.width];
		}
//		else if ( [left isFunction] )
//		{
//			TODO( "" );
//		}
//		else
//		{
//			TODO( "" );
//		}
	}
	
	if ( right )
	{
		if ( [right isNumber] )
		{
			inset.right = [right computeValue:size.width];
		}
//		else if ( [right isFunction] )
//		{
//			TODO( "" );
//		}
//		else
//		{
//			TODO( "" );
//		}
	}
	
	inset.top		= NORMALIZE_VALUE( inset.top );
	inset.left		= NORMALIZE_VALUE( inset.left );
	inset.right		= NORMALIZE_VALUE( inset.right );
	inset.bottom	= NORMALIZE_VALUE( inset.bottom );
	
	return inset;
}

- (UIEdgeInsets)computePadding:(CGSize)size
{
	UIEdgeInsets inset = UIEdgeInsetsZero;
	
	SamuraiHtmlStyleObject * top = self.style.paddingTop ?: self.style.padding.top;
	SamuraiHtmlStyleObject * left = self.style.paddingLeft ?: self.style.padding.left;
	SamuraiHtmlStyleObject * right = self.style.paddingRight ?: self.style.padding.right;
	SamuraiHtmlStyleObject * bottom = self.style.paddingBottom ?: self.style.padding.bottom;
	
	if ( top )
	{
		if ( [top isNumber] )
		{
			inset.top = [top computeValue:size.height];
		}
//		else if ( [top isFunction] )
//		{
//			TODO( "" );
//		}
//		else
//		{
//			TODO( "" );
//		}
	}
	
	if ( bottom )
	{
		if ( [bottom isNumber] )
		{
			inset.bottom = [bottom computeValue:size.height];
		}
//		else if ( [bottom isFunction] )
//		{
//			TODO( "" );
//		}
//		else
//		{
//			TODO( "" );
//		}
	}
	
	if ( left )
	{
		if ( [left isNumber] )
		{
			inset.left = [left computeValue:size.width];
		}
//		else if ( [left isFunction] )
//		{
//			TODO( "" );
//		}
//		else
//		{
//			TODO( "" );
//		}
	}
	
	if ( right )
	{
		if ( [right isNumber] )
		{
			inset.right = [right computeValue:size.width];
		}
//		else if ( [right isFunction] )
//		{
//			TODO( "" );
//		}
//		else
//		{
//			TODO( "" );
//		}
	}
	
	inset.top		= NORMALIZE_VALUE( inset.top );
	inset.left		= NORMALIZE_VALUE( inset.left );
	inset.right		= NORMALIZE_VALUE( inset.right );
	inset.bottom	= NORMALIZE_VALUE( inset.bottom );
	
	return inset;
}

- (UIEdgeInsets)computeBorder:(CGSize)size
{
	UIEdgeInsets inset = UIEdgeInsetsZero;
	
	SamuraiHtmlStyleObject * top = self.style.borderTop ?: [self.style.border objectAtIndex:0];
	SamuraiHtmlStyleObject * left = self.style.borderLeft ?: [self.style.border objectAtIndex:0];
	SamuraiHtmlStyleObject * right = self.style.borderRight ?: [self.style.border objectAtIndex:0];
	SamuraiHtmlStyleObject * bottom = self.style.borderBottom ?: [self.style.border objectAtIndex:0];
	
	TODO( "border" )

	if ( top )
	{
		if ( [top isNumber] )
		{
			inset.top = [top computeValue:size.height];
		}
//		else if ( [top isFunction] )
//		{
//			TODO( "" );
//		}
//		else
//		{
//			TODO( "" );
//		}
	}
	
	if ( bottom )
	{
		if ( [bottom isNumber] )
		{
			inset.bottom = [bottom computeValue:size.height];
		}
//		else if ( [bottom isFunction] )
//		{
//			TODO( "" );
//		}
//		else
//		{
//			TODO( "" );
//		}
	}
	
	if ( left )
	{
		if ( [left isNumber] )
		{
			inset.left = [left computeValue:size.width];
		}
//		else if ( [left isFunction] )
//		{
//			TODO( "" );
//		}
//		else
//		{
//			TODO( "" );
//		}
	}
	
	if ( right )
	{
		if ( [right isNumber] )
		{
			inset.right = [right computeValue:size.width];
		}
//		else if ( [right isFunction] )
//		{
//			TODO( "" );
//		}
//		else
//		{
//			TODO( "" );
//		}
	}
	
	inset.top		= NORMALIZE_VALUE( inset.top );
	inset.left		= NORMALIZE_VALUE( inset.left );
	inset.right		= NORMALIZE_VALUE( inset.right );
	inset.bottom	= NORMALIZE_VALUE( inset.bottom );
	
	return inset;
}

- (UIEdgeInsets)computeMargin:(CGSize)size
{
	UIEdgeInsets inset = UIEdgeInsetsZero;
	
	SamuraiHtmlStyleObject * top = self.style.marginTop ?: self.style.margin.top;
	SamuraiHtmlStyleObject * left = self.style.marginLeft ?: self.style.margin.left;
	SamuraiHtmlStyleObject * right = self.style.marginRight ?: self.style.margin.right;
	SamuraiHtmlStyleObject * bottom = self.style.marginBottom ?: self.style.margin.bottom;
	
	if ( top )
	{
		if ( [top isNumber] )
		{
			inset.top = [top computeValue:size.height];
		}
//		else if ( [top isFunction] )
//		{
//			TODO( "" );
//		}
//		else
//		{
//			TODO( "" );
//		}
	}
	
	if ( bottom )
	{
		if ( [bottom isNumber] )
		{
			inset.bottom = [bottom computeValue:size.height];
		}
//		else if ( [bottom isFunction] )
//		{
//			TODO( "" );
//		}
//		else
//		{
//			TODO( "" );
//		}
	}
	
	if ( left )
	{
		if ( [left isNumber] )
		{
			inset.left = [left computeValue:size.width];
		}
//		else if ( [left isFunction] )
//		{
//			TODO( "" );
//		}
//		else
//		{
//			TODO( "" );
//		}
	}
	
	if ( right )
	{
		if ( [right isNumber] )
		{
			inset.right = [right computeValue:size.width];
		}
//		else if ( [right isFunction] )
//		{
//			TODO( "" );
//		}
//		else
//		{
//			TODO( "" );
//		}
	}
	
	inset.top		= NORMALIZE_VALUE( inset.top );
	inset.left		= NORMALIZE_VALUE( inset.left );
	inset.right		= NORMALIZE_VALUE( inset.right );
	inset.bottom	= NORMALIZE_VALUE( inset.bottom );

	return inset;
}

- (UIEdgeInsets)computeOffset:(CGSize)size
{
	UIEdgeInsets inset = UIEdgeInsetsZero;
	
	SamuraiHtmlStyleObject * top = self.style.top;
	SamuraiHtmlStyleObject * left = self.style.left;
	SamuraiHtmlStyleObject * right = self.style.right;
	SamuraiHtmlStyleObject * bottom = self.style.bottom;
	
	if ( top )
	{
		if ( [top isNumber] )
		{
			inset.top = [top computeValue:size.height];
		}
//		else if ( [top isFunction] )
//		{
//			TODO( "" );
//		}
//		else
//		{
//			TODO( "" );
//		}
	}
	
	if ( bottom )
	{
		if ( [bottom isNumber] )
		{
			inset.bottom = [bottom computeValue:size.height];
		}
//		else if ( [bottom isFunction] )
//		{
//			TODO( "" );
//		}
//		else
//		{
//			TODO( "" );
//		}
	}
	
	if ( left )
	{
		if ( [left isNumber] )
		{
			inset.left = [left computeValue:size.width];
		}
//		else if ( [left isFunction] )
//		{
//			TODO( "" );
//		}
//		else
//		{
//			TODO( "" );
//		}
	}
	
	if ( right )
	{
		if ( [right isNumber] )
		{
			inset.right = [right computeValue:size.width];
		}
//		else if ( [right isFunction] )
//		{
//			TODO( "" );
//		}
//		else
//		{
//			TODO( "" );
//		}
	}

	inset.top		= NORMALIZE_VALUE( inset.top );
	inset.left		= NORMALIZE_VALUE( inset.left );
	inset.right		= NORMALIZE_VALUE( inset.right );
	inset.bottom	= NORMALIZE_VALUE( inset.bottom );

	return inset;
}

- (CGFloat)computeLineHeight:(CGFloat)height
{
	CGFloat lineHeight = 0.0f;
	
	if ( self.style.lineHeight )
	{
		if ( [self.style.lineHeight isNumber] )
		{
			if ( [self.style.lineHeight isConstant] )
			{
				lineHeight = [self.style.lineHeight computeValue:height];
				lineHeight = NORMALIZE_VALUE( lineHeight );
				lineHeight = height * lineHeight;
			}
			else if ( [self.style.lineHeight isPercentage] )
			{
				lineHeight = [self.style.lineHeight computeValue:height];
				lineHeight = NORMALIZE_VALUE( lineHeight );
				lineHeight = height * lineHeight;
			}
			else
			{
				lineHeight = [self.style.lineHeight computeValue:height];
				lineHeight = NORMALIZE_VALUE( lineHeight );	
			}
		}
	}
	
	return lineHeight;
}

- (CGFloat)computeBorderSpacing
{
	CGFloat borderSpacing = 0.0f;

	if ( self.style.borderSpacing )
	{
		if ( [self.style.borderSpacing isNumber] )
		{
			borderSpacing = [self.style.borderSpacing computeValue];
			borderSpacing = NORMALIZE_VALUE( borderSpacing );
		}
	}
	
	return borderSpacing;
}

- (CGFloat)computeCellSpacing
{
	CGFloat cellSpacing = 0.0f;
	
	if ( self.style.cellSpacing )
	{
		if ( [self.style.cellSpacing isNumber] )
		{
			cellSpacing = [self.style.cellSpacing computeValue];
			cellSpacing = NORMALIZE_VALUE( cellSpacing );
		}
	}
	
	return cellSpacing;
}

- (CGFloat)computeCellPadding
{
	CGFloat cellPadding = 0.0f;
	
	if ( self.style.cellPadding )
	{
		if ( [self.style.cellPadding isNumber] )
		{
			cellPadding = [self.style.cellPadding computeValue];
			cellPadding = NORMALIZE_VALUE( cellPadding );
		}
	}

	return cellPadding;
}

#pragma mark -

- (void)renderWillLoad
{
}

- (void)renderDidLoad
{
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, HtmlRenderObject )

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
