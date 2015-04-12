#import "STIHTTPNetwork.h"

#pragma mark - 枚举类型

#pragma mark - Models

@class DATES;
@class RATINGS;
@class IMAGE;
@class PERSON;
@class LINKS;
@class IDS;
@class MOVIE;

#pragma mark - Protocols

@protocol DATES <NSObject> @end
@protocol RATINGS <NSObject> @end
@protocol IMAGE <NSObject> @end
@protocol PERSON <NSObject> @end
@protocol LINKS <NSObject> @end
@protocol IDS <NSObject> @end
@protocol MOVIE <NSObject> @end

#pragma mark - Classes

@interface DATES : NSObject 
@property (nonatomic, strong) NSString * theater;
@property (nonatomic, strong) NSString * dvd;
@end
 
@interface RATINGS : NSObject 
@property (nonatomic, strong) NSString * critics_rating;
@property (nonatomic, assign) NSInteger critics_score;
@property (nonatomic, strong) NSString * audience_rating;
@property (nonatomic, assign) NSInteger audience_score;
@end
 
@interface IMAGE : NSObject 
@property (nonatomic, strong) NSString * thumbnail;
@property (nonatomic, strong) NSString * profile;
@property (nonatomic, strong) NSString * detailed;
@property (nonatomic, strong) NSString * original;
@end
 
@interface PERSON : NSObject 
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSArray<NSObject> * characters;
@end
 
@interface LINKS : NSObject 
@property (nonatomic, strong) NSString * self;
@property (nonatomic, strong) NSString * alternate;
@property (nonatomic, strong) NSString * cast;
@property (nonatomic, strong) NSString * clips;
@property (nonatomic, strong) NSString * reviews;
@property (nonatomic, strong) NSString * similar;
@end
 
@interface IDS : NSObject 
@property (nonatomic, strong) NSString * imdb;
@end
 
@interface MOVIE : NSObject 
@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger year;
@property (nonatomic, strong) NSArray<NSObject> * genres;
@property (nonatomic, strong) NSString * mpaa_rating;
@property (nonatomic, assign) NSInteger runtime;
@property (nonatomic, strong) NSString * critics_consensus;
@property (nonatomic, strong) DATES * release_dates;
@property (nonatomic, strong) RATINGS * ratings;
@property (nonatomic, strong) NSString * synopsis;
@property (nonatomic, strong) IMAGE * posters;
@property (nonatomic, strong) NSArray<PERSON> * abridged_cast;
@property (nonatomic, strong) NSArray<PERSON> * abridged_directors;
@property (nonatomic, strong) NSString * studio;
@property (nonatomic, strong) IDS * alternate_ids;
@property (nonatomic, strong) LINKS * links;
@end
 
#pragma mark - API

#pragma mark - List movies

@interface LIST_MOVIES_REQUEST : STIHTTPRequest
@property (nonatomic, strong) NSString * apikey;
@property (nonatomic, strong) NSString * list;
@property (nonatomic, strong) NSString * timeframe;
@property (nonatomic, strong) NSDate * date;
@property (nonatomic, strong) NSString * sort;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger page_limit;
@end

@interface LIST_MOVIES_RESPONSE : STIHTTPResponse
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, strong) NSArray<MOVIE> * movies;
@end

@interface LIST_MOVIES_API : STIHTTPApi
@property (nonatomic, strong) LIST_MOVIES_REQUEST * req;
@property (nonatomic, strong) LIST_MOVIES_RESPONSE * resp;
@end

#pragma mark - Get a movie

@interface GET_A_MOVIE_REQUEST : STIHTTPRequest
@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * apikey;
@end

@interface GET_A_MOVIE_RESPONSE : STIHTTPResponse
@property (nonatomic, strong) NSString * message;
@property (nonatomic, strong) NSArray<NSObject> * errors;
@property (nonatomic, strong) MOVIE * movie;
@end

@interface GET_A_MOVIE_API : STIHTTPApi
@property (nonatomic, strong) GET_A_MOVIE_REQUEST * req;
@property (nonatomic, strong) GET_A_MOVIE_RESPONSE * resp;
@end

