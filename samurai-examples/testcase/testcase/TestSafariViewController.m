//
//  ViewController.m
//  test
//
//  Created by god on 15/4/29.
//  Copyright (c) 2015年 Geek-Zoo Studio. All rights reserved.
//

#import "TestSafariViewController.h"

#import "Samurai.h"
#import "Samurai_WebCore.h"

@implementation TestSafariViewController
{
	UIWebView * _webView;
}

@synthesize html;

- (void)dealloc
{
	[self unloadTemplate];
	
	[_webView removeFromSuperview];
	_webView = nil;
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
	
	[self loadTemplate:@"/www/html/test-safari.html"];
	
	[_webView loadHTMLString:self.html baseURL:nil];
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

@end
