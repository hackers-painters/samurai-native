//
//  main.m
//  movie
//
//  Created by QFish on 4/9/15.
//  Copyright (c) 2015 Geek Zoo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#import "Samurai.h"
#import "Samurai_WebCore.h"

int main(int argc, char * argv[])
{
    @autoreleasepool
	{
		[[SamuraiWatcher sharedInstance] watch:@(__FILE__)];
		
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
