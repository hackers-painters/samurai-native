//
//  ViewController.m
//  test
//
//  Created by god on 15/4/29.
//  Copyright (c) 2015年 Geek-Zoo Studio. All rights reserved.
//

#import "TestCaseViewController.h"
#import "TestSafariViewController.h"

#import "Samurai.h"
#import "Samurai_WebCore.h"

@implementation TestCaseViewController

@synthesize testCase;

- (void)dealloc
{
	[self unloadTemplate];
}

- (void)setView:(UIView *)newView
{
	[super setView:newView];
	
	if ( IOS7_OR_LATER )
	{
		self.edgesForExtendedLayout = UIRectEdgeNone;
		self.extendedLayoutIncludesOpaqueBars = NO;
		self.modalPresentationCapturesStatusBarAppearance = NO;
		self.automaticallyAdjustsScrollViewInsets = YES;
	}
	
	self.view.userInteractionEnabled = YES;
	self.view.backgroundColor = [UIColor whiteColor];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	[self loadTemplate:self.testCase];
	
	self.navigationBarTitle = [self.testCase lastPathComponent];
	self.navigationBarDoneButton = @"Compare";

	self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
	
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews
{
	[self relayout];
}

- (void)onDonePressed
{
	TestSafariViewController * viewController = [[TestSafariViewController alloc] init];
	viewController.html = [NSString stringWithContentsOfFile:self.testCase encoding:NSUTF8StringEncoding error:NULL];
	[self.navigationController pushViewController:viewController animated:YES];
}

@end
