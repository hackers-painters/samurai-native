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
	if ( 0 == [_t1.text length] )
	{
		[_t1 performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.25f];
		[_t1 addCssStyleClass:@"error"];
		[_t1 restyle];
		
		return;
	}
	else
	{
		[_t1 removeCssStyleClass:@"error"];
		[_t1 restyle];
	}
	
	if ( 0 == [_t2.text length] )
	{
		[_t2 performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.25f];
		[_t2 addCssStyleClass:@"error"];
		[_t2 restyle];
		
		return;
	}
	else
	{
		[_t2 removeCssStyleClass:@"error"];
		[_t2 restyle];
	}

	if ( 0 == [_t3.text length] )
	{
		[_t3 performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.25f];
		[_t3 addCssStyleClass:@"error"];
		[_t3 restyle];
		
		return;
	}
	else
	{
		[_t3 removeCssStyleClass:@"error"];
		[_t3 restyle];
	}

	if ( 0 == [_t4.text length] || NO == [_t3.text isEqualToString:_t4.text] )
	{
		[_t4 performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.25f];
		[_t4 addCssStyleClass:@"error"];
		[_t4 restyle];
		
		return;
	}
	else
	{
		[_t4 removeCssStyleClass:@"error"];
		[_t4 restyle];
	}

	[[[UIAlertView alloc] initWithTitle:@"Welcome"
								message:nil
							   delegate:nil
					  cancelButtonTitle:@"OK"
					  otherButtonTitles:nil] show];
}

#pragma mark -

handleSignal( t4, eventReturn )
{
	[self submitForm];
}

handleSignal( submit )
{
	[self submitForm];
}

@end
