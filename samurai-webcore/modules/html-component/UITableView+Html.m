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

#import "UITableView+Html.h"
#import "UITableViewCell+Html.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#import "Samurai_HtmlDocument.h"
#import "Samurai_HtmlRenderStyle.h"
#import "Samurai_HtmlRenderObject.h"
#import "Samurai_HtmlRenderStoreScope.h"

#pragma mark -

@interface __HtmlTableViewSection : SamuraiUITableViewSection

@prop_assign( NSUInteger,					index );
@prop_strong( SamuraiHtmlDocument *,		document );
@prop_assign( CGFloat,						rowHeight );
@prop_unsafe( UITableView *,				tableView );
@prop_strong( NSString *,					reuseIdentifier );

@prop_strong( NSObject *,					cachedData );
@prop_strong( NSMutableDictionary *,		cachedHeight );

- (BOOL)parseDocument:(SamuraiHtmlDocument *)document;

@end

#pragma mark -

@implementation __HtmlTableViewSection

@def_prop_assign( NSUInteger,				index );
@def_prop_strong( SamuraiHtmlDocument *,	document );
@def_prop_assign( CGFloat,					rowHeight );
@def_prop_unsafe( UITableView *,			tableView );
@def_prop_strong( NSString *,				reuseIdentifier );

@def_prop_strong( NSObject *,				cachedData );
@def_prop_strong( NSMutableDictionary *,	cachedHeight );

#pragma mark -

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.rowHeight = INVALID_VALUE;
		self.cachedHeight = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)dealloc
{
	self.cachedHeight = nil;
	self.cachedData = nil;
	self.tableView = nil;
	self.document = nil;
}

#pragma mark -

- (BOOL)parseDocument:(SamuraiHtmlDocument *)document
{
	BOOL parseSucceed = [document parse];
	if ( NO == parseSucceed )
	{
		ERROR( @"Failed to parse table section" );
		return NO;
	}
	
	BOOL reflowSucceed = [document reflow];
	if ( NO == reflowSucceed )
	{
		ERROR( @"Failed to reflow table section" );
		return NO;
	}

	if ( [UITableViewCell class] != document.renderTree.viewClass && NO == [document.renderTree.viewClass isSubclassOfClass:[UITableViewCell class]] )
	{
		ERROR( @"Invalid table cell class" );
		return NO;
	}
	
	self.document = document;
	self.reuseIdentifier = [NSString stringWithFormat:@"%@-%@", document.domTree.tag, document.renderTree.id];
	
	SamuraiCSSValue * rowHeight = document.renderTree.style.height;
	
	if ( rowHeight && [rowHeight isAbsolute] )
	{
		self.rowHeight = [rowHeight computeValue:0];
	}
	
	return YES;
}

#pragma mark -

- (NSUInteger)getRowCount
{
	if ( nil == self.document || nil == self.document.domTree || nil == self.document.renderTree )
	{
		return 0;
	}
	
	if ( nil == self.cachedData )
	{
		return 0;
	}
	
	if ( [self.cachedData isKindOfClass:[NSArray class]] || [self.cachedData conformsToProtocol:@protocol(NSArrayProtocol)] )
	{
		return [(NSArray *)self.cachedData count];
	}
	else
	{
		return 0; // 1;
	}
}

- (CGFloat)getHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ( CGRectEqualToRect( self.tableView.frame, CGRectZero ) )
	{
		return 0.0f;
	}
	
	ASSERT( indexPath );
	
//	if ( INVALID_VALUE != self.rowHeight )
//	{
//		return self.rowHeight;
//	}
	
	NSString * cachedKey = [NSString stringWithFormat:@"%ld-%ld", (long)indexPath.section, (long)indexPath.row];
	NSNumber * cachedHeight = [self.cachedHeight objectForKey:cachedKey];
	
	if ( cachedHeight )
	{
		return cachedHeight.floatValue;
	}
	
