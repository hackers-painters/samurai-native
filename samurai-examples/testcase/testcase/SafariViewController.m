//
//  ViewController.m
//  test
//
//  Created by god on 15/4/29.
//  Copyright (c) 2015年 Geek-Zoo Studio. All rights reserved.
//

#import "SafariViewController.h"

@implementation SafariViewController
{
	UIWebView * _webview;
}

@synthesize testCase;

- (void)dealloc
{
	[self unloadViewTemplate];
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	[self loadViewTemplate:@"/www/html/safari.html"];

	[_webview loadHTMLString:[NSString stringWithContentsOfFile:self.testCase encoding:NSUTF8StringEncoding error:NULL] baseURL:nil];
}

- (void)didReceiveMemoryWarning {
	
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
