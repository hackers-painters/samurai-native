//
//  MoviesClient.h
//  demo
//
//  Created by QFish on 4/7/15.
//  Copyright (c) 2015 Geek-Zoo Studio. All rights reserved.
//

#import "STIHTTPSessionManager.h"
#import "NSObject+AutoCoding.h"
#import "Movies.h"

@interface MoviesClient : STIHTTPSessionManager
+ (instancetype)sharedClient;
@end

@interface NSObject (APIExtension) <AutoModelCoding>
@end

@interface GET_A_MOVIE_API (APIExtension)
@end