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

#import "Samurai_HtmlRenderQuery.h"
#import "Samurai_HtmlRenderObject.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiHtmlRenderQuery

@def_prop_strong( NSMutableArray *,					input );
@def_prop_strong( NSMutableArray *,					output );

@def_prop_readonly( NSArray *,						views );
@def_prop_readonly( UIView *,						lastView );
@def_prop_readonly( UIView *,						firstView );

@def_prop_dynamic( SamuraiHtmlRenderQueryBlockN,	ATTR );
@def_prop_dynamic( SamuraiHtmlRenderQueryBlockN,	SET_CLASS );
@def_prop_dynamic( SamuraiHtmlRenderQueryBlockN,	ADD_CLASS );
@def_prop_dynamic( SamuraiHtmlRenderQueryBlockN,	REMOVE_CLASS );
@def_prop_dynamic( SamuraiHtmlRenderQueryBlockN,	TOGGLE_CLASS );

+ (SamuraiHtmlRenderQuery *)renderQuery
{
	return [[self alloc] init];
}

+ (SamuraiHtmlRenderQuery *)renderQuery:(NSArray *)array
{
	SamuraiHtmlRenderQuery * query = [[self alloc] init];
	[query.input addObjectsFromArray:array];
	return query;
}

#pragma mark -

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.input = [NSMutableArray nonRetainingArray];
		self.output = [NSMutableArray nonRetainingArray];
	}
	return self;
}

- (void)dealloc
{
	self.input = nil;
	self.output = nil;
}

#pragma mark -

- (BOOL)renderer:(SamuraiHtmlRenderObject *)source matchById:(NSString *)idString
{
	if ( nil == idString || 0 == idString.length )
		return NO;
	
	if ( source.dom.attrId )
	{
		if ( [source.dom.attrId isEqualToString:idString] )
		{
			return YES;
		}
	}
	
	return NO;
}

