//
//  ViewController.m
//  test
//
//  Created by god on 15/4/29.
//  Copyright (c) 2015年 Geek-Zoo Studio. All rights reserved.
//

#import "TestCaseViewController.h"

@implementation TestCaseViewController
{
	UIWebView * _webView;
}

@synthesize testCase;

- (void)dealloc
{
	[self unloadViewTemplate];
	
	[_webView removeFromSuperview];
	_webView = nil;
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	[self loadViewTemplate:self.testCase];
	
	self.navigationBarTitle = [self.testCase lastPathComponent];
	self.navigationBarDoneButton = @"Compare";

	self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
	
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
	CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
	CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
	
	CGRect webFrame;
	webFrame.origin.x = 0.0f;
	webFrame.origin.y = statusBarHeight + navigationBarHeight;
	webFrame.size.width = self.view.frame.size.width;
	webFrame.size.height = self.view.frame.size.height - (statusBarHeight + navigationBarHeight);
	
	_webView.frame = webFrame;
}

- (void)onDonePressed
{
	if ( nil == _webView )
	{
		_webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
		_webView.alpha = 0.95f;
		_webView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1f];
		
		[self.view addSubview:_webView];
		[self viewDidLayoutSubviews];
		
		[_webView loadHTMLString:[NSString stringWithContentsOfFile:self.testCase encoding:NSUTF8StringEncoding error:NULL] baseURL:nil];
	}
	else
	{
		[_webView removeFromSuperview];
		_webView = nil;
	}
}

@end
