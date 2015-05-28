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
	EncodingType_Unknown = 0,
	EncodingType_Null,
	EncodingType_Number,
	EncodingType_String,
	EncodingType_Date,
	EncodingType_Data,
	EncodingType_Url,
	EncodingType_Array,
	EncodingType_Dict
} EncodingType;

#pragma mark -

@interface NSObject(Encoding)

/**
 *  對象編碼
 *
 *  @param type 目標編碼類型
 *
 *  @return 編碼後的對象
 */

- (NSObject *)converToType:(EncodingType)type;

@end

#pragma mark -

/**
 *  「武士」·「編碼器」
 */

@interface SamuraiEncoding : NSObject

/**
 *  判斷對象屬性是否為只讀？
 *
 *  @param attr 屬性名稱
 *
 *  @return YES或NO
 */

+ (BOOL)isReadOnly:(const char *)attr;

+ (EncodingType)typeOfAttribute:(const char *)attr;
+ (EncodingType)typeOfClassName:(const char *)clazz;
+ (EncodingType)typeOfClass:(Class)clazz;
+ (EncodingType)typeOfObject:(id)obj;

+ (NSString *)classNameOfAttribute:(const char *)attr;
+ (NSString *)classNameOfClass:(Class)clazz;
+ (NSString *)classNameOfObject:(id)obj;

+ (Class)classOfAttribute:(const char *)attr;

+ (BOOL)isAtomAttribute:(const char *)attr;
+ (BOOL)isAtomClassName:(const char *)clazz;
+ (BOOL)isAtomClass:(Class)clazz;
+ (BOOL)isAtomObject:(id)obj;

@end
