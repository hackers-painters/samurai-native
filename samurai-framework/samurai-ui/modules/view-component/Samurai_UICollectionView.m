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

#import "Samurai_UICollectionView.h"
#import "Samurai_UICollectionViewCell.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiUICollectionViewSection

- (CGFloat)getWidthForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [self getSizeForRowAtIndexPath:indexPath byBounds:CGSizeMake(INVALID_VALUE, INVALID_VALUE)].width;
}

- (CGFloat)getWidthForRowAtIndexPath:(NSIndexPath *)indexPath byHeight:(CGFloat)height
{
	return [self getSizeForRowAtIndexPath:indexPath byBounds:CGSizeMake(INVALID_VALUE, height)].width;
}

- (CGFloat)getHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [self getSizeForRowAtIndexPath:indexPath byBounds:CGSizeMake(INVALID_VALUE, INVALID_VALUE)].height;
}

- (CGFloat)getHeightForRowAtIndexPath:(NSIndexPath *)indexPath byWidth:(CGFloat)width
{
	return [self getSizeForRowAtIndexPath:indexPath byBounds:CGSizeMake(width, INVALID_VALUE)].height;
}

- (CGSize)getSizeForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [self getSizeForRowAtIndexPath:indexPath byBounds:CGSizeMake(INVALID_VALUE, INVALID_VALUE)];
}

- (CGSize)getSizeForRowAtIndexPath:(NSIndexPath *)indexPath byWidth:(CGFloat)width
{
	return [self getSizeForRowAtIndexPath:indexPath byBounds:CGSizeMake(width, INVALID_VALUE)];
}

- (CGSize)getSizeForRowAtIndexPath:(NSIndexPath *)indexPath byHeight:(CGFloat)height
{
	return [self getSizeForRowAtIndexPath:indexPath byBounds:CGSizeMake(INVALID_VALUE, height)];
}

- (CGSize)getSizeForRowAtIndexPath:(NSIndexPath *)indexPath byBounds:(CGSize)bounds
{
	return CGSizeZero;
}

- (NSUInteger)getRowCount
{
	return 0;
}

- (NSObject *)getDataForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

- (UICollectionViewCell *)getCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

@end

#pragma mark -

@implementation SamuraiUICollectionViewAgent

@def_prop_strong( NSMutableArray *,		sections );
@def_prop_unsafe( UICollectionView *,	collectionView );

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.sections = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[self.sections removeAllObjects];
	self.sections = nil;
}

#pragma mark -

- (void)appendSection:(SamuraiUICollectionViewSection *)section
{
	if ( nil == section )
		return;
	
	[self.sections addObject:section];
}

- (void)insertSection:(SamuraiUICollectionViewSection *)section atIndex:(NSUInteger)index
{
	if ( nil == section )
		return;
	
	[self.sections insertObject:section atIndex:index];
}

- (void)removeAllSections
{
	[self.sections removeAllObjects];
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath // called when the user taps on an already-selected item in multi-select mode
{
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0)
{
	[cell cellWillDisplay];
	
	[cell.renderer relayout];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0)
{
	[view.renderer relayout];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
	[cell cellDidDisplay];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
	
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{

}

- (UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout
{
	return nil;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	// Default is 1 if not implemented

	SamuraiUICollectionViewSection * collectionSection = [self.sections safeObjectAtIndex:(section % [self.sections count])];
	
	if ( nil == collectionSection )
	{
		return 0;
	}
	else
	{
		return [collectionSection getRowCount];
	}
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	SamuraiUICollectionViewSection * collectionSection = [self.sections safeObjectAtIndex:(indexPath.section % [self.sections count])];
	
	if ( nil == collectionSection )
	{
		return [[UICollectionViewCell alloc] initWithFrame:CGRectZero];
	}
	else
	{
		return [collectionSection getCellForRowAtIndexPath:indexPath];
	}
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	// Default is 1 if not implemented
	
	return [self.sections count];
}

// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

@end

#pragma mark - UICollectionView

@implementation UICollectionView(Samurai)

+ (id)createInstanceWithRenderer:(SamuraiRenderObject *)renderer identifier:(NSString *)identifier
{
	UICollectionViewLayout *	collectionLayout = [[UICollectionViewLayout alloc] init];
	UICollectionView *			collectionView = [[self alloc] initWithFrame:CGRectZero collectionViewLayout:collectionLayout];
	
	collectionView.allowsSelection = NO;
	collectionView.allowsMultipleSelection = NO;
	
	collectionView.renderer = renderer;

	return collectionView;
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

- (SamuraiUICollectionViewAgent *)collectionViewAgent
{
	SamuraiUICollectionViewAgent * agent = [self getAssociatedObjectForKey:"UICollectionView.agent"];
	
	if ( nil == agent )
	{
		agent = [[SamuraiUICollectionViewAgent alloc] init];
		agent.scrollView = self;
		agent.collectionView = self;

		self.delegate = agent;
		self.dataSource = agent;

		[self retainAssociatedObject:agent forKey:"UICollectionView.agent"];
	}
	
	return agent;
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

- (void)applyDom:(SamuraiDomNode *)dom
{
	[super applyDom:dom];
}

- (void)applyStyle:(SamuraiRenderStyle *)style
{
	[super applyStyle:style];
}

- (void)applyFrame:(CGRect)newFrame
{
//	[super applyFrame:frame];
	
	// TODO: if animation
	
	newFrame.origin.x = isnan( newFrame.origin.x ) ? 0.0f : newFrame.origin.x;
	newFrame.origin.y = isnan( newFrame.origin.y ) ? 0.0f : newFrame.origin.y;
	newFrame.size.width = isnan( newFrame.size.width ) ? 0.0f : newFrame.size.width;
	newFrame.size.height = isnan( newFrame.size.height ) ? 0.0f : newFrame.size.height;

	[self setFrame:newFrame];
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

- (BOOL)isCell
{
	return NO;
}

- (BOOL)isCellContainer
{
	return YES;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, UICollectionView )

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
