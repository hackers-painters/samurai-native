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

#import "Samurai_HtmlRenderStyle.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_HtmlUserAgent.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@interface SamuraiCSSObject(Border)

- (BOOL)isBorderSize;
- (BOOL)isBorderStyle;

- (CGFloat)computeBorderSize:(CGFloat)bounds;
- (CSSBorderStyle)computeBorderStyle:(CSSBorderStyle)defaultStyle;

@end

#pragma mark -

@implementation SamuraiCSSObject(Border)

- (BOOL)isBorderSize
{
	if ( [self isNumber] )
	{
		return YES;
	}
	else if ( [self inStrings:@[@"thin", @"medium", @"thick"]] )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)isBorderStyle
{
	if ( [self inStrings:@[@"none", @"hidden", @"dotted", @"dashed", @"solid", @"double", @"groove", @"ridge", @"inset", @"outset", @"inherit"]] )
	{
		return YES;
	}

	return NO;
}

- (CGFloat)computeBorderSize:(CGFloat)bounds
{
	if ( [self isNumber] )
	{
		return [self computeValue:bounds];
	}
	else if ( [self isString:@"thin"] )
	{
		return [SamuraiHtmlUserAgent sharedInstance].thinSize;
	}
	else if ( [self isString:@"medium"] )
	{
		return [SamuraiHtmlUserAgent sharedInstance].mediumSize;
	}
	else if ( [self isString:@"thick"] )
	{
		return [SamuraiHtmlUserAgent sharedInstance].thickSize;
	}
	else
	{
		return INVALID_VALUE;
	}
}

- (CSSBorderStyle)computeBorderStyle:(CSSBorderStyle)defaultStyle
{
	if ( [self isString:@"inherit"] )
	{
		return CSSBorderStyle_Inherit;
	}
	else if ( [self isString:@"none"] )
	{
		return CSSBorderStyle_None;
	}
	else if ( [self isString:@"hidden"] )
	{
		return CSSBorderStyle_Hidden;
	}
	else if ( [self isString:@"dotted"] )
	{
		return CSSBorderStyle_Dotted;
	}
	else if ( [self isString:@"dashed"] )
	{
		return CSSBorderStyle_Dashed;
	}
	else if ( [self isString:@"solid"] )
	{
		return CSSBorderStyle_Solid;
	}
	else if ( [self isString:@"double"] )
	{
		return CSSBorderStyle_Double;
	}
	else if ( [self isString:@"groove"] )
	{
		return CSSBorderStyle_Groove;
	}
	else if ( [self isString:@"ridge"] )
	{
		return CSSBorderStyle_Ridge;
	}
	else if ( [self isString:@"inset"] )
	{
		return CSSBorderStyle_Inset;
	}
	else if ( [self isString:@"outset"] )
	{
		return CSSBorderStyle_Outset;
	}
	else
	{
		return defaultStyle;
	}
}

@end

#pragma mark -

@implementation NSObject(RenderStyle)

+ (CSSViewHierarchy)style_viewHierarchy
{
	return CSSViewHierarchy_Leaf;
}

@end

#pragma mark -

@implementation SamuraiHtmlRenderStyle

@def_css_value( top, setTop,											@"top" );
@def_css_value( left, setLeft,											@"left");
@def_css_value( right, setRight,										@"right");
@def_css_value( bottom, setBottom,										@"bottom" );

@def_css_value( width, setWidth,										@"width" );
@def_css_value( minWidth, setMinWidth,									@"min-width" );
@def_css_value( maxWidth, setMaxWidth,									@"max-width" );

@def_css_value( height, setHeight,										@"height" );
@def_css_value( minHeight, setMinHeight,								@"min-height" );
@def_css_value( maxHeight, setMaxHeight,								@"max-height" );

@def_css_value( position, setPosition,									@"position" );
@def_css_value( floating, setFloating,									@"float" );
@def_css_value( clear, setClear,										@"clear" );

@def_css_value( order, setOrder,										@"order" );
@def_css_value( zIndex, setZIndex,										@"z-index" );

@def_css_value( display, setDisplay,									@"display" );
@def_css_value( overflow, setOverflow,									@"overflow" );
@def_css_value( visibility, setVisibility,								@"visibility" );
@def_css_value( opacity, setOpacity,									@"opacity" );

@def_css_value( boxSizing, setBoxSizing,								@"box-sizing" );
@def_css_array( boxShadow, setBoxShadow,								@"box-shadow" );

@def_css_value( baseline, setBaseline,									@"baseline" );
@def_css_value( wordWrap, setWordWrap,									@"word-wrap" );
@def_css_value( contentMode, setContentMode,							@"content-mode" );

@def_css_value( color, setColor,										@"color" );
@def_css_value( direction, setDirection,								@"direction" );
@def_css_value( letterSpacing, setLetterSpacing,						@"letter-spacing" );
@def_css_value( lineHeight, setLineHeight,								@"line-height" );
@def_css_value( align, setAlign,										@"align" );
@def_css_value( verticalAlign, setVerticalAlign,						@"vertical-align" );
@def_css_value( textAlign, setTextAlign,								@"text-align" );
@def_css_value( textDecoration, setTextDecoration,						@"text-decoration" );
@def_css_value( textIndent, setTextIndent,								@"text-indent" );
@def_css_array( textShadow, setTextShadow,								@"text-shadow" );
@def_css_value( textTransform, setTextTransform,						@"text-transform" );
@def_css_value( textOverflow, setTextOverflow,							@"text-overflow" );
@def_css_value( unicodeBidi, setUnicodeBidi,							@"unicode-bidi" );
@def_css_value( whiteSpace, setWhiteSpace,								@"white-space" );
@def_css_value( wordSpacing, setWordSpacing,							@"word-spacing" );

// list

@def_css_array( listStyle, setListStyle,								@"list-style" );
@def_css_value( listStyleType, setListStyleType,						@"list-style-type" );
@def_css_value( listStyleImage, setListStyleImage,						@"list-style-image" );
@def_css_value( listStylePosition, setListStylePosition,				@"list-style-position" );

// background

@def_css_array( background, setBackground,								@"background" );
@def_css_value( backgroundColor, setBackgroundColor,					@"background-color" );
@def_css_value( backgroundImage, setBackgroundImage,					@"background-image" );

// flex box

@def_css_array( flex, setFlex,											@"flex" );
@def_css_value( flexGrow, setFlexGrow,									@"flex-grow" );
@def_css_value( flexShrink, setFlexShrink,								@"flex-shrink" );
@def_css_value( flexBasis, setFlexBasis,								@"flex-basis" );
@def_css_value( flexWrap, setFlexWrap,									@"flex-wrap" );
@def_css_array( flexFlow, setFlexFlow,									@"flex-flow" );
@def_css_value( flexDirection, setFlexDirection,						@"flex-direction" );

@def_css_value( alignSelf, setAlignSelf,								@"align-self" );
@def_css_value( alignItems, setAlignItems,								@"align-items" );
@def_css_value( alignContent, setAlignContent,							@"align-content" );
@def_css_value( justifyContent, setJustifyContent,						@"justify-content" );

@def_css_value( boxAlign, setBoxAlign,									@"box-align" );
@def_css_value( boxDirection, setBoxDirection,							@"box-direction" );
@def_css_value( boxFlex, setBoxFlex,									@"box-flex" );
@def_css_value( boxFlexGroup, setBoxFlexGroup,							@"box-flex-group" );
@def_css_value( boxLines, setBoxLines,									@"box-lines" );
@def_css_value( boxOrdinalGroup, setBoxOrdinalGroup,					@"box-ordinal-group" );
@def_css_value( boxOrient, setBoxOrient,								@"box-orient" );
@def_css_value( boxPack, setBoxPack,									@"box-pack" );

// font

@def_css_array( font, setFont,											@"font" );
@def_css_array( fontFamily, setFontFamily,								@"font-family" );
@def_css_value( fontSize, setFontSize,									@"font-size" );
@def_css_value( fontWeight, setFontWeight,								@"font-weight" );
@def_css_value( fontStyle, setFontStyle,								@"font-style" );
@def_css_value( fontVariant, setFontVariant,							@"font-variant" );

// border

@def_css_value( borderCollapse, setBorderCollapse,						@"border-collapse" );
@def_css_value( borderSpacing, setBorderSpacing,						@"border-spacing" );

@def_css_value( cellSpacing, setCellSpacing,							@"cell-spacing" );
@def_css_value( cellPadding, setCellPadding,							@"cell-padding" );

@def_css_array( border, setBorder,										@"border" );
@def_css_array( borderWidth, setBorderWidth,							@"border-width" );
@def_css_array( borderStyle, setBorderStyle,							@"border-style" );
@def_css_array( borderColor, setBorderColor,							@"border-color" );

@def_css_array( borderRadius, setBorderRadius,							@"border-radius" );
@def_css_array( borderTopLeftRadius, setBorderTopLeftRadius,			@"border-top-left-radius" );
@def_css_array( borderTopRightRadius, setBorderTopRightRadius,			@"border-top-right-radius" );
@def_css_array( borderBottomLeftRadius, setBorderBottomLeftRadius,		@"border-bottom-left-radius" );
@def_css_array( borderBottomRightRadius, setBorderBottomRightRadius,	@"border-bottom-right-radius" );

@def_css_array( borderTop, setBorderTop,								@"border-top" );
@def_css_value( borderTopColor, setBorderTopColor,						@"border-top-color" );
@def_css_value( borderTopStyle, setBorderTopStyle,						@"border-top-style" );
@def_css_value( borderTopWidth, setBorderTopWidth,						@"border-top-width" );

@def_css_array( borderLeft, setBorderLeft,								@"border-left" );
@def_css_value( borderLeftColor, setBorderLeftColor,					@"border-left-color" );
@def_css_value( borderLeftStyle, setBorderLeftStyle,					@"border-left-style" );
@def_css_value( borderLeftWidth, setBorderLeftWidth,					@"border-left-width" );

@def_css_array( borderRight, setBorderRight,							@"border-right" );
@def_css_value( borderRightColor, setBorderRightColor,					@"border-right-color" );
@def_css_value( borderRightStyle, setBorderRightStyle,					@"border-right-style" );
@def_css_value( borderRightWidth, setBorderRightWidth,					@"border-right-width" );

@def_css_array( borderBottom, setBorderBottom,							@"border-bottom" );
@def_css_value( borderBottomColor, setBorderBottomColor,				@"border-bottom-color" );
@def_css_value( borderBottomStyle, setBorderBottomStyle,				@"border-bottom-style" );
@def_css_value( borderBottomWidth, setBorderBottomWidth,				@"border-bottom-width" );

