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

#import "Samurai_UISlider.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_Metric.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiUISliderAgent
{
	BOOL _enabled;
}

@def_prop_unsafe( UISlider *,	slider );

- (void)dealloc
{
	[self disableEvents];
}

- (void)enableEvents
{
	if ( NO == _enabled )
	{
		[self.slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
		
		_enabled = YES;
	}
}

- (void)disableEvents
{
	if ( _enabled )
	{
		[self.slider removeTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];

		_enabled = NO;
	}
}

#pragma mark -

- (void)valueChanged:(id)sender
{
	[self.slider sendSignal:UISlider.eventValueChanged];
}

@end

#pragma mark -

@implementation UISlider(Samurai)

@def_signal( eventValueChanged )

+ (id)createInstanceWithRenderer:(SamuraiRenderObject *)renderer identifier:(NSString *)identifier
{
	UISlider * slider = [[self alloc] initWithFrame:CGRectZero];
	
	slider.renderer = renderer;
	slider.value = 0.0f;
	slider.minimumValue = 0.0f;
	slider.maximumValue = 0.0f;
	slider.continuous = NO;
	
	[[slider sliderAgent] enableEvents];

	return slider;
}

#pragma mark -

- (SamuraiUISliderAgent *)sliderAgent
{
	SamuraiUISliderAgent * agent = [self getAssociatedObjectForKey:"UISlider.agent"];
	
	if ( nil == agent )
	{
		agent = [[SamuraiUISliderAgent alloc] init];
		agent.slider = self;
		
		[self retainAssociatedObject:agent forKey:"UISlider.agent"];
	}
	
	return agent;
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
	return [NSNumber numberWithFloat:self.value];
}

- (void)unserialize:(id)obj
{
	self.value = [obj floatValue];
}

- (void)zerolize
{
	self.value = 0.0f;
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

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, UISlider )

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
