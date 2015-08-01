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
#import "STIHTTPSessionManager.h"

@class STIHTTPResponseError;

#pragma mark -

@interface STIHTTPBaseObject : NSObject
@property (nonatomic, assign, readonly) BOOL isValidated;
@end

#pragma mark -

@interface STIHTTPRequest : STIHTTPBaseObject

/**
 *  Transform properies to a dcitionary that can be parameter for a request.
 *
 *  @return a dictionary composed of properties
 */
@property (nonatomic, strong, readonly) NSDictionary * parameters;

/**
 *  Transform origin endpoint to parametered uri with known properies.
 *
 *  For example:
 *
 *  Endpoint: /users/:username/repos
 *  Result: /users/qfish/repos
 *
 *  @return the parametered uri
 */
@property (nonatomic, strong, readonly) NSString * endpoint;
@property (nonatomic, assign, readonly) STIHTTPRequestMethod method;
@property (nonatomic, assign) Class responseClass;

- (instancetype)initWithEndpoint:(NSString *)endpoint method:(STIHTTPRequestMethod)method;
+ (instancetype)requestWithEndpoint:(NSString *)endpoint method:(STIHTTPRequestMethod)method;

@end

#pragma mark -

@protocol STIHTTPResponse <NSObject>
@optional
@property (nonatomic, assign, readonly) BOOL isValidated;
@end

@interface STIHTTPResponse : STIHTTPBaseObject<STIHTTPResponse>
@end

@interface STIHTTPResponseError : NSObject
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) NSString * message;
@end

#pragma mark -

@class STIHTTPSessionManager;

@interface STIHTTPApi : STIHTTPBaseObject<STIHTTPResponseDataProcessor>

@property (nonatomic, weak) STIHTTPSessionManager * HTTPSessionManager;
@property (nonatomic, strong) STIHTTPRequest * req;
@property (nonatomic, strong) id<STIHTTPResponse> resp;
@property (nonatomic, strong) id responseObject;
@property (nonatomic, weak) NSURLSessionDataTask * task;
@property (nonatomic, copy) STIHTTPApiBlock whenUpdated;
@property (nonatomic, copy) STIHTTPApiBlock whenFailed;
@property (nonatomic, copy) void (^ whenCanceled)(void);

/**
 * Api will not be auto cancelled, that means `[STIHTTPApi cacenl]` will not 
 * cancel it if set YES.
 */
@property (nonatomic, assign) BOOL manuallyCancel;

- (void)send;
- (void)cancel;

/**
 * This operation will cancel all the apis kind of this class.
 */
+ (void)cancel;
+ (void)setGlobalHTTPSessionManager:(STIHTTPSessionManager *)HTTPSessionManager;

@end
