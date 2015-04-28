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

#import "Samurai_UITableView.h"
#import "Samurai_UITableViewCell.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiUITableViewSection
{
	NSObject *				_cachedData;
	NSMutableDictionary *	_cachedHeight;
}

@def_prop_unsafe( UITableView *,		tableView );
@def_prop_assign( NSUInteger,			index );
@def_prop_strong( SamuraiDocument *,	document );

- (id)init
{
	self = [super init];
	if ( self )
	{
		_cachedHeight = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)dealloc
{
	_cachedHeight = nil;
	_cachedData = nil;
	
	self.tableView = nil;
	self.document = nil;
}

#pragma mark -

- (id)serialize
{
	return _cachedData;
}

- (void)unserialize:(id)obj
{
	[_cachedHeight removeAllObjects];

	_cachedData = obj;
}

- (void)zerolize
{
	[_cachedHeight removeAllObjects];

	_cachedData = nil;
}

#pragma mark -

- (void)clearCache
{
//	_cachedData = nil;
	
	[_cachedHeight removeAllObjects];
}

#pragma mark -

- (NSUInteger)getRowCount
{
	if ( nil == self.document || nil == self.document.domTree || nil == self.document.renderTree )
	{
		return 0;
	}
	
	if ( nil == _cachedData )
	{
		return 0;
	}

	if ( [_cachedData isKindOfClass:[NSArray class]] || [_cachedData conformsToProtocol:@protocol(NSArrayProtocol)] )
	{
		return [(NSArray *)_cachedData count];
	}
	else
	{
		return 0; // 1;
	}
}

- (NSObject *)getDataForRowAtIndexPath:(NSIndexPath *)indexPath
{
	ASSERT( indexPath );

	if ( _cachedData )
	{
		if ( [_cachedData isKindOfClass:[NSArray class]] || [_cachedData conformsToProtocol:@protocol(NSArrayProtocol)] )
		{
			if ( indexPath.row >= [(NSArray *)_cachedData count] )
			{
				return nil;
			}
			else
			{
				return [(NSArray *)_cachedData objectAtIndex:indexPath.row];
			}
		}
		else
		{
			return _cachedData;
		}
	}
	
	return nil;
}

- (CGFloat)getHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ( CGRectEqualToRect( self.tableView.frame, CGRectZero ) )
	{
		return 0.0f;
	}
	
	ASSERT( indexPath );

	NSString * cachedKey = [NSString stringWithFormat:@"%ld-%ld", indexPath.section, indexPath.row];
	NSNumber * cachedHeight = [_cachedHeight objectForKey:cachedKey];
	
	if ( cachedHeight )
	{
		return cachedHeight.floatValue;
	}

	UITableViewCell * reuseCell = (UITableViewCell *)self.document.renderTree.view;
	
	if ( nil == reuseCell )
	{
		reuseCell = (UITableViewCell *)[self.document.renderTree createViewWithIdentifier:nil];
		[reuseCell.renderer bindOutletsTo:reuseCell];
	}
	
	if ( nil == reuseCell )
	{
		reuseCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
		[reuseCell.renderer bindOutletsTo:reuseCell];
	}
	
	NSObject * reuseData = [self getDataForRowAtIndexPath:indexPath];
	
	if ( reuseData )
	{
		[reuseCell unserialize:reuseData];
	}
//	else
//	{
//		[reuseCell zerolize];
//	}

	CGFloat cellHeight = [reuseCell.renderer computeHeight:self.tableView.frame.size.width];
	
// use default height
	
	if ( INVALID_VALUE == cellHeight )
	{
		cellHeight = self.tableView.rowHeight;
	}

	[_cachedHeight setObject:@(cellHeight) forKey:cachedKey];

	return cellHeight;
}

- (UITableViewCell *)getCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	ASSERT( indexPath );

	NSString *			reuseIdentifier = [NSString stringWithFormat:@"%@-%@", self.document.domTree.domTag, self.document.renderTree.id];
	UITableViewCell *	reuseCell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];

	if ( nil == reuseCell )
	{
		PERF( @"UITableView '%p', creating cell '%@' for row #%d", self, reuseIdentifier, indexPath.row );
		
		SamuraiRenderObject * reuseRenderer = [self.document.renderTree clone];

		reuseCell = (UITableViewCell *)[reuseRenderer createViewWithIdentifier:reuseIdentifier];

		if ( nil == reuseCell )
		{
			reuseCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
		}

		[reuseRenderer bindOutletsTo:reuseCell];

		[self.tableView.renderer appendNode:reuseRenderer];
	}
	else
	{
		PERF( @"UITableView '%p', reusing cell '%@' for row #%d", self, reuseIdentifier, indexPath.row );
	}

	NSObject * resueData = [self getDataForRowAtIndexPath:indexPath];
	
	if ( resueData )
	{
		[reuseCell unserialize:resueData];
	}
//	else
//	{
//		[reuseCell zerolize];
//	}
	
	[reuseCell.renderer relayout];
