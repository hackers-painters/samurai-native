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

#import "Samurai.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_HtmlStyleObject.h"

#import "Samurai_HtmlBox.h"
#import "Samurai_HtmlArray.h"
#import "Samurai_HtmlSize.h"
#import "Samurai_HtmlValue.h"
#import "Samurai_HtmlColor.h"
#import "Samurai_HtmlFunction.h"
#import "Samurai_HtmlNumber.h"
#import "Samurai_HtmlNumberAutomatic.h"
#import "Samurai_HtmlNumberCm.h"
#import "Samurai_HtmlNumberConstant.h"
#import "Samurai_HtmlNumberEm.h"
#import "Samurai_HtmlNumberEx.h"
#import "Samurai_HtmlNumberIn.h"
#import "Samurai_HtmlNumberMm.h"
#import "Samurai_HtmlNumberPc.h"
#import "Samurai_HtmlNumberPercentage.h"
#import "Samurai_HtmlNumberPt.h"
#import "Samurai_HtmlNumberPx.h"
#import "Samurai_HtmlString.h"
#import "Samurai_HtmlUrl.h"

#pragma mark -

// object

#undef	html_style_object
#define	html_style_object( type, name ) \
		property (nonatomic, strong) type * name

#undef	def_html_style_object
#define	def_html_style_object( type, getter, setter, key ) \
		dynamic getter; \
		- (type *)getter { return [self propertyForKey:key withClass:[type class]]; } \
		- (void)setter:(type *)value { [self setProperty:value forKey:key withClass:[type class]]; }

// number | color | function | string

#undef	html_style_value
#define	html_style_value( name ) \
		html_style_object( SamuraiHtmlValue, name )

#undef	def_html_style_value
#define	def_html_style_value( getter, setter, key ) \
		def_html_style_object( SamuraiHtmlValue, getter, setter, key )

// number

#undef	html_style_number
#define	html_style_number( name ) \
		html_style_object( SamuraiHtmlNumber, name )

#undef	def_html_style_number
#define	def_html_style_number( getter, setter, key ) \
		def_html_style_object( SamuraiHtmlNumber, getter, setter, key )

// color

#undef	html_style_color
#define	html_style_color( name ) \
		html_style_object( SamuraiHtmlColor, name )

#undef	def_html_style_color
#define	def_html_style_color( getter, setter, key ) \
		def_html_style_object( SamuraiHtmlColor, getter, setter, key )

// function

#undef	html_style_function
#define	html_style_function( name ) \
		html_style_object( SamuraiHtmlFunction, name )

#undef	def_html_style_function
#define	def_html_style_function( getter, setter, key ) \
		def_html_style_object( SamuraiHtmlFunction, getter, setter, key )

// string

#undef	html_style_string
#define	html_style_string( name ) \
		html_style_object( SamuraiHtmlString, name )

#undef	def_html_style_string
#define	def_html_style_string( getter, setter, key ) \
		def_html_style_object( SamuraiHtmlString, getter, setter, key )

// box

#undef	html_style_box
#define	html_style_box( name ) \
		html_style_object( SamuraiHtmlBox, name )

#undef	def_html_style_box
#define	def_html_style_box( getter, setter, key ) \
		def_html_style_object( SamuraiHtmlBox, getter, setter, key )

// list

#undef	html_style_array
#define	html_style_array( name ) \
		html_style_object( SamuraiHtmlArray, name )

#undef	def_html_style_array
#define	def_html_style_array( getter, setter, key ) \
		def_html_style_object( SamuraiHtmlArray, getter, setter, key )

// size

#undef	html_style_size
#define	html_style_size( name ) \
		html_style_object( SamuraiHtmlSize, name )

#undef	def_html_style_size
#define	def_html_style_size( getter, setter, key ) \
		def_html_style_object( SamuraiHtmlSize, getter, setter, key )

#pragma mark -

