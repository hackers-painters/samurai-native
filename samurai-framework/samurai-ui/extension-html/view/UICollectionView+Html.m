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

#import "UICollectionView+Html.h"
#import "UICollectionViewCell+Html.h"

#import "Samurai_UICollectionView.h"
#import "Samurai_UICollectionViewCell.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_HtmlStyle.h"
#import "Samurai_HtmlRenderObject.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

#define	LAYOUT_DIRECTION_VERTICAL	(0)
#define	LAYOUT_DIRECTION_HORIZONTAL	(1)

#define LAYOUT_PATTERN_COL			(0)
#define LAYOUT_PATTERN_ROW			(1)

#define LAYOUT_MAX_LINES			(64)

#pragma mark -

@interface UICollectionViewItem_Html : NSObject

@prop_strong( UICollectionViewLayoutAttributes *,		attributes );
@prop_unsafe( UICollectionViewItem_Html *,				prev );
@prop_unsafe( UICollectionViewItem_Html *,				next );

@prop_strong( NSIndexPath *,							indexPath );
@prop_assign( NSInteger,								type );
@prop_assign( NSInteger,								line );
@prop_assign( CGRect,									frame );

@prop_assign( NSInteger,								estimatedSpan );
@prop_assign( CGSize,									estimatedSize );

@end

#pragma mark -

@implementation UICollectionViewItem_Html

@def_prop_strong( UICollectionViewLayoutAttributes *,	attributes );
@def_prop_unsafe( UICollectionViewItem_Html *,			prev );
@def_prop_unsafe( UICollectionViewItem_Html *,			next );

@def_prop_strong( NSIndexPath *,						indexPath );
@def_prop_assign( NSInteger,							type );
@def_prop_assign( NSInteger,							line );
@def_prop_assign( CGRect,								frame );

@def_prop_assign( NSInteger,							estimatedSpan );
@def_prop_assign( CGSize,								estimatedSize );

- (void)dealloc
{
	self.attributes = nil;
	self.indexPath = nil;
}

@end

#pragma mark -

@implementation UICollectionViewLayout_Html
{
	NSUInteger				_layoutColumnCount;
	CGFloat					_layoutColumnWidth;
	CGFloat					_layoutColumnHeights[LAYOUT_MAX_LINES];
	
	NSUInteger				_layoutDirection;
	CGSize					_layoutContentSize;
	
	NSMutableArray *		_layoutItems;
	NSMutableArray *		_layoutAttributes;
	
	NSMutableArray *		_layoutStickTop;
	NSMutableArray *		_layoutStickBottom;
	
	NSMutableArray *		_layoutFixedTop;
	NSMutableArray *		_layoutFixedBottom;
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		_layoutColumnCount = 1;
		_layoutDirection = LAYOUT_DIRECTION_VERTICAL;
		
		_layoutContentSize = CGSizeZero;
		
		_layoutItems = [[NSMutableArray alloc] init];
		_layoutAttributes = [[NSMutableArray alloc] init];
		
		_layoutStickTop = [[NSMutableArray alloc] init];
		_layoutStickBottom = [[NSMutableArray alloc] init];
		
		_layoutFixedTop = [[NSMutableArray alloc] init];
		_layoutFixedBottom = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[_layoutItems removeAllObjects];
	_layoutItems = nil;
	
	[_layoutAttributes removeAllObjects];
	_layoutAttributes = nil;
	
	[_layoutStickTop removeAllObjects];
	_layoutStickTop = nil;
	
	[_layoutStickBottom removeAllObjects];
	_layoutStickBottom = nil;
	
	[_layoutFixedTop removeAllObjects];
	_layoutFixedTop = nil;
	
	[_layoutFixedBottom removeAllObjects];
	_layoutFixedBottom = nil;
}

#pragma mark -

