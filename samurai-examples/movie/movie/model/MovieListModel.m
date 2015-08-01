//
//  MovieListModel.m
//  movie
//
//  Created by QFish on 4/9/15.
//  Copyright (c) 2015 Geek Zoo Studio. All rights reserved.
//

#import "MovieListModel.h"

@interface MovieListModel ()
@end

@implementation MovieListModel

@def_signal( eventLoading )
@def_signal( eventLoaded )
@def_signal( eventError )

- (id)init
{
    self = [super init];
    if ( self )
    {
        self.movies = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc
{
    self.total = 0;
    self.page = 0;
    self.movies = nil;
}

#pragma mark -

- (void)modelLoad
{
    // todo
}

- (void)modelSave
{
    // todo
}

- (void)modelClear
{
    // todo
}

#pragma mark -

- (BOOL)more
{
    return self.movies.count < self.total;
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
    LIST_MOVIES_API * api = [LIST_MOVIES_API new];
    
    @weakify( self );
    
    if ( isFirstTime )
    {
        api.req.page = 1;
        self.page = 1;
    }
    else
    {
        self.page++;
        api.req.page = self.page;
    }
    
    api.req.page_limit = 10;
    
    api.whenUpdated = ^( LIST_MOVIES_RESPONSE * resp, id error ) {
        
        @strongify( self );
        
        if ( resp )
        {
            if ( isFirstTime )
            {
                [self.movies removeAllObjects];
            }
            
            self.total = resp.total;
            
            [self.movies addObjectsFromArray:resp.movies];
            
            [self modelSave];
            
            [self sendSignal:self.eventLoaded];
        }
        else
        {
            [self sendSignal:self.eventError];
        }
    };
    
    [api send];
    
    [self sendSignal:self.eventLoading];
}

@end