//	[reuseCell tableViewCellAgent].dirty = YES;

	return reuseCell;
}

@end

#pragma mark -

@implementation SamuraiUITableViewAgent

@def_prop_unsafe( UITableView *,		tableView );
@def_prop_strong( NSMutableArray *,		sections );

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.sections = [[NSMutableArray alloc] init];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(UIApplicationWillChangeStatusBarOrientationNotification:)
													 name:UIApplicationWillChangeStatusBarOrientationNotification
												   object:nil];
	}
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[self.sections removeAllObjects];
	self.sections = nil;
}

#pragma mark -

- (void)UIApplicationWillChangeStatusBarOrientationNotification:(NSNotification *)notification
{
	for ( SamuraiUITableViewSection * section in self.sections )
	{
		[section clearCache];
	}
	
	[self.tableView reloadData];
}

#pragma mark -

- (void)constructSections:(SamuraiRenderObject *)renderObject
{
	[self.sections removeAllObjects];

	NSUInteger index = 0;

	SamuraiDocument * parentDoc = renderObject.dom.document;
	if ( parentDoc )
	{
		for ( SamuraiDomNode * childDom in renderObject.dom.childs )
		{
			if ( DomNodeType_Document == childDom.type || DomNodeType_Element == childDom.type )
			{
				SamuraiDocument * childDoc = [parentDoc childDocument:childDom];
				if ( nil == childDoc )
					continue;

				BOOL succeed = [childDoc parse];
				if ( succeed )
				{
					succeed = [childDoc reflow];
					if ( succeed )
					{
						SamuraiUITableViewSection * section = [[SamuraiUITableViewSection alloc] init];
						
						section.index = index++;
						section.document = childDoc;
						section.tableView = self.tableView;
						
						[self.sections addObject:section];
					}
				}
			}
		}
	}
}

#pragma mark -

- (SamuraiUITableViewSection *)getSection:(NSUInteger)index
{
	return [self.sections safeObjectAtIndex:(index % [self.sections count])];
}

#pragma mark -

- (id)serialize
{
	if ( nil == self.sections || 0 == [self.sections count] )
		return nil;
	
//	if ( 1 == [self.sections count] )
//	{
//		return [[self.sections firstObject] serialize];
//	}
//	else
	{
		NSMutableDictionary * dict = [NSMutableDictionary dictionary];
		
		for ( SamuraiUITableViewSection * section in self.sections )
		{
			NSString * sectionKey = nil;
			NSString * sectionData = nil;
			
			if ( section.document.domTree.domName )
			{
				sectionKey = section.document.domTree.domName;
			}
			else
			{
				sectionKey = [NSString stringWithFormat:@"%lu", section.index];
			}
			
			sectionData = [section serialize];
			
			if ( sectionKey && sectionData )
			{
				[dict setObject:sectionData forKey:sectionKey];
			}
		}
		
		return dict;
	}
}

- (void)unserialize:(id)obj
{
	if ( nil == self.sections || 0 == [self.sections count] )
		return;
	
//	if ( 1 == [self.sections count] )
//	{
//		[[self.sections firstObject] unserialize:obj];
//	}
//	else
	{
		for ( SamuraiUITableViewSection * section in self.sections )
		{
			NSString * sectionKey = nil;
			NSString * sectionData = nil;
			
			if ( section.document.domTree.domName )
			{
				sectionKey = section.document.domTree.domName;
			}
			else
			{
				sectionKey = [NSString stringWithFormat:@"%lu", section.index];
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
				[section unserialize:sectionData];
			}
			else
			{
				[section zerolize];
			}
		}
	}
}

- (void)zerolize
{
	for ( SamuraiUITableViewSection * section in self.sections )
	{
		[section zerolize];
	}
}

#pragma mark -

// Display customization

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	[cell.renderer relayout];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0)
{
	[view.renderer relayout];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0)
{
	[view.renderer relayout];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath NS_AVAILABLE_IOS(6_0)
{
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0)
{
	
}

- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0)
{
	
}

// Variable height support

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	SamuraiUITableViewSection * tableSection = [self getSection:indexPath.section];
	
	if ( nil == tableSection )
	{
		return 0.0f;
	}
	else
	{
		return [tableSection getHeightForRowAtIndexPath:indexPath];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return 0.0f;
}

// Use the estimatedHeight methods to quickly calcuate guessed values which will allow for fast load times of the table.
// If these methods are implemented, the above -tableView:heightForXXX calls will be deferred until views are ready to be displayed, so more expensive logic can be placed there.

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(7_0)
//{
//	return [self tableView:tableView heightForRowAtIndexPath:indexPath];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section NS_AVAILABLE_IOS(7_0)
//{
//	return [self tableView:tableView heightForHeaderInSection:section];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section NS_AVAILABLE_IOS(7_0)
//{
//	return [self tableView:tableView heightForFooterInSection:section];
//}

