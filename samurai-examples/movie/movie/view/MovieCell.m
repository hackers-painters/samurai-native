//
//  MovieCell.m
//  movie
//
//  Created by QFish on 4/12/15.
//  Copyright (c) 2015 Geek Zoo Studio. All rights reserved.
//

#import "MovieCell.h"
#import "Samurai.h"
#import "Model.h"
#import "UIColor+Movie.h"

@interface MovieCell()
@property (nonatomic, strong) UILabel * critics_label;
@property (nonatomic, strong) UILabel * audience_label;
@end

@implementation MovieCell

- (void)unserialize:(id)obj
{
    [super unserialize:obj];
    
    if ( obj )
    {
        NSInteger score = [obj[@"critics"] integerValue];
        self.critics_label.textColor = [UIColor mv_colorWithScore:score];
        self.critics_label.text = [NSString stringWithFormat:@"critics %@%%", obj[@"critics"]];
    }
}

@end
