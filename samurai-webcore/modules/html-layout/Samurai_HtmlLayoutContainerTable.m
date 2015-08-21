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

#import "Samurai_HtmlLayoutContainerTable.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

#undef	HTML_TABLE_MAX_ROWS
#define HTML_TABLE_MAX_ROWS	(128)

#undef	HTML_TABLE_MAX_COLS
#define HTML_TABLE_MAX_COLS	(128)

#pragma mark -

@implementation SamuraiHtmlLayoutContainerTable
{
	BOOL					_layoutParsed;
	NSInteger				_layoutMaxRow;
	NSInteger				_layoutMaxCol;
	__unsafe_unretained id	_layoutBlocks[HTML_TABLE_MAX_ROWS][HTML_TABLE_MAX_COLS];
	CGFloat					_layoutWidths[HTML_TABLE_MAX_COLS];
	CGFloat					_layoutHeights[HTML_TABLE_MAX_ROWS];
}

#pragma mark -

- (id)init
{
	self = [super init];
	if ( self )
	{
		_layoutMaxRow = 0;
		_layoutMaxCol = 0;
	}
	return self;
}

- (void)dealloc
{
}

#pragma mark -

- (void)parseTableStructure
{
	if ( _layoutParsed )
		return;
	
	_layoutMaxRow = 0;
	_layoutMaxCol = 0;
	
	memset( _layoutBlocks, 0x0, sizeof(_layoutBlocks) );
	memset( _layoutWidths, 0x0, sizeof(_layoutWidths) );
	memset( _layoutHeights, 0x0, sizeof(_layoutHeights) );
	
	NSMutableArray * thead = [NSMutableArray array];
	NSMutableArray * tbody = [NSMutableArray array];
	NSMutableArray * tfoot = [NSMutableArray array];
	NSMutableArray * groups = [NSMutableArray array];
	
	for ( SamuraiHtmlRenderObject * child in self.source.childs )
	{
		if ( NSOrderedSame == [child.dom.tag compare:@"thead"] )
		{
			[thead addObjectsFromArray:child.childs];
		}
		else if ( NSOrderedSame == [child.dom.tag compare:@"tbody"] )
		{
			[tbody addObjectsFromArray:child.childs];
		}
		else if ( NSOrderedSame == [child.dom.tag compare:@"tfoot"] )
		{
			[tfoot addObjectsFromArray:child.childs];
		}
		else
		{
			[tbody addObject:child];
		}
	}
	
	[groups addObjectsFromArray:thead];
	[groups addObjectsFromArray:tbody];
	[groups addObjectsFromArray:tfoot];
	
	NSMutableArray * rows = [NSMutableArray array];
	NSMutableArray * tr = nil;
	
	for ( SamuraiHtmlRenderObject * child in groups )
	{
		if ( NSOrderedSame == [child.dom.tag compare:@"tr"] )
		{
			// row
			
			tr = [NSMutableArray array];
			
			for ( SamuraiHtmlRenderObject * column in child.childs )
			{
				if ( NSOrderedSame == [column.dom.tag compare:@"td"] || NSOrderedSame == [column.dom.tag compare:@"th"] )
				{
					[tr addObject:column];
				}
			}
			
			[rows addObject:tr];
			
			tr = nil;
		}
		else if ( NSOrderedSame == [child.dom.tag compare:@"td"] || NSOrderedSame == [child.dom.tag compare:@"th"] )
		{
			// column
			
			if ( nil == tr )
			{
				tr = [NSMutableArray array];
				
				[rows addObject:tr];
			}
			
			[tr addObject:child];
		}
	}
	
	for ( NSUInteger rowIndex = 0; rowIndex < [rows count]; ++rowIndex )
	{
		NSArray * row = [rows objectAtIndex:rowIndex];
		
		for ( NSUInteger colIndex = 0; colIndex < [row count]; ++colIndex )
		{
			SamuraiHtmlRenderObject * column = [row objectAtIndex:colIndex];
			
			column.tableRow = -1;
			column.tableCol = -1;
			
			if ( CSSDisplay_None == column.display )
			{
				continue;
			}
			
			NSInteger rowSpan = 1;
			NSInteger colSpan = 1;
			
			NSString * domRowSpan = column.dom.attrRowSpan;
			NSString * domColSpan = column.dom.attrColSpan;
			
			if ( domRowSpan )
			{
				rowSpan = [domRowSpan integerValue];
				rowSpan = rowSpan < 1 ? 1 : rowSpan;
			}
			
			if ( domColSpan )
			{
				colSpan = [domColSpan integerValue];
				colSpan = colSpan < 1 ? 1 : colSpan;
			}
			
			for ( NSInteger r = 0; r < rowSpan; ++r )
			{
				NSInteger sr = rowIndex + r;
				
				for ( NSInteger c = 0; c < colSpan; ++c )
				{
					NSInteger sc = colIndex + c;
					
					for ( NSInteger x = 0; x < HTML_TABLE_MAX_COLS - sc; ++x )
					{
						NSInteger sx = sc + x;
						
						if ( nil == _layoutBlocks[sr][sx] )
						{
							column.tableRow = (-1 == column.tableRow) ? sr : column.tableRow;
							column.tableCol = (-1 == column.tableCol) ? sx : column.tableCol;
							column.tableColSpan = colSpan;
							column.tableRowSpan = rowSpan;
							
							_layoutBlocks[sr][sx] = column;
							
							break;
						}
					}
					
					_layoutMaxCol = MAX( column.tableCol + column.tableColSpan, _layoutMaxCol );
				}
				
				_layoutMaxRow = MAX( column.tableRow + column.tableRowSpan, _layoutMaxRow );
			}
		}
	}
	
	_layoutParsed = YES;
}

