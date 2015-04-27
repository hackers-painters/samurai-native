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

// main

#undef	dispatch_async_foreground
#define dispatch_async_foreground( block ) \
        dispatch_async( dispatch_get_main_queue(), block )

#undef	dispatch_after_foreground
#define dispatch_after_foreground( seconds, block ) \
		dispatch_after( dispatch_time( DISPATCH_TIME_NOW, seconds * 1ull * NSEC_PER_SEC ), dispatch_get_main_queue(), block ); \

#undef	dispatch_barrier_async_foreground
#define dispatch_barrier_async_foreground( seconds, block ) \
		dispatch_barrier_async( [SamuraiQueue sharedInstance].concurrent, ^{ \
			dispatch_async_foreground( block ); \
		});

// concurrent

#undef	dispatch_async_background_concurrent
#define dispatch_async_background_concurrent( block ) \
        dispatch_async( [SamuraiQueue sharedInstance].concurrent, block )

#undef	dispatch_after_background_concurrent
#define dispatch_after_background_concurrent( seconds, block ) \
		dispatch_after( dispatch_time( DISPATCH_TIME_NOW, seconds * 1ull * NSEC_PER_SEC ), [SamuraiQueue sharedInstance].concurrent, block ); \

#undef	dispatch_barrier_async_background_concurrent
#define dispatch_barrier_async_background_concurrent( seconds, block ) \
		dispatch_barrier_async( [SamuraiQueue sharedInstance].concurrent, block )

// serial

#undef	dispatch_async_background_serial
#define dispatch_async_background_serial( block ) \
		dispatch_async( [SamuraiQueue sharedInstance].serial, block )

#undef	dispatch_after_background_serial
#define dispatch_after_background_serial( seconds, block ) \
		dispatch_after( dispatch_time( DISPATCH_TIME_NOW, seconds * 1ull * NSEC_PER_SEC ), [SamuraiQueue sharedInstance].serial, block ); \

#pragma mark -

@interface SamuraiQueue : NSObject

@singleton( SamuraiQueue )

@prop_readonly( dispatch_queue_t,	serial );
@prop_readonly( dispatch_queue_t,	concurrent );

@end

#pragma mark -

@protocol NSLockProtocol <NSObject>
@optional
- (void)lock;
- (void)unlock;
@end
