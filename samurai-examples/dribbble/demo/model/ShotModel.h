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

@interface ShotModel : SamuraiModel

@prop_assign( NSInteger,				shot_id )
@prop_strong( SHOT *,	shot )

@signal( eventLoading )
@signal( eventLoaded )
@signal( eventError )

- (void)refresh;

@end
