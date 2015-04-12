//
//  AppDelegate.m
//  honey
//
//  Created by god on 14-4-8.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Samurai.h"
#import "UIImageView+WebCache.h"

#pragma mark -

@interface SDWebImageView : UIImageView

@prop_strong( NSString *, loadedURL );
@prop_strong( UIActivityIndicatorView *, indicator );

@end
