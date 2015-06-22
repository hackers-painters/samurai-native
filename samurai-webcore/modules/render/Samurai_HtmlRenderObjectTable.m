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

#import "Samurai_HtmlRenderScope.h"
#import "Samurai_HtmlRenderStore.h"

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
	NSInteger	_renderMaxRow;
	NSInteger	_renderMaxColumn;
	
	__unsafe_unretained id	_renderRows[HTML_TABLE_MAX_ROWS];
	__unsafe_unretained id	_renderBlocks[HTML_TABLE_MAX_ROWS][HTML_TABLE_MAX_COLUMNS];
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

- (UIView *)createViewWithIdentifier:(NSString *)identifier
{
	return [super createViewWithIdentifier:identifier];
}

#pragma mark -

- (BOOL)html_hasChildren
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

	[self parseTableStructure];
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

- (BOOL)layoutShouldAutoSizing
{
	return [super layoutShouldAutoSizing];
}

- (BOOL)layoutShouldCenteringInRow
{
	return [super layoutShouldCenteringInRow];
}

- (BOOL)layoutShouldCenteringInCol
{
	return [super layoutShouldCenteringInCol];
}

- (BOOL)layoutShouldLeftJustifiedInRow
{
	return [super layoutShouldLeftJustifiedInRow];
}

