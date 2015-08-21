//
//  AppDelegate.m
//  honey
//
//  Created by god on 14-4-8.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "PlayerModel.h"

#pragma mark -

@interface PlayerModel ()
@property (nonatomic, strong) STIHTTPApi * api;
@end

@implementation PlayerModel

@def_prop_assign( NSInteger,	player_id )
@def_prop_strong( USER *,		player )

@def_signal( eventLoading )
@def_signal( eventLoaded )
@def_signal( eventError )

- (id)init
{
	self = [super init];
	if ( self )
	{
	}
	return self;
}

- (void)dealloc
{
	self.player_id = 0;
	self.player = nil;
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

- (void)refresh
{
    [self.api cancel];
    
    GET_A_SINGLE_USER_API * api = [GET_A_SINGLE_USER_API new];
	
	@weakify( self );
	
	api.req.user = self.player_id;
	
	api.whenUpdated = ^( GET_A_SINGLE_USER_RESPONSE * resp, id error ) {
        
        @strongify( self );
        
        if ( resp )
        {
            self.player = resp.data;
            
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
