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
	LogLevel_Error = 0,
	LogLevel_Warn,
	LogLevel_Info,
	LogLevel_Perf,
	LogLevel_All
} LogLevel;

#pragma mark -

#if __SAMURAI_LOGGING__

#if __SAMURAI_DEBUG__

	#define INFO( ... )			[[SamuraiLogger sharedInstance] file:@(__FILE__) line:__LINE__ func:@(__PRETTY_FUNCTION__) level:LogLevel_Info format:__VA_ARGS__];
	#define PERF( ... )			[[SamuraiLogger sharedInstance] file:@(__FILE__) line:__LINE__ func:@(__PRETTY_FUNCTION__) level:LogLevel_Perf format:__VA_ARGS__];
	#define WARN( ... )			[[SamuraiLogger sharedInstance] file:@(__FILE__) line:__LINE__ func:@(__PRETTY_FUNCTION__) level:LogLevel_Warn format:__VA_ARGS__];
	#define ERROR( ... )		[[SamuraiLogger sharedInstance] file:@(__FILE__) line:__LINE__ func:@(__PRETTY_FUNCTION__) level:LogLevel_Error format:__VA_ARGS__];
	#define PRINT( ... )		[[SamuraiLogger sharedInstance] file:@(__FILE__) line:__LINE__ func:@(__PRETTY_FUNCTION__) level:LogLevel_All format:__VA_ARGS__];

#else

	#define INFO( ... )			[[SamuraiLogger sharedInstance] file:nil line:0 func:nil level:LogLevel_Info format:__VA_ARGS__];
	#define PERF( ... )			[[SamuraiLogger sharedInstance] file:nil line:0 func:nil level:LogLevel_Perf format:__VA_ARGS__];
	#define WARN( ... )			[[SamuraiLogger sharedInstance] file:nil line:0 func:nil level:LogLevel_Warn format:__VA_ARGS__];
	#define ERROR( ... )		[[SamuraiLogger sharedInstance] file:nil line:0 func:nil level:LogLevel_Error format:__VA_ARGS__];
	#define PRINT( ... )		[[SamuraiLogger sharedInstance] file:nil line:0 func:nil level:LogLevel_All format:__VA_ARGS__];

#endif

#else

	#define INFO( ... )
	#define PERF( ... )
	#define WARN( ... )
	#define ERROR( ... )
	#define PRINT( ... )

#endif

#undef	VAR_DUMP
#define VAR_DUMP( __obj )	PRINT( [__obj description] );

#undef	OBJ_DUMP
#define OBJ_DUMP( __obj )	PRINT( [__obj objectToDictionary] );

#pragma mark -

@interface SamuraiLogger : NSObject

@singleton( SamuraiLogger );

@prop_assign( BOOL,					enabled );

@prop_strong( NSMutableString *,	output );
@prop_strong( NSMutableArray *,		buffer );
@prop_assign( LogLevel,				filter );

@prop_copy( BlockType,				outputHandler );

- (void)toggle;
- (void)enable;
- (void)disable;

- (void)indent;
- (void)indent:(NSUInteger)tabs;
- (void)unindent;
- (void)unindent:(NSUInteger)tabs;

- (void)outputCapture;
- (void)outputRelease;

- (void)file:(NSString *)file line:(NSUInteger)line func:(NSString *)func level:(LogLevel)level format:(NSString *)format, ...;
- (void)file:(NSString *)file line:(NSUInteger)line func:(NSString *)func level:(LogLevel)level format:(NSString *)format args:(va_list)args;

- (void)flush;

@end
