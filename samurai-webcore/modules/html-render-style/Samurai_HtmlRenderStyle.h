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

#import "Samurai_CSSObject.h"
#import "Samurai_CSSArray.h"
#import "Samurai_CSSValue.h"

#import "Samurai_CSSColor.h"
#import "Samurai_CSSFunction.h"
#import "Samurai_CSSString.h"
#import "Samurai_CSSUri.h"

#import "Samurai_CSSNumberAutomatic.h"
#import "Samurai_CSSNumberChs.h"
#import "Samurai_CSSNumberCm.h"
#import "Samurai_CSSNumberDeg.h"
#import "Samurai_CSSNumberDpcm.h"
#import "Samurai_CSSNumberDpi.h"
#import "Samurai_CSSNumberDppx.h"
#import "Samurai_CSSNumberEm.h"
#import "Samurai_CSSNumberQem.h"
#import "Samurai_CSSNumberEx.h"
#import "Samurai_CSSNumberFr.h"
#import "Samurai_CSSNumberGRad.h"
#import "Samurai_CSSNumberHz.h"
#import "Samurai_CSSNumberIn.h"
#import "Samurai_CSSNumberKhz.h"
#import "Samurai_CSSNumberMm.h"
#import "Samurai_CSSNumberMs.h"
#import "Samurai_CSSNumberPc.h"
#import "Samurai_CSSNumberPercentage.h"
#import "Samurai_CSSNumberPt.h"
#import "Samurai_CSSNumberPx.h"
#import "Samurai_CSSNumberQem.h"
#import "Samurai_CSSNumberRad.h"
#import "Samurai_CSSNumberRems.h"
#import "Samurai_CSSNumberS.h"
#import "Samurai_CSSNumberTurn.h"
#import "Samurai_CSSNumberVh.h"
#import "Samurai_CSSNumberVmax.h"
#import "Samurai_CSSNumberVmin.h"
#import "Samurai_CSSNumberVw.h"
#import "Samurai_CSSNumberConstant.h"

#import "Samurai_CSSParser.h"
#import "Samurai_CSSStyleSheet.h"
#import "Samurai_CSSMediaQuery.h"

#pragma mark -

#undef	css_value
#define	css_value( name ) \
		property (nonatomic, strong) SamuraiCSSValue * name

#undef	def_css_value
#define	def_css_value( getter, setter, key ) \
		dynamic getter; \
		- (SamuraiCSSValue *)getter { return [self getCSSValueForKey:key]; } \
		- (void)setter:(SamuraiCSSValue *)value { [self setCSSValue:value forKey:key]; }

#undef	css_array
#define	css_array( name ) \
		property (nonatomic, strong) SamuraiCSSArray * name

#undef	def_css_array
#define	def_css_array( getter, setter, key ) \
		dynamic getter; \
		- (SamuraiCSSArray *)getter { return [self getCSSArrayForKey:key]; } \
		- (void)setter:(SamuraiCSSArray *)array { [self setCSSArray:array forKey:key]; }

#pragma mark -

typedef enum
{
	CSSDisplay_Inherit = 0,			/// 继承自父级
	CSSDisplay_None,				/// 不显示
	CSSDisplay_Block,				/// 块显示
	CSSDisplay_Inline,				/// 行显示
	CSSDisplay_InlineBlock,			/// 行内块显示
	CSSDisplay_Flex,				/// 伸缩显示
	CSSDisplay_InlineFlex,			/// 行内伸缩显示
	CSSDisplay_Grid,				/// 网络显示
	CSSDisplay_InlineGrid,			/// 行内网络显示
	CSSDisplay_ListItem,			/// 列表项
	CSSDisplay_Table,				/// 此元素会作为块级表格来显示（类似 <table>），表格前后带有换行符。
	CSSDisplay_InlineTable,			/// 此元素会作为内联表格来显示（类似 <table>），表格前后没有换行符。
	CSSDisplay_TableRowGroup,		/// 此元素会作为一个或多个行的分组来显示（类似 <tbody>）。
	CSSDisplay_TableHeaderGroup,	/// 此元素会作为一个或多个行的分组来显示（类似 <thead>）。
	CSSDisplay_TableFooterGroup,	/// 此元素会作为一个或多个行的分组来显示（类似 <tfoot>）。
	CSSDisplay_TableRow,			/// 此元素会作为一个表格行显示（类似 <tr>）。
	CSSDisplay_TableColumnGroup,	/// 此元素会作为一个或多个列的分组来显示（类似 <colgroup>）。
	CSSDisplay_TableColumn,			/// 此元素会作为一个单元格列显示（类似 <col>）
	CSSDisplay_TableCell,			/// 此元素会作为一个表格单元格显示（类似 <td> 和 <th>）
	CSSDisplay_TableCaption,		/// 此元素会作为一个表格标题显示（类似 <caption>）

} CSSDisplay;

