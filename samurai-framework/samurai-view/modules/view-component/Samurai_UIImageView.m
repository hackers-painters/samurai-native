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

#import "Samurai_UIImageView.h"
#import "Samurai_App.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_Metric.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation UIImageView(Samurai)

+ (id)createInstanceWithRenderer:(SamuraiRenderObject *)renderer identifier:(NSString *)identifier
{
	UIImageView * imageView = [[self alloc] initWithFrame:CGRectZero];
	
	imageView.renderer = renderer;
	imageView.clipsToBounds = YES;
	imageView.layer.masksToBounds = YES;
	
	return imageView;
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

- (id)serialize
{
	return self.image;
}

- (void)unserialize:(id)obj
{
	if ( obj )
	{
		if ( [obj isKindOfClass:[UIImage class]] )
		{
			self.image = obj;
		}
		else if ( [obj isKindOfClass:[NSString class]] )
		{
			UIImage * image = [UIImage imageNamed:obj];
			
			if ( nil == image )
			{
				image = [[UIImage alloc] initWithContentsOfFile:obj];
			}
			
			self.image = image;
			
		}
		else
		{
			self.image = nil;
		}
	}
	else
	{
		self.image = nil;
	}
}

- (void)zerolize
{
	self.image = nil;
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

- (CGSize)computeSizeBySize:(CGSize)size
{
	if ( INVALID_VALUE == size.width && INVALID_VALUE == size.height )
	{
	//	full size
		
		if ( self.image )
		{
			CGSize result = self.image.size;
//			result.width = ceilf( result.width );
//			result.height = ceilf( result.height );
			return result;
		}
		else
		{
			return CGSizeZero;
		}
	}
	else
	{
		if ( INVALID_VALUE != size.width )
		{
		//	scale aspect fit by width
			
			if ( self.image )
			{
				CGSize result = AspectFitSizeByWidth( self.image.size, size.width );
//				result.width = ceilf( result.width );
//				result.height = ceilf( result.height );
				return result;
			}
			else
			{
				CGSize result;
				result.width = size.width;
				result.height = 0.0f;
				return result;
			}
		}
		else if ( INVALID_VALUE != size.height )
		{
		//	scale aspect fit by height
			
			if ( self.image )
			{
				CGSize result = AspectFitSizeByHeight( self.image.size, size.height );
//				result.width = ceilf( result.width );
//				result.height = ceilf( result.height );
				return result;
			}
			else
			{
				CGSize result;
				result.width = 0.0f;
				result.height = size.height;
				return result;
			}
		}
		else
		{
			return [super computeSizeBySize:size];
		}
	}
}

- (CGSize)computeSizeByWidth:(CGFloat)width
{
	if ( INVALID_VALUE == width )
	{
		if ( self.image )
		{
			CGSize result = self.image.size;
//			result.width = ceilf( result.width );
//			result.height = ceilf( result.height );
			return result;
		}
		else
		{
			return CGSizeZero;
		}
	}
	else
	{
		if ( self.image )
		{
			CGSize result = AspectFitSizeByWidth( self.image.size, width );
//			result.width = ceilf( result.width );
//			result.height = ceilf( result.height );
			return result;
		}
		else
		{
			CGSize result;
			result.width = width;
			result.height = 0.0f;
			return result;
		}
	}
}

- (CGSize)computeSizeByHeight:(CGFloat)height
{
	if ( INVALID_VALUE == height )
	{
		if ( self.image )
		{
			CGSize result = self.image.size;
//			result.width = ceilf( result.width );
//			result.height = ceilf( result.height );
			return result;
		}
		else
		{
			return CGSizeZero;
		}
	}
	else
	{
		if ( self.image )
		{
			CGSize result = AspectFitSizeByHeight( self.image.size, height );
//			result.width = ceilf( result.width );
//			result.height = ceilf( result.height );
			return result;
		}
		else
		{
			CGSize result;
			result.width = 0.0f;
			result.height = height;
			return result;
		}
	}
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, UIImageView )

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