// margin

@def_css_array( margin, setMargin,										@"margin" );
@def_css_value( marginTop, setMarginTop,								@"margin-top" );
@def_css_value( marginLeft, setMarginLeft,								@"margin-left" );
@def_css_value( marginRight, setMarginRight,							@"margin-right" );
@def_css_value( marginBottom, setMarginBottom,							@"margin-bottom" );

// padding

@def_css_array( padding, setPadding,									@"padding" );
@def_css_value( paddingTop, setPaddingTop,								@"padding-top" );
@def_css_value( paddingLeft, setPaddingLeft,							@"padding-left" );
@def_css_value( paddingRight, setPaddingRight,							@"padding-right" );
@def_css_value( paddingBottom, setPaddingBottom,						@"padding-bottom" );

// inset

@def_css_array( inset, setInset,										@"inset" );
@def_css_value( insetTop, setInsetTop,									@"inset-top" );
@def_css_value( insetLeft, setInsetLeft,								@"inset-left" );
@def_css_value( insetRight, setInsetRight,								@"inset-right" );
@def_css_value( insetBottom, setInsetBottom,							@"inset-bottom" );

// view-hierarchy

@def_css_value( webkitMarginBefore, setWebkitMarginBefore,				@"-webkit-margin-before" );
@def_css_value( webkitMarginAfter, setWebkitMarginAfter,				@"-webkit-margin-after" );
@def_css_value( webkitMarginStart, setWebkitMarginStart,				@"-webkit-margin-start" );
@def_css_value( webkitMarginEnd, setWebkitMarginEnd,					@"-webkit-margin-end" );

@def_css_value( webkitPaddingBefore, setWebkitPaddingBefore,			@"-webkit-padding-before" );
@def_css_value( webkitPaddingAfter, setWebkitPaddingAfter,				@"-webkit-padding-after" );
@def_css_value( webkitPaddingStart, setWebkitPaddingStart,				@"-webkit-padding-start" );
@def_css_value( webkitPaddingEnd, setWebkitPaddingEnd,					@"-webkit-padding-end" );

@def_css_value( samuraiViewHierarchy, setSamuraiViewHierarchy,			@"-samurai-view-hierarchy" );
@def_css_value( samuraiViewClass, setSamuraiViewClass,					@"-samurai-view-class" );

#pragma mark -

- (id)init
{
	self = [super init];
	if ( self )
	{
	}
	return self;
}

- (void)dealloc
{
}

#pragma mark -

- (SamuraiCSSValue *)getCSSValueForKey:(NSString *)key
{
	if ( nil == key )
		return nil;
	
	NSObject * object = [self.properties objectForKey:key];

	if ( nil == object )
	{
		object = [self.properties objectForKey:[@"-webkit-" stringByAppendingString:key]];
	}
	
	if ( object )
	{
		if ( [object isKindOfClass:[NSString class]] )
		{
			return [SamuraiCSSValue parseString:(NSString *)object];
		}
		else if ( [object isKindOfClass:[SamuraiCSSValue class]] )
		{
			return (SamuraiCSSValue *)object;
		}
		else if ( [object isKindOfClass:[SamuraiCSSArray class]] )
		{
			return [(SamuraiCSSArray *)object objectAtIndex:0];
		}
	}
	
	return nil;
}

- (SamuraiCSSArray *)getCSSArrayForKey:(NSString *)key
{
	if ( nil == key )
		return nil;

	NSObject * object = [self.properties objectForKey:key];
	if ( object )
	{
		if ( [object isKindOfClass:[NSString class]] )
		{
			return [SamuraiCSSArray parseString:(NSString *)object];
		}
		else if ( [object isKindOfClass:[SamuraiCSSValue class]] )
		{
			return [SamuraiCSSArray array:[NSArray arrayWithObject:object]];
		}
		else if ( [object isKindOfClass:[SamuraiCSSArray class]] )
		{
			return (SamuraiCSSArray *)object;
		}
	}

	return nil;
}

- (void)setCSSValue:(SamuraiCSSValue *)value forKey:(NSString *)key
{
	if ( nil == key )
		return;

	if ( nil == value )
	{
		[self.properties removeObjectForKey:key];
	}
	else
	{
		[self.properties setObject:value forKeyedSubscript:key];
	}
}

- (void)setCSSArray:(SamuraiCSSArray *)array forKey:(NSString *)key
{
	if ( nil == key )
		return;
	
	if ( nil == array )
	{
		[self.properties removeObjectForKey:key];
	}
	else
	{
		[self.properties setObject:array forKeyedSubscript:key];
	}
}

#pragma mark -

- (BOOL)isAutoWidth
{
	if ( [self.width isAutomatic] )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)isAutoHeight
{
	if ( [self.height isAutomatic] )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)isFixedWidth
{
	if ( [self.width isAbsolute] )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)isFixedHeight
{
	if ( [self.height isAbsolute] )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)isAutoMarginTop
{
	if ( [self.margin.top isAutomatic] || [self.marginTop isAutomatic] )
	{
		return YES;
	}

	return NO;
}

- (BOOL)isAutoMarginLeft
{
	if ( [self.margin.left isAutomatic] || [self.marginLeft isAutomatic] )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)isAutoMarginRight
{
	if ( [self.margin.right isAutomatic] || [self.marginRight isAutomatic] )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)isAutoMarginBottom
{
	if ( [self.margin.bottom isAutomatic] || [self.marginBottom isAutomatic] )
	{
		return YES;
	}
	
	return NO;
}

- (UIFont *)computeFont:(UIFont *)defaultFont
{
	UIFont * result = nil;
	
	NSUInteger			componentIndex = 0;
	SamuraiCSSValue *	component = nil;

	SamuraiCSSArray *	font = self.font;
	SamuraiCSSValue *	fontVariant = self.fontVariant;
//	SamuraiCSSArray *	fontFamily = self.fontFamily;
	SamuraiCSSValue *	fontWeight = self.fontWeight;
	SamuraiCSSValue *	fontStyle = self.fontStyle;
	SamuraiCSSValue *	fontSize = self.fontSize;
	
	if ( font )
	{
	// font: [ [ <font-style> || <font-variant> || <font-weight> ]? <font-size> [ / <line-height> ]? <font-family> ] | caption | icon | menu | message-box | small-caption | status-bar | inherit
		
	// font-style (optional)
		
		component = [font objectAtIndex:componentIndex];
		
		if ( [component inStrings:@[@"normal", @"italic", @"oblique", @"inherit"]] )
		{
			fontStyle = fontStyle ?: component;

			componentIndex += 1;
		}

	// font-variant (optional)
		
		component = [font objectAtIndex:componentIndex];
		
		if ( [component inStrings:@[@"normal", @"small-caps", @"inherit"]] )
		{
			fontVariant = fontVariant ?: component;
			
			componentIndex += 1;
		}

	// font-weight (optional)
		
		component = [font objectAtIndex:componentIndex];
		
		if ( [component inStrings:@[@"normal", @"bold", @"bolder", @"lighter", @"inherit"]] || [component isNumber] )
		{
			fontWeight = fontWeight ?: component;

			componentIndex += 1;
		}
		
	// font-size
		
		component = [font objectAtIndex:componentIndex];
		
		if ( component )
		{
			if ( [component inStrings:@[@"xx-small", @"x-small", @"small", @"medium", @"large", @"x-large", @"xx-large"]] )
			{
				fontSize = fontSize ?: component;
				
				componentIndex += 1;
			}
			else if ( [component inStrings:@[@"larger", @"smaller"]] )
			{
				fontSize = fontSize ?: component;

				componentIndex += 1;
			}
			else if ( [component inStrings:@[@"inherit"]] )
			{
				fontSize = fontSize ?: component;
				
				componentIndex += 1;
			}
			else if ( [component isNumber] )
			{
				fontSize = fontSize ?: component;
				
				componentIndex += 1;
			}
			else
			{
			//	ERROR( @"unknown font-size unit" );
			}
		}

	// font-family
		
		component = [font objectAtIndex:componentIndex];
		
		if ( component )
		{
		//	fontFamily = fontFamily ?: [SamuraiCSSArray object:component];

			componentIndex += 1;
		}
	}

	CGFloat defaultFontHeight = [SamuraiHtmlUserAgent sharedInstance].defaultFont.lineHeight;
	CGFloat fontHeight = defaultFontHeight;

	if ( fontSize )
	{
		if ( [fontSize isNumber] )
		{
			if ( [fontSize isPercentage] )
			{
				fontHeight = [fontSize computeValue:defaultFont.lineHeight];
			}
			else
			{
				fontHeight = [fontSize computeValue:defaultFontHeight];
			}
		}
		else if ( [fontSize isString] )
		{
			if ( [fontSize isString:@"xx-small"] )
			{
				fontHeight = defaultFontHeight * 0.4f;
			}
			else if ( [fontSize isString:@"x-small"] )
			{
				fontHeight = defaultFontHeight * 0.6f;
			}
			else if ( [fontSize isString:@"small"] )
			{
				fontHeight = defaultFontHeight * 0.8f;
			}
			else if ( [fontSize isString:@"medium"] )
			{
				fontHeight = defaultFontHeight * 1.0f;
			}
			else if ( [fontSize isString:@"large"] )
			{
				fontHeight = defaultFontHeight * 1.2f;
			}
			else if ( [fontSize isString:@"x-large"] )
			{
				fontHeight = defaultFontHeight * 1.4f;
			}
			else if ( [fontSize isString:@"xx-large"] )
			{
				fontHeight = defaultFontHeight * 1.6f;
			}
			else if ( [fontSize isString:@"larger"] )
			{
				fontHeight = defaultFontHeight * 1.2f;
			}
			else if ( [fontSize isString:@"smaller"] )
			{
				fontHeight = defaultFontHeight * 0.8f;
			}
		}
		else
		{
			ERROR( @"unknown font-size unit" );
		}
	}

	if ( fontVariant )
	{
		if ( [fontVariant isString:@"small-caps"] )
		{
			fontHeight = defaultFontHeight / 2.0f;
		}
	}
	
//// custom font
//	
//	for ( SamuraiCSSString * family in fontFamily.items )
//	{
//		if ( [family isString] )
//		{
//			NSArray * names = [UIFont fontNamesForFamilyName:family.value];
//
//			for ( NSString * name in names )
//			{
//				result = [UIFont fontWithName:name size:fontHeight];
//
//				if ( result )
//					break;
//			}
//		}
//
//		if ( result )
//			break;
//	}
	
// italic font
	
	if ( nil == result )
	{
		if ( fontStyle )
		{
			if ( [fontStyle inStrings:@[@"italic", @"oblique"]] )
			{
				result = [UIFont italicSystemFontOfSize:fontHeight];
			}
		}
	}
	
// bold font
	
	if ( nil == result )
	{
		if ( fontWeight )
		{
			if ( [fontWeight inStrings:@[@"bold", @"bolder"]] )
			{
				result = [UIFont boldSystemFontOfSize:fontHeight];
			}
			else if ( [fontWeight inStrings:@[@"normal"]] )
			{
				result = [UIFont systemFontOfSize:fontHeight];
			}
			else if ( [fontWeight isNumber] )
			{
				CGFloat value = [fontWeight computeValue:200.0f];

				if ( value >= 600.0f )
				{
					result = [UIFont boldSystemFontOfSize:fontHeight];
				}
			}
		}
	}

// normal font
	
	if ( nil == result )
	{
		if ( fontHeight )
		{
			result = [UIFont systemFontOfSize:fontHeight];
		}
	}

// default font
	
	if ( nil == result )
	{
		result = defaultFont;
	}

	return result;
}