- (BOOL)renderer:(SamuraiHtmlRenderObject *)source matchByClass:(NSString *)classString
{
	if ( nil == classString || 0 == classString.length )
		return NO;
	
	if ( source.dom.attrClass )
	{
		NSArray * classes = [source.dom.attrClass componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		for ( NSString * styleClass in classes )
		{
			if ( [styleClass isEqualToString:classString] )
			{
				return YES;
			}
		}
	}
	
	return NO;
}

- (BOOL)renderer:(SamuraiHtmlRenderObject *)source matchByTag:(NSString *)tagString
{
	if ( nil == tagString || 0 == tagString.length )
		return NO;
	
	if ( source.dom.tag )
	{
		if ( [source.dom.tag isEqualToString:tagString] )
		{
			return YES;
		}
	}
	
	return NO;
}

- (BOOL)renderer:(SamuraiHtmlRenderObject *)source matchByPaths:(NSArray *)paths
{
	if ( 0 == paths.count )
		return NO;
	
	NSUInteger index = 0;
	
	for ( SamuraiHtmlRenderObject *	render = source; render; render = (id)render.parent )
	{
		BOOL		matched = NO;
		NSString *	condition = [paths objectAtIndex:(paths.count - index - 1)];
		
		if ( [condition isEqualToString:@"*"] )
		{
			matched = YES;
		}
		else if ( [condition hasPrefix:@"#"] )
		{
			matched = [self renderer:source matchById:[condition substringFromIndex:1]];
		}
		else if ( [condition hasPrefix:@"."] )
		{
			matched = [self renderer:source matchByClass:[condition substringFromIndex:1]];
		}
		else
		{
			matched = [self renderer:source matchByTag:condition];
		}
		
		if ( matched && index == 0 )
			return YES;
		
		index += 1;
	}
	
	return NO;
}

#pragma mark -

- (void)renderer:(SamuraiHtmlRenderObject *)source queryById:(NSString *)condition
{
	if ( [self renderer:source matchById:condition] )
	{
		[self.output addObject:source];
	}
	
	for ( SamuraiHtmlRenderObject * child in source.childs )
	{
		[self renderer:child queryById:condition];
	}
}

- (void)renderer:(SamuraiHtmlRenderObject *)source queryByClass:(NSString *)classString
{
	if ( [self renderer:source matchByClass:classString] )
	{
		[self.output addObject:source];
	}
	
	for ( SamuraiHtmlRenderObject * child in source.childs )
	{
		[self renderer:child queryByClass:classString];
	}
}

- (void)renderer:(SamuraiHtmlRenderObject *)source queryByTag:(NSString *)tagString
{
	if ( [self renderer:source matchByTag:tagString] )
	{
		[self.output addObject:source];
	}
	
	for ( SamuraiHtmlRenderObject * child in source.childs )
	{
		[self renderer:child queryByTag:tagString];
	}
}

- (void)renderer:(SamuraiHtmlRenderObject *)source queryByPaths:(NSArray *)paths
{
	if ( [self renderer:source matchByPaths:paths] )
	{
		[self.output addObject:source];
	}
	
	for ( SamuraiHtmlRenderObject * child in source.childs )
	{
		[self renderer:child queryByPaths:paths];
	}
}

- (void)renderer:(SamuraiHtmlRenderObject *)source query:(NSString *)text
{
	NSArray * components = [text componentsSeparatedByString:@","];
	
	for ( NSString * component in components )
	{
		NSString * condition = [component trim];
		if ( nil == condition || 0 == condition.length )
			continue;
		
		if ( NSNotFound != [condition rangeOfString:@">"].location )
		{
			[self renderer:source queryByPaths:[condition componentsSeparatedByString:@">"]];
		}
		else
		{
			if ( [condition isEqualToString:@"*"] )
			{
				[self.output addObjectsFromArray:self.input];
			}
			else if ( [condition hasPrefix:@"#"] )
			{
				[self renderer:source queryById:[condition substringFromIndex:1]];
			}
			else if ( [condition hasPrefix:@"."] )
			{
				[self renderer:source queryByClass:[condition substringFromIndex:1]];
			}
			else
			{
				[self renderer:source queryByTag:condition];
			}
		}
	}
}

#pragma mark -

- (void)input:(SamuraiHtmlRenderObject *)object
{
	if ( nil == object )
		return;
	
	ASSERT( [object isKindOfClass:[SamuraiHtmlRenderObject class]] );
	
	[self.input addObject:object];
}

- (void)output:(SamuraiHtmlRenderObject *)object
{
	if ( nil == object )
		return;

	ASSERT( [object isKindOfClass:[SamuraiHtmlRenderObject class]] );

	[self.output addObject:object];
}

- (void)execute:(NSString *)condition
{
	if ( nil == condition )
	{
		[self.output addObjectsFromArray:self.input];
	}
	else
	{
		for ( SamuraiHtmlRenderObject * renderer in self.input )
		{
			[self renderer:renderer query:condition];
		}
	}
}

#pragma mark -

- (NSArray *)views
{
	NSMutableArray * array = [NSMutableArray nonRetainingArray];
	
	for ( SamuraiHtmlRenderObject * renderObject in self.output )
	{
		[array addObject:renderObject.view];
	}
	
	return array;
}

- (UIView *)lastView
{
	return [[self.output lastObject] view];
}

- (UIView *)firstView
{
	return [[self.output firstObject] view];
}

#pragma mark -

- (NSUInteger)count
{
	return [self.output count];
}

- (id)objectAtIndex:(NSUInteger)index
{
	return [[self.output safeObjectAtIndex:index] view];
}

#pragma mark -

- (SamuraiHtmlRenderQueryBlockN)ATTR
{
	@weakify( self )
	
	SamuraiHtmlRenderQueryBlockN block = (SamuraiHtmlRenderQueryBlockN)^ SamuraiHtmlRenderQuery * ( NSString * key, NSString * value )
	{
		@strongify( self )
		
		if ( key && value )
		{
			for ( SamuraiHtmlRenderObject * renderObject in self.output )
			{
				[renderObject.customStyle setObject:value forKey:key];
				
				[renderObject restyle];
			}
		}
		
		return self;
	};
	
	return [block copy];
}

- (SamuraiHtmlRenderQueryBlockN)SET_CLASS
{
	@weakify( self )
	
	SamuraiHtmlRenderQueryBlockN block = (SamuraiHtmlRenderQueryBlockN)^ SamuraiHtmlRenderQuery * ( NSString * string )
	{
		@strongify( self )
		
		NSArray * classes = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		if ( classes && [classes count] )
		{
			for ( SamuraiHtmlRenderObject * renderObject in self.output )
			{
				[renderObject.customClasses removeAllObjects];
				[renderObject.customClasses addObjectsFromArray:classes];
				
				[renderObject restyle];
			}
		}
		
		return self;
	};
	
	return [block copy];
}

- (SamuraiHtmlRenderQueryBlockN)ADD_CLASS
{
	@weakify( self )
	
	SamuraiHtmlRenderQueryBlockN block = (SamuraiHtmlRenderQueryBlockN)^ SamuraiHtmlRenderQuery * ( NSString * string )
	{
		@strongify( self )
		
		NSArray * classes = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		if ( classes && [classes count] )
		{
			for ( SamuraiHtmlRenderObject * renderObject in self.output )
			{
				[renderObject.customClasses addObjectsFromArray:classes];
				
				[renderObject restyle];
			}
		}
		
		return self;
	};
	
	return [block copy];
}

- (SamuraiHtmlRenderQueryBlockN)REMOVE_CLASS
{
	@weakify( self )
	
	SamuraiHtmlRenderQueryBlockN block = (SamuraiHtmlRenderQueryBlockN)^ SamuraiHtmlRenderQuery * ( NSString * string )
	{
		@strongify( self )
		
		NSArray * classes = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		if ( classes && [classes count] )
		{
			for ( SamuraiHtmlRenderObject * renderObject in self.output )
			{
				[renderObject.customClasses removeObjectsInArray:classes];
				
				[renderObject restyle];
			}
		}
		
		return self;
	};
	
	return [block copy];
}

- (SamuraiHtmlRenderQueryBlockN)TOGGLE_CLASS
{
	@weakify( self )
	
	SamuraiHtmlRenderQueryBlockN block = (SamuraiHtmlRenderQueryBlockN)^ SamuraiHtmlRenderQuery * ( NSString * string )
	{
		@strongify( self )
		
		NSArray * classes = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		if ( classes && [classes count] )
		{
			for ( SamuraiHtmlRenderObject * renderObject in self.output )
			{
				for ( NSString * class in classes )
				{
					if ( NO == [renderObject.customClasses containsObject:class] )
					{
						[renderObject.customClasses addObject:class];
					}
					else
					{
						[renderObject.customClasses removeObject:class];
					}
				}
				
				[renderObject restyle];
			}
		}
		
		return self;
	};
	
	return [block copy];
}

@end

#pragma mark -

SamuraiHtmlRenderQueryBlockN __dollar( id context )
{
	SamuraiHtmlRenderQueryBlockN resultBlock = ^ SamuraiHtmlRenderQuery * ( id first, ... )
	{
		SamuraiHtmlRenderQuery * queryContext = [SamuraiHtmlRenderQuery renderQuery];

		UIView *	container = nil;
		NSString *	condition = nil;
		
		if ( [first isKindOfClass:[UIView class]] )
		{
			container = first;
		}
		else if ( [first isKindOfClass:[UIViewController class]] )
		{
			UIViewController * controller = (UIViewController *)context;

			if ( controller && [controller isViewLoaded] )
			{
				container = [controller view];
			}
		}
		else if ( [first isKindOfClass:[NSString class]] )
		{
			condition = (NSString *)first;

			if ( [context isKindOfClass:[UIView class]] )
			{
				container = context;
			}
			else if ( [context isKindOfClass:[UIViewController class]] )
			{
				UIViewController * controller = (UIViewController *)context;

				if ( controller && [controller isViewLoaded] )
				{
					container = [controller view];
				}
			}
			else
			{
				ASSERT( 0 );
			}
		}

		[queryContext input:(SamuraiHtmlRenderObject *)[container renderer]];
		[queryContext execute:condition];

		return queryContext;
	};

	return [resultBlock copy];
}

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlRenderQuery )

DESCRIBE( before )
{
}

DESCRIBE( after )
{
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
