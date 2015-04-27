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

#import "Samurai_UIConfig.h"
#import "Samurai_ViewCore.h"

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
#import "Samurai_HtmlNumberDp.h"
#import "Samurai_HtmlNumberEm.h"
#import "Samurai_HtmlNumberPercentage.h"
#import "Samurai_HtmlNumberPx.h"
#import "Samurai_HtmlNumberConstant.h"
#import "Samurai_HtmlString.h"
#import "Samurai_HtmlUrl.h"

#pragma mark -

// object

#undef	html_object
#define	html_object( type, name ) \
		property (nonatomic, strong) type * name

#undef	def_html_object
#define	def_html_object( type, getter, setter, key ) \
		dynamic getter; \
		- (type *)getter { return [self propertyForKey:key withClass:[type class]]; } \
		- (void)setter:(type *)value { [self setProperty:value forKey:key withClass:[type class]]; }

// number | color | function | string

#undef	html_value
#define	html_value( name ) \
		html_object( SamuraiHtmlValue, name )

#undef	def_html_value
#define	def_html_value( getter, setter, key ) \
		def_html_object( SamuraiHtmlValue, getter, setter, key )

// number

#undef	html_number
#define	html_number( name ) \
		html_object( SamuraiHtmlNumber, name )

#undef	def_html_number
#define	def_html_number( getter, setter, key ) \
		def_html_object( SamuraiHtmlNumber, getter, setter, key )

// color

#undef	html_color
#define	html_color( name ) \
		html_object( SamuraiHtmlColor, name )

#undef	def_html_color
#define	def_html_color( getter, setter, key ) \
		def_html_object( SamuraiHtmlColor, getter, setter, key )

// function

#undef	html_function
#define	html_function( name ) \
		html_object( SamuraiHtmlFunction, name )

#undef	def_html_function
#define	def_html_function( getter, setter, key ) \
		def_html_object( SamuraiHtmlFunction, getter, setter, key )

// string

#undef	html_string
#define	html_string( name ) \
		html_object( SamuraiHtmlString, name )

#undef	def_html_string
#define	def_html_string( getter, setter, key ) \
		def_html_object( SamuraiHtmlString, getter, setter, key )

// box

#undef	html_box
#define	html_box( name ) \
		html_object( SamuraiHtmlBox, name )

#undef	def_html_box
#define	def_html_box( getter, setter, key ) \
		def_html_object( SamuraiHtmlBox, getter, setter, key )

// list

#undef	html_array
#define	html_array( name ) \
		html_object( SamuraiHtmlArray, name )

#undef	def_html_array
#define	def_html_array( getter, setter, key ) \
		def_html_object( SamuraiHtmlArray, getter, setter, key )

// size

#undef	html_size
#define	html_size( name ) \
		html_object( SamuraiHtmlSize, name )

#undef	def_html_size
#define	def_html_size( getter, setter, key ) \
		def_html_object( SamuraiHtmlSize, getter, setter, key )

#pragma mark -

typedef enum
{
	RenderDisplay_Inherit = 0,		/// 继承自父级
	RenderDisplay_None,				/// 不显示
	RenderDisplay_Block,			/// 块显示
	RenderDisplay_Inline,			/// 行显示
	RenderDisplay_InlineBlock,		/// 行内块显示
	RenderDisplay_Flex,				/// 伸缩显示
	RenderDisplay_InlineFlex		/// 行内伸缩显示
} RenderDisplay;

typedef enum
{
	RenderPosition_Inherit = 0,		/// 继承自父级
	RenderPosition_Static,			/// 默认排版
	RenderPosition_Relative,		/// 相对于当前
	RenderPosition_Absolute,		/// 相对于上级
	RenderPosition_Fixed			/// 相对于屏幕
} RenderPosition;

typedef enum
{
	RenderDirection_Inherit = 0,	/// 继承自父级
	RenderDirection_Row,			/// 水平排版
	RenderDirection_RowReverse,		/// 水平排版（反转）
	RenderDirection_Column,			/// 垂直排版
	RenderDirection_ColumnReverse	/// 垂直排版（反转）
} RenderDirection;

