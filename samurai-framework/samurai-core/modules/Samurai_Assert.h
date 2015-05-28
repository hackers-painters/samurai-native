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

#if __SAMURAI_DEBUG__

#define ASSERT( __expr ) [[SamuraiAsserter sharedInstance] file:__FILE__ line:__LINE__ func:__PRETTY_FUNCTION__ flag:((__expr) ? YES : NO) expr:#__expr];

#else

#define ASSERT( __expr )

#endif

#pragma mark -

/**
 *  「武士」·「斷言」
 */

@interface SamuraiAsserter : NSObject

@singleton( SamuraiAsserter );

@prop_assign( BOOL,	enabled );

/**
 *  若已開啟則關閉，若已關閉則開啟
 */

- (void)toggle;

/**
 *  開啟，使之有效
 */

- (void)enable;

/**
 *  關閉，使之失效
 */

- (void)disable;

/**
 *  觸發斷言
 *
 *  @param file 文件名稱
 *  @param line 文件行號
 *  @param func 方法名稱
 *  @param flag 斷言結果
 *  @param expr 斷言表達式
 */

- (void)file:(const char *)file line:(NSUInteger)line func:(const char *)func flag:(BOOL)flag expr:(const char *)expr;

@end

#pragma mark -

#if __cplusplus
extern "C" {
#endif
	
/**
 *  觸發斷言 · C語言方式
 *
 *  @param file 文件名稱
 *  @param line 文件行號
 *  @param func 方法名稱
 *  @param flag 斷言結果
 *  @param expr 斷言表達式
 */

void SamuraiAssert( const char * file, NSUInteger line, const char * func, BOOL flag, const char * expr );

#if __cplusplus
}
#endif
