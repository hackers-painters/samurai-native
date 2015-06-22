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

#import "Samurai_HtmlStyle.h"
#import "Samurai_CSSStyleSheet.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_HtmlUserAgent.h"
#import "Samurai_HtmlNumberAutomatic.h"
#import "Samurai_HtmlNumberPercentage.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@interface SamuraiHtmlStyleObject(Extension)

- (BOOL)isBorderSize;
- (BOOL)isBorderStyle;

- (CGFloat)computeBorderSize:(CGFloat)bounds;
- (HtmlRenderBorderStyle)computeBorderStyle:(HtmlRenderBorderStyle)defaultStyle;

@end

#pragma mark -

@implementation SamuraiHtmlStyleObject(Extension)

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

- (HtmlRenderBorderStyle)computeBorderStyle:(HtmlRenderBorderStyle)defaultStyle
{
	if ( [self isString:@"inherit"] )
	{
		return HtmlRenderBorderStyle_Inherit;
	}
	else if ( [self isString:@"none"] )
	{
		return HtmlRenderBorderStyle_None;
	}
	else if ( [self isString:@"hidden"] )
	{
		return HtmlRenderBorderStyle_Hidden;
	}
	else if ( [self isString:@"dotted"] )
	{
		return HtmlRenderBorderStyle_Dotted;
	}
	else if ( [self isString:@"dashed"] )
	{
		return HtmlRenderBorderStyle_Dashed;
	}
	else if ( [self isString:@"solid"] )
	{
		return HtmlRenderBorderStyle_Solid;
	}
	else if ( [self isString:@"double"] )
	{
		return HtmlRenderBorderStyle_Double;
	}
	else if ( [self isString:@"groove"] )
	{
		return HtmlRenderBorderStyle_Groove;
	}
	else if ( [self isString:@"ridge"] )
	{
		return HtmlRenderBorderStyle_Ridge;
	}
	else if ( [self isString:@"inset"] )
	{
		return HtmlRenderBorderStyle_Inset;
	}
	else if ( [self isString:@"outset"] )
	{
		return HtmlRenderBorderStyle_Outset;
	}
	else
	{
		return defaultStyle;
	}
}

@end

#pragma mark -

@implementation SamuraiHtmlStyle

@def_html_style_value( top, setTop,											@"top" );
@def_html_style_value( left, setLeft,										@"left");
@def_html_style_value( right, setRight,										@"right");
@def_html_style_value( bottom, setBottom,									@"bottom" );

@def_html_style_value( width, setWidth,										@"width" );
@def_html_style_value( minWidth, setMinWidth,								@"min-width" );
@def_html_style_value( maxWidth, setMaxWidth,								@"max-width" );

@def_html_style_value( height, setHeight,									@"height" );
@def_html_style_value( minHeight, setMinHeight,								@"min-height" );
@def_html_style_value( maxHeight, setMaxHeight,								@"max-height" );

@def_html_style_value( position, setPosition,								@"position" );
@def_html_style_value( floating, setFloating,								@"float" );
@def_html_style_value( clear, setClear,										@"clear" );

@def_html_style_value( zIndex, setZIndex,									@"z-index" );
@def_html_style_value( display, setDisplay,									@"display" );
@def_html_style_value( overflow, setOverflow,								@"overflow" );
@def_html_style_value( visibility, setVisibility,							@"visibility" );
@def_html_style_value( opacity, setOpacity,									@"opacity" );

@def_html_style_value( boxSizing, setBoxSizing,								@"box-sizing" );
@def_html_style_array( boxShadow, setBoxShadow,								@"box-shadow" );

@def_html_style_value( baseline, setBaseline,								@"baseline" );
@def_html_style_value( wordWrap, setWordWrap,								@"word-wrap" );
@def_html_style_value( contentMode, setContentMode,							@"content-mode" );

@def_html_style_value( color, setColor,										@"color" );
@def_html_style_value( direction, setDirection,								@"direction" );
@def_html_style_value( letterSpacing, setLetterSpacing,						@"letter-spacing" );
@def_html_style_value( lineHeight, setLineHeight,							@"line-height" );
@def_html_style_value( align, setAlign,										@"align" );
@def_html_style_value( verticalAlign, setVerticalAlign,						@"vertical-align" );
@def_html_style_value( textAlign, setTextAlign,								@"text-align" );
@def_html_style_value( textDecoration, setTextDecoration,					@"text-decoration" );
@def_html_style_value( textIndent, setTextIndent,							@"text-indent" );
@def_html_style_array( textShadow, setTextShadow,							@"text-shadow" );
@def_html_style_value( textTransform, setTextTransform,						@"text-transform" );
@def_html_style_value( textOverflow, setTextOverflow,						@"text-overflow" );
@def_html_style_value( unicodeBidi, setUnicodeBidi,							@"unicode-bidi" );
@def_html_style_value( whiteSpace, setWhiteSpace,							@"white-space" );
@def_html_style_value( wordSpacing, setWordSpacing,							@"word-spacing" );