- (NSInteger)getLongestColumn
{
	NSInteger longest = 0;
	
	for ( NSInteger i = 0; i < _layoutColumnCount; ++i )
	{
		if ( _layoutColumnHeights[i] > _layoutColumnHeights[longest] )
		{
			longest = i;
		}
	}
	
	return longest;
}

- (NSInteger)getShortestColumn
{
	NSInteger shortest = 0;
	
	for ( NSInteger i = 0; i < _layoutColumnCount; ++i )
	{
		if ( _layoutColumnHeights[i] < _layoutColumnHeights[shortest] )
		{
			shortest = i;
		}
	}
	
	return shortest;
}

#pragma mark -

- (void)resetLayout
{
	_layoutDirection = LAYOUT_DIRECTION_VERTICAL;
	_layoutContentSize = CGSizeZero;
	
	_layoutColumnWidth = 0.0f;
	_layoutColumnCount = 1;
	
	memset( _layoutColumnHeights, 0x0, sizeof(_layoutColumnHeights) );
	
	[_layoutItems removeAllObjects];
	[_layoutAttributes removeAllObjects];
	
	[_layoutStickTop removeAllObjects];
	[_layoutStickBottom removeAllObjects];
	
	[_layoutFixedTop removeAllObjects];
	[_layoutFixedBottom removeAllObjects];
}

