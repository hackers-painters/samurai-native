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

#import "Samurai_HtmlBox.h"
#import "Samurai_HtmlNumber.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiHtmlStyleObject(Box)

- (BOOL)isBox
{
	return NO;
}

@end

#pragma mark -

@implementation SamuraiHtmlBox

@def_prop_strong( SamuraiHtmlValue *,	top );
@def_prop_strong( SamuraiHtmlValue *,	right );
@def_prop_strong( SamuraiHtmlValue *,	bottom );
@def_prop_strong( SamuraiHtmlValue *,	left );

+ (instancetype)object:(id)any
{
	if ( nil == any )
		return nil;

	if ( [any isKindOfClass:[NSString class]] )
	{
		NSString * str = any;
		
		if ( 0 == str.length )
			return nil;

		SamuraiHtmlBox * box = nil;

		NSArray * components = [str componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		if ( 0 != components.count )
		{
			box = [[self alloc] init];

			if ( 1 == [components count] )
			{
				box.top = [SamuraiHtmlValue object:[components objectAtIndex:0]];
				box.right = box.top;
				box.bottom = box.top;
				box.left = box.top;
			}
			else if ( 2 == components.count )
			{
				box.top = [SamuraiHtmlValue object:[components objectAtIndex:0]];
				box.bottom = box.top;
				box.right = [SamuraiHtmlValue object:[components objectAtIndex:1]];
				box.left = box.right;
			}
			else if ( 3 == components.count )
			{
				box.top = [SamuraiHtmlValue object:[components objectAtIndex:0]];
				box.right = [SamuraiHtmlValue object:[components objectAtIndex:1]];
				box.left = box.right;
				box.bottom = [SamuraiHtmlValue object:[components objectAtIndex:2]];
			}
			else if ( components.count >= 4 )
			{
				box.top = [SamuraiHtmlValue object:[components objectAtIndex:0]];
				box.right = [SamuraiHtmlValue object:[components objectAtIndex:1]];
				box.bottom = [SamuraiHtmlValue object:[components objectAtIndex:2]];
				box.left = [SamuraiHtmlValue object:[components objectAtIndex:3]];
			}
		}

		return box;
	}
	else if ( [any isKindOfClass:[NSValue class]] )
	{
		UIEdgeInsets rawInsets = [(NSValue *)any UIEdgeInsetsValue];
	
		SamuraiHtmlBox * box = [[self alloc] init];
		
		box.top = [SamuraiHtmlNumber number:rawInsets.top];
		box.right = [SamuraiHtmlNumber number:rawInsets.right];
		box.bottom = [SamuraiHtmlNumber number:rawInsets.bottom];
		box.left = [SamuraiHtmlNumber number:rawInsets.left];
		
		return box;
	}
	else if ( [any isKindOfClass:[NSArray class]] )
	{
		NSArray * array = any;
		
		if ( 0 == array.count )
			return nil;
		
		SamuraiHtmlBox * box = [[self alloc] init];
		
		if ( 1 == array.count )
		{
			box.top = [SamuraiHtmlValue object:[array objectAtIndex:0]];
			box.right = box.top;
			box.bottom = box.top;
			box.left = box.top;
		}
		else if ( 2 == array.count )
		{
			box.top = [SamuraiHtmlValue object:[array objectAtIndex:0]];
			box.bottom = box.top;
			box.right = [SamuraiHtmlValue object:[array objectAtIndex:1]];
			box.left = box.right;
		}
		else if ( 3 == array.count )
		{
			box.top = [SamuraiHtmlValue object:[array objectAtIndex:0]];
			box.right = [SamuraiHtmlValue object:[array objectAtIndex:1]];
			box.left = box.right;
			box.bottom = [SamuraiHtmlValue object:[array objectAtIndex:2]];
		}
		else if ( array.count >= 4 )
		{
			box.top = [SamuraiHtmlValue object:[array objectAtIndex:0]];
			box.right = [SamuraiHtmlValue object:[array objectAtIndex:1]];
			box.bottom = [SamuraiHtmlValue object:[array objectAtIndex:2]];
			box.left = [SamuraiHtmlValue object:[array objectAtIndex:3]];
		}
		
		return box;
	}

	return nil; // [super object:any];
}

+ (instancetype)box:(UIEdgeInsets)box
{
	return [self object:[NSValue valueWithUIEdgeInsets:box]];
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
	self.top = nil;
	self.right = nil;
	self.bottom = nil;
	self.left = nil;
}

- (BOOL)isBox
{
	return YES;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlBox )

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
