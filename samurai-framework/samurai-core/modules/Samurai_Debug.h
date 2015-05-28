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

	#if defined(__ppc__)

		#undef	TRAP
		#define TRAP()			asm("trap");

	#elif defined(__i386__) ||  defined(__amd64__)

		#undef	TRAP
		#define TRAP()			asm("int3");

	#else

		#undef	TRAP
		#define TRAP()

	#endif

#else

	#undef	TRAP
	#define TRAP()

#endif

#undef	TRAP_
#define TRAP_( expr )	if ( expr ) { TRAP; };

#pragma mark -

#undef	TRACE
#define TRACE()			[[SamuraiDebugger sharedInstance] trace];

#pragma mark -

typedef enum
{
	CallFrameType_Unknown = 0,	/// 未知調用棧類型
	CallFrameType_ObjectC = 0,	/// Objective-C
	CallFrameType_NativeC = 0,	/// C
} CallFrameType;

#pragma mark -

@interface NSObject(Debug)

- (void)dump;

@end

#pragma mark -

/**
 *  「武士」·「調用棧」
 */

@interface SamuraiCallFrame : NSObject

@prop_assign( CallFrameType,	type );
@prop_strong( NSString *,		process );
@prop_assign( NSUInteger,		entry );
@prop_assign( NSUInteger,		offset );
@prop_strong( NSString *,		clazz );
@prop_strong( NSString *,		method );

/**
 *  解析原始調用棧数据
 *
 *  @param line 调用栈原始数据
 *
 *  @return 調用棧對象
 */

+ (id)parse:(NSString *)line;

/**
 *  创建调用栈对象
 *
 *  @return 调用栈对象
 */

+ (id)unknown;

@end

#pragma mark -

/**
 *  「武士」·「調試器」
 */

@interface SamuraiDebugger : NSObject

@singleton(SamuraiDebugger)

@prop_readonly( NSArray *,	callstack );

/**
 *  獲取調用棧（當前線程）
 *
 *  @return 調用棧對象數組
 */

- (NSArray *)callstack;

/**
 *  @brief 獲取調用棧（當前線程）
 *
 *  @param depth 最大棧深
 *
 *  @return 調用棧對象數組
 */

- (NSArray *)callstack:(NSInteger)depth;

/**
 *  軟件斷點
 */

- (void)trap;

/**
 *  打印調用棧
 */

- (void)trace;

/**
 *  打印調用棧
 *
 *  @param depth 最大棧深
 */

- (void)trace:(NSInteger)depth;

@end
