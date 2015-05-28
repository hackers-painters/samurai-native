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

#import "Samurai_HtmlRenderObjectTable.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "HtmlElement_Table.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

#undef	HTML_TABLE_MAX_ROWS
#define HTML_TABLE_MAX_ROWS		(1024)

#undef	HTML_TABLE_MAX_COLUMNS
#define HTML_TABLE_MAX_COLUMNS	(1024)

#pragma mark -

@implementation SamuraiHtmlRenderObjectTable
{
	NSInteger			_renderMaxRow;
	NSInteger			_renderMaxColumn;
	void *				_renderMap[HTML_TABLE_MAX_ROWS][HTML_TABLE_MAX_COLUMNS];
}

+ (instancetype)renderObjectWithDom:(SamuraiHtmlDomNode *)dom andStyle:(SamuraiHtmlStyle *)style
{
	SamuraiHtmlRenderObjectTable * renderObject = [super renderObjectWithDom:dom andStyle:style];
	
	return renderObject;
}

#pragma mark -

- (id)init
{
	self = [super init];
	if ( self )
	{
		_renderMaxRow = 0;
		_renderMaxColumn = 0;
	}
	return self;
}

- (void)dealloc
{
}

#pragma mark -

+ (Class)defaultViewClass
{
	return [HtmlElement_Table class];
}

#pragma mark -

- (BOOL)store_isValid
{
	return YES;
}

- (BOOL)store_hasChildren
{
	return YES;
}

#pragma mark -

- (void)renderWillLoad
{
	[super renderWillLoad];
}

- (void)renderDidLoad
{
	[super renderDidLoad];

	[self parseTableGroups];
}

#pragma mark -

- (BOOL)layoutShouldWrapLine
{
	return [super layoutShouldWrapLine];
}

- (BOOL)layoutShouldWrapBefore
{
	return [super layoutShouldWrapBefore];
}

- (BOOL)layoutShouldWrapAfter
{
	return [super layoutShouldWrapAfter];
}

- (BOOL)layoutShouldBoundsToWindow
{
	return [super layoutShouldBoundsToWindow];
}

- (BOOL)layoutShouldCenteringInRow
{
	return [super layoutShouldCenteringInRow];
}

- (BOOL)layoutShouldCenteringInCol
{
	return [super layoutShouldCenteringInCol];
}

- (BOOL)layoutShouldPositioningChildren
{
	return [super layoutShouldPositioningChildren];
}

- (BOOL)layoutShouldArrangedInRow
{
	return [super layoutShouldArrangedInRow];
}

- (BOOL)layoutShouldArrangedInCol
{
	return [super layoutShouldArrangedInCol];
}

- (BOOL)layoutShouldArrangedReverse
{
	return [super layoutShouldArrangedReverse];
}

- (BOOL)layoutShouldHorizontalAlign
{
	return [super layoutShouldHorizontalAlign];
}

- (BOOL)layoutShouldHorizontalAlignLeft
{
	return [super layoutShouldHorizontalAlignLeft];
}

- (BOOL)layoutShouldHorizontalAlignRight
{
	return [super layoutShouldHorizontalAlignRight];
}

- (BOOL)layoutShouldHorizontalAlignCenter
{
	return [super layoutShouldHorizontalAlignCenter];
}

- (BOOL)layoutShouldVerticalAlign
{
	return [super layoutShouldVerticalAlign];
}

- (BOOL)layoutShouldVerticalAlignTop
{
	return [super layoutShouldVerticalAlignTop];
}

- (BOOL)layoutShouldVerticalAlignMiddle
{
	return [super layoutShouldVerticalAlignMiddle];
}

- (BOOL)layoutShouldVerticalAlignBottom
{
	return [super layoutShouldVerticalAlignBottom];
}

#pragma mark -

- (void)parseTableGroups
{
	NSMutableArray * thead = [NSMutableArray array];
	NSMutableArray * tbody = [NSMutableArray array];
	NSMutableArray * tfoot = [NSMutableArray array];

	for ( SamuraiHtmlRenderObject * child in self.childs )
	{
		if ( NSOrderedSame == [child.dom.domTag compare:@"thead"] )
		{
			[thead addObjectsFromArray:child.childs];
		}
		else if ( NSOrderedSame == [child.dom.domTag compare:@"tbody"] )
		{
			[tbody addObjectsFromArray:child.childs];
		}
		else if ( NSOrderedSame == [child.dom.domTag compare:@"tfoot"] )
		{
			[tfoot addObjectsFromArray:child.childs];
		}
		else
		{
			[tbody addObject:child];
		}
	}

	NSMutableArray * renderRows = [NSMutableArray array];

	[self parseTableRows:thead toArray:renderRows];
	[self parseTableRows:tbody toArray:renderRows];
	[self parseTableRows:tfoot toArray:renderRows];

	[self parseTableMapFromArray:renderRows];
}