#pragma mark -

- (void)layout
{
	DEBUG_RENDERER_LAYOUT( self.source );
	
	[self parseTableStructure];
	
	CGSize relSize = CGSizeMake( self.computedSize.width, self.computedSize.height );
	
	if ( INVALID_VALUE == relSize.width )
	{
		relSize.width = self.bounds.width;
	}

//	if ( INVALID_VALUE == relSize.height )
//	{
//		relSize.height = self.bound.height;
//	}
	
	CGSize cellBounds;

	if ( INVALID_VALUE != self.stretch.width )
	{
		cellBounds.width = self.stretch.width;
	}
	else
	{
		cellBounds.width = (INVALID_VALUE != self.computedMaxWidth) ? self.computedMaxWidth : relSize.width;
	}
	
	if ( INVALID_VALUE != self.stretch.height )
	{
		cellBounds.height = self.stretch.height;
	}
	else
	{
		cellBounds.height = (INVALID_VALUE != self.computedMaxHeight) ? self.computedMaxHeight : relSize.height;
	}

	if ( INVALID_VALUE != self.computedMinWidth && cellBounds.width < self.computedMinWidth )
	{
		cellBounds.width = self.computedMinWidth;
	}
	
	if ( INVALID_VALUE != self.computedMinHeight && cellBounds.height < self.computedMinHeight )
	{
		cellBounds.height = self.computedMinHeight;
	}
	
	if ( INVALID_VALUE != self.computedMaxWidth && cellBounds.width > self.computedMaxWidth )
	{
		cellBounds.width = self.computedMaxWidth;
	}
	
	if ( INVALID_VALUE != self.computedMaxHeight && cellBounds.height > self.computedMaxHeight )
	{
		cellBounds.height = self.computedMaxHeight;
	}
	
	for ( NSInteger rowIndex = 0; rowIndex < _layoutMaxRow; ++rowIndex )
	{
		for ( NSInteger colIndex = 0; colIndex < _layoutMaxCol; ++colIndex )
		{
			SamuraiHtmlRenderObject * tableCell = _layoutBlocks[rowIndex][colIndex];
			
			if ( nil == tableCell )
				continue;
			
			if ( tableCell.tableRow == rowIndex && tableCell.tableCol == colIndex )
			{
				tableCell.layout.bounds		= cellBounds;
				tableCell.layout.origin		= CGPointZero;
				tableCell.layout.stretch	= CGSizeMake( INVALID_VALUE, INVALID_VALUE );
				tableCell.layout.collapse	= UIEdgeInsetsZero;
				
				if ( [tableCell.layout begin:YES] )
				{
					if ( [tableCell.childs count] )
					{
						[tableCell.layout layout];
					}
					else
					{
						[tableCell.layout resize:CGSizeZero];
					}

					[tableCell.layout finish];
				}
				
				if ( tableCell.tableColSpan <= 1 )
				{
					_layoutWidths[colIndex] = fmax( _layoutWidths[colIndex], tableCell.layout.computedBounds.size.width );
				}
				
				if ( tableCell.tableRowSpan <= 1 )
				{
					_layoutHeights[rowIndex] = fmax( _layoutHeights[rowIndex], tableCell.layout.computedBounds.size.height );
				}
			}
		}
	}
	
	CGFloat xOrigin = 0.0f;
	CGFloat yOrigin = 0.0f;
	
	xOrigin += self.computedBorder.left;
//	xOrigin += self.computedMargin.left;
	xOrigin += self.computedPadding.left;
	xOrigin += self.computedCellSpacing;
	xOrigin += self.computedBorderSpacing;
	
	yOrigin += self.computedBorder.top;
//	yOrigin += self.computedMargin.top;
	yOrigin += self.computedPadding.top;
	yOrigin += self.computedCellSpacing;
	yOrigin += self.computedBorderSpacing;
	
	CGFloat	xOffset = xOrigin;
	CGFloat	yOffset = yOrigin;
	
	CGSize	contentSize = CGSizeZero;
	
	for ( NSInteger rowIndex = 0; rowIndex < _layoutMaxRow; ++rowIndex )
	{
		for ( NSInteger colIndex = 0; colIndex < _layoutMaxCol; ++colIndex )
		{
			SamuraiHtmlRenderObject * tableCell = _layoutBlocks[rowIndex][colIndex];
			
			if ( nil == tableCell )
				continue;
			
			if ( tableCell.tableRow == rowIndex && tableCell.tableCol == colIndex )
			{
				if ( [tableCell.layout begin:NO] )
				{
					CGPoint	cellOffset = CGPointZero;
					CGSize cellSize = CGSizeZero;
					
					cellOffset.x = xOffset;
					cellOffset.y = yOffset;
					
					for ( NSInteger colSpan = 0; colSpan < tableCell.tableColSpan; ++colSpan )
					{
						cellSize.width += _layoutWidths[colIndex + colSpan];
					}
					
					for ( NSInteger rowSpan = 0; rowSpan < tableCell.tableRowSpan; ++rowSpan )
					{
						cellSize.height += _layoutHeights[rowIndex + rowSpan];
					}
					
					if ( tableCell.tableColSpan > 1 )
					{
						cellSize.width += (tableCell.tableColSpan - 1) * self.computedCellSpacing;
					}
					
					if ( tableCell.tableRowSpan > 1 )
					{
						cellSize.height += (tableCell.tableRowSpan - 1) * self.computedCellSpacing;
					}
					
					cellSize.width = fmax( cellSize.width, tableCell.layout.computedBounds.size.width );
					cellSize.height = fmax( cellSize.height, tableCell.layout.computedBounds.size.height );
					
					[tableCell.layout offset:cellOffset];
					[tableCell.layout resize:cellSize];
					[tableCell.layout finish];
				}
				
				xOffset += tableCell.layout.computedBounds.size.width;
				xOffset += self.computedCellSpacing;
			}
			else
			{
				xOffset = CGRectGetMaxX( tableCell.layout.computedBounds );
				xOffset += self.computedCellSpacing;
			}
		}
		
		yOffset += _layoutHeights[rowIndex];
		yOffset += self.computedCellSpacing;
		
		contentSize.width = fmax( xOffset, contentSize.width );
		contentSize.height = fmax( yOffset, contentSize.height );
		
		xOffset = xOrigin;
	}

//	contentSize.width += self.computedBorderSpacing;
//	contentSize.width += self.computedCellSpacing;

//	contentSize.height += self.computedBorderSpacing;
//	contentSize.height += self.computedCellSpacing;

	[self resize:contentSize];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlLayoutContainerTable )

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
