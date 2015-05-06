//
//  AppDelegate.m
//  honey
//
//  Created by god on 14-4-8.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "ShotCommentListModel.h"

#pragma mark -

@interface ShotCommentListModel ()
@property (nonatomic, strong) STIHTTPApi * api;
@end

@implementation ShotCommentListModel

@def_prop_assign( NSInteger,			page )
@def_prop_assign( NSInteger,			shot_id )

@def_prop_strong( NSMutableArray *,		comments )

@def_signal( eventLoading )
@def_signal( eventLoaded )
@def_signal( eventError )

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.comments = [NSMutableArray array];
	}
	return self;
}

- (void)dealloc
{
	self.page = 0;
	self.shot_id = 0;
	self.comments = nil;
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
    
    LIST_COMMENTS_FOR_A_SHOT_API * api = [LIST_COMMENTS_FOR_A_SHOT_API new];
    
    @weakify( self );
    
    if ( isFirstTime ) {
        api.req.page = 1;
        self.page = 0;
    } else {
        self.page++;
        api.req.page = self.page + 1;
    }
    
    api.req.per_page = 18;
    api.req.shot = self.shot_id;
    
    api.whenUpdated = ^( LIST_COMMENTS_FOR_A_SHOT_RESPONSE * resp, id error ) {
        
        @strongify( self );
        
        if ( resp )
        {
            if ( isFirstTime )
            {
                [self.comments removeAllObjects];
            }
            
            [self.comments addObjectsFromArray:resp.data];
            
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