- (UIColor *)computeColor:(UIColor *)defaultColor
{
	SamuraiCSSValue * color = self.color;
	
	if ( [color isColor] )
	{
		return [color color];
	}
	
	return defaultColor;
}

- (NSTextAlignment)computeTextAlignment:(NSTextAlignment)defaultMode
{
	SamuraiCSSValue * textAlign = self.textAlign;
	
	if ( textAlign )
	{
		if ( [textAlign isString:@"left"] )
		{
			return NSTextAlignmentLeft;
		}
		else if ( [textAlign isString:@"right"] )
		{
			return NSTextAlignmentRight;
		}
		else if ( [textAlign isString:@"center"] )
		{
			return NSTextAlignmentCenter;
		}
		else if ( [textAlign isString:@"justify"] )
		{
			return NSTextAlignmentJustified;
		}
		else if ( [textAlign isString:@"natural"] )
		{
			return NSTextAlignmentNatural;
		}
	}
	
	return defaultMode;
}

- (NSLineBreakMode)computeLineBreakMode:(NSLineBreakMode)defaultMode
{
	SamuraiCSSValue * overflow = self.textOverflow;
	SamuraiCSSValue * wordwrap = self.wordWrap;
	
	if ( overflow )
	{
		if ( [overflow isString:@"clip"] )
		{
			return NSLineBreakByClipping;
		}
		else if ( [overflow isString:@"ellipsis"] )
		{
			return NSLineBreakByTruncatingTail;
		}
		else if ( [overflow isString:@"ellipsis-head"] )
		{
			return NSLineBreakByTruncatingHead;
		}
		else if ( [overflow isString:@"ellipsis-tail"] )
		{
			return NSLineBreakByTruncatingTail;
		}
		else if ( [overflow isString:@"ellipsis-middle"] )
		{
			return NSLineBreakByTruncatingMiddle;
		}
	}
	
	if ( wordwrap )
	{
		if ( [wordwrap isString:@"normal"] )
		{
			return NSLineBreakByCharWrapping;
		}
		else if ( [wordwrap isString:@"break-word"] )
		{
			return NSLineBreakByWordWrapping;
		}
	}
	
	return defaultMode;
}

- (UIViewContentMode)computeContentMode:(UIViewContentMode)defaultMode
{
	SamuraiCSSValue * contentMode = self.contentMode;
	
	if ( contentMode )
	{
		if ( [contentMode isString:@"scale"] )
		{
			return UIViewContentModeScaleToFill;
		}
		else if ( [contentMode isString:@"fit"] )
		{
			return UIViewContentModeScaleAspectFit;
		}
		else if ( [contentMode isString:@"fill"] )
		{
			return UIViewContentModeScaleAspectFill;
		}
		else if ( [contentMode isString:@"center"] )
		{
			return UIViewContentModeCenter;
		}
		else if ( [contentMode isString:@"top"] )
		{
			return UIViewContentModeTop;
		}
		else if ( [contentMode isString:@"bottom"] )
		{
			return UIViewContentModeBottom;
		}
		else if ( [contentMode isString:@"left"] )
		{
			return UIViewContentModeLeft;
		}
		else if ( [contentMode isString:@"right"] )
		{
			return UIViewContentModeRight;
		}
		else if ( [contentMode inStrings:@[@"top-left", @"left-top"]] )
		{
			return UIViewContentModeTopLeft;
		}
		else if ( [contentMode inStrings:@[@"top-right", @"right-top"]] )
		{
			return UIViewContentModeTopRight;
		}
		else if ( [contentMode inStrings:@[@"bottom-left", @"left-bottom"]] )
		{
			return UIViewContentModeBottomLeft;
		}
		else if ( [contentMode inStrings:@[@"bottom-right", @"right-bottom"]] )
		{
			return UIViewContentModeBottomRight;
		}
	}
	
	return defaultMode;

}

- (UIBaselineAdjustment)computeBaselineAdjustment:(UIBaselineAdjustment)defaultMode
{
	SamuraiCSSValue * baseline = self.baseline;
	
	if ( baseline )
	{
		if ( [baseline isString:@"top"] )
		{
			return UIBaselineAdjustmentAlignBaselines;
		}
		else if ( [baseline isString:@"center"] )
		{
			return UIBaselineAdjustmentAlignCenters;
		}
		else if ( [baseline isString:@"bottom"] )
		{
			return UIBaselineAdjustmentNone;
		}
	}
	
	return defaultMode;
}

- (UITextDecoration)computeTextDecoration:(UITextDecoration)defaultDecoration
{
	SamuraiCSSValue * textDecoration = self.textDecoration;

	if ( textDecoration )
	{
		if ( [textDecoration isString:@"none"] || [textDecoration isString:@"inherit"] )
		{
			return UITextDecoration_None;
		}
		else if ( [textDecoration isString:@"overline"] )
		{
			return UITextDecoration_Overline;
		}
		else if ( [textDecoration isString:@"underline"] )
		{
			return UITextDecoration_Underline;
		}
		else if ( [textDecoration isString:@"line-through"] )
		{
			return UITextDecoration_LineThrough;
		}
	}
	
	return defaultDecoration;
}

#pragma mark -

- (CSSWrap)computeWrap:(CSSWrap)defaultValue
{
	SamuraiCSSValue * flexWrap = self.flexWrap;
	
	if ( flexWrap )
	{
		if ( [flexWrap isString:@"nowrap"] )
		{
			return CSSWrap_NoWrap;
		}
		else if ( [flexWrap isString:@"wrap"] )
		{
			return CSSWrap_Wrap;
		}
		else if ( [flexWrap isString:@"wrap-reverse"] )
		{
			return CSSWrap_WrapReverse;
		}
		else if ( [flexWrap isString:@"inherit"] )
		{
			return CSSWrap_Inherit;
		}
	}
	
	return defaultValue;
}

- (CSSAlign)computeAlign:(CSSAlign)defaultValue
{
	SamuraiCSSValue * align = self.align;
	SamuraiCSSValue * textAlign = self.textAlign;

	if ( align )
	{
		if ( [align isString:@"left"] )
		{
			return CSSAlign_Left;
		}
		else if ( [align isString:@"right"] )
		{
			return CSSAlign_Right;
		}
		else if ( [align isString:@"center"] )
		{
			return CSSAlign_Center;
		}
		else if ( [align isString:@"inherit"] )
		{
			return CSSAlign_Inherit;
		}
	}
	
	if ( textAlign )
	{
		if ( [textAlign isString:@"left"] )
		{
			return CSSAlign_Left;
		}
		else if ( [textAlign isString:@"right"] )
		{
			return CSSAlign_Right;
		}
		else if ( [textAlign isString:@"center"] )
		{
			return CSSAlign_Center;
		}
	}

	return defaultValue;
}

- (CSSClear)computeClear:(CSSClear)defaultValue
{
	SamuraiCSSValue * clear = self.clear;
	
	if ( clear )
	{
		if ( [clear isString:@"inherit"] )
		{
			return CSSClear_Inherit;
		}
		else if ( [clear isString:@"none"] )
		{
			return CSSClear_None;
		}
		else if ( [clear isString:@"left"] )
		{
			return CSSClear_Left;
		}
		else if ( [clear isString:@"right"] )
		{
			return CSSClear_Right;
		}
		else if ( [clear isString:@"both"] || [clear isString:@"all"] )
		{
			return CSSClear_Both;
		}
	}
	
	return defaultValue;
}

- (CSSDisplay)computeDisplay:(CSSDisplay)defaultValue
{
	SamuraiCSSValue * display = self.display;
	
	if ( display )
	{
		if ( [display isString:@"none"] )
		{
			return CSSDisplay_None;
		}
		else if ( [display isString:@"block"] )
		{
			return CSSDisplay_Block;
		}
		else if ( [display isString:@"inline"] )
		{
			return CSSDisplay_Inline;
		}
		else if ( [display isString:@"inline-block"] )
		{
			return CSSDisplay_InlineBlock;
		}
		else if ( [display isString:@"flex"] || [display isString:@"box"] || [display isString:@"flexbox"] )
		{
			return CSSDisplay_Flex;
		}
		else if ( [display isString:@"inline-flex"] || [display isString:@"inline-box"] || [display isString:@"inline-flexbox"] )
		{
			return CSSDisplay_InlineFlex;
		}
		else if ( [display isString:@"grid"] )
		{
			return CSSDisplay_Grid;
		}
		else if ( [display isString:@"inline-grid"] )
		{
			return CSSDisplay_InlineGrid;
		}
		else if ( [display isString:@"list-item"] )
		{
			return CSSDisplay_ListItem;
		}
		else if ( [display isString:@"table"] )
		{
			return CSSDisplay_Table;
		}
		else if ( [display isString:@"inline-table"] )
		{
			return CSSDisplay_InlineTable;
		}
		else if ( [display isString:@"table-row-group"] )
		{
			return CSSDisplay_TableRowGroup;
		}
		else if ( [display isString:@"table-header-group"] )
		{
			return CSSDisplay_TableHeaderGroup;
		}
		else if ( [display isString:@"table-footer-group"] )
		{
			return CSSDisplay_TableFooterGroup;
		}
		else if ( [display isString:@"table-row"] )
		{
			return CSSDisplay_TableRow;
		}
		else if ( [display isString:@"table-column-group"] )
		{
			return CSSDisplay_TableColumnGroup;
		}
		else if ( [display isString:@"table-column"] )
		{
			return CSSDisplay_TableColumn;
		}
		else if ( [display isString:@"table-cell"] )
		{
			return CSSDisplay_TableCell;
		}
		else if ( [display isString:@"table-caption"] )
		{
			return CSSDisplay_TableCaption;
		}
		else if ( [display isString:@"inherit"] )
		{
			return CSSDisplay_Inherit;
		}
	}

	return defaultValue;
}

