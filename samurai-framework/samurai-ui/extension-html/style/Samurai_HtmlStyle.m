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

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

#undef	HTML_DEFAULT_FONT_SIZE
#define HTML_DEFAULT_FONT_SIZE		(12.0f)

#undef	HTML_DEFAULT_FONT_WEIGHT
#define HTML_DEFAULT_FONT_WEIGHT	(200)

#pragma mark -

@implementation SamuraiHtmlStyle

@def_html_value( top, setTop,											@"top" );
@def_html_value( left, setLeft,											@"left");
@def_html_value( right, setRight,										@"right");
@def_html_value( bottom, setBottom,										@"bottom" );

@def_html_value( width, setWidth,										@"width" );
@def_html_value( minWidth, setMinWidth,									@"min-width" );
@def_html_value( maxWidth, setMaxWidth,									@"max-width" );

@def_html_value( height, setHeight,										@"height" );
@def_html_value( minHeight, setMinHeight,								@"min-height" );
@def_html_value( maxHeight, setMaxHeight,								@"max-height" );

@def_html_value( position, setPosition,									@"position" );
@def_html_value( floating, setFloating,									@"float" );

@def_html_value( display, setDisplay,									@"display" );
@def_html_value( overflow, setOverflow,									@"overflow" );
@def_html_value( visibility, setVisibility,								@"visibility" );
@def_html_value( opacity, setOpacity,									@"opacity" );

@def_html_array( boxShadow, setBoxShadow,								@"box-shadow" );

@def_html_value( baseline, setBaseline,									@"baseline" );
@def_html_value( wordWrap, setWordWrap,									@"word-wrap" );
@def_html_value( contentMode, setContentMode,							@"content-mode" );

@def_html_value( color, setColor,										@"color" );
@def_html_value( direction, setDirection,								@"direction" );
@def_html_value( letterSpacing, setLetterSpacing,						@"letter-spacing" );
@def_html_value( lineHeight, setLineHeight,								@"line-height" );
@def_html_value( textAlign, setTextAlign,								@"text-align" );
@def_html_value( textDecoration, setTextDecoration,						@"text-decoration" );
@def_html_value( textIndent, setTextIndent,								@"text-indent" );
@def_html_array( textShadow, setTextShadow,								@"text-shadow" );
@def_html_value( textTransform, setTextTransform,						@"text-transform" );
@def_html_value( textOverflow, setTextOverflow,							@"text-overflow" );
@def_html_value( unicodeBidi, setUnicodeBidi,							@"unicode-bidi" );
@def_html_value( whiteSpace, setWhiteSpace,								@"white-space" );
@def_html_value( wordSpacing, setWordSpacing,							@"word-spacing" );

// background

@def_html_array( background, setBackground,								@"background" );
@def_html_value( backgroundColor, setBackgroundColor,					@"background-color" );
@def_html_value( backgroundImage, setBackgroundImage,					@"background-image" );

// flex box

@def_html_value( flex, setFlex,											@"flex" );
@def_html_value( flexWrap, setFlexWrap,									@"flex-wrap" );
@def_html_value( flexFlow, setFlexFlow,									@"flex-flow" );
@def_html_value( flexDirection, setFlexDirection,						@"flex-direction" );

// font

@def_html_array( font, setFont,											@"font" );
@def_html_array( fontFamily, setFontFamily,								@"font-family" );
@def_html_value( fontSize, setFontSize,									@"font-size" );
@def_html_value( fontWeight, setFontWeight,								@"font-weight" );
@def_html_value( fontStyle, setFontStyle,								@"font-style" );
@def_html_value( fontVariant, setFontVariant,							@"font-variant" );

// border

@def_html_array( border, setBorder,										@"border" );
@def_html_value( borderWidth, setBorderWidth,							@"border-width" );
@def_html_value( borderStyle, setBorderStyle,							@"border-style" );
@def_html_value( borderColor, setBorderColor,							@"border-color" );

@def_html_value( borderRadius, setBorderRadius,							@"border-radius" );
@def_html_value( borderTopLeftRadius, setBorderTopLeftRadius,			@"border-top-left-radius" );
@def_html_value( borderTopRightRadius, setBorderTopRightRadius,			@"border-top-right-radius" );
@def_html_value( borderBottomLeftRadius, setBorderBottomLeftRadius,		@"border-bottom-left-radius" );
@def_html_value( borderBottomRightRadius, setBorderBottomRightRadius,	@"border-bottom-right-radius" );

@def_html_value( borderTop, setBorderTop,								@"border-top" );
@def_html_value( borderTopColor, setBorderTopColor,						@"border-top-color" );
@def_html_value( borderTopStyle, setBorderTopStyle,						@"border-top-style" );
@def_html_value( borderTopWidth, setBorderTopWidth,						@"border-top-width" );

