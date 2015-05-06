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
	[self unloadViewTemplate];
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	[self loadViewTemplate:@"/www/html/Test_UIButton.html"];
	
	self.onSignal( makeSignal(test1), ^{
		
		[[[UIAlertView alloc] initWithTitle:@"Button 1 was clicked"
									message:nil
								   delegate:nil
						  cancelButtonTitle:@"OK"
						  otherButtonTitles:nil] show];
	});

	self.onSignal( makeSignal(test3), ^{

		[[[UIAlertView alloc] initWithTitle:@"Button 3 was clicked"
									message:nil
								   delegate:nil
						  cancelButtonTitle:@"OK"
						  otherButtonTitles:nil] show];
	});
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

handleSignal( test2 )
{
	[[[UIAlertView alloc] initWithTitle:@"Button 2 was clicked"
								message:nil
							   delegate:nil
					  cancelButtonTitle:@"OK"
					  otherButtonTitles:nil] show];
}

handleSignal( test4 )
{
	[[[UIAlertView alloc] initWithTitle:@"Button 4 was clicked"
								message:nil
							   delegate:nil
					  cancelButtonTitle:@"OK"
					  otherButtonTitles:nil] show];
}

@end