- (CSSFloating)computeFloating:(CSSFloating)defaultValue
{
	SamuraiCSSValue * floating = self.floating;
	
	if ( floating )
	{
		if ( [floating isString:@"none"] )
		{
			return CSSFloating_None;
		}
		else if ( [floating isString:@"left"] )
		{
			return CSSFloating_Left;
		}
		else if ( [floating isString:@"right"] )
		{
			return CSSFloating_Right;
		}
		else if ( [floating isString:@"inherit"] )
		{
			return CSSFloating_Inherit;
		}
	}
	
	return defaultValue;
}

- (CSSPosition)computePosition:(CSSPosition)defaultValue
{
	SamuraiCSSValue * position = self.position;
	
	if ( position )
	{
		if ( [position isString:@"static"] )
		{
			return CSSPosition_Static;
		}
		else if ( [position isString:@"relative"] )
		{
			return CSSPosition_Relative;
		}
		else if ( [position isString:@"absolute"] )
		{
			return CSSPosition_Absolute;
		}
		else if ( [position isString:@"fixed"] )
		{
			return CSSPosition_Fixed;
		}
		else if ( [position isString:@"inherit"] )
		{
			return CSSPosition_Inherit;
		}
	}
	
	return defaultValue;
}

- (CSSWhiteSpace)computeWhiteSpace:(CSSWhiteSpace)defaultValue
{
	SamuraiCSSValue * whiteSpace = self.whiteSpace;

	if ( whiteSpace )
	{
		if ( [whiteSpace isString:@"normal"] )
		{
			return CSSWhiteSpace_Normal;
		}
		else if ( [whiteSpace isString:@"pre"] )
		{
			return CSSWhiteSpace_Pre;
		}
		else if ( [whiteSpace isString:@"nowrap"] )
		{
			return CSSWhiteSpace_NoWrap;
		}
		else if ( [whiteSpace isString:@"pre-wrap"] )
		{
			return CSSWhiteSpace_PreWrap;
		}
		else if ( [whiteSpace isString:@"pre-line"] )
		{
			return CSSWhiteSpace_PreLine;
		}
	}
	
	return defaultValue;
}

- (CSSVerticalAlign)computeVerticalAlign:(CSSVerticalAlign)defaultValue
{
	SamuraiCSSValue * align = self.align;
	
	if ( align )
	{
		if ( [align isString:@"baseline"] )
		{
			return CSSVerticalAlign_Baseline;
		}
		else if ( [align isString:@"sub"] )
		{
			return CSSVerticalAlign_Sub;
		}
		else if ( [align isString:@"super"] )
		{
			return CSSVerticalAlign_Super;
		}
		else if ( [align isString:@"top"] )
		{
			return CSSVerticalAlign_Top;
		}
		else if ( [align isString:@"text-top"] )
		{
			return CSSVerticalAlign_TextTop;
		}
		else if ( [align isString:@"middle"] )
		{
			return CSSVerticalAlign_Middle;
		}
		else if ( [align isString:@"bottom"] )
		{
			return CSSVerticalAlign_Bottom;
		}
		else if ( [align isString:@"text-bottom"] )
		{
			return CSSVerticalAlign_TextBottom;
		}
		else if ( [align isString:@"inherit"] )
		{
			return CSSVerticalAlign_Inherit;
		}
	}
	
	return defaultValue;
}

- (CSSViewHierarchy)computeViewHierarchy:(CSSViewHierarchy)defaultValue
{
	SamuraiCSSValue * hierarchy = self.samuraiViewHierarchy;
	
	if ( hierarchy )
	{
		if ( [hierarchy isString:@"leaf"] )
		{
			return CSSViewHierarchy_Leaf;
		}
		else if ( [hierarchy isString:@"tree"] )
		{
			return CSSViewHierarchy_Tree;
		}
		else if ( [hierarchy isString:@"branch"] )
		{
			return CSSViewHierarchy_Branch;
		}
		else if ( [hierarchy isString:@"hidden"] )
		{
			return CSSViewHierarchy_Hidden;
		}
		else if ( [hierarchy isString:@"inherit"] )
		{
			return CSSViewHierarchy_Inherit;
		}
	}
	
	return defaultValue;
}

- (CSSBorderCollapse)computeBorderCollapse:(CSSBorderCollapse)defaultValue
{
	SamuraiCSSValue * collapse = self.borderCollapse;
	
	if ( collapse )
	{
		if ( [collapse isString:@"separate"] )
		{
			return CSSBorderCollapse_Separate;
		}
		else if ( [collapse isString:@"collapse"] )
		{
			return CSSBorderCollapse_Collapse;
		}
		else if ( [collapse isString:@"inherit"] )
		{
			return CSSBorderCollapse_Inherit;
		}
	}
	
	return defaultValue;
}

#pragma mark -

- (CSSBoxPack)computeBoxPack:(CSSBoxPack)defaultValue
{
	SamuraiCSSValue * boxPack = self.boxPack;
	
	if ( boxPack )
	{
		if ( [boxPack isString:@"inherit"] )
		{
			return CSSBoxPack_Inherit;
		}
		else if ( [boxPack isString:@"start"] )
		{
			return CSSBoxPack_Start;
		}
		else if ( [boxPack isString:@"end"] )
		{
			return CSSBoxPack_End;
		}
		else if ( [boxPack isString:@"center"] )
		{
			return CSSBoxPack_Center;
		}
		else if ( [boxPack isString:@"justify"] )
		{
			return CSSBoxPack_Justify;
		}
	}

	return defaultValue;
}

- (CSSBoxAlign)computeBoxAlign:(CSSBoxAlign)defaultValue
{
	SamuraiCSSValue * boxAlign = self.boxAlign;
	
	if ( boxAlign )
	{
		if ( [boxAlign isString:@"inherit"] )
		{
			return CSSBoxAlign_Inherit;
		}
		else if ( [boxAlign isString:@"start"] )
		{
			return CSSBoxAlign_Start;
		}
		else if ( [boxAlign isString:@"end"] )
		{
			return CSSBoxAlign_End;
		}
		else if ( [boxAlign isString:@"center"] )
		{
			return CSSBoxAlign_Center;
		}
		else if ( [boxAlign isString:@"baseline"] )
		{
			return CSSBoxAlign_Baseline;
		}
		else if ( [boxAlign isString:@"stretch"] )
		{
			return CSSBoxAlign_Stretch;
		}
	}
	
	return defaultValue;
}

- (CSSBoxLines)computeBoxLines:(CSSBoxLines)defaultValue
{
	SamuraiCSSValue * boxLines = self.boxLines;
	
	if ( boxLines )
	{
		if ( [boxLines isString:@"inherit"] )
		{
			return CSSBoxLines_Inherit;
		}
		else if ( [boxLines isString:@"single"] )
		{
			return CSSBoxLines_Single;
		}
		else if ( [boxLines isString:@"multiple"] )
		{
			return CSSBoxLines_Multiple;
		}
	}
	
	return defaultValue;
}

- (CSSBoxOrient)computeBoxOrient:(CSSBoxOrient)defaultValue
{
	SamuraiCSSValue * boxOrient = self.boxOrient;
	
	if ( boxOrient )
	{
		if ( [boxOrient isString:@"inherit"] )
		{
			return CSSBoxOrient_Inherit;
		}
		else if ( [boxOrient isString:@"horizontal"] )
		{
			return CSSBoxOrient_Horizontal;
		}
		else if ( [boxOrient isString:@"vertical"] )
		{
			return CSSBoxOrient_Vertical;
		}
		else if ( [boxOrient isString:@"inline-axis"] )
		{
			return CSSBoxOrient_InlineAxis;
		}
		else if ( [boxOrient isString:@"block-axis"] )
		{
			return CSSBoxOrient_BlockAxis;
		}
	}
	
	return defaultValue;
}

- (CSSBoxDirection)computeBoxDirection:(CSSBoxDirection)defaultValue
{
	SamuraiCSSValue * boxDirection = self.boxDirection;
	
	if ( boxDirection )
	{
		if ( [boxDirection isString:@"inherit"] )
		{
			return CSSBoxDirection_Inherit;
		}
		else if ( [boxDirection isString:@"normal"] )
		{
			return CSSBoxDirection_Normal;
		}
		else if ( [boxDirection isString:@"reverse"] )
		{
			return CSSBoxDirection_Reverse;
		}
	}
	
	return defaultValue;
}

- (CSSFlexWrap)computeFlexWrap:(CSSFlexWrap)defaultValue
{
	SamuraiCSSValue * flexWrap = self.flexWrap ?: [self.flexFlow objectAtIndex:1];
	
	if ( flexWrap )
	{
		if ( [flexWrap isString:@"inherit"] )
		{
			return CSSFlexWrap_Inherit;
		}
		else if ( [flexWrap isString:@"nowrap"] )
		{
			return CSSFlexWrap_Nowrap;
		}
		else if ( [flexWrap isString:@"wrap"] )
		{
			return CSSFlexWrap_Wrap;
		}
		else if ( [flexWrap isString:@"wrap-reverse"] )
		{
			return CSSFlexWrap_WrapReverse;
		}
	}
	
	return defaultValue;
}

- (CSSFlexDirection)computeFlexDirection:(CSSFlexDirection)defaultValue
{
	SamuraiCSSValue * flexDirection = self.flexDirection ?: [self.flexFlow objectAtIndex:0];
	
	if ( flexDirection )
	{
		if ( [flexDirection isString:@"inherit"] )
		{
			return CSSFlexDirection_Inherit;
		}
		else if ( [flexDirection isString:@"row"] )
		{
			return CSSFlexDirection_Row;
		}
		else if ( [flexDirection isString:@"row-reverse"] )
		{
			return CSSFlexDirection_RowReverse;
		}
		else if ( [flexDirection isString:@"column"] )
		{
			return CSSFlexDirection_Column;
		}
		else if ( [flexDirection isString:@"column-reverse"] )
		{
			return CSSFlexDirection_ColumnReverse;
		}
	}
	
	return defaultValue;
}

