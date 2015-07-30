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

#import "Samurai_HtmlDocument.h"
#import "Samurai_HtmlRenderStyle.h"
#import "Samurai_HtmlRenderObject.h"
#import "Samurai_HtmlRenderStoreScope.h"

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

@interface __HtmlCollectionViewSection : SamuraiUICollectionViewSection

@prop_assign( NSUInteger,				minCount );
@prop_assign( NSUInteger,				maxCount );
@prop_strong( NSObject *,				cachedData );
@prop_strong( NSMutableDictionary *,	cachedHeight );

@prop_assign( NSUInteger,				index );
@prop_strong( SamuraiDocument *,		document );
@prop_unsafe( UICollectionView *,		collectionView );
@prop_strong( NSString *,				reuseIdentifier );

- (BOOL)parseDocument:(SamuraiHtmlDocument *)document;

@end

#pragma mark -

@implementation __HtmlCollectionViewSection

@def_prop_assign( NSUInteger,				minCount );
@def_prop_assign( NSUInteger,				maxCount );
@def_prop_strong( NSObject *,				cachedData );
@def_prop_strong( NSMutableDictionary *,	cachedHeight );

@def_prop_assign( NSUInteger,				index );
@def_prop_strong( SamuraiDocument *,		document );
@def_prop_unsafe( UICollectionView *,		collectionView );
@def_prop_strong( NSString *,				reuseIdentifier );

#pragma mark -

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.minCount = 0;
		self.maxCount = 0;
		self.cachedHeight = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)dealloc
{
	self.cachedData = nil;
	self.cachedHeight = nil;
	
	self.document = nil;
	self.collectionView = nil;
	self.reuseIdentifier = nil;
}

#pragma mark -

- (BOOL)parseDocument:(SamuraiHtmlDocument *)document
{
	BOOL parseSucceed = [document parse];
	if ( NO == parseSucceed )
	{
		ERROR( @"Failed to parse collection section" );
		return nil;
	}
	
	BOOL reflowSucceed = [document reflow];
	if ( NO == reflowSucceed )
	{
		ERROR( @"Failed to reflow collection section" );
		return nil;
	}
	
	if ( [UICollectionViewCell class] != document.renderTree.viewClass && NO == [document.renderTree.viewClass isSubclassOfClass:[UICollectionViewCell class]] )
	{
		ERROR( @"Invalid collection cell class" );
		return NO;
	}

	self.document = document;
	self.reuseIdentifier = [NSString stringWithFormat:@"%@-%@", document.domTree.tag, document.renderTree.id];
	
	NSString * isStatic = ((SamuraiHtmlDomNode *)self.document.domTree).attrIsStatic;
	
	if ( isStatic )
	{
		self.minCount = 1;
		self.maxCount = 1;
	}
	else
	{
		self.minCount = 0;
		self.maxCount = 0;
	}
	
	if ( self.document.renderTree.viewClass )
	{
		[self.collectionView registerClass:self.document.renderTree.viewClass forCellWithReuseIdentifier:self.reuseIdentifier];
//		[self.collectionView registerClass:self.document.renderTree.viewClass forSupplementaryViewOfKind: withReuseIdentifier:self.reuseIdentifier];
	}

	return YES;
}

#pragma mark -

- (CGSize)getSizeForRowAtIndexPath:(NSIndexPath *)indexPath byBounds:(CGSize)bounds
{
	if ( CGRectEqualToRect( self.collectionView.frame, CGRectZero ) )
	{
		return CGSizeZero;
	}

	NSString *	cachedKey = [NSString stringWithFormat:@"%ld-%ld", (long)indexPath.section, (long)indexPath.row];
	NSValue *	cachedSize = [self.cachedHeight objectForKey:cachedKey];
	
	if ( cachedSize )
	{
		return [cachedSize CGSizeValue];
	}
	
// alloc cell

	UICollectionViewCell * collectionViewCell = (UICollectionViewCell *)self.document.renderTree.view;
	
	if ( nil == collectionViewCell )
	{
		collectionViewCell = (UICollectionViewCell *)[self.document.renderTree createViewWithIdentifier:nil];
	}

	ASSERT( nil != collectionViewCell );

	[collectionViewCell.renderer bindView:collectionViewCell];
	[collectionViewCell.renderer bindOutletsTo:collectionViewCell];
	[collectionViewCell.renderer restyle];
	[collectionViewCell.renderer rechain];

// update data
	
	NSObject * data = [self getDataForRowAtIndexPath:indexPath];
	
	if ( data )
	{
		[collectionViewCell store_unserialize:data];
	}
//	else
//	{
//		[collectionViewCell store_zerolize];
//	}

// compute size

	CGSize cellSize = [collectionViewCell.renderer computeSize:bounds];

	[self.cachedHeight setObject:[NSValue valueWithCGSize:cellSize] forKey:cachedKey];

	return cellSize;
}

