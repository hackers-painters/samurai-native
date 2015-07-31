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

// ----------------------------------
// Version
// ----------------------------------

#define __MUST_ON__		(1)
#define __MUST_OFF__	(0)

#define __ON__			(1)
#define __OFF__			(0)
#define __AUTO__		(DEBUG)

// ----------------------------------
// Unix include headers
// ----------------------------------

#import <stdio.h>
#import <stdlib.h>
#import <stdint.h>
#import <string.h>
#import <assert.h>
#import <errno.h>

#import <sys/errno.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <sys/types.h>
#import <sys/socket.h>
#import <sys/stat.h>
#import <sys/mman.h>

#import <math.h>
#import <unistd.h>
#import <limits.h>
#import <execinfo.h>

#import <netdb.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>

#import <mach/mach.h>
#import <mach/machine.h>
#import <machine/endian.h>
#import <malloc/malloc.h>

#import <sys/utsname.h>

#import <fcntl.h>
#import <dirent.h>
#import <dlfcn.h>
#import <spawn.h>

#import <mach-o/fat.h>
#import <mach-o/dyld.h>
#import <mach-o/arch.h>
#import <mach-o/nlist.h>
#import <mach-o/loader.h>
#import <mach-o/getsect.h>

#import <zlib.h>
//#import <libxml2/libxml/HTMLparser.h>
//#import <libxml2/libxml/tree.h>
//#import <libxml2/libxml/xpath.h>

#ifdef __IPHONE_8_0
#import <spawn.h>
#endif

// ----------------------------------
// Mac/iOS include headers
// ----------------------------------

#ifdef __OBJC__

	#import <Availability.h>
	#import <Foundation/Foundation.h>

	#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

	#import <UIKit/UIKit.h>
	#import <UIKit/UIGestureRecognizerSubclass.h>
	#import <CoreText/CoreText.h>
	#import <Foundation/Foundation.h>
	#import <QuartzCore/QuartzCore.h>
	#import <AudioToolbox/AudioToolbox.h>
	#import <TargetConditionals.h>
	#import <AssetsLibrary/AssetsLibrary.h>
	#import <SystemConfiguration/SystemConfiguration.h>

	#import <AVFoundation/AVFoundation.h>
	#import <CoreGraphics/CoreGraphics.h>
	#import <CoreVideo/CoreVideo.h>
	#import <CoreMedia/CoreMedia.h>
	#import <CoreImage/CoreImage.h>
	#import <CoreLocation/CoreLocation.h>

	#import <objc/runtime.h>
	#import <objc/message.h>
	#import <dlfcn.h>

	#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

	#import <Cocoa/Cocoa.h>
	#import <AppKit/AppKit.h>
	#import <WebKit/WebKit.h>

	#import <objc/objc-class.h>

	#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import <CommonCrypto/CommonDigest.h>

#endif	// #ifdef __OBJC__

// ----------------------------------
// Common use macros
// ----------------------------------

#ifndef	IN
#define IN
#endif

#ifndef	OUT
#define OUT
#endif

#ifndef	INOUT
#define INOUT
#endif

#ifndef	UNUSED
#define	UNUSED( __x )		{ id __unused_var__ __attribute__((unused)) = (id)(__x); }
#endif

#ifndef	ALIAS
#define	ALIAS( __a, __b )	__typeof__(__a) __b = __a;
#endif

#ifndef	DEPRECATED
#define	DEPRECATED			__attribute__((deprecated))
#endif

#ifndef	TODO
#define TODO( X )			_Pragma(macro_cstr(message("TODO: " X)))
#endif

#ifndef	EXTERN_C
#if defined(__cplusplus)
#define EXTERN_C			extern "C"
#else
#define EXTERN_C			extern
#endif
#endif

#ifndef	INLINE
#define	INLINE				__inline__ __attribute__((always_inline))
#endif

// ----------------------------------
// Custom keywords
// ----------------------------------

#undef	var
#define var	NSObject *

#if !defined(__clang__) || __clang_major__ < 3

	#ifndef __bridge
	#define __bridge
	#endif

	#ifndef __bridge_retain
	#define __bridge_retain
	#endif

	#ifndef __bridge_retained
	#define __bridge_retained
	#endif

	#ifndef __autoreleasing
	#define __autoreleasing
	#endif

	#ifndef __strong
	#define __strong
	#endif

	#ifndef __unsafe_unretained
	#define __unsafe_unretained
	#endif

	#ifndef __weak
	#define __weak
	#endif