// Section header & footer information. Views are preferred over title should you decide to provide both

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	// custom view for header. will be adjusted to default or specified header height

	return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	// custom view for footer. will be adjusted to default or specified footer height
	
	return nil;
}

//// Accessories (disclosures).
//
//- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath NS_DEPRECATED_IOS(2_0, 3_0)
//{
//	return UITableViewCellAccessoryNone;
//}
//
//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
//{
//	
//}

// Selection

// -tableView:shouldHighlightRowAtIndexPath: is called when a touch comes down on a row.
// Returning NO to that message halts the selection process and does not cause the currently selected row to lose its selected look while the touch is down.

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(6_0)
{
	return NO;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(6_0)
{
	
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(6_0)
{
	
}

// Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView sendSignal:UITableView.eventWillSelectRow withObject:indexPath];

	return indexPath;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0)
{
	[tableView sendSignal:UITableView.eventWillDeselectRow withObject:indexPath];
	
	return indexPath;
}

// Called after the user changes the selection.

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView sendSignal:UITableView.eventDidSelectRow withObject:indexPath];

}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0)
{
	[tableView sendSignal:UITableView.eventDidDeselectRow withObject:indexPath];
}

// Editing

// Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property set to YES.

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleNone;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0)
{
	return nil;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0)
{
	// supercedes -tableView:titleForDeleteConfirmationButtonForRowAtIndexPath: if return value is non-nil
	
	return nil;
}

// Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}

// The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row

- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}

// Moving/reordering

// Allows customization of the target row for a particular row as it is being moved/reordered
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
	return nil;
}

// Indentation

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// return 'depth' of row for hierarchies
	
	return 0;
}

// Copy/Paste.  All three methods must be implemented by the delegate.

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(5_0)
{
	return NO;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender NS_AVAILABLE_IOS(5_0)
{
	return NO;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender NS_AVAILABLE_IOS(5_0)
{
	
}

#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	// Default is 1 if not implemented

	return [self.sections count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	// fixed font style. use custom view (UILabel) if you want something different

	return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// Default is 1 if not implemented

	SamuraiUITableViewSection * tableSection = [self getSection:section];
	
	if ( nil == tableSection )
	{
		return 0;
	}
	else
	{
		return [tableSection getRowCount];
	}
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	SamuraiUITableViewSection * tableSection = [self getSection:indexPath.section];

	if ( nil == tableSection )
	{
		return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
	}
	else
	{
		return [tableSection getCellForRowAtIndexPath:indexPath];
	}
}

// Editing

// Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}

// Moving/reordering

// Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}

// Index

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
	// return list of section titles to display in section index view (e.g. "ABCD...Z#")
	
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
	// tell table which section corresponds to section title/index (e.g. "B",1))
	
	return 0;
}

// Data manipulation - insert and delete support

// After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
// Not called for edit actions using UITableViewRowAction - the action's handler will be invoked instead

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}

// Data manipulation - reorder / moving support

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
	
}

@end

#pragma mark - UITableView

@implementation UITableView(Samurai)

@def_signal( eventWillSelectRow );
@def_signal( eventWillDeselectRow );

@def_signal( eventDidSelectRow );
@def_signal( eventDidDeselectRow );

+ (id)createInstanceWithRenderer:(SamuraiRenderObject *)renderer identifier:(NSString *)identifier
{
	UITableView * tableView = [[self alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	
	SamuraiUITableViewAgent * agent = [tableView tableViewAgent];
	
	tableView.renderer = renderer;
	tableView.delegate = agent;
	tableView.dataSource = agent;

	[agent constructSections:renderer];

	return tableView;
}

#pragma mark -

- (SamuraiUITableViewAgent *)tableViewAgent
{
	SamuraiUITableViewAgent * agent = [self getAssociatedObjectForKey:"UITableView.agent"];
	
	if ( nil == agent )
	{
		agent = [[SamuraiUITableViewAgent alloc] init];
		agent.tableView = self;

		[self retainAssociatedObject:agent forKey:"UITableView.agent"];
	}
	
	return agent;
}

#pragma mark -

- (id)serialize
{
	return [[self tableViewAgent] serialize];
}

- (void)unserialize:(id)obj
{
	[[self tableViewAgent] unserialize:obj];

	[self reloadData];
}

- (void)zerolize
{
	[[self tableViewAgent] zerolize];
	
	[self reloadData];
}

#pragma mark -

- (void)applyFrame:(CGRect)frame
{
//	[super applyFrame:frame];

	[self setFrame:frame];
}

#pragma mark -

- (CGSize)computeSizeBySize:(CGSize)size
{
	return [super computeSizeBySize:size];
}

- (CGSize)computeSizeByWidth:(CGFloat)width
{
	return [super computeSizeByWidth:width];
}

- (CGSize)computeSizeByHeight:(CGFloat)height
{
	return [super computeSizeByHeight:height];
}

#pragma mark -

- (BOOL)isCell
{
	return NO;
}

- (BOOL)isCellContainer
{
	return YES;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, UITableView )

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
