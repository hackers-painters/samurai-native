#import "Movies.h"

#pragma mark - models

#pragma mark - DATES;

@implementation DATES;
@end

#pragma mark - RATINGS;

@implementation RATINGS;
@end

#pragma mark - IMAGE;

@implementation IMAGE;
@end

#pragma mark - PERSON;

@implementation PERSON;
@end

#pragma mark - LINKS;

@implementation LINKS;
@end

#pragma mark - IDS;

@implementation IDS;
@end

#pragma mark - MOVIE;

@implementation MOVIE;
@end

#pragma mark - API

#pragma mark - List movies

@implementation LIST_MOVIES_REQUEST
@end

@implementation LIST_MOVIES_RESPONSE
@end

@implementation LIST_MOVIES_API

@synthesize req = _req;
@synthesize resp = _resp;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.req = [LIST_MOVIES_REQUEST requestWithEndpoint:@"/lists/movies/in_theaters.json" method:STIHTTPRequestMethodGet];
        self.req.responseClass = [LIST_MOVIES_RESPONSE class];
    }
    return self;
}

@end

#pragma mark - Get a movie

@implementation GET_A_MOVIE_REQUEST
@end

@implementation GET_A_MOVIE_RESPONSE
@end

@implementation GET_A_MOVIE_API

@synthesize req = _req;
@synthesize resp = _resp;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.req = [GET_A_MOVIE_REQUEST requestWithEndpoint:@"movies/:id.json" method:STIHTTPRequestMethodGet];
        self.req.responseClass = [GET_A_MOVIE_RESPONSE class];
    }
    return self;
}

@end

