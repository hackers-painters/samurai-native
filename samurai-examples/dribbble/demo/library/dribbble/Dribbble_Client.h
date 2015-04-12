//
//  DribbbleClient.h
//  demo
//
//  Created by QFish on 4/7/15.
//  Copyright (c) 2015 Geek-Zoo Studio. All rights reserved.
//

#import "STIHTTPSessionManager.h"
#import "NSObject+AutoCoding.h"

@interface DribbbleClient : STIHTTPSessionManager
+ (instancetype)authClient;
+ (instancetype)sharedClient;
@end

@interface NSObject (APIExtension) <AutoModelCoding>
@end