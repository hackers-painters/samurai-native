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

#import "Samurai_HtmlLayoutText.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_HtmlRenderObject.h"
#import "Samurai_HtmlRenderStyle.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiHtmlLayoutText

- (void)layout
{
	DEBUG_RENDERER_LAYOUT( self.source );

	CGSize textBounds = self.computedSize;

	if ( INVALID_VALUE == textBounds.width )
	{
		textBounds.width = self.bounds.width;
	}
	
	if ( INVALID_VALUE == textBounds.width )
		return;

	CGSize contentSize = CGSizeZero;

	if ( INVALID_VALUE == textBounds.width && INVALID_VALUE == textBounds.height )
	{
		contentSize = [self.source.view computeSizeBySize:textBounds];
	}
	else if ( INVALID_VALUE == textBounds.width )
	{
		contentSize = [self.source.view computeSizeByHeight:textBounds.height];
//		contentSize.height = fminf( contentSize.height, textBounds.height );
	}
	else if ( INVALID_VALUE == textBounds.height )
	{
		contentSize = [self.source.view computeSizeByWidth:textBounds.width];
//		contentSize.width = fminf( contentSize.width, textBounds.width );
	}
	else
	{
		contentSize = [self.source.view computeSizeBySize:textBounds];
//		contentSize.width = fminf( textBounds.width, contentSize.width );
//		contentSize.height = fminf( textBounds.height, contentSize.height );
	}
	
	if ( INVALID_VALUE != self.bounds.width )
	{
		if ( contentSize.width > self.bounds.width )
		{
			contentSize.width = self.bounds.width;
		}
	}

	if ( INVALID_VALUE != self.bounds.height )
	{
		if ( contentSize.height > self.bounds.height )
		{
			contentSize.height = self.bounds.height;
		}
	}

	if ( self.source.parent )
	{
		CGFloat parentLineHeight = self.source.parent.layout.computedLineHeight;

		if ( INVALID_VALUE != parentLineHeight )
		{
			if ( contentSize.height < parentLineHeight )
			{
				contentSize.height = parentLineHeight;
			}
		}	
	}

	[self resize:contentSize];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlLayoutText )

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
