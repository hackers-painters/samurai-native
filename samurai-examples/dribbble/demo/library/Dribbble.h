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

#import "STIHTTPNetwork.h"

#pragma mark - 枚举类型

#pragma mark - Models

@class LINKS;
@class SHOT;
@class USER;
@class TEAM;
@class IMAGE;
@class COMMENT;

#pragma mark - Protocols

@protocol LINKS <NSObject> @end
@protocol SHOT <NSObject> @end
@protocol USER <NSObject> @end
@protocol TEAM <NSObject> @end
@protocol IMAGE <NSObject> @end
@protocol COMMENT <NSObject> @end

#pragma mark - Classes

@interface LINKS : NSObject
@property (nonatomic, strong) NSString * web;
@property (nonatomic, strong) NSString * twitter;
@end

@interface SHOT : NSObject
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * description;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, strong) IMAGE * images;
@property (nonatomic, assign) NSInteger views_count;
@property (nonatomic, assign) NSInteger likes_count;
@property (nonatomic, assign) NSInteger comments_count;
@property (nonatomic, assign) NSInteger attachments_count;
@property (nonatomic, assign) NSInteger rebounds_count;
@property (nonatomic, assign) NSInteger buckets_count;
@property (nonatomic, strong) NSDate * created_at;
@property (nonatomic, strong) NSDate * updated_at;
@property (nonatomic, strong) NSString * html_url;
@property (nonatomic, strong) NSString * attachments_url;
@property (nonatomic, strong) NSString * buckets_url;
@property (nonatomic, strong) NSString * comments_url;
@property (nonatomic, strong) NSString * likes_url;
@property (nonatomic, strong) NSString * projects_url;
@property (nonatomic, strong) NSString * rebounds_url;
@property (nonatomic, strong) NSArray<NSObject> * tags;
@property (nonatomic, strong) USER * user;
@property (nonatomic, strong) TEAM * team;
@end

@interface USER : NSObject
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSString * html_url;
@property (nonatomic, strong) NSString * avatar_url;
@property (nonatomic, strong) NSString * bio;
@property (nonatomic, strong) NSString * location;
@property (nonatomic, strong) LINKS * links;
@property (nonatomic, assign) NSInteger buckets_count;
@property (nonatomic, assign) NSInteger comments_received_count;
@property (nonatomic, assign) NSInteger followers_count;
@property (nonatomic, assign) NSInteger followings_count;
@property (nonatomic, assign) NSInteger likes_count;
@property (nonatomic, assign) NSInteger likes_received_count;
@property (nonatomic, assign) NSInteger projects_count;
@property (nonatomic, assign) NSInteger rebounds_received_count;
@property (nonatomic, assign) NSInteger shots_count;
@property (nonatomic, assign) NSInteger teams_count;
@property (nonatomic, assign) BOOL can_upload_shot;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, assign) BOOL pro;
@property (nonatomic, strong) NSString * buckets_url;
@property (nonatomic, strong) NSString * followers_url;
@property (nonatomic, strong) NSString * following_url;
@property (nonatomic, strong) NSString * likes_url;
@property (nonatomic, strong) NSString * shots_url;
@property (nonatomic, strong) NSString * teams_url;
@property (nonatomic, strong) NSDate * created_at;
@property (nonatomic, strong) NSDate * updated_at;
@end

@interface TEAM : NSObject
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSString * html_url;
@property (nonatomic, strong) NSString * avatar_url;
@property (nonatomic, strong) NSString * bio;
@property (nonatomic, strong) NSString * location;
@property (nonatomic, strong) LINKS * links;
@property (nonatomic, assign) NSInteger buckets_count;
@property (nonatomic, assign) NSInteger comments_received_count;
@property (nonatomic, assign) NSInteger followers_count;
@property (nonatomic, assign) NSInteger followings_count;
@property (nonatomic, assign) NSInteger likes_count;
@property (nonatomic, assign) NSInteger likes_received_count;
@property (nonatomic, assign) NSInteger members_count;
@property (nonatomic, assign) NSInteger projects_count;
@property (nonatomic, assign) NSInteger rebounds_received_count;
@property (nonatomic, assign) NSInteger shots_count;
@property (nonatomic, assign) BOOL can_upload_shot;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, assign) BOOL pro;
@property (nonatomic, strong) NSString * buckets_url;
@property (nonatomic, strong) NSString * followers_url;
@property (nonatomic, strong) NSString * following_url;
@property (nonatomic, strong) NSString * likes_url;
@property (nonatomic, strong) NSString * members_url;
@property (nonatomic, strong) NSString * shots_url;
@property (nonatomic, strong) NSString * team_shots_url;
@property (nonatomic, strong) NSDate * created_at;
@property (nonatomic, strong) NSDate * updated_at;
@end

