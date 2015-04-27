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

#import "dribbble.h"

#pragma mark - models

#pragma mark - LINKS;

@implementation LINKS;
@end

#pragma mark - SHOT;

@implementation SHOT;
@end

#pragma mark - USER;

@implementation USER;
@end

#pragma mark - TEAM;

@implementation TEAM;
@end

#pragma mark - IMAGE;

@implementation IMAGE;
@end

#pragma mark - COMMENT;

@implementation COMMENT;
@end

#pragma mark - API

#pragma mark - List shots

@implementation LIST_SHOTS_REQUEST
@end

@implementation LIST_SHOTS_RESPONSE
@end

@implementation LIST_SHOTS_API

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.req = [LIST_SHOTS_REQUEST requestWithEndpoint:@"/shots" method:STIHTTPRequestMethodGet];
        self.req.responseClass = [LIST_SHOTS_RESPONSE class];
    }
    return self;
}

@end

#pragma mark - Get a shot

@implementation GET_A_SHOT_REQUEST
@end

@implementation GET_A_SHOT_RESPONSE
@end

@implementation GET_A_SHOT_API

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.req = [GET_A_SHOT_REQUEST requestWithEndpoint:@"/shots/:id" method:STIHTTPRequestMethodGet];
        self.req.responseClass = [GET_A_SHOT_RESPONSE class];
    }
    return self;
}

@end

#pragma mark - List comments for a shot

@implementation LIST_COMMENTS_FOR_A_SHOT_REQUEST
@end

@implementation LIST_COMMENTS_FOR_A_SHOT_RESPONSE
@end

@implementation LIST_COMMENTS_FOR_A_SHOT_API

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.req = [LIST_COMMENTS_FOR_A_SHOT_REQUEST requestWithEndpoint:@"/shots/:shot/comments" method:STIHTTPRequestMethodGet];
        self.req.responseClass = [LIST_COMMENTS_FOR_A_SHOT_RESPONSE class];
    }
    return self;
}

@end

#pragma mark - Get a single user

@implementation GET_A_SINGLE_USER_REQUEST
@end

@implementation GET_A_SINGLE_USER_RESPONSE
@end

@implementation GET_A_SINGLE_USER_API

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.req = [GET_A_SINGLE_USER_REQUEST requestWithEndpoint:@"/users/:user" method:STIHTTPRequestMethodGet];
        self.req.responseClass = [GET_A_SINGLE_USER_RESPONSE class];
    }
    return self;
}

@end

#pragma mark - List shots for a user

@implementation LIST_SHOTS_FOR_A_USER_REQUEST
@end

@implementation LIST_SHOTS_FOR_A_USER_RESPONSE
@end

@implementation LIST_SHOTS_FOR_A_USER_API

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.req = [LIST_SHOTS_FOR_A_USER_REQUEST requestWithEndpoint:@"/users/:user/shots" method:STIHTTPRequestMethodGet];
        self.req.responseClass = [LIST_SHOTS_FOR_A_USER_RESPONSE class];
    }
    return self;
}

@end
