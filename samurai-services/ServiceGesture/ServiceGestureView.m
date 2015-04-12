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

#import "ServiceGestureView.h"
#import "ServiceGestureSetting.h"

// ----------------------------------
// Source code
// ----------------------------------

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

@implementation ServiceGestureView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		self.userInteractionEnabled = NO;
		self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2f];
		self.alpha = 0.85f;
		self.hidden = [[ServiceGestureSetting sharedInstance] isEnabled] ? NO : YES;
		self.layer.borderColor = [HEX_RGBA(0xeb212e, 0.6) CGColor];
		self.layer.borderWidth = 3.0f;

		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(didEnabled)
													 name:ServiceGestureSetting.Enabled
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(didDisabled)
													 name:ServiceGestureSetting.Disabled
												   object:nil];
	}
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setGesture:(UIGestureRecognizer *)gesture
{	
}

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	
	self.layer.masksToBounds = YES;
	self.layer.cornerRadius = fminf( frame.size.width, frame.size.height ) / 2.0f;
}

- (void)startAnimation
{
}

- (void)stopAnimation
{
}

- (void)didEnabled
{
	self.hidden = NO;
}

- (void)didDisabled
{
	self.hidden = YES;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
