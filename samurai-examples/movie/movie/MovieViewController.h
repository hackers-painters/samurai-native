//
//  MovieViewController.h
//  movie
//
//  Created by QFish on 4/11/15.
//  Copyright (c) 2015 Geek Zoo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Samurai.h"
#import "Samurai_WebCore.h"

@class MOVIE;

@interface MovieViewController : UIViewController
@property (nonatomic, strong) MOVIE * movie;
@end
