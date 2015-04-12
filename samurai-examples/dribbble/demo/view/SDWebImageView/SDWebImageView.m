//
//  AppDelegate.m
//  honey
//
//  Created by god on 14-4-8.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "SDWebImageView.h"

#pragma mark -

@implementation SDWebImageView

@def_prop_strong( UIActivityIndicatorView *, indicator );
@def_prop_strong( NSString *,                loadedURL );

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		self.indicator.color = [UIColor blackColor];
		self.indicator.hidesWhenStopped = YES;
		[self addSubview:self.indicator];
	}
	return self;
}

- (void)dealloc
{
	[self.indicator removeFromSuperview];
	self.indicator = nil;
	
	[self stopLoading];
	
	self.loadedURL = nil;
}

#pragma mark -

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect indFrame;
	indFrame.size.width = 14.0f;
	indFrame.size.height = 14.0f;
	indFrame.origin.x = (self.frame.size.width - indFrame.size.width) / 2.0f;
	indFrame.origin.y = (self.frame.size.height - indFrame.size.height) / 2.0f;

	self.indicator.frame = indFrame;
}

#pragma mark -

- (id)serialize
{
	return self.loadedURL;
}

- (void)unserialize:(id)obj
{
	[self stopLoading];
	
	if ( [obj isKindOfClass:[NSString class]] )
	{
		if ( [obj hasPrefix:@"//"] || [obj hasPrefix:@"http://"] || [obj hasPrefix:@"https://"] )
		{
			[self loadURL:obj];
			return;
		}

		NSData * imageData = [obj BASE64Decrypted];
		if ( imageData )
		{
			self.image = [[UIImage alloc] initWithData:imageData];
			return;
		}
	}

	[super unserialize:obj];
}

- (void)zerolize
{
	[self stopLoading];

	[super zerolize];
}

#pragma mark -

- (void)stopLoading
{
	[self sd_cancelCurrentImageLoad];
}

- (void)loadURL:(NSString *)url
{
	@weakify( self );

	[self.indicator startAnimating];
	
	[self sd_setImageWithURL:[NSURL URLWithString:url]
			placeholderImage:nil
					 options:SDWebImageCacheMemoryOnly|SDWebImageRefreshCached
					progress:^(NSInteger receivedSize, NSInteger expectedSize) {
						
//						@strongify( self );
						
					} completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        @strongify( self );
						[self.indicator stopAnimating];

//						if ( image )
//						{
//							[self.renderer.root relayout];
//						}
					}];

	self.loadedURL = url;
}

@end
