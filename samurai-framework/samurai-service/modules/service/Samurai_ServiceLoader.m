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

#import "Samurai_ServiceLoader.h"
#import "Samurai_Service.h"

#import "_pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiServiceLoader
{
	NSMutableDictionary * _services;
}

@def_singleton( SamuraiServiceLoader )

@def_prop_dynamic( NSArray *, services );

- (id)init
{
	self = [super init];
	if ( self )
	{
		_services = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[_services removeAllObjects];
	_services = nil;
}

- (void)installServices
{
#if __SAMURAI_SERVICE__

	for ( NSString * className in [SamuraiService subClasses] )
	{
		Class classType = NSClassFromString( className );
		if ( nil == classType )
			continue;

		fprintf( stderr, "  Loading service '%s'\n", [[classType description] UTF8String] );
		
		SamuraiService * service = [self service:classType];
		if ( service )
		{
			[service install];
		}
	}
	
	fprintf( stderr, "\n" );

#endif
}

- (void)uninstallServices
{
	for ( SamuraiService * service in _services )
	{
		[service uninstall];
	}
	
	[_services removeAllObjects];
}

- (NSArray *)services
{
	return [_services allValues];
}

- (id)service:(Class)classType
{
	SamuraiService * service = [_services objectForKey:[classType description]];

	if ( nil == service )
	{
		service = [[classType alloc] init];
		if ( service )
		{
			[_services setObject:service forKey:[classType description]];
		}

		if ( [service conformsToProtocol:@protocol(ManagedService)] )
		{
			[service powerOn];
		}
	}

	return service;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( Service, Loader )

DESCRIBE( before )
{
}

DESCRIBE( after )
{
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#import "_pragma_pop.h"
