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
#import "Samurai_HtmlSharedResource.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

#define HTML_DEFAULT_WRAP		RenderWrap_Wrap
#define HTML_DEFAULT_DISPLAY	RenderDisplay_InlineBlock
#define HTML_DEFAULT_FLOATING	RenderFloating_None
#define HTML_DEFAULT_POSITION	RenderPosition_Relative
#define HTML_DEFAULT_DIRECTION	RenderDirection_Row

#pragma mark -

@implementation NSObject(HtmlSupport)

- (void)html_applyDom:(SamuraiHtmlDomNode *)dom
{
}

- (void)html_applyStyle:(SamuraiHtmlRenderStyle *)style
{
}

@end

#pragma mark -

@implementation SamuraiHtmlRenderObject

@def_prop_strong( NSMutableDictionary *,		customStyleProperties );
@def_prop_strong( NSMutableArray *,				customStyleClasses );
@def_prop_strong( NSMutableDictionary *,		customStyleComputed );

@def_prop_assign( RenderWrap,					wrap );
@def_prop_assign( RenderDisplay,				display );
@def_prop_assign( RenderFloating,				floating );
@def_prop_assign( RenderPosition,				position );
@def_prop_assign( RenderDirection,				direction );

BASE_CLASS( SamuraiHtmlRenderObject )

#pragma mark -

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.customStyleProperties = [[NSMutableDictionary alloc] init];
		self.customStyleClasses = [[NSMutableArray alloc] init];
		self.customStyleComputed = [[NSMutableDictionary alloc] init];

		self.wrap		= HTML_DEFAULT_WRAP;
		self.display	= HTML_DEFAULT_DISPLAY;
		self.floating	= HTML_DEFAULT_FLOATING;
		self.position	= HTML_DEFAULT_POSITION;
		self.direction	= HTML_DEFAULT_DIRECTION;
	}
	return self;
}

- (void)dealloc
{
	self.customStyleProperties = nil;
	self.customStyleClasses = nil;
	self.customStyleComputed = nil;
}

#pragma mark -

- (void)deepCopyFrom:(SamuraiHtmlRenderObject *)right
{
	[super deepCopyFrom:right];
	
	[self.customStyleClasses removeAllObjects];
	[self.customStyleClasses addObjectsFromArray:right.customStyleClasses];
	
	[self.customStyleProperties removeAllObjects];
	[self.customStyleProperties addEntriesFromDictionary:right.customStyleProperties];
	
	[self.customStyleComputed removeAllObjects];
	[self.customStyleComputed addEntriesFromDictionary:right.customStyleComputed];
	
	self.wrap = right.wrap;
	self.display = right.display;
	self.floating = right.floating;
	self.position = right.position;
	self.direction = right.direction;
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
//	if ( RenderFloating_None != self.floating )
//	{
//		return NO;
//	}

	if ( self.parent ) // flex
	{
		if ( RenderDisplay_Flex == self.parent.display || RenderDisplay_Flex == self.parent.display )
		{
			if ( RenderWrap_NoWrap == self.parent.wrap )
			{
				return NO;
			}
		}
	}

	return YES;
}

- (BOOL)layoutShouldWrapBefore
{
	if ( RenderFloating_None != self.floating )
	{
		return NO;
	}
	
	if ( self.parent ) // flex
	{
		if ( RenderDisplay_Flex == self.parent.display || RenderDisplay_Flex == self.parent.display )
		{
			return NO;
		}
	}
	
	if ( RenderDisplay_Inline == self.display ) // inline
	{
		return NO;
	}
	else if ( RenderDisplay_Block == self.display ) // block
	{
		return YES;
	}
	else if ( RenderDisplay_InlineBlock == self.display ) // inline-block
	{
		return NO;
	}
	else if ( RenderDisplay_Flex == self.display ) // flex
	{
		return YES;
	}
	else if ( RenderDisplay_InlineFlex == self.display ) // inline-flex
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
	if ( RenderFloating_None != self.floating )
	{
		return NO;
	}
	
	if ( self.parent ) // flex
	{
		if ( RenderDisplay_Flex == self.parent.display || RenderDisplay_InlineFlex == self.parent.display )
		{
			return NO;
		}
	}
	
	if ( RenderDisplay_Inline == self.display ) // inline
	{
		return NO;
	}
	else if ( RenderDisplay_Block == self.display ) // block
	{
		return YES;
	}
	else if ( RenderDisplay_InlineBlock == self.display ) // inline-block
	{
		return NO;
	}
	else if ( RenderDisplay_Flex == self.display ) // flex
	{
		return YES;
	}
	else if ( RenderDisplay_InlineFlex == self.display ) // inline-flex
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
	if ( RenderFloating_None != self.floating )
	{
		return NO;
	}
	
	if ( RenderDisplay_Block != self.display )
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
	if ( RenderFloating_None != self.floating )
	{
		return NO;
	}
	
	if ( RenderDisplay_Block != self.display )
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
	if ( RenderDisplay_Inline == self.display )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)layoutShouldPositioningChildren
{
	if ( RenderDisplay_Block == self.display || RenderDisplay_InlineBlock == self.display )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)layoutShouldArrangedInRow
{
	if ( RenderDisplay_Flex == self.display || RenderDisplay_InlineFlex == self.display ) // flex
	{
		if ( RenderDirection_Row == self.direction || RenderDirection_RowReverse == self.direction )
		{
			return YES;
		}
	}
	
	return NO;
}

