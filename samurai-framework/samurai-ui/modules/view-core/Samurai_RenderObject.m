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

#import "Samurai_RenderObject.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_EventInput.h"
#import "Samurai_EventPanGesture.h"
#import "Samurai_EventPinchGesture.h"
#import "Samurai_EventSwipeGesture.h"
#import "Samurai_EventTapGesture.h"

#import "Samurai_DomNode.h"

#import "Samurai_RenderObject.h"
#import "Samurai_RenderStyle.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSObject(Renderer)

@def_prop_dynamic_strong( SamuraiRenderObject *, renderer, setRenderer );

+ (id)createInstanceWithRenderer:(SamuraiRenderObject *)renderer
{
	return nil;
}

+ (id)createInstanceWithRenderer:(SamuraiRenderObject *)renderer identifier:(NSString *)identifier
{
	return nil;
}

- (void)prepareForRendering
{
}

- (CGSize)computeSizeBySize:(CGSize)size
{
	return CGSizeZero;
}

- (CGSize)computeSizeByWidth:(CGFloat)width
{
	return CGSizeZero;
}

- (CGSize)computeSizeByHeight:(CGFloat)height
{
	return CGSizeZero;
}

- (void)applyDom:(SamuraiDomNode *)dom
{	
}

- (void)applyStyle:(SamuraiRenderStyle *)style
{
}

- (void)applyFrame:(CGRect)frame
{
}

@end

#pragma mark -

@implementation SamuraiRenderObject

@def_prop_strong( NSNumber *,				id );
@def_prop_unsafe( SamuraiDomNode *,			dom );
@def_prop_strong( SamuraiRenderStyle *,		style );

@def_prop_assign( NSInteger,				index );
@def_prop_assign( CGRect,					bounds );
@def_prop_assign( NSUInteger,				lines );
@def_prop_assign( CGPoint,					start );
@def_prop_assign( CGPoint,					end );

@def_prop_assign( UIEdgeInsets,				inset );
@def_prop_assign( UIEdgeInsets,				border );
@def_prop_assign( UIEdgeInsets,				margin );
@def_prop_assign( UIEdgeInsets,				padding );

@def_prop_strong( UIView *,					view );
@def_prop_strong( Class,					viewClass );

BASE_CLASS( SamuraiRenderObject )

static NSUInteger __objectSeed = 0;

#pragma mark -

+ (Class)defaultViewClass
{
	return nil;
}

+ (instancetype)renderObject
{
	return [[self alloc] init];
}

+ (instancetype)renderObjectWithDom:(SamuraiDomNode *)dom andStyle:(SamuraiRenderStyle *)style
{
	SamuraiRenderObject * renderObject = [[self alloc] init];
	
	[renderObject bindDom:dom];
	[renderObject bindStyle:style];

	return renderObject;
}

#pragma mark -

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.id = [NSNumber numberWithUnsignedInteger:__objectSeed++];

//		self.dom = nil;
//		self.style = nil;
//		self.viewClass = nil; // [[self class] defaultViewClass];

		self.index = 0;
		self.bounds = CGRectZero;

		self.inset = UIEdgeInsetsZero;
		self.margin = UIEdgeInsetsZero;
		self.padding = UIEdgeInsetsZero;
		self.border = UIEdgeInsetsZero;
	}
	return self;
}

- (void)dealloc
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];

	self.viewClass = nil;
	self.view = nil;
	
	self.style = nil;
	self.dom = nil;
	self.id = nil;
}

#pragma mark -

- (void)deepCopyFrom:(SamuraiRenderObject *)right
{
	[super deepCopyFrom:right];
	
	[self bindDom:right.dom];
	[self bindStyle:[right.style clone]];

	self.viewClass = right.viewClass;
}

#pragma mark -

- (void)bindOutletsTo:(NSObject *)container
{
	[self bindOutlets:self toContainer:container];
}