// list

@def_html_style_value( listStyleType, setListStyleType,						@"list-style-type" );
@def_html_style_value( listStyleImage, setListStyleImage,					@"list-style-image" );
@def_html_style_value( listStylePosition, setListStylePosition,				@"list-style-position" );

// background

@def_html_style_array( background, setBackground,							@"background" );
@def_html_style_value( backgroundColor, setBackgroundColor,					@"background-color" );
@def_html_style_value( backgroundImage, setBackgroundImage,					@"background-image" );

// flex box

@def_html_style_value( flex, setFlex,										@"flex" );
@def_html_style_value( flexWrap, setFlexWrap,								@"flex-wrap" );
@def_html_style_value( flexFlow, setFlexFlow,								@"flex-flow" );
@def_html_style_value( flexDirection, setFlexDirection,						@"flex-direction" );

// font

@def_html_style_array( font, setFont,										@"font" );
@def_html_style_array( fontFamily, setFontFamily,							@"font-family" );
@def_html_style_value( fontSize, setFontSize,								@"font-size" );
@def_html_style_value( fontWeight, setFontWeight,							@"font-weight" );
@def_html_style_value( fontStyle, setFontStyle,								@"font-style" );
@def_html_style_value( fontVariant, setFontVariant,							@"font-variant" );

// border

@def_html_style_value( borderCollapse, setBorderCollapse,					@"border-collapse" );
@def_html_style_value( borderSpacing, setBorderSpacing,						@"border-spacing" );

@def_html_style_value( cellSpacing, setCellSpacing,							@"cell-spacing" );
@def_html_style_value( cellPadding, setCellPadding,							@"cell-padding" );

@def_html_style_array( border, setBorder,									@"border" );
@def_html_style_box( borderWidth, setBorderWidth,							@"border-width" );
@def_html_style_box( borderStyle, setBorderStyle,							@"border-style" );
@def_html_style_box( borderColor, setBorderColor,							@"border-color" );

@def_html_style_array( borderRadius, setBorderRadius,						@"border-radius" );
@def_html_style_array( borderTopLeftRadius, setBorderTopLeftRadius,			@"border-top-left-radius" );
@def_html_style_array( borderTopRightRadius, setBorderTopRightRadius,		@"border-top-right-radius" );
@def_html_style_array( borderBottomLeftRadius, setBorderBottomLeftRadius,	@"border-bottom-left-radius" );
@def_html_style_array( borderBottomRightRadius, setBorderBottomRightRadius,	@"border-bottom-right-radius" );

@def_html_style_array( borderTop, setBorderTop,								@"border-top" );
@def_html_style_value( borderTopColor, setBorderTopColor,					@"border-top-color" );
@def_html_style_value( borderTopStyle, setBorderTopStyle,					@"border-top-style" );
@def_html_style_value( borderTopWidth, setBorderTopWidth,					@"border-top-width" );

@def_html_style_array( borderLeft, setBorderLeft,							@"border-left" );
@def_html_style_value( borderLeftColor, setBorderLeftColor,					@"border-left-color" );
@def_html_style_value( borderLeftStyle, setBorderLeftStyle,					@"border-left-style" );
@def_html_style_value( borderLeftWidth, setBorderLeftWidth,					@"border-left-width" );

@def_html_style_array( borderRight, setBorderRight,							@"border-right" );
@def_html_style_value( borderRightColor, setBorderRightColor,				@"border-right-color" );
@def_html_style_value( borderRightStyle, setBorderRightStyle,				@"border-right-style" );
@def_html_style_value( borderRightWidth, setBorderRightWidth,				@"border-right-width" );

@def_html_style_array( borderBottom, setBorderBottom,						@"border-bottom" );
@def_html_style_value( borderBottomColor, setBorderBottomColor,				@"border-bottom-color" );
@def_html_style_value( borderBottomStyle, setBorderBottomStyle,				@"border-bottom-style" );
@def_html_style_value( borderBottomWidth, setBorderBottomWidth,				@"border-bottom-width" );

// margin

@def_html_style_box( margin, setMargin,										@"margin" );
@def_html_style_value( marginTop, setMarginTop,								@"margin-top" );
@def_html_style_value( marginLeft, setMarginLeft,							@"margin-left" );
@def_html_style_value( marginRight, setMarginRight,							@"margin-right" );
@def_html_style_value( marginBottom, setMarginBottom,						@"margin-bottom" );

// padding

@def_html_style_box( padding, setPadding,									@"padding" );
@def_html_style_value( paddingTop, setPaddingTop,							@"padding-top" );
@def_html_style_value( paddingLeft, setPaddingLeft,							@"padding-left" );
@def_html_style_value( paddingRight, setPaddingRight,						@"padding-right" );
@def_html_style_value( paddingBottom, setPaddingBottom,						@"padding-bottom" );

