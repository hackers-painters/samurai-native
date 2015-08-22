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
#import "Samurai_HtmlRenderStyle.h"

#import "Samurai_HtmlRenderStoreScope.h"
#import "Samurai_HtmlRenderStore.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

#define HTML_DEFAULT_WRAP			CSSWrap_Wrap
#define HTML_DEFAULT_ALIGN			CSSAlign_None
#define HTML_DEFAULT_CLEAR			CSSClear_None
#define HTML_DEFAULT_DISPLAY		CSSDisplay_Inline
#define HTML_DEFAULT_FLOATING		CSSFloating_None
#define HTML_DEFAULT_POSITION		CSSPosition_Relative
#define HTML_DEFAULT_VALIGN			CSSVerticalAlign_Baseline

#define HTML_DEFAULT_BOXALIGN		CSSBoxAlign_Stretch
#define HTML_DEFAULT_BOXORIENT		CSSBoxOrient_InlineAxis
#define HTML_DEFAULT_BOXDIRECTION	CSSBoxDirection_Normal
#define HTML_DEFAULT_BOXLINES		CSSBoxLines_Single
#define HTML_DEFAULT_BOXPACK		CSSBoxPack_Start

#define HTML_DEFAULT_FLEXWRAP		CSSFlexWrap_Nowrap
#define HTML_DEFAULT_FLEXDIRECTION	CSSFlexDirection_Row

#define HTML_DEFAULT_ALIGNSELF		CSSAlignSelf_Auto
#define HTML_DEFAULT_ALIGNITEMS		CSSAlignItems_Stretch
#define HTML_DEFAULT_ALIGNCONTENT	CSSAlignContent_Stretch
#define HTML_DEFAULT_JUSTIFYCONTENT	CSSJustifyContent_FlexStart

#pragma mark -

@implementation NSObject(HtmlSupport)

@def_prop_dynamic( SamuraiHtmlRenderObject *,	htmlRenderer );

- (SamuraiHtmlRenderObject *)htmlRenderer
{
	SamuraiRenderObject * renderer = [self renderer];
	
	if ( renderer && [renderer isKindOfClass:[SamuraiHtmlRenderObject class]] )
	{
		return (SamuraiHtmlRenderObject *)renderer;
	}
	else
	{
		return nil;
	}
}

- (void)html_applyDom:(SamuraiHtmlDomNode *)dom
{
	[self applyDom:dom];
}

- (void)html_applyStyle:(SamuraiHtmlRenderStyle *)style
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
	SamuraiHtmlRenderWorkflow_UpdateFrame *		_relayoutFlow;
	SamuraiHtmlRenderWorkflow_UpdateStyle *		_restyleFlow;
	SamuraiHtmlRenderWorkflow_UpdateChain *		_rechainFlow;
}

@def_prop_strong( NSMutableArray *,				customClasses );
@def_prop_strong( SamuraiHtmlRenderStyle *,		customStyle );

@def_prop_assign( CSSWrap,						wrap );
@def_prop_assign( CSSAlign,						align );
@def_prop_assign( CSSClear,						clear );
@def_prop_assign( CSSDisplay,					display );
@def_prop_assign( CSSFloating,					floating );
@def_prop_assign( CSSPosition,					position );
@def_prop_assign( CSSVerticalAlign,				verticalAlign );

@def_prop_assign( CSSBoxAlign,					boxAlign );
@def_prop_assign( CSSBoxOrient,					boxOrient );
@def_prop_assign( CSSBoxDirection,				boxDirection );
@def_prop_assign( CSSBoxLines,					boxLines );
@def_prop_assign( CSSBoxPack,					boxPack );

@def_prop_assign( CSSFlexWrap,					flexWrap );
@def_prop_assign( CSSFlexDirection,				flexDirection );

@def_prop_assign( CSSAlignSelf,					alignSelf );
@def_prop_assign( CSSAlignItems,				alignItems );
@def_prop_assign( CSSAlignContent,				alignContent );
@def_prop_assign( CSSJustifyContent,			justifyContent );

@def_prop_assign( CGFloat,						zIndex );
@def_prop_assign( CGFloat,						order );

@def_prop_assign( CGFloat,						flexGrow );
@def_prop_assign( CGFloat,						flexBasis );
@def_prop_assign( CGFloat,						flexShrink );

