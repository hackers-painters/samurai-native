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

#import "UIView+TemplateLoading.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation UIView(TemplateLoading)

#pragma mark -

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
	[self.template.document.renderTree.view removeFromSuperview];

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
		[template.document configureForView:self];

		SamuraiRenderObject * rootRender = template.document.renderTree;
		
		if ( rootRender )
		{
			if ( self.renderer )
			{
				for ( SamuraiRenderObject * childRender in [rootRender.childs reverseObjectEnumerator] )
				{
					[self.renderer appendNode:childRender];
					
					UIView * childView = [childRender createViewWithIdentifier:nil];

					if ( childView )
					{
						[self addSubview:childView];
						
						[childRender bindOutletsTo:self];
					}
				}
			}
			else
			{
//				self.renderer = rootRender;
			}

			[rootRender rechain];
		//	[rootRender relayout];

		#if __SAMURAI_UI_USE_CALLCHAIN__
			[self performCallChainWithSelector:@selector(onTemplateLoaded) reversed:YES];
		#else	// #if __SAMURAI_UI_USE_CALLCHAIN__
			[self onTemplateLoaded];
		#endif	// #if __SAMURAI_UI_USE_CALLCHAIN__
		}
		else
		{
		#if __SAMURAI_UI_USE_CALLCHAIN__
			[self performCallChainWithSelector:@selector(onTemplateFailed) reversed:YES];
		#else	// #if __SAMURAI_UI_USE_CALLCHAIN__
			[self onTemplateFailed];
		#endif	// #if __SAMURAI_UI_USE_CALLCHAIN__
		}
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
	if ( self.renderer )
	{
		[self.renderer rechain];
	}
}

- (void)relayout
{
	CGSize viewSize = self.frame.size;
	
	if ( CGSizeEqualToSize( viewSize, CGSizeZero ) )
	{
		self.layer.hidden = YES;
	}
	else
	{
		self.layer.hidden = NO;

		if ( self.renderer )
		{
			[self.renderer relayout];
		}
	}
}

- (void)restyle
{
	if ( self.renderer )
	{
		[self.renderer restyle];
	}
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, UIView_TemplateLoading )

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
