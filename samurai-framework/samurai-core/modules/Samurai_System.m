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

#import "Samurai_System.h"
#import "Samurai_UnitTest.h"
#import "Samurai_Vendor.h"

#import "_pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiSystem

@def_singleton( SamuraiSystem );

@def_prop_readonly( NSString *,			osVersion );
@def_prop_readonly( OperationSystem,	osType );
@def_prop_readonly( NSString *,			bundleVersion );
@def_prop_readonly( NSString *,			bundleShortVersion );
@def_prop_readonly( NSString *,			bundleIdentifier );
@def_prop_readonly( NSString *,			urlSchema );
@def_prop_readonly( NSString *,			deviceModel );
@def_prop_readonly( NSString *,			deviceUDID );

@def_prop_readonly( BOOL,				isJailBroken );
@def_prop_readonly( BOOL,				runningOnPhone );
@def_prop_readonly( BOOL,				runningOnPad );
@def_prop_readonly( BOOL,				requiresPhoneOS );

@def_prop_readonly( BOOL,				isScreenPhone );
@def_prop_readonly( BOOL,				isScreen320x480 );
@def_prop_readonly( BOOL,				isScreen640x960 );
@def_prop_readonly( BOOL,				isScreen640x1136 );

@def_prop_readonly( BOOL,				isScreenPad );
@def_prop_readonly( BOOL,				isScreen768x1024 );
@def_prop_readonly( BOOL,				isScreen1536x2048 );

@def_prop_readonly( CGSize,				screenSize );

+ (void)classAutoLoad
{
	[SamuraiSystem sharedInstance];
}

- (NSString *)osVersion
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return [NSString stringWithFormat:@"%@ %@", [UIDevice currentDevice].systemName, [UIDevice currentDevice].systemVersion];
#else
	return nil;
#endif
}

- (OperationSystem)osType
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return OperationSystem_iOS;
#elif (TARGET_OS_MAC)
	return OperationSystem_Mac;
#else
	return OperationSystem_Unknown;
#endif
}

- (NSString *)bundleVersion
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_MAC)
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
#else
	return nil;
#endif
}

- (NSString *)bundleShortVersion
	{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_MAC)
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
#else
	return nil;
#endif
}

- (NSString *)bundleIdentifier
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
#else
	return nil;
#endif
}

- (NSString *)urlSchema
{
	return [self urlSchemaWithName:nil];
}

- (NSString *)urlSchemaWithName:(NSString *)name
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	
	NSArray * array = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"];
	for ( NSDictionary * dict in array )
	{
		if ( name )
		{
			NSString * URLName = [dict objectForKey:@"CFBundleURLName"];
			if ( nil == URLName )
			{
				continue;
			}

			if ( NO == [URLName isEqualToString:name] )
			{
				continue;
			}
		}

		NSArray * URLSchemes = [dict objectForKey:@"CFBundleURLSchemes"];
		if ( nil == URLSchemes || 0 == URLSchemes.count )
		{
			continue;
		}

		NSString * schema = [URLSchemes objectAtIndex:0];
		if ( schema && schema.length )
		{
			return schema;
		}
	}

	return nil;
	
#else
	
	return nil;
	
#endif
}

- (NSString *)deviceModel
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return [UIDevice currentDevice].model;
#else
	return nil;
#endif
}

- (NSString *)deviceUDID
{
	return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

- (BOOL)isJailBroken
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	
	static const char * __jb_apps[] =
	{
		"/Application/Cydia.app", 
		"/Application/limera1n.app", 
		"/Application/greenpois0n.app", 
		"/Application/blackra1n.app",
		"/Application/blacksn0w.app",
		"/Application/redsn0w.app",
		NULL
	};

// method 1
	
    for ( int i = 0; __jb_apps[i]; ++i )
    {
        if ( [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:__jb_apps[i]]] )
        {
			return YES;
        }
    }
	
// method 2
	
	if ( [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"] )
	{
		return YES;
	}
	
// method 3

//#ifdef __IPHONE_8_0
//
//	if ( 0 == posix_spawn("ls") )
//	{
//		return YES;
//	}
//	
//#else
//
//	if ( 0 == system("ls") )
//	{
//		return YES;
//	}
//	
//#endif
	
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	
    return NO;
}

- (BOOL)runningOnPhone
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	
	NSString * deviceType = [UIDevice currentDevice].model;
	if ( [deviceType rangeOfString:@"iPhone" options:NSCaseInsensitiveSearch].length > 0 ||
		 [deviceType rangeOfString:@"iPod" options:NSCaseInsensitiveSearch].length > 0 ||
		 [deviceType rangeOfString:@"iTouch" options:NSCaseInsensitiveSearch].length > 0 )
	{
		return YES;
	}
	
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	
	return NO;
}

- (BOOL)runningOnPad
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	
	NSString * deviceType = [UIDevice currentDevice].model;
	if ( [deviceType rangeOfString:@"iPad" options:NSCaseInsensitiveSearch].length > 0 )
	{
		return YES;
	}
	
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	
	return NO;
}