- (CSSAlignSelf)computeAlignSelf:(CSSAlignSelf)defaultValue
{
	SamuraiCSSValue * alignSelf = self.alignSelf;
	
	if ( alignSelf )
	{
		if ( [alignSelf isString:@"inherit"] )
		{
			return CSSAlignSelf_Inherit;
		}
		else if ( [alignSelf isString:@"auto"] )
		{
			return CSSAlignSelf_Auto;
		}
		else if ( [alignSelf isString:@"flex-start"] )
		{
			return CSSAlignSelf_FlexStart;
		}
		else if ( [alignSelf isString:@"flex-end"] )
		{
			return CSSAlignSelf_FlexEnd;
		}
		else if ( [alignSelf isString:@"center"] )
		{
			return CSSAlignSelf_Center;
		}
		else if ( [alignSelf isString:@"baseline"] )
		{
			return CSSAlignSelf_Baseline;
		}
		else if ( [alignSelf isString:@"stretch"] )
		{
			return CSSAlignSelf_Stretch;
		}
	}
	
	return defaultValue;
}

- (CSSAlignItems)computeAlignItems:(CSSAlignItems)defaultValue
{
	SamuraiCSSValue * alignItems = self.alignItems;
	
	if ( alignItems )
	{
		if ( [alignItems isString:@"inherit"] )
		{
			return CSSAlignItems_Inherit;
		}
		else if ( [alignItems isString:@"flex-start"] )
		{
			return CSSAlignItems_FlexStart;
		}
		else if ( [alignItems isString:@"flex-end"] )
		{
			return CSSAlignItems_FlexEnd;
		}
		else if ( [alignItems isString:@"center"] )
		{
			return CSSAlignItems_Center;
		}
		else if ( [alignItems isString:@"baseline"] )
		{
			return CSSAlignItems_Baseline;
		}
		else if ( [alignItems isString:@"stretch"] )
		{
			return CSSAlignItems_Stretch;
		}
	}
	
	return defaultValue;
}

- (CSSAlignContent)computeAlignContent:(CSSAlignContent)defaultValue
{
	SamuraiCSSValue * alignContent = self.alignContent;
	
	if ( alignContent )
	{
		if ( [alignContent isString:@"inherit"] )
		{
			return CSSAlignContent_Inherit;
		}
		else if ( [alignContent isString:@"flex-start"] )
		{
			return CSSAlignContent_FlexStart;
		}
		else if ( [alignContent isString:@"flex-end"] )
		{
			return CSSAlignContent_FlexEnd;
		}
		else if ( [alignContent isString:@"center"] )
		{
			return CSSAlignContent_Center;
		}
		else if ( [alignContent isString:@"space-between"] )
		{
			return CSSAlignContent_SpaceBetween;
		}
		else if ( [alignContent isString:@"space-around"] )
		{
			return CSSAlignContent_SpaceAround;
		}
		else if ( [alignContent isString:@"stretch"] )
		{
			return CSSAlignContent_Stretch;
		}
	}

	return defaultValue;
}

- (CSSJustifyContent)computeJustifyContent:(CSSJustifyContent)defaultValue;
{
	SamuraiCSSValue * justifyContent = self.justifyContent;
	
	if ( justifyContent )
	{
		if ( [justifyContent isString:@"inherit"] )
		{
			return CSSJustifyContent_Inherit;
		}
		else if ( [justifyContent isString:@"flex-start"] )
		{
			return CSSJustifyContent_FlexStart;
		}
		else if ( [justifyContent isString:@"flex-end"] )
		{
			return CSSJustifyContent_FlexEnd;
		}
		else if ( [justifyContent isString:@"center"] )
		{
			return CSSJustifyContent_Center;
		}
		else if ( [justifyContent isString:@"space-between"] )
		{
			return CSSJustifyContent_SpaceBetween;
		}
		else if ( [justifyContent isString:@"space-around"] )
		{
			return CSSJustifyContent_SpaceAround;
		}
	}

	return defaultValue;
}

#pragma mark -

- (BOOL)isWidthEqualsToHeight
{
	SamuraiCSSObject * width = self.width;
	
	if ( width )
	{
		if ( [width isFunction:@"equals("] )
		{
			NSObject * firstParam = [[width params] firstObject];
			
			if ( [firstParam isKindOfClass:[NSString class]] )
			{
				if ( [(NSString *)firstParam isEqualToString:@"height"] )
				{
					return YES;
				}
			}
			else if ( [firstParam isKindOfClass:[SamuraiCSSObject class]] )
			{
				if ( [(SamuraiCSSObject *)firstParam isString:@"height"] )
				{
					return YES;
				}
			}
		}
	}
	
	return NO;
}

- (BOOL)isHeightEqualsToWidth
{
	SamuraiCSSObject * height = self.height;

	if ( height )
	{
		if ( [height isFunction:@"equals("] )
		{
			NSObject * firstParam = [[height params] firstObject];
			
			if ( [firstParam isKindOfClass:[NSString class]] )
			{
				if ( [(NSString *)firstParam isEqualToString:@"width"] )
				{
					return YES;
				}
			}
			else if ( [firstParam isKindOfClass:[SamuraiCSSObject class]] )
			{
				if ( [(SamuraiCSSObject *)firstParam isString:@"width"] )
				{
					return YES;
				}
			}
		}
	}

	return NO;
}

#pragma mark -

- (CGFloat)computeTop:(CGFloat)bounds defaultSize:(CGFloat)defaultSize
{
	if ( self.top )
	{
		CGFloat value = [self.top computeValue:bounds];
		
		return INVALID_VALUE == value ? defaultSize : value;
	}
	else
	{
		return defaultSize;
	}
}

- (CGFloat)computeLeft:(CGFloat)bounds defaultSize:(CGFloat)defaultSize
{
	if ( self.left )
	{
		CGFloat value = [self.left computeValue:bounds];
		
		return INVALID_VALUE == value ? defaultSize : value;
	}
	else
	{
		return defaultSize;
	}
}

- (CGFloat)computeRight:(CGFloat)bounds defaultSize:(CGFloat)defaultSize
{
	if ( self.right )
	{
		CGFloat value = [self.right computeValue:bounds];
		
		return INVALID_VALUE == value ? defaultSize : value;
	}
	else
	{
		return defaultSize;
	}
}

- (CGFloat)computeBottom:(CGFloat)bounds defaultSize:(CGFloat)defaultSize
{
	if ( self.bottom )
	{
		CGFloat value = [self.bottom computeValue:bounds];
		
		return INVALID_VALUE == value ? defaultSize : value;
	}
	else
	{
		return defaultSize;
	}
}

#pragma mark -

- (CGFloat)computeWidth:(CGFloat)bounds defaultSize:(CGFloat)defaultSize
{
	if ( self.width )
	{
		CGFloat value = [self.width computeValue:bounds];
		
		return INVALID_VALUE == value ? defaultSize : value;
	}
	else
	{
		return defaultSize;
	}
}

- (CGFloat)computeHeight:(CGFloat)bounds defaultSize:(CGFloat)defaultSize
{
	if ( self.height )
	{
		CGFloat value = [self.height computeValue:bounds];
		
		return INVALID_VALUE == value ? defaultSize : value;
	}
	else
	{
		return defaultSize;
	}
}

#pragma mark -

- (CGFloat)computeMinWidth:(CGFloat)bounds defaultSize:(CGFloat)defaultSize
{
	if ( self.minWidth )
	{
		CGFloat value = [self.minWidth computeValue:bounds];
		
		return INVALID_VALUE == value ? defaultSize : value;
	}
	else
	{
		return defaultSize;
	}
}

- (CGFloat)computeMaxWidth:(CGFloat)bounds defaultSize:(CGFloat)defaultSize
{
	if ( self.maxWidth )
	{
		CGFloat value = [self.maxWidth computeValue:bounds];
		
		return INVALID_VALUE == value ? defaultSize : value;
	}
	else
	{
		return defaultSize;
	}
}

- (CGFloat)computeMinHeight:(CGFloat)bounds defaultSize:(CGFloat)defaultSize
{
	if ( self.minHeight )
	{
		CGFloat value = [self.minHeight computeValue:bounds];

		return INVALID_VALUE == value ? defaultSize : value;
	}
	else
	{
		return defaultSize;
	}
}

- (CGFloat)computeMaxHeight:(CGFloat)bounds defaultSize:(CGFloat)defaultSize
{
	if ( self.maxHeight )
	{
		CGFloat value = [self.maxHeight computeValue:bounds];

		return INVALID_VALUE == value ? defaultSize : value;
	}
	else
	{
		return defaultSize;
	}
}

#pragma mark -

- (CGFloat)computeInsetTopSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize
{
	SamuraiCSSValue * top = self.insetTop ?: self.inset.top;
	
	if ( top )
	{
		CGFloat value = [top computeValue:bounds];
		
		return INVALID_VALUE == value ? defaultSize : value;
	}
	else
	{
		return defaultSize;
	}
}

- (CGFloat)computeInsetLeftSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize
{
	SamuraiCSSValue * left = self.insetLeft ?: self.inset.left;
	
	if ( left )
	{
		CGFloat value = [left computeValue:bounds];
		
		return INVALID_VALUE == value ? defaultSize : value;
	}
	else
	{
		return defaultSize;
	}
}

- (CGFloat)computeInsetRightSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize
{
	SamuraiCSSValue * right = self.insetRight ?: self.inset.right;
	
	if ( right )
	{
		CGFloat value = [right computeValue:bounds];
		
		return INVALID_VALUE == value ? defaultSize : value;
	}
	else
	{
		return defaultSize;
	}
}

- (CGFloat)computeInsetBottomSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize
{
	SamuraiCSSValue * bottom = self.insetBottom ?: self.inset.bottom;
	
	if ( bottom )
	{
		CGFloat value = [bottom computeValue:bounds];
		
		return INVALID_VALUE == value ? defaultSize : value;
	}
	else
	{
		return defaultSize;
	}
}

#pragma mark -

- (CGFloat)computePaddingTopSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize
{
	SamuraiCSSValue * top = self.paddingTop ?: (self.padding.top ?: self.webkitPaddingBefore);
	
	if ( top )
	{
		CGFloat value = [top computeValue:bounds];
		
		return INVALID_VALUE == value ? defaultSize : value;
	}
	else
	{
		return defaultSize;
	}
}

- (CGFloat)computePaddingLeftSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize
{
	SamuraiCSSValue * left = self.paddingLeft ?: (self.padding.left ?: self.webkitPaddingStart);
	
	if ( left )
	{
		CGFloat value = [left computeValue:bounds];
		
		return INVALID_VALUE == value ? defaultSize : value;
	}
	else
	{
		return defaultSize;
	}
}

- (CGFloat)computePaddingRightSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize
{
	SamuraiCSSValue * right = self.paddingRight ?: (self.padding.right ?: self.webkitPaddingEnd);
	
	if ( right )
	{
		CGFloat value = [right computeValue:bounds];
		
		return INVALID_VALUE == value ? defaultSize : value;
	}
	else
	{
		return defaultSize;
	}
}

