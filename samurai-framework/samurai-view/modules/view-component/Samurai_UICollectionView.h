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

#import "Samurai_Core.h"
#import "Samurai_Event.h"

#import "Samurai_ViewConfig.h"
#import "Samurai_ViewCore.h"
#import "Samurai_ViewEvent.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_UIView.h"
#import "Samurai_UIScrollView.h"

#pragma mark -

@interface SamuraiUICollectionViewSection : NSObject

- (CGFloat)getWidthForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)getWidthForRowAtIndexPath:(NSIndexPath *)indexPath byHeight:(CGFloat)height;
- (CGFloat)getHeightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)getHeightForRowAtIndexPath:(NSIndexPath *)indexPath byWidth:(CGFloat)width;
- (CGSize)getSizeForRowAtIndexPath:(NSIndexPath *)indexPath byBounds:(CGSize)bounds;
- (CGSize)getSizeForRowAtIndexPath:(NSIndexPath *)indexPath byWidth:(CGFloat)width;
- (CGSize)getSizeForRowAtIndexPath:(NSIndexPath *)indexPath byHeight:(CGFloat)height;

- (NSUInteger)getRowCount;														// override point
- (CGSize)getSizeForRowAtIndexPath:(NSIndexPath *)indexPath;					// override point
- (NSObject *)getDataForRowAtIndexPath:(NSIndexPath *)indexPath;				// override point
- (UICollectionViewCell *)getCellForRowAtIndexPath:(NSIndexPath *)indexPath;	// override point

@end

#pragma mark -

@interface SamuraiUICollectionViewAgent : SamuraiUIScrollViewAgent<UICollectionViewDelegate, UICollectionViewDataSource>

@prop_strong( NSMutableArray *,		sections );
@prop_unsafe( UICollectionView *,	collectionView );

- (void)appendSection:(SamuraiUICollectionViewSection *)section;
- (void)insertSection:(SamuraiUICollectionViewSection *)section atIndex:(NSUInteger)index;
- (void)removeAllSections;

@end

#pragma mark -

@interface UICollectionView(Samurai)

- (SamuraiUICollectionViewAgent *)collectionViewAgent;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