typedef enum
{
	HtmlRenderDisplay_Inherit = 0,		/// 继承自父级
	HtmlRenderDisplay_None,				/// 不显示
	HtmlRenderDisplay_Block,			/// 块显示
	HtmlRenderDisplay_Inline,			/// 行显示
	HtmlRenderDisplay_InlineBlock,		/// 行内块显示
	HtmlRenderDisplay_Flex,				/// 伸缩显示
	HtmlRenderDisplay_InlineFlex,		/// 行内伸缩显示

	HtmlRenderDisplay_ListItem,			/// 列表项
	
	HtmlRenderDisplay_Table,			/// 此元素会作为块级表格来显示（类似 <table>），表格前后带有换行符。
	HtmlRenderDisplay_InlineTable,		/// 此元素会作为内联表格来显示（类似 <table>），表格前后没有换行符。
	HtmlRenderDisplay_TableRowGroup,	/// 此元素会作为一个或多个行的分组来显示（类似 <tbody>）。
	HtmlRenderDisplay_TableHeaderGroup,	/// 此元素会作为一个或多个行的分组来显示（类似 <thead>）。
	HtmlRenderDisplay_TableFooterGroup,	/// 此元素会作为一个或多个行的分组来显示（类似 <tfoot>）。
	HtmlRenderDisplay_TableRow,			/// 此元素会作为一个表格行显示（类似 <tr>）。
	HtmlRenderDisplay_TableColumnGroup,	/// 此元素会作为一个或多个列的分组来显示（类似 <colgroup>）。
	HtmlRenderDisplay_TableColumn,		/// 此元素会作为一个单元格列显示（类似 <col>）
	HtmlRenderDisplay_TableCell,		/// 此元素会作为一个表格单元格显示（类似 <td> 和 <th>）
	HtmlRenderDisplay_TableCaption,		/// 此元素会作为一个表格标题显示（类似 <caption>）

} HtmlRenderDisplay;

typedef enum
{
	HtmlRenderPosition_Inherit = 0,		/// 继承自父级
	HtmlRenderPosition_Static,			/// 默认排版
	HtmlRenderPosition_Relative,		/// 相对于当前
	HtmlRenderPosition_Absolute,		/// 相对于上级
	HtmlRenderPosition_Fixed			/// 相对于屏幕
} HtmlRenderPosition;

typedef enum
{
	HtmlRenderDirection_Inherit = 0,	/// 继承自父级
	HtmlRenderDirection_Row,			/// 水平排版
	HtmlRenderDirection_RowReverse,		/// 水平排版（反转）
	HtmlRenderDirection_Column,			/// 垂直排版
	HtmlRenderDirection_ColumnReverse	/// 垂直排版（反转）
} HtmlRenderDirection;

typedef enum
{
	HtmlRenderFloating_Inherit = 0,		/// 继承自父级
	HtmlRenderFloating_Left,			/// 左浮动
	HtmlRenderFloating_None,			/// 非浮动
	HtmlRenderFloating_Right			/// 右浮动
} HtmlRenderFloating;

typedef enum
{
	HtmlRenderClear_None = 0,		/// 继承自父级
	HtmlRenderClear_Left,			/// 左浮动
	HtmlRenderClear_Right,			/// 非浮动
	HtmlRenderClear_Both			/// 右浮动
} HtmlRenderClear;

typedef enum
{
	HtmlRenderWrap_Inherit = 0,			/// 继承自父级
	HtmlRenderWrap_NoWrap,				/// 非浮动
	HtmlRenderWrap_Wrap,				/// 左浮动
	HtmlRenderWrap_WrapReverse			/// 右浮动
} HtmlRenderWrap;

typedef enum
{
	HtmlRenderAlign_Inherit = 0,		/// 继承自父级
	HtmlRenderAlign_None,				/// 无效
	HtmlRenderAlign_Left,				/// 居左对齐
	HtmlRenderAlign_Right,				/// 居右对齐
	HtmlRenderAlign_Center				/// 居中对齐
} HtmlRenderAlign;

typedef enum
{
	HtmlRenderVerticalAlign_Inherit = 0,		/// 继承自父级
	HtmlRenderVerticalAlign_None,				/// 无效
	HtmlRenderVerticalAlign_Baseline,			/// 默认。元素放置在父元素的基线上
	HtmlRenderVerticalAlign_Sub,				/// 垂直对齐文本的下标
	HtmlRenderVerticalAlign_Super,				/// 垂直对齐文本的上标
	HtmlRenderVerticalAlign_Top,				/// 把元素的顶端与行中最高元素的顶端对齐
	HtmlRenderVerticalAlign_TextTop,			/// 把元素的顶端与父元素字体的顶端对齐
	HtmlRenderVerticalAlign_Middle,				/// 把此元素放置在父元素的中部
	HtmlRenderVerticalAlign_Bottom,				/// 把元素的顶端与行中最低的元素的顶端对齐
	HtmlRenderVerticalAlign_TextBottom			/// 把元素的底端与父元素字体的底端对齐
} HtmlRenderVerticalAlign;