- (void)prepareLayout
{
	CGSize viewBounds = self.collectionView.frame.size;
	if ( CGSizeEqualToSize(viewBounds, CGSizeZero) )
		return;
	
	[self resetLayout];
	
	// Compute size
	
	NSString * columnCount = [self.collectionView.renderer.dom.domAttributes objectForKey:@"columns"];
	
	if ( columnCount )
	{
		_layoutColumnCount = [columnCount integerValue];
		_layoutColumnCount = (_layoutColumnCount > 0) ? _layoutColumnCount : 1;
	}
	
	NSString * isVertical = [self.collectionView.renderer.dom.domAttributes objectForKey:@"is-vertical"];
	NSString * isHorizontal = [self.collectionView.renderer.dom.domAttributes objectForKey:@"is-horizontal"];
	
	if ( isVertical )
	{
		_layoutDirection = LAYOUT_DIRECTION_VERTICAL;
		_layoutColumnWidth = viewBounds.width / _layoutColumnCount;
	}
	else if ( isHorizontal )
	{
		_layoutDirection = LAYOUT_DIRECTION_HORIZONTAL;
		_layoutColumnWidth = viewBounds.height / _layoutColumnCount;
	}
	else
	{
		_layoutDirection = LAYOUT_DIRECTION_VERTICAL;
		_layoutColumnWidth = viewBounds.width / _layoutColumnCount;
	}
	
	// Alloc items
	
	for ( SamuraiUICollectionViewSection * section in [self.collectionView collectionViewAgent].sections )
	{
		NSUInteger rowCount = [section getRowCount];
		if ( 0 == rowCount )
			continue;
		
		NSString *	isStickTop = [section.document.domTree.domAttributes objectForKey:@"stick-top"];
		NSString *	isStickBottom = [section.document.domTree.domAttributes objectForKey:@"stick-bottom"];
		
		NSString *	isFixedTop = [section.document.domTree.domAttributes objectForKey:@"fixed-top"];
		NSString *	isFixedBottom = [section.document.domTree.domAttributes objectForKey:@"fixed-bottom"];
		
		NSString *	isCol = [section.document.domTree.domAttributes objectForKey:@"is-column"];
		NSString *	isRow = [section.document.domTree.domAttributes objectForKey:@"is-row"];
		
		NSUInteger	itemType = LAYOUT_PATTERN_COL;
		
		if ( isCol )
		{
			itemType = LAYOUT_PATTERN_COL;
		}
		else if ( isRow )
		{
			itemType = LAYOUT_PATTERN_ROW;
		}
		
		for ( NSInteger i = 0; i < rowCount; ++i )
		{
			UICollectionViewItem_Html * currItem = [[UICollectionViewItem_Html alloc] init];
			
			currItem.indexPath = [NSIndexPath indexPathForRow:i inSection:section.index];
			currItem.type = itemType;
			
			if ( LAYOUT_PATTERN_ROW == itemType )
			{
				if ( LAYOUT_DIRECTION_VERTICAL == _layoutDirection )
				{
					currItem.estimatedSize = [section getSizeForRowAtIndexPath:currItem.indexPath byWidth:viewBounds.width];
					currItem.estimatedSpan = _layoutColumnCount; // (currItem.estimatedSize.width + _layoutColumnWidth - 1.0f) / _layoutColumnWidth;
				}
				else if ( LAYOUT_DIRECTION_HORIZONTAL == _layoutDirection )
				{
					currItem.estimatedSize = [section getSizeForRowAtIndexPath:currItem.indexPath byHeight:viewBounds.height];
					currItem.estimatedSpan = _layoutColumnCount; // (currItem.estimatedSize.height + _layoutColumnWidth - 1.0f) / _layoutColumnWidth;
				}
				else
				{
					ASSERT( 0 );
				}
			}
			else if ( LAYOUT_PATTERN_COL == itemType )
			{
				if ( LAYOUT_DIRECTION_VERTICAL == _layoutDirection )
				{
					currItem.estimatedSize = [section getSizeForRowAtIndexPath:currItem.indexPath byWidth:_layoutColumnWidth];
					currItem.estimatedSpan = (currItem.estimatedSize.width + _layoutColumnWidth - 1.0f) / _layoutColumnWidth;
				}
				else if ( LAYOUT_DIRECTION_HORIZONTAL == _layoutDirection )
				{
					currItem.estimatedSize = [section getSizeForRowAtIndexPath:currItem.indexPath byHeight:_layoutColumnWidth];
					currItem.estimatedSpan = (currItem.estimatedSize.height + _layoutColumnWidth - 1.0f) / _layoutColumnWidth;
				}
				else
				{
					ASSERT( 0 );
				}
			}
			else
			{
				ASSERT( 0 );
			}
			
			currItem.estimatedSpan = (currItem.estimatedSpan > _layoutColumnCount) ? _layoutColumnCount : currItem.estimatedSpan;
			currItem.estimatedSpan = (currItem.estimatedSpan > 0) ? currItem.estimatedSpan : 1;
			
			if ( isStickTop )
			{
				UICollectionViewItem_Html * lastItem = (UICollectionViewItem_Html *)[_layoutStickTop lastObject];
				
				currItem.prev = lastItem;
				lastItem.next = currItem;
				
				[_layoutStickTop addObject:currItem];
			}
			else if ( isStickBottom )
			{
				UICollectionViewItem_Html * lastItem = (UICollectionViewItem_Html *)[_layoutStickBottom lastObject];
				
				currItem.prev = lastItem;
				lastItem.next = currItem;
				
				[_layoutStickBottom addObject:currItem];
			}
			
			if ( isFixedTop )
			{
				UICollectionViewItem_Html * lastItem = (UICollectionViewItem_Html *)[_layoutFixedTop lastObject];
				
				currItem.prev = lastItem;
				lastItem.next = currItem;
				
				[_layoutFixedTop addObject:currItem];
			}
			else if ( isFixedBottom )
			{
				UICollectionViewItem_Html * lastItem = (UICollectionViewItem_Html *)[_layoutFixedBottom lastObject];
				
				currItem.prev = lastItem;
				lastItem.next = currItem;
				
				[_layoutFixedBottom addObject:currItem];
			}
			
			[_layoutItems addObject:currItem];
		}
	}
	
	// Layout items
	
	for ( UICollectionViewItem_Html * item in _layoutItems )
	{
		NSInteger	shortestColumn = [self getShortestColumn];
		NSInteger	longestColumn = [self getLongestColumn];
		
		if ( LAYOUT_PATTERN_COL == item.type )
		{
			if ( item.estimatedSpan > 1 )
			{
				if ( shortestColumn + item.estimatedSpan >= _layoutColumnCount )
				{
					item.line = _layoutColumnCount - item.estimatedSpan;
					item.line = (item.line < 0) ? 0 : item.line;
				}
				else
				{
					item.line = shortestColumn;
				}
			}
			else
			{
				item.line = item.indexPath.row % _layoutColumnCount;
			}
			
			if ( LAYOUT_DIRECTION_HORIZONTAL == _layoutDirection )
			{
				CGRect itemFrame;
				
				itemFrame.origin.x		= _layoutColumnHeights[item.line];
				itemFrame.origin.y		= _layoutColumnWidth * item.line;
				itemFrame.size.width	= item.estimatedSize.width;
				itemFrame.size.height	= item.estimatedSpan * _layoutColumnWidth;
				
				item.frame = itemFrame;
				
				for ( NSInteger k = 0; k < item.estimatedSpan; ++k )
				{
					NSInteger line = item.line + k;
					
					if ( line >= _layoutColumnCount )
						break;
					
					_layoutColumnHeights[line] = CGRectGetMaxX( itemFrame );
				}
			}
			else
			{
				CGRect itemFrame;
				
				itemFrame.origin.x		= _layoutColumnWidth * item.line;
				itemFrame.origin.y		= _layoutColumnHeights[item.line];
				itemFrame.size.width	= item.estimatedSpan * _layoutColumnWidth;
				itemFrame.size.height	= item.estimatedSize.height;
				
				item.frame = itemFrame;
				
				for ( NSInteger k = 0; k < item.estimatedSpan; ++k )
				{
					NSInteger line = item.line + k;
					
					if ( line >= _layoutColumnCount )
						break;
					
					_layoutColumnHeights[line] = CGRectGetMaxY( itemFrame );
				}
			}
			
			if ( item.estimatedSpan > 1 )
			{
				for ( UICollectionViewItem_Html * prevItem in _layoutItems )
				{
					if ( prevItem.indexPath.row >= item.indexPath.row )
						break;
					
					if ( prevItem.line >= item.line && prevItem.line < (item.line + item.estimatedSpan) )
					{
						if ( LAYOUT_DIRECTION_HORIZONTAL == _layoutDirection )
						{
							if ( CGRectGetMaxX( prevItem.frame ) > CGRectGetMinX( item.frame ) )
							{
								CGRect itemFrame = prevItem.frame;
								
								itemFrame.origin.x = CGRectGetMaxX( item.frame );
								
								prevItem.frame = itemFrame;
							}
							
							if ( CGRectGetMaxX( prevItem.frame ) > _layoutColumnHeights[prevItem.line] )
							{
								_layoutColumnHeights[prevItem.line] = CGRectGetMaxX( prevItem.frame );
							}
						}
						else
						{
							if ( CGRectGetMaxY( prevItem.frame ) > CGRectGetMinY( item.frame ) )
							{
								CGRect itemFrame = prevItem.frame;
								
								itemFrame.origin.y = CGRectGetMaxY( item.frame );
								
								prevItem.frame = itemFrame;
							}
							
							if ( CGRectGetMaxY( prevItem.frame ) > _layoutColumnHeights[prevItem.line] )
							{
								_layoutColumnHeights[prevItem.line] = CGRectGetMaxY( prevItem.frame );
							}
						}
					}
				}
			}
		}
		else if ( LAYOUT_PATTERN_ROW == item.type )
		{
			item.line = 0;
			item.estimatedSpan = _layoutColumnCount;
			
			if ( LAYOUT_DIRECTION_HORIZONTAL == _layoutDirection )
			{
				CGRect itemFrame;
				
				itemFrame.origin.x		= _layoutColumnHeights[longestColumn];
				itemFrame.origin.y		= 0.0f;
				itemFrame.size.width	= item.estimatedSize.width;
				itemFrame.size.height	= viewBounds.height;
				
				item.frame = itemFrame;
			}
			else
			{
				CGRect itemFrame;
				
				itemFrame.origin.x		= 0.0f;
				itemFrame.origin.y		= _layoutColumnHeights[longestColumn];
				itemFrame.size.width	= viewBounds.width;
				itemFrame.size.height	= item.estimatedSize.height;
				
				item.frame = itemFrame;
			}
			
			for ( NSUInteger i = 0; i < _layoutColumnCount; ++i )
			{
				if ( LAYOUT_DIRECTION_HORIZONTAL == _layoutDirection )
				{
					_layoutColumnHeights[i] = CGRectGetMaxX( item.frame );
				}
				else
				{
					_layoutColumnHeights[i] = CGRectGetMaxY( item.frame );
				}
			}
		}
		
		item.attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:item.indexPath];
		item.attributes.frame = item.frame;
		item.attributes.size = item.frame.size;
		item.attributes.alpha = 1.0f;
		item.attributes.zIndex = 0;
		
		[_layoutAttributes addObject:item.attributes];
	}
	
	NSInteger bottomLine = [self getLongestColumn];
	
	if ( LAYOUT_DIRECTION_HORIZONTAL == _layoutDirection )
	{
		_layoutContentSize = CGSizeMake( _layoutColumnHeights[bottomLine], viewBounds.height );
	}
	else
	{
		_layoutContentSize = CGSizeMake( viewBounds.width, _layoutColumnHeights[bottomLine] );
	}
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
	CGPoint contentOffset = self.collectionView.contentOffset;
	contentOffset.x += self.collectionView.contentInset.left;
	contentOffset.y += self.collectionView.contentInset.top;
	
	if ( LAYOUT_DIRECTION_VERTICAL == _layoutDirection )
	{
		for ( UICollectionViewItem_Html * item in _layoutStickTop )
		{
			CGRect itemFrame = item.frame;
			
			if ( itemFrame.origin.y < contentOffset.y )
			{
				itemFrame.origin.y = contentOffset.y;
			}
			
			item.attributes.zIndex = 1;
			item.attributes.frame = itemFrame;
		}
		
		UICollectionViewItem_Html * currItem = [_layoutStickTop lastObject];
		
		while ( nil != currItem && nil != currItem.prev )
		{
			CGFloat prevMaxY = CGRectGetMaxY( currItem.prev.attributes.frame );
			CGFloat currMinY = CGRectGetMinY( currItem.attributes.frame );
			
			if ( prevMaxY < contentOffset.y )
				continue;
			
			if ( prevMaxY >= currMinY )
			{
				CGRect itemFrame = currItem.prev.attributes.frame;
				
				itemFrame.origin.y = currItem.attributes.frame.origin.y - currItem.prev.attributes.frame.size.height;
				
				currItem.prev.attributes.frame = itemFrame;
			}
			
			currItem = currItem.prev;
		}
		
		for ( UICollectionViewItem_Html * item in _layoutFixedTop )
		{
			CGRect itemFrame = item.frame;
			
			itemFrame.origin.y = contentOffset.y;
			
			item.attributes.zIndex = 2;
			item.attributes.frame = itemFrame;
		}
	}
	else if ( LAYOUT_DIRECTION_HORIZONTAL == _layoutDirection )
	{
		for ( UICollectionViewItem_Html * item in _layoutStickTop )
		{
			CGRect itemFrame = item.frame;
			
			if ( itemFrame.origin.x < contentOffset.x )
			{
				itemFrame.origin.x = contentOffset.x;
			}
			
			item.attributes.zIndex = 1;
			item.attributes.frame = itemFrame;
		}
		
		UICollectionViewItem_Html * currItem = [_layoutStickTop lastObject];
		
		while ( nil != currItem && nil != currItem.prev )
		{
			CGFloat prevMaxX = CGRectGetMaxX( currItem.prev.attributes.frame );
			CGFloat currMinX = CGRectGetMinX( currItem.attributes.frame );
			
			if ( prevMaxX < contentOffset.x )
				continue;
			
			if ( prevMaxX >= currMinX )
			{
				CGRect itemFrame = currItem.prev.attributes.frame;
				
				itemFrame.origin.x = currItem.attributes.frame.origin.x - currItem.prev.attributes.frame.size.width;
				
				currItem.prev.attributes.frame = itemFrame;
			}
			
			currItem = currItem.prev;
		}
		
		for ( UICollectionViewItem_Html * item in _layoutFixedTop )
		{
			CGRect itemFrame = item.frame;
			
			itemFrame.origin.x = contentOffset.x;
			
			item.attributes.zIndex = 2;
			item.attributes.frame = itemFrame;
		}
	}
	
	return _layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds // return YES to cause the collection view to requery the layout for geometry information
{
	return YES;
	
	//	if ( NO == CGSizeEqualToSize(newBounds.size, self.collectionView.frame.size) )
	//	{
	//		return YES;
	//	}
	//
	//	return NO;
}

