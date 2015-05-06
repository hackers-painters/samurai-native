//
//  main.m
//  catalog
//
//  Created by god on 15/4/30.
//  Copyright (c) 2015年 Geek-Zoo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Samurai.h"

int main(int argc, char * argv[]) {
	@autoreleasepool {
		
		[[SamuraiWatcher sharedInstance] watch:@(__FILE__)];

	    return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
	}
}
