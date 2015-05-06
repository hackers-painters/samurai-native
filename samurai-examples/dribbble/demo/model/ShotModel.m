//
//  AppDelegate.m
//  honey
//
//  Created by god on 14-4-8.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "ShotModel.h"

#pragma mark -

@interface ShotModel ()
@property (nonatomic, strong) STIHTTPApi * api;
@end

@implementation ShotModel

@def_prop_assign( NSInteger,	 shot_id )
@def_prop_strong( SHOT *,    shot )

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
	self.shot_id = 0;
	self.shot = nil;
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
    
    GET_A_SHOT_API * api = [GET_A_SHOT_API new];
    
    @weakify( self );

    api.req.id = self.shot_id;
    
    api.whenUpdated = ^( GET_A_SHOT_RESPONSE * resp, id error ) {
        
        @strongify( self );
        
        if ( resp )
        {
            self.shot = resp.data;
            
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
