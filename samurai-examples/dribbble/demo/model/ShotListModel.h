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

@interface ShotListModel : SamuraiModel

@prop_assign( NSInteger,            page	IN )
@prop_strong( NSString *,			type	IN )
@prop_strong( NSMutableArray *,		shots	OUT )

@signal( eventLoading )
@signal( eventLoaded )
@signal( eventError )

- (void)refresh;

- (BOOL)more;
- (void)loadMore;

@end

#pragma mark -

@interface PopularShotListModel : ShotListModel
@end

@interface EveryoneShotListModel : ShotListModel
@end

@interface DebutsShotListModel : ShotListModel
@end