@def_html_value( borderLeft, setBorderLeft,								@"border-left" );
@def_html_value( borderLeftColor, setBorderLeftColor,					@"border-left-color" );
@def_html_value( borderLeftStyle, setBorderLeftStyle,					@"border-left-style" );
@def_html_value( borderLeftWidth, setBorderLeftWidth,					@"border-left-width" );

@def_html_value( borderRight, setBorderRight,							@"border-right" );
@def_html_value( borderRightColor, setBorderRightColor,					@"border-right-color" );
@def_html_value( borderRightStyle, setBorderRightStyle,					@"border-right-style" );
@def_html_value( borderRightWidth, setBorderRightWidth,					@"border-right-width" );

@def_html_value( borderBottom, setBorderBottom,							@"border-bottom" );
@def_html_value( borderBottomColor, setBorderBottomColor,				@"border-bottom-color" );
@def_html_value( borderBottomStyle, setBorderBottomStyle,				@"border-bottom-style" );
@def_html_value( borderBottomWidth, setBorderBottomWidth,				@"border-bottom-width" );

// margin

@def_html_box( margin, setMargin,										@"margin" );
@def_html_value( marginTop, setMarginTop,								@"margin-top" );
@def_html_value( marginLeft, setMarginLeft,								@"margin-left" );
@def_html_value( marginRight, setMarginRight,							@"margin-right" );
@def_html_value( marginBottom, setMarginBottom,							@"margin-bottom" );

// padding

@def_html_box( padding, setPadding,										@"padding" );
@def_html_value( paddingTop, setPaddingTop,								@"padding-top" );
@def_html_value( paddingLeft, setPaddingLeft,							@"padding-left" );
@def_html_value( paddingRight, setPaddingRight,							@"padding-right" );
@def_html_value( paddingBottom, setPaddingBottom,						@"padding-bottom" );

// inset

@def_html_box( inset, setInset,											@"inset" );
@def_html_value( insetTop, setInsetTop,									@"inset-top" );
@def_html_value( insetLeft, setInsetLeft,								@"inset-left" );
@def_html_value( insetRight, setInsetRight,								@"inset-right" );
@def_html_value( insetBottom, setInsetBottom,							@"inset-bottom" );

// render-model

@def_html_string( renderModel, setRenderModel,							@"-samurai-render-model" );
@def_html_string( renderClass, setRenderClass,							@"-samurai-render-class" );

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
			
			TODO( "font-variant" );	// optional
			
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
			if ( [component inStrings:@[@"xx-small", @"x-small", @"small", @"medium", @"large", @"x-large", @"xx-large", @"larger", @"smaller", @"inherit"]] )
			{
				fontSize = fontSize ?: component;
				
				componentIndex += 1;
			}
			else if ( [component inStrings:@[@"larger", @"smaller", @"inherit"]] )
			{
				fontSize = fontSize ?: component;

				componentIndex += 1;
			}
			else if ( [component isNumber] )
			{
				fontSize = fontSize ?: component;
				
				componentIndex += 1;
			}
//			else if ( [component isFunction] )
//			{
//				TODO( "" );
//			}
			else
			{
				ERROR( @"unknown font-size unit" );
			}

			TODO( "line-height" );	// optional
		}

	// font-family
		
		component = [self.font objectAtIndex:componentIndex];
		
		if ( component )
		{
			fontFamily = fontFamily ?: [SamuraiHtmlArray object:component];

			componentIndex += 1;
		}
	}

	CGFloat fontHeight = HTML_DEFAULT_FONT_SIZE;

	if ( fontSize )
	{
		if ( [fontSize isNumber] )
		{
			fontHeight = [fontSize computeValue:HTML_DEFAULT_FONT_SIZE];
		}
		else if ( [fontSize isString] )
		{
			if ( [fontSize isString:@"xx-small"] )
			{
				fontHeight = HTML_DEFAULT_FONT_SIZE * 0.4f;
			}
			else if ( [fontSize isString:@"x-small"] )
			{
				fontHeight = HTML_DEFAULT_FONT_SIZE * 0.6f;
			}
			else if ( [fontSize isString:@"small"] )
			{
				fontHeight = HTML_DEFAULT_FONT_SIZE * 0.8f;
			}
			else if ( [fontSize isString:@"medium"] )
			{
				fontHeight = HTML_DEFAULT_FONT_SIZE * 1.0f;
			}
			else if ( [fontSize isString:@"large"] )
			{
				fontHeight = HTML_DEFAULT_FONT_SIZE * 1.2f;
			}
			else if ( [fontSize isString:@"x-large"] )
			{
				fontHeight = HTML_DEFAULT_FONT_SIZE * 1.4f;
			}
			else if ( [fontSize isString:@"xx-large"] )
			{
				fontHeight = HTML_DEFAULT_FONT_SIZE * 1.6f;
			}
//			else if ( [fontSize isString:@"larger"] )
//			{
//				TODO( "" )
//			}
//			else if ( [fontSize isString:@"smaller"] )
//			{
//				TODO( "" )
//			}
//			else
//			{
//				TODO( "" )
//			}
		}
//		else if ( [fontSize isFunction] )
//		{
//			TODO( "" )
//		}
		else
		{
			ERROR( @"unknown font-size unit" );
		}
	}

