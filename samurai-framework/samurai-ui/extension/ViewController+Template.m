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

#import "Viewcontroller+Template.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation UIViewController(Template)

- (SamuraiRenderStoreScope *)viewStore
{
	if ( [self isViewLoaded] )
	{
		return [SamuraiRenderStoreScope storeScope:[[self view] renderer]];
	}
	
	return nil;
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

#pragma mark -

- (void)loadViewTemplate
{
	self.viewTemplate = [[SamuraiViewTemplate alloc] init];
	self.viewTemplate.responder = self;
	
	[self.viewTemplate loadClass:[self class]];
}

- (void)unloadViewTemplate
{
	[self.viewTemplate stopLoading];
	[self.viewTemplate.document.renderTree unbindOutletsFrom:self];
	
	self.viewTemplate.responder = nil;
	self.viewTemplate = nil;
}

- (void)handleViewTemplate:(SamuraiViewTemplate *)viewTemplate
{
	ASSERT( viewTemplate == self.viewTemplate );
	
	if ( viewTemplate.loading )
	{
		[self performCallChainWithSelector:@selector(onTemplateLoading) reversed:YES];
	}
	else if ( viewTemplate.loaded )
	{
		if ( viewTemplate.document.renderTree )
		{
			UIView * rootView = [self.viewTemplate.document.renderTree createViewWithIdentifier:nil];
			
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
				
				[self.viewTemplate.document.renderTree bindOutletsTo:self];
			}
			else
			{
				[self.viewTemplate.document.renderTree unbindOutletsFrom:self];
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
		
		if ( self.viewTemplate )
		{
			NSString * documentTitle = [self.viewTemplate.document computeTitle];

			if ( documentTitle )
			{
				self.title = documentTitle;
			}
		}
		
		[self performCallChainWithSelector:@selector(onTemplateLoaded) reversed:YES];
	}
	else if ( viewTemplate.failed )
	{
		[self performCallChainWithSelector:@selector(onTemplateFailed) reversed:YES];
	}
	else if ( viewTemplate.cancelled )
	{
		[self performCallChainWithSelector:@selector(onTemplateCancelled) reversed:YES];
	}
}

#pragma mark -

- (void)relayout
{
	if ( [self isViewLoaded] )
	{
		if ( self.viewTemplate )
		{
			[self.viewTemplate relayout];
		}
	}
}

#pragma mark -

- (id)objectForKey:(id)key
{
	return [[self viewStore] getDataWithPath:key];
}

- (BOOL)hasObjectForKey:(id)key
{
	return [[self viewStore] getDataWithPath:key] ? YES : NO;
}

- (void)setObject:(id)value forKey:(id)key
{
	[[self viewStore] setData:value withPath:key];
}

- (void)removeObjectForKey:(id)key
{
	[[self viewStore] clearDataWithPath:key];
}

- (void)removeAllObjects
{
	[[self viewStore] clearData];
}

- (id)objectForKeyedSubscript:(id)key;
{
	return [self objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key
{
	[self setObject:obj forKey:key];
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
}

- (void)onTemplateCancelled
{
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, ViewController_Template )
{
//	TODO( @"test case" )
}
TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "_pragma_pop.h"
