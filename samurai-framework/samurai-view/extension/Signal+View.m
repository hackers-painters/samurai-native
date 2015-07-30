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

#import "Signal+View.h"

#import "_pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

@implementation SamuraiSignal(View)

@def_prop_dynamic( UIView *,				sourceView );
@def_prop_dynamic( UIView *,				sourceCell );
@def_prop_dynamic( UITableViewCell *,		sourceTableCell );
@def_prop_dynamic( UICollectionViewCell *,	sourceCollectionCell );

@def_prop_dynamic( SamuraiDomNode *,		sourceDom );
@def_prop_dynamic( SamuraiRenderObject *,	sourceRender );
@def_prop_dynamic( NSIndexPath *,			sourceIndexPath );

- (UIView *)sourceView
{
	if ( nil == self.source )
		return nil;

	if ( [self.source isKindOfClass:[UIView class]] )
	{
		return (UIView *)self.source;
	}
	else if ( [self.source isKindOfClass:[UIViewController class]] )
	{
		return ((UIViewController *)self.source).view;
	}

	return nil;
}

- (UIView *)sourceCell
{
	if ( nil == self.source )
		return nil;
	
	UIView * thisView = nil;
	
	if ( [self.source isKindOfClass:[UIView class]] )
	{
		thisView = (UIView *)self.source;
	}
	else if ( [self.source isKindOfClass:[UIViewController class]] )
	{
		thisView = ((UIViewController *)self.source).view;
	}
	
	while ( nil != thisView )
	{
		if ( [thisView isKindOfClass:[UITableViewCell class]] || [thisView isKindOfClass:[UICollectionViewCell class]] )
		{
			return thisView;
		}
		
		thisView = thisView.superview;
	}
	
	return nil;
}

- (UITableViewCell *)sourceTableCell
{
	if ( nil == self.source )
		return nil;
	
	UIView * thisView = nil;
	
	if ( [self.source isKindOfClass:[UIView class]] )
	{
		thisView = (UIView *)self.source;
	}
	else if ( [self.source isKindOfClass:[UIViewController class]] )
	{
		thisView = ((UIViewController *)self.source).view;
	}

	while ( nil != thisView )
	{
		if ( [thisView isKindOfClass:[UITableViewCell class]] )
		{
			return (UITableViewCell *)thisView;
		}
		
		thisView = thisView.superview;
	}
	
	return nil;
}

- (UICollectionViewCell *)sourceCollectionCell
{
	if ( nil == self.source )
		return nil;
	
	UIView * thisView = nil;
	
	if ( [self.source isKindOfClass:[UIView class]] )
	{
		thisView = (UIView *)self.source;
	}
	else if ( [self.source isKindOfClass:[UIViewController class]] )
	{
		thisView = ((UIViewController *)self.source).view;
	}

	while ( nil != thisView )
	{
		if ( [thisView isKindOfClass:[UICollectionViewCell class]] )
		{
			return (UICollectionViewCell *)thisView;
		}
		
		thisView = thisView.superview;
	}
	
	return nil;
}

- (SamuraiDomNode *)sourceDom
{
	if ( nil == self.source )
		return nil;
	
	return [[self.source renderer] dom];
}

- (SamuraiRenderObject *)sourceRender
{
	if ( nil == self.source )
		return nil;
	
	return [self.source renderer];
}

- (NSIndexPath *)sourceIndexPath
{
	if ( nil == self.source )
		return nil;
	
	UIView * thisView = nil;

	if ( [self.source isKindOfClass:[UIView class]] )
	{
		thisView = (UIView *)self.source;
	}
	else if ( [self.source isKindOfClass:[UIViewController class]] )
	{
		thisView = ((UIViewController *)self.source).view;
	}
	
	while ( nil != thisView )
	{
		if ( [thisView isCell] )
		{
			return [thisView computeIndexPath];
		}
		
		thisView = thisView.superview;
	}
	
	return nil;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
