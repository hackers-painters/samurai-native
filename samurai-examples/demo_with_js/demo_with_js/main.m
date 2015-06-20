//
//  main.m
//  demo_with_js
//
//  Created by god on 15/6/3.
//  Copyright (c) 2015年 Geek-Zoo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "JPEngine.h"

int main(int argc, char * argv[]) {
	@autoreleasepool {
				
		[JPEngine startEngine];
		
		NSString * sourcePath = [[NSBundle mainBundle] pathForResource:@"AppDelegate" ofType:@"js"];
		NSString * script = [NSString stringWithContentsOfFile:sourcePath encoding:NSUTF8StringEncoding error:nil];
		
		[JPEngine evaluateScript:script];

	    return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
	}
}
