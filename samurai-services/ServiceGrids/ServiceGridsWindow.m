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

#import "ServiceGridsWindow.h"

#pragma mark -

@implementation ServiceGridsWindow

@def_singleton( ServiceGridsWindow )

- (id)init
{
	self = [super initWithFrame:[UIScreen mainScreen].bounds];
	if ( self )
	{
		self.hidden = YES;
		self.backgroundColor = [UIColor clearColor];
		self.windowLevel = UIWindowLevelStatusBar + 2.0f;
		self.userInteractionEnabled = NO;
		self.rootViewController = [[UIViewController alloc] init];
	}
	return self;
}

- (void)dealloc
{
}

#pragma mark -

- (void)show
{
	self.hidden = NO;
}

- (void)hide
{
	self.hidden = YES;
}

#pragma mark -

- (void)drawRect:(CGRect)rect
{
	CGFloat a = 30.0f;
	CGFloat i = 5.0f;
//	CGFloat n = [UIScreen mainScreen].bounds.size.width / (a + i);

	CGContextRef context = UIGraphicsGetCurrentContext();
	if ( context )
	{
		CGContextSaveGState( context );

		CGContextSetFillColorWithColor( context, [[UIColor clearColor] CGColor] );
		CGContextFillRect( context, rect );

		CGFloat x = 0;
		
		while ( x < [UIScreen mainScreen].bounds.size.width )
		{
			x += i;
			
			CGRect column;
			column.origin.x = x;
			column.origin.y = 0.0f;
			column.size.width = a;
			column.size.height = [UIScreen mainScreen].bounds.size.height;

			CGContextSetFillColorWithColor( context, [HEX_RGBA( 0xc3ebfa, 0.4f ) CGColor] );
			CGContextFillRect( context, column );

			CGContextSetStrokeColorWithColor( context, [HEX_RGBA( 0x0097ff, 0.8f ) CGColor] );
			CGContextStrokeRect( context, column );

			x += a;
		}

		CGContextRestoreGState( context );
	}
	
	[super drawRect:rect];
}

@end
