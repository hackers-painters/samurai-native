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

#import "DribbbleClient.h"
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
    // Dump response headers
//    NSHTTPURLResponse * resp = ( NSHTTPURLResponse *)task.response;
//    NSLog(@"%@", resp.allHeaderFields);
    
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
    return [[NSDate format:@"yyyy-MM-dd'T'HH:mm:ss'Z'"] dateFromString:string];
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