typedef enum
{
	CSSPosition_Inherit = 0,		/// 继承自父级
	CSSPosition_Static,				/// 默认排版
	CSSPosition_Relative,			/// 相对于当前
	CSSPosition_Absolute,			/// 相对于上级
	CSSPosition_Fixed				/// 相对于屏幕
} CSSPosition;

typedef enum
{
	CSSDirection_Inherit = 0,		/// 继承自父级
	CSSDirection_Row,				/// 水平排版
	CSSDirection_RowReverse,		/// 水平排版（反转）
	CSSDirection_Column,			/// 垂直排版
	CSSDirection_ColumnReverse		/// 垂直排版（反转）
} CSSDirection;

typedef enum
{
	CSSFloating_Inherit = 0,		/// 继承自父级
	CSSFloating_Left,				/// 左浮动
	CSSFloating_None,				/// 非浮动
	CSSFloating_Right				/// 右浮动
} CSSFloating;

typedef enum
{
	CSSClear_Inherit = 0,			/// 继承自父级
	CSSClear_None,					/// 没有浮动
	CSSClear_Left,					/// 清除左浮动
	CSSClear_Right,					/// 清除右浮动
	CSSClear_Both					/// 清除左右浮动
} CSSClear;

typedef enum
{
	CSSWrap_Inherit = 0,			/// 继承自父级
	CSSWrap_NoWrap,					/// 非浮动
	CSSWrap_Wrap,					/// 左浮动
	CSSWrap_WrapReverse				/// 右浮动
} CSSWrap;

typedef enum
{
	CSSWhiteSpace_Inherit = 0,		/// 继承自父级
	CSSWhiteSpace_Normal,			/// 空白会被忽略
	CSSWhiteSpace_Pre,				/// 空白会被保留，其行为方式类似 HTML 中的 <pre> 标签。
	CSSWhiteSpace_NoWrap,			/// 文本不会换行，文本会在在同一行上继续，直到遇到 <br> 标签为止。
	CSSWhiteSpace_PreWrap,			/// 保留空白符序列，但是正常地进行换行。
	CSSWhiteSpace_PreLine,			/// 合并空白符序列，但是保留换行符。
} CSSWhiteSpace;

typedef enum
{
	CSSAlign_Inherit = 0,			/// 继承自父级
	CSSAlign_None,					/// 无效
	CSSAlign_Left,					/// 居左对齐
	CSSAlign_Right,					/// 居右对齐
	CSSAlign_Center					/// 居中对齐
} CSSAlign;

typedef enum
{
	CSSVerticalAlign_Inherit = 0,	/// 继承自父级
	CSSVerticalAlign_None,			/// 无效
	CSSVerticalAlign_Baseline,		/// 默认。元素放置在父元素的基线上
	CSSVerticalAlign_Sub,			/// 垂直对齐文本的下标
	CSSVerticalAlign_Super,			/// 垂直对齐文本的上标
	CSSVerticalAlign_Top,			/// 把元素的顶端与行中最高元素的顶端对齐
	CSSVerticalAlign_TextTop,		/// 把元素的顶端与父元素字体的顶端对齐
	CSSVerticalAlign_Middle,		/// 把此元素放置在父元素的中部
	CSSVerticalAlign_Bottom,		/// 把元素的顶端与行中最低的元素的顶端对齐
	CSSVerticalAlign_TextBottom		/// 把元素的底端与父元素字体的底端对齐
} CSSVerticalAlign;