//- (UICollectionViewLayoutInvalidationContext *)invalidationContextForBoundsChange:(CGRect)newBounds NS_AVAILABLE_IOS(7_0)
//{
//	return nil;
//}
//
//- (BOOL)shouldInvalidateLayoutForPreferredLayoutAttributes:(UICollectionViewLayoutAttributes *)preferredAttributes withOriginalAttributes:(UICollectionViewLayoutAttributes *)originalAttributes NS_AVAILABLE_IOS(8_0)
//{
//	return YES;
//}
//
//- (UICollectionViewLayoutInvalidationContext *)invalidationContextForPreferredLayoutAttributes:(UICollectionViewLayoutAttributes *)preferredAttributes withOriginalAttributes:(UICollectionViewLayoutAttributes *)originalAttributes NS_AVAILABLE_IOS(8_0)
//{
//	return nil;
//}
//
//- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity // return a point at which to rest after scrolling - for layouts that want snap-to-point scrolling behavior
//{
//	return CGPointZero;
//}
//
//- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset NS_AVAILABLE_IOS(7_0) // a layout can return the content offset to be applied during transition or update animations
//{
//	return CGPointZero;
//}

- (CGSize)collectionViewContentSize // Subclasses must override this method and use it to return the width and height of the collection view’s content. These values represent the width and height of all the content, not just the content that is currently visible. The collection view uses this information to configure its own content size to facilitate scrolling.
{
	return _layoutContentSize;
}

