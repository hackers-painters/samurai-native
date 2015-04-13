//
//  STIHTTPNetwork.h
//  AFNetworking iOS Example
//
//  Created by QFish on 10/7/14.
//  Copyright (c) 2014 QFish. All rights reserved.
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
@property (nonatomic, strong) id responseObject;
@end

@interface STIHTTPResponse : STIHTTPBaseObject<STIHTTPResponse>
@end

@interface STIHTTPResponseError : NSObject
@property (nonatomic, assign) NSUInteger code;
@property (nonatomic, strong) NSString * message;
@end

#pragma mark -

@class STIHTTPSessionManager;

@interface STIHTTPApi : STIHTTPBaseObject<STIHTTPResponseDataProcessor>

@property (nonatomic, weak) STIHTTPSessionManager * HTTPSessionManager;
@property (nonatomic, copy) STIHTTPApiBlock whenUpdate;
@property (nonatomic, strong) STIHTTPRequest * req;
@property (nonatomic, strong) id<STIHTTPResponse> resp;
@property (nonatomic, strong) id responseObject;
@property (nonatomic, weak) NSURLSessionDataTask * task;

- (void)send;
+ (void)setGlobalHTTPSessionManager:(STIHTTPSessionManager *)HTTPSessionManager;

@end