typedef enum
{
	CSSBorderStyle_Inherit = 0,
	CSSBorderStyle_None,
	CSSBorderStyle_Hidden,
	CSSBorderStyle_Dotted,
	CSSBorderStyle_Dashed,
	CSSBorderStyle_Solid,
	CSSBorderStyle_Double,
	CSSBorderStyle_Groove,
	CSSBorderStyle_Ridge,
	CSSBorderStyle_Inset,
	CSSBorderStyle_Outset
} CSSBorderStyle;

typedef enum
{
	CSSBorderCollapse_Inherit = 0,
	CSSBorderCollapse_Separate,
	CSSBorderCollapse_Collapse,
} CSSBorderCollapse;

typedef enum
{
	CSSViewHierarchy_Inherit = 0,			/// 继承自父级
	CSSViewHierarchy_Leaf,					/// 叶子
	CSSViewHierarchy_Tree,					/// 树
	CSSViewHierarchy_Table,					/// 表
	CSSViewHierarchy_Branch,				/// 分支
	CSSViewHierarchy_Hidden					/// 隐藏
} CSSViewHierarchy;

#pragma mark -

@interface NSObject(RenderStyle)

+ (CSSViewHierarchy)style_viewHierarchy;

@end

#pragma mark -

@interface SamuraiHtmlRenderStyle : SamuraiRenderStyle

@css_value( top );
@css_value( left );
@css_value( right );
@css_value( bottom );

@css_value( width );
@css_value( minWidth );
@css_value( maxWidth );

@css_value( height );
@css_value( minHeight );
@css_value( maxHeight );

@css_value( position );
@css_value( floating );
@css_value( clear );

@css_value( zIndex );
@css_value( display );
@css_value( overflow );
@css_value( visibility );
@css_value( opacity );

@css_value( boxSizing );
@css_array( boxShadow );

@css_value( baseline );
@css_value( wordWrap );
@css_value( contentMode );

@css_value( color );
@css_value( direction );
@css_value( letterSpacing );
@css_value( lineHeight );
@css_value( align );
@css_value( verticalAlign );
@css_value( textAlign );
@css_value( textDecoration );
@css_value( textIndent );
@css_array( textShadow );
@css_value( textTransform );
@css_value( textOverflow );
@css_value( unicodeBidi );
@css_value( whiteSpace );
@css_value( wordSpacing );

// list

@css_array( listStyle );
@css_value( listStyleType );
@css_value( listStyleImage );
@css_value( listStylePosition );

// background

@css_array( background );
@css_value( backgroundColor );
@css_value( backgroundImage );

// flex box

@css_value( flex );
@css_value( flexWrap );
@css_value( flexFlow );
@css_value( flexDirection );

// font

@css_array( font );
@css_array( fontFamily );
@css_value( fontVariant );
@css_value( fontStyle );
@css_value( fontSize );
@css_value( fontWeight );

// border

@css_value( borderCollapse );
@css_value( borderSpacing );

@css_value( cellSpacing );
@css_value( cellPadding );

@css_array( border );
@css_array( borderWidth );
@css_array( borderStyle );
@css_array( borderColor );

@css_array( borderRadius );
@css_array( borderTopLeftRadius );
@css_array( borderTopRightRadius );
@css_array( borderBottomLeftRadius );
@css_array( borderBottomRightRadius );

@css_array( borderTop );
@css_value( borderTopColor );
@css_value( borderTopStyle );
@css_value( borderTopWidth );

@css_array( borderLeft );
@css_value( borderLeftColor );
@css_value( borderLeftStyle );
@css_value( borderLeftWidth );

