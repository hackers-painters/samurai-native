//
//  Test_UIImageView.h
//  catalog
//
//  Created by god on 15/4/30.
//  Copyright (c) 2015年 Geek-Zoo Studio. All rights reserved.
//

#import "Test_UIScrollView.h"

@implementation Test_UIScrollView

- (void)dealloc
{
	[self unloadTemplate];
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	[self loadTemplate:@"/www/html/Test_UIScrollView.html"];
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

- (void)banner:(SamuraiSignal *)signal
{
	[[[UIAlertView alloc] initWithTitle:@"Banner was clicked"
								message:nil
							   delegate:nil
					  cancelButtonTitle:@"OK"
					  otherButtonTitles:nil] show];
}

- (void)button:(SamuraiSignal *)signal
{
	[[[UIAlertView alloc] initWithTitle:@"Button was clicked"
								message:nil
							   delegate:nil
					  cancelButtonTitle:@"OK"
					  otherButtonTitles:nil] show];
}

@end
