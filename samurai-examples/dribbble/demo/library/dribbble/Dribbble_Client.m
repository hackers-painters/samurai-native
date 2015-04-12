//
//  DribbbleClient.m
//  demo
//
//  Created by QFish on 4/7/15.
//  Copyright (c) 2015 Geek-Zoo Studio. All rights reserved.
//

#import "Dribbble_Client.h"
#import "STIHTTPNetwork.h"
#import "NSDate+Extension.h"

static NSString * const DribbbleAuthURLString = @"https://dribbble.com/oauth/";
static NSString * const DribbbleAPIBaseURLString = @"https://api.dribbble.com/v1/";
static NSString * const DribbbleAuthorizationToken = @"5354c746b236110c767ef7e3c0cc6b76069fa27e5eb1df982636d90a3d057358";

#pragma mark - API

@implementation DribbbleClient

+ (void)load
{
    [STIHTTPApi setGlobalHTTPSessionManager:[self sharedClient]];
}

+ (instancetype)authClient {
    static DribbbleClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[DribbbleClient alloc] initWithBaseURL:[NSURL URLWithString:DribbbleAuthURLString]];
    });
    return _sharedClient;
}

+ (instancetype)sharedClient {
    static DribbbleClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[DribbbleClient alloc] initWithBaseURL:[NSURL URLWithString:DribbbleAPIBaseURLString]];
        [_sharedClient.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", DribbbleAuthorizationToken] forHTTPHeaderField:@"Authorization"];
    });
    return _sharedClient;
}

- (id)processedDataWithResponseObject:(id)responseObject task:(NSURLSessionDataTask *)task
{
    NSHTTPURLResponse * resp = ( NSHTTPURLResponse *)task.response;
    
    NSLog(@"%@", resp.allHeaderFields);
    
    if ( responseObject )
    {
        if ( [responseObject isKindOfClass:[NSDictionary class]] )
        {
            if ( !responseObject[@"message"] && !responseObject[@"error"] )
            {
                return @{@"data": responseObject};
            }
        }
        
        if ( [responseObject isKindOfClass:[NSArray class]] )
        {
            return @{@"data": responseObject};
        }
    }
    
    return responseObject;
}

@end

#pragma mark -

NSDate * CreateDateFromString(NSString * string)
{
    if ( !string )
        return nil;
    
    NSDateFormatter * fomatter = [[NSDateFormatter alloc] init];
    fomatter.dateFormat = @"YYYY-MM-DDTHH:MM:SSZ";
    NSDate * date = [fomatter dateFromString:string];
    return date;
}

@implementation NSObject (APIExtension)

+ (id)processedValueForKey:(NSString *)key
               originValue:(id)originValue
            convertedValue:(id)convertedValue
                     class:(__unsafe_unretained Class)clazz
                  subClass:(__unsafe_unretained Class)subClazz
{
    if ( [clazz isEqual:NSDate.class] )
    {
        if ( [originValue isKindOfClass:clazz] ) {
            return originValue;
        } else {
            return CreateDateFromString(convertedValue);
        }
    }
    
    if ( [clazz isEqual:NSNumber.class] )
    {
        if (  [originValue isKindOfClass:NSString.class] )
        {
            return @([originValue floatValue]);
        }
    }
    
    return convertedValue;
}

@end