typedef enum
{
	RenderFloating_Inherit = 0,		/// 继承自父级
	RenderFloating_None,			/// 非浮动
	RenderFloating_Left,			/// 左浮动
	RenderFloating_Right			/// 右浮动
} RenderFloating;

typedef enum
{
	RenderWrap_Inherit = 0,			/// 继承自父级
	RenderWrap_NoWrap,				/// 非浮动
	RenderWrap_Wrap,				/// 左浮动
	RenderWrap_WrapReverse			/// 右浮动
} RenderWrap;

#pragma mark -

@interface SamuraiHtmlStyle : SamuraiRenderStyle

@html_value( top );
@html_value( left );
@html_value( right );
@html_value( bottom );

@html_value( width );
@html_value( minWidth );
@html_value( maxWidth );

@html_value( height );
@html_value( minHeight );
@html_value( maxHeight );

@html_value( position );
@html_value( floating );

@html_value( display );
@html_value( overflow );
@html_value( visibility );
@html_value( opacity );

@html_array( boxShadow );

@html_value( baseline );
@html_value( wordWrap );
@html_value( contentMode );

@html_value( color );
@html_value( direction );
@html_value( letterSpacing );
@html_value( lineHeight );
@html_value( textAlign );
@html_value( textDecoration );
@html_value( textIndent );
@html_array( textShadow );
@html_value( textTransform );
@html_value( textOverflow );
@html_value( unicodeBidi );
@html_value( whiteSpace );
@html_value( wordSpacing );

// background

@html_array( background );
@html_value( backgroundColor );
@html_value( backgroundImage );

// flex box

@html_value( flex );
@html_value( flexWrap );
@html_value( flexFlow );
@html_value( flexDirection );

// font

@html_array( font );
@html_array( fontFamily );
@html_value( fontVariant );
@html_value( fontStyle );
@html_value( fontSize );
@html_value( fontWeight );

// border

@html_array( border );
@html_value( borderWidth );
@html_value( borderStyle );
@html_value( borderColor );

@html_value( borderRadius );
@html_value( borderTopLeftRadius );
@html_value( borderTopRightRadius );
@html_value( borderBottomLeftRadius );
@html_value( borderBottomRightRadius );

@html_value( borderTop );
@html_value( borderTopColor );
@html_value( borderTopStyle );
@html_value( borderTopWidth );

@html_value( borderLeft );
@html_value( borderLeftColor );
@html_value( borderLeftStyle );
@html_value( borderLeftWidth );

@html_value( borderRight );
@html_value( borderRightColor );
@html_value( borderRightStyle );
@html_value( borderRightWidth );

@html_value( borderBottom );
@html_value( borderBottomColor );
@html_value( borderBottomStyle );
@html_value( borderBottomWidth );

// margin

@html_box( margin );
@html_value( marginTop );
@html_value( marginLeft );
@html_value( marginRight );
@html_value( marginBottom );

// padding

@html_box( padding );
@html_value( paddingTop );
@html_value( paddingLeft );
@html_value( paddingRight );
@html_value( paddingBottom );

// inset

@html_box( inset );
@html_value( insetTop );
@html_value( insetLeft );
@html_value( insetRight );
@html_value( insetBottom );

// render

@html_string( renderModel );
@html_string( renderClass );

#pragma mark -

- (id)propertyForKey:(NSString *)key;
- (id)propertyForKey:(NSString *)key withClass:(Class)classType;

- (void)setProperty:(id)object forKey:(NSString *)key;
- (void)setProperty:(id)object forKey:(NSString *)key withClass:(Class)classType;

- (BOOL)isAutoWidth;
- (BOOL)isAutoHeight;

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

- (RenderWrap)computeWrap:(RenderWrap)defaultValue;
- (RenderDisplay)computeDisplay:(RenderDisplay)defaultValue;
- (RenderFloating)computeFloating:(RenderFloating)defaultValue;
- (RenderPosition)computePosition:(RenderPosition)defaultValue;
- (RenderDirection)computeDirection:(RenderDirection)defaultValue;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
