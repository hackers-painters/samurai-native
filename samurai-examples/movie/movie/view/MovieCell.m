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

- (void)store_unserialize:(id)obj
{
    [super store_unserialize:obj];
    
    if ( obj )
    {
        self.critics_label.htmlRenderer.customStyle.color = cssColor( [UIColor mv_colorWithScore:[obj[@"critics"] integerValue]] );
        self.audience_label.htmlRenderer.customStyle.color = cssColor( [UIColor mv_colorWithScore:[obj[@"audience"] integerValue]] );

		[self.critics_label restyle];
		[self.audience_label restyle];
    }
}

@end
