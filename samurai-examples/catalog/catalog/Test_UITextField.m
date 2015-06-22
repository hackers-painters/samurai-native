//
//  ViewController.m
//  catalog
//
//  Created by god on 15/4/30.
//  Copyright (c) 2015年 Geek-Zoo Studio. All rights reserved.
//

#import "Test_UITextField.h"

@implementation Test_UITextField
{
	UITextField *	_t1;
	UITextField *	_t2;
	UITextField *	_t3;
	UITextField *	_t4;
}

- (void)dealloc
{
	[self unloadViewTemplate];
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	[self loadViewTemplate:@"/www/html/Test_UITextField.html"];
}

- (void)viewDidAppear:(BOOL)animated
{
	[_t1 becomeFirstResponder];
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

- (void)submitForm
{
	BOOL valid = YES;
	
	if ( 0 == [_t1.text length] )
	{
		[_t1 style_addClass:@"error"];
		
		valid = NO;
	}
	else
	{
		[_t1 style_removeClass:@"error"];
	}
	
	if ( 0 == [_t2.text length] )
	{
		[_t2 style_addClass:@"error"];
		
		valid = NO;
	}
	else
	{
		[_t2 style_removeClass:@"error"];
	}

	if ( 0 == [_t3.text length] )
	{
		[_t3 style_addClass:@"error"];
		
		valid = NO;
	}
	else
	{
		[_t3 style_removeClass:@"error"];
	}

	if ( 0 == [_t4.text length] || NO == [_t3.text isEqualToString:_t4.text] )
	{
		[_t4 style_addClass:@"error"];
		
		valid = NO;
	}
	else
	{
		[_t4 style_removeClass:@"error"];
	}

	[_t1 restyle];
	[_t2 restyle];
	[_t3 restyle];
	[_t4 restyle];

	if ( NO == valid )
	{
		[[[UIAlertView alloc] initWithTitle:@"Invalid content"
									message:nil
								   delegate:nil
						  cancelButtonTitle:@"OK"
						  otherButtonTitles:nil] show];
	}
	else
	{
		[[[UIAlertView alloc] initWithTitle:@"Thank you"
									message:nil
								   delegate:nil
						  cancelButtonTitle:@"OK"
						  otherButtonTitles:nil] show];
	}
}

#pragma mark -

- (void)submit:(SamuraiSignal *)signal
{
	[self submitForm];
}

@end
