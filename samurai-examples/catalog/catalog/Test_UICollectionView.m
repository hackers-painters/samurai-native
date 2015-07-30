//
//  Test_UICollectionView.h
//  catalog
//
//  Created by god on 15/4/30.
//  Copyright (c) 2015年 Geek-Zoo Studio. All rights reserved.
//

#import "Test_UICollectionView.h"

@implementation Test_UICollectionView

- (void)dealloc
{
	[self unloadTemplate];
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	[self loadTemplate:@"/www/html/Test_UICollectionView.html"];
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
	self.scope[@"sections"] = @{
	
		@"section2" : @[ @"1", @"2", @"3", @"4", @"5", @"6" ],
		@"section4" : @[ @"1", @"2", @"3", @"4", @"5", @"6" ],
		@"section5" : @[ @"1" ],
		@"section6" : @[ @"1", @"2", @"3", @"4", @"5", @"6", @"1", @"2", @"3", @"4", @"5", @"6", @"1", @"2", @"3", @"4", @"5", @"6" ]
		
	};
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
	UICollectionViewCell *	cell = signal.sourceCollectionCell;
	NSIndexPath *			index = signal.sourceIndexPath;

	UNUSED( cell );
	
	[[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Section(%lu) / Row(%lu) was clicked", index.section, index.row]
								message:nil
							   delegate:nil
					  cancelButtonTitle:@"OK"
					  otherButtonTitles:nil] show];
}

@end
