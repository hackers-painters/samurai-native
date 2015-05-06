//
//  MoviesClient.m
//  demo
//
//  Created by QFish on 4/7/15.
//  Copyright (c) 2015 Geek-Zoo Studio. All rights reserved.
//

#import "MoviesClient.h"
#import "STIHTTPNetwork.h"
#import "NSDate+Extension.h"

static NSString * const kMoviesAPIURL = @"http://api.rottentomatoes.com/api/public/v1.0/";
static NSString * const kMoviesApiKey = @"7waqfqbprs7pajbz28mqf6vz";

#pragma mark - API

@implementation MoviesClient

+ (void)load
{
    [STIHTTPApi setGlobalHTTPSessionManager:[self sharedClient]];
}

+ (instancetype)sharedClient {
    static MoviesClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[MoviesClient alloc] initWithBaseURL:[NSURL URLWithString:kMoviesAPIURL]];
    });
    return _sharedClient;
}

- (id)processedDataWithResponseObject:(id)responseObject task:(NSURLSessionDataTask *)task
{
    // dump responseObject here
    return responseObject;
}

- (NSURLSessionDataTask *)method:(STIHTTPRequestMethod)method
                        endpoint:(NSString *)endpoint
                      parameters:(id)parameters
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error))failure
{
    NSDictionary * params = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [params setValue:kMoviesApiKey forKey:@"apikey"];

    return [super method:method
                endpoint:endpoint
              parameters:params
                 success:success
                 failure:failure];
}

@end

#pragma mark -

@implementation NSObject (APIExtension)

+ (id)processedValueForKey:(NSString *)key
               originValue:(id)originValue
            convertedValue:(id)convertedValue
                     class:(__unsafe_unretained Class)clazz
                  subClass:(__unsafe_unretained Class)subClazz
{
    if ( [clazz isEqual:NSString.class] )
    {
        if (  [originValue isKindOfClass:NSNumber.class] )
        {
            return ((NSNumber *)originValue).stringValue;
        }
    }
    
    return convertedValue;
}

@end

#pragma mark -

@implementation GET_A_MOVIE_API (APIExtension)

- (id)processedDataWithResponseObject:(id)responseObject task:(NSURLSessionDataTask *)task
{
    return nil == responseObject ? nil : @{@"movie": responseObject};
}

@end
