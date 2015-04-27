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

#import "Samurai_UITextField.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation UITextField(Samurai)

+ (id)createInstanceWithRenderer:(SamuraiRenderObject *)renderer identifier:(NSString *)identifier
{
	return [super createInstanceWithRenderer:renderer identifier:identifier];
}

#pragma mark -

- (id)serialize
{
	return self.text;
}

- (void)unserialize:(id)obj
{
	self.text = [obj toString];
}

- (void)zerolize
{
	self.text = nil;
}

#pragma mark -

- (void)applyFrame:(CGRect)frame
{
	[super applyFrame:frame];
}

#pragma mark -

- (CGSize)computeSizeBySize:(CGSize)size
{
	if ( nil == self.text || 0 == self.text.length )
	{
		return CGSizeZero;
	}
	
	NSDictionary *			attribute = [NSDictionary dictionaryWithObject:self.font forKey:NSFontAttributeName];
	NSStringDrawingOptions	options = NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading;
	
	if ( INVALID_VALUE == size.width && INVALID_VALUE == size.height )
	{
		CGSize bound = CGSizeMake(HUGE_VALF, HUGE_VALF/*fmaxf(self.font.lineHeight, self.font.pointSize)*/);
		CGSize result = [self.text boundingRectWithSize:bound options:options attributes:attribute context:nil].size;
		result.width = ceilf( result.width );
		result.height = ceilf( result.height );
		return result;
	}
	else if ( INVALID_VALUE != size.width && INVALID_VALUE != size.height )
	{
		CGSize result = [self.text boundingRectWithSize:size options:options attributes:attribute context:nil].size;
		result.width = ceilf( result.width );
		result.height = ceilf( result.height );
		return result;
	}
	else
	{
		if ( INVALID_VALUE != size.width )
		{
			CGSize bound = CGSizeMake(size.width, HUGE_VALF);
			CGSize result = [self.text boundingRectWithSize:bound options:options attributes:attribute context:nil].size;
			result.width = ceilf( result.width );
			result.height = ceilf( result.height );
			return result;
		}
		else if ( INVALID_VALUE != size.height )
		{
			CGSize bound = CGSizeMake(HUGE_VALF, size.height);
			CGSize result = [self.text boundingRectWithSize:bound options:options attributes:attribute context:nil].size;
			result.width = ceilf( result.width );
			result.height = ceilf( result.height );
			return result;
		}
		else
		{
			CGSize result = [self.text boundingRectWithSize:size options:options attributes:attribute context:nil].size;
			result.width = ceilf( result.width );
			result.height = ceilf( result.height );
			return result;
		}
	}
}

- (CGSize)computeSizeByWidth:(CGFloat)width
{
	if ( INVALID_VALUE == width )
	{
		return [self computeSizeBySize:CGSizeMake( width, INVALID_VALUE )];
	}
	else
	{
		if ( nil == self.text || 0 == self.text.length )
		{
			return CGSizeMake( width, 0.0f );
		}
		
		NSDictionary *			attribute = [NSDictionary dictionaryWithObject:self.font forKey:NSFontAttributeName];
		NSStringDrawingOptions	options = NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading;
		
		CGSize result = [self.text boundingRectWithSize:CGSizeMake(width, HUGE_VALF) options:options attributes:attribute context:nil].size;
		result.width = ceilf( result.width );
		result.height = ceilf( result.height );
		return result;
	}
}

- (CGSize)computeSizeByHeight:(CGFloat)height
{
	if ( INVALID_VALUE == height )
	{
		return [self computeSizeBySize:CGSizeMake( INVALID_VALUE, height )];
	}
	else
	{
		if ( nil == self.text || 0 == self.text.length )
		{
			return CGSizeMake( 0.0f, height );
		}
		
		NSDictionary *			attribute = [NSDictionary dictionaryWithObject:self.font forKey:NSFontAttributeName];
		NSStringDrawingOptions	options = NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading;
		
		CGSize result = [self.text boundingRectWithSize:CGSizeMake(HUGE_VALF, height) options:options attributes:attribute context:nil].size;
		result.width = ceilf( result.width );
		result.height = ceilf( result.height );
		return result;
	}
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, UITextField )

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