@css_array( borderRight );
@css_value( borderRightColor );
@css_value( borderRightStyle );
@css_value( borderRightWidth );

@css_array( borderBottom );
@css_value( borderBottomColor );
@css_value( borderBottomStyle );
@css_value( borderBottomWidth );

// margin

@css_array( margin );
@css_value( marginTop );
@css_value( marginLeft );
@css_value( marginRight );
@css_value( marginBottom );

// padding

@css_array( padding );
@css_value( paddingTop );
@css_value( paddingLeft );
@css_value( paddingRight );
@css_value( paddingBottom );

// inset

@css_array( inset );
@css_value( insetTop );
@css_value( insetLeft );
@css_value( insetRight );
@css_value( insetBottom );

// custom

@css_value( webkitMarginBefore );
@css_value( webkitMarginAfter );
@css_value( webkitMarginStart );
@css_value( webkitMarginEnd );

@css_value( webkitPaddingBefore );
@css_value( webkitPaddingAfter );
@css_value( webkitPaddingStart );
@css_value( webkitPaddingEnd );

@css_value( samuraiViewHierarchy );
@css_value( samuraiViewClass );

#pragma mark -

- (SamuraiCSSValue *)getCSSValueForKey:(NSString *)key;
- (SamuraiCSSArray *)getCSSArrayForKey:(NSString *)key;

- (void)setCSSValue:(SamuraiCSSValue *)value forKey:(NSString *)key;
- (void)setCSSArray:(SamuraiCSSArray *)array forKey:(NSString *)key;

#pragma mark -

- (BOOL)isAutoWidth;
- (BOOL)isAutoHeight;

- (BOOL)isFixedWidth;
- (BOOL)isFixedHeight;

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

- (CSSWrap)computeWrap:(CSSWrap)defaultValue;
- (CSSAlign)computeAlign:(CSSAlign)defaultValue;
- (CSSClear)computeClear:(CSSClear)defaultValue;
- (CSSDisplay)computeDisplay:(CSSDisplay)defaultValue;
- (CSSFloating)computeFloating:(CSSFloating)defaultValue;
- (CSSPosition)computePosition:(CSSPosition)defaultValue;
- (CSSDirection)computeDirection:(CSSDirection)defaultValue;
- (CSSWhiteSpace)computeWhiteSpace:(CSSWhiteSpace)defaultValue;
- (CSSVerticalAlign)computeVerticalAlign:(CSSVerticalAlign)defaultValue;
- (CSSViewHierarchy)computeViewHierarchy:(CSSViewHierarchy)defaultValue;
- (CSSBorderCollapse)computeBorderCollapse:(CSSBorderCollapse)defaultValue;

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

- (CSSBorderStyle)computeBorderTopStyle:(CSSBorderStyle)style;
- (CSSBorderStyle)computeBorderLeftStyle:(CSSBorderStyle)style;
- (CSSBorderStyle)computeBorderRightStyle:(CSSBorderStyle)style;
- (CSSBorderStyle)computeBorderBottomStyle:(CSSBorderStyle)style;

- (CGFloat)computeBorderTopLeftRadius:(CGFloat)bounds defaultRadius:(CGFloat)defaultRadius;
- (CGFloat)computeBorderTopRightRadius:(CGFloat)bounds defaultRadius:(CGFloat)defaultRadius;
- (CGFloat)computeBorderBottomLeftRadius:(CGFloat)bounds defaultRadius:(CGFloat)defaultRadius;
- (CGFloat)computeBorderBottomRightRadius:(CGFloat)bounds defaultRadius:(CGFloat)defaultRadius;

- (CGFloat)computeBorderSpacing:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeCellSpacing:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeCellPadding:(CGFloat)bounds defaultSize:(CGFloat)defaultSize;

- (CGFloat)computeLineHeight:(CGFloat)fontHeight defaultSize:(CGFloat)defaultSize;
- (CGFloat)computeLetterSpacing:(CGFloat)defaultSize;

- (CGFloat)computeZIndex:(CGFloat)defaultIndex;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
