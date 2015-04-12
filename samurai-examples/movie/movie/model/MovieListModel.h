//
//  MovieListModel.h
//  movie
//
//  Created by QFish on 4/9/15.
//  Copyright (c) 2015 Geek Zoo Studio. All rights reserved.
//

#import "Samurai_ModelInstance.h"
#import "Movies.h"

@interface MovieListModel : SamuraiModel

@property (nonatomic, assign) IN    NSInteger page;
@property (nonatomic, assign) OUT   NSInteger total;
@property (nonatomic, strong) OUT   NSMutableArray * movies;

@signal( eventLoading )
@signal( eventLoaded )
@signal( eventError )

- (void)refresh;

- (BOOL)more;
- (void)loadMore;

@end