- (void)parseTableRows:(NSArray *)rows toArray:(NSMutableArray *)array
{
	NSMutableArray * plainRow = nil;

	for ( SamuraiHtmlRenderObject * child in rows )
	{
		if ( NSOrderedSame == [child.dom.domTag compare:@"tr"] )
		{
		// row

			plainRow = nil;

			NSMutableArray * row = [NSMutableArray nonRetainingArray];
			
			for ( SamuraiHtmlRenderObject * column in child.childs )
			{
				if ( NSOrderedSame == [column.dom.domTag compare:@"td"] ||
					NSOrderedSame == [column.dom.domTag compare:@"th"] )
				{
					[row addObject:column];
				}
			}

			[array addObject:row];
		}
		else if ( NSOrderedSame == [child.dom.domTag compare:@"td"] ||
				 NSOrderedSame == [child.dom.domTag compare:@"th"] )
		{
		// column

			if ( nil == plainRow )
			{
				plainRow = [NSMutableArray nonRetainingArray];

				[array addObject:plainRow];
			}

			[plainRow addObject:child];
		}
	}
}

- (void)parseTableMapFromArray:(NSArray *)renderRows
{
	_renderMaxRow = 0;
	_renderMaxColumn = 0;

	memset( _renderMap, 0x0, sizeof(_renderMap) );

	for ( NSInteger rowIndex = 0; rowIndex < [renderRows count]; ++rowIndex )
	{
		NSArray * row = [renderRows objectAtIndex:rowIndex];

		for ( NSInteger colIndex = 0; colIndex < [row count]; ++colIndex )
		{
			SamuraiHtmlRenderObject * column = [row objectAtIndex:colIndex];

			column.tableRow = -1;
			column.tableCol = -1;
			
			if ( HtmlRenderDisplay_None == column.display )
			{
				continue;
			}

			NSInteger rowSpan = 1;
			NSInteger colSpan = 1;

			if ( column.dom.rowSpan )
			{
				rowSpan = [column.dom.rowSpan integerValue];
				rowSpan = rowSpan < 1 ? 1 : rowSpan;
			}

			if ( column.dom.colSpan )
			{
				colSpan = [column.dom.colSpan integerValue];
				colSpan = colSpan < 1 ? 1 : colSpan;
			}

			for ( NSInteger r = 0; r < rowSpan; ++r )
			{
				NSInteger sr = rowIndex + r;
				
				for ( NSInteger c = 0; c < colSpan; ++c )
				{
					NSInteger sc = colIndex + c;
					
					for ( NSInteger x = 0; x < HTML_TABLE_MAX_COLUMNS - sc; ++x )
					{
						NSInteger sx = sc + x;
						
						if ( nil == _renderMap[sr][sx] )
						{
							column.tableRow = (-1 == column.tableRow) ? sr : column.tableRow;
							column.tableCol = (-1 == column.tableCol) ? sx : column.tableCol;
							column.tableColSpan = colSpan;
							column.tableRowSpan = rowSpan;
							
							_renderMap[sr][sx] = (__bridge void *)column;
							
							break;
						}
					}
					
					_renderMaxColumn = MAX( column.tableCol + column.tableColSpan, _renderMaxColumn );
				}
				
				_renderMaxRow = MAX( column.tableRow + column.tableRowSpan, _renderMaxRow );
			}
		}
	}
}

#pragma mark -

