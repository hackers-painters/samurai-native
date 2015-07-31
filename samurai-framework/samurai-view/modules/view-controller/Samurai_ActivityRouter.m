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

#import "Samurai_ActivityRouter.h"
#import "Samurai_Intent.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiActivityRouter
{
	NSMutableDictionary *	_map;
}

@def_singleton( SamuraiActivityRouter )

#pragma mark -

- (id)init
{
	self = [super init];
	if ( self )
	{
		_map = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[_map removeAllObjects];
	_map = nil;
}

#pragma mark -

- (NSString *)formatURL:(NSString *)url
{
	NSString * formattedURL = url;
	
	if ( NO == [formattedURL hasPrefix:@"/"] )
	{
		formattedURL = [@"/" stringByAppendingString:formattedURL];
	}
	
	if ( NO == [formattedURL hasPrefix:@"/"] )
	{
		formattedURL = [formattedURL stringByAppendingString:@"/"];
	}
	
	if ( formattedURL && formattedURL.length )
	{
		formattedURL = [formattedURL lowercaseString];
	}
	
	return formattedURL;
}

- (void)mapURL:(NSString *)url toActivityClass:(Class)classType
{
	url = [self formatURL:url];
	
	if ( url )
	{
		[_map setObject:[classType description] forKey:url];
	}
}

- (void)mapURL:(NSString *)url toActivityInstance:(SamuraiActivity *)activity
{
	url = [self formatURL:url];
	
	if ( url )
	{
		[_map setObject:activity forKey:url];
	}
}

- (void)mapURL:(NSString *)url toBlock:(ActivityRouterBlock)block
{
	url = [self formatURL:url];
	
	if ( url )
	{
		[_map setObject:[block copy] forKey:url];
	}
}

- (id)activityForURL:(NSString *)url
{
	url = [self formatURL:url];
	
	NSObject * obj = nil;
	
	if ( url && url.length )
	{
		obj = [_map objectForKey:url];
	}
	
	if ( nil == obj )
	{
		obj = [_map objectForKey:@"*"];
	}

	SamuraiActivity * activity = nil;
	
	@try
	{
		if ( obj )
		{
			if ( [obj isKindOfClass:[NSString class]] )
			{
				Class objClass = NSClassFromString( (NSString *)obj );
				if ( objClass && [objClass isSubclassOfClass:[SamuraiActivity class]] )
				{
					activity = [[objClass alloc] init];
				}
			}
			else if ( [obj isKindOfClass:[SamuraiActivity class]] )
			{
				activity = (SamuraiActivity *)obj;
			}
			else
			{
				ActivityRouterBlock objBlock = (ActivityRouterBlock)obj;
				activity = objBlock( url );
			}
		}
	}
	@catch ( NSException * exception )
	{
	}
	@finally
	{
	}

	return activity;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, ActivityRouter )

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
