//
//  UIColor+Movie.m
//  movie
//
//  Created by QFish on 4/13/15.
//  Copyright (c) 2015 Geek Zoo Studio. All rights reserved.
//

#import "UIColor+Movie.h"

@implementation UIColor (Movie)

+ (UIColor *)mv_colorWithScore:(NSInteger)score
{
    NSInteger max = 200;
    NSInteger value = (score / 100.f) * max;
    return [UIColor colorWithRed:(max - value) / 255.f green:value / 255.f blue:0 alpha:1];
}

@end
