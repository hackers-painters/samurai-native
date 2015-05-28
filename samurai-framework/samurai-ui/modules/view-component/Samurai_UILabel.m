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

#import "Samurai_UILabel.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_Metric.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation UILabel(Samurai)

@def_prop_dynamic( BOOL,							trimmed );
@def_prop_dynamic( BOOL,							normalized );
@def_prop_dynamic_strong( NSMutableDictionary *,	mutableAttributes, setMutableAttributes )

+ (id)createInstanceWithRenderer:(SamuraiRenderObject *)renderer identifier:(NSString *)identifier
{
	UILabel * label = [[self alloc] initWithFrame:CGRectZero];

	label.renderer = renderer;

	return label;
}

#pragma mark -

+ (BOOL)supportTapGesture
{
	return YES;
}

+ (BOOL)supportSwipeGesture
{
	return YES;
}

+ (BOOL)supportPinchGesture
{
	return YES;
}

+ (BOOL)supportPanGesture
{
	return YES;
}

#pragma mark -

- (BOOL)normalized
{
	NSNumber * normalized = [self getAssociatedObjectForKey:"normalized"];
	
	if ( normalized )
	{
		return [normalized boolValue];
	}
	
	return NO;
}

- (void)setNormalized:(BOOL)normalized
{
	[self retainAssociatedObject:@(normalized) forKey:"normalized"];
}

#pragma mark -

- (BOOL)trimmed
{
	NSNumber * trimmed = [self getAssociatedObjectForKey:"trimmed"];
	
	if ( trimmed )
	{
		return [trimmed boolValue];
	}
	
	return NO;
}

- (void)setTrimmed:(BOOL)trimmed
{
	[self retainAssociatedObject:@(trimmed) forKey:"trimmed"];
}

#pragma mark -

- (id)serialize
{
	return self.attributedText ? self.attributedText.string : self.text;
}

- (void)unserialize:(id)obj
{
	if ( obj )
	{
		NSString * content = nil;
		
		if ( [obj isKindOfClass:[NSAttributedString class]] )
		{
			content = [(NSAttributedString *)obj string];
		}
		else
		{
			content = [obj toString];
		}
		
		if ( [self trimmed] )
		{
			content = [content trim];
		}
		
		if ( [self normalized] )
		{
			content = [content normalize];
		}
		
		if ( content )
		{
			NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:content];
			[attributedString setAttributes:self.mutableAttributes range:NSMakeRange(0, [content length])];
			self.attributedText = attributedString;
		}
		else
		{
			self.attributedText = nil;
		}
	}
	else
	{
		self.attributedText = nil;
	}
}

- (void)zerolize
{
	self.attributedText = nil;
}

#pragma mark -

- (void)applyDom:(SamuraiDomNode *)dom
{
	[super applyDom:dom];
}

- (void)applyStyle:(SamuraiRenderStyle *)style
{
	[super applyStyle:style];
}

- (void)applyFrame:(CGRect)frame
{
	[super applyFrame:frame];
}

#pragma mark -

//- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
//{
//	UIEdgeInsets insets = self.renderer.padding;
//	
//	bounds.origin.x += insets.left;
//	bounds.origin.y += insets.top;
//	bounds.size.width -= insets.left;
//	bounds.size.height -= insets.top;
//	bounds.size.width -= insets.right;
//	bounds.size.height -= insets.bottom;
//
//	return bounds;
//}

#pragma mark -

- (CGSize)computeSizeBySize:(CGSize)size
{
	if ( nil == self.attributedText || 0 == self.attributedText.string.length )
	{
		return CGSizeZero;
	}

	NSDictionary *			attribute = [NSDictionary dictionaryWithObject:self.font forKey:NSFontAttributeName];
	NSStringDrawingOptions	options = NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading;

	if ( INVALID_VALUE == size.width && INVALID_VALUE == size.height )
	{
		CGSize bound = CGSizeMake(HUGE_VALF, HUGE_VALF/*fmaxf(self.font.lineHeight, self.font.pointSize)*/);
		CGSize result = [self.attributedText.string boundingRectWithSize:bound options:options attributes:attribute context:nil].size;
		result.width = ceilf( result.width );
		result.height = ceilf( result.height );
		return result;
	}
	else if ( INVALID_VALUE != size.width && INVALID_VALUE != size.height )
	{
		CGSize result = [self.attributedText.string boundingRectWithSize:size options:options attributes:attribute context:nil].size;
		result.width = ceilf( result.width );
		result.height = ceilf( result.height );
		return result;
	}
	else
	{
		if ( INVALID_VALUE != size.width )
		{
			CGSize bound = CGSizeMake(size.width, HUGE_VALF);
			CGSize result = [self.attributedText.string boundingRectWithSize:bound options:options attributes:attribute context:nil].size;
			result.width = ceilf( result.width );
			result.height = ceilf( result.height );
			return result;
		}
		else if ( INVALID_VALUE != size.height )
		{
			CGSize bound = CGSizeMake(HUGE_VALF, size.height);
			CGSize result = [self.attributedText.string boundingRectWithSize:bound options:options attributes:attribute context:nil].size;
			result.width = ceilf( result.width );
			result.height = ceilf( result.height );
			return result;
		}
		else
		{
			CGSize result = [self.attributedText.string boundingRectWithSize:size options:options attributes:attribute context:nil].size;
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
		if ( nil == self.attributedText.string || 0 == self.attributedText.string.length )
		{
			return CGSizeMake( 0.0f, 0.0f );
		}
		
		NSDictionary *			attribute = [NSDictionary dictionaryWithObject:self.font forKey:NSFontAttributeName];
		NSStringDrawingOptions	options = NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading;
		
		CGSize result = [self.attributedText.string boundingRectWithSize:CGSizeMake(width, HUGE_VALF) options:options attributes:attribute context:nil].size;
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
		if ( nil == self.attributedText.string || 0 == self.attributedText.string.length )
		{
			return CGSizeMake( 0.0f, 0.0f );
		}

		NSDictionary *			attribute = [NSDictionary dictionaryWithObject:self.font forKey:NSFontAttributeName];
		NSStringDrawingOptions	options = NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading;

		CGSize result = [self.attributedText.string boundingRectWithSize:CGSizeMake(HUGE_VALF, height) options:options attributes:attribute context:nil].size;
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

TEST_CASE( UI, UILabel )

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
