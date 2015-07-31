//
//  Test_UIActivityIndicatorView.h
//  catalog
//
//  Created by god on 15/4/30.
//  Copyright (c) 2015年 Geek-Zoo Studio. All rights reserved.
//

#import "Test_UIButton.h"

@implementation Test_UIButton

- (void)dealloc
{
	[self unloadTemplate];
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	[self loadTemplate:@"/www/html/Test_UIButton.html"];
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
}

- (void)onTemplateFailed
{
	
}

- (void)onTemplateCancelled
{
	
}

#pragma mark -

- (void)test1:(SamuraiSignal *)signal
{
	[[[UIAlertView alloc] initWithTitle:@"Button 1 was clicked"
								message:nil
							   delegate:nil
					  cancelButtonTitle:@"OK"
					  otherButtonTitles:nil] show];
}

- (void)test2:(SamuraiSignal *)signal
{
	[[[UIAlertView alloc] initWithTitle:@"Button 2 was clicked"
								message:nil
							   delegate:nil
					  cancelButtonTitle:@"OK"
					  otherButtonTitles:nil] show];
}

- (void)test3:(SamuraiSignal *)signal
{
	[[[UIAlertView alloc] initWithTitle:@"Button 3 was clicked"
								message:nil
							   delegate:nil
					  cancelButtonTitle:@"OK"
					  otherButtonTitles:nil] show];
}

@end