- (CGFloat)computePaddingBottomSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize
{
	SamuraiCSSValue * bottom = self.paddingBottom ?: (self.padding.bottom ?: self.webkitPaddingAfter);
	
	if ( bottom )
	{
		CGFloat value = [bottom computeValue:bounds];
		
		return INVALID_VALUE == value ? defaultSize : value;
	}
	else
	{
		return defaultSize;
	}
}

#pragma mark -

- (CGFloat)computeMarginTopSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize
{
	SamuraiCSSValue * top = self.marginTop ?: (self.margin.top ?: self.webkitMarginBefore);
	
	if ( top )
	{
		CGFloat value = [top computeValue:bounds];
		
		return INVALID_VALUE == value ? defaultSize : value;
	}
	else
	{
		return defaultSize;
	}
}

- (CGFloat)computeMarginLeftSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize
{
	SamuraiCSSValue * left = self.marginLeft ?: (self.margin.left ?: self.webkitMarginStart);
	
	if ( left )
	{
		CGFloat value = [left computeValue:bounds];
		
		return INVALID_VALUE == value ? defaultSize : value;
	}
	else
	{
		return defaultSize;
	}
}

- (CGFloat)computeMarginRightSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize
{
	SamuraiCSSValue * right = self.marginRight ?: (self.margin.right ?: self.webkitMarginEnd);
	
	if ( right )
	{
		CGFloat value = [right computeValue:bounds];
		
		return INVALID_VALUE == value ? defaultSize : value;
	}
	else
	{
		return defaultSize;
	}
}

- (CGFloat)computeMarginBottomSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize
{
	SamuraiCSSValue * bottom = self.marginBottom ?: (self.margin.bottom ?: self.webkitMarginAfter);
	
	if ( bottom )
	{
		CGFloat value = [bottom computeValue:bounds];
		
		return INVALID_VALUE == value ? defaultSize : value;
	}
	else
	{
		return defaultSize;
	}
}

#pragma mark -

- (UIColor *)computeBorderTopColor:(UIColor *)defaultColor
{
	SamuraiCSSValue * borderColor = nil;

	if ( nil == borderColor )
	{
		borderColor = self.borderTopColor;
	}

	if ( nil == borderColor )
	{
		borderColor = self.borderColor.top;
	}

	if ( nil == borderColor )
	{
		for ( SamuraiCSSValue * item in self.borderTop.array )
		{
			if ( [item isColor] )
			{
				borderColor = borderColor ?: item;
			}
		}
	}
	
	if ( nil == borderColor )
	{
		for ( SamuraiCSSValue * item in self.border.array )
		{
			if ( [item isColor] )
			{
				borderColor = borderColor ?: item;
			}
		}
	}
	
	if ( borderColor && [borderColor isColor] )
	{
		return [borderColor color];
	}
	else
	{
		return defaultColor;
	}
}

- (UIColor *)computeBorderLeftColor:(UIColor *)defaultColor
{
	SamuraiCSSValue * borderColor = nil;
	
	if ( nil == borderColor )
	{
		borderColor = self.borderLeftColor;
	}
	
	if ( nil == borderColor )
	{
		borderColor = self.borderColor.left;
	}

	if ( nil == borderColor )
	{
		for ( SamuraiCSSValue * item in self.borderLeft.array )
		{
			if ( [item isColor] )
			{
				borderColor = borderColor ?: item;
			}
		}
	}
	
	if ( nil == borderColor )
	{
		for ( SamuraiCSSValue * item in self.border.array )
		{
			if ( [item isColor] )
			{
				borderColor = borderColor ?: item;
			}
		}
	}

	if ( borderColor && [borderColor isColor] )
	{
		return [borderColor color];
	}
	else
	{
		return defaultColor;
	}
}

- (UIColor *)computeBorderRightColor:(UIColor *)defaultColor
{
	SamuraiCSSValue * borderColor = nil;
	
	if ( nil == borderColor )
	{
		borderColor = self.borderRightColor;
	}

	if ( nil == borderColor )
	{
		borderColor = self.borderColor.right;
	}

	if ( nil == borderColor )
	{
		for ( SamuraiCSSValue * item in self.borderRight.array )
		{
			if ( [item isColor] )
			{
				borderColor = borderColor ?: item;
			}
		}
	}
	
	if ( nil == borderColor )
	{
		for ( SamuraiCSSValue * item in self.border.array )
		{
			if ( [item isColor] )
			{
				borderColor = borderColor ?: item;
			}
		}
	}

	if ( borderColor && [borderColor isColor] )
	{
		return [borderColor color];
	}
	else
	{
		return defaultColor;
	}
}

- (UIColor *)computeBorderBottomColor:(UIColor *)defaultColor
{
	SamuraiCSSValue * borderColor = nil;
	
	if ( nil == borderColor )
	{
		borderColor = self.borderBottomColor;
	}
	
	if ( nil == borderColor )
	{
		borderColor = self.borderColor.bottom;
	}

	if ( nil == borderColor )
	{
		for ( SamuraiCSSValue * item in self.borderBottom.array )
		{
			if ( [item isColor] )
			{
				borderColor = borderColor ?: item;
			}
		}
	}
	
	if ( nil == borderColor )
	{
		for ( SamuraiCSSValue * item in self.border.array )
		{
			if ( [item isColor] )
			{
				borderColor = borderColor ?: item;
			}
		}
	}

	if ( borderColor && [borderColor isColor] )
	{
		return [borderColor color];
	}
	else
	{
		return defaultColor;
	}
}

#pragma mark -

- (CGFloat)computeBorderTopSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize
{
	SamuraiCSSValue * borderSize = nil;

	if ( nil == borderSize )
	{
		borderSize = self.borderTopWidth;
	}
	
	if ( nil == borderSize )
	{
		borderSize = self.borderWidth.top;
	}

	if ( nil == borderSize )
	{
		for ( SamuraiCSSValue * item in self.borderTop.array )
		{
			if ( [item isBorderSize] )
			{
				borderSize = borderSize ?: item;
			}
		}
	}

	if ( nil == borderSize )
	{
		for ( SamuraiCSSValue * item in self.border.array )
		{
			if ( [item isBorderSize] )
			{
				borderSize = borderSize ?: item;
			}
		}
	}

	if ( borderSize )
	{
		CGFloat value = [borderSize computeBorderSize:bounds];

		return INVALID_VALUE == value ? defaultSize : value;
	}
	else
	{
		return defaultSize;
	}
}

- (CGFloat)computeBorderLeftSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize
{
	SamuraiCSSValue * borderSize = nil;
	
	if ( nil == borderSize )
	{
		borderSize = self.borderLeftWidth;
	}
	
	if ( nil == borderSize )
	{
		borderSize = self.borderWidth.left;
	}

	if ( nil == borderSize )
	{
		for ( SamuraiCSSValue * item in self.borderLeft.array )
		{
			if ( [item isBorderSize] )
			{
				borderSize = borderSize ?: item;
			}
		}
	}
	
	if ( nil == borderSize )
	{
		for ( SamuraiCSSValue * item in self.border.array )
		{
			if ( [item isBorderSize] )
			{
				borderSize = borderSize ?: item;
			}
		}
	}

	if ( borderSize )
	{
		CGFloat value = [borderSize computeBorderSize:bounds];
		
		return INVALID_VALUE == value ? defaultSize : value;
	}
	else
	{
		return defaultSize;
	}
}

- (CGFloat)computeBorderRightSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize
{
	SamuraiCSSValue * borderSize = nil;
	
	if ( nil == borderSize )
	{
		borderSize = self.borderRightWidth;
	}
	
	if ( nil == borderSize )
	{
		borderSize = self.borderWidth.right;
	}

	if ( nil == borderSize )
	{
		for ( SamuraiCSSValue * item in self.borderRight.array )
		{
			if ( [item isBorderSize] )
			{
				borderSize = borderSize ?: item;
			}
		}
	}
	
	if ( nil == borderSize )
	{
		for ( SamuraiCSSValue * item in self.border.array )
		{
			if ( [item isBorderSize] )
			{
				borderSize = borderSize ?: item;
			}
		}
	}

	if ( borderSize )
	{
		CGFloat value = [borderSize computeBorderSize:bounds];
		
		return INVALID_VALUE == value ? defaultSize : value;
	}
	else
	{
		return defaultSize;
	}
}

- (CGFloat)computeBorderBottomSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize
{
	SamuraiCSSValue * borderSize = nil;
	
	if ( nil == borderSize )
	{
		borderSize = self.borderBottomWidth;
	}
	
	if ( nil == borderSize )
	{
		borderSize = self.borderWidth.bottom;
	}

	if ( nil == borderSize )
	{
		for ( SamuraiCSSValue * item in self.borderBottom.array )
		{
			if ( [item isBorderSize] )
			{
				borderSize = borderSize ?: item;
			}
		}
	}
	
	if ( nil == borderSize )
	{
		for ( SamuraiCSSValue * item in self.border.array )
		{
			if ( [item isBorderSize] )
			{
				borderSize = borderSize ?: item;
			}
		}
	}

	if ( borderSize )
	{
		CGFloat value = [borderSize computeBorderSize:bounds];
		
		return INVALID_VALUE == value ? defaultSize : value;
	}
	else
	{
		return defaultSize;
	}
}

#pragma mark -

- (CSSBorderStyle)computeBorderTopStyle:(CSSBorderStyle)defaultStyle
{
	SamuraiCSSValue * borderStyle = nil;
	
	if ( nil == borderStyle )
	{
		borderStyle = self.borderTopStyle;
	}

	if ( nil == borderStyle )
	{
		borderStyle = self.borderStyle.top;
	}

	if ( nil == borderStyle )
	{
		for ( SamuraiCSSValue * item in self.borderTop.array )
		{
			if ( [item isBorderStyle] )
			{
				borderStyle = borderStyle ?: item;
			}
		}
	}

	if ( nil == borderStyle )
	{
		for ( SamuraiCSSValue * item in self.border.array )
		{
			if ( [item isBorderStyle] )
			{
				borderStyle = borderStyle ?: item;
			}
		}
	}

	if ( borderStyle && [borderStyle isBorderStyle] )
	{
		return [borderStyle computeBorderStyle:defaultStyle];
	}
	else
	{
		return defaultStyle;
	}
}

