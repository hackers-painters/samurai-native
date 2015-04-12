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
#import "Samurai_CssStyleSheet.h"

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

@implementation SamuraiHtmlRenderStyle

@def_html_value( top,						@"top" );
@def_html_value( left,						@"left");
@def_html_value( right,						@"right");
@def_html_value( bottom,					@"bottom" );

@def_html_value( width,						@"width" );
@def_html_value( minWidth,					@"min-width" );
@def_html_value( maxWidth,					@"max-width" );

@def_html_value( height,					@"height" );
@def_html_value( minHeight,					@"min-height" );
@def_html_value( maxHeight,					@"max-height" );

@def_html_value( position,					@"position" );
@def_html_value( floating,					@"float" );

@def_html_value( display,					@"display" );
@def_html_value( overflow,					@"overflow" );
@def_html_value( visibility,				@"visibility" );

@def_html_array( boxShadow,					@"box-shadow" );

@def_html_value( baseline,					@"baseline" );
@def_html_value( wordWrap,					@"word-wrap" );
@def_html_value( contentMode,				@"content-mode" );

@def_html_value( color,						@"color" );
@def_html_value( direction,					@"direction" );
@def_html_value( letterSpacing,				@"letter-spacing" );
@def_html_value( lineHeight,				@"line-height" );
@def_html_value( textAlign,					@"text-align" );
@def_html_value( textDecoration,			@"text-decoration" );
@def_html_value( textIndent,				@"text-indent" );
@def_html_array( textShadow,				@"text-shadow" );
@def_html_value( textTransform,				@"text-transform" );
@def_html_value( textOverflow,				@"text-overflow" );
@def_html_value( unicodeBidi,				@"unicode-bidi" );
@def_html_value( whiteSpace,				@"white-space" );
@def_html_value( wordSpacing,				@"word-spacing" );

// background

@def_html_array( background,				@"background" );
@def_html_value( backgroundColor,			@"background-color" );
@def_html_value( backgroundImage,			@"background-image" );

// flex box

@def_html_value( flexWrap,					@"flex-wrap" );
@def_html_value( flexFlow,					@"flex-flow" );
@def_html_value( flexDirection,				@"flex-direction" );

// font

@def_html_array( font,						@"font" );
@def_html_array( fontFamily,				@"font-family" );
@def_html_value( fontSize,					@"font-size" );
@def_html_value( fontWeight,				@"font-weight" );
@def_html_value( fontStyle,					@"font-style" );
@def_html_value( fontVariant,				@"font-variant" );

// border

@def_html_array( border,					@"border" );
@def_html_value( borderWidth,				@"border-width" );
@def_html_value( borderStyle,				@"border-style" );
@def_html_value( borderColor,				@"border-color" );

@def_html_value( borderRadius,				@"border-radius" );
@def_html_value( borderTopLeftRadius,		@"border-top-left-radius" );
@def_html_value( borderTopRightRadius,		@"border-top-right-radius" );
@def_html_value( borderBottomLeftRadius,	@"border-bottom-left-radius" );
@def_html_value( borderBottomRightRadius,	@"border-bottom-right-radius" );

@def_html_value( borderTop,					@"border-top" );
@def_html_value( borderTopColor,			@"border-top-color" );
@def_html_value( borderTopStyle,			@"border-top-style" );
@def_html_value( borderTopWidth,			@"border-top-width" );

@def_html_value( borderLeft,				@"border-left" );
@def_html_value( borderLeftColor,			@"border-left-color" );
@def_html_value( borderLeftStyle,			@"border-left-style" );
@def_html_value( borderLeftWidth,			@"border-left-width" );

@def_html_value( borderRight,				@"border-right" );
@def_html_value( borderRightColor,			@"border-right-color" );
@def_html_value( borderRightStyle,			@"border-right-style" );
@def_html_value( borderRightWidth,			@"border-right-width" );

@def_html_value( borderBottom,				@"border-bottom" );
@def_html_value( borderBottomColor,			@"border-bottom-color" );
@def_html_value( borderBottomStyle,			@"border-bottom-style" );
@def_html_value( borderBottomWidth,			@"border-bottom-width" );

// margin

@def_html_box( margin,						@"margin" );
@def_html_value( marginTop,					@"margin-top" );
@def_html_value( marginLeft,				@"margin-left" );
@def_html_value( marginRight,				@"margin-right" );
@def_html_value( marginBottom,				@"margin-bottom" );

// padding

@def_html_box( padding,						@"padding" );
@def_html_value( paddingTop,				@"padding-top" );
@def_html_value( paddingLeft,				@"padding-left" );
@def_html_value( paddingRight,				@"padding-right" );
@def_html_value( paddingBottom,				@"padding-bottom" );

// inset

@def_html_box( inset,						@"inset" );
@def_html_value( insetTop,					@"inset-top" );
@def_html_value( insetLeft,					@"inset-left" );
@def_html_value( insetRight,                @"inset-right" );
@def_html_value( insetBottom,				@"inset-bottom" );

// render-model

@def_html_value( samuraiRenderModel,        @"-samurai-render-model" );
@def_html_value( samuraiRenderClass,        @"-samurai-render-class" );

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

- (id)objectWithClass:(Class)classType forKey:(NSString *)key;
{
	static dispatch_once_t			once;
	static NSMutableDictionary *	cache = nil;
	
	dispatch_once( &once, ^{
		cache = [[NSMutableDictionary alloc] init];
	});
	
	id value = [self.properties objectForKey:key];
	if ( nil == value )
		return nil;
	
	NSString * cacheKey = [NSString stringWithFormat:@"%@: %@", key, value];
	
	id object = [cache objectForKey:cacheKey];
	if ( nil == object )
	{
        if ( [value isKindOfClass:[NSString class]] )
        {
            object = [classType object:value];
        }
        else if ( [value isKindOfClass:[SamuraiCssValueWrapper class]] )
        {
            object = [classType object:((SamuraiCssValueWrapper *)value).rawValue];
        }

		if ( object )
		{
			[cache setObject:object forKey:cacheKey];
		}
	}

	return object;
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
	SamuraiHtmlObject * color = self.color;
	
	if ( [color isColor] )
	{
		return ((SamuraiHtmlColor *)color).value;
	}
	
	return defaultColor;
}

- (NSTextAlignment)computeTextAlignment:(NSTextAlignment)defaultMode
{
	SamuraiHtmlObject * textAlign = self.textAlign;
	
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
	SamuraiHtmlObject * overflow = self.textOverflow;
	SamuraiHtmlObject * wordwrap = self.wordWrap;
	
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
	SamuraiHtmlObject * contentMode = self.contentMode;
	
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
	SamuraiHtmlObject * baseline = self.baseline;
	
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
	SamuraiHtmlObject * flexWrap = self.flexWrap;
	
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
	SamuraiHtmlObject * display = self.display;
	
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
	SamuraiHtmlObject * floating = self.floating;
	
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
	SamuraiHtmlObject * position = self.position;
	
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
	SamuraiHtmlObject * direction = self.flexDirection;
	
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

TEST_CASE( UI, HtmlRenderStyle )
{
}
TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "_pragma_pop.h"
