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
#import "Samurai_Property.h"

#pragma mark -

#undef	BASE_CLASS
#define BASE_CLASS( __class ) \
		+ (Class)baseClass \
		{ \
			return NSClassFromString( @(#__class) ); \
		}

#undef	CONVERT_CLASS
#define	CONVERT_CLASS( __name, __class ) \
		+ (Class)convertClass_##__name \
		{ \
			return NSClassFromString( @(#__class) ); \
		}

#pragma mark -

@interface NSObject(Extension)

+ (Class)baseClass;

+ (id)unserializeForUnknownValue:(id)value;
+ (id)serializeForUnknownValue:(id)value;

- (void)deepEqualsTo:(id)obj;
- (void)deepCopyFrom:(id)obj;

+ (id)unserialize:(id)obj;
+ (id)unserialize:(id)obj withClass:(Class)clazz;

- (id)JSONEncoded;
- (id)JSONDecoded;

- (BOOL)toBool;
- (float)toFloat;
- (double)toDouble;
- (NSInteger)toInteger;
- (NSUInteger)toUnsignedInteger;

- (NSURL *)toURL;
- (NSDate *)toDate;
- (NSData *)toData;
- (NSNumber *)toNumber;
- (NSString *)toString;

- (id)clone;					// override point
- (id)serialize;				// override point
- (void)unserialize:(id)obj;	// override point
- (void)zerolize;				// override point

@end