#endif	// #if !defined(__clang__) || __clang_major__ < 3

// ----------------------------------
// Code block
// ----------------------------------

#ifndef	weakify
#if __has_feature(objc_arc)

#define weakify( x ) \
		_Pragma("clang diagnostic push") \
		_Pragma("clang diagnostic ignored \"-Wshadow\"") \
		autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x; \
		_Pragma("clang diagnostic pop")

#else

#define weakify( x ) \
		_Pragma("clang diagnostic push") \
		_Pragma("clang diagnostic ignored \"-Wshadow\"") \
		autoreleasepool{} __block __typeof__(x) __block_##x##__ = x; \
		_Pragma("clang diagnostic pop")

#endif
#endif

#ifndef	strongify
#if __has_feature(objc_arc)

#define strongify( x ) \
		_Pragma("clang diagnostic push") \
		_Pragma("clang diagnostic ignored \"-Wshadow\"") \
		try{} @finally{} __typeof__(x) x = __weak_##x##__; \
		_Pragma("clang diagnostic pop")

#else

#define strongify( x ) \
		_Pragma("clang diagnostic push") \
		_Pragma("clang diagnostic ignored \"-Wshadow\"") \
		try{} @finally{} __typeof__(x) x = __block_##x##__; \
		_Pragma("clang diagnostic pop")

#endif
#endif

typedef id		BlockType;
typedef void (^ BlockTypeVoid )( void );
typedef void (^ BlockTypeVarg )( id first, ... );

// ----------------------------------
// Meta macro
// ----------------------------------

#define macro_first(...)									macro_first_( __VA_ARGS__, 0 )
#define macro_first_( A, ... )								A

#define macro_concat( A, B )								macro_concat_( A, B )
#define macro_concat_( A, B )								A##B

#define macro_count(...)									macro_at( 8, __VA_ARGS__, 8, 7, 6, 5, 4, 3, 2, 1 )
#define macro_more(...)										macro_at( 8, __VA_ARGS__, 1, 1, 1, 1, 1, 1, 1, 1 )

#define macro_at0(...)										macro_first(__VA_ARGS__)
#define macro_at1(_0, ...)									macro_first(__VA_ARGS__)
#define macro_at2(_0, _1, ...)								macro_first(__VA_ARGS__)
#define macro_at3(_0, _1, _2, ...)							macro_first(__VA_ARGS__)
#define macro_at4(_0, _1, _2, _3, ...)						macro_first(__VA_ARGS__)
#define macro_at5(_0, _1, _2, _3, _4 ...)					macro_first(__VA_ARGS__)
#define macro_at6(_0, _1, _2, _3, _4, _5 ...)				macro_first(__VA_ARGS__)
#define macro_at7(_0, _1, _2, _3, _4, _5, _6 ...)			macro_first(__VA_ARGS__)
#define macro_at8(_0, _1, _2, _3, _4, _5, _6, _7, ...)		macro_first(__VA_ARGS__)
#define macro_at(N, ...)									macro_concat(macro_at, N)( __VA_ARGS__ )

#define macro_join0( ... )
#define macro_join1( A )									A
#define macro_join2( A, B )									A##____##B
#define macro_join3( A, B, C )								A##____##B##____##C
#define macro_join4( A, B, C, D )							A##____##B##____##C##____##D
#define macro_join5( A, B, C, D, E )						A##____##B##____##C##____##D##____##E
#define macro_join6( A, B, C, D, E, F )						A##____##B##____##C##____##D##____##E##____##F
#define macro_join7( A, B, C, D, E, F, G )					A##____##B##____##C##____##D##____##E##____##F##____##G
#define macro_join8( A, B, C, D, E, F, G, H )				A##____##B##____##C##____##D##____##E##____##F##____##G##____##H
#define macro_join( ... )									macro_concat(macro_join, macro_count(__VA_ARGS__))(__VA_ARGS__)

#define macro_cstr( A )										macro_cstr_( A )
#define macro_cstr_( A )									#A

#define macro_string( A )									macro_string_( A )
#define macro_string_( A )									@(#A)