- (NSUInteger)getRowCount
{
	if ( nil == self.document || nil == self.document.domTree || nil == self.document.renderTree )
	{
		return 0;
	}
	
	NSUInteger count = 0;
	
	if ( [self.cachedData isKindOfClass:[NSArray class]] || [self.cachedData conformsToProtocol:@protocol(NSArrayProtocol)] )
	{
		count = [(NSArray *)self.cachedData count];
	}
	
	if ( self.maxCount )
	{
		count = MIN( count, self.maxCount );
	}
	
	if ( self.minCount )
	{
		count = MAX( count, self.minCount );
	}
	
	return count;
}

- (NSObject *)getDataForRowAtIndexPath:(NSIndexPath *)indexPath
{
	ASSERT( indexPath );
	
	if ( self.cachedData )
	{
		if ( [self.cachedData isKindOfClass:[NSArray class]] || [self.cachedData conformsToProtocol:@protocol(NSArrayProtocol)] )
		{
			if ( indexPath.row >= [(NSArray *)self.cachedData count] )
			{
				return nil;
			}
			else
			{
				NSInteger row = indexPath.row;
				
				return [(NSArray *)self.cachedData objectAtIndex:row];
			}
		}
		else
		{
			return self.cachedData;
		}
	}
	
	return nil;
}

- (UICollectionViewCell *)getCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	ASSERT( indexPath );
	
// alloc cell
	
	UICollectionViewCell * collectionViewCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:self.reuseIdentifier forIndexPath:indexPath];

	if ( collectionViewCell )
	{
		PERF( @"UICollectionView '%p', reusing cell '%@' for row #%d", self, self.reuseIdentifier, indexPath.row );

		if ( nil == collectionViewCell.renderer )
		{
			collectionViewCell.renderer = [self.document.renderTree clone];

			[self.collectionView.renderer appendNode:collectionViewCell.renderer];
		}
	}

	ASSERT( nil != collectionViewCell );
	
	[collectionViewCell.renderer bindView:collectionViewCell];
	[collectionViewCell.renderer bindOutletsTo:collectionViewCell];
	[collectionViewCell.renderer restyle];
	[collectionViewCell.renderer rechain];

// update data
	
	NSObject * data = [self getDataForRowAtIndexPath:indexPath];
	
	if ( data )
	{
		[collectionViewCell store_unserialize:data];
	}
//	else
//	{
//		[collectionViewCell store_zerolize];
//	}		
	
	return collectionViewCell;
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

@interface __HtmlCollectionViewItem : NSObject

@prop_strong( UICollectionViewLayoutAttributes *,		attributes );
@prop_unsafe( __HtmlCollectionViewItem *,				prev );
@prop_unsafe( __HtmlCollectionViewItem *,				next );

@prop_strong( NSIndexPath *,							indexPath );
@prop_assign( NSInteger,								type );
@prop_assign( NSInteger,								line );
@prop_assign( CGRect,									frame );

@prop_assign( NSInteger,								estimatedSpan );
@prop_assign( CGSize,									estimatedSize );

@end

#pragma mark -

@implementation __HtmlCollectionViewItem

@def_prop_strong( UICollectionViewLayoutAttributes *,	attributes );
@def_prop_unsafe( __HtmlCollectionViewItem *,			prev );
@def_prop_unsafe( __HtmlCollectionViewItem *,			next );

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

@interface __HtmlCollectionViewLayout : UICollectionViewLayout
@end

#pragma mark -

