//
//  AppDelegate.m
//  honey
//
//  Created by god on 14-4-8.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "ShotListModel.h"

#pragma mark -

@interface ShotListModel ()
@property (nonatomic, strong) STIHTTPApi * api;
@end

@implementation ShotListModel

@def_prop_assign( NSInteger,            page )
@def_prop_strong( NSString *,			type )
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
	self.type = nil;
	
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
    
    LIST_SHOTS_API * api = [LIST_SHOTS_API new];
    
    @weakify( self );
    
    if ( isFirstTime ) {
        api.req.page = 1;
        self.page = 0;
    } else {
        self.page++;
        api.req.page = self.page + 1;
    }

    api.req.per_page = 18;
    api.req.list = self.type;
    
    api.whenUpdated = ^( LIST_SHOTS_RESPONSE * resp, id error ) {
        
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

#pragma mark -

@implementation PopularShotListModel

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.type = @"popular";
	}
	return self;
}

- (void)dealloc
{
}

@end

#pragma mark -

@implementation EveryoneShotListModel

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.type = @"everyone";
	}
	return self;
}

- (void)dealloc
{
}

@end

#pragma mark -

@implementation DebutsShotListModel

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.type = @"debuts";
	}
	return self;
}

- (void)dealloc
{
}

@end
