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

@def_prop_assign( NSUInteger,				minCount );
@def_prop_assign( NSUInteger,				maxCount );

@def_prop_strong( NSObject *,				cachedData );
@def_prop_strong( NSMutableDictionary *,	cachedHeight );

@def_prop_assign( NSUInteger,				index );
@def_prop_strong( SamuraiDocument *,		document );
@def_prop_unsafe( UICollectionView *,		collectionView );
@def_prop_strong( NSString *,				reuseIdentifier );

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.minCount = 0;
		self.maxCount = 0;
		self.cachedHeight = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)dealloc
{
	self.cachedData = nil;
	self.cachedHeight = nil;

	self.document = nil;
	self.collectionView = nil;
	self.reuseIdentifier = nil;
}

#pragma mark -

- (id)serialize
{
	return _cachedData;
}

- (void)unserialize:(id)obj
{
	[_cachedHeight removeAllObjects];

	_cachedData = obj;
}

- (void)zerolize
{
	[_cachedHeight removeAllObjects];
	
	_cachedData = nil;
}

#pragma mark -

- (void)clearCache
{
//	_cachedData = nil;
	
	[_cachedHeight removeAllObjects];
}

#pragma mark -

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
	if ( CGRectEqualToRect( self.collectionView.frame, CGRectZero ) )
	{
		return CGSizeZero;
	}
	
	NSString *	cachedKey = [NSString stringWithFormat:@"%ld-%ld", indexPath.section, indexPath.row];
	NSValue *	cachedSize = [_cachedHeight objectForKey:cachedKey];

	if ( cachedSize )
	{
		return [cachedSize CGSizeValue];
	}

	UICollectionViewCell * reuseCell = (UICollectionViewCell *)self.document.renderTree.view;
	
	if ( nil == reuseCell )
	{
		reuseCell = (UICollectionViewCell *)[self.document.renderTree createViewWithIdentifier:nil];
		[reuseCell.renderer bindOutletsTo:reuseCell];
	}
	
	if ( nil == reuseCell )
	{
		reuseCell = [[UICollectionViewCell alloc] initWithFrame:CGRectZero];
		[reuseCell.renderer bindOutletsTo:reuseCell];
	}
	
	NSObject * reuseData = [self getDataForRowAtIndexPath:indexPath];
	
	if ( reuseData )
	{
		[reuseCell unserialize:reuseData];
	}
//		else
//		{
//			[reuseCell zerolize];
//		}
	
	CGSize cellSize = [reuseCell.renderer computeFrame:bounds].size;

	[_cachedHeight setObject:[NSValue valueWithCGSize:cellSize] forKey:cachedKey];
	
	return cellSize;
}

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

- (NSUInteger)getRowCount
{
	if ( nil == self.document || nil == self.document.domTree || nil == self.document.renderTree )
	{
		return 0;
	}
	
	NSUInteger count = 0;
	
	if ( [_cachedData isKindOfClass:[NSArray class]] || [_cachedData conformsToProtocol:@protocol(NSArrayProtocol)] )
	{
		count = [(NSArray *)_cachedData count];
	}
	
	if ( self.maxCount )
	{
		count = MIN( count, self.maxCount );
	}
	
	if ( self.minCount )
	{
		count = MAX( count, self.minCount );
	}
	
	return count;
}

- (NSObject *)getDataForRowAtIndexPath:(NSIndexPath *)indexPath
{
	ASSERT( indexPath );
	
	if ( _cachedData )
	{
		if ( [_cachedData isKindOfClass:[NSArray class]] || [_cachedData conformsToProtocol:@protocol(NSArrayProtocol)] )
		{
			if ( indexPath.row >= [(NSArray *)_cachedData count] )
			{
				return nil;
			}
			else
			{
				NSInteger row = indexPath.row;
				
				return [(NSArray *)_cachedData objectAtIndex:row];
			}
		}
		else
		{
			return _cachedData;
		}
	}
	
	return nil;
}

- (UICollectionViewCell *)getCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	ASSERT( indexPath );

	SamuraiRenderObject *	reuseRenderer = nil;
	NSObject *				reuseData = nil;
	UICollectionViewCell *	reuseCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:self.reuseIdentifier forIndexPath:indexPath];

	if ( reuseCell )
	{
		PERF( @"UICollectionView '%p', reusing cell '%@' for row #%d", self, self.reuseIdentifier, indexPath.row );

		reuseRenderer = reuseCell.renderer;

		if ( nil == reuseRenderer )
		{
			reuseRenderer = [self.document.renderTree clone];
			
			[reuseRenderer bindView:reuseCell];
			[reuseRenderer bindOutletsTo:reuseCell];

		//	[reuseRenderer restyle];

			[self.collectionView.renderer appendNode:reuseRenderer];
		}
		
		reuseData = [self getDataForRowAtIndexPath:indexPath];

		if ( reuseData )
		{
			[reuseCell unserialize:reuseData];
		}
//		else
//		{
//			[reuseCell zerolize];
//		}

		[reuseRenderer relayout];
	}
	
	return reuseCell;
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
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(UIApplicationWillChangeStatusBarOrientationNotification:)
													 name:UIApplicationWillChangeStatusBarOrientationNotification
												   object:nil];
	}
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[self.sections removeAllObjects];
	self.sections = nil;
}

#pragma mark -

- (void)UIApplicationWillChangeStatusBarOrientationNotification:(NSNotification *)notification
{
	for ( SamuraiUICollectionViewSection * section in self.sections )
	{
		[section clearCache];
	}
	
	[self.collectionView reloadData];
}

