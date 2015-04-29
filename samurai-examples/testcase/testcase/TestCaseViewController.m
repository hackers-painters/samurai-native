//
//  ViewController.m
//  test
//
//  Created by god on 15/4/29.
//  Copyright (c) 2015年 Geek-Zoo Studio. All rights reserved.
//

#import "TestCaseViewController.h"
#import "SafariViewController.h"

@implementation TestCaseViewController

@synthesize testCase;

- (void)dealloc
{
	[self unloadViewTemplate];
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	self.navigationBarDoneButton = @"Compare";

	[self loadViewTemplate:self.testCase];
	
	self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
	
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)onDonePressed
{
	SafariViewController * viewController = [[SafariViewController alloc] init];
	viewController.testCase = self.testCase;
	[self.navigationController pushViewController:viewController animated:YES];
}

@end
