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
