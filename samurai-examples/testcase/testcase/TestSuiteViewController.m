//
//  ViewController.m
//  test
//
//  Created by god on 15/4/29.
//  Copyright (c) 2015年 Geek-Zoo Studio. All rights reserved.
//

#import "TestSuiteViewController.h"
#import "TestCaseViewController.h"

@implementation TestSuiteViewController
{
	UITableView *		_tableView;
	NSMutableArray *	_files;
}

- (void)dealloc
{
	[self unloadViewTemplate];
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	NSString * basePath = [[NSBundle mainBundle] pathForResource:@"/www/html/testcases" ofType:nil inDirectory:nil];
	NSDirectoryEnumerator * dir = [[NSFileManager defaultManager] enumeratorAtPath:basePath];
	
	_files = [NSMutableArray array];
	
	for ( ;; )
	{
		NSString * subPath = [dir nextObject];
		if ( nil == subPath )
			break;
		
		NSString * fullPath = [[basePath stringByAppendingPathComponent:subPath] stringByStandardizingPath];
		if ( nil == fullPath )
			continue;
		
		BOOL isDir = NO;
		BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir];
		if ( exists )
		{
			if ( NO == isDir && ([fullPath hasSuffix:@".html"] || [fullPath hasSuffix:@".html"]) )
			{
				[_files addObject:fullPath];
			}
		}
	}

	[self loadViewTemplate:@"/www/html/test-suite.html"];
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
	self[@"list"] = @{
					  
		@"items" : ({
			
			NSMutableArray * array = [NSMutableArray array];

			for ( NSString * path in _files )
			{
				[array addObject:@{ @"title" : [path lastPathComponent] }];
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

handleSignal( test )
{
	TestCaseViewController * viewController = [[TestCaseViewController alloc] init];
	viewController.testCase = [_files objectAtIndex:signal.sourceIndexPath.row];
	[self.navigationController pushViewController:viewController animated:YES];
}

@end
