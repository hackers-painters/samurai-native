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

#import "Samurai_HtmlDomNode.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_HtmlDocument.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiHtmlDomNode

@def_prop_assign( BOOL,							implied );
@def_prop_strong( NSMutableDictionary *,		computedStyle );

@def_prop_dynamic( SamuraiHtmlDomNode *,		parent );
@def_prop_dynamic( SamuraiHtmlDomNode *,		prev );
@def_prop_dynamic( SamuraiHtmlDomNode *,		next );

@def_prop_unsafe( SamuraiHtmlDomNode *,			shadowHost );
@def_prop_strong( SamuraiHtmlDomNode *,			shadowRoot );

@def_dom_attr( attrId,				setAttrId,				@"id" );
@def_dom_attr( attrFor,				setAttrFor,				@"for" );
@def_dom_attr( attrSrc,				setAttrSrc,				@"src" );
@def_dom_attr( attrRel,				setAttrRel,				@"rel" );
@def_dom_attr( attrName,			setAttrName,			@"name" );
@def_dom_attr( attrType,			setAttrType,			@"type" );
@def_dom_attr( attrHref,			setAttrHref,			@"href" );
@def_dom_attr( attrMedia,			setAttrMedia,			@"media" );
@def_dom_attr( attrStyle,			setAttrStyle,			@"style" );
@def_dom_attr( attrClass,			setAttrClass,			@"class" );
@def_dom_attr( attrContent,			setAttrContent,			@"content" );
@def_dom_attr( attrValue,			setAttrValue,			@"value" );
@def_dom_attr( attrMin,				setAttrMin,				@"min" );
@def_dom_attr( attrMax,				setAttrMax,				@"max" );
@def_dom_attr( attrSelected,		setAttrSelected,		@"selected" );
@def_dom_attr( attrRowSpan,			setAttrRowSpan,			@"rowspan" );
@def_dom_attr( attrColSpan,			setAttrColSpan,			@"colspan" );
@def_dom_attr( attrTabindex,		setAttrTabindex,		@"tabindex" );
@def_dom_attr( attrIsLarge,			setAttrIsLarge,			@"is-large" );
@def_dom_attr( attrIsAnimating,		setAttrIsAnimating,		@"is-animating" );
@def_dom_attr( attrIsStatic,		setAttrIsStatic,		@"is-static" );
@def_dom_attr( attrColumns,			setAttrColumns,			@"columns" );
@def_dom_attr( attrIsVertical,		setAttrIsVertical,		@"is-vertical" );
@def_dom_attr( attrIsHorizontal,	setAttrIsHorizontal,	@"is-horizontal" );
@def_dom_attr( attrStickTop,		setAttrStickTop,		@"stick-top" );
@def_dom_attr( attrStickBottom,		setAttrStickBottom,		@"stick-bottom" );
@def_dom_attr( attrFixedTop,		setAttrFixedTop,		@"fixed-top" );
@def_dom_attr( attrFixedBottom,		setAttrFixedBottom,		@"fixed-bottom" );
@def_dom_attr( attrIsColumn,		setAttrIsColumn,		@"is-column" );
@def_dom_attr( attrIsRow,			setAttrIsRow,			@"is-row" );
@def_dom_attr( attrLayout,			setAttrLayout,			@"layout" );
@def_dom_attr( attrPages,			setAttrPages,			@"pages" );
@def_dom_attr( attrCurrent,			setAttrCurrent,			@"current" );
@def_dom_attr( attrIsBar,			setAttrIsBar,			@"is-bar" );
@def_dom_attr( attrIsPaging,		setAttrIsPaging,		@"is-paging" );
@def_dom_attr( attrIsContinuous,	setAttrIsContinuous,	@"is-continuous" );
@def_dom_attr( attrStep,			setAttrStep,			@"step" );
@def_dom_attr( attrIsOn,			setAttrIsOn,			@"is-on" );
@def_dom_attr( attrIsOff,			setAttrIsOff,			@"is-off" );