- (BOOL)layoutShouldArrangedInCol
{
	if ( RenderDisplay_Flex == self.display || RenderDisplay_InlineFlex == self.display ) // flex
	{
		if ( RenderDirection_Column == self.direction || RenderDirection_ColumnReverse == self.direction )
		{
			return YES;
		}
	}
	
	return NO;
}

- (BOOL)layoutShouldArrangedReverse
{
	if ( RenderDisplay_Flex == self.display || RenderDisplay_InlineFlex == self.display ) // flex
	{
		if ( RenderDirection_RowReverse == self.direction || RenderDirection_ColumnReverse == self.direction )
		{
			return YES;
		}
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
		[newView html_applyDom:self.dom];
		[newView html_applyStyle:self.style];
	}

	return newView;
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

- (NSArray *)cssPseudos
{
	return nil;
}

- (id<SamuraiCssProtocol>)cssParent
{
	return self.parent;
}

- (id<SamuraiCssProtocol>)cssPreviousSibling
{
	return self.prev;
}

- (id<SamuraiCssProtocol>)cssFollowingSibling
{
	return self.next;
}

- (id<SamuraiCssProtocol>)cssSiblingAtIndex:(NSInteger)index
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

- (BOOL)setStyleValue:(NSString *)value forKey:(NSString *)key
{
	if ( nil == key )
	{
		return NO;
	}
	
	if ( nil == value )
	{
		return [self removeStyleValueForKey:key];
	}

	NSString * oldValue = [self.customStyleProperties objectForKey:key];

	if ( oldValue && [oldValue isEqualToString:value] )
	{
		return NO;
	}
	
	[self.customStyleProperties setObject:value forKey:key];
	
	return YES;
}

- (BOOL)removeStyleValueForKey:(NSString *)key
{
	if ( nil == key )
	{
		return NO;
	}
	
	if ( nil == [self.customStyleProperties objectForKey:key] )
	{
		return NO;
	}

	[self.customStyleProperties removeObjectForKey:key];

	return YES;
}

- (BOOL)setStyleClass:(NSString *)styleClass
{
	if ( nil == styleClass )
	{
		return NO;
	}

	[self.customStyleClasses removeAllObjects];
	[self.customStyleClasses addObject:styleClass];

	return YES;
}

- (BOOL)addStyleClass:(NSString *)styleClass
{
	if ( nil == styleClass )
	{
		return NO;
	}

	if ( [self.customStyleClasses containsObject:styleClass] )
	{
		return NO;
	}
	
	[self.customStyleClasses addObject:styleClass];
	
	return YES;
}

- (BOOL)removeStyleClass:(NSString *)styleClass
{
	if ( nil == styleClass )
	{
		return NO;
	}

	if ( NO == [self.customStyleClasses containsObject:styleClass] )
	{
		return NO;
	}

	[self.customStyleClasses removeObject:styleClass];
	
	return YES;
}

- (BOOL)toggleStyleClass:(NSString *)styleClass
{
	if ( [self.customStyleClasses containsObject:styleClass] )
	{
		[self.customStyleClasses removeObject:styleClass];
	}
	else
	{
		[self.customStyleClasses addObject:styleClass];
	}
	
	return YES;
}

- (BOOL)setStyleClasses:(NSArray *)styleClasses
{
	if ( nil == styleClasses )
	{
		return NO;
	}
	
	[self.customStyleClasses removeAllObjects];
	[self.customStyleClasses addObjectsFromArray:styleClasses];
	
	return YES;
}

- (BOOL)addStyleClasses:(NSArray *)styleClasses
{
	BOOL changed = NO;
	
	for ( NSString * class in styleClasses )
	{
		if ( NO == [self.customStyleClasses containsObject:class] )
		{
			[self.customStyleClasses addObject:class];
			
			changed = YES;
		}
	}
	
	return changed;
}

- (BOOL)removeStyleClasses:(NSArray *)styleClasses
{
	BOOL changed = NO;
	
	for ( NSString * class in styleClasses )
	{
		if ( [self.customStyleClasses containsObject:class] )
		{
			[self.customStyleClasses removeObject:class];
			
			changed = YES;
		}
	}
	
	return changed;
}

- (BOOL)toggleStyleClasses:(NSArray *)styleClasses
{
	for ( NSString * class in styleClasses )
	{
		if ( NO == [self.customStyleClasses containsObject:class] )
		{
			[self.customStyleClasses addObject:styleClasses];
		}
		else
		{
			[self.customStyleClasses removeObject:styleClasses];
		}
	}

	return YES;
}

- (BOOL)removeAllStyleProperties
{
	if ( 0 == [self.customStyleProperties count] )
	{
		return NO;
	}
	
	[self.customStyleProperties removeAllObjects];

	return YES;
}

- (BOOL)removeAllStyleClasses
{
	if ( 0 == [self.customStyleClasses count] )
	{
		return NO;
	}

	[self.customStyleClasses removeAllObjects];
	
	return YES;
}

#pragma mark -

- (void)relayout
{
	[[SamuraiHtmlRenderWorkflow_UpdateFrame workflowWithContext:self] process];
}

- (void)restyle
{
	[[SamuraiHtmlRenderWorkflow_UpdateStyle workflowWithContext:self] process];
}

#pragma mark -

- (void)applyStyle
{
	Class classType = nil;
	
	classType = classType ?: NSClassFromString( [self.style.samuraiRenderClass stringValue] );
	classType = classType ?: NSClassFromString( self.dom.domTag );
	classType = classType ?: [[self class] defaultViewClass];

	self.viewClass = classType;

	self.wrap = [self.style computeWrap:HTML_DEFAULT_WRAP];
	self.display = [self.style computeDisplay:HTML_DEFAULT_DISPLAY];
	self.floating = [self.style computeFloating:HTML_DEFAULT_FLOATING];
	self.position = [self.style computePosition:HTML_DEFAULT_POSITION];
	self.direction = [self.style computeDirection:HTML_DEFAULT_DIRECTION];

	SamuraiHtmlRenderObject * parent = self.parent;

	while ( nil != parent )
	{
		self.wrap = (RenderWrap_Inherit == self.wrap) ? parent.wrap : self.wrap;
		self.display = (RenderDisplay_Inherit == self.display) ? parent.display : self.display;
		self.floating = (RenderFloating_Inherit == self.floating) ? parent.floating : self.floating;
		self.position = (RenderPosition_Inherit == self.position) ? parent.position : self.position;
		self.direction = (RenderDirection_Inherit == self.direction) ? parent.direction : self.direction;

		parent = (SamuraiHtmlRenderObject *)parent.parent;
	}

	self.wrap = (RenderWrap_Inherit == self.wrap) ? HTML_DEFAULT_WRAP : self.wrap;
	self.display = (RenderDisplay_Inherit == self.display) ? HTML_DEFAULT_DISPLAY : self.display;
	self.floating = (RenderFloating_Inherit == self.floating) ? HTML_DEFAULT_FLOATING : self.floating;
	self.position = (RenderPosition_Inherit == self.position) ? HTML_DEFAULT_POSITION : self.position;
	self.direction = (RenderDirection_Inherit == self.direction) ? HTML_DEFAULT_DIRECTION : self.direction;
	
	if ( self.view )
	{
		[self.view html_applyStyle:self.style];
	}
}

#pragma mark -

- (UIEdgeInsets)computeInset:(CGSize)size
{
	UIEdgeInsets inset = UIEdgeInsetsZero;
	
	SamuraiHtmlObject * top = self.style.insetTop ?: self.style.inset.top;
	SamuraiHtmlObject * left = self.style.insetLeft ?: self.style.inset.left;
	SamuraiHtmlObject * right = self.style.insetRight ?: self.style.inset.right;
	SamuraiHtmlObject * bottom = self.style.insetBottom ?: self.style.inset.bottom;
	
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
	
//	inset.top = (INVALID_VALUE == inset.top) ? 0.0f : inset.top;
//	inset.left = (INVALID_VALUE == inset.left) ? 0.0f : inset.left;
//	inset.right = (INVALID_VALUE == inset.right) ? 0.0f : inset.right;
//	inset.bottom = (INVALID_VALUE == inset.bottom) ? 0.0f : inset.bottom;
	
	return inset;
}

- (UIEdgeInsets)computePadding:(CGSize)size
{
	UIEdgeInsets inset = UIEdgeInsetsZero;
	
	SamuraiHtmlObject * top = self.style.paddingTop ?: self.style.padding.top;
	SamuraiHtmlObject * left = self.style.paddingLeft ?: self.style.padding.left;
	SamuraiHtmlObject * right = self.style.paddingRight ?: self.style.padding.right;
	SamuraiHtmlObject * bottom = self.style.paddingBottom ?: self.style.padding.bottom;
	
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
	
//	inset.top = (INVALID_VALUE == inset.top) ? 0.0f : inset.top;
//	inset.left = (INVALID_VALUE == inset.left) ? 0.0f : inset.left;
//	inset.right = (INVALID_VALUE == inset.right) ? 0.0f : inset.right;
//	inset.bottom = (INVALID_VALUE == inset.bottom) ? 0.0f : inset.bottom;
	
	return inset;
}

- (UIEdgeInsets)computeBorder:(CGSize)size
{
	UIEdgeInsets inset = UIEdgeInsetsZero;
	
	SamuraiHtmlObject * top = self.style.borderTop ?: [self.style.border objectAtIndex:0];
	SamuraiHtmlObject * left = self.style.borderLeft ?: [self.style.border objectAtIndex:0];
	SamuraiHtmlObject * right = self.style.borderRight ?: [self.style.border objectAtIndex:0];
	SamuraiHtmlObject * bottom = self.style.borderBottom ?: [self.style.border objectAtIndex:0];
	
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
	
//	inset.top = (INVALID_VALUE == inset.top) ? 0.0f : inset.top;
//	inset.left = (INVALID_VALUE == inset.left) ? 0.0f : inset.left;
//	inset.right = (INVALID_VALUE == inset.right) ? 0.0f : inset.right;
//	inset.bottom = (INVALID_VALUE == inset.bottom) ? 0.0f : inset.bottom;
	
	return inset;
}

- (UIEdgeInsets)computeMargin:(CGSize)size
{
	UIEdgeInsets inset = UIEdgeInsetsZero;
	
	SamuraiHtmlObject * top = self.style.marginTop ?: self.style.margin.top;
	SamuraiHtmlObject * left = self.style.marginLeft ?: self.style.margin.left;
	SamuraiHtmlObject * right = self.style.marginRight ?: self.style.margin.right;
	SamuraiHtmlObject * bottom = self.style.marginBottom ?: self.style.margin.bottom;
	
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
	
//	inset.top = (INVALID_VALUE == inset.top) ? 0.0f : inset.top;
//	inset.left = (INVALID_VALUE == inset.left) ? 0.0f : inset.left;
//	inset.right = (INVALID_VALUE == inset.right) ? 0.0f : inset.right;
//	inset.bottom = (INVALID_VALUE == inset.bottom) ? 0.0f : inset.bottom;

	return inset;
}

- (UIEdgeInsets)computeOffset:(CGSize)size
{
	UIEdgeInsets inset = UIEdgeInsetsZero;
	
	SamuraiHtmlObject * top = self.style.top;
	SamuraiHtmlObject * left = self.style.left;
	SamuraiHtmlObject * right = self.style.right;
	SamuraiHtmlObject * bottom = self.style.bottom;
	
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
	
//	inset.top = (INVALID_VALUE == inset.top) ? 0.0f : inset.top;
//	inset.left = (INVALID_VALUE == inset.left) ? 0.0f : inset.left;
//	inset.right = (INVALID_VALUE == inset.right) ? 0.0f : inset.right;
//	inset.bottom = (INVALID_VALUE == inset.bottom) ? 0.0f : inset.bottom;

	return inset;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, HtmlRenderObject )
{
}
TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "_pragma_pop.h"