// alloc cell
	
	UITableViewCell * tableViewCell = (UITableViewCell *)self.document.renderTree.view;
	
	if ( nil == tableViewCell )
	{
		tableViewCell = (UITableViewCell *)[self.document.renderTree createViewWithIdentifier:nil];
	}
	
	ASSERT( nil != tableViewCell )

	[tableViewCell.renderer bindView:tableViewCell];
	[tableViewCell.renderer bindOutletsTo:tableViewCell];
	[tableViewCell.renderer restyle];
	[tableViewCell.renderer rechain];

// update data
	
	NSObject * data = [self getDataForRowAtIndexPath:indexPath];

	if ( data )
	{
		[tableViewCell store_unserialize:data];
	}
//	else
//	{
//		[tableViewCell store_zerolize];
//	}
	
// compute height
	
	CGFloat cellHeight = [tableViewCell.renderer computeHeight:self.tableView.frame.size.width];
	
	if ( INVALID_VALUE == cellHeight )
	{
		cellHeight = self.tableView.rowHeight;
	}
	
	[self.cachedHeight setObject:@(cellHeight) forKey:cachedKey];
	
	return cellHeight;
}

- (NSObject *)getDataForRowAtIndexPath:(NSIndexPath *)indexPath
{
	ASSERT( indexPath );
	
	NSObject * reuseData = nil;
	
	if ( self.cachedData )
	{
		if ( [self.cachedData isKindOfClass:[NSArray class]] || [self.cachedData conformsToProtocol:@protocol(NSArrayProtocol)] )
		{
			if ( indexPath.row < [(NSArray *)self.cachedData count] )
			{
				reuseData = [(NSArray *)self.cachedData objectAtIndex:indexPath.row];
			}
		}
		else
		{
			reuseData = self.cachedData;
		}
	}
	
	return reuseData;
}

- (UITableViewCell *)getCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	ASSERT( indexPath );
	
// alloc cell
	
	UITableViewCell * tableViewCell = [self.tableView dequeueReusableCellWithIdentifier:self.reuseIdentifier];
	
	if ( nil == tableViewCell )
	{
		PERF( @"UITableView '%p', creating cell '%@' for row #%d", self, self.reuseIdentifier, indexPath.row );
		
		SamuraiHtmlRenderObject * reuseRenderer = [self.document.renderTree clone];
		
		ASSERT( nil != reuseRenderer );
		
		tableViewCell = (UITableViewCell *)[reuseRenderer createViewWithIdentifier:self.reuseIdentifier];
		
		ASSERT( nil != tableViewCell )

		[self.tableView.renderer appendNode:reuseRenderer];
	}
	else
	{
		PERF( @"UITableView '%p', reusing cell '%@' for row #%d", self, self.reuseIdentifier, indexPath.row );
	}

	[tableViewCell.renderer bindView:tableViewCell];
	[tableViewCell.renderer bindOutletsTo:tableViewCell];
	[tableViewCell.renderer restyle];
	[tableViewCell.renderer rechain];

// update data

	NSObject * data = [self getDataForRowAtIndexPath:indexPath];
	
	if ( data )
	{
		[tableViewCell store_unserialize:data];
	}
//	else
//	{
//		[tableViewCell store_zerolize];
//	}

	return tableViewCell;
}

#pragma mark -

- (id)store_serialize
{
	return self.cachedData;
}

- (void)store_unserialize:(id)obj
{
	[self.cachedHeight removeAllObjects];
	
	self.cachedData = obj;
}

- (void)store_zerolize
{
	[self.cachedHeight removeAllObjects];
	
	self.cachedData = nil;
}

@end

#pragma mark -

@implementation UITableView(Html)

+ (CSSViewHierarchy)style_viewHierarchy
{
	return CSSViewHierarchy_Leaf;
}

#pragma mark -

- (void)html_applyDom:(SamuraiHtmlDomNode *)dom
{
	[super html_applyDom:dom];

	[self html_parseSections:dom];
}

