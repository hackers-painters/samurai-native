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

#import "Samurai_HtmlSize.h"
#import "Samurai_HtmlNumber.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiHtmlStyleObject(Size)

- (BOOL)isSize
{
	return NO;
}

@end

#pragma mark -

@implementation SamuraiHtmlSize

@def_prop_strong( SamuraiHtmlValue *,	width );
@def_prop_strong( SamuraiHtmlValue *,	height );

+ (instancetype)object:(id)any
{
	if ( nil == any )
		return nil;
	
	if ( [any isKindOfClass:[NSString class]] )
	{
		NSString * str = any;
		
		if ( 0 == str.length )
			return nil;
	
		SamuraiHtmlSize * size = nil;

		NSArray * components = [str componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		if ( 0 != components.count )
		{
			size = [[self alloc] init];

			if ( 1 == components.count )
			{
				size.width = [SamuraiHtmlValue object:[components objectAtIndex:0]];
				size.height = size.width;
			}
			else if ( components.count >= 2 )
			{
				size.width = [SamuraiHtmlValue object:[components objectAtIndex:0]];
				size.height = [SamuraiHtmlValue object:[components objectAtIndex:1]];
			}
		}

		return size;
	}
	else if ( [any isKindOfClass:[NSValue class]] )
	{
		CGSize rawSize = [(NSValue *)any CGSizeValue];
		
		SamuraiHtmlSize * size = [[self alloc] init];

		size.width = [SamuraiHtmlNumber number:rawSize.width];
		size.height = [SamuraiHtmlNumber number:rawSize.height];
		
		return size;
	}
	else if ( [any isKindOfClass:[NSArray class]] )
	{
		NSArray * array = any;

		if ( 0 == array.count )
			return nil;
		
		SamuraiHtmlSize * size = [[self alloc] init];
		
		if ( 1 == array.count )
		{
			size.width = [SamuraiHtmlValue object:[array objectAtIndex:0]];
			size.height = size.width;
		}
		else if ( 2 == array.count )
		{
			size.width = [SamuraiHtmlValue object:[array objectAtIndex:0]];
			size.height = [SamuraiHtmlValue object:[array objectAtIndex:1]];
		}

		return size;
	}
	
	return nil; // [super object:any];
}

+ (instancetype)size:(CGSize)size
{
	return [self object:[NSValue valueWithCGSize:size]];
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
	self.width = nil;
	self.height = nil;
}

- (BOOL)isSize
{
	return YES;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlSize )

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
