//
//  AppDelegate.m
//  honey
//
//  Created by god on 14-4-8.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Samurai.h"
#import "Dribbble.h"

#pragma mark -

@interface PlayerModel : SamuraiModel

@prop_assign( NSInteger,	player_id )
@prop_strong( USER *,		player )

@signal( eventLoading )
@signal( eventLoaded )
@signal( eventError )

- (void)refresh;

@end
