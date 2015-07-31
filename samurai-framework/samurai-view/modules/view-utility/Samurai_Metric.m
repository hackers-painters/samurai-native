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

#import "Samurai_Metric.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

CGSize AspectFitSizeByWidth( CGSize size, CGFloat width )
{
	float scale = size.width / width;
	return CGSizeMake( size.width / scale, size.height / scale );
}

CGSize AspectFitSizeByHeight( CGSize size, CGFloat height )
{
	float scale = size.height / height;
	return CGSizeMake( size.width / scale, size.height / scale );
}

CGSize AspectFillSizeByWidth( CGSize size, CGFloat width )
{
	float scale = width / size.width;
	
	size.width *= scale;
	size.height *= scale;
	size.width = size.width;
	size.height = size.height;
	
	return size;
}

CGSize AspectFillSizeByHeight( CGSize size, CGFloat height )
{
	float scale = height / size.height;
	
	size.width *= scale;
	size.height *= scale;
	size.width = size.width;
	size.height = size.height;
	
	return size;
}

CGSize AspectFitSize( CGSize size, CGSize bound )
{
	if ( size.width == 0 || size.height == 0 )
		return CGSizeZero;
	
	CGSize newSize = size;
	CGFloat newScale = 1.0f;
	
	float scaleX = bound.width / newSize.width;
	float scaleY = bound.height / newSize.height;
	
	newScale = fminf( scaleX, scaleY );
	
	newSize.width *= newScale;
	newSize.height *= newScale;
	
	newSize.width = newSize.width;
	newSize.height = newSize.height;
	
	return newSize;
}

CGRect AspectFitRect( CGRect rect, CGRect bound )
{
	CGSize newSize = AspectFitSize( rect.size, bound.size );
	newSize.width = newSize.width;
	newSize.height = newSize.height;
	
	CGRect newRect;
	newRect.origin.x = (bound.size.width - newSize.width) / 2;
	newRect.origin.y = (bound.size.height - newSize.height) / 2;
	newRect.size.width = newSize.width;
	newRect.size.height = newSize.height;
	
	return newRect;
}

CGSize AspectFillSize( CGSize size, CGSize bound )
{
	CGSize newSize = size;
	CGFloat newScale = 1.0f;
	
	float scaleX = bound.width / newSize.width;
	float scaleY = bound.height / newSize.height;
	
	newScale = fmaxf( scaleX, scaleY );
	
	newSize.width *= newScale;
	newSize.height *= newScale;
	newSize.width = newSize.width;
	newSize.height = newSize.height;
	
	return newSize;
}

CGRect AspectFillRect( CGRect rect, CGRect bound )
{
	CGSize newSize = AspectFillSize( rect.size, bound.size );
	newSize.width = newSize.width;
	newSize.height = newSize.height;
	
	CGRect newRect;
	newRect.origin.x = (bound.size.width - newSize.width) / 2;
	newRect.origin.y = (bound.size.height - newSize.height) / 2;
	newRect.size.width = newSize.width;
	newRect.size.height = newSize.height;
	
	return newRect;
}

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, Metric )

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