@def_prop_assign( NSInteger,					tableRow );
@def_prop_assign( NSInteger,					tableCol );
@def_prop_assign( NSInteger,					tableRowSpan );
@def_prop_assign( NSInteger,					tableColSpan );

@def_prop_strong( SamuraiHtmlLayoutObject *,	layout );

@def_prop_dynamic( SamuraiHtmlDomNode *,		dom );		// overrided
@def_prop_dynamic( SamuraiHtmlRenderStyle *,	style );	// overrided
@def_prop_dynamic( SamuraiHtmlRenderObject *,	root );		// overrided
@def_prop_dynamic( SamuraiHtmlRenderObject *,	parent );	// overrided
@def_prop_dynamic( SamuraiHtmlRenderObject *,	prev );		// overrided
@def_prop_dynamic( SamuraiHtmlRenderObject *,	next );		// overrided

BASE_CLASS( SamuraiHtmlRenderObject )

+ (Class)defaultLayoutClass
{
	return nil;
}

+ (Class)defaultViewClass
{
	return nil;
}

#pragma mark -

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.customClasses = [[NSMutableArray alloc] init];
		self.customStyle = [[SamuraiHtmlRenderStyle alloc] init];

		self.wrap			= HTML_DEFAULT_WRAP;
		self.align			= HTML_DEFAULT_ALIGN;
		self.display		= HTML_DEFAULT_DISPLAY;
		self.floating		= HTML_DEFAULT_FLOATING;
		self.position		= HTML_DEFAULT_POSITION;
		self.verticalAlign	= HTML_DEFAULT_VALIGN;

		self.boxAlign		= HTML_DEFAULT_BOXALIGN;
		self.boxOrient		= HTML_DEFAULT_BOXORIENT;
		self.boxDirection	= HTML_DEFAULT_BOXDIRECTION;
		self.boxLines		= HTML_DEFAULT_BOXLINES;
		self.boxPack		= HTML_DEFAULT_BOXPACK;

		self.flexWrap		= HTML_DEFAULT_FLEXWRAP;
		self.flexDirection	= HTML_DEFAULT_FLEXDIRECTION;
		
		self.alignSelf		= HTML_DEFAULT_ALIGNSELF;
		self.alignItems		= HTML_DEFAULT_ALIGNITEMS;
		self.alignContent	= HTML_DEFAULT_ALIGNCONTENT;
		self.justifyContent	= HTML_DEFAULT_JUSTIFYCONTENT;
		
		self.zIndex			= 0.0f;
		self.order			= 0.0f;
		
		self.flexGrow		= 0;
		self.flexBasis		= INVALID_VALUE;
		self.flexShrink		= 1;

		self.tableCol		= -1;
		self.tableRow		= -1;
		self.tableRowSpan	= 0;
		self.tableColSpan	= 0;
	}
	return self;
}

- (void)dealloc
{
	_relayoutFlow = nil;
	_restyleFlow = nil;
	_rechainFlow = nil;

	self.customClasses = nil;
	self.customStyle = nil;

	self.layout = nil;
}

#pragma mark -

- (void)deepCopyFrom:(SamuraiHtmlRenderObject *)right
{
	[super deepCopyFrom:right];

	[self.customClasses removeAllObjects];
	[self.customClasses addObjectsFromArray:right.customClasses];

	[self.customStyle clearProperties];
	[self.customStyle mergeProperties:right.customStyle.properties];

	[self.style clearProperties];
	[self.style mergeProperties:right.style.properties];
	
	[self computeProperties];
}

#pragma mark -

- (void)renderWillLoad
{
}

- (void)renderDidLoad
{
}

#pragma mark -

- (id)store_serialize
{
	return [super serialize];
}

- (void)store_unserialize:(id)obj
{
	[super unserialize:obj];
}

- (void)store_zerolize
{
	[super zerolize];
}

#pragma mark -

