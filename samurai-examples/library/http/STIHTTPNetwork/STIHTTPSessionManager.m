//
//  STIHTTPSessionManager.m
//  AFNetworking iOS Example
//
//  Created by QFish on 10/7/14.
//  Copyright (c) 2014 QFish. All rights reserved.
//

#import "STIHTTPSessionManager.h"
#import "STIHTTPNetwork.h"

NSString * STIHTTPRequestMethodString(STIHTTPRequestMethod method)
{
    NSString * methodString = nil;
    switch ( method ) {
        case STIHTTPRequestMethodGet:
            methodString = @"GET";
            break;
        case STIHTTPRequestMethodHead:
            methodString = @"HEAD";
            break;
        case STIHTTPRequestMethodPost:
            methodString = @"POST";
            break;
        case STIHTTPRequestMethodPut:
            methodString = @"PUT";
            break;
        case STIHTTPRequestMethodPatch:
            methodString = @"PATCH";
            break;
        case STIHTTPRequestMethodDelete:
            methodString = @"DELETE";
            break;
    }
    return methodString;
}

@implementation STIHTTPSessionManager

- (id)processedDataWithResponseObject:(id)responseObject task:(NSURLSessionDataTask *)task
{
    return responseObject;
}

- (void)handleError:(NSError *)error responseObject:(id)responseObject task:(NSURLSessionDataTask *)task failureBlock:(STIHTTPApiBlock)failureBlock
{
    if ( failureBlock ) {
        failureBlock(nil, error);
    }
}

- (NSURLSessionDataTask *)methodString:(NSString *)methodString
                        endpoint:(NSString *)endpoint
                      parameters:(id)parameters
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error))failure
{
    NSURLSessionDataTask *dataTask = [self dataTaskWithHTTPMethod:methodString URLString:endpoint parameters:parameters success:success failure:failure];
    
    [dataTask resume];
    
    return dataTask;
}

- (NSURLSessionDataTask *)method:(STIHTTPRequestMethod)method
                        endpoint:(NSString *)endpoint
                      parameters:(id)parameters
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error))failure
{
    return [self methodString:STIHTTPRequestMethodString(method) endpoint:endpoint parameters:parameters success:success failure:failure];
}

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, id, NSError *))failure
{
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            if (failure) {
                failure(dataTask, responseObject, error);
            }
        } else {
            if (success) {
                success(dataTask, responseObject);
            }
        }
    }];
    
    return dataTask;
}

@end
