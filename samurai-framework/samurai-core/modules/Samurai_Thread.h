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

#undef	dispatch_async_foreground
#define dispatch_async_foreground( block ) \
		dispatch_async( dispatch_get_main_queue(), block )

#undef	dispatch_async_background
#define dispatch_async_background( block ) \
		dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), block )

#undef	dispatch_after_foreground
#define dispatch_after_foreground( seconds, block ) \
		{ \
			dispatch_time_t __time = dispatch_time( DISPATCH_TIME_NOW, seconds * 1ull * NSEC_PER_SEC ); \
			dispatch_after( __time, dispatch_get_main_queue(), block ); \
		}

#undef	dispatch_after_background
#define dispatch_after_background( seconds, block ) \
		{ \
			dispatch_time_t __time = dispatch_time( DISPATCH_TIME_NOW, seconds * 1ull * NSEC_PER_SEC ); \
			dispatch_after( __time, dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), block ); \
		}

#undef	dispatch_barrier_async_foreground
#define dispatch_barrier_async_foreground( seconds, block ) \
		dispatch_barrier_async( dispatch_get_main_queue(), block )

#undef	dispatch_barrier_async_background
#define dispatch_barrier_async_background( seconds, block ) \
		dispatch_barrier_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), block )

#pragma mark -

@protocol NSLockProtocol <NSObject>
@optional
- (void)lock;
- (void)unlock;
@end
