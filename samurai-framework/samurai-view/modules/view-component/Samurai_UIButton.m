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

#import "Samurai_UIButton.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_Metric.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiUIButtonAgent
{
	BOOL _enabled;
}

@def_prop_unsafe( UIButton *,	button );

- (void)dealloc
{
	[self disableEvents];
}

- (void)enableEvents
{
	if ( NO == _enabled )
	{
		[self.button addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
		[self.button addTarget:self action:@selector(touchDownRepeat:) forControlEvents:UIControlEventTouchDownRepeat];
		[self.button addTarget:self action:@selector(touchDragInside:) forControlEvents:UIControlEventTouchDragInside];
		[self.button addTarget:self action:@selector(touchDragOutside:) forControlEvents:UIControlEventTouchDragOutside];
		[self.button addTarget:self action:@selector(touchDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
		[self.button addTarget:self action:@selector(touchDragExit:) forControlEvents:UIControlEventTouchDragExit];
		[self.button addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
		[self.button addTarget:self action:@selector(touchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
		[self.button addTarget:self action:@selector(touchCancel:) forControlEvents:UIControlEventTouchCancel];
		
		_enabled = YES;
	}
}

- (void)disableEvents
{
	if ( _enabled )
	{
		[self.button removeTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
		[self.button removeTarget:self action:@selector(touchDownRepeat:) forControlEvents:UIControlEventTouchDownRepeat];
		[self.button removeTarget:self action:@selector(touchDragInside:) forControlEvents:UIControlEventTouchDragInside];
		[self.button removeTarget:self action:@selector(touchDragOutside:) forControlEvents:UIControlEventTouchDragOutside];
		[self.button removeTarget:self action:@selector(touchDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
		[self.button removeTarget:self action:@selector(touchDragExit:) forControlEvents:UIControlEventTouchDragExit];
		[self.button removeTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
		[self.button removeTarget:self action:@selector(touchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
		[self.button removeTarget:self action:@selector(touchCancel:) forControlEvents:UIControlEventTouchCancel];
		
		_enabled = NO;
	}
}

#pragma mark -

- (void)touchDown:(__unused id)sender
{
	[self.button sendSignal:UIView.eventTapPressing];
}

- (void)touchDownRepeat:(__unused id)sender
{
	
}

- (void)touchDragInside:(__unused id)sender
{
	
}

- (void)touchDragOutside:(__unused id)sender
{
	
}

- (void)touchDragEnter:(__unused id)sender
{
	
}

- (void)touchDragExit:(__unused id)sender
{
	
}

- (void)touchUpInside:(__unused id)sender
{
	if ( self.button.tapSignalName )
	{
		[self.button sendSignal:self.button.tapSignalName];
	}
	else
	{
		[self.button sendSignal:UIView.eventTapRaised];
	}
}

- (void)touchUpOutside:(__unused id)sender
{
	[self.button sendSignal:UIView.eventTapCancelled];
}

- (void)touchCancel:(__unused id)sender
{
	[self.button sendSignal:UIView.eventTapCancelled];
}

@end

#pragma mark -

@implementation UIButton(Samurai)

+ (id)createInstanceWithRenderer:(SamuraiRenderObject *)renderer identifier:(__unused NSString *)identifier
{
	UIButton * button = [self buttonWithType:UIButtonTypeCustom];

	button.renderer = renderer;
	
	[[button buttonAgent] enableEvents];
	
	return button;
}

#pragma mark -

- (SamuraiUIButtonAgent *)buttonAgent
{
	SamuraiUIButtonAgent * agent = [self getAssociatedObjectForKey:"UIButton.agent"];
	
	if ( nil == agent )
	{
		agent = [[SamuraiUIButtonAgent alloc] init];
		agent.button = self;

		[self retainAssociatedObject:agent forKey:"UIButton.agent"];
	}

	return agent;
}

#pragma mark -

+ (BOOL)supportTapGesture
{
	return NO;
}

+ (BOOL)supportSwipeGesture
{
	return NO;
}

+ (BOOL)supportPinchGesture
{
	return NO;
}

+ (BOOL)supportPanGesture
{
	return NO;
}

#pragma mark -

- (id)serialize
{
	return [self currentTitle];
}

- (void)unserialize:(id)obj
{
	[self setTitle:[[obj toString] normalize] forState:UIControlStateNormal];
}

- (void)zerolize
{
	[self setTitle:nil forState:UIControlStateNormal];
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
	return [super computeSizeBySize:size];
}

- (CGSize)computeSizeByWidth:(CGFloat)width
{
	return [super computeSizeByWidth:width];
}

- (CGSize)computeSizeByHeight:(CGFloat)height
{
	return [super computeSizeByHeight:height];
}

#pragma mark -

- (void)enableTapGesture
{
	[self enableTapGestureWithSignal:nil];
}

- (void)enableTapGestureWithSignal:(NSString *)signal
{
	self.tapSignalName = signal;

	[[self buttonAgent] enableEvents];
}

- (void)disableTapGesture
{
	[[self buttonAgent] disableEvents];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, UIButton )

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
