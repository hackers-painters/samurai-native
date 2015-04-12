//
//  STIHTTPNetwork.m
//  AFNetworking iOS Example
//
//  Created by QFish on 10/7/14.
//  Copyright (c) 2014 QFish. All rights reserved.
//

#import "STIHTTPNetwork.h"
#import "AutoCoding.h"
#import "NSObject+AutoCoding.h"
#import "AFNetworking.h"

@implementation STIHTTPBaseObject

- (BOOL)isValidated
{
    return YES;
}

- (NSString *)description
{
    return [[self dictionaryRepresentation] description];
}

@end

#pragma mark -

static STIHTTPSessionManager * kGlobalHTTPSessionManager = nil;

@implementation STIHTTPApi

+ (void)setGlobalHTTPSessionManager:(STIHTTPSessionManager *)HTTPSessionManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kGlobalHTTPSessionManager = HTTPSessionManager;
    });
}

- (void)dealloc
{
    switch ( self.task.state )
    {
        case NSURLSessionTaskStateRunning:
        case NSURLSessionTaskStateSuspended:
            [self.task cancel];
            break;
        case NSURLSessionTaskStateCanceling:
        case NSURLSessionTaskStateCompleted:
            break;
    }
}

- (STIHTTPSessionManager *)HTTPSessionManager
{
    if ( _HTTPSessionManager == nil ) {
        return kGlobalHTTPSessionManager;
    }
    // TODO: nil check
    return _HTTPSessionManager;
}

- (id)processedDataWithResponseObject:(id)responseObject task:(NSURLSessionDataTask *)task
{
    // By default, just make the HTTPSessionManager process data
    return [self.HTTPSessionManager processedDataWithResponseObject:responseObject task:task];
}

- (void)handleError:(NSError *)error responseObject:(id)responseObject task:(NSURLSessionDataTask *)task failureBlock:(void (^)(id, id))failureBlock
{
    // By default, just make the HTTPSessionManager handle error
    [self.HTTPSessionManager handleError:error responseObject:responseObject task:task failureBlock:failureBlock];
}

- (void)send
{
    if ( self.HTTPSessionManager.setup ) {
        self.HTTPSessionManager.setup(nil);
    }

//    __weak typeof(self) weakSelf = self;
    [self.HTTPSessionManager method:self.req.method
                           endpoint:self.req.endpoint
                         parameters:self.req.parameters
                            success:^(NSURLSessionDataTask *task, id responseObject) {
//                                __strong typeof(weakSelf) self = weakSelf;
                                self.resp = [self.req.responseClass ac_objectWithAny:[self processedDataWithResponseObject:responseObject task:task]];
                                self.responseObject = responseObject;
                                if ( self.whenUpdate ) {
                                    self.whenUpdate( self.resp, nil );
                                }
                            }
                            failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
//                                __strong typeof(weakSelf) self = weakSelf;
                                [self.HTTPSessionManager handleError:error responseObject:responseObject task:task failureBlock:self.whenUpdate];
                            }];
}

@end

#pragma mark -

@interface STIHTTPRequest()
@end

#pragma mark -

@implementation STIHTTPRequest

@synthesize method = _method;
@synthesize endpoint = _endpoint;

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSAssert(NO, @"You should use [STIHTTPRequest initWithEndpoint:] instead.");
    }
    return self;
}

- (instancetype)initWithEndpoint:(NSString *)endpoint method:(STIHTTPRequestMethod)method
{
    self = [super init];
    if (self) {
        _endpoint = endpoint;
        _method = method;
    }
    return self;
}

+ (instancetype)requestWithEndpoint:(NSString *)endpoint method:(STIHTTPRequestMethod)method
{
    return [[self alloc] initWithEndpoint:endpoint method:method];
}

- (NSDictionary *)parameters
{
    NSDictionary * parameters = [self dictionaryRepresentation];
	return parameters.count ? parameters : nil;
}

- (NSString *)endpoint
{
    NSAssert(_endpoint && _endpoint.length, @"Are you kiding ?! The URI endpoint for requset should not be empty");

    if ( [_endpoint hasPrefix:@"/"] ) {
        _endpoint = [_endpoint substringFromIndex:1];
    }
    
    NSArray * partials = [_endpoint componentsSeparatedByString:@"/"];

    NSArray * targets = [partials filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF beginswith[c] ':'"]];

    __block NSMutableString * path = [_endpoint mutableCopy];
    
    [targets enumerateObjectsUsingBlock:^(NSString * str, __unused NSUInteger idx, __unused BOOL *stop) {
        
        NSString * param = [self valueForKeyPath:[str stringByReplacingOccurrencesOfString:@":" withString:@""]];
        
        [path replaceOccurrencesOfString:str
                              withString:[param description]
                                 options:NSCaseInsensitiveSearch
                                   range:NSMakeRange(0, path.length)];
    }];
    
    return path;
}

@end

#pragma mark -

@implementation STIHTTPResponse

- (BOOL)isValidated
{
    return YES;
}

@end

#pragma mark -

@implementation STIHTTPResponseError
@end