- (BOOL)layoutShouldRightJustifiedInRow
{
	return [super layoutShouldRightJustifiedInRow];
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

- (void)parseTableStructure
{
	_renderMaxRow = 0;
	_renderMaxColumn = 0;
	
	memset( _renderRows, 0x0, sizeof(_renderRows) );
	memset( _renderBlocks, 0x0, sizeof(_renderBlocks) );

	NSMutableArray * thead = [NSMutableArray array];
	NSMutableArray * tbody = [NSMutableArray array];
	NSMutableArray * tfoot = [NSMutableArray array];
	NSMutableArray * groups = [NSMutableArray array];

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
	
	[groups addObjectsFromArray:thead];
	[groups addObjectsFromArray:tbody];
	[groups addObjectsFromArray:tfoot];

	NSMutableArray * rows = [NSMutableArray array];
	NSMutableArray * tr = nil;
	
	for ( SamuraiHtmlRenderObject * child in groups )
	{
		if ( NSOrderedSame == [child.dom.domTag compare:@"tr"] )
		{
			// row
			
			tr = [NSMutableArray nonRetainingArray];
			
			for ( SamuraiHtmlRenderObject * column in child.childs )
			{
				if ( NSOrderedSame == [column.dom.domTag compare:@"td"] || NSOrderedSame == [column.dom.domTag compare:@"th"] )
				{
					[tr addObject:column];
				}
			}
			
			[rows addObject:tr];

			tr = nil;
		}
		else if ( NSOrderedSame == [child.dom.domTag compare:@"td"] || NSOrderedSame == [child.dom.domTag compare:@"th"] )
		{
			// column

			if ( nil == tr )
			{
				tr = [NSMutableArray nonRetainingArray];
				
				[rows addObject:tr];
			}

			[tr addObject:child];
		}
	}
	
	for ( NSInteger rowIndex = 0; rowIndex < [rows count]; ++rowIndex )
	{
		NSArray * row = [rows objectAtIndex:rowIndex];
		
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
						
						if ( nil == _renderBlocks[sr][sx] )
						{
							column.tableRow = (-1 == column.tableRow) ? sr : column.tableRow;
							column.tableCol = (-1 == column.tableCol) ? sx : column.tableCol;
							column.tableColSpan = colSpan;
							column.tableRowSpan = rowSpan;
							
							_renderBlocks[sr][sx] = column;
							
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

- (CGRect)layoutWithContext:(SamuraiHtmlLayoutContext *)context
			  parentContext:(SamuraiHtmlLayoutContext *)parentContext
{
	DEBUG_RENDERER_LAYOUT( self );
	
	htmlLayoutInit( context );
	
	if ( HtmlRenderDisplay_None != self.display )
	{
		htmlLayoutBegin( context );

		CGSize relSize = CGSizeMake( context->computedSize.width, context->computedSize.height );
		
		if ( INVALID_VALUE == relSize.width )
		{
			relSize.width = context->bounds.width;
		}
		
	//	if ( INVALID_VALUE == relSize.height )
	//	{
	//		relSize.height = context.bound.height;
	//	}
		
		CGFloat maxColWidths[HTML_TABLE_MAX_ROWS] = { 0.0f };
		CGFloat maxRowHeights[HTML_TABLE_MAX_ROWS] = { 0.0f };

		for ( NSInteger rowIndex = 0; rowIndex < _renderMaxRow; ++rowIndex )
		{
			for ( NSInteger colIndex = 0; colIndex < _renderMaxColumn; ++colIndex )
			{
				SamuraiHtmlRenderObject * cell = _renderBlocks[rowIndex][colIndex];

				if ( nil == cell )
					continue;

				if ( cell.tableRow == rowIndex && cell.tableCol == colIndex )
				{
					CGSize cellBound;
					CGRect cellWindow;

					cellBound.width = (INVALID_VALUE != context->computedMaxWidth) ? context->computedMaxWidth : relSize.width; // INVALID_VALUE; // computedSize.width;
					cellBound.height = (INVALID_VALUE != context->computedMaxHeight) ? context->computedMaxHeight : relSize.height; // INVALID_VALUE; // computedSize.height;

					SamuraiHtmlLayoutContext cellContext = {
						.style		= cell.style,
						.bounds		= cellBound,
						.origin		= CGPointZero,
						.collapse	= UIEdgeInsetsZero
					};

					cellWindow = [cell layoutWithContext:&cellContext parentContext:context];

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

		htmlComputeBorderSpacing( context );
		htmlComputeCellPadding( context );
		htmlComputeCellSpacing( context );

		CGFloat xOrigin = 0.0f;
		CGFloat yOrigin = 0.0f;

		xOrigin += context->computedBorder.left;
	//	xOrigin += context->computedMargin.left;
		xOrigin += context->computedPadding.left;
		xOrigin += context->computedBorderSpacing;
		xOrigin += context->computedCellSpacing;

		yOrigin += context->computedBorder.top;
	//	yOrigin += context->computedMargin.top;
		yOrigin += context->computedPadding.top;
		yOrigin += context->computedBorderSpacing;
		yOrigin += context->computedCellSpacing;

		CGFloat	xOffset = xOrigin;
		CGFloat	yOffset = yOrigin;

		CGSize	contentSize = CGSizeZero;

		for ( NSInteger rowIndex = 0; rowIndex < _renderMaxRow; ++rowIndex )
		{
			for ( NSInteger colIndex = 0; colIndex < _renderMaxColumn; ++colIndex )
			{
				SamuraiHtmlRenderObject * tableCell = _renderBlocks[rowIndex][colIndex];

				if ( nil == tableCell )
					continue;
				
				if ( tableCell.tableRow == rowIndex && tableCell.tableCol == colIndex )
				{
					CGRect cellFrame = tableCell.bounds;
					
					cellFrame.origin.x = xOffset;
					cellFrame.origin.y = yOffset;

					cellFrame.size.width = 0.0f;
					cellFrame.size.height = 0.0f;

					for ( NSInteger colSpan = 0; colSpan < tableCell.tableColSpan; ++colSpan )
					{
						cellFrame.size.width += maxColWidths[colIndex + colSpan];
					}

					for ( NSInteger rowSpan = 0; rowSpan < tableCell.tableRowSpan; ++rowSpan )
					{
						cellFrame.size.height += maxRowHeights[rowIndex + rowSpan];
					}

					if ( tableCell.tableColSpan > 1 )
					{
						cellFrame.size.width += (tableCell.tableColSpan - 1) * context->computedCellSpacing;
					}

					if ( tableCell.tableRowSpan > 1 )
					{
						cellFrame.size.height += (tableCell.tableRowSpan - 1) * context->computedCellSpacing;
					}

					cellFrame.size.width	= fmax( cellFrame.size.width, tableCell.bounds.size.width );
					cellFrame.size.height	= fmax( cellFrame.size.height, tableCell.bounds.size.height );

					tableCell.bounds = cellFrame;

					xOffset += cellFrame.size.width;
				}
				else
				{
					xOffset = CGRectGetMaxX( tableCell.bounds );
				}
				
				contentSize.width	= fmax( CGRectGetMaxX( tableCell.bounds ), contentSize.width );
				contentSize.height	= fmax( CGRectGetMaxY( tableCell.bounds ), contentSize.height );

				xOffset += context->computedCellSpacing;
			}

			yOffset += maxRowHeights[rowIndex];
			yOffset += context->computedCellSpacing;
			
			xOffset = xOrigin;
		}

		contentSize.width += context->computedBorderSpacing;
		contentSize.width += context->computedCellSpacing;

		contentSize.height += context->computedBorderSpacing;
		contentSize.height += context->computedCellSpacing;

		htmlLayoutResize( context, contentSize );
		htmlLayoutFinish( context );
	}
	
	self.lines		= 1;
	self.start		= CGPointMake( CGRectGetMinX( context->computedBounds ), CGRectGetMinY( context->computedBounds ) );
	self.end		= CGPointMake( CGRectGetMaxX( context->computedBounds ), CGRectGetMinY( context->computedBounds ) );

	self.inset		= context->computedInset;
	self.border		= context->computedBorder;
	self.margin		= context->computedMargin;
	self.padding	= context->computedPadding;
	self.bounds		= context->computedBounds;
	
	return self.bounds;
}

#pragma mark -

- (id)html_serialize
{
	TODO( "html_serialize" );
	
	return [self.view html_serialize];
}

- (void)html_unserialize:(id)obj
{
	TODO( "html_unserialize" );
	
	[self.view html_unserialize:obj];
}

- (void)html_zerolize
{
	TODO( "html_zerolize" );

	[self.view html_zerolize];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlRenderObjectTable )

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