- (UIView *)createViewWithIdentifier:(NSString *)identifier
{
	UIView * newView = [super createViewWithIdentifier:identifier];
	
	if ( newView )
	{
		if ( self.dom.tag )
		{
			PERF( @"RenderObject '%p', create view '%@' for <%@/>", self, self.viewClass, self.dom.tag );
		}
		else
		{
			PERF( @"RenderObject '%p', create view '%@' for \"%@\"", self, self.viewClass, [self.dom.text trim] );
		}

		DEBUG_RENDERER_DOM( self );

		[newView html_applyDom:self.dom];
		
//		DEBUG_RENDERER_STYLE( self );
//
//		[newView html_applyStyle:self.style];	// TODO: useless code

		if ( self.childs && [self.childs count] )
		{
			NSMutableArray * subRenderers = [NSMutableArray nonRetainingArray];
			
			[subRenderers addObjectsFromArray:self.childs];
			[subRenderers sortUsingComparator:^NSComparisonResult(SamuraiHtmlRenderObject * obj1, SamuraiHtmlRenderObject * obj2) {
				if ( obj1.zIndex < obj2.zIndex )
				{
					return NSOrderedAscending;
				}
				else if ( obj1.zIndex > obj2.zIndex )
				{
					return NSOrderedDescending;
				}
				else
				{
					return NSOrderedSame;
				}
			}];
			
			for ( SamuraiHtmlRenderObject * subRenderer in subRenderers )
			{
				if ( subRenderer.view )
				{
					[subRenderer.view.superview bringSubviewToFront:subRenderer.view];
				}
			}
		}
	}
	else
	{
		if ( self.dom.tag )
		{
			ERROR( @"RenderObject '%p', failed to create view '%@' for <%@/>", self, self.viewClass, self.dom.tag );
		}
		else
		{
			ERROR( @"RenderObject '%p', failed to create view '%@' for \"%@\"", self, self.viewClass, [self.dom.text trim] );
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

- (void)bindStyle:(SamuraiHtmlRenderStyle *)newStyle
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
	return self.customClasses;
}

- (NSDictionary *)cssAttributes
{
	return nil;
}

- (NSArray *)cssPseudos
{
	return nil;
}

- (NSString *)cssShadowPseudoId
{
    return nil;
}

#pragma mark -

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
	
	SamuraiHtmlRenderObject * domNode = self.prev;
	
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
	
	SamuraiHtmlRenderObject * domNode = self.next;

	while ( domNode )
	{
		[array addObject:domNode];
		
		domNode = domNode.next;
	}
	
	return array;
}

- (NSString *)description
{
    return NSStringFromSamuraiCSSProtocolElement(self);
}

#pragma mark -

- (NSString *)signalNamespace
{
	if ( nil == self.view )
		return nil;
	
	return [[self.view class] description];
}

- (NSString *)signalTag
{
	if ( nil == self.view )
		return nil;

	return self.dom.attrId;
}

- (NSString *)signalDescription
{
	if ( nil == self.view )
		return nil;

	if ( self.dom.tag && self.dom.attrId )
	{
		return [NSString stringWithFormat:@"%@, <%@ id='%@'/>", [[self class] description], self.dom.tag, self.dom.attrId];
	}
	else if ( self.dom.tag )
	{
		return [NSString stringWithFormat:@"%@, <%@/>", [[self class] description], self.dom.tag];
	}
	else
	{
		return [NSString stringWithFormat:@"%@", [[self class] description]];
	}
}

- (id)signalResponders
{
	if ( nil == self.view )
		return nil;

	return [self.view nextResponder];
}

- (id)signalAlias
{
	if ( nil == self.view )
		return nil;

	NSMutableArray * array = [NSMutableArray nonRetainingArray];
	
	if ( self.dom.attrId && self.dom.tag )
	{
		[array addObject:[NSString stringWithFormat:@"%@____%@", self.dom.tag, self.dom.attrId]];
	}
	
	if ( self.dom.attrId )
	{
		[array addObject:self.dom.attrId];
	}
	
	return array;
}

#pragma mark -

- (void)relayout
{
	if ( nil == _relayoutFlow )
	{
		_relayoutFlow = [SamuraiHtmlRenderWorkflow_UpdateFrame workflowWithContext:self];
	}
	
	[_relayoutFlow process];
}

- (void)restyle
{
	if ( nil == _restyleFlow )
	{
		_restyleFlow = [SamuraiHtmlRenderWorkflow_UpdateStyle workflowWithContext:self];
	}

	[_restyleFlow process];
}

- (void)rechain
{
	if ( nil == _rechainFlow )
	{
		_rechainFlow = [SamuraiHtmlRenderWorkflow_UpdateChain workflowWithContext:self];
	}
	
	[_rechainFlow process];
}

#pragma mark -

- (void)bindOutletsTo:(NSObject *)container
{
	[self bindOutlets:self toContainer:container];
}

- (void)bindOutlets:(SamuraiHtmlRenderObject *)source toContainer:(NSObject *)container
{
	if ( nil == source )
		return;
	
	if ( source.dom.attrId && source.dom.attrId.length )
	{
		NSString * ivarName = source.dom.attrId;
		NSString * ivarName2 = [NSString stringWithFormat:@"_%@", source.dom.attrId];
		NSString * propName = source.dom.attrId;
		
		[self assignValue:source.view toObject:container forProperty:ivarName];
		[self assignValue:source.view toObject:container forProperty:ivarName2];
		[self assignValue:source.view toObject:container forProperty:propName];
	}
	else
	{
		for ( SamuraiHtmlRenderObject * childRender in source.childs )
		{
			[self bindOutlets:childRender toContainer:container];
		}
	}
}

- (void)unbindOutletsFrom:(NSObject *)container
{
	[self unbindOutlets:self fromContainer:container];
}

- (void)unbindOutlets:(SamuraiHtmlRenderObject *)source fromContainer:(NSObject *)container
{
	if ( source.dom.attrId && source.dom.attrId.length )
	{
		NSString * ivarName = [NSString stringWithFormat:@"_%@", source.dom.attrId];
		NSString * propName = source.dom.attrId;
		
		[self assignValue:nil toObject:container forProperty:ivarName];
		[self assignValue:nil toObject:container forProperty:propName];
	}
	else
	{
		for ( SamuraiHtmlRenderObject * childRender in source.childs )
		{
			[self unbindOutlets:childRender fromContainer:container];
		}
	}
}

- (void)assignValue:(UIView *)view toObject:(NSObject *)container forProperty:(NSString *)name
{
	name = [name stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
	name = [name stringByReplacingOccurrencesOfString:@"." withString:@"_"];
	name = [name stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
	name = [name trim];
	
	//	name = [@"outlet_" stringByAppendingString:name];
	
	objc_property_t property = class_getProperty( [container class], [name UTF8String] );
	if ( property )
	{
		const char * attr = property_getAttributes( property );
		if ( NULL == attr )
			return;
		
		BOOL isReadOnly = [SamuraiEncoding isReadOnly:attr];
		if ( isReadOnly )
			return;
		
		NSString * className = [SamuraiEncoding classNameOfAttribute:attr];
		if ( nil == className )
			return;
		
		Class classType = NSClassFromString( className );
		if ( classType && ([classType isSubclassOfClass:[UIView class]] || [classType isSubclassOfClass:[UIViewController class]]) )
		{
			PERF( @"RenderObject '%p', set %@ '%p' to property '%@'", self, self.viewClass, self.view, name );
			
			[container setValue:view forKey:name];
		}
	}
	else
	{
		Ivar ivar = class_getInstanceVariable( [container class], [name UTF8String] );
		if ( ivar )
		{
			PERF( @"RenderObject '%p', set %@ '%p' to ivar '%@'", self, self.viewClass, self.view, name );
			
			[container setValue:view forKey:name];
		}
	}
}

#pragma mark -

- (SamuraiHtmlRenderObject *)queryById:(NSString *)domId
{
	if ( nil == domId )
	{
		return nil;
	}
	
	if ( [self.dom.attrId isEqualToString:domId] )
	{
		return self;
	}
	
	for ( SamuraiHtmlRenderObject * childRender in self.childs )
	{
		SamuraiHtmlRenderObject * result = [childRender queryById:domId];
		
		if ( result )
		{
			return result;
		}
	}
	
	return nil;
}

- (SamuraiHtmlRenderObject *)queryByDom:(SamuraiHtmlDomNode *)domNode
{
	if ( nil == domNode )
	{
		return nil;
	}
	
	if ( self.dom == domNode )
	{
		return self;
	}

	for ( SamuraiHtmlRenderObject * childRender in self.childs )
	{
		SamuraiHtmlRenderObject * result = [childRender queryByDom:domNode];
		
		if ( result )
		{
			return result;
		}
	}
	
	return nil;
}

- (SamuraiHtmlRenderObject *)queryByName:(NSString *)name
{
	if ( nil == name )
	{
		return nil;
	}
	
	if ( [self.dom.attrName isEqualToString:name] )
	{
		return self;
	}
	
	for ( SamuraiHtmlRenderObject * childRender in self.childs )
	{
		SamuraiHtmlRenderObject * result = [childRender queryByName:name];
		
		if ( result )
		{
			return result;
		}
	}
	
	return nil;
}

#pragma mark -

- (void)computeProperties
{
// compute properties
	
	self.wrap			= [self.style computeWrap:HTML_DEFAULT_WRAP];
	self.align			= [self.style computeAlign:HTML_DEFAULT_ALIGN];
	self.clear			= [self.style computeClear:HTML_DEFAULT_CLEAR];
	self.display		= [self.style computeDisplay:HTML_DEFAULT_DISPLAY];
	self.floating		= [self.style computeFloating:HTML_DEFAULT_FLOATING];
	self.position		= [self.style computePosition:HTML_DEFAULT_POSITION];
	self.verticalAlign	= [self.style computeVerticalAlign:HTML_DEFAULT_VALIGN];
	
	self.wrap			= (CSSWrap_Inherit == self.wrap) ? HTML_DEFAULT_WRAP : self.wrap;
	self.align			= (CSSAlign_Inherit == self.align) ? HTML_DEFAULT_ALIGN : self.align;
	self.clear			= (CSSClear_Inherit == self.clear) ? HTML_DEFAULT_CLEAR : self.clear;
	self.display		= (CSSDisplay_Inherit == self.display) ? HTML_DEFAULT_DISPLAY : self.display;
	self.floating		= (CSSFloating_Inherit == self.floating) ? HTML_DEFAULT_FLOATING : self.floating;
	self.position		= (CSSPosition_Inherit == self.position) ? HTML_DEFAULT_POSITION : self.position;
	self.verticalAlign	= (CSSVerticalAlign_Inherit == self.verticalAlign) ? HTML_DEFAULT_VALIGN : self.verticalAlign;
	
	self.order			= [self.style computeOrder:0.0f];
	self.zIndex			= [self.style computeZIndex:0.0f];
	
// compute properties
	
	self.boxPack		= [self.style computeBoxPack:HTML_DEFAULT_BOXPACK];
	self.boxAlign		= [self.style computeBoxAlign:HTML_DEFAULT_BOXALIGN];
	self.boxLines		= [self.style computeBoxLines:HTML_DEFAULT_BOXLINES];
	self.boxOrient		= [self.style computeBoxOrient:HTML_DEFAULT_BOXORIENT];
	self.boxDirection	= [self.style computeBoxDirection:HTML_DEFAULT_BOXDIRECTION];

	self.flexWrap		= [self.style computeFlexWrap:HTML_DEFAULT_FLEXWRAP];
	self.flexDirection	= [self.style computeFlexDirection:HTML_DEFAULT_FLEXDIRECTION];
	self.flexGrow		= [self.style computeFlexGrow:0];
	self.flexBasis		= [self.style computeFlexBasis:INVALID_VALUE];
	self.flexShrink		= [self.style computeFlexShrink:1];

	self.alignSelf		= [self.style computeAlignSelf:HTML_DEFAULT_ALIGNSELF];
	self.alignItems		= [self.style computeAlignItems:HTML_DEFAULT_ALIGNITEMS];
	self.alignContent	= [self.style computeAlignContent:HTML_DEFAULT_ALIGNCONTENT];
	self.justifyContent	= [self.style computeJustifyContent:HTML_DEFAULT_JUSTIFYCONTENT];

	self.boxPack		= (CSSBoxPack_Inherit == self.boxPack) ? HTML_DEFAULT_BOXPACK : self.boxPack;
	self.boxAlign		= (CSSBoxAlign_Inherit == self.boxAlign) ? HTML_DEFAULT_BOXALIGN : self.boxAlign;
	self.boxLines		= (CSSBoxLines_Inherit == self.boxLines) ? HTML_DEFAULT_BOXLINES : self.boxLines;
	self.boxOrient		= (CSSBoxOrient_Inherit == self.boxOrient) ? HTML_DEFAULT_BOXORIENT : self.boxOrient;
	self.boxDirection	= (CSSBoxDirection_Inherit == self.boxDirection) ? HTML_DEFAULT_BOXDIRECTION : self.boxDirection;
	
	self.flexWrap		= (CSSFlexWrap_Inherit == self.flexWrap) ? HTML_DEFAULT_FLEXWRAP : self.flexWrap;
	self.flexDirection	= (CSSFlexDirection_Inherit == self.flexDirection) ? HTML_DEFAULT_FLEXDIRECTION : self.flexDirection;
	
	self.alignSelf		= (CSSAlignSelf_Inherit == self.alignSelf) ? HTML_DEFAULT_ALIGNSELF : self.alignSelf;
	self.alignItems		= (CSSAlignItems_Inherit == self.alignItems) ? HTML_DEFAULT_ALIGNITEMS : self.alignItems;
	self.alignContent	= (CSSAlignContent_Inherit == self.alignContent) ? HTML_DEFAULT_ALIGNCONTENT : self.alignContent;
	self.justifyContent	= (CSSJustifyContent_Inherit == self.justifyContent) ? HTML_DEFAULT_JUSTIFYCONTENT : self.justifyContent;

// compute view class
	
	if ( nil == self.viewClass )
	{
		Class classType = nil;
		
		classType = classType ?: NSClassFromString( [self.style.samuraiViewClass string] );
		classType = classType ?: NSClassFromString( self.dom.tag );
		classType = classType ?: [[self class] defaultViewClass];
		
		self.viewClass = classType;
	}
}

#pragma mark -

- (CGSize)computeSize:(CGSize)bounds
{
	self.layout.bounds		= bounds;
	self.layout.origin		= CGPointZero;
	self.layout.stretch		= CGSizeMake( INVALID_VALUE, INVALID_VALUE );
	self.layout.collapse	= UIEdgeInsetsZero;

	if ( [self.layout begin:YES] )
	{
		[self.layout layout];
		[self.layout finish];
	}

	return self.layout.computedBounds.size;
}

- (CGFloat)computeWidth:(CGFloat)height
{
	self.layout.bounds		= CGSizeMake( INVALID_VALUE, height );
	self.layout.origin		= CGPointZero;
	self.layout.stretch		= CGSizeMake( INVALID_VALUE, INVALID_VALUE );
	self.layout.collapse	= UIEdgeInsetsZero;

	if ( [self.layout begin:YES] )
	{
		[self.layout layout];
		[self.layout finish];
	}
	
	return self.layout.computedBounds.size.width;
}

- (CGFloat)computeHeight:(CGFloat)width
{
	self.layout.bounds		= CGSizeMake( width, INVALID_VALUE );
	self.layout.origin		= CGPointZero;
	self.layout.stretch		= CGSizeMake( INVALID_VALUE, INVALID_VALUE );
	self.layout.collapse	= UIEdgeInsetsZero;
	
	if ( [self.layout begin:YES] )
	{
		[self.layout layout];
		[self.layout finish];
	}

	return self.layout.computedBounds.size.height;
}

#pragma mark -

- (void)dump
{
	if ( DomNodeType_Text == self.dom.type )
	{
		PRINT( @"\"%@\", [%@], XY = (%.1f, %.1f), WH = (%.1f, %.1f)",
			  self.dom.text ? [self.dom.text trim] : @"", [self.viewClass description],
			  self.layout.frame.origin.x, self.layout.frame.origin.y,
			  self.layout.frame.size.width, self.layout.frame.size.height );
	}
	else
	{
		if ( self.dom.attrClass )
		{
			PRINT( @"<%@ class=\"%@\">, [%@], XY = (%.1f, %.1f), WH = (%.1f, %.1f)",
				  self.dom.tag ?: @"", self.dom.attrClass, [self.viewClass description],
				  self.layout.frame.origin.x, self.layout.frame.origin.y,
				  self.layout.frame.size.width, self.layout.frame.size.height );
		}
		else
		{
			PRINT( @"<%@>, [%@], XY = (%.1f, %.1f), WH = (%.1f, %.1f)",
				  self.dom.tag ?: @"", [self.viewClass description],
				  self.layout.frame.origin.x, self.layout.frame.origin.y,
				  self.layout.frame.size.width, self.layout.frame.size.height );
		}
		
		[[SamuraiLogger sharedInstance] indent];
		
		for ( SamuraiRenderObject * child in self.childs )
		{
			[child dump];
		}
		
		[[SamuraiLogger sharedInstance] unindent];
		
		PRINT( @"</%@>", self.dom.tag ?: @"" );
	}
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
