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

#import "Samurai_Config.h"
#import "Samurai_CoreConfig.h"

#import "Samurai_Property.h"
#import "Samurai_Singleton.h"

#pragma mark -

typedef enum
{
	OperationSystem_Unknown = 0,
	OperationSystem_Mac,
	OperationSystem_iOS
} OperationSystem;

#pragma mark -

#define IOS9_OR_LATER		[[SamuraiSystem sharedInstance] isOsVersionOrLater:@"9.0"]
#define IOS8_OR_LATER		[[SamuraiSystem sharedInstance] isOsVersionOrLater:@"8.0"]
#define IOS7_OR_LATER		[[SamuraiSystem sharedInstance] isOsVersionOrLater:@"7.0"]
#define IOS6_OR_LATER		[[SamuraiSystem sharedInstance] isOsVersionOrLater:@"6.0"]
#define IOS5_OR_LATER		[[SamuraiSystem sharedInstance] isOsVersionOrLater:@"5.0"]
#define IOS4_OR_LATER		[[SamuraiSystem sharedInstance] isOsVersionOrLater:@"4.0"]

#define IOS9_OR_EARLIER		[[SamuraiSystem sharedInstance] isOsVersionOrEarlier:@"9.0"]
#define IOS8_OR_EARLIER		[[SamuraiSystem sharedInstance] isOsVersionOrEarlier:@"8.0"]
#define IOS7_OR_EARLIER		[[SamuraiSystem sharedInstance] isOsVersionOrEarlier:@"7.0"]
#define IOS6_OR_EARLIER		[[SamuraiSystem sharedInstance] isOsVersionOrEarlier:@"6.0"]
#define IOS5_OR_EARLIER		[[SamuraiSystem sharedInstance] isOsVersionOrEarlier:@"5.0"]
#define IOS4_OR_EARLIER		[[SamuraiSystem sharedInstance] isOsVersionOrEarlier:@"4.0"]

#pragma mark -

@interface SamuraiSystem : NSObject

@singleton( SamuraiSystem )

@prop_readonly( NSString *,			osVersion );
@prop_readonly( OperationSystem,	osType );
@prop_readonly( NSString *,			bundleVersion );
@prop_readonly( NSString *,			bundleShortVersion );
@prop_readonly( NSString *,			bundleIdentifier );
@prop_readonly( NSString *,			urlSchema );
@prop_readonly( NSString *,			deviceModel );
@prop_readonly( NSString *,			deviceUDID );

@prop_readonly( BOOL,				isJailBroken );
@prop_readonly( BOOL,				runningOnPhone );
@prop_readonly( BOOL,				runningOnPad );
@prop_readonly( BOOL,				requiresPhoneOS );

@prop_readonly( BOOL,				isScreenPhone );
@prop_readonly( BOOL,				isScreen320x480 );      // history
@prop_readonly( BOOL,				isScreen640x960 );      // ip4s
@prop_readonly( BOOL,				isScreen640x1136 );     // ip5, ip5s, ip6 Zoom mode
@prop_readonly( BOOL,				isScreen750x1334 );     // ip6
@prop_readonly( BOOL,				isScreen1242x2208 );    // ip6p
@prop_readonly( BOOL,				isScreen1125x2001 );    // ip6p Zoom mode

@prop_readonly( BOOL,				isScreenPad );
@prop_readonly( BOOL,				isScreen768x1024 );     // only ipad1, ipad2, ipad mini1
@prop_readonly( BOOL,				isScreen1536x2048 );

@prop_readonly( CGSize,				screenSize );

- (NSString *)urlSchemaWithName:(NSString *)name;

- (BOOL)isOsVersionOrEarlier:(NSString *)ver;
- (BOOL)isOsVersionOrLater:(NSString *)ver;
- (BOOL)isOsVersionEqualTo:(NSString *)ver;

- (BOOL)isScreenSizeSmallerThan:(CGSize)size;
- (BOOL)isScreenSizeBiggerThan:(CGSize)size;
- (BOOL)isScreenSizeEqualTo:(CGSize)size;

@end