- (CSSBorderStyle)computeBorderLeftStyle:(CSSBorderStyle)defaultStyle
{
	SamuraiCSSValue * borderStyle = nil;
	
	if ( nil == borderStyle )
	{
		borderStyle = self.borderLeftStyle;
	}
	
	if ( nil == borderStyle )
	{
		borderStyle = self.borderStyle.left;
	}

	if ( nil == borderStyle )
	{
		for ( SamuraiCSSValue * item in self.borderLeft.array )
		{
			if ( [item isBorderStyle] )
			{
				borderStyle = borderStyle ?: item;
			}
		}
	}
	
	if ( nil == borderStyle )
	{
		for ( SamuraiCSSValue * item in self.border.array )
		{
			if ( [item isBorderStyle] )
			{
				borderStyle = borderStyle ?: item;
			}
		}
	}

	if ( borderStyle && [borderStyle isBorderStyle] )
	{
		return [borderStyle computeBorderStyle:defaultStyle];
	}
	else
	{
		return defaultStyle;
	}
}

- (CSSBorderStyle)computeBorderRightStyle:(CSSBorderStyle)defaultStyle
{
	SamuraiCSSValue * borderStyle = nil;
	
	if ( nil == borderStyle )
	{
		borderStyle = self.borderRightStyle;
	}

	if ( nil == borderStyle )
	{
		borderStyle = self.borderStyle.right;
	}

	if ( nil == borderStyle )
	{
		for ( SamuraiCSSValue * item in self.borderRight.array )
		{
			if ( [item isBorderStyle] )
			{
				borderStyle = borderStyle ?: item;
			}
		}
	}
	
	if ( nil == borderStyle )
	{
		for ( SamuraiCSSValue * item in self.border.array )
		{
			if ( [item isBorderStyle] )
			{
				borderStyle = borderStyle ?: item;
			}
		}
	}

	if ( borderStyle && [borderStyle isBorderStyle] )
	{
		return [borderStyle computeBorderStyle:defaultStyle];
	}
	else
	{
		return defaultStyle;
	}
}

- (CSSBorderStyle)computeBorderBottomStyle:(CSSBorderStyle)defaultStyle
{
	SamuraiCSSValue * borderStyle = nil;
	
	if ( nil == borderStyle )
	{
		borderStyle = self.borderBottomStyle;
	}

	if ( nil == borderStyle )
	{
		borderStyle = self.borderStyle.bottom;
	}

	if ( nil == borderStyle )
	{
		for ( SamuraiCSSValue * item in self.borderBottom.array )
		{
			if ( [item isBorderStyle] )
			{
				borderStyle = borderStyle ?: item;
			}
		}
	}

	if ( nil == borderStyle )
	{
		for ( SamuraiCSSValue * item in self.border.array )
		{
			if ( [item isBorderStyle] )
			{
				borderStyle = borderStyle ?: item;
			}
		}
	}

	if ( borderStyle && [borderStyle isBorderStyle] )
	{
		return [borderStyle computeBorderStyle:defaultStyle];
	}
	else
	{
		return defaultStyle;
	}
}

#pragma mark -

- (CGFloat)computeBorderTopLeftRadius:(CGFloat)bounds defaultRadius:(CGFloat)defaultRadius
{
	TODO( "border radius" )
	
	if ( self.borderRadius && [self.borderRadius count] > 0 )
	{
		CGFloat radius = [[self.borderRadius objectAtIndex:0] computeValue:bounds];
		
		return INVALID_VALUE == radius ? defaultRadius : radius;
	}
	else
	{
		return defaultRadius;
	}
}

- (CGFloat)computeBorderTopRightRadius:(CGFloat)bounds defaultRadius:(CGFloat)defaultRadius
{
	TODO( "border radius" )
	
	if ( self.borderRadius && [self.borderRadius count] > 0 )
	{
		CGFloat radius = [[self.borderRadius objectAtIndex:0] computeValue:bounds];
		
		return INVALID_VALUE == radius ? defaultRadius : radius;
	}
	else
	{
		return defaultRadius;
	}
}

- (CGFloat)computeBorderBottomLeftRadius:(CGFloat)bounds defaultRadius:(CGFloat)defaultRadius
{
	TODO( "border radius" )
	
	if ( self.borderRadius && [self.borderRadius count] > 0 )
	{
		CGFloat radius = [[self.borderRadius objectAtIndex:0] computeValue:bounds];
		
		return INVALID_VALUE == radius ? defaultRadius : radius;
	}
	else
	{
		return defaultRadius;
	}
}

- (CGFloat)computeBorderBottomRightRadius:(CGFloat)bounds defaultRadius:(CGFloat)defaultRadius
{
	TODO( "border radius" )
	
	if ( self.borderRadius && [self.borderRadius count] > 0 )
	{
		CGFloat radius = [[self.borderRadius objectAtIndex:0] computeValue:bounds];
		
		return INVALID_VALUE == radius ? defaultRadius : radius;
	}
	else
	{
		return defaultRadius;
	}
}

#pragma mark -

- (CGFloat)computeBorderSpacing:(CGFloat)bounds defaultSize:(CGFloat)defaultSize
{
	if ( self.borderSpacing )
	{
		CGFloat value = [self.borderSpacing computeValue:defaultSize];
		
		return INVALID_VALUE == value ? defaultSize : value;
	}
	else
	{
		return defaultSize;
	}
}

- (CGFloat)computeCellSpacing:(CGFloat)bounds defaultSize:(CGFloat)defaultSize
{
	if ( self.cellSpacing )
	{
		CGFloat value = [self.cellSpacing computeValue:defaultSize];
		
		return INVALID_VALUE == value ? defaultSize : value;
	}
	else
	{
		return defaultSize;
	}
}

- (CGFloat)computeCellPadding:(CGFloat)bounds defaultSize:(CGFloat)defaultSize
{
	if ( self.cellPadding )
	{
		CGFloat value = [self.cellPadding computeValue:defaultSize];
		
		return INVALID_VALUE == value ? defaultSize : value;
	}
	else
	{
		return defaultSize;
	}
}

- (CGFloat)computeTextIndent:(CGFloat)defaultSize
{
	if ( self.textIndent )
	{
		CGFloat textIndent = [self.textIndent computeValue:defaultSize];
		
		return INVALID_VALUE == textIndent ? defaultSize : textIndent;
	}
	else
	{
		return INVALID_VALUE;
	}
}

- (CGFloat)computeLineHeight:(CGFloat)fontHeight defaultSize:(CGFloat)defaultSize
{
	if ( self.lineHeight )
	{
		CGFloat lineHeight = 0.0f;
		
		if ( [self.lineHeight isConstant] )
		{
			lineHeight = [self.lineHeight computeValue:fontHeight];
			lineHeight = NORMALIZE_VALUE( lineHeight );

			lineHeight = fontHeight * lineHeight;
		}
		else if ( [self.lineHeight isPercentage] )
		{
			lineHeight = [self.lineHeight computeValue:fontHeight];
			lineHeight = NORMALIZE_VALUE( lineHeight );
		}
		else if ( [self.lineHeight isString:@"normal"] )
		{
			lineHeight = [SamuraiHtmlUserAgent sharedInstance].defaultFont.lineHeight;
		}
		else
		{
			lineHeight = [self.lineHeight computeValue:fontHeight];
			lineHeight = NORMALIZE_VALUE( lineHeight );
		}

		return lineHeight;
	}
	else
	{
		return defaultSize;
	}
}

- (CGFloat)computeLetterSpacing:(CGFloat)defaultSize
{
	if ( self.letterSpacing )
	{
		CGFloat letterSpacing = [self.letterSpacing computeValue:defaultSize];
		
		return INVALID_VALUE == letterSpacing ? defaultSize : letterSpacing;
	}
	else
	{
		return INVALID_VALUE;
	}
}

- (CGFloat)computeOrder:(CGFloat)defaultOrder
{
	if ( self.order )
	{
		CGFloat order = [self.order computeValue:INVALID_VALUE];
		
		return INVALID_VALUE == order ? defaultOrder : order;
	}
	else
	{
		return defaultOrder;
	}
}

- (CGFloat)computeZIndex:(CGFloat)defaultIndex
{
	if ( self.zIndex )
	{
		CGFloat zIndex = [self.zIndex computeValue:INVALID_VALUE];
		
		return INVALID_VALUE == zIndex ? defaultIndex : zIndex;
	}
	else
	{
		return defaultIndex;
	}
}

- (CGFloat)computeFlexGrow:(CGFloat)defaultValue
{
	SamuraiCSSValue * grow = self.flexGrow ?: [self.flex objectAtIndex:0];
	
	if ( grow )
	{
		CGFloat flexGrow = [grow computeValue:INVALID_VALUE];
		
		return INVALID_VALUE == flexGrow ? defaultValue : flexGrow;
	}
	else
	{
		return defaultValue;
	}
}

- (CGFloat)computeFlexShrink:(CGFloat)defaultValue
{
	SamuraiCSSValue * shrink = self.flexShrink ?: [self.flex objectAtIndex:1];

	if ( shrink )
	{
		CGFloat flexShrink = [shrink computeValue:INVALID_VALUE];
		
		return INVALID_VALUE == flexShrink ? defaultValue : flexShrink;
	}
	else
	{
		return defaultValue;
	}
}

- (CGFloat)computeFlexBasis:(CGFloat)defaultValue
{
	SamuraiCSSValue * basis = self.flexBasis ?: [self.flex objectAtIndex:2];

	if ( basis )
	{
		CGFloat flexBasis = [basis computeValue:INVALID_VALUE];
		
		return INVALID_VALUE == flexBasis ? defaultValue : flexBasis;
	}
	else
	{
		return defaultValue;
	}
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlRenderStyle )
{
	SamuraiHtmlRenderStyle *	_style;
}

- (void)testNumberForKey:(NSString *)key
{
	SamuraiCSSValue * value = nil;

// set string
	
	[_style setValue:makePx( 1234 ) forKey:key];
	
	value = [_style valueForKey:key];
	
	EXPECTED( nil != value );
	EXPECTED( [value isNumber] );
	EXPECTED( [value isNumber:1234] );

// set string
	
	[_style setValue:makeDp( 1234 ) forKey:key];
	
	value = [_style valueForKey:key];
	
	EXPECTED( nil != value );
	EXPECTED( [value isNumber] );
	EXPECTED( [value isNumber:1234] );

// set string
	
	[_style setValue:makeEm( 1234 ) forKey:key];
	
	value = [_style valueForKey:key];
	
	EXPECTED( nil != value );
	EXPECTED( [value isNumber] );
	EXPECTED( [value isNumber:1234] );

// set string
	
	[_style setValue:makePercent( 33.0 ) forKey:key];
	
	value = [_style valueForKey:key];

	EXPECTED( nil != value );
	EXPECTED( [value isNumber] );
	EXPECTED( [value isNumber:33.0f] );

// set auto
	
	[_style setValue:makeAuto() forKey:key];

	value = [_style valueForKey:key];
	
	EXPECTED( nil != value );
	EXPECTED( [value isNumber] );
	EXPECTED( [value isAutomatic] );
}

