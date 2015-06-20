//
//  ViewController.m
//  demo_with_js
//
//  Created by god on 15/6/3.
//  Copyright (c) 2015年 Geek-Zoo Studio. All rights reserved.
//

#import "ViewController.h"

#import "Samurai.h"
#import "RefreshCollectionView.h"

@interface ViewController ()
{
	RefreshCollectionView *	_list;
}
@end

#pragma mark -

@implementation ViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if ( self )
	{
	}
	return self;
}

- (void)dealloc
{
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self loadViewTemplate:@"/www/html/index.html"];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

#pragma mark -

- (void)onTemplateLoading
{
}

- (void)onTemplateLoaded
{
	[self reloadData];
}

- (void)onTemplateFailed
{
	
}

- (void)onTemplateCancelled
{
	
}

#pragma mark -

- (void)reloadData
{
	NSMutableArray * shots = [NSMutableArray array];
	
	for ( NSUInteger i = 0; i < 10; ++i )
	{
		[shots addObject:@{
						   
			@"attr" : @{
				@"comments" : @(28),
				@"likes" : @(339),
				@"views" : @(2433)
			},
		 
			@"author" : @{
				@"avatar" : @"https://d13yacurqjgara.cloudfront.net/users/285475/avatars/normal/7ab1fc9d69e079e2dc11095fd74908cf.png?1432660315",
				@"name" : @"Markus Magnusson",
				@"title" : @"Road Trippin(archive & delete)"
			},
			
			@"shot-url" : @"https://d13yacurqjgara.cloudfront.net/users/285475/screenshots/2091336/road_trip_dribbble_1x.gif"
		}];
	}
	
	[self setViewData:@{ @"shots" : shots } withPath:@"list"];
}

@end