@def_dom_attr( attrPlaceholder,			setAttrPlaceholder,			@"placeholder" );
@def_dom_attr( attrAutoCapitalization,	setAttrAutoCapitalization,	@"auto-capitalization" );
@def_dom_attr( attrAutoCorrection,		setAttrAutoCorrection,		@"auto-correction" );
@def_dom_attr( attrAutoClears,			setAttrAutoClears,			@"auto-clears" );
@def_dom_attr( attrSpellChecking,		setAttrSpellChecking,		@"spell-checking" );
@def_dom_attr( attrKeyboardType,		setAttrKeyboardType,		@"keyboard-type" );
@def_dom_attr( attrKeyboardAppearance,	setAttrKeyboardAppearance,	@"keyboard-appearance" );
@def_dom_attr( attrReturnKeyType,		setAttrReturnKeyType,		@"return-key-type" );
@def_dom_attr( attrIsSecure,			setAttrIsSecure,			@"is-secure" );

@def_dom_attr( attrOnClick,			setAttrOnClick,			@"onclick" );
@def_dom_attr( attrOnSwipe,			setAttrOnSwipe,			@"onswipe" );
@def_dom_attr( attrOnSwipeLeft,		setAttrOnSwipeLeft,		@"onswipe-left" );
@def_dom_attr( attrOnSwipeRight,	setAttrOnSwipeRight,	@"onswipe-right" );
@def_dom_attr( attrOnSwipeUp,		setAttrOnSwipeUp,		@"onswipe-up" );
@def_dom_attr( attrOnSwipeDown,		setAttrOnSwipeDown,		@"onswipe-down" );
@def_dom_attr( attrOnPinch,			setAttrOnPinch,			@"onpinch" );
@def_dom_attr( attrOnPan,			setAttrOnPan,			@"onpan" );

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.implied = NO;
		self.computedStyle = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)dealloc
{
	self.computedStyle = nil;
	self.shadowRoot = nil;
	self.shadowHost = nil;
}

- (void)deepCopyFrom:(SamuraiHtmlDomNode *)right
{
	[super deepCopyFrom:right];

	[self.computedStyle removeAllObjects];
	[self.computedStyle addEntriesFromDictionary:right.computedStyle];
	
	self.shadowHost = nil;
	self.shadowRoot = [right.shadowRoot clone];
}

#pragma mark -

- (NSString *)cssId
{
	return self.attrId;
}

- (NSString *)cssTag
{
	return self.tag;
}

- (NSArray *)cssClasses
{
	return [self.attrClass componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSDictionary *)cssAttributes
{
	return self.attr;
}

- (NSArray *)cssPseudos
{
	return nil;
}

- (NSString *)cssShadowPseudoId
{
    return nil;
}

- (NSObject *)cssParent
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
	
	SamuraiHtmlDomNode * domNode = self.prev;
	
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
	
	SamuraiHtmlDomNode * domNode = self.next;
	
	while ( domNode )
	{
		[array addObject:domNode];
		
		domNode = domNode.next;
	}
	
	return array;
}

#pragma mark -

- (NSString *)computeInnerText
{
	if ( 0 == self.childs.count )
	{
		if ( DomNodeType_Text == self.type )
		{
			return self.text;
		}
		else
		{
			return nil;
		}
	}
	else if ( 1 == self.childs.count )
	{
		SamuraiHtmlDomNode * childNode = [self.childs firstObject];
		
		if ( DomNodeType_Text == childNode.type )
		{
			return childNode.text;
		}
		else
		{
			return nil;
		}
	}
	else
	{
		NSMutableString * innerText = [NSMutableString string];
		
		for ( SamuraiHtmlDomNode * childNode in self.childs )
		{
			if ( DomNodeType_Text == childNode.type )
			{
				[innerText appendString:childNode.text];
			}
		}
		
		return innerText;
	}
}

- (NSString *)computeOuterText
{
	return [self computeInnerText];
}

#pragma mark -

