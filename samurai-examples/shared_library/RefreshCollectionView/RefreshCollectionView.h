//
//  AppDelegate.m
//  honey
//
//  Created by god on 14-4-8.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Samurai.h"

#pragma mark -

@interface RefreshCollectionView : UICollectionView

@signal( eventPullToRefresh );
@signal( eventLoadMore );

- (void)stopLoading;

@end
