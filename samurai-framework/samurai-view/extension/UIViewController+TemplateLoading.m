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

#import "UIViewcontroller+TemplateLoading.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation UIViewController(TemplateLoading)

- (void)loadTemplate
{
	self.template = [[SamuraiTemplate alloc] init];
	self.template.responder = self;
	
	[self.template loadClass:[self class]];
}

- (void)unloadTemplate
{
	[self.template stopLoading];
	[self.template.document.renderTree unbindOutletsFrom:self];
	
	self.template.responder = nil;
	self.template = nil;
}

- (void)handleTemplate:(SamuraiTemplate *)template
{
	ASSERT( template == self.template );
	
	if ( template.loading )
	{
	#if __SAMURAI_UI_USE_CALLCHAIN__
		[self performCallChainWithSelector:@selector(onTemplateLoading) reversed:YES];
	#else	// #if __SAMURAI_UI_USE_CALLCHAIN__
		[self onTemplateLoading];
	#endif	// #if __SAMURAI_UI_USE_CALLCHAIN__
	}
	else if ( template.loaded )
	{
		if ( template.document.renderTree )
		{
			UIView * rootView = [self.template.document.renderTree createViewWithIdentifier:nil];
			
			if ( rootView )
			{
				if ( [self isViewLoaded] )
				{
					rootView.frame = self.view.frame;
					
					if ( [self.view isKindOfClass:[UIScrollView class]] )
					{
						__unsafe_unretained UIScrollView * leftView = (UIScrollView *)rootView;
						__unsafe_unretained UIScrollView * rightView = (UIScrollView *)self.view;
						
						leftView.bounces = rightView.bounces;
						leftView.contentSize = rightView.contentSize;
						leftView.contentInset = rightView.contentInset;
						leftView.contentOffset = rightView.contentOffset;
						leftView.alwaysBounceVertical = rightView.alwaysBounceVertical;
						leftView.alwaysBounceHorizontal = rightView.alwaysBounceHorizontal;
						leftView.pagingEnabled = rightView.pagingEnabled;
						leftView.scrollEnabled = rightView.scrollEnabled;
						leftView.showsHorizontalScrollIndicator = rightView.showsHorizontalScrollIndicator;
						leftView.showsVerticalScrollIndicator = rightView.showsVerticalScrollIndicator;
						leftView.scrollIndicatorInsets = rightView.scrollIndicatorInsets;
						leftView.indicatorStyle = rightView.indicatorStyle;
						leftView.decelerationRate = rightView.decelerationRate;
					}
				}

				self.view = rootView;
				
				[self.template.document.renderTree bindOutletsTo:self];
			}
			else
			{
				[self.template.document.renderTree unbindOutletsFrom:self];
			}
		}
		else
		{
			if ( [self isViewLoaded] )
			{
				self.view.renderer = nil;
				self.view = nil;
			}
		}
		
		[self.template.document configureForViewController:self];
		[self.template.document.renderTree rechain];

	#if __SAMURAI_UI_USE_CALLCHAIN__
		[self performCallChainWithSelector:@selector(onTemplateLoaded) reversed:YES];
	#else	// #if __SAMURAI_UI_USE_CALLCHAIN__
		[self onTemplateLoaded];
	#endif	// #if __SAMURAI_UI_USE_CALLCHAIN__
	}
	else if ( template.failed )
	{
	#if __SAMURAI_UI_USE_CALLCHAIN__
		[self performCallChainWithSelector:@selector(onTemplateFailed) reversed:YES];
	#else	// #if __SAMURAI_UI_USE_CALLCHAIN__
		[self onTemplateFailed];
	#endif	// #if __SAMURAI_UI_USE_CALLCHAIN__
	}
	else if ( template.cancelled )
	{
	#if __SAMURAI_UI_USE_CALLCHAIN__
		[self performCallChainWithSelector:@selector(onTemplateCancelled) reversed:YES];
	#else	// #if __SAMURAI_UI_USE_CALLCHAIN__
		[self onTemplateCancelled];
	#endif	// #if __SAMURAI_UI_USE_CALLCHAIN__
	}
}

#pragma mark -

- (void)onTemplateLoading
{
}

- (void)onTemplateLoaded
{
	[self relayout];
}

- (void)onTemplateFailed
{
	[self relayout];
}

- (void)onTemplateCancelled
{
	[self relayout];
}

#pragma mark -

- (void)rechain
{
	if ( [self isViewLoaded] )
	{
		if ( self.template )
		{
			if ( self.template.document && self.template.document.renderTree )
			{
				[self.template.document.renderTree rechain];
			}
		}
	}
}

- (void)relayout
{
	if ( [self isViewLoaded] )
	{
		CGSize viewSize = self.view.frame.size;
		
		if ( CGSizeEqualToSize( viewSize, CGSizeZero ) )
		{
			self.view.layer.hidden = YES;
		}
		else
		{
			self.view.layer.hidden = NO;
			
			if ( self.template )
			{
				if ( self.template.document && self.template.document.renderTree )
				{
					[self.template.document.renderTree relayout];
				}
			}
		}
	}
}

- (void)restyle
{
	if ( [self isViewLoaded] )
	{
		if ( self.template )
		{
			if ( self.template.document && self.template.document.renderTree )
			{
				[self.template.document.renderTree restyle];
			}
		}
	}
}

#pragma mark -

- (NSArray*)keyCommands
{
	UIKeyCommand * command = [UIKeyCommand keyCommandWithInput:@"r"
												 modifierFlags:UIKeyModifierCommand
														action:@selector(handleCommandR:)];
	return [NSArray arrayWithObject:command];
}

- (void)handleCommandR:(UIKeyCommand *)command
{
	int __break = 0;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, UIViewController_TemplateLoading )

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
