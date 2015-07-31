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

#import "Samurai_HtmlElementSelect.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_HtmlRenderStyle.h"
#import "Samurai_HtmlRenderObject.h"
#import "Samurai_HtmlRenderStoreScope.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiHtmlElementSelect
{
	NSUInteger			_selectedIndex;
	NSMutableArray *	_options;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
	}
	return self;
}

- (void)dealloc
{
	_options = nil;
}

#pragma mark -

- (void)html_applyDom:(SamuraiHtmlDomNode *)dom
{
	[super html_applyDom:dom];
	
	_options = [NSMutableArray array];
	
	for ( SamuraiHtmlDomNode * child in dom.childs )
	{
		if ( NSOrderedSame == [child.tag compare:@"option" options:NSCaseInsensitiveSearch] )
		{
			[_options addObject:child];
			
			NSString * selected = child.attrSelected;
			
			if ( selected )
			{
				_selectedIndex = [dom.childs indexOfObject:child];
			}
		}
		else if ( NSOrderedSame == [child.tag compare:@"optgroup" options:NSCaseInsensitiveSearch] )
		{
			for ( SamuraiHtmlDomNode * subchild in dom.childs )
			{
				[_options addObject:subchild];
			
				NSString * selected = child.attrSelected;
				
				if ( selected )
				{
					_selectedIndex = [dom.childs indexOfObject:subchild];
				}
			}
		}
	}

	[self unserialize:@(_selectedIndex)];
}

- (void)html_applyStyle:(SamuraiHtmlRenderStyle *)style
{
	[super html_applyStyle:style];
	
	self.textAlignment = NSTextAlignmentCenter;
	self.userInteractionEnabled = YES;
}

- (void)html_applyFrame:(CGRect)newFrame
{
	[super html_applyFrame:newFrame];
}

#pragma mark -

- (id)store_serialize
{
	if ( [_options count] )
	{
		SamuraiHtmlDomNode * currentOption = [_options objectAtIndex:_selectedIndex];
		
		return currentOption.attrName;
	}
	else
	{
		return nil;
	}
}

- (void)store_unserialize:(id)obj
{
	[super store_unserialize:obj];
	
	if ( [obj isKindOfClass:[NSNumber class]] )
	{
		if ( [_options count] )
		{
			_selectedIndex = [obj integerValue];
			
			if ( _selectedIndex >= [_options count] )
			{
				_selectedIndex = [_options count] - 1;
			}
		}
		else
		{
			_selectedIndex = 0;
		}
	}
	else if ( [obj isKindOfClass:[NSString class]] )
	{
		for ( SamuraiHtmlDomNode * option in _options )
		{
			if ( option.attrName && [option.attrName isEqualToString:obj] )
			{
				_selectedIndex = [_options indexOfObject:option];
				break;
			}
		}
	}
	
	if ( [_options count] )
	{
		SamuraiHtmlDomNode * currentOption = [_options objectAtIndex:_selectedIndex];
		
		self.text = [currentOption computeInnerText];
	}
	else
	{
		self.text = nil;
	}
}

- (void)store_zerolize
{
	[super store_zerolize];
	
	_selectedIndex = 0;
	
	if ( [_options count] )
	{
		SamuraiHtmlDomNode * currentOption = [_options firstObject];
		
		self.text = [currentOption computeInnerText];
	}
	else
	{
		self.text = nil;
	}
}

#pragma mark -

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	TODO( "use UIAlertControl instead" );
	
	UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil
															  delegate:self
													 cancelButtonTitle:@"Cancel"
												destructiveButtonTitle:nil
													 otherButtonTitles:nil];
	
	for ( SamuraiHtmlDomNode * option in _options )
	{
		NSString * text = [option computeInnerText];
		
		if ( text && [text length] )
		{
			[actionSheet addButtonWithTitle:text];
		}
		else
		{
			[actionSheet addButtonWithTitle:@""];
		}
	}

	[actionSheet showInView:self];
}

#pragma mark -

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if ( buttonIndex > 0 )
	{
		[self unserialize:@(buttonIndex - 1)];
	}
}

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
	
}

// before animation and showing view
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
	
}

// after animation
- (void)didPresentActionSheet:(UIActionSheet *)actionSheet
{
	
}

// before animation and hiding view
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	
}

// after animation
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlElementSelect )

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
