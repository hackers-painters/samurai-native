//
//  AppDelegate.m
//  honey
//
//  Created by god on 14-4-8.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "PlayerShotListModel.h"

#pragma mark -

@interface PlayerShotListModel ()
@property (nonatomic, strong) STIHTTPApi * api;
@end

@implementation PlayerShotListModel

@def_prop_assign( NSInteger,			page )
@def_prop_assign( NSInteger,			player_id )

@def_prop_strong( NSMutableArray *,		shots )

@def_signal( eventLoading )
@def_signal( eventLoaded )
@def_signal( eventError )

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.shots = [NSMutableArray array];
	}
	return self;
}

- (void)dealloc
{
	self.page = 0;
	self.player_id = 0;
	
	self.shots = nil;
}

#pragma mark -

- (void)modelLoad
{
}

- (void)modelSave
{
}

- (void)modelClear
{
}

#pragma mark -

- (BOOL)more
{
    return YES;
}

- (void)refresh
{
    [self loadFirstTime:YES];
}

- (void)loadMore
{
    [self loadFirstTime:NO];
}

- (void)loadFirstTime:(BOOL)isFirstTime
{
    [self.api cancel];
    
    LIST_SHOTS_FOR_A_USER_API * api = [LIST_SHOTS_FOR_A_USER_API new];
    
    @weakify( self );
    
    if ( isFirstTime ) {
        api.req.page = 1;
        self.page = 0;
    } else {
        self.page++;
        api.req.page = self.page + 1;
    }
    api.req.user = self.player_id;
    api.req.per_page = 18;
    
    api.whenUpdated = ^( LIST_SHOTS_FOR_A_USER_RESPONSE * resp, id error ) {
        
        @strongify( self );
        
        if ( resp )
        {
            if ( isFirstTime )
            {
                [self.shots removeAllObjects];
            }
            
            [self.shots addObjectsFromArray:resp.data];
            
            [self modelSave];
            
            [self sendSignal:self.eventLoaded];
        }
        else
        {
            [self sendSignal:self.eventError];
        }
    };
    
    self.api = api;
    
    [api send];
    
    [self sendSignal:self.eventLoading];
}

@end
