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

#import "Samurai_UIView.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation UIView(Samurai)

+ (id)createInstanceWithRenderer:(SamuraiRenderObject *)renderer identifier:(NSString *)identifier
{
	UIView * newView = [[self alloc] initWithFrame:CGRectZero];
	newView.renderer = renderer;
	return newView;
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

- (CGSize)computeSizeBySize:(CGSize)size
{
	return size;
}

- (CGSize)computeSizeByWidth:(CGFloat)width
{
	return CGSizeMake( width, self.frame.size.height );
}

- (CGSize)computeSizeByHeight:(CGFloat)height
{
	return CGSizeMake( self.frame.size.width, height );
}

#pragma mark -

- (void)applyDom:(SamuraiDomNode *)dom
{
	
}

- (void)applyStyle:(SamuraiRenderStyle *)style
{
	
}

- (void)applyFrame:(CGRect)newFrame
{
	// TODO: if animation
	
	newFrame.origin.x = isnan( newFrame.origin.x ) ? 0.0f : newFrame.origin.x;
	newFrame.origin.y = isnan( newFrame.origin.y ) ? 0.0f : newFrame.origin.y;
	newFrame.size.width = isnan( newFrame.size.width ) ? 0.0f : newFrame.size.width;
	newFrame.size.height = isnan( newFrame.size.height ) ? 0.0f : newFrame.size.height;

	[UIView performWithoutAnimation:^{
		[self setFrame:newFrame];
	}];
}

#pragma mark -

- (BOOL)isCell
{
	return NO;
}

- (BOOL)isCellContainer
{
	return NO;
}

- (NSIndexPath *)computeIndexPath
{
	return nil;
}

#pragma mark -

- (NSString *)description
{
	[[SamuraiLogger sharedInstance] outputCapture];
	
	[self dump];
	
	[[SamuraiLogger sharedInstance] outputRelease];
	
	return [SamuraiLogger sharedInstance].output;
}

- (void)dump
{
	SEL selector = NSSelectorFromString( @"recursiveDescription" );
	if ( selector && [self respondsToSelector:selector] )
	{
		NSMethodSignature * signature = [self methodSignatureForSelector:selector];
		NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];
		
		[invocation setTarget:self];
		[invocation setSelector:selector];
		[invocation invoke];
	}
}

#pragma mark -

- (id)serialize
{
	return nil;
}

- (void)unserialize:(id)obj
{
}

- (void)zerolize
{
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, UIView )

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