- (BOOL)requiresPhoneOS
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	
	return [[[NSBundle mainBundle].infoDictionary objectForKey:@"LSRequiresIPhoneOS"] boolValue];
	
#else
	
	return NO;
	
#endif
}

- (BOOL)isScreenPhone
{
	if ( [self isScreen320x480] || [self isScreen640x960] || [self isScreen640x1136] || [self isScreen750x1334] || [self isScreen1242x2208] || [self isScreen1125x2001] )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)isScreen320x480
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	
	if ( [self runningOnPad] )
	{
		if ( [self requiresPhoneOS] && [self isScreen768x1024] )
		{
			return YES;
		}

		return NO;
	}
	else
	{
		return [self isScreenSizeEqualTo:CGSizeMake(320, 480)];
	}

#endif
	
	return NO;
}

- (BOOL)isScreen640x960
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	
	if ( [self runningOnPad] )
	{
		if ( [self requiresPhoneOS] && [self isScreen1536x2048] )
		{
			return YES;
		}

		return NO;
	}
	else
	{
		return [self isScreenSizeEqualTo:CGSizeMake(640, 960)];
	}
	
#endif
	
	return NO;
}

- (BOOL)isScreen640x1136
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	
	if ( [self runningOnPad] )
	{
		return NO;
	}
	else
	{
		return [self isScreenSizeEqualTo:CGSizeMake(640, 1136)];
	}

#endif
	
	return NO;
}

- (BOOL)isScreen750x1334
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    if ( [self runningOnPad] )
    {
        return NO;
    }
    else
    {
        return [self isScreenSizeEqualTo:CGSizeMake(750, 1334)];
    }
    
#endif
    
    return NO;
}

- (BOOL)isScreen1242x2208
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    if ( [self runningOnPad] )
    {
        return NO;
    }
    else
    {
        return [self isScreenSizeEqualTo:CGSizeMake(1242, 2208)];
    }
    
#endif
    
    return NO;
}

- (BOOL)isScreen1125x2001
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    if ( [self runningOnPad] )
    {
        return NO;
    }
    else
    {
        return [self isScreenSizeEqualTo:CGSizeMake(1125, 2001)];
    }
    
#endif
    
    return NO;
}

- (BOOL)isScreenPad
{
	if ( [self isScreen768x1024] || [self isScreen1536x2048] )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)isScreen768x1024
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	
	return [self isScreenSizeEqualTo:CGSizeMake(768, 1024)];
	
#endif
	
	return NO;
}

- (BOOL)isScreen1536x2048
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

	return [self isScreenSizeEqualTo:CGSizeMake(1536, 2048)];

#endif
	
	return NO;
}

- (CGSize)screenSize
{
	return [UIScreen mainScreen].currentMode.size;
}

- (BOOL)isScreenSizeEqualTo:(CGSize)size
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	
	CGSize size2 = CGSizeMake( size.height, size.width );
	CGSize screenSize = [UIScreen mainScreen].currentMode.size;
	
	if ( CGSizeEqualToSize(size, screenSize) || CGSizeEqualToSize(size2, screenSize) )
	{
		return YES;
	}

#endif
	
	return NO;
}

- (BOOL)isScreenSizeSmallerThan:(CGSize)size
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	
	CGSize size2 = CGSizeMake( size.height, size.width );
	CGSize screenSize = [UIScreen mainScreen].currentMode.size;

	if ( (size.width > screenSize.width && size.height > screenSize.height) ||
		(size2.width > screenSize.width && size2.height > screenSize.height) )
	{
		return YES;
	}
	
#endif
	
	return NO;
}

- (BOOL)isScreenSizeBiggerThan:(CGSize)size
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	
	CGSize size2 = CGSizeMake( size.height, size.width );
	CGSize screenSize = [UIScreen mainScreen].currentMode.size;
	
	if ( (size.width < screenSize.width && size.height < screenSize.height) ||
		(size2.width < screenSize.width && size2.height < screenSize.height) )
	{
		return YES;
	}
	
#endif
	
	return NO;
}

- (BOOL)isOsVersionOrEarlier:(NSString *)ver
{
	if ( [[self osVersion] compare:ver] != NSOrderedDescending )
	{
		return YES;
	}
	else
	{
		return NO;
	}
}

- (BOOL)isOsVersionOrLater:(NSString *)ver
{
	if ( [[self osVersion] compare:ver] != NSOrderedAscending )
	{
		return YES;
	}
	else
	{
		return NO;
	}
}

- (BOOL)isOsVersionEqualTo:(NSString *)ver
{
	if ( NSOrderedSame == [[self osVersion] compare:ver] )
	{
		return YES;
	}
	else
	{
		return NO;
	}	
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( Core, System )
{
}

DESCRIBE( system info )
{
	EXPECTED( [SamuraiSystem sharedInstance].osVersion );
	EXPECTED( [SamuraiSystem sharedInstance].osType != OperationSystem_Unknown );

	EXPECTED( [SamuraiSystem sharedInstance].deviceModel );
	EXPECTED( [SamuraiSystem sharedInstance].deviceUDID );
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#import "_pragma_pop.h"
