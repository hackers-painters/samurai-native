//
//  ViewController.m
//  catalog
//
//  Created by god on 15/4/30.
//  Copyright (c) 2015年 Geek-Zoo Studio. All rights reserved.
//

#import "CatalogViewController.h"

@implementation CatalogViewController
{
	UITableView *	_tableView;
	NSArray *		_controls;
}

- (void)dealloc
{
	[self unloadViewTemplate];
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	_controls = @[
		@"UIActivityIndicatorView",
		@"UIButton",
		@"UICollectionView",
		@"UIImageView",
		@"UILabel",
		@"UIPageControl",
		@"UIProgressView",
		@"UIScrollView",
		@"UISlider",
		@"UISwitch",
		@"UITableView",
		@"UITextField",
		@"UITextView"
	];

	[self loadViewTemplate:@"/www/html/catalog.html"];
}

- (void)didReceiveMemoryWarning {
	
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)onTemplateLoading
{
	
}

- (void)onTemplateLoaded
{
	self.viewStorage[@"list"] = @{
					  
		@"items" : ({

			NSMutableArray * array = [NSMutableArray array];

			for ( NSString * title in _controls )
			{
				[array addObject:@{ @"title" : title }];
			}

			array;
		})
	};
}

- (void)onTemplateFailed
{
	
}

- (void)onTemplateCancelled
{
	
}

#pragma mark -

- (void)test:(SamuraiSignal *)signal
{
	NSString * controlName = [_controls objectAtIndex:signal.sourceIndexPath.row];
	NSString * controllerName = [NSString stringWithFormat:@"Test_%@", controlName];

	UIViewController * controller = [[NSClassFromString(controllerName) alloc] init];
	if ( controller )
	{
		[self.navigationController pushViewController:controller animated:YES];
	}
}

@end
