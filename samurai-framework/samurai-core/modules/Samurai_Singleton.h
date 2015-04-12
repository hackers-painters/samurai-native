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

#pragma mark -

#undef	singleton
#define singleton( __class ) \
		property (nonatomic, readonly) __class * sharedInstance; \
		- (__class *)sharedInstance; \
		+ (__class *)sharedInstance;

#undef	def_singleton
#define def_singleton( __class ) \
		dynamic sharedInstance; \
		- (__class *)sharedInstance \
		{ \
			return [__class sharedInstance]; \
		} \
		+ (__class *)sharedInstance \
		{ \
			static dispatch_once_t once; \
			static __strong id __singleton__ = nil; \
			dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
			return __singleton__; \
		}

#pragma mark -

@interface NSObject(Singleton)

+ (id)sharedInstance;
- (id)sharedInstance;

+ (id)sharedInstanceOrNew;
- (id)sharedInstanceOrNew;

@end