- (void)getElementsById:(NSString *)domId toArray:(NSMutableArray *)array limitCount:(NSUInteger)limitCount
{
	if ( [self.attrId isEqualToString:domId] )
	{
		[array addObject:self];
		
		if ( NSUIntegerMax != limitCount && [array count] >= limitCount )
		{
			return;
		}
	}
	
	for ( SamuraiHtmlDomNode * child in self.childs )
	{
		[child getElementsById:domId toArray:array limitCount:limitCount];
	}
}

- (void)getElementsByName:(NSString *)domName toArray:(NSMutableArray *)array limitCount:(NSUInteger)limitCount
{
	if ( [self.attrName isEqualToString:domName] )
	{
		[array addObject:self];
		
		if ( NSUIntegerMax != limitCount && [array count] >= limitCount )
		{
			return;
		}
	}
	
	for ( SamuraiHtmlDomNode * child in self.childs )
	{
		[child getElementsByName:domName toArray:array limitCount:limitCount];
	}
}

- (void)getElementsByTagName:(NSString *)domTag toArray:(NSMutableArray *)array limitCount:(NSUInteger)limitCount
{
	if ( [self.tag isEqualToString:domTag] )
	{
		[array addObject:self];
		
		if ( NSUIntegerMax != limitCount && [array count] >= limitCount )
		{
			return;
		}
	}
	
	for ( SamuraiHtmlDomNode * child in self.childs )
	{
		[child getElementsByTagName:domTag toArray:array limitCount:limitCount];
	}
}

#pragma mark -

- (NSArray *)getElementsById:(NSString *)domId
{
	NSMutableArray * array = [NSMutableArray array];
	
	[self getElementsById:domId toArray:array limitCount:NSUIntegerMax];
	
	return array;
}

- (NSArray *)getElementsByName:(NSString *)domName
{
	NSMutableArray * array = [NSMutableArray array];
	
	[self getElementsByName:domName toArray:array limitCount:NSUIntegerMax];
	
	return array;
}

- (NSArray *)getElementsByTagName:(NSString *)domTag
{
	NSMutableArray * array = [NSMutableArray array];
	
	[self getElementsByTagName:domTag toArray:array limitCount:NSUIntegerMax];
	
	return array;
}

- (SamuraiHtmlDomNode *)getFirstElementById:(NSString *)domId
{
	NSMutableArray * array = [NSMutableArray array];
	
	[self getElementsById:domId toArray:array limitCount:1];
	
	return [array firstObject];
}

- (SamuraiHtmlDomNode *)getFirstElementByName:(NSString *)domName
{
	NSMutableArray * array = [NSMutableArray array];
	
	[self getElementsByName:domName toArray:array limitCount:1];
	
	return [array firstObject];
}

- (SamuraiHtmlDomNode *)getFirstElementByTagName:(NSString *)domTag
{
	NSMutableArray * array = [NSMutableArray array];
	
	[self getElementsByTagName:domTag toArray:array limitCount:1];
	
	return [array firstObject];
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
	if ( self.tag )
	{
		if ( self.childs.count )
		{
			if ( self.attrId && self.attrId.length )
			{
				PRINT( @"<%@ id='%@'>", self.tag, self.attrId );
			}
			else
			{
				PRINT( @"<%@>", self.tag );
			}
		}
		else
		{
			if ( self.attrId && self.attrId.length )
			{
				PRINT( @"<%@ id='%@'/>", self.tag, self.attrId );
			}
			else
			{
				PRINT( @"<%@/>", self.tag );
			}
		}
	}
	else
	{
		if ( self.text.length )
		{
			if ( self.text.length > 32 )
			{
				PRINT( @"\"%@\" ...", [[[self.text substringToIndex:32] trim] normalize] );
			}
			else
			{
				PRINT( @"\"%@\"", [[self.text trim] normalize] );
			}
		}
	}
	
	[[SamuraiLogger sharedInstance] indent];
	
	for ( SamuraiHtmlDomNode * child in self.childs )
	{
		[child dump];
	}
	
	[[SamuraiLogger sharedInstance] unindent];
	
	if ( self.childs.count )
	{
		PRINT( @"</%@>", self.tag );
	}
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlDomNode )

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
