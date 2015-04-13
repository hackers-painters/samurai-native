//
//  MovieModel.h
//  movie
//
//  Created by QFish on 4/9/15.
//  Copyright (c) 2015 Geek Zoo Studio. All rights reserved.
//

#import "Samurai_ModelInstance.h"

@class MOVIE;

@interface MovieModel : SamuraiModel

@property (nonatomic, strong) IN  NSString * id;
@property (nonatomic, strong) OUT MOVIE * movie;

@signal( eventLoading )
@signal( eventLoaded )
@signal( eventError )

- (void)refresh;

@end
