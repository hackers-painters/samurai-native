//
//  AppDelegate.m
//  honey
//
//  Created by god on 14-4-8.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "RefreshCollectionView.h"

#import "INSAnimatable.h"
#import "INSInfiniteScrollBackgroundView.h"
#import "INSPullToRefreshBackgroundView.h"
#import "INSCircleInfiniteIndicator.h"
#import "INSCirclePullToRefresh.h"
#import "UIScrollView+INSPullToRefresh.h"

#pragma mark -

@implementation RefreshCollectionView
{
	BOOL _refreshInited;
}

@def_signal( eventPullToRefresh );
@def_signal( eventLoadMore );

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
	self = [super initWithFrame:frame collectionViewLayout:layout];
	if ( self )
	{
		self.backgroundColor = [UIColor clearColor];
	}
	return self;
}

- (void)dealloc
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	
	[self ins_removeInfinityScroll];
	[self ins_removePullToRefresh];
}

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	
	if ( NO == CGSizeEqualToSize(frame.size, CGSizeZero) )
	{
		if ( NO == _refreshInited )
		{
			@weakify(self);
			
			[self ins_addPullToRefreshWithHeight:60.0 handler:^( UIScrollView * scrollView ) {
				@strongify(self);
				[self sendSignal:self.eventPullToRefresh];
			}];
			
			[self ins_addInfinityScrollWithHeight:60 handler:^( UIScrollView * scrollView ) {
				@strongify(self);
				[self sendSignal:self.eventLoadMore];
			}];
			
			UIView<INSAnimatable> * infinityIndicator = [[INSCircleInfiniteIndicator alloc] initWithFrame:CGRectMake(0, 0, 24.0f, 24.0f)];
			UIView<INSPullToRefreshBackgroundViewDelegate> * pullToRefresh = [[INSCirclePullToRefresh alloc] initWithFrame:CGRectMake(0, 0, 24.0f, 24.0f)];

			self.ins_infiniteScrollBackgroundView.preserveContentInset = NO;
			[self.ins_infiniteScrollBackgroundView addSubview:infinityIndicator];
			
			self.ins_pullToRefreshBackgroundView.delegate = pullToRefresh;
			self.ins_pullToRefreshBackgroundView.preserveContentInset = NO;
			[self.ins_pullToRefreshBackgroundView addSubview:pullToRefresh];
			
			[infinityIndicator startAnimating];

			_refreshInited = YES;
		}
	}
}

- (void)stopLoading
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	
	[self performSelector:@selector(stopLoadingDelayed) withObject:nil afterDelay:0.1f];
}

- (void)stopLoadingDelayed
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	
	[self ins_endInfinityScroll];
	[self ins_endPullToRefresh];
}

@end
