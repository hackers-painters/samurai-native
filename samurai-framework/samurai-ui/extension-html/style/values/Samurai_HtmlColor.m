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
			namedColors = [[NSMutableDictionary alloc] init];
			
			[namedColors setObject:[UIColor clearColor]		forKey:@"clear"];
			[namedColors setObject:[UIColor clearColor]		forKey:@"transparent"];
			[namedColors setObject:[UIColor redColor]		forKey:@"red"];
			[namedColors setObject:[UIColor blackColor]		forKey:@"black"];
			[namedColors setObject:[UIColor darkGrayColor]	forKey:@"darkgray"];
			[namedColors setObject:[UIColor lightGrayColor]	forKey:@"lightgray"];
			[namedColors setObject:[UIColor whiteColor]		forKey:@"white"];
			[namedColors setObject:[UIColor grayColor]		forKey:@"gray"];
			[namedColors setObject:HEX_RGB( 0x00a651 )		forKey:@"green"];
			[namedColors setObject:[UIColor blueColor]		forKey:@"blue"];
			[namedColors setObject:[UIColor cyanColor]		forKey:@"cyan"];
			[namedColors setObject:[UIColor yellowColor]	forKey:@"yellow"];
			[namedColors setObject:[UIColor magentaColor]	forKey:@"magenta"];
			[namedColors setObject:[UIColor orangeColor]	forKey:@"orange"];
			[namedColors setObject:[UIColor purpleColor]	forKey:@"purple"];
			[namedColors setObject:[UIColor brownColor]		forKey:@"brown"];
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
