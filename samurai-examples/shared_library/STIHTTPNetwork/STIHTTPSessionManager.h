//
//     ____    _                        __     _      _____
//    / ___\  /_\     /\/\    /\ /\    /__\   /_\     \_   \
//    \ \    //_\\   /    \  / / \ \  / \//  //_\\     / /\/
//  /\_\ \  /  _  \ / /\/\ \ \ \_/ / / _  \ /  _  \ /\/ /_
//  \____/  \_/ \_/ \/    \/  \___/  \/ \_/ \_/ \_/ \____/
//
//	Copyright Samurai development team and other contributors
//
//	http://www.samurai-framework.com
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
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