@implementation __HtmlCollectionViewLayout
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
	SamuraiUICollectionViewAgent * agent = [self.collectionView collectionViewAgent];
	
	CGSize viewBounds = self.collectionView.frame.size;
	if ( CGSizeEqualToSize(viewBounds, CGSizeZero) )
		return;
	
	[self resetLayout];
	
	// Compute size
	
	NSString * columnCount = ((SamuraiHtmlDomNode *)self.collectionView.renderer.dom).attrColumns;
	
	if ( columnCount )
	{
		_layoutColumnCount = [columnCount integerValue];
		_layoutColumnCount = (_layoutColumnCount > 0) ? _layoutColumnCount : 1;
	}
	
	NSString * isVertical = ((SamuraiHtmlDomNode *)self.collectionView.renderer.dom).attrIsVertical;
	NSString * isHorizontal = ((SamuraiHtmlDomNode *)self.collectionView.renderer.dom).attrIsHorizontal;
	
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
	
	for ( __HtmlCollectionViewSection * section in agent.sections )
	{
		NSUInteger rowCount = [section getRowCount];
		if ( 0 == rowCount )
			continue;
		
		NSString *	isStickTop = ((SamuraiHtmlDomNode *)section.document.domTree).attrStickTop;
		NSString *	isStickBottom = ((SamuraiHtmlDomNode *)section.document.domTree).attrStickBottom;
		
		NSString *	isFixedTop = ((SamuraiHtmlDomNode *)section.document.domTree).attrFixedTop;
		NSString *	isFixedBottom = ((SamuraiHtmlDomNode *)section.document.domTree).attrFixedBottom;
		
		NSString *	isCol = ((SamuraiHtmlDomNode *)section.document.domTree).attrIsColumn;
		NSString *	isRow = ((SamuraiHtmlDomNode *)section.document.domTree).attrIsRow;
		
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
			__HtmlCollectionViewItem * currItem = [[__HtmlCollectionViewItem alloc] init];
			
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
					currItem.estimatedSize = [section getSizeForRowAtIndexPath:currItem.indexPath byWidth:viewBounds.width];
				//	currItem.estimatedSize = [section getSizeForRowAtIndexPath:currItem.indexPath byHeight:viewBounds.height];
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
					currItem.estimatedSize = [section getSizeForRowAtIndexPath:currItem.indexPath byWidth:_layoutColumnWidth];
				//	currItem.estimatedSize = [section getSizeForRowAtIndexPath:currItem.indexPath byHeight:_layoutColumnWidth];
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
				__HtmlCollectionViewItem * lastItem = (__HtmlCollectionViewItem *)[_layoutStickTop lastObject];
				
				currItem.prev = lastItem;
				lastItem.next = currItem;
				
				[_layoutStickTop addObject:currItem];
			}
			else if ( isStickBottom )
			{
				__HtmlCollectionViewItem * lastItem = (__HtmlCollectionViewItem *)[_layoutStickBottom lastObject];
				
				currItem.prev = lastItem;
				lastItem.next = currItem;
				
				[_layoutStickBottom addObject:currItem];
			}
			
			if ( isFixedTop )
			{
				__HtmlCollectionViewItem * lastItem = (__HtmlCollectionViewItem *)[_layoutFixedTop lastObject];
				
				currItem.prev = lastItem;
				lastItem.next = currItem;
				
				[_layoutFixedTop addObject:currItem];
			}
			else if ( isFixedBottom )
			{
				__HtmlCollectionViewItem * lastItem = (__HtmlCollectionViewItem *)[_layoutFixedBottom lastObject];
				
				currItem.prev = lastItem;
				lastItem.next = currItem;
				
				[_layoutFixedBottom addObject:currItem];
			}
			
			[_layoutItems addObject:currItem];
		}
	}
	
	// Layout items
	
	for ( __HtmlCollectionViewItem * item in _layoutItems )
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
				for ( __HtmlCollectionViewItem * prevItem in _layoutItems )
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
		for ( __HtmlCollectionViewItem * item in _layoutStickTop )
		{
			CGRect itemFrame = item.frame;
			
			if ( itemFrame.origin.y < contentOffset.y )
			{
				itemFrame.origin.y = contentOffset.y;
			}
			
			item.attributes.zIndex = 1;
			item.attributes.frame = itemFrame;
		}
		
		__HtmlCollectionViewItem * currItem = [_layoutStickTop lastObject];
		
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
		
		for ( __HtmlCollectionViewItem * item in _layoutFixedTop )
		{
			CGRect itemFrame = item.frame;
			
			itemFrame.origin.y = contentOffset.y;
			
			item.attributes.zIndex = 2;
			item.attributes.frame = itemFrame;
		}
	}
	else if ( LAYOUT_DIRECTION_HORIZONTAL == _layoutDirection )
	{
		for ( __HtmlCollectionViewItem * item in _layoutStickTop )
		{
			CGRect itemFrame = item.frame;
			
			if ( itemFrame.origin.x < contentOffset.x )
			{
				itemFrame.origin.x = contentOffset.x;
			}
			
			item.attributes.zIndex = 1;
			item.attributes.frame = itemFrame;
		}
		
		__HtmlCollectionViewItem * currItem = [_layoutStickTop lastObject];
		
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
		
		for ( __HtmlCollectionViewItem * item in _layoutFixedTop )
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

+ (CSSViewHierarchy)style_viewHierarchy
{
	return CSSViewHierarchy_Leaf;
}

#pragma mark -

- (void)html_applyDom:(SamuraiHtmlDomNode *)dom
{
	[super html_applyDom:dom];

	[self html_parseLayout:dom];
	[self html_parseSections:dom];
}

- (void)html_applyStyle:(SamuraiHtmlRenderStyle *)style
{
	[super html_applyStyle:style];

//	self.allowsSelection = NO;
//	self.allowsMultipleSelection = NO;
}

- (void)html_applyFrame:(CGRect)newFrame
{
	[super html_applyFrame:newFrame];

	NSString * isVertical = ((SamuraiHtmlDomNode *)self.renderer.dom).attrIsVertical;
	NSString * isHorizontal = ((SamuraiHtmlDomNode *)self.renderer.dom).attrIsHorizontal;

	if ( isVertical )
	{
		self.alwaysBounceVertical = YES;
		self.showsVerticalScrollIndicator = NO;
		
		self.alwaysBounceHorizontal = NO;
		self.showsHorizontalScrollIndicator = NO;
		
		self.bounces = YES;
		self.scrollEnabled = YES;
	}
	else if ( isHorizontal )
	{
		self.alwaysBounceVertical = NO;
		self.showsVerticalScrollIndicator = NO;
		
		self.alwaysBounceHorizontal = YES;
		self.showsHorizontalScrollIndicator = NO;
		
		self.bounces = YES;
		self.scrollEnabled = YES;
	}
	else
	{
		self.alwaysBounceVertical = YES;
		self.showsVerticalScrollIndicator = NO;
		
		self.alwaysBounceHorizontal = NO;
		self.showsHorizontalScrollIndicator = NO;
		
		self.bounces = YES;
		self.scrollEnabled = YES;
	}
}

#pragma mark -

- (void)html_parseLayout:(SamuraiHtmlDomNode *)rootDom
{
	Class layoutClass = NSClassFromString( rootDom.attrLayout );

	if ( layoutClass )
	{
		self.collectionViewLayout = [[layoutClass alloc] init];
	}
	else
	{
		self.collectionViewLayout = [[__HtmlCollectionViewLayout alloc] init];
	}
}

- (void)html_parseSections:(SamuraiHtmlDomNode *)rootDom
{
	SamuraiUICollectionViewAgent * agent = [self collectionViewAgent];
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
				
				__HtmlCollectionViewSection * section = [[__HtmlCollectionViewSection alloc] init];

				section.index = [agent.sections count];
				section.collectionView = self;

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
	
	SamuraiUICollectionViewAgent * agent = [self collectionViewAgent];
	if ( agent )
	{
//		if ( 1 == [agent.sections count] )
//		{
//			return [[agent.sections firstObject] store_serialize];
//		}
//		else
//		{
			NSMutableDictionary * dict = [NSMutableDictionary dictionary];
			
			for ( __HtmlCollectionViewSection * section in agent.sections )
			{
				NSString * sectionKey = nil;
				NSString * sectionData = nil;
				
				if ( ((SamuraiHtmlDomNode *)section.document.domTree).attrName )
				{
					sectionKey = ((SamuraiHtmlDomNode *)section.document.domTree).attrName;
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
	
	SamuraiUICollectionViewAgent * agent = [self collectionViewAgent];
	if ( agent )
	{
//		if ( 1 == [agent.sections count] )
//		{
//			[[agent.sections firstObject] store_unserialize:obj];
//		}
//		else
//		{
			for ( __HtmlCollectionViewSection * section in agent.sections )
			{
				NSString * sectionKey = nil;
				NSString * sectionData = nil;
				
				if ( ((SamuraiHtmlDomNode *)section.document.domTree).attrName )
				{
					sectionKey = ((SamuraiHtmlDomNode *)section.document.domTree).attrName;
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
//		}
	}
	
	[self reloadData];
}

- (void)store_zerolize
{
	[super store_zerolize];
	
	SamuraiUICollectionViewAgent * agent = [self collectionViewAgent];
	if ( agent )
	{
		for ( __HtmlCollectionViewSection * section in agent.sections )
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

TEST_CASE( WebCore, UICollectionView_Html )

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
