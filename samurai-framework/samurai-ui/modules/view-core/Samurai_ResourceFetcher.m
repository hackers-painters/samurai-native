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

#import "Samurai_ResourceFetcher.h"
#import "Samurai_App.h"

#if __SAMURAI_USE_AFNETWORKING__
#import "AFNetworking.h"
#else	// #if __SAMURAI_USE_AFNETWORKING__
// TODO
#endif	// #if __SAMURAI_USE_AFNETWORKING__

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSObject(ResourceFetcher)

- (void)handleResourceLoaded:(SamuraiResource *)resource
{
	
}

- (void)handleResourceFailed:(SamuraiResource *)resource
{
	
}

- (void)handleResourceCancelled:(SamuraiResource *)resource
{
	
}

@end

#pragma mark -

@implementation SamuraiResourceFetcher
{
#if __SAMURAI_USE_AFNETWORKING__
	NSMutableArray * _operations;
#endif	// #if __SAMURAI_USE_AFNETWORKING__
}

@def_prop_unsafe( id,	responder );

+ (SamuraiResourceFetcher *)resourceFetcher
{
	return [[SamuraiResourceFetcher alloc] init];
}

- (id)init
{
	self = [super init];
	if ( self )
	{
	#if __SAMURAI_USE_AFNETWORKING__
		_operations = [NSMutableArray nonRetainingArray];
	#endif	// #if __SAMURAI_USE_AFNETWORKING__

		self.responder = nil;
	}
	return self;
}

- (void)dealloc
{
	[self cancel];
	
	self.responder = nil;

#if __SAMURAI_USE_AFNETWORKING__
	[_operations removeAllObjects];
	_operations = nil;
#endif	// #if __SAMURAI_USE_AFNETWORKING__
}

- (void)queue:(SamuraiResource *)resource
{
#if __SAMURAI_USE_AFNETWORKING__
	
	NSURL * url = [NSURL URLWithString:resource.resPath];
	if ( nil == url )
		return;

	NSURLRequest * request = [NSURLRequest requestWithURL:url];
	if ( nil == request )
		return;
	
	@weakify( self );
	
	AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	
	[_operations addObject:operation];
	
	[operation setCompletionBlockWithSuccess:^( AFHTTPRequestOperation * operation, id responseObject ){
		
		@strongify( self );

	//	NSString *	requestURL = nil;
		NSData *	responseData = operation.responseData;
	//	NSString *	responseType = nil;
		
		[resource clear];
		
	//	resource.resType = responseType ?: resource.resType;
	//	resource.resPath = requestURL ?: resource.resPath;
		resource.resContent = [responseData toString];
		
		BOOL succeed = [resource parse];
		if ( NO == succeed )
		{
			if ( self.responder )
			{
				[self.responder handleResourceFailed:resource];
			}
		}
		else
		{
			if ( self.responder )
			{
				[self.responder handleResourceLoaded:resource];
			}
		}

		[_operations removeObject:operation];

	} failure:^( AFHTTPRequestOperation * operation, NSError * error ) {
		
		@strongify( self );

		[self handleResourceFailed:resource];

		[_operations removeObject:operation];
	}];

	[operation start];

#else	// #if __SAMURAI_USE_AFNETWORKING__

	SamuraiHTTPSession * session = [self HTTP_GET:resource.resPath];
	
	@weakify(self)
	
	session.object = resource;
	session.timeoutSeconds = RESOURCE_TIMEOUT_SECONDS;
	session.stateChanged = ^( SamuraiHTTPSession * session )
	{
		@strongify(self)
		
		SamuraiResource * resource = session.object;
		ASSERT( nil != resource );
		
		if ( session.sending )
		{
		}
		else if ( session.recving )
		{
		}
		else if ( session.succeed )
		{
		//	NSString *	requestURL = session.url.absoluteString;
			NSData *	responseData = session.response.bodyData;
		//	NSString *	responseType = [[session.response.ContentType componentsSeparatedByString:@";"] safeObjectAtIndex:0];
			
			[resource clear];
			
		//	resource.resType = responseType ?: resource.resType;
		//	resource.resPath = requestURL ?: resource.resPath;
			resource.resContent = [responseData toString];
			
			BOOL succeed = [resource parse];
			if ( NO == succeed )
			{
				[self cancelAllSessions];
				
				if ( self.responder )
				{
					[self.responder handleResourceFailed:resource];
				}
			}
			else
			{
				if ( self.responder )
				{
					[self.responder handleResourceLoaded:resource];
				}
			}
		}
		else if ( session.failed )
		{
			if ( self.responder )
			{
				[self.responder handleResourceFailed:resource];
			}
		}
		else if ( session.cancelled )
		{
			if ( self.responder )
			{
				[self.responder handleResourceCancelled:resource];
			}
		}
	};
	
#endif	// #if __SAMURAI_USE_AFNETWORKING__
}

- (void)cancel
{
#if __SAMURAI_USE_AFNETWORKING__
	
	for ( AFHTTPRequestOperation * operation in [_operations copy] )
	{
		[operation cancel];
	}
	
	[_operations removeAllObjects];
	
#else	// #if __SAMURAI_USE_AFNETWORKING__
	
	[self cancelAllSessions];
	
#endif	// #if __SAMURAI_USE_AFNETWORKING__
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, ResourceFetcher )

DESCRIBE( before )
{
}

DESCRIBE( after )
{
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "_pragma_pop.h"