- (void)bindOutlets:(SamuraiRenderObject *)source toContainer:(NSObject *)container
{
	if ( nil == source )
		return;
	
	if ( source.dom.domId && source.dom.domId.length )
	{
		NSString * ivarName = source.dom.domId;
		NSString * ivarName2 = [NSString stringWithFormat:@"_%@", source.dom.domId];
		NSString * propName = source.dom.domId;
	
		[self assignValue:source.view toObject:container forProperty:ivarName];
		[self assignValue:source.view toObject:container forProperty:ivarName2];
		[self assignValue:source.view toObject:container forProperty:propName];
	}
	else
	{
		for ( SamuraiRenderObject * childRender in source.childs )
		{
			[self bindOutlets:childRender toContainer:container];
		}
	}
}

- (void)unbindOutletsFrom:(NSObject *)container
{
	[self unbindOutlets:self fromContainer:container];
}

- (void)unbindOutlets:(SamuraiRenderObject *)source fromContainer:(NSObject *)container
{
	if ( source.dom.domId && source.dom.domId.length )
	{
		NSString * ivarName = [NSString stringWithFormat:@"_%@", source.dom.domId];
		NSString * propName = source.dom.domId;
		
		[self assignValue:nil toObject:container forProperty:ivarName];
		[self assignValue:nil toObject:container forProperty:propName];
	}
	else
	{
		for ( SamuraiRenderObject * childRender in source.childs )
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

- (SamuraiRenderObject *)queryById:(NSString *)domId
{
	if ( nil == domId )
	{
		return nil;
	}

	if ( [self.dom.domId isEqualToString:domId] )
	{
		return self;
	}
	
	for ( SamuraiRenderObject * childRender in self.childs )
	{
		SamuraiRenderObject * result = [childRender queryById:domId];
		
		if ( result )
		{
			return result;
		}
	}
	
	return nil;
}

- (SamuraiRenderObject *)queryByDom:(SamuraiDomNode *)domNode
{
	if ( nil == domNode )
	{
		return nil;
	}

	if ( self.dom == domNode )
	{
		return self;
	}
	
	for ( SamuraiRenderObject * childRender in self.childs )
	{
		SamuraiRenderObject * result = [childRender queryByDom:domNode];
		
		if ( result )
		{
			return result;
		}
	}
	
	return nil;
}

- (SamuraiRenderObject *)queryByName:(NSString *)name
{
	if ( nil == name )
	{
		return nil;
	}
	
	if ( [self.dom.domName isEqualToString:name] )
	{
		return self;
	}
	
	for ( SamuraiRenderObject * childRender in self.childs )
	{
		SamuraiRenderObject * result = [childRender queryByName:name];
		
		if ( result )
		{
			return result;
		}
	}
	
	return nil;
}

- (SamuraiRenderObject *)prevObject
{
	return [self.root findObjectWithTabIndex:(self.index - 1) exclude:self];
}

- (SamuraiRenderObject *)nextObject
{
	return [self.root findObjectWithTabIndex:(self.index + 1) exclude:self];
}

- (SamuraiRenderObject *)findObjectWithTabIndex:(NSInteger)tabIndex exclude:(SamuraiRenderObject *)sourceObject
{
	if ( self != sourceObject )
	{
		if ( self.index == tabIndex )
		{
			return self;
		}
	}

	for ( SamuraiRenderObject * childRender in self.childs )
	{
		SamuraiRenderObject * result = [childRender findObjectWithTabIndex:tabIndex exclude:sourceObject];

		if ( result )
		{
			return result;
		}
	}

	return nil;
}

#pragma mark -

- (CGSize)computeSize:(CGSize)bound
{
	return CGSizeZero;
}

- (CGFloat)computeWidth:(CGFloat)height
{
	return [self computeSize:CGSizeMake( INVALID_VALUE, height )].width;
}

- (CGFloat)computeHeight:(CGFloat)width
{
	return [self computeSize:CGSizeMake( width, INVALID_VALUE )].width;
}

#pragma mark -

- (void)relayout
{
}

- (void)restyle
{
}

- (void)rechain
{
}

#pragma mark -

- (UIView *)createViewWithIdentifier:(NSString *)identifier
{
//	if ( nil == self.dom )
//		return nil;
	
	if ( nil == self.viewClass )
		return nil;

	self.view = [self.viewClass createInstanceWithRenderer:self identifier:identifier];

	if ( self.view )
	{
		self.view.renderer = self;

		UIView * contentView = nil;

		if ( [self.view respondsToSelector:@selector(contentView)] )
		{
			contentView = [self.view performSelector:@selector(contentView) withObject:nil];
		}
		else
		{
			contentView = self.view;
		}
		
		for ( SamuraiRenderObject * child in self.childs )
		{
			if ( nil == child.view )
			{
				UIView * childView = [child createViewWithIdentifier:nil];
				
				if ( childView )
				{
					[contentView addSubview:childView];
				}

			//	[child bindOutletsTo:self.view];
			}
		}

		self.view.exclusiveTouch = YES;
		self.view.multipleTouchEnabled = YES;
		
		[self.view prepareForRendering];
	}

	return self.view;
}

- (void)bindView:(UIView *)view
{
	if ( nil == view )
	{
		[self unbindView];
	}
	else
	{
		self.view = view;
		self.viewClass = [view class];
		
		if ( self.view )
		{
			self.view.renderer = self;
			
			if ( self.dom.domTag )
			{
				PERF( @"RenderObject '%p', bind view '%@ %p' for <%@/>", self, self.viewClass, self.view, self.dom.domTag );
			}
			else
			{
				PERF( @"RenderObject '%p', bind view '%@ %p' for \"%@ ...\"", self, self.viewClass, self.view, self.dom.domText.length > 20 ? [self.dom.domText substringToIndex:20] : self.dom.domText );
			}
			
			UIView * contentView = nil;
			
			if ( [self.view respondsToSelector:@selector(contentView)] )
			{
				contentView = [self.view performSelector:@selector(contentView) withObject:nil];
			}
			else
			{
				contentView = self.view;
			}
			
			for ( SamuraiRenderObject * child in self.childs )
			{
				if ( nil == child.view )
				{
					UIView * childView = [child createViewWithIdentifier:nil];
					
					if ( childView )
					{
						[contentView addSubview:childView];
					}
					
//					[child bindOutletsTo:self.view];
				}
			}
			
			[self.view prepareForRendering];
		}
	}
}

- (void)unbindView
{
	self.view = nil;
}

- (void)bindDom:(SamuraiDomNode *)newDom
{
	self.dom = newDom;
}

- (void)unbindDom
{
	self.dom = nil;
}

- (void)bindStyle:(SamuraiRenderStyle *)newStyle
{
	self.style = newStyle;
}

- (void)unbindStyle
{
	self.style = nil;
}

#pragma mark -

- (id)serialize
{
	return nil;
}

- (void)unserialize:(id)obj
{
	UNUSED( obj );
}

- (void)zerolize
{
}

#pragma mark -

- (NSString *)description
{
	[[SamuraiLogger sharedInstance] outputCapture];
	
	[self dump];
	
	[[SamuraiLogger sharedInstance] outputRelease];
	
	return [SamuraiLogger sharedInstance].output;
}

- (void)dump
{
	if ( DomNodeType_Text == self.dom.type )
	{
		PRINT( @"\"%@ ...\", [%@], XY = (%.1f, %.1f), WH = (%.1f, %.1f)",
			 (self.dom.domText.length > 20 ? [self.dom.domText substringToIndex:20] : self.dom.domText),
			 [self.viewClass description],
			 self.bounds.origin.x, self.bounds.origin.y,
			 self.bounds.size.width, self.bounds.size.height );
	}
	else
	{
		PRINT( @"<%@>, [%@], XY = (%.1f, %.1f), WH = (%.1f, %.1f)",
			  self.dom.domTag ?: @"",
			  [self.viewClass description],
			  self.bounds.origin.x, self.bounds.origin.y,
			  self.bounds.size.width, self.bounds.size.height );
		
		[[SamuraiLogger sharedInstance] indent];
		
		for ( SamuraiRenderObject * child in self.childs )
		{
			[child dump];
		}
		
		[[SamuraiLogger sharedInstance] unindent];
		
		PRINT( @"</%@>", self.dom.domTag ?: @"" );
	}
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, RenderObject )

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
