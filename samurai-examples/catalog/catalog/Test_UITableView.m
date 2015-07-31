//
//  ViewController.m
//  catalog
//
//  Created by god on 15/4/30.
//  Copyright (c) 2015年 Geek-Zoo Studio. All rights reserved.
//

#import "Test_UITableView.h"

@implementation Test_UITableView

- (void)dealloc
{
	[self unloadTemplate];
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	[self loadTemplate:@"/www/html/Test_UITableView.html"];
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
	self.scope[@"list"] = @{
					  
	  @"section1" : ({
		  
		  NSMutableArray * array = [NSMutableArray array];
		  
		  for ( int i = 0; i < 10; ++i )
		  {
			  [array addObject:@{ @"title" : [NSString stringWithFormat:@"Section 0, Row %d", i] }];
		  }
		  
		  array;	// return
	  }),

	  @"section2" : ({
		  
		  NSMutableArray * array = [NSMutableArray array];
		  
		  for ( int i = 0; i < 10; ++i )
		  {
			  [array addObject:@{ @"title" : [NSString stringWithFormat:@"Section 1, Row %d", i] }];
		  }

		  array;	// return
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
	UITableViewCell *	cell = signal.sourceTableCell;
	NSIndexPath *		index = signal.sourceIndexPath;
	
	UNUSED( cell );
	
	[[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Section(%lu) / Row(%lu) was clicked", index.section, index.row]
								message:nil
							   delegate:nil
					  cancelButtonTitle:@"OK"
					  otherButtonTitles:nil] show];
}

@end