typedef enum
{
	HtmlRenderBorderStyle_Inherit = 0,
	HtmlRenderBorderStyle_None,
	HtmlRenderBorderStyle_Hidden,
	HtmlRenderBorderStyle_Dotted,
	HtmlRenderBorderStyle_Dashed,
	HtmlRenderBorderStyle_Solid,
	HtmlRenderBorderStyle_Double,
	HtmlRenderBorderStyle_Groove,
	HtmlRenderBorderStyle_Ridge,
	HtmlRenderBorderStyle_Inset,
	HtmlRenderBorderStyle_Outset
} HtmlRenderBorderStyle;

#pragma mark -

@interface SamuraiHtmlStyle : SamuraiRenderStyle

@html_style_value( top );
@html_style_value( left );
@html_style_value( right );
@html_style_value( bottom );

@html_style_value( width );
@html_style_value( minWidth );
@html_style_value( maxWidth );

@html_style_value( height );
@html_style_value( minHeight );
@html_style_value( maxHeight );

@html_style_value( position );
@html_style_value( floating );
@html_style_value( clear );

@html_style_value( zIndex );
@html_style_value( display );
@html_style_value( overflow );
@html_style_value( visibility );
@html_style_value( opacity );

@html_style_value( boxSizing );
@html_style_array( boxShadow );

@html_style_value( baseline );
@html_style_value( wordWrap );
@html_style_value( contentMode );

@html_style_value( color );
@html_style_value( direction );
@html_style_value( letterSpacing );
@html_style_value( lineHeight );
@html_style_value( align );
@html_style_value( verticalAlign );
@html_style_value( textAlign );
@html_style_value( textDecoration );
@html_style_value( textIndent );
@html_style_array( textShadow );
@html_style_value( textTransform );
@html_style_value( textOverflow );
@html_style_value( unicodeBidi );
@html_style_value( whiteSpace );
@html_style_value( wordSpacing );

// list

@html_style_value( listStyleType );
@html_style_value( listStyleImage );
@html_style_value( listStylePosition );

// background

@html_style_array( background );
@html_style_value( backgroundColor );
@html_style_value( backgroundImage );

// flex box

@html_style_value( flex );
@html_style_value( flexWrap );
@html_style_value( flexFlow );
@html_style_value( flexDirection );

// font

@html_style_array( font );
@html_style_array( fontFamily );
@html_style_value( fontVariant );
@html_style_value( fontStyle );
@html_style_value( fontSize );
@html_style_value( fontWeight );

// border

@html_style_value( borderCollapse );
@html_style_value( borderSpacing );

@html_style_value( cellSpacing );
@html_style_value( cellPadding );

@html_style_array( border );
@html_style_box( borderWidth );
@html_style_box( borderStyle );
@html_style_box( borderColor );

@html_style_array( borderRadius );
@html_style_array( borderTopLeftRadius );
@html_style_array( borderTopRightRadius );
@html_style_array( borderBottomLeftRadius );
@html_style_array( borderBottomRightRadius );

@html_style_array( borderTop );
@html_style_value( borderTopColor );
@html_style_value( borderTopStyle );
@html_style_value( borderTopWidth );

@html_style_array( borderLeft );
@html_style_value( borderLeftColor );
@html_style_value( borderLeftStyle );
@html_style_value( borderLeftWidth );

@html_style_array( borderRight );
@html_style_value( borderRightColor );
@html_style_value( borderRightStyle );
@html_style_value( borderRightWidth );

@html_style_array( borderBottom );
@html_style_value( borderBottomColor );
@html_style_value( borderBottomStyle );
@html_style_value( borderBottomWidth );

// margin

@html_style_box( margin );
@html_style_value( marginTop );
@html_style_value( marginLeft );
@html_style_value( marginRight );
@html_style_value( marginBottom );

// padding

@html_style_box( padding );
@html_style_value( paddingTop );
@html_style_value( paddingLeft );
@html_style_value( paddingRight );
@html_style_value( paddingBottom );

// inset

@html_style_box( inset );
@html_style_value( insetTop );
@html_style_value( insetLeft );
@html_style_value( insetRight );
@html_style_value( insetBottom );

// custom

@html_style_value( webkitMarginBefore );
@html_style_value( webkitMarginAfter );
@html_style_value( webkitMarginStart );
@html_style_value( webkitMarginEnd );

@html_style_value( webkitPaddingBefore );
@html_style_value( webkitPaddingAfter );
@html_style_value( webkitPaddingStart );
@html_style_value( webkitPaddingEnd );

