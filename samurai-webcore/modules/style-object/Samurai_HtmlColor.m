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

#import "Samurai_HtmlColor.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiHtmlStyleObject(Color)

- (BOOL)isColor
{
	return NO;
}

- (UIColor *)colorValue
{
	return nil;
}

@end

#pragma mark -

@implementation SamuraiHtmlColor

@def_prop_strong( UIColor *, value );

+ (UIColor *)parseColor:(NSString *)string
{
	if ( nil == string || 0 == string.length )
		return nil;

	UIColor * result = nil;
	
	if ( [string hasPrefix:@"rgb("] && [string hasSuffix:@")"] )
	{
		string = [string substringWithRange:NSMakeRange(4, string.length - 5)];
		if ( string && string.length )
		{
			NSArray * elems = [string componentsSeparatedByString:@","];
			if ( elems && elems.count == 3 )
			{
				NSInteger r = [[elems objectAtIndex:0] integerValue];
				NSInteger g = [[elems objectAtIndex:1] integerValue];
				NSInteger b = [[elems objectAtIndex:2] integerValue];
				
				result = [UIColor colorWithRed:(r * 1.0f / 255.0f) green:(g * 1.0f / 255.0f) blue:(b * 1.0f / 255.0f) alpha:1.0f];
			}
		}
	}
	else if ( [string hasPrefix:@"rgba("] && [string hasSuffix:@")"] )
	{
		string = [string substringWithRange:NSMakeRange(5, string.length - 6)];
		if ( string && string.length )
		{
			NSArray * elems = [string componentsSeparatedByString:@","];
			if ( elems && elems.count == 4 )
			{
				NSInteger r = [[elems objectAtIndex:0] integerValue];
				NSInteger g = [[elems objectAtIndex:1] integerValue];
				NSInteger b = [[elems objectAtIndex:2] integerValue];
				float a = [[elems objectAtIndex:3] floatValue];
				
				result = [UIColor colorWithRed:(r * 1.0f / 255.0f) green:(g * 1.0f / 255.0f) blue:(b * 1.0f / 255.0f) alpha:a];
			}
		}
	}
	else if ( [string hasPrefix:@"hsl("] && [string hasSuffix:@")"] )
	{
		TODO( "hsl" );
	}
	else if ( [string hasPrefix:@"hsla("] && [string hasSuffix:@")"] )
	{
		TODO( "hsla" );
	}
	else if ( [string hasPrefix:@"#"] )
	{
		NSArray *	array = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		NSString *	color = [[array safeObjectAtIndex:0] substringFromIndex:1];
		CGFloat		alpha = [[array safeObjectAtIndex:1] floatValue] ?: 1.0f;

		if ( color.length == 3 )
		{
			result = [UIColor fromShortHexValue:strtol(color.UTF8String , nil, 16) alpha:alpha];
		}
		else if ( color.length == 6 )
		{
			result = [UIColor fromHexValue:strtol(color.UTF8String , nil, 16) alpha:alpha];
		}
	}
	else
	{
		static dispatch_once_t			once;
		static NSMutableDictionary *	namedColors = nil;
		
		dispatch_once( &once, ^
		{
			namedColors = [[NSMutableDictionary alloc] init];
			namedColors[@"aliceblue"]				= HEX_RGB( 0xF0F8FF );
			namedColors[@"antiquewhite"]			= HEX_RGB( 0xFAEBD7 );
			namedColors[@"aqua"]					= HEX_RGB( 0x00FFFF );
			namedColors[@"aquamarine"]				= HEX_RGB( 0x7FFFD4 );
			namedColors[@"azure"]					= HEX_RGB( 0xF0FFFF );
			namedColors[@"beige"]					= HEX_RGB( 0xF5F5DC );
			namedColors[@"bisque"]					= HEX_RGB( 0xFFE4C4 );
			namedColors[@"black"]					= HEX_RGB( 0x000000 );
			namedColors[@"blanchedalmond"]			= HEX_RGB( 0xFFEBCD );
			namedColors[@"blue"]					= HEX_RGB( 0x0000FF );
			namedColors[@"blueviolet"]				= HEX_RGB( 0x8A2BE2 );
			namedColors[@"brown"]					= HEX_RGB( 0xA52A2A );
			namedColors[@"burlywood"]				= HEX_RGB( 0xDEB887 );
			namedColors[@"cadetblue"]				= HEX_RGB( 0x5F9EA0 );
			namedColors[@"chartreuse"]				= HEX_RGB( 0x7FFF00 );
			namedColors[@"chocolate"]				= HEX_RGB( 0xD2691E );
			namedColors[@"coral"]					= HEX_RGB( 0xFF7F50 );
			namedColors[@"cornflowerblue"]			= HEX_RGB( 0x6495ED );
			namedColors[@"cornsilk"]				= HEX_RGB( 0xFFF8DC );
			namedColors[@"crimson"]					= HEX_RGB( 0xDC143C );
			namedColors[@"cyan"]					= HEX_RGB( 0x00FFFF );
			namedColors[@"darkblue"]				= HEX_RGB( 0x00008B );
			namedColors[@"darkcyan"]				= HEX_RGB( 0x008B8B );
			namedColors[@"darkgoldenrod"]			= HEX_RGB( 0xB8860B );
			namedColors[@"darkgray"]				= HEX_RGB( 0xA9A9A9 );
			namedColors[@"darkgreen"]				= HEX_RGB( 0x006400 );
			namedColors[@"darkkhaki"]				= HEX_RGB( 0xBDB76B );
			namedColors[@"darkmagenta"]				= HEX_RGB( 0x8B008B );
			namedColors[@"darkolivegreen"]			= HEX_RGB( 0x556B2F );
			namedColors[@"darkorange"]				= HEX_RGB( 0xFF8C00 );
			namedColors[@"darkorchid"]				= HEX_RGB( 0x9932CC );
			namedColors[@"darkred"]					= HEX_RGB( 0x8B0000 );
			namedColors[@"darksalmon"]				= HEX_RGB( 0xE9967A );
			namedColors[@"darkseagreen"]			= HEX_RGB( 0x8FBC8F );
			namedColors[@"darkslateblue"]			= HEX_RGB( 0x483D8B );
			namedColors[@"darkslategray"]			= HEX_RGB( 0x2F4F4F );
			namedColors[@"darkturquoise"]			= HEX_RGB( 0x00CED1 );
			namedColors[@"darkviolet"]				= HEX_RGB( 0x9400D3 );
			namedColors[@"deeppink"]				= HEX_RGB( 0xFF1493 );
			namedColors[@"deepskyblue"]				= HEX_RGB( 0x00BFFF );
			namedColors[@"dimgray"]					= HEX_RGB( 0x696969 );
			namedColors[@"dodgerblue"]				= HEX_RGB( 0x1E90FF );
			namedColors[@"feldspar"]				= HEX_RGB( 0xD19275 );
			namedColors[@"firebrick"]				= HEX_RGB( 0xB22222 );
			namedColors[@"floralwhite"]				= HEX_RGB( 0xFFFAF0 );
			namedColors[@"forestgreen"]				= HEX_RGB( 0x228B22 );
			namedColors[@"fuchsia"]					= HEX_RGB( 0xFF00FF );
			namedColors[@"gainsboro"]				= HEX_RGB( 0xDCDCDC );
			namedColors[@"ghostwhite"]				= HEX_RGB( 0xF8F8FF );
			namedColors[@"gold"]					= HEX_RGB( 0xFFD700 );
			namedColors[@"goldenrod"]				= HEX_RGB( 0xDAA520 );
			namedColors[@"gray"]					= HEX_RGB( 0x808080 );
			namedColors[@"green"]					= HEX_RGB( 0x008000 );
			namedColors[@"greenyellow"]				= HEX_RGB( 0xADFF2F );
			namedColors[@"honeydew"]				= HEX_RGB( 0xF0FFF0 );
			namedColors[@"hotpink"]					= HEX_RGB( 0xFF69B4 );
			namedColors[@"indianred"]				= HEX_RGB( 0xCD5C5C );
			namedColors[@"indigo"]					= HEX_RGB( 0x4B0082 );
			namedColors[@"ivory"]					= HEX_RGB( 0xFFFFF0 );
			namedColors[@"khaki"]					= HEX_RGB( 0xF0E68C );
			namedColors[@"lavender"]				= HEX_RGB( 0xE6E6FA );
			namedColors[@"lavenderblush"]			= HEX_RGB( 0xFFF0F5 );
			namedColors[@"lawngreen"]				= HEX_RGB( 0x7CFC00 );
			namedColors[@"lemonchiffon"]			= HEX_RGB( 0xFFFACD );
			namedColors[@"lightblue"]				= HEX_RGB( 0xADD8E6 );
			namedColors[@"lightcoral"]				= HEX_RGB( 0xF08080 );
			namedColors[@"lightcyan"]				= HEX_RGB( 0xE0FFFF );
			namedColors[@"lightgoldenrodyellow"]	= HEX_RGB( 0xFAFAD2 );
			namedColors[@"lightgrey"]				= HEX_RGB( 0xD3D3D3 );
			namedColors[@"lightgreen"]				= HEX_RGB( 0x90EE90 );
			namedColors[@"lightpink"]				= HEX_RGB( 0xFFB6C1 );
			namedColors[@"lightsalmon"]				= HEX_RGB( 0xFFA07A );
			namedColors[@"lightseagreen"]			= HEX_RGB( 0x20B2AA );
			namedColors[@"lightskyblue"]			= HEX_RGB( 0x87CEFA );
			namedColors[@"lightslateblue"]			= HEX_RGB( 0x8470FF );
			namedColors[@"lightslategray"]			= HEX_RGB( 0x778899 );
			namedColors[@"lightsteelblue"]			= HEX_RGB( 0xB0C4DE );
			namedColors[@"lightyellow"]				= HEX_RGB( 0xFFFFE0 );
			namedColors[@"lime"]					= HEX_RGB( 0x00FF00 );
			namedColors[@"limegreen"]				= HEX_RGB( 0x32CD32 );
			namedColors[@"linen"]					= HEX_RGB( 0xFAF0E6 );
			namedColors[@"magenta"]					= HEX_RGB( 0xFF00FF );
			namedColors[@"maroon"]					= HEX_RGB( 0x800000 );
			namedColors[@"mediumaquamarine"]		= HEX_RGB( 0x66CDAA );
			namedColors[@"mediumblue"]				= HEX_RGB( 0x0000CD );
			namedColors[@"mediumorchid"]			= HEX_RGB( 0xBA55D3 );
			namedColors[@"mediumpurple"]			= HEX_RGB( 0x9370D8 );
			namedColors[@"mediumseagreen"]			= HEX_RGB( 0x3CB371 );
			namedColors[@"mediumslateblue"]			= HEX_RGB( 0x7B68EE );
			namedColors[@"mediumspringgreen"]		= HEX_RGB( 0x00FA9A );
			namedColors[@"mediumturquoise"]			= HEX_RGB( 0x48D1CC );
			namedColors[@"mediumvioletred"]			= HEX_RGB( 0xC71585 );
			namedColors[@"midnightblue"]			= HEX_RGB( 0x191970 );
			namedColors[@"mintcream"]				= HEX_RGB( 0xF5FFFA );
			namedColors[@"mistyrose"]				= HEX_RGB( 0xFFE4E1 );
			namedColors[@"moccasin"]				= HEX_RGB( 0xFFE4B5 );
			namedColors[@"navajowhite"]				= HEX_RGB( 0xFFDEAD );
			namedColors[@"navy"]					= HEX_RGB( 0x000080 );
			namedColors[@"oldlace"]					= HEX_RGB( 0xFDF5E6 );
			namedColors[@"olive"]					= HEX_RGB( 0x808000 );
			namedColors[@"olivedrab"]				= HEX_RGB( 0x6B8E23 );
			namedColors[@"orange"]					= HEX_RGB( 0xFFA500 );
			namedColors[@"orangered"]				= HEX_RGB( 0xFF4500 );
			namedColors[@"orchid"]					= HEX_RGB( 0xDA70D6 );
			namedColors[@"palegoldenrod"]			= HEX_RGB( 0xEEE8AA );
			namedColors[@"palegreen"]				= HEX_RGB( 0x98FB98 );
			namedColors[@"paleturquoise"]			= HEX_RGB( 0xAFEEEE );
			namedColors[@"palevioletred"]			= HEX_RGB( 0xD87093 );
			namedColors[@"papayawhip"]				= HEX_RGB( 0xFFEFD5 );
			namedColors[@"peachpuff"]				= HEX_RGB( 0xFFDAB9 );
			namedColors[@"peru"]					= HEX_RGB( 0xCD853F );
			namedColors[@"pink"]					= HEX_RGB( 0xFFC0CB );
			namedColors[@"plum"]					= HEX_RGB( 0xDDA0DD );
			namedColors[@"powderblue"]				= HEX_RGB( 0xB0E0E6 );
			namedColors[@"purple"]					= HEX_RGB( 0x800080 );
			namedColors[@"red"]						= HEX_RGB( 0xFF0000 );
			namedColors[@"rosybrown"]				= HEX_RGB( 0xBC8F8F );
			namedColors[@"royalblue"]				= HEX_RGB( 0x4169E1 );
			namedColors[@"saddlebrown"]				= HEX_RGB( 0x8B4513 );
			namedColors[@"salmon"]					= HEX_RGB( 0xFA8072 );
			namedColors[@"sandybrown"]				= HEX_RGB( 0xF4A460 );
			namedColors[@"seagreen"]				= HEX_RGB( 0x2E8B57 );
			namedColors[@"seashell"]				= HEX_RGB( 0xFFF5EE );
			namedColors[@"sienna"]					= HEX_RGB( 0xA0522D );
			namedColors[@"silver"]					= HEX_RGB( 0xC0C0C0 );
			namedColors[@"skyblue"]					= HEX_RGB( 0x87CEEB );
			namedColors[@"slateblue"]				= HEX_RGB( 0x6A5ACD );
			namedColors[@"slategray"]				= HEX_RGB( 0x708090 );
			namedColors[@"snow"]					= HEX_RGB( 0xFFFAFA );
			namedColors[@"springgreen"]				= HEX_RGB( 0x00FF7F );
			namedColors[@"steelblue"]				= HEX_RGB( 0x4682B4 );
			namedColors[@"tan"]						= HEX_RGB( 0xD2B48C );
			namedColors[@"teal"]					= HEX_RGB( 0x008080 );
			namedColors[@"thistle"]					= HEX_RGB( 0xD8BFD8 );
			namedColors[@"tomato"]					= HEX_RGB( 0xFF6347 );
			namedColors[@"turquoise"]				= HEX_RGB( 0x40E0D0 );
			namedColors[@"violet"]					= HEX_RGB( 0xEE82EE );
			namedColors[@"violetred"]				= HEX_RGB( 0xD02090 );
			namedColors[@"wheat"]					= HEX_RGB( 0xF5DEB3 );
			namedColors[@"white"]					= HEX_RGB( 0xFFFFFF );
			namedColors[@"whitesmoke"]				= HEX_RGB( 0xF5F5F5 );
			namedColors[@"yellow"]					= HEX_RGB( 0xFFFF00 );
			namedColors[@"yellowgreen"]				= HEX_RGB( 0x9ACD32 );
			namedColors[@"transparent"]				= [UIColor clearColor];
		});

		result = [namedColors objectForKey:[string lowercaseString]];
	}
	
	return result;
}

+ (instancetype)object:(id)any
{
	if ( [any isKindOfClass:[NSString class]] )
	{
		NSString * str = any;
		
		if ( str.length < 3 )
			return nil;

		UIColor * color = [self parseColor:str];
		if ( nil == color )
			return nil;
		
		SamuraiHtmlColor * value = [[self alloc] init];
		value.value = color;
		return value;
	}
	else if ( [any isKindOfClass:[UIColor class]] )
	{
		SamuraiHtmlColor * value = [[self alloc] init];
		value.value = any;
		return value;
	}

	return nil; // [super object:any];
}

+ (instancetype)color:(UIColor *)color
{
	return [self object:color];
}

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
	self.value = nil;
}

- (NSString *)description
{
	return [self.value description];
}

- (BOOL)isColor
{
	return YES;
}

- (UIColor *)colorValue
{
	return self.value;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlValueColor )

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
