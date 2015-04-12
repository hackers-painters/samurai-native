//
//  AppDelegate.m
//  honey
//
//  Created by god on 14-4-8.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Samurai.h"
#import "dribbble.h"

#pragma mark -

@interface ShotCommentListModel : SamuraiModel

@prop_assign( NSInteger,			page		IN )
@prop_assign( NSInteger,			shot_id		IN )

@prop_strong( NSMutableArray *,		comments	OUT )

@signal( eventLoading )
@signal( eventLoaded )
@signal( eventError )

- (void)refresh;

- (BOOL)more;
- (void)loadMore;

@end
