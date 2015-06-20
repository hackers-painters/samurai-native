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

#import "Samurai_DomNode.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_StyleSheet.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiDomNode

@def_prop_strong( NSNumber *,				id );
@def_prop_assign( DomNodeType,				type );
@def_prop_strong( NSMutableDictionary *,	attributes );

@def_prop_strong( NSString *,				domId );
@def_prop_strong( NSString *,				domTag );
@def_prop_strong( NSString *,				domText );
@def_prop_strong( NSString *,				domName );
@def_prop_strong( NSString *,				domNamespace );

@def_prop_strong( NSString *,				domStyleInline );
@def_prop_strong( NSMutableArray *,			domStyleClasses );
@def_prop_strong( NSMutableDictionary *,	domStyleComputed );

@def_prop_unsafe( SamuraiDocument *,		document );
@def_prop_unsafe( SamuraiDomNode *,			parent );
@def_prop_unsafe( SamuraiDomNode *,			prev );
@def_prop_unsafe( SamuraiDomNode *,			next );

BASE_CLASS( SamuraiDomNode )

#pragma mark -

+ (instancetype)domNode
{
	return [[self alloc] init];
}

#pragma mark -

static NSUInteger __domSeed = 0;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.id = [NSNumber numberWithUnsignedInteger:__domSeed++];
		
		self.type = DomNodeType_Unknown;
		self.attributes = [[NSMutableDictionary alloc] init];
		
		self.domStyleInline = nil;
		self.domStyleClasses = [[NSMutableArray alloc] init];
		self.domStyleComputed = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)dealloc
{
	self.id = nil;
	self.attributes = nil;

	self.domId = nil;
	self.domTag = nil;
	self.domText = nil;
	self.domName = nil;
	self.domNamespace = nil;
	
	self.domStyleInline = nil;
	self.domStyleClasses = nil;
	self.domStyleComputed = nil;

	self.document = nil;
	self.parent = nil;
	self.prev = nil;
	self.next = nil;
}

#pragma mark -

- (void)deepCopyFrom:(SamuraiDomNode *)right
{
	[super deepCopyFrom:right];

	self.type = right.type;
	self.document = right.document;
	
	self.domId = [right.domId copy];
	self.domTag = [right.domTag copy];
	self.domText = [right.domText copy];
	self.domName = [right.domName copy];
	self.domNamespace = [right.domNamespace copy];

	self.domStyleInline = right.domStyleInline;
	[self.domStyleClasses addObjectsFromArray:right.domStyleClasses];
	[self.domStyleComputed addEntriesFromDictionary:right.domStyleComputed];

	[self.attributes setDictionary:right.attributes];
}

#pragma mark -

- (void)attach:(SamuraiDocument *)document
{
	self.document = document;
	
	for ( SamuraiDomNode * child in self.childs )
	{
		[child attach:document];
	}
}

- (void)detach
{
	self.document = nil;
	
	for ( SamuraiDomNode * child in self.childs )
	{
		[child detach];
	}
}

#pragma mark -

- (NSString *)computeInnerText
{
	if ( 0 == self.childs.count )
	{
		if ( DomNodeType_Text == self.type )
		{
			return self.domText;
		}
		else
		{
			return nil;
		}
	}
	else if ( 1 == self.childs.count )
	{
		SamuraiDomNode * childNode = [self.childs firstObject];
		
		if ( DomNodeType_Text == childNode.type )
		{
			return childNode.domText;
		}
		else
		{
			return nil;
		}
	}
	else
	{
		NSMutableString * innerText = [NSMutableString string];
		
		for ( SamuraiDomNode * childNode in self.childs )
		{
			if ( DomNodeType_Text == childNode.type )
			{
				[innerText appendString:childNode.domText];
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
	if ( [self.domId isEqualToString:domId] )
	{
		[array addObject:self];
		
		if ( NSUIntegerMax != limitCount && [array count] >= limitCount )
		{
			return;
		}
	}
	
	for ( SamuraiDomNode * child in self.childs )
	{
		[child getElementsById:domId toArray:array limitCount:limitCount];
	}
}

- (void)getElementsByName:(NSString *)domName toArray:(NSMutableArray *)array limitCount:(NSUInteger)limitCount
{
	if ( [self.domName isEqualToString:domName] )
	{
		[array addObject:self];
		
		if ( NSUIntegerMax != limitCount && [array count] >= limitCount )
		{
			return;
		}
	}
	
	for ( SamuraiDomNode * child in self.childs )
	{
		[child getElementsByName:domName toArray:array limitCount:limitCount];
	}
}

- (void)getElementsByTagName:(NSString *)domTag toArray:(NSMutableArray *)array limitCount:(NSUInteger)limitCount
{
	if ( [self.domTag isEqualToString:domTag] )
	{
		[array addObject:self];
		
		if ( NSUIntegerMax != limitCount && [array count] >= limitCount )
		{
			return;
		}
	}
	
	for ( SamuraiDomNode * child in self.childs )
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

- (SamuraiDomNode *)getFirstElementById:(NSString *)domId
{
	NSMutableArray * array = [NSMutableArray array];
	
	[self getElementsById:domId toArray:array limitCount:1];
	
	return [array firstObject];
}

- (SamuraiDomNode *)getFirstElementByName:(NSString *)domName
{
	NSMutableArray * array = [NSMutableArray array];
	
	[self getElementsByName:domName toArray:array limitCount:1];
	
	return [array firstObject];
}

- (SamuraiDomNode *)getFirstElementByTagName:(NSString *)domTag
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
	if ( self.domTag )
	{
		if ( self.childs.count )
		{
			if ( self.domId && self.domId.length )
			{
				PRINT( @"<%@ id='%@'>", self.domTag, self.domId );
			}
			else
			{
				PRINT( @"<%@>", self.domTag );
			}
		}
		else
		{
			if ( self.domId && self.domId.length )
			{
				PRINT( @"<%@ id='%@'/>", self.domTag, self.domId );
			}
			else
			{
				PRINT( @"<%@/>", self.domTag );
			}
		}
	}
	else
	{
		if ( self.domText.length )
		{
			if ( self.domText.length > 32 )
			{
				PRINT( @"\"%@\" ...", [[[self.domText substringToIndex:32] trim] normalize] );
			}
			else
			{
				PRINT( @"\"%@\"", [[self.domText trim] normalize] );
			}
		}
	}
	
	[[SamuraiLogger sharedInstance] indent];
	
	for ( SamuraiDomNode * child in self.childs )
	{
		[child dump];
	}
	
	[[SamuraiLogger sharedInstance] unindent];
	
	if ( self.childs.count )
	{
		PRINT( @"</%@>", self.domTag );
	}
}


@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, DomNode )

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