@end

#pragma mark -

@implementation UICollectionView(Html)

+ (HtmlRenderModel)html_defaultRenderModel
{
	return HtmlRenderModel_Element;
}

- (void)html_applyDom:(SamuraiHtmlDomNode *)dom
{
	[super html_applyDom:dom];

	Class layoutClass = NSClassFromString( [dom.domAttributes objectForKey:@"layout"] );
	if ( layoutClass )
	{
		self.collectionViewLayout = [[layoutClass alloc] init];
	}
	else
	{
		self.collectionViewLayout = [[UICollectionViewLayout_Html alloc] init];
	}

	for ( SamuraiUICollectionViewSection * section in [self collectionViewAgent].sections )
	{
		NSString * isStatic = [section.document.domTree.domAttributes objectForKey:@"is-static"];

		if ( isStatic )
		{
			section.minCount = 1;
			section.maxCount = 1;
		}
		else
		{
			section.minCount = 0;
			section.maxCount = 0;
		}
	}
}

- (void)html_applyStyle:(SamuraiHtmlStyle *)style
{
	[super html_applyStyle:style];

	self.allowsSelection = NO;
	self.allowsMultipleSelection = NO;
}

- (void)html_applyFrame:(CGRect)newFrame
{
	[super html_applyFrame:newFrame];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, UICollectionView_Html )

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