#pragma mark -

- (void)constructSections:(SamuraiRenderObject *)renderObject
{
	[self.sections removeAllObjects];
	
	NSUInteger index = 0;
	
	SamuraiDocument * parentDoc = renderObject.dom.document;
	if ( parentDoc )
	{
		for ( SamuraiDomNode * childDom in renderObject.dom.childs )
		{
			if ( DomNodeType_Document == childDom.type || DomNodeType_Element == childDom.type )
			{
				SamuraiDocument * childDoc = [parentDoc childDocument:childDom];
				if ( nil == childDoc )
					continue;
				
				BOOL succeed = [childDoc parse];
				if ( succeed )
				{
					succeed = [childDoc reflow];
					if ( succeed )
					{
						if ( [UICollectionViewCell class] == childDoc.renderTree.viewClass || [childDoc.renderTree.viewClass isSubclassOfClass:[UICollectionViewCell class]] )
						{
							SamuraiUICollectionViewSection * section = [[SamuraiUICollectionViewSection alloc] init];
							
							section.index = index++;
							section.document = childDoc;
							section.collectionView = self.collectionView;
							section.reuseIdentifier = [NSString stringWithFormat:@"%@-%@", childDoc.domTree.domTag, childDoc.renderTree.id];
							
							[self.sections addObject:section];
						}
					}
				}
			}
		}
	}

	for ( SamuraiUICollectionViewSection * section in self.sections )
	{
		if ( section.document.renderTree.viewClass )
		{
			[self.collectionView registerClass:section.document.renderTree.viewClass forCellWithReuseIdentifier:section.reuseIdentifier];
//			[self.collectionView registerClass:section.document.renderTree.viewClass forSupplementaryViewOfKind: withReuseIdentifier:section.reuseIdentifier];
		}
	}
}

#pragma mark -

- (SamuraiUICollectionViewSection *)getSection:(NSUInteger)index
{
	return [self.sections safeObjectAtIndex:(index % [self.sections count])];
}

#pragma mark -

- (id)serialize
{
	if ( nil == self.sections || 0 == [self.sections count] )
		return nil;

//	if ( 1 == [self.sections count] )
//	{
//		return [[self.sections firstObject] serialize];
//	}
//	else
	{
		NSMutableDictionary * dict = [NSMutableDictionary dictionary];

		for ( SamuraiUICollectionViewSection * section in self.sections )
		{
			NSString * sectionKey = nil;
			NSString * sectionData = nil;
			
			if ( section.document.domTree.domName )
			{
				sectionKey = section.document.domTree.domName;
			}
			else
			{
				sectionKey = [NSString stringWithFormat:@"%lu", section.index];
			}
			
			sectionData = [section serialize];
			
			if ( sectionKey && sectionData )
			{
				[dict setObject:sectionData forKey:sectionKey];
			}
		}

		return dict;
	}
}

- (void)unserialize:(id)obj
{
	if ( nil == self.sections || 0 == [self.sections count] )
		return;

//	if ( 1 == [self.sections count] )
//	{
//		[[self.sections firstObject] unserialize:obj];
//	}
//	else
	{
		for ( SamuraiUICollectionViewSection * section in self.sections )
		{
			NSString * sectionKey = nil;
			NSString * sectionData = nil;
			
			if ( section.document.domTree.domName )
			{
				sectionKey = section.document.domTree.domName;
			}
			else
			{
				sectionKey = [NSString stringWithFormat:@"%lu", section.index];
			}
			
			if ( [obj isKindOfClass:[NSDictionary class]] || [obj conformsToProtocol:@protocol(NSDictionaryProtocol)] )
			{
				sectionData = [(NSDictionary *)obj objectForKey:sectionKey];
			}
			else
			{
				sectionData = [obj valueForKey:sectionKey];
			}
			
			if ( sectionData && NO == [sectionData isKindOfClass:[NSNull class]] )
			{
				[section unserialize:sectionData];
			}
			else
			{
				[section zerolize];
			}
		}
	}
}

- (void)zerolize
{
	for ( SamuraiUICollectionViewSection * section in self.sections )
	{
		[section zerolize];
	}
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

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath // called when the user taps on an already-selected item in multi-select mode
{
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
	
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0)
{
	
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0)
{
	
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
	
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

	SamuraiUICollectionViewSection * collectionSection = [self getSection:section];
	
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
	SamuraiUICollectionViewSection * collectionSection = [self getSection:indexPath.section];
	
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

	SamuraiUICollectionViewAgent * agent = [collectionView collectionViewAgent];
	
	collectionView.renderer = renderer;
	collectionView.delegate = agent;
	collectionView.dataSource = agent;
	
	[agent constructSections:renderer];

	return collectionView;
}

#pragma mark -

- (SamuraiUICollectionViewAgent *)collectionViewAgent
{
	SamuraiUICollectionViewAgent * agent = [self getAssociatedObjectForKey:"UICollectionView.agent"];
	
	if ( nil == agent )
	{
		agent = [[SamuraiUICollectionViewAgent alloc] init];
		agent.collectionView = self;

		[self retainAssociatedObject:agent forKey:"UICollectionView.agent"];
	}
	
	return agent;
}

#pragma mark -

- (id)serialize
{
	return [[self collectionViewAgent] serialize];
}

- (void)unserialize:(id)obj
{
	[[self collectionViewAgent] unserialize:obj];

	[self reloadData];
}

- (void)zerolize
{
	[[self collectionViewAgent] zerolize];
	
	[self reloadData];
}

#pragma mark -

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
