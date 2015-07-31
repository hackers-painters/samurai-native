//
//  ViewController.m
//  test
//
//  Created by god on 15/4/29.
//  Copyright (c) 2015年 Geek-Zoo Studio. All rights reserved.
//

#import "TestSuiteViewController.h"
#import "TestCaseViewController.h"

#import "Samurai.h"
#import "Samurai_WebCore.h"

@implementation TestSuiteViewController
{
	UITableView *		_tableView;
	NSMutableArray *	_files;
}

@synthesize testSuite;

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

	_files = [[NSMutableArray alloc] init];
	
	NSString * basePath = [[NSBundle mainBundle] pathForResource:@"/www/html/testcases" ofType:nil inDirectory:nil];

	if ( nil == self.testSuite )
	{
		self.testSuite = basePath;
	}

	NSArray * contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.testSuite error:NULL];
	
	for ( NSString * subPath in contents )
	{
		NSString * fullPath = [[self.testSuite stringByAppendingPathComponent:subPath] stringByStandardizingPath];
		if ( nil == fullPath )
			continue;

		BOOL isDir = NO;
		BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir];
		if ( exists )
		{
			if ( isDir )
			{
				[_files addObject:fullPath];
			}
			else if ( [fullPath hasSuffix:@".html"] || [fullPath hasSuffix:@".htm"] )
			{
				[_files addObject:fullPath];
			}
		}
	}
	
	[_files sortUsingSelector:@selector(compare:)];

	[self loadTemplate:@"/www/html/test-suite.html"];
//	[self loadTemplate:@"http://www.36kr.com"];

	self.navigationBarTitle = self.testSuite;
	self.navigationBarTitle = [self.testSuite lastPathComponent];
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

#pragma mark -

- (void)onTemplateLoading
{
	
}

- (void)onTemplateLoaded
{
	[self setViewData:@{
					  
		@"items" : ({
			
			NSMutableArray * array = [NSMutableArray array];

			for ( NSString * path in _files )
			{
				BOOL isDir = NO;
				
				[[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
				
				if ( isDir )
				{
					[array addObject:@{ @"title" : [NSString stringWithFormat:@"%@ >", [path lastPathComponent]] }];
				}
				else
				{
					[array addObject:@{ @"title" : [path lastPathComponent] }];
				}
			}

			array;
		})
		
	} withPath:@"list"];
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
	BOOL isDir = NO;
	
	NSString * path = [_files objectAtIndex:signal.sourceIndexPath.row];
	
	[[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];

	if ( isDir )
	{
		TestSuiteViewController * viewController = [[TestSuiteViewController alloc] init];
		viewController.testSuite = path;
		[self.navigationController pushViewController:viewController animated:YES];
	}
	else
	{
		TestCaseViewController * viewController = [[TestCaseViewController alloc] init];
		viewController.testCase = path;
		[self.navigationController pushViewController:viewController animated:YES];
	}
}

@end
