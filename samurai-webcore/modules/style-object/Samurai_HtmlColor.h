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

#import "Samurai_HtmlValue.h"

#pragma mark -

#undef	makeColor
#define makeColor( c )			[SamuraiHtmlColor object:c]

#undef	makeColor_
#define makeColor_( c )			[SamuraiHtmlColor object:@(c)]

#undef	makeHex_
#define makeHex_( c )			[SamuraiHtmlColor color:HEX_RGB(c)]

#undef	makeHexA_
#define makeHexA_( c, a )		[SamuraiHtmlColor color:HEX_RGBA(c, a)]

#undef	makeHexShort_
#define makeHexShort_( c )		[SamuraiHtmlColor color:SHORT_RGB(c)]

#undef	makeRGB_
#define makeRGB_( r, g, b )		[SamuraiHtmlColor color:RGB(r,g,b)]

#undef	makeRGBA_
#define makeRGBA_( r, g, b, a )	[SamuraiHtmlColor color:RGBA(r,g,b,a)]

#pragma mark -

@interface SamuraiHtmlStyleObject(Color)

- (BOOL)isColor;

- (UIColor *)colorValue;

@end

#pragma mark -

@interface SamuraiHtmlColor : SamuraiHtmlValue

@prop_strong( UIColor *, value );

+ (UIColor *)parseColor:(NSString *)string;

+ (instancetype)color:(UIColor *)color;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