- (void)testColorForKey:(NSString *)key
{
	SamuraiCSSValue * value = nil;
	
// set string
	
	[_style setValue:makeColor( [UIColor blackColor] ) forKey:key];
	
	value = [_style valueForKey:key];
	
	EXPECTED( nil != value );
	EXPECTED( [value isColor] );

// set string
	
	[_style setValue:makeColor_( "#333" ) forKey:key];
	
	value = [_style valueForKey:key];
	
	EXPECTED( nil != value );
	EXPECTED( [value isColor] );

// set string
	
	[_style setValue:makeColor_( "rgb(1,1,1)" ) forKey:key];
	
	value = [_style valueForKey:key];
	
	EXPECTED( nil != value );
	EXPECTED( [value isColor] );

// set string
	
	[_style setValue:makeColor_( "rgba(1,1,1, 0.5)" ) forKey:key];
	
	value = [_style valueForKey:key];
	
	EXPECTED( nil != value );
	EXPECTED( [value isColor] );

// set short hex
	
	[_style setValue:makeHexShort_( 0x333 ) forKey:key];
	
	value = [_style valueForKey:key];
	
	EXPECTED( nil != value );
	EXPECTED( [value isColor] );

// set hex

	[_style setValue:makeHex_( 0x333333 ) forKey:key];
	
	value = [_style valueForKey:key];
	
	EXPECTED( nil != value );
	EXPECTED( [value isColor] );

// set hex with alpha
	
	[_style setValue:makeHexA_( 0x333333, 0.5 ) forKey:key];
	
	value = [_style valueForKey:key];
	
	EXPECTED( nil != value );
	EXPECTED( [value isColor] );

// set RGB
	
	[_style setValue:makeRGB_( 1,2,3 ) forKey:key];
	
	value = [_style valueForKey:key];
	
	EXPECTED( nil != value );
	EXPECTED( [value isColor] );

// set RGB with alpha
	
	[_style setValue:makeRGBA_( 1,2,3, 0.5 ) forKey:key];
	
	value = [_style valueForKey:key];
	
	EXPECTED( nil != value );
	EXPECTED( [value isColor] );
}

- (void)testStringForKey:(NSString *)key
{
	SamuraiCSSValue * value = nil;
	
// set string
	
	[_style setValue:makeString( @"hello" ) forKey:key];
	
	value = [_style valueForKey:key];
	
	EXPECTED( nil != value );
	EXPECTED( [value isString] );
	EXPECTED( [value isString:@"hello"] );

// set string

	[_style setValue:makeString_( "hello" ) forKey:key];
	
	value = [_style valueForKey:key];
	
	EXPECTED( nil != value );
	EXPECTED( [value isString] );
	EXPECTED( [value isString:@"hello"] );
}

- (void)testUrlForKey:(NSString *)key
{
	SamuraiCSSValue * value = nil;
	
// set string
	
	[_style setValue:makeUrl( [NSURL URLWithString:@"http://www.github.com"] ) forKey:key];
	
	value = [_style valueForKey:key];
	
	EXPECTED( nil != value );
	EXPECTED( [value isUri] );
	EXPECTED( [value isUri:@"http://www.github.com"] );

// set string

	[_style setValue:makeUrl_( "http://www.github.com" ) forKey:key];
	
	value = [_style valueForKey:key];
	
	EXPECTED( nil != value );
	EXPECTED( [value isUrl] );
	EXPECTED( [value isUrl:@"http://www.github.com"] );
}

- (void)testArrayForKey:(NSString *)key
{
	SamuraiCSSValue * value = nil;
	
// set array

	NSArray * array = @[ @(1), @"2px", makeFloat( 1.0f ), makeString_("hello") ];

	[_style setValue:makeArray( array ) forKey:key];

	value = [_style valueForKey:key];
	
	EXPECTED( nil != value );
	EXPECTED( [value isArray] );
	EXPECTED( [[value objectAtIndex:0] isNumber:1] );
	EXPECTED( [[value objectAtIndex:1] isNumber:2] );
	EXPECTED( [[value objectAtIndex:2] isNumber:1] );
	EXPECTED( [[value objectAtIndex:3] isString:@"hello"] );

// set array

	[_style setValue:makeArray_( @(1), @(2), @(3), @(4) ) forKey:key];

	value = [_style valueForKey:key];

	EXPECTED( nil != value );
	EXPECTED( [value isArray] );
	EXPECTED( [[value objectAtIndex:0] isNumber:1] );
	EXPECTED( [[value objectAtIndex:1] isNumber:2] );
	EXPECTED( [[value objectAtIndex:2] isNumber:3] );
	EXPECTED( [[value objectAtIndex:3] isNumber:4] );
}

- (void)testBoxForKey:(NSString *)key
{
	SamuraiCSSBox * value = nil;

// set box

	NSArray * array = @[ @(1), @"2px", @(3), @"4px" ];

	[_style setValue:makeBox( array ) forKey:key];

	value = [_style valueForKey:key];
	
	EXPECTED( nil != value );
	EXPECTED( [value isBox] );
	EXPECTED( [value.top isNumber:1] );
	EXPECTED( [value.right isNumber:2] );
	EXPECTED( [value.bottom isNumber:3] );
	EXPECTED( [value.left isNumber:4] );
	
// set box list
	
	[_style setValue:makeBox_( 1, 2, 3, 4 ) forKey:key];

	value = [_style valueForKey:key];

	EXPECTED( [value isBox] );
	EXPECTED( [value.top isNumber:1] );
	EXPECTED( [value.right isNumber:2] );
	EXPECTED( [value.bottom isNumber:3] );
	EXPECTED( [value.left isNumber:4] );
}

- (void)testValueForKey:(NSString *)key
{
	[self testUrlForKey:key];
	[self testColorForKey:key];
	[self testNumberForKey:key];
	[self testStringForKey:key];
}

DESCRIBE( before )
{
	_style = [[SamuraiHtmlRenderStyle alloc] init];
}

DESCRIBE( test )
{
	[self testValueForKey:@"top"];
	[self testValueForKey:@"left"];
	[self testValueForKey:@"right"];
	[self testValueForKey:@"bottom"];
	
	[self testValueForKey:@"width"];
	[self testValueForKey:@"minWidth"];
	[self testValueForKey:@"maxWidth"];
	
	[self testValueForKey:@"height"];
	[self testValueForKey:@"minHeight"];
	[self testValueForKey:@"maxHeight"];
	
	[self testValueForKey:@"position"];
	[self testValueForKey:@"floating"];
	
	[self testValueForKey:@"display"];
	[self testValueForKey:@"overflow"];
	[self testValueForKey:@"visibility"];
	[self testValueForKey:@"opacity"];
	
	[self testArrayForKey:@"boxShadow"];
	
	[self testValueForKey:@"baseline"];
	[self testValueForKey:@"wordWrap"];
	[self testValueForKey:@"contentMode"];
	
	[self testValueForKey:@"color"];
	[self testValueForKey:@"direction"];
	[self testValueForKey:@"letterSpacing"];
	[self testValueForKey:@"lineHeight"];
	[self testValueForKey:@"textAlign"];
	[self testValueForKey:@"textDecoration"];
	[self testValueForKey:@"textIndent"];
	[self testArrayForKey:@"textShadow"];
	[self testValueForKey:@"textTransform"];
	[self testValueForKey:@"textOverflow"];
	[self testValueForKey:@"unicodeBidi"];
	[self testValueForKey:@"whiteSpace"];
	[self testValueForKey:@"wordSpacing"];
	
	// background
	
	[self testArrayForKey:@"background"];
	[self testValueForKey:@"backgroundColor"];
	[self testValueForKey:@"backgroundImage"];
	
	// flex box
	
	[self testValueForKey:@"flex"];
	[self testValueForKey:@"flexWrap"];
	[self testValueForKey:@"flexFlow"];
	[self testValueForKey:@"flexDirection"];
	
	// font
	
	[self testArrayForKey:@"font"];
	[self testArrayForKey:@"fontFamily"];
	[self testValueForKey:@"fontVariant"];
	[self testValueForKey:@"fontStyle"];
	[self testValueForKey:@"fontSize"];
	[self testValueForKey:@"fontWeight"];
	
	// border
	
	[self testArrayForKey:@"border"];
	[self testValueForKey:@"borderWidth"];
	[self testValueForKey:@"borderStyle"];
	[self testValueForKey:@"borderColor"];
	
	[self testValueForKey:@"borderRadius"];
	[self testValueForKey:@"borderTopLeftRadius"];
	[self testValueForKey:@"borderTopRightRadius"];
	[self testValueForKey:@"borderBottomLeftRadius"];
	[self testValueForKey:@"borderBottomRightRadius"];
	
	[self testValueForKey:@"borderTop"];
	[self testValueForKey:@"borderTopColor"];
	[self testValueForKey:@"borderTopStyle"];
	[self testValueForKey:@"borderTopWidth"];
	
	[self testValueForKey:@"borderLeft"];
	[self testValueForKey:@"borderLeftColor"];
	[self testValueForKey:@"borderLeftStyle"];
	[self testValueForKey:@"borderLeftWidth"];
	
	[self testValueForKey:@"borderRight"];
	[self testValueForKey:@"borderRightColor"];
	[self testValueForKey:@"borderRightStyle"];
	[self testValueForKey:@"borderRightWidth"];
	
	[self testValueForKey:@"borderBottom"];
	[self testValueForKey:@"borderBottomColor"];
	[self testValueForKey:@"borderBottomStyle"];
	[self testValueForKey:@"borderBottomWidth"];
	
	// margin
	
	[self testBoxForKey:@"margin"];
	[self testValueForKey:@"marginTop"];
	[self testValueForKey:@"marginLeft"];
	[self testValueForKey:@"marginRight"];
	[self testValueForKey:@"marginBottom"];
	
	// padding
	
	[self testBoxForKey:@"padding"];
	[self testValueForKey:@"paddingTop"];
	[self testValueForKey:@"paddingLeft"];
	[self testValueForKey:@"paddingRight"];
	[self testValueForKey:@"paddingBottom"];
	
	// inset
	
	[self testBoxForKey:@"inset"];
	[self testValueForKey:@"insetTop"];
	[self testValueForKey:@"insetLeft"];
	[self testValueForKey:@"insetRight"];
	[self testValueForKey:@"insetBottom"];
	
	// render
	
	[self testValueForKey:@"renderModel"];
	[self testValueForKey:@"renderClass"];
}

DESCRIBE( after )
{
	_style = nil;
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "_pragma_pop.h"
