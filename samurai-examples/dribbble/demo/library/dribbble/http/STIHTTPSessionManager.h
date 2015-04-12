//
//  STIHTTPSessionManager.h
//  AFNetworking iOS Example
//
//  Created by QFish on 10/7/14.
//  Copyright (c) 2014 QFish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^STIHTTPApiBlock)(id data, id error);

typedef NS_ENUM(NSUInteger, STIHTTPRequestMethod) {
    STIHTTPRequestMethodGet,
    STIHTTPRequestMethodHead,
    STIHTTPRequestMethodPost,
    STIHTTPRequestMethodPut,
    STIHTTPRequestMethodPatch,
    STIHTTPRequestMethodDelete,
};

FOUNDATION_EXPORT NSString * STIHTTPRequestMethodString(STIHTTPRequestMethod);

@class STIHTTPResponseError;

@protocol STIHTTPResponseDataProcessor <NSObject>

/**
 *  处理响应回来的数据
 *
 *  @param responseObject 请求响应返回的数据，已经过 ResponseSerializer 处理
 *  @param task           请求的任务，在这里可以拿到响应的Header信息等
 *
 *  @return 返回处理过的 responseObject
 */
- (id)processedDataWithResponseObject:(id)responseObject task:(NSURLSessionDataTask *)task;

/**
 *  处理请求错误
 *
 *  @param error 错误信息
 */
- (void)handleError:(NSError *)error responseObject:(id)responseObject task:(NSURLSessionDataTask *)task failureBlock:(void (^)(id data, id error))failureBlock;

@end

@interface STIHTTPSessionManager : AFHTTPSessionManager<STIHTTPResponseDataProcessor>

/**
 *  每次请求都会回调这个 block，用于配置公共参数，Header信息等
 */
@property (nonatomic, copy) void (^setup)(id vars, ...);

/**
 *  处理请求数据
 *
 *  @param method     请求方式，一般默认super
 *  @param endpoint   endpoint，一般默认super
 *  @param parameters 请求参数，可以重写这个函数统一处理
 *  @param success    成功回调，一般默认super
 *  @param failure    失败毁掉，一般默认super
 *
 *  @return 默认返回super
 */
- (NSURLSessionDataTask *)method:(STIHTTPRequestMethod)method
                        endpoint:(NSString *)endpoint
                      parameters:(id)parameters
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error))failure;

@end