// custom font
	
	for ( SamuraiHtmlString * family in fontFamily.items )
	{
		if ( [family isString] )
		{
			NSArray * names = [UIFont fontNamesForFamilyName:family.value];

			for ( NSString * name in names )
			{
				result = [UIFont fontWithName:name size:fontHeight];

				if ( result )
					break;
			}
		}

		if ( result )
			break;
	}
	
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
				CGFloat value = [fontWeight computeValue:HTML_DEFAULT_FONT_WEIGHT];
				
				if ( value >= 600 )
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

#pragma mark -

- (RenderWrap)computeWrap:(RenderWrap)defaultValue
{
	SamuraiHtmlStyleObject * flexWrap = self.flexWrap;
	
	if ( flexWrap )
	{
		if ( [flexWrap isString:@"nowrap"] )
		{
			return RenderWrap_NoWrap;
		}
		else if ( [flexWrap isString:@"wrap"] )
		{
			return RenderWrap_Wrap;
		}
		else if ( [flexWrap isString:@"wrap-reverse"] )
		{
			return RenderWrap_WrapReverse;
		}
		else if ( [flexWrap isString:@"inherit"] )
		{
			return RenderWrap_Inherit;
		}
	}
	
	return defaultValue;
}

- (RenderDisplay)computeDisplay:(RenderDisplay)defaultValue
{
	SamuraiHtmlStyleObject * display = self.display;
	
	if ( display )
	{
		if ( [display isString:@"none"] )
		{
			return RenderDisplay_None;
		}
		else if ( [display isString:@"block"] )
		{
			return RenderDisplay_Block;
		}
		else if ( [display isString:@"inline"] )
		{
			return RenderDisplay_Inline;
		}
		else if ( [display isString:@"inline-block"] )
		{
			return RenderDisplay_InlineBlock;
		}
		else if ( [display isString:@"flex"] )
		{
			return RenderDisplay_Flex;
		}
		else if ( [display isString:@"inline-flex"] )
		{
			return RenderDisplay_InlineFlex;
		}
		else if ( [display isString:@"inherit"] )
		{
			return RenderDisplay_Inherit;
		}
	}
	
	return defaultValue;
}

- (RenderFloating)computeFloating:(RenderFloating)defaultValue
{
	SamuraiHtmlStyleObject * floating = self.floating;
	
	if ( floating )
	{
		if ( [floating isString:@"none"] )
		{
			return RenderFloating_None;
		}
		else if ( [floating isString:@"left"] )
		{
			return RenderFloating_Left;
		}
		else if ( [floating isString:@"right"] )
		{
			return RenderFloating_Right;
		}
		else if ( [floating isString:@"inherit"] )
		{
			return RenderFloating_Inherit;
		}
	}
	
	return defaultValue;
}

- (RenderPosition)computePosition:(RenderPosition)defaultValue
{
	SamuraiHtmlStyleObject * position = self.position;
	
	if ( position )
	{
		if ( [position isString:@"static"] )
		{
			return RenderPosition_Static;
		}
		else if ( [position isString:@"relative"] )
		{
			return RenderPosition_Relative;
		}
		else if ( [position isString:@"absolute"] )
		{
			return RenderPosition_Absolute;
		}
		else if ( [position isString:@"fixed"] )
		{
			return RenderPosition_Fixed;
		}
		else if ( [position isString:@"inherit"] )
		{
			return RenderPosition_Inherit;
		}
	}
	
	return defaultValue;
}

- (RenderDirection)computeDirection:(RenderDirection)defaultValue
{
	SamuraiHtmlStyleObject * direction = self.flexDirection;
	
	if ( direction )
	{
		if ( [direction isString:@"column"] )
		{
			return RenderDirection_Column;
		}
		else if ( [direction isString:@" column-reverse"] )
		{
			return RenderDirection_ColumnReverse;
		}
		else if ( [direction isString:@"row"] )
		{
			return RenderDirection_Row;
		}
		else if ( [direction isString:@"row-reverse"] )
		{
			return RenderDirection_RowReverse;
		}
		else if ( [direction isString:@"inherit"] )
		{
			return RenderDirection_Inherit;
		}
	}
	
	return defaultValue;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, HtmlStyle )
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