// inset

@def_html_style_box( inset, setInset,										@"inset" );
@def_html_style_value( insetTop, setInsetTop,								@"inset-top" );
@def_html_style_value( insetLeft, setInsetLeft,								@"inset-left" );
@def_html_style_value( insetRight, setInsetRight,							@"inset-right" );
@def_html_style_value( insetBottom, setInsetBottom,							@"inset-bottom" );

// render-model

@def_html_style_value( webkitMarginBefore, setWebkitMarginBefore,			@"-webkit-margin-before" );
@def_html_style_value( webkitMarginAfter, setWebkitMarginAfter,				@"-webkit-margin-after" );
@def_html_style_value( webkitMarginStart, setWebkitMarginStart,				@"-webkit-margin-start" );
@def_html_style_value( webkitMarginEnd, setWebkitMarginEnd,					@"-webkit-margin-end" );

@def_html_style_value( webkitPaddingBefore, setWebkitPaddingBefore,			@"-webkit-padding-before" );
@def_html_style_value( webkitPaddingAfter, setWebkitPaddingAfter,			@"-webkit-padding-after" );
@def_html_style_value( webkitPaddingStart, setWebkitPaddingStart,			@"-webkit-padding-start" );
@def_html_style_value( webkitPaddingEnd, setWebkitPaddingEnd,				@"-webkit-padding-end" );

@def_html_style_string( samuraiRenderModel, setSamuraiRenderModel,			@"-samurai-render-model" );
@def_html_style_string( samuraiRenderClass, setSamuraiRenderClass,			@"-samurai-render-class" );

#pragma makr -

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

- (id)propertyForKey:(NSString *)key
{
	return [self propertyForKey:key withClass:[SamuraiHtmlStyleObject class]];
}

- (id)propertyForKey:(NSString *)key withClass:(Class)classType
{
	ASSERT( classType );
	
	if ( nil == key )
	{
		return nil;
	}
	
	static dispatch_once_t			__once;
	static NSMutableDictionary *	__cache = nil;
	
	dispatch_once( &__once, ^{
		__cache = [[NSMutableDictionary alloc] init];
	});

	id value = [self.properties objectForKey:key];
	if ( nil == value )
	{
		return nil;
	}

	if ( [value isKindOfClass:[NSString class]] )
	{
		NSString * string = value;
		NSString * cacheKey = [NSString stringWithFormat:@"%@: %@", key, string];
		
		id result = [__cache objectForKey:cacheKey];
		if ( nil == result )
		{
			result = [classType object:string];
			if ( result )
			{
				[__cache setObject:result forKey:cacheKey];
			}
		}

		return result;
	}
	else if ( [value isKindOfClass:[SamuraiCSSValueWrapper class]] )
	{
		NSString * string = [(SamuraiCSSValueWrapper *)value rawValue];
		NSString * cacheKey = [NSString stringWithFormat:@"%@: %@", key, string];
		
		id result = [__cache objectForKey:cacheKey];
		if ( nil == result )
		{
			result = [classType object:string];
			if ( result )
			{
				[__cache setObject:result forKey:cacheKey];
			}
		}

		return result;
	}
	else if ( [value isKindOfClass:[SamuraiHtmlStyleObject class]] )
	{
		return value;
	}
	else
	{
		return [classType object:value];
	}

	return nil;
}

- (void)setProperty:(id)value forKey:(NSString *)key
{
	[self setProperty:value forKey:key withClass:[SamuraiHtmlStyleObject class]];
}

- (void)setProperty:(id)value forKey:(NSString *)key withClass:(Class)classType
{
	ASSERT( classType );
	
	if ( nil == key )
		return;

	if ( value )
	{
		id result = nil;

		if ( [value isKindOfClass:[NSString class]] )
		{
			result = [classType object:value];
		}
		else if ( [value isKindOfClass:[SamuraiCSSValueWrapper class]] )
		{
			result = [classType object:[(SamuraiCSSValueWrapper *)value rawValue]];
		}
		else if ( [value isKindOfClass:[SamuraiHtmlStyleObject class]] )
		{
			result = value;
		}
		else
		{
			result = [classType object:value];
		}
		
		if ( result )
		{
			[self.properties setObject:result forKey:key];
		}
		else
		{
			[self.properties removeObjectForKey:key];
		}
	}
	else
	{
		[self.properties removeObjectForKey:key];
	}
}

#pragma mark -

- (id)arrayForKey:(NSString *)key
{
	return [self propertyForKey:key withClass:[SamuraiHtmlArray class]];
}

- (id)boxForKey:(NSString *)key
{
	return [self propertyForKey:key withClass:[SamuraiHtmlBox class]];
}

