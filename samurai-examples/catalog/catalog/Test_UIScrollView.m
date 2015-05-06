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
	[self unloadViewTemplate];
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	[self loadViewTemplate:@"/www/html/Test_UIScrollView.html"];
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

handleSignal( UIScrollView, eventDidScroll )
{
	
}

handleSignal( UIScrollView, eventDidZoom )
{
	
}

handleSignal( UIScrollView, eventWillBeginDragging )
{
	
}

handleSignal( UIScrollView, eventWillEndDragging )
{
	
}

handleSignal( UIScrollView, eventDidEndDragging )
{
	
}

handleSignal( UIScrollView, eventWillBeginDecelerating )
{
	
}

handleSignal( UIScrollView, eventDidEndDecelerating )
{
	
}

handleSignal( UIScrollView, eventDidEndScrolling )
{
	
}

handleSignal( UIScrollView, eventWillBeginZooming )
{
	
}

handleSignal( UIScrollView, eventDidEndZooming )
{
	
}

handleSignal( UIScrollView, eventDidScrollToTop )
{
	
}

@end
