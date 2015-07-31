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

- (NSUInteger)getRowCount
{
	return 0;
}

- (CGFloat)getHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 0.0f;
}

- (NSObject *)getDataForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

- (UITableViewCell *)getCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	ASSERT( 0 );

	return nil;
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
	}
	return self;
}

- (void)dealloc
{
	[self.sections removeAllObjects];
	self.sections = nil;
}

#pragma mark -

- (void)appendSection:(SamuraiUITableViewSection *)section
{
	if ( nil == section )
		return;
	
	[self.sections addObject:section];
}

- (void)insertSection:(SamuraiUITableViewSection *)section atIndex:(NSUInteger)index
{
	if ( nil == section )
		return;
	
	[self.sections insertObject:section atIndex:index];
}

- (void)removeAllSections
{
	[self.sections removeAllObjects];
}

#pragma mark -

// Display customization

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	[cell cellWillDisplay];

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
	[cell cellDidDisplay];
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
	SamuraiUITableViewSection * tableSection = [self.sections safeObjectAtIndex:(indexPath.section % self.sections.count)];
	
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
	return nil;
}

// Called after the user changes the selection.

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0)
{
	return nil;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0)
{

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

	SamuraiUITableViewSection * tableSection = [self.sections safeObjectAtIndex:(section % self.sections.count)];
	
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
	SamuraiUITableViewSection * tableSection = [self.sections safeObjectAtIndex:(indexPath.section % self.sections.count)];

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

	tableView.allowsSelection = NO;
	tableView.allowsMultipleSelection = NO;

	tableView.renderer = renderer;

	return tableView;
}

#pragma mark -

+ (BOOL)supportTapGesture
{
	return YES;
}

+ (BOOL)supportSwipeGesture
{
	return YES;
}

+ (BOOL)supportPinchGesture
{
	return YES;
}

+ (BOOL)supportPanGesture
{
	return YES;
}

#pragma mark -

- (SamuraiUITableViewAgent *)tableViewAgent
{
	SamuraiUITableViewAgent * agent = [self getAssociatedObjectForKey:"UITableView.agent"];
	
	if ( nil == agent )
	{
		agent = [[SamuraiUITableViewAgent alloc] init];
		agent.scrollView = self;
		agent.tableView = self;

		self.delegate = agent;
		self.dataSource = agent;

		[self retainAssociatedObject:agent forKey:"UITableView.agent"];
	}
	
	return agent;
}

#pragma mark -

- (id)serialize
{
	return nil;
}

- (void)unserialize:(id)obj
{
}

- (void)zerolize
{
}

#pragma mark -

- (void)applyDom:(SamuraiDomNode *)dom
{
	[super applyDom:dom];
}

- (void)applyStyle:(SamuraiRenderStyle *)style
{
	[super applyStyle:style];
}

- (void)applyFrame:(CGRect)newFrame
{
//	[super applyFrame:frame];

	// TODO: if animation
	
	newFrame.origin.x = isnan( newFrame.origin.x ) ? 0.0f : newFrame.origin.x;
	newFrame.origin.y = isnan( newFrame.origin.y ) ? 0.0f : newFrame.origin.y;
	newFrame.size.width = isnan( newFrame.size.width ) ? 0.0f : newFrame.size.width;
	newFrame.size.height = isnan( newFrame.size.height ) ? 0.0f : newFrame.size.height;

	[self setFrame:newFrame];
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