@interface IMAGE : NSObject
@property (nonatomic, strong) NSString * hidpi;
@property (nonatomic, strong) NSString * normal;
@property (nonatomic, strong) NSString * teaser;
@end

@interface COMMENT : NSObject
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString * body;
@property (nonatomic, assign) NSInteger likes_count;
@property (nonatomic, strong) NSString * likes_url;
@property (nonatomic, strong) NSDate * created_at;
@property (nonatomic, strong) NSDate * updated_at;
@property (nonatomic, strong) USER * user;
@end

#pragma mark - API

#pragma mark - List shots

@interface LIST_SHOTS_REQUEST : STIHTTPRequest
@property (nonatomic, strong) NSString * list;
@property (nonatomic, strong) NSString * timeframe;
@property (nonatomic, strong) NSDate * date;
@property (nonatomic, strong) NSString * sort;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger per_page;
@end

@interface LIST_SHOTS_RESPONSE : STIHTTPResponse
@property (nonatomic, strong) NSString * message;
@property (nonatomic, strong) NSArray<NSObject> * errors;
@property (nonatomic, strong) NSArray<SHOT> * data;
@end

@interface LIST_SHOTS_API : STIHTTPApi
@property (nonatomic, strong) LIST_SHOTS_REQUEST * req;
@property (nonatomic, strong) LIST_SHOTS_RESPONSE * resp;
@end

#pragma mark - Get a shot

@interface GET_A_SHOT_REQUEST : STIHTTPRequest
@property (nonatomic, assign) NSInteger id;
@end

@interface GET_A_SHOT_RESPONSE : STIHTTPResponse
@property (nonatomic, strong) NSString * message;
@property (nonatomic, strong) NSArray<NSObject> * errors;
@property (nonatomic, strong) SHOT * data;
@end

@interface GET_A_SHOT_API : STIHTTPApi
@property (nonatomic, strong) GET_A_SHOT_REQUEST * req;
@property (nonatomic, strong) GET_A_SHOT_RESPONSE * resp;
@end

#pragma mark - List comments for a shot

@interface LIST_COMMENTS_FOR_A_SHOT_REQUEST : STIHTTPRequest
@property (nonatomic, assign) NSInteger shot;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger per_page;
@end

@interface LIST_COMMENTS_FOR_A_SHOT_RESPONSE : STIHTTPResponse
@property (nonatomic, strong) NSString * message;
@property (nonatomic, strong) NSArray<NSObject> * errors;
@property (nonatomic, strong) NSArray<COMMENT> * data;
@end

@interface LIST_COMMENTS_FOR_A_SHOT_API : STIHTTPApi
@property (nonatomic, strong) LIST_COMMENTS_FOR_A_SHOT_REQUEST * req;
@property (nonatomic, strong) LIST_COMMENTS_FOR_A_SHOT_RESPONSE * resp;
@end

#pragma mark - Get a single user

@interface GET_A_SINGLE_USER_REQUEST : STIHTTPRequest
@property (nonatomic, assign) NSInteger user;
@end

@interface GET_A_SINGLE_USER_RESPONSE : STIHTTPResponse
@property (nonatomic, strong) NSString * message;
@property (nonatomic, strong) NSArray<NSObject> * errors;
@property (nonatomic, strong) USER * data;
@end

@interface GET_A_SINGLE_USER_API : STIHTTPApi
@property (nonatomic, strong) GET_A_SINGLE_USER_REQUEST * req;
@property (nonatomic, strong) GET_A_SINGLE_USER_RESPONSE * resp;
@end

#pragma mark - List shots for a user

@interface LIST_SHOTS_FOR_A_USER_REQUEST : STIHTTPRequest
@property (nonatomic, assign) NSInteger user;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger per_page;
@end

@interface LIST_SHOTS_FOR_A_USER_RESPONSE : STIHTTPResponse
@property (nonatomic, strong) NSString * message;
@property (nonatomic, strong) NSArray<NSObject> * errors;
@property (nonatomic, strong) NSArray<SHOT> * data;
@end

@interface LIST_SHOTS_FOR_A_USER_API : STIHTTPApi
@property (nonatomic, strong) LIST_SHOTS_FOR_A_USER_REQUEST * req;
@property (nonatomic, strong) LIST_SHOTS_FOR_A_USER_RESPONSE * resp;
@end

