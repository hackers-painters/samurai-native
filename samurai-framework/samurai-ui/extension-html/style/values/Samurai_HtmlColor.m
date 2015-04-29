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
            namedColors = [NSDictionary dictionaryWithObjectsAndKeys:
                           [UIColor colorWithRed:240.0/255.0 green:248.0/255.0 blue:255.0/255.0 alpha:1], @"aliceblue",
                           [UIColor colorWithRed:250.0/255.0 green:235.0/255.0 blue:215.0/255.0 alpha:1], @"antiquewhite",
                           [UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1], @"aqua",
                           [UIColor colorWithRed:127.0/255.0 green:255.0/255.0 blue:212.0/255.0 alpha:1], @"aquamarine",
                           [UIColor colorWithRed:240.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1], @"azure",
                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:220.0/255.0 alpha:1], @"beige",
                           [UIColor colorWithRed:255.0/255.0 green:228.0/255.0 blue:196.0/255.0 alpha:1], @"bisque",
                           [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1], @"black",
                           [UIColor colorWithRed:255.0/255.0 green:235.0/255.0 blue:205.0/255.0 alpha:1], @"blanchedalmond",
                           [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:255.0/255.0 alpha:1], @"blue",
                           [UIColor colorWithRed:138.0/255.0 green:43.0/255.0 blue:226.0/255.0 alpha:1], @"blueviolet",
                           [UIColor colorWithRed:165.0/255.0 green:42.0/255.0 blue:42.0/255.0 alpha:1], @"brown",
                           [UIColor colorWithRed:222.0/255.0 green:184.0/255.0 blue:135.0/255.0 alpha:1], @"burlywood",
                           [UIColor colorWithRed:95.0/255.0 green:158.0/255.0 blue:160.0/255.0 alpha:1], @"cadetblue",
                           [UIColor colorWithRed:127.0/255.0 green:255.0/255.0 blue:0.0/255.0 alpha:1], @"chartreuse",
                           [UIColor colorWithRed:210.0/255.0 green:105.0/255.0 blue:30.0/255.0 alpha:1], @"chocolate",
                           [UIColor colorWithRed:255.0/255.0 green:127.0/255.0 blue:80.0/255.0 alpha:1], @"coral",
                           [UIColor colorWithRed:100.0/255.0 green:149.0/255.0 blue:237.0/255.0 alpha:1], @"cornflowerblue",
                           [UIColor colorWithRed:255.0/255.0 green:248.0/255.0 blue:220.0/255.0 alpha:1], @"cornsilk",
                           [UIColor colorWithRed:220.0/255.0 green:20.0/255.0 blue:60.0/255.0 alpha:1], @"crimson",
                           [UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1], @"cyan",
                           [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:139.0/255.0 alpha:1], @"darkblue",
                           [UIColor colorWithRed:0.0/255.0 green:139.0/255.0 blue:139.0/255.0 alpha:1], @"darkcyan",
                           [UIColor colorWithRed:184.0/255.0 green:134.0/255.0 blue:11.0/255.0 alpha:1], @"darkgoldenrod",
                           [UIColor colorWithRed:169.0/255.0 green:169.0/255.0 blue:169.0/255.0 alpha:1], @"darkgray",
                           [UIColor colorWithRed:0.0/255.0 green:100.0/255.0 blue:0.0/255.0 alpha:1], @"darkgreen",
                           [UIColor colorWithRed:169.0/255.0 green:169.0/255.0 blue:169.0/255.0 alpha:1], @"darkgrey",
                           [UIColor colorWithRed:189.0/255.0 green:183.0/255.0 blue:107.0/255.0 alpha:1], @"darkkhaki",
                           [UIColor colorWithRed:139.0/255.0 green:0.0/255.0 blue:139.0/255.0 alpha:1], @"darkmagenta",
                           [UIColor colorWithRed:85.0/255.0 green:107.0/255.0 blue:47.0/255.0 alpha:1], @"darkolivegreen",
                           [UIColor colorWithRed:255.0/255.0 green:140.0/255.0 blue:0.0/255.0 alpha:1], @"darkorange",
                           [UIColor colorWithRed:153.0/255.0 green:50.0/255.0 blue:204.0/255.0 alpha:1], @"darkorchid",
                           [UIColor colorWithRed:139.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1], @"darkred",
                           [UIColor colorWithRed:233.0/255.0 green:150.0/255.0 blue:122.0/255.0 alpha:1], @"darksalmon",
                           [UIColor colorWithRed:143.0/255.0 green:188.0/255.0 blue:143.0/255.0 alpha:1], @"darkseagreen",
                           [UIColor colorWithRed:72.0/255.0 green:61.0/255.0 blue:139.0/255.0 alpha:1], @"darkslateblue",
                           [UIColor colorWithRed:47.0/255.0 green:79.0/255.0 blue:79.0/255.0 alpha:1], @"darkslategray",
                           [UIColor colorWithRed:47.0/255.0 green:79.0/255.0 blue:79.0/255.0 alpha:1], @"darkslategrey",
                           [UIColor colorWithRed:0.0/255.0 green:206.0/255.0 blue:209.0/255.0 alpha:1], @"darkturquoise",
                           [UIColor colorWithRed:148.0/255.0 green:0.0/255.0 blue:211.0/255.0 alpha:1], @"darkviolet",
                           [UIColor colorWithRed:255.0/255.0 green:20.0/255.0 blue:147.0/255.0 alpha:1], @"deeppink",
                           [UIColor colorWithRed:0.0/255.0 green:191.0/255.0 blue:255.0/255.0 alpha:1], @"deepskyblue",
                           [UIColor colorWithRed:105.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:1], @"dimgray",
                           [UIColor colorWithRed:105.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:1], @"dimgrey",
                           [UIColor colorWithRed:30.0/255.0 green:144.0/255.0 blue:255.0/255.0 alpha:1], @"dodgerblue",
                           [UIColor colorWithRed:178.0/255.0 green:34.0/255.0 blue:34.0/255.0 alpha:1], @"firebrick",
                           [UIColor colorWithRed:255.0/255.0 green:250.0/255.0 blue:240.0/255.0 alpha:1], @"floralwhite",
                           [UIColor colorWithRed:34.0/255.0 green:139.0/255.0 blue:34.0/255.0 alpha:1], @"forestgreen",
                           [UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:255.0/255.0 alpha:1], @"fuchsia",
                           [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1], @"gainsboro",
                           [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:255.0/255.0 alpha:1], @"ghostwhite",
                           [UIColor colorWithRed:255.0/255.0 green:215.0/255.0 blue:0.0/255.0 alpha:1], @"gold",
                           [UIColor colorWithRed:218.0/255.0 green:165.0/255.0 blue:32.0/255.0 alpha:1], @"goldenrod",
                           [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1], @"gray",
                           [UIColor colorWithRed:0.0/255.0 green:128.0/255.0 blue:0.0/255.0 alpha:1], @"green",
                           [UIColor colorWithRed:173.0/255.0 green:255.0/255.0 blue:47.0/255.0 alpha:1], @"greenyellow",
                           [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1], @"grey",
                           [UIColor colorWithRed:240.0/255.0 green:255.0/255.0 blue:240.0/255.0 alpha:1], @"honeydew",
                           [UIColor colorWithRed:255.0/255.0 green:105.0/255.0 blue:180.0/255.0 alpha:1], @"hotpink",
                           [UIColor colorWithRed:205.0/255.0 green:92.0/255.0 blue:92.0/255.0 alpha:1], @"indianred",
                           [UIColor colorWithRed:75.0/255.0 green:0.0/255.0 blue:130.0/255.0 alpha:1], @"indigo",
                           [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:240.0/255.0 alpha:1], @"ivory",
                           [UIColor colorWithRed:240.0/255.0 green:230.0/255.0 blue:140.0/255.0 alpha:1], @"khaki",
                           [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1], @"lavender",
                           [UIColor colorWithRed:255.0/255.0 green:240.0/255.0 blue:245.0/255.0 alpha:1], @"lavenderblush",
                           [UIColor colorWithRed:124.0/255.0 green:252.0/255.0 blue:0.0/255.0 alpha:1], @"lawngreen",
                           [UIColor colorWithRed:255.0/255.0 green:250.0/255.0 blue:205.0/255.0 alpha:1], @"lemonchiffon",
                           [UIColor colorWithRed:173.0/255.0 green:216.0/255.0 blue:230.0/255.0 alpha:1], @"lightblue",
                           [UIColor colorWithRed:240.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1], @"lightcoral",
                           [UIColor colorWithRed:224.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1], @"lightcyan",
                           [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:210.0/255.0 alpha:1], @"lightgoldenrodyellow",
                           [UIColor colorWithRed:211.0/255.0 green:211.0/255.0 blue:211.0/255.0 alpha:1], @"lightgray",
                           [UIColor colorWithRed:144.0/255.0 green:238.0/255.0 blue:144.0/255.0 alpha:1], @"lightgreen",
                           [UIColor colorWithRed:211.0/255.0 green:211.0/255.0 blue:211.0/255.0 alpha:1], @"lightgrey",
                           [UIColor colorWithRed:255.0/255.0 green:182.0/255.0 blue:193.0/255.0 alpha:1], @"lightpink",
                           [UIColor colorWithRed:255.0/255.0 green:160.0/255.0 blue:122.0/255.0 alpha:1], @"lightsalmon",
                           [UIColor colorWithRed:32.0/255.0 green:178.0/255.0 blue:170.0/255.0 alpha:1], @"lightseagreen",
                           [UIColor colorWithRed:135.0/255.0 green:206.0/255.0 blue:250.0/255.0 alpha:1], @"lightskyblue",
                           [UIColor colorWithRed:119.0/255.0 green:136.0/255.0 blue:153.0/255.0 alpha:1], @"lightslategray",
                           [UIColor colorWithRed:119.0/255.0 green:136.0/255.0 blue:153.0/255.0 alpha:1], @"lightslategrey",
                           [UIColor colorWithRed:176.0/255.0 green:196.0/255.0 blue:222.0/255.0 alpha:1], @"lightsteelblue",
                           [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:224.0/255.0 alpha:1], @"lightyellow",
                           [UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:0.0/255.0 alpha:1], @"lime",
                           [UIColor colorWithRed:50.0/255.0 green:205.0/255.0 blue:50.0/255.0 alpha:1], @"limegreen",
                           [UIColor colorWithRed:250.0/255.0 green:240.0/255.0 blue:230.0/255.0 alpha:1], @"linen",
                           [UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:255.0/255.0 alpha:1], @"magenta",
                           [UIColor colorWithRed:128.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1], @"maroon",
                           [UIColor colorWithRed:102.0/255.0 green:205.0/255.0 blue:170.0/255.0 alpha:1], @"mediumaquamarine",
                           [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:205.0/255.0 alpha:1], @"mediumblue",
                           [UIColor colorWithRed:186.0/255.0 green:85.0/255.0 blue:211.0/255.0 alpha:1], @"mediumorchid",
                           [UIColor colorWithRed:147.0/255.0 green:112.0/255.0 blue:219.0/255.0 alpha:1], @"mediumpurple",
                           [UIColor colorWithRed:60.0/255.0 green:179.0/255.0 blue:113.0/255.0 alpha:1], @"mediumseagreen",
                           [UIColor colorWithRed:123.0/255.0 green:104.0/255.0 blue:238.0/255.0 alpha:1], @"mediumslateblue",
                           [UIColor colorWithRed:0.0/255.0 green:250.0/255.0 blue:154.0/255.0 alpha:1], @"mediumspringgreen",
                           [UIColor colorWithRed:72.0/255.0 green:209.0/255.0 blue:204.0/255.0 alpha:1], @"mediumturquoise",
                           [UIColor colorWithRed:199.0/255.0 green:21.0/255.0 blue:133.0/255.0 alpha:1], @"mediumvioletred",
                           [UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:112.0/255.0 alpha:1], @"midnightblue",
                           [UIColor colorWithRed:245.0/255.0 green:255.0/255.0 blue:250.0/255.0 alpha:1], @"mintcream",
                           [UIColor colorWithRed:255.0/255.0 green:228.0/255.0 blue:225.0/255.0 alpha:1], @"mistyrose",
                           [UIColor colorWithRed:255.0/255.0 green:228.0/255.0 blue:181.0/255.0 alpha:1], @"moccasin",
                           [UIColor colorWithRed:255.0/255.0 green:222.0/255.0 blue:173.0/255.0 alpha:1], @"navajowhite",
                           [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:128.0/255.0 alpha:1], @"navy",
                           [UIColor colorWithRed:253.0/255.0 green:245.0/255.0 blue:230.0/255.0 alpha:1], @"oldlace",
                           [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:0.0/255.0 alpha:1], @"olive",
                           [UIColor colorWithRed:107.0/255.0 green:142.0/255.0 blue:35.0/255.0 alpha:1], @"olivedrab",
                           [UIColor colorWithRed:255.0/255.0 green:165.0/255.0 blue:0.0/255.0 alpha:1], @"orange",
                           [UIColor colorWithRed:255.0/255.0 green:69.0/255.0 blue:0.0/255.0 alpha:1], @"orangered",
                           [UIColor colorWithRed:218.0/255.0 green:112.0/255.0 blue:214.0/255.0 alpha:1], @"orchid",
                           [UIColor colorWithRed:238.0/255.0 green:232.0/255.0 blue:170.0/255.0 alpha:1], @"palegoldenrod",
                           [UIColor colorWithRed:152.0/255.0 green:251.0/255.0 blue:152.0/255.0 alpha:1], @"palegreen",
                           [UIColor colorWithRed:175.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1], @"paleturquoise",
                           [UIColor colorWithRed:219.0/255.0 green:112.0/255.0 blue:147.0/255.0 alpha:1], @"palevioletred",
                           [UIColor colorWithRed:255.0/255.0 green:239.0/255.0 blue:213.0/255.0 alpha:1], @"papayawhip",
                           [UIColor colorWithRed:255.0/255.0 green:218.0/255.0 blue:185.0/255.0 alpha:1], @"peachpuff",
                           [UIColor colorWithRed:205.0/255.0 green:133.0/255.0 blue:63.0/255.0 alpha:1], @"peru",
                           [UIColor colorWithRed:255.0/255.0 green:192.0/255.0 blue:203.0/255.0 alpha:1], @"pink",
                           [UIColor colorWithRed:221.0/255.0 green:160.0/255.0 blue:221.0/255.0 alpha:1], @"plum",
                           [UIColor colorWithRed:176.0/255.0 green:224.0/255.0 blue:230.0/255.0 alpha:1], @"powderblue",
                           [UIColor colorWithRed:128.0/255.0 green:0.0/255.0 blue:128.0/255.0 alpha:1], @"purple",
                           [UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1], @"red",
                           [UIColor colorWithRed:188.0/255.0 green:143.0/255.0 blue:143.0/255.0 alpha:1], @"rosybrown",
                           [UIColor colorWithRed:65.0/255.0 green:105.0/255.0 blue:225.0/255.0 alpha:1], @"royalblue",
                           [UIColor colorWithRed:139.0/255.0 green:69.0/255.0 blue:19.0/255.0 alpha:1], @"saddlebrown",
                           [UIColor colorWithRed:250.0/255.0 green:128.0/255.0 blue:114.0/255.0 alpha:1], @"salmon",
                           [UIColor colorWithRed:244.0/255.0 green:164.0/255.0 blue:96.0/255.0 alpha:1], @"sandybrown",
                           [UIColor colorWithRed:46.0/255.0 green:139.0/255.0 blue:87.0/255.0 alpha:1], @"seagreen",
                           [UIColor colorWithRed:255.0/255.0 green:245.0/255.0 blue:238.0/255.0 alpha:1], @"seashell",
                           [UIColor colorWithRed:160.0/255.0 green:82.0/255.0 blue:45.0/255.0 alpha:1], @"sienna",
                           [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1], @"silver",
                           [UIColor colorWithRed:135.0/255.0 green:206.0/255.0 blue:235.0/255.0 alpha:1], @"skyblue",
                           [UIColor colorWithRed:106.0/255.0 green:90.0/255.0 blue:205.0/255.0 alpha:1], @"slateblue",
                           [UIColor colorWithRed:112.0/255.0 green:128.0/255.0 blue:144.0/255.0 alpha:1], @"slategray",
                           [UIColor colorWithRed:112.0/255.0 green:128.0/255.0 blue:144.0/255.0 alpha:1], @"slategrey",
                           [UIColor colorWithRed:255.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1], @"snow",
                           [UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:127.0/255.0 alpha:1], @"springgreen",
                           [UIColor colorWithRed:70.0/255.0 green:130.0/255.0 blue:180.0/255.0 alpha:1], @"steelblue",
                           [UIColor colorWithRed:210.0/255.0 green:180.0/255.0 blue:140.0/255.0 alpha:1], @"tan",
                           [UIColor colorWithRed:0.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1], @"teal",
                           [UIColor colorWithRed:216.0/255.0 green:191.0/255.0 blue:216.0/255.0 alpha:1], @"thistle",
                           [UIColor colorWithRed:255.0/255.0 green:99.0/255.0 blue:71.0/255.0 alpha:1], @"tomato",
                           [UIColor clearColor], @"transparent",
                           [UIColor colorWithRed:64.0/255.0 green:224.0/255.0 blue:208.0/255.0 alpha:1], @"turquoise",
                           [UIColor colorWithRed:238.0/255.0 green:130.0/255.0 blue:238.0/255.0 alpha:1], @"violet",
                           [UIColor colorWithRed:245.0/255.0 green:222.0/255.0 blue:179.0/255.0 alpha:1], @"wheat",
                           [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1], @"white",
                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1], @"whitesmoke",
                           [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:0.0/255.0 alpha:1], @"yellow",
                           [UIColor colorWithRed:154.0/255.0 green:205.0/255.0 blue:50.0/255.0 alpha:1], @"yellowgreen",
                           nil];
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

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, HtmlValueColor )

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