@html_style_string( samuraiRenderModel );
@html_style_string( samuraiRenderClass );

#pragma mark -

- (id)propertyForKey:(NSString *)key;
- (id)propertyForKey:(NSString *)key withClass:(Class)classType;

- (void)setProperty:(id)object forKey:(NSString *)key;
- (void)setProperty:(id)object forKey:(NSString *)key withClass:(Class)classType;

- (BOOL)isAutoWidth;
- (BOOL)isAutoHeight;

- (BOOL)isWidthEqualsToHeight;
- (BOOL)isHeightEqualsToWidth;

- (BOOL)isAutoMarginTop;
- (BOOL)isAutoMarginLeft;
- (BOOL)isAutoMarginRight;
- (BOOL)isAutoMarginBottom;

- (UIFont *)computeFont:(UIFont *)defaultFont;
- (UIColor *)computeColor:(UIColor *)defaultColor;
- (NSTextAlignment)computeTextAlignment:(NSTextAlignment)defaultMode;
- (NSLineBreakMode)computeLineBreakMode:(NSLineBreakMode)defaultMode;
- (UIViewContentMode)computeContentMode:(UIViewContentMode)defaultMode;
- (UIBaselineAdjustment)computeBaselineAdjustment:(UIBaselineAdjustment)defaultMode;
- (UITextDecoration)computeTextDecoration:(UITextDecoration)defaultDecoration;

- (HtmlRenderWrap)computeWrap:(HtmlRenderWrap)defaultValue;
- (HtmlRenderAlign)computeAlign:(HtmlRenderAlign)defaultValue;
- (HtmlRenderClear)computeClear:(HtmlRenderClear)defaultValue;
- (HtmlRenderDisplay)computeDisplay:(HtmlRenderDisplay)defaultValue;
- (HtmlRenderFloating)computeFloating:(HtmlRenderFloating)defaultValue;
- (HtmlRenderPosition)computePosition:(HtmlRenderPosition)defaultValue;
- (HtmlRenderDirection)computeDirection:(HtmlRenderDirection)defaultValue;
- (HtmlRenderVerticalAlign)computeVerticalAlign:(HtmlRenderVerticalAlign)defaultValue;

- (CGFloat)computeTop:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeLeft:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeRight:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeBottom:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;

- (CGFloat)computeWidth:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeHeight:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;

- (CGFloat)computeMinWidth:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeMaxWidth:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeMinHeight:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeMaxHeight:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;

- (CGFloat)computeInsetTopSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeInsetLeftSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeInsetRightSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeInsetBottomSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;

- (CGFloat)computePaddingTopSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computePaddingLeftSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computePaddingRightSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computePaddingBottomSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;

- (CGFloat)computeMarginTopSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeMarginLeftSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeMarginRightSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeMarginBottomSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;

- (UIColor *)computeBorderTopColor:(UIColor *)defaultColor;
- (UIColor *)computeBorderLeftColor:(UIColor *)defaultColor;
- (UIColor *)computeBorderRightColor:(UIColor *)defaultColor;
- (UIColor *)computeBorderBottomColor:(UIColor *)defaultColor;

- (CGFloat)computeBorderTopSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeBorderLeftSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeBorderRightSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeBorderBottomSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;

- (HtmlRenderBorderStyle)computeBorderTopStyle:(HtmlRenderBorderStyle)style;
- (HtmlRenderBorderStyle)computeBorderLeftStyle:(HtmlRenderBorderStyle)style;
- (HtmlRenderBorderStyle)computeBorderRightStyle:(HtmlRenderBorderStyle)style;
- (HtmlRenderBorderStyle)computeBorderBottomStyle:(HtmlRenderBorderStyle)style;

- (CGFloat)computeBorderTopLeftRadius:(CGFloat)bounds defaultRadius:(CGFloat)defaultRadius;
- (CGFloat)computeBorderTopRightRadius:(CGFloat)bounds defaultRadius:(CGFloat)defaultRadius;
- (CGFloat)computeBorderBottomLeftRadius:(CGFloat)bounds defaultRadius:(CGFloat)defaultRadius;
- (CGFloat)computeBorderBottomRightRadius:(CGFloat)bounds defaultRadius:(CGFloat)defaultRadius;

- (CGFloat)computeBorderSpacing:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeCellSpacing:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeCellPadding:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;

- (CGFloat)computeLineHeight:(CGFloat)fontHeight defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeLetterSpacing:(CGFloat)defaultSize;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
