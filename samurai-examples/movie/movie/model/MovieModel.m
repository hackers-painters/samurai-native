//
//  MovieModel.m
//  movie
//
//  Created by QFish on 4/9/15.
//  Copyright (c) 2015 Geek Zoo Studio. All rights reserved.
//

#import "MovieModel.h"
#import "Movies.h"

@interface MovieModel ()
@end

@implementation MovieModel

@def_signal( eventLoading )
@def_signal( eventLoaded )
@def_signal( eventError )

- (void)dealloc
{
    self.id = 0;
    self.movie = nil;
}

#pragma mark -
//
//- (void)modelLoad
//{
//    NSString * key = [NSString stringWithFormat:@"%@_%ld", [[self class] description], (long)self.id];
//    NSData * val = [[SamuraiFileCache sharedInstance] objectForKey:key];
//    
//    if ( val )
//    {
//        self.movie = [MOVIE unserialize:[val JSONDecoded]];
//    }
//}
//
//- (void)modelSave
//{
//    NSString * key = [NSString stringWithFormat:@"%@_%ld", [[self class] description], (long)self.id];
//    NSData * val = [[self.movie serialize] JSONEncoded];
//    
//    [[SamuraiFileCache sharedInstance] setObject:val forKey:key];
//}
//
//- (void)modelClear
//{
//    NSString * key = [NSString stringWithFormat:@"%@_%ld", [[self class] description], (long)self.id];
//    
//    [[SamuraiFileCache sharedInstance] removeObjectForKey:key];
//}

#pragma mark -

- (void)refresh
{
    GET_A_MOVIE_API * api = [GET_A_MOVIE_API new];
    
    @weakify( self );
    
    api.req.id = self.id;
    
    api.whenUpdated = ^( GET_A_MOVIE_RESPONSE * resp, id error ) {
        
        @strongify( self );
        
        if ( resp )
        {
            self.movie = resp.movie;
            
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
