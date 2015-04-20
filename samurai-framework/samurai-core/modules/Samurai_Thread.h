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

// 主队列
#undef	dispatch_async_foreground
#define dispatch_async_foreground( block ) \
        dispatch_async( dispatch_get_main_queue(), block )

#undef	dispatch_after_foreground
#define dispatch_after_foreground( seconds, block ) \
        { \
            dispatch_time_t __time = dispatch_time( DISPATCH_TIME_NOW, seconds * 1ull * NSEC_PER_SEC ); \
            dispatch_after( __time, dispatch_get_main_queue(), block ); \
        }

// 自己建的后台并行队列
#undef	dispatch_async_background
#define dispatch_async_background( block )      dispatch_async_background_concurrent( block )

#undef	dispatch_async_background_concurrent
#define dispatch_async_background_concurrent( block ) \
        dispatch_async( [SamuraiGCD sharedInstance].backConcurrentQueue, block )

#undef	dispatch_after_background_concurrent
#define dispatch_after_background_concurrent( seconds, block ) \
        { \
            dispatch_time_t __time = dispatch_time( DISPATCH_TIME_NOW, seconds * 1ull * NSEC_PER_SEC ); \
            dispatch_after( __time, [SamuraiGCD sharedInstance].backConcurrentQueue, block ); \
        }

// 自己建的后台串行队列
#undef	dispatch_async_background_serial
#define dispatch_async_background_serial( block ) \
    dispatch_async( [SamuraiGCD sharedInstance].backSerialQueue, block )

#undef	dispatch_after_background_serial
#define dispatch_after_background_serial( seconds, block ) \
    { \
        dispatch_time_t __time = dispatch_time( DISPATCH_TIME_NOW, seconds * 1ull * NSEC_PER_SEC ); \
        dispatch_after( __time, [SamuraiGCD sharedInstance].backSerialQueue, block ); \
    }

// 自己建写的文件用的串行队列
#undef	dispatch_async_background_writeFile
#define dispatch_async_background_writeFile( block ) \
        dispatch_async( [SamuraiGCD sharedInstance].writeFileQueue, block )


// barrier
#undef	dispatch_barrier_async_foreground
#define dispatch_barrier_async_foreground( seconds, block ) \
        dispatch_barrier_async( [SamuraiGCD sharedInstance].backConcurrentQueue, ^{   \
            dispatch_async_foreground( block );   \
        });

#undef	dispatch_barrier_async_background_concurrent
#define dispatch_barrier_async_background_concurrent( seconds, block ) \
        dispatch_barrier_async( [SamuraiGCD sharedInstance].backConcurrentQueue, block )

#pragma mark -
@interface SamuraiGCD : NSObject

@singleton( SamuraiGCD )

@prop_readonly(dispatch_queue_t,			foreQueue );
@prop_readonly(dispatch_queue_t,			backSerialQueue );
@prop_readonly(dispatch_queue_t,			backConcurrentQueue );
@prop_readonly(dispatch_queue_t,			writeFileQueue );

@end
#pragma mark -

@protocol NSLockProtocol <NSObject>
@optional
- (void)lock;
- (void)unlock;
@end