- (CGRect)computeFrame:(CGSize)bound origin:(CGPoint)origin
{
	DEBUG_RENDERER_LAYOUT( self );
	
	if ( HtmlRenderDisplay_None == self.display )
	{
		return [self zerolizeFrame];
	}
	
// compute min/max size
	
	CGFloat minWidth = INVALID_VALUE;
	CGFloat maxWidth = INVALID_VALUE;
	CGFloat minHeight = INVALID_VALUE;
	CGFloat maxHeight = INVALID_VALUE;
	
	if ( self.style.minWidth )
	{
		minWidth = [self.style.minWidth computeValue:bound.width];
	}
	
	if ( self.style.minHeight )
	{
		minHeight = [self.style.minHeight computeValue:bound.height];
	}
	
	if ( self.style.maxWidth )
	{
		maxWidth = [self.style.maxWidth computeValue:bound.width];
	}
	
	if ( self.style.maxHeight )
	{
		maxHeight = [self.style.maxHeight computeValue:bound.height];
	}
	
// compute width/height
	
	CGSize computedSize = bound;
 
	if ( self.style.width )
	{
		if ( [self.style.width isNumber] )
		{
			computedSize.width = [self.style.width computeValue:bound.width];
		}
	}
	
	if ( self.style.height )
	{
		if ( [self.style.height isNumber] )
		{
			computedSize.height = [self.style.height computeValue:bound.height];
		}
	}
	
// compute function
	
	if ( self.style.width )
	{
		if ( [self.style.width isFunction:@"equals"] )
		{
			NSString * firstParam = [[self.style.width params] firstObject];
			
			if ( [firstParam isEqualToString:@"height"] )
			{
				computedSize.width = computedSize.height;
			}
		}
	}
	
	if ( self.style.height )
	{
		if ( [self.style.height isFunction:@"equals"] )
		{
			NSString * firstParam = [[self.style.height params] firstObject];
			
			if ( [firstParam isEqualToString:@"width"] )
			{
				computedSize.height = computedSize.width;
			}
		}
	}
	
// compute min/max size
	
	if ( self.style.minWidth )
	{
		if ( INVALID_VALUE != minWidth && computedSize.width < minWidth )
		{
			computedSize.width = minWidth;
		}
	}
	
	if ( self.style.minHeight )
	{
		if ( INVALID_VALUE != minHeight && computedSize.height < minHeight )
		{
			computedSize.height = minHeight;
		}
	}
	
	if ( self.style.maxWidth )
	{
		if ( INVALID_VALUE != maxWidth && computedSize.width > maxWidth )
		{
			computedSize.width = maxWidth;
		}
	}
	
	if ( self.style.maxHeight )
	{
		if ( INVALID_VALUE != maxHeight && computedSize.height > maxHeight )
		{
			computedSize.height = maxHeight;
		}
	}

// compute border/margin/padding
	
	UIEdgeInsets computedInset = [self computeInset:computedSize];
	UIEdgeInsets computedBorder = [self computeBorder:computedSize];
	UIEdgeInsets computedMargin = [self computeMargin:computedSize];
	UIEdgeInsets computedPadding = [self computePadding:computedSize];
	
	CGFloat maxColWidths[HTML_TABLE_MAX_ROWS] = { 0.0f };
	CGFloat maxRowHeights[HTML_TABLE_MAX_ROWS] = { 0.0f };

// compute size

	for ( NSInteger rowIndex = 0; rowIndex < _renderMaxRow; ++rowIndex )
	{
		for ( NSInteger colIndex = 0; colIndex < _renderMaxColumn; ++colIndex )
		{
			SamuraiHtmlRenderObject * cell = (__bridge SamuraiHtmlRenderObject *)(_renderMap[rowIndex][colIndex]);

			if ( nil == cell )
				continue;

			if ( cell.tableRow == rowIndex && cell.tableCol == colIndex )
			{
				CGSize cellBound;
				CGRect cellWindow;

				cellBound.width = self.style.maxWidth ? maxWidth : INVALID_VALUE; // computedSize.width;
				cellBound.height = self.style.maxHeight ? maxHeight : INVALID_VALUE; // computedSize.height;

				cellWindow = [cell computeFrame:cellBound origin:CGPointZero];

				if ( cell.tableColSpan <= 1 )
				{
					maxColWidths[colIndex] = fmax( maxColWidths[colIndex], cellWindow.size.width );
				}

				if ( cell.tableRowSpan <= 1 )
				{
					maxRowHeights[rowIndex] = fmax( maxRowHeights[rowIndex], cellWindow.size.height );
				}
			}
		}
	}

// compute size

	CGFloat computedBorderSpacing = [self computeBorderSpacing];

	CGFloat computedCellPadding = [self computeCellPadding];
	CGFloat computedCellSpacing = [self computeCellSpacing];

	CGFloat xOrigin = 0.0f;
	CGFloat yOrigin = 0.0f;

	xOrigin += computedBorder.left;
//	xOrigin += computedMargin.left;
	xOrigin += computedPadding.left;
	xOrigin += computedBorderSpacing;
	xOrigin += computedCellSpacing;

	yOrigin += computedBorder.top;
//	yOrigin += computedMargin.top;
	yOrigin += computedPadding.top;
	yOrigin += computedBorderSpacing;
	yOrigin += computedCellSpacing;

	CGFloat	xOffset = xOrigin;
	CGFloat	yOffset = yOrigin;

	CGSize	maxSize = CGSizeZero;

	for ( NSInteger rowIndex = 0; rowIndex < _renderMaxRow; ++rowIndex )
	{
		for ( NSInteger colIndex = 0; colIndex < _renderMaxColumn; ++colIndex )
		{
			SamuraiHtmlRenderObject * cell = (__bridge SamuraiHtmlRenderObject *)(_renderMap[rowIndex][colIndex]);

			if ( nil == cell )
				continue;
			
			if ( cell.tableRow == rowIndex && cell.tableCol == colIndex )
			{
				CGRect cellFrame = cell.bounds;
				
				cellFrame.origin.x = xOffset;
				cellFrame.origin.y = yOffset;

				cellFrame.size.width = 0.0f;
				cellFrame.size.height = 0.0f;

				for ( NSInteger colSpan = 0; colSpan < cell.tableColSpan; ++colSpan )
				{
					cellFrame.size.width += maxColWidths[colIndex + colSpan];
				}

				for ( NSInteger rowSpan = 0; rowSpan < cell.tableRowSpan; ++rowSpan )
				{
					cellFrame.size.height += maxRowHeights[rowIndex + rowSpan];
				}

				if ( cell.tableColSpan > 1 )
				{
					cellFrame.size.width += (cell.tableColSpan - 1) * computedCellSpacing;
				}

				if ( cell.tableRowSpan > 1 )
				{
					cellFrame.size.height += (cell.tableRowSpan - 1) * computedCellSpacing;
				}

//				cellFrame.size.width = fmax( cellFrame.size.width, cell.bounds.size.width );
//				cellFrame.size.height = fmax( cellFrame.size.height, cell.bounds.size.height );

				cell.bounds = cellFrame;

				xOffset += cellFrame.size.width;
			}
			else
			{
				xOffset = CGRectGetMaxX( cell.bounds );
			}
			
			maxSize.width	= fmax( CGRectGetMaxX( cell.bounds ), maxSize.width );
			maxSize.height	= fmax( CGRectGetMaxY( cell.bounds ), maxSize.height );

			xOffset += computedCellSpacing;
		}

		yOffset += maxRowHeights[rowIndex];
		yOffset += computedCellSpacing;
		
		xOffset = xOrigin;
	}

	maxSize.width += computedBorderSpacing;
	maxSize.width += computedCellSpacing;

	maxSize.height += computedBorderSpacing;
	maxSize.height += computedCellSpacing;

	computedSize.width	= maxSize.width;
	computedSize.height	= maxSize.height;

// compute function
	
	if ( self.style.width )
	{
		if ( [self.style.width isFunction:@"equals"] )
		{
			NSString * firstParam = [[self.style.width params] firstObject];
			
			if ( [firstParam isEqualToString:@"height"] )
			{
				computedSize.width = computedSize.height;
			}
		}
	}

	if ( self.style.height )
	{
		if ( [self.style.height isFunction:@"equals"] )
		{
			NSString * firstParam = [[self.style.height params] firstObject];
			
			if ( [firstParam isEqualToString:@"width"] )
			{
				computedSize.height = computedSize.width;
			}
		}
	}
	
// normalize value
	
	computedSize.width = NORMALIZE_VALUE( computedSize.width );
	computedSize.height = NORMALIZE_VALUE( computedSize.height );
	
// compute min/max size
	
	if ( self.style.minWidth )
	{
		if ( INVALID_VALUE != minWidth && computedSize.width < minWidth )
		{
			computedSize.width = minWidth;
		}
	}
	
	if ( self.style.minHeight )
	{
		if ( INVALID_VALUE != minHeight && computedSize.height < minHeight )
		{
			computedSize.height = minHeight;
		}
	}
	
	if ( self.style.maxWidth )
	{
		if ( INVALID_VALUE != maxWidth && computedSize.width > maxWidth )
		{
			computedSize.width = maxWidth;
		}
	}
	
	if ( self.style.maxHeight )
	{
		if ( INVALID_VALUE != maxHeight && computedSize.height > maxHeight )
		{
			computedSize.height = maxHeight;
		}
	}
	
// compute inset / border / margin /padding
	
	self.inset = computedInset;
	self.border = computedBorder;
	self.margin = computedMargin;
	self.padding = computedPadding;
	
// compute bounds
	
	CGRect computedBounds;
	
	computedBounds.origin = origin;
	
	computedBounds.size.width = computedSize.width;
	computedBounds.size.width += computedPadding.left;
	computedBounds.size.width += computedPadding.right;
	computedBounds.size.width += computedBorder.left;
	computedBounds.size.width += computedBorder.right;
	computedBounds.size.width += computedMargin.left;
	computedBounds.size.width += computedMargin.right;
	
	computedBounds.size.height = computedSize.height;
	computedBounds.size.height += computedPadding.top;
	computedBounds.size.height += computedPadding.bottom;
	computedBounds.size.height += computedBorder.top;
	computedBounds.size.height += computedBorder.bottom;
	computedBounds.size.height += computedMargin.top;
	computedBounds.size.height += computedMargin.bottom;
	
	self.bounds = computedBounds;

	return computedBounds;
}

#pragma mark -

- (id)serialize
{
	return [self.view serialize];
}

- (void)unserialize:(id)obj
{
	[self.view unserialize:obj];
}

- (void)zerolize
{
	[self.view zerolize];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, HtmlRenderObjectTable )

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