- (id)sizeForKey:(NSString *)key
{
	return [self propertyForKey:key withClass:[SamuraiHtmlSize class]];
}

- (id)colorForKey:(NSString *)key
{
	return [self propertyForKey:key withClass:[SamuraiHtmlColor class]];
}

- (id)functionForKey:(NSString *)key
{
	return [self propertyForKey:key withClass:[SamuraiHtmlFunction class]];
}

- (id)numberForKey:(NSString *)key
{
	return [self propertyForKey:key withClass:[SamuraiHtmlNumber class]];
}

- (id)stringForKey:(NSString *)key
{
	return [self propertyForKey:key withClass:[SamuraiHtmlString class]];
}

- (id)urlForKey:(NSString *)key
{
	return [self propertyForKey:key withClass:[SamuraiHtmlUrl class]];
}

- (id)valueForKey:(NSString *)key
{
	return [self propertyForKey:key withClass:[SamuraiHtmlValue class]];
}

#pragma mark -

- (BOOL)isAutoWidth
{
	if ( self.width && [self.width isAutomatic] )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)isAutoHeight
{
	if ( self.height && [self.height isAutomatic] )
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
	SamuraiHtmlValue *	component = nil;

	SamuraiHtmlValue *	fontVariant = self.fontVariant;
	SamuraiHtmlArray *	fontFamily = self.fontFamily;
	SamuraiHtmlValue *	fontWeight = self.fontWeight;
	SamuraiHtmlValue *	fontStyle = self.fontStyle;
	SamuraiHtmlValue *	fontSize = self.fontSize;
	
	if ( self.font )
	{
	// font: [ [ <font-style> || <font-variant> || <font-weight> ]? <font-size> [ / <line-height> ]? <font-family> ] | caption | icon | menu | message-box | small-caption | status-bar | inherit
		
	// font-style (optional)
		
		component = [self.font objectAtIndex:componentIndex];
		
		if ( [component inStrings:@[@"normal", @"italic", @"oblique", @"inherit"]] )
		{
			fontStyle = fontStyle ?: component;

			componentIndex += 1;
		}

	// font-variant (optional)
		
		component = [self.font objectAtIndex:componentIndex];
		
		if ( [component inStrings:@[@"normal", @"small-caps", @"inherit"]] )
		{
			fontVariant = fontVariant ?: component;
			
			componentIndex += 1;
		}

	// font-weight (optional)
		
		component = [self.font objectAtIndex:componentIndex];
		
		if ( [component inStrings:@[@"normal", @"bold", @"bolder", @"lighter", @"inherit"]] || [component isNumber] )
		{
			fontWeight = fontWeight ?: component;

			componentIndex += 1;
		}
		
	// font-size
		
		component = [self.font objectAtIndex:componentIndex];
		
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
		
		component = [self.font objectAtIndex:componentIndex];
		
		if ( component )
		{
			fontFamily = fontFamily ?: [SamuraiHtmlArray object:component];

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
//	for ( SamuraiHtmlString * family in fontFamily.items )
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
	SamuraiHtmlStyleObject * color = self.color;
	
	if ( [color isColor] )
	{
		return ((SamuraiHtmlColor *)color).value;
	}
	
	return defaultColor;
}

- (NSTextAlignment)computeTextAlignment:(NSTextAlignment)defaultMode
{
	SamuraiHtmlStyleObject * textAlign = self.textAlign;
	
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
		else if ( [textAlign isString:@"justified"] )
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
	SamuraiHtmlStyleObject * overflow = self.textOverflow;
	SamuraiHtmlStyleObject * wordwrap = self.wordWrap;
	
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
	SamuraiHtmlStyleObject * contentMode = self.contentMode;
	
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
	SamuraiHtmlStyleObject * baseline = self.baseline;
	
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
	SamuraiHtmlValue * textDecoration = self.textDecoration;

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

- (HtmlRenderWrap)computeWrap:(HtmlRenderWrap)defaultValue
{
	SamuraiHtmlStyleObject * flexWrap = self.flexWrap;
	
	if ( flexWrap )
	{
		if ( [flexWrap isString:@"nowrap"] )
		{
			return HtmlRenderWrap_NoWrap;
		}
		else if ( [flexWrap isString:@"wrap"] )
		{
			return HtmlRenderWrap_Wrap;
		}
		else if ( [flexWrap isString:@"wrap-reverse"] )
		{
			return HtmlRenderWrap_WrapReverse;
		}
		else if ( [flexWrap isString:@"inherit"] )
		{
			return HtmlRenderWrap_Inherit;
		}
	}
	
	return defaultValue;
}

- (HtmlRenderAlign)computeAlign:(HtmlRenderAlign)defaultValue
{
	SamuraiHtmlStyleObject * align = self.align;
	SamuraiHtmlStyleObject * textAlign = self.textAlign;

	if ( align )
	{
		if ( [align isString:@"left"] )
		{
			return HtmlRenderAlign_Left;
		}
		else if ( [align isString:@"right"] )
		{
			return HtmlRenderAlign_Right;
		}
		else if ( [align isString:@"center"] )
		{
			return HtmlRenderAlign_Center;
		}
		else if ( [align isString:@"inherit"] )
		{
			return HtmlRenderAlign_Inherit;
		}
	}
	
	if ( textAlign )
	{
		if ( [textAlign isString:@"left"] )
		{
			return HtmlRenderAlign_Left;
		}
		else if ( [textAlign isString:@"right"] )
		{
			return HtmlRenderAlign_Right;
		}
		else if ( [textAlign isString:@"center"] )
		{
			return HtmlRenderAlign_Center;
		}
	}

	return defaultValue;
}

- (HtmlRenderClear)computeClear:(HtmlRenderClear)defaultValue
{
	SamuraiHtmlStyleObject * clear = self.clear;
	
	if ( clear )
	{
		if ( [clear isString:@"none"] )
		{
			return HtmlRenderClear_None;
		}
		else if ( [clear isString:@"left"] )
		{
			return HtmlRenderClear_Left;
		}
		else if ( [clear isString:@"right"] )
		{
			return HtmlRenderClear_Right;
		}
		else if ( [clear isString:@"both"] )
		{
			return HtmlRenderClear_Both;
		}
	}
	
	return defaultValue;
}

- (HtmlRenderDisplay)computeDisplay:(HtmlRenderDisplay)defaultValue
{
	SamuraiHtmlStyleObject * display = self.display;
	
	if ( display )
	{
		if ( [display isString:@"none"] )
		{
			return HtmlRenderDisplay_None;
		}
		else if ( [display isString:@"block"] )
		{
			return HtmlRenderDisplay_Block;
		}
		else if ( [display isString:@"inline"] )
		{
			return HtmlRenderDisplay_Inline;
		}
		else if ( [display isString:@"inline-block"] )
		{
			return HtmlRenderDisplay_InlineBlock;
		}
		else if ( [display isString:@"flex"] )
		{
			return HtmlRenderDisplay_Flex;
		}
		else if ( [display isString:@"inline-flex"] )
		{
			return HtmlRenderDisplay_InlineFlex;
		}
		else if ( [display isString:@"list-item"] )
		{
			return HtmlRenderDisplay_ListItem;
		}
		else if ( [display isString:@"table"] )
		{
			return HtmlRenderDisplay_Table;
		}
		else if ( [display isString:@"inline-table"] )
		{
			return HtmlRenderDisplay_InlineTable;
		}
		else if ( [display isString:@"table-row-group"] )
		{
			return HtmlRenderDisplay_TableRowGroup;
		}
		else if ( [display isString:@"table-header-group"] )
		{
			return HtmlRenderDisplay_TableHeaderGroup;
		}
		else if ( [display isString:@"table-footer-group"] )
		{
			return HtmlRenderDisplay_TableFooterGroup;
		}
		else if ( [display isString:@"table-row"] )
		{
			return HtmlRenderDisplay_TableRow;
		}
		else if ( [display isString:@"table-column-group"] )
		{
			return HtmlRenderDisplay_TableColumnGroup;
		}
		else if ( [display isString:@"table-column"] )
		{
			return HtmlRenderDisplay_TableColumn;
		}
		else if ( [display isString:@"table-cell"] )
		{
			return HtmlRenderDisplay_TableCell;
		}
		else if ( [display isString:@"table-caption"] )
		{
			return HtmlRenderDisplay_TableCaption;
		}
		else if ( [display isString:@"inherit"] )
		{
			return HtmlRenderDisplay_Inherit;
		}
	}

	return defaultValue;
}

- (HtmlRenderFloating)computeFloating:(HtmlRenderFloating)defaultValue
{
	SamuraiHtmlStyleObject * floating = self.floating;
	
	if ( floating )
	{
		if ( [floating isString:@"none"] )
		{
			return HtmlRenderFloating_None;
		}
		else if ( [floating isString:@"left"] )
		{
			return HtmlRenderFloating_Left;
		}
		else if ( [floating isString:@"right"] )
		{
			return HtmlRenderFloating_Right;
		}
		else if ( [floating isString:@"inherit"] )
		{
			return HtmlRenderFloating_Inherit;
		}
	}
	
	return defaultValue;
}

- (HtmlRenderPosition)computePosition:(HtmlRenderPosition)defaultValue
{
	SamuraiHtmlStyleObject * position = self.position;
	
	if ( position )
	{
		if ( [position isString:@"static"] )
		{
			return HtmlRenderPosition_Static;
		}
		else if ( [position isString:@"relative"] )
		{
			return HtmlRenderPosition_Relative;
		}
		else if ( [position isString:@"absolute"] )
		{
			return HtmlRenderPosition_Absolute;
		}
		else if ( [position isString:@"fixed"] )
		{
			return HtmlRenderPosition_Fixed;
		}
		else if ( [position isString:@"inherit"] )
		{
			return HtmlRenderPosition_Inherit;
		}
	}
	
	return defaultValue;
}

- (HtmlRenderDirection)computeDirection:(HtmlRenderDirection)defaultValue
{
	SamuraiHtmlStyleObject * direction = self.flexDirection;
	
	if ( direction )
	{
		if ( [direction isString:@"column"] )
		{
			return HtmlRenderDirection_Column;
		}
		else if ( [direction isString:@" column-reverse"] )
		{
			return HtmlRenderDirection_ColumnReverse;
		}
		else if ( [direction isString:@"row"] )
		{
			return HtmlRenderDirection_Row;
		}
		else if ( [direction isString:@"row-reverse"] )
		{
			return HtmlRenderDirection_RowReverse;
		}
		else if ( [direction isString:@"inherit"] )
		{
			return HtmlRenderDirection_Inherit;
		}
	}
	
	return defaultValue;
}

- (HtmlRenderVerticalAlign)computeVerticalAlign:(HtmlRenderVerticalAlign)defaultValue
{
	SamuraiHtmlStyleObject * align = self.align;
	
	if ( align )
	{
		if ( [align isString:@"baseline"] )
		{
			return HtmlRenderVerticalAlign_Baseline;
		}
		else if ( [align isString:@"sub"] )
		{
			return HtmlRenderVerticalAlign_Sub;
		}
		else if ( [align isString:@"super"] )
		{
			return HtmlRenderVerticalAlign_Super;
		}
		else if ( [align isString:@"top"] )
		{
			return HtmlRenderVerticalAlign_Top;
		}
		else if ( [align isString:@"text-top"] )
		{
			return HtmlRenderVerticalAlign_TextTop;
		}
		else if ( [align isString:@"middle"] )
		{
			return HtmlRenderVerticalAlign_Middle;
		}
		else if ( [align isString:@"bottom"] )
		{
			return HtmlRenderVerticalAlign_Bottom;
		}
		else if ( [align isString:@"text-bottom"] )
		{
			return HtmlRenderVerticalAlign_TextBottom;
		}
		else if ( [align isString:@"inherit"] )
		{
			return HtmlRenderVerticalAlign_Inherit;
		}
	}
	
	return defaultValue;
}

#pragma mark -

- (BOOL)isWidthEqualsToHeight
{
	if ( self.width )
	{
		if ( [self.width isFunction:@"equals"] )
		{
			NSString * firstParam = [[self.width params] firstObject];
			
			if ( [firstParam isEqualToString:@"height"] )
			{
				return YES;
			}
		}
	}
	
	return NO;
}

- (BOOL)isHeightEqualsToWidth
{
	if ( self.height )
	{
		if ( [self.height isFunction:@"equals"] )
		{
			NSString * firstParam = [[self.height params] firstObject];
			
			if ( [firstParam isEqualToString:@"width"] )
			{
				return YES;
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
	SamuraiHtmlStyleObject * top = self.insetTop ?: self.inset.top;
	
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
	SamuraiHtmlStyleObject * left = self.insetLeft ?: self.inset.left;
	
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
	SamuraiHtmlStyleObject * right = self.insetRight ?: self.inset.right;
	
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
	SamuraiHtmlStyleObject * bottom = self.insetBottom ?: self.inset.bottom;
	
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
	SamuraiHtmlStyleObject * top = self.paddingTop ?: (self.padding.top ?: self.webkitPaddingBefore);
	
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
	SamuraiHtmlStyleObject * left = self.paddingLeft ?: (self.padding.left ?: self.webkitPaddingStart);
	
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
	SamuraiHtmlStyleObject * right = self.paddingRight ?: (self.padding.right ?: self.webkitPaddingEnd);
	
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
	SamuraiHtmlStyleObject * bottom = self.paddingBottom ?: (self.padding.bottom ?: self.webkitPaddingAfter);
	
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
	SamuraiHtmlStyleObject * top = self.marginTop ?: (self.margin.top ?: self.webkitMarginBefore);
	
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
	SamuraiHtmlStyleObject * left = self.marginLeft ?: (self.margin.left ?: self.webkitMarginStart);
	
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
	SamuraiHtmlStyleObject * right = self.marginRight ?: (self.margin.right ?: self.webkitMarginEnd);
	
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
	SamuraiHtmlStyleObject * bottom = self.marginBottom ?: (self.margin.bottom ?: self.webkitMarginAfter);
	
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
	SamuraiHtmlStyleObject * borderColor = nil;

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
		for ( SamuraiHtmlStyleObject * item in self.borderTop.items )
		{
			if ( [item isColor] )
			{
				borderColor = borderColor ?: item;
			}
		}
	}
	
	if ( nil == borderColor )
	{
		for ( SamuraiHtmlStyleObject * item in self.border.items )
		{
			if ( [item isColor] )
			{
				borderColor = borderColor ?: item;
			}
		}
	}
	
	if ( borderColor && [borderColor isColor] )
	{
		return [borderColor colorValue];
	}
	else
	{
		return defaultColor;
	}
}

- (UIColor *)computeBorderLeftColor:(UIColor *)defaultColor
{
	SamuraiHtmlStyleObject * borderColor = nil;
	
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
		for ( SamuraiHtmlStyleObject * item in self.borderLeft.items )
		{
			if ( [item isColor] )
			{
				borderColor = borderColor ?: item;
			}
		}
	}
	
	if ( nil == borderColor )
	{
		for ( SamuraiHtmlStyleObject * item in self.border.items )
		{
			if ( [item isColor] )
			{
				borderColor = borderColor ?: item;
			}
		}
	}

	if ( borderColor && [borderColor isColor] )
	{
		return [borderColor colorValue];
	}
	else
	{
		return defaultColor;
	}
}

- (UIColor *)computeBorderRightColor:(UIColor *)defaultColor
{
	SamuraiHtmlStyleObject * borderColor = nil;
	
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
		for ( SamuraiHtmlStyleObject * item in self.borderRight.items )
		{
			if ( [item isColor] )
			{
				borderColor = borderColor ?: item;
			}
		}
	}
	
	if ( nil == borderColor )
	{
		for ( SamuraiHtmlStyleObject * item in self.border.items )
		{
			if ( [item isColor] )
			{
				borderColor = borderColor ?: item;
			}
		}
	}

	if ( borderColor && [borderColor isColor] )
	{
		return [borderColor colorValue];
	}
	else
	{
		return defaultColor;
	}
}

- (UIColor *)computeBorderBottomColor:(UIColor *)defaultColor
{
	SamuraiHtmlStyleObject * borderColor = nil;
	
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
		for ( SamuraiHtmlStyleObject * item in self.borderBottom.items )
		{
			if ( [item isColor] )
			{
				borderColor = borderColor ?: item;
			}
		}
	}
	
	if ( nil == borderColor )
	{
		for ( SamuraiHtmlStyleObject * item in self.border.items )
		{
			if ( [item isColor] )
			{
				borderColor = borderColor ?: item;
			}
		}
	}

	if ( borderColor && [borderColor isColor] )
	{
		return [borderColor colorValue];
	}
	else
	{
		return defaultColor;
	}
}

#pragma mark -

- (CGFloat)computeBorderTopSize:(CGFloat)bounds defaultSize:(CGFloat)defaultSize
{
	SamuraiHtmlStyleObject * borderSize = nil;

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
		for ( SamuraiHtmlStyleObject * item in self.borderTop.items )
		{
			if ( [item isBorderSize] )
			{
				borderSize = borderSize ?: item;
			}
		}
	}

	if ( nil == borderSize )
	{
		for ( SamuraiHtmlStyleObject * item in self.border.items )
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
	SamuraiHtmlStyleObject * borderSize = nil;
	
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
		for ( SamuraiHtmlStyleObject * item in self.borderLeft.items )
		{
			if ( [item isBorderSize] )
			{
				borderSize = borderSize ?: item;
			}
		}
	}
	
	if ( nil == borderSize )
	{
		for ( SamuraiHtmlStyleObject * item in self.border.items )
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
	SamuraiHtmlStyleObject * borderSize = nil;
	
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
		for ( SamuraiHtmlStyleObject * item in self.borderRight.items )
		{
			if ( [item isBorderSize] )
			{
				borderSize = borderSize ?: item;
			}
		}
	}
	
	if ( nil == borderSize )
	{
		for ( SamuraiHtmlStyleObject * item in self.border.items )
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
	SamuraiHtmlStyleObject * borderSize = nil;
	
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
		for ( SamuraiHtmlStyleObject * item in self.borderBottom.items )
		{
			if ( [item isBorderSize] )
			{
				borderSize = borderSize ?: item;
			}
		}
	}
	
	if ( nil == borderSize )
	{
		for ( SamuraiHtmlStyleObject * item in self.border.items )
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

- (HtmlRenderBorderStyle)computeBorderTopStyle:(HtmlRenderBorderStyle)defaultStyle
{
	SamuraiHtmlStyleObject * borderStyle = nil;
	
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
		for ( SamuraiHtmlStyleObject * item in self.borderTop.items )
		{
			if ( [item isBorderStyle] )
			{
				borderStyle = borderStyle ?: item;
			}
		}
	}

	if ( nil == borderStyle )
	{
		for ( SamuraiHtmlStyleObject * item in self.border.items )
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

- (HtmlRenderBorderStyle)computeBorderLeftStyle:(HtmlRenderBorderStyle)defaultStyle
{
	SamuraiHtmlStyleObject * borderStyle = nil;
	
	if ( nil == borderStyle )
	{
		borderStyle = self.borderLeftStyle;
	}
	
	if ( nil == borderStyle )
	{
		borderStyle = self.borderStyle.top;
	}

	if ( nil == borderStyle )
	{
		for ( SamuraiHtmlStyleObject * item in self.borderLeft.items )
		{
			if ( [item isBorderStyle] )
			{
				borderStyle = borderStyle ?: item;
			}
		}
	}
	
	if ( nil == borderStyle )
	{
		for ( SamuraiHtmlStyleObject * item in self.border.items )
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

- (HtmlRenderBorderStyle)computeBorderRightStyle:(HtmlRenderBorderStyle)defaultStyle
{
	SamuraiHtmlStyleObject * borderStyle = nil;
	
	if ( nil == borderStyle )
	{
		borderStyle = self.borderRightStyle;
	}

	if ( nil == borderStyle )
	{
		borderStyle = self.borderStyle.top;
	}

	if ( nil == borderStyle )
	{
		for ( SamuraiHtmlStyleObject * item in self.borderRight.items )
		{
			if ( [item isBorderStyle] )
			{
				borderStyle = borderStyle ?: item;
			}
		}
	}
	
	if ( nil == borderStyle )
	{
		for ( SamuraiHtmlStyleObject * item in self.border.items )
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

- (HtmlRenderBorderStyle)computeBorderBottomStyle:(HtmlRenderBorderStyle)defaultStyle
{
	SamuraiHtmlStyleObject * borderStyle = nil;
	
	if ( nil == borderStyle )
	{
		borderStyle = self.borderBottomStyle;
	}

	if ( nil == borderStyle )
	{
		borderStyle = self.borderStyle.top;
	}

	if ( nil == borderStyle )
	{
		for ( SamuraiHtmlStyleObject * item in self.borderBottom.items )
		{
			if ( [item isBorderStyle] )
			{
				borderStyle = borderStyle ?: item;
			}
		}
	}

	if ( nil == borderStyle )
	{
		for ( SamuraiHtmlStyleObject * item in self.border.items )
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
		CGFloat value = [self.borderSpacing computeValue];
		
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
		CGFloat value = [self.cellSpacing computeValue];
		
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
		CGFloat value = [self.cellPadding computeValue];
		
		return INVALID_VALUE == value ? defaultSize : value;
	}
	else
	{
		return defaultSize;
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
		CGFloat letterSpacing = [self.letterSpacing computeValue];
		
		return INVALID_VALUE == letterSpacing ? defaultSize : letterSpacing;
	}
	else
	{
		return INVALID_VALUE;
	}
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlStyle )
{
	SamuraiHtmlStyle *	_style;
}

- (void)testNumberForKey:(NSString *)key
{
	SamuraiHtmlStyleObject * value = nil;

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
	SamuraiHtmlStyleObject * value = nil;
	
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
	SamuraiHtmlStyleObject * value = nil;
	
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
	SamuraiHtmlStyleObject * value = nil;
	
// set string
	
	[_style setValue:makeUrl( [NSURL URLWithString:@"http://www.github.com"] ) forKey:key];
	
	value = [_style valueForKey:key];
	
	EXPECTED( nil != value );
	EXPECTED( [value isUrl] );
	EXPECTED( [value isUrl:@"http://www.github.com"] );

// set string

	[_style setValue:makeUrl_( "http://www.github.com" ) forKey:key];
	
	value = [_style valueForKey:key];
	
	EXPECTED( nil != value );
	EXPECTED( [value isUrl] );
	EXPECTED( [value isUrl:@"http://www.github.com"] );
}

- (void)testArrayForKey:(NSString *)key
{
	SamuraiHtmlStyleObject * value = nil;
	
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
	SamuraiHtmlBox * value = nil;

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

- (void)testSizeForKey:(NSString *)key
{
	SamuraiHtmlSize * value = nil;
	
// set size
	
	NSArray * array = @[makeFloat(1), makeString_("2")];

	[_style setValue:makeSize( array ) forKey:key];
	
	value = [_style valueForKey:key];
	
	EXPECTED( nil != value );
	EXPECTED( [value isSize] );
	EXPECTED( [value.width isNumber:1] );
	EXPECTED( [value.height isNumber:2] );
	
// set size list
	
	[_style setValue:makeSize_( 3, 4 ) forKey:key];
	
	value = [_style valueForKey:key];

	EXPECTED( nil != value );
	EXPECTED( [value isSize] );
	EXPECTED( [value.width isNumber:3] );
	EXPECTED( [value.height isNumber:4] );
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
	_style = [[SamuraiHtmlStyle alloc] init];
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