- (void)html_applyStyle:(SamuraiHtmlRenderStyle *)style
{
	[super html_applyStyle:style];

//	self.allowsSelection = NO;
//	self.allowsSelectionDuringEditing = NO;
//	self.allowsMultipleSelection = NO;
//	self.allowsMultipleSelectionDuringEditing = NO;
	self.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)html_applyFrame:(CGRect)newFrame
{
	[super html_applyFrame:newFrame];
}

#pragma mark -

- (void)html_parseSections:(SamuraiHtmlDomNode *)rootDom
{
	SamuraiUITableViewAgent * agent = [self tableViewAgent];
	if ( agent )
	{
		[agent removeAllSections];
		
		for ( SamuraiHtmlDomNode * childDom in rootDom.childs )
		{
			if ( DomNodeType_Document == childDom.type || DomNodeType_Element == childDom.type )
			{
				SamuraiHtmlDocument * childDocument = (SamuraiHtmlDocument *)[rootDom.document childDocument:childDom];
				if ( nil == childDocument )
					continue;

				__HtmlTableViewSection * section = [[__HtmlTableViewSection alloc] init];
				
				section.index = [agent.sections count];
				section.tableView = self;

				BOOL parseSucceed = [section parseDocument:childDocument];
				if ( parseSucceed )
				{
					[agent appendSection:section];
				}
			}
		}
	}
}

#pragma mark -

- (id)store_serialize
{
	id data = [super store_serialize];
	if ( nil != data )
		return data;

	SamuraiUITableViewAgent * agent = [self tableViewAgent];
	if ( agent )
	{
//		if ( 1 == [agent.sections count] )
//		{
//			return [[agent.sections firstObject] store_serialize];
//		}
//		else
//		{
			NSMutableDictionary * dict = [NSMutableDictionary dictionary];
			
			for ( __HtmlTableViewSection * section in agent.sections )
			{
				NSString * sectionKey = nil;
				NSString * sectionData = nil;
				
				if ( section.document.domTree.attrName )
				{
					sectionKey = section.document.domTree.attrName;
				}
				else
				{
					sectionKey = [NSString stringWithFormat:@"%lu", (unsigned long)section.index];
				}
				
				sectionData = [section store_serialize];
				
				if ( sectionKey && sectionData )
				{
					[dict setObject:sectionData forKey:sectionKey];
				}
			}
			
			return dict;
//		}
	}
	
	return nil;
}

- (void)store_unserialize:(id)obj
{
	[super store_unserialize:obj];
	
	SamuraiUITableViewAgent * agent = [self tableViewAgent];
	if ( agent )
	{
//		if ( 1 == [agent.sections count] )
//		{
//			[[agent.sections firstObject] store_unserialize:obj];
//		}
//		else
		{
			for ( __HtmlTableViewSection * section in agent.sections )
			{
				NSString * sectionKey = nil;
				NSString * sectionData = nil;
				
				if ( section.document.domTree.attrName )
				{
					sectionKey = section.document.domTree.attrName;
				}
				else
				{
					sectionKey = [NSString stringWithFormat:@"%lu", (unsigned long)section.index];
				}
				
				if ( [obj isKindOfClass:[NSDictionary class]] || [obj conformsToProtocol:@protocol(NSDictionaryProtocol)] )
				{
					sectionData = [(NSDictionary *)obj objectForKey:sectionKey];
				}
				else
				{
					sectionData = [obj valueForKey:sectionKey];
				}
				
				if ( sectionData && NO == [sectionData isKindOfClass:[NSNull class]] )
				{
					[section store_unserialize:sectionData];
				}
				else
				{
					[section store_zerolize];
				}
			}
		}
	}
	
	[self reloadData];
}

- (void)store_zerolize
{
	[super store_zerolize];
	
	SamuraiUITableViewAgent * agent = [self tableViewAgent];
	if ( agent )
	{
		for ( __HtmlTableViewSection * section in agent.sections )
		{
			[section store_zerolize];
		}
	}
	
	[self reloadData];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, UITableView_Html )

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
