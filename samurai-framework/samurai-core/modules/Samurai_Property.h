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

#undef	static_property
#define static_property( __name ) \
		property (nonatomic, readonly) NSString * __name; \
		- (NSString *)__name; \
		+ (NSString *)__name;

#undef	def_static_property
#define def_static_property( __name, ... ) \
		macro_concat(def_static_property, macro_count(__VA_ARGS__))(__name, __VA_ARGS__)

#undef	def_static_property0
#define def_static_property0( __name ) \
		dynamic __name; \
		- (NSString *)__name { return [NSString stringWithFormat:@"%s", #__name]; } \
		+ (NSString *)__name { return [NSString stringWithFormat:@"%s", #__name]; }

#undef	def_static_property1
#define def_static_property1( __name, A ) \
		dynamic __name; \
		- (NSString *)__name { return [NSString stringWithFormat:@"%@.%s", A, #__name]; } \
		+ (NSString *)__name { return [NSString stringWithFormat:@"%@.%s", A, #__name]; }

#undef	def_static_property2
#define def_static_property2( __name, A, B ) \
		dynamic __name; \
		- (NSString *)__name { return [NSString stringWithFormat:@"%@.%@.%s", A, B, #__name]; } \
		+ (NSString *)__name { return [NSString stringWithFormat:@"%@.%@.%s", A, B, #__name]; }

#undef	def_static_property3
#define def_static_property3( __name, A, B, C ) \
		dynamic __name; \
		- (NSString *)__name { return [NSString stringWithFormat:@"%@.%@.%@.%s", A, B, C, #__name]; } \
		+ (NSString *)__name { return [NSString stringWithFormat:@"%@.%@.%@.%s", A, B, C, #__name]; }

#undef	alias_static_property
#define alias_static_property( __name, __alias ) \
		dynamic __name; \
		- (NSString *)__name { return __alias; } \
		+ (NSString *)__name { return __alias; }

#pragma mark -

#undef	integer
#define integer( __name ) \
		property (nonatomic, readonly) NSInteger __name; \
		- (NSInteger)__name; \
		+ (NSInteger)__name;

#undef	def_integer
#define def_integer( __name, __value ) \
		dynamic __name; \
		- (NSInteger)__name { return __value; } \
		+ (NSInteger)__name { return __value; }

#pragma mark -

#undef	unsigned_integer
#define unsigned_integer( __name ) \
		property (nonatomic, readonly) NSUInteger __name; \
		- (NSUInteger)__name; \
		+ (NSUInteger)__name;

#undef	def_unsigned_integer
#define def_unsigned_integer( __name, __value ) \
		dynamic __name; \
		- (NSUInteger)__name { return __value; } \
		+ (NSUInteger)__name { return __value; }

#pragma mark -

#undef	number
#define number( __name ) \
		property (nonatomic, readonly) NSNumber * __name; \
		- (NSNumber *)__name; \
		+ (NSNumber *)__name;

#undef	def_number
#define def_number( __name, __value ) \
		dynamic __name; \
		- (NSNumber *)__name { return @(__value); } \
		+ (NSNumber *)__name { return @(__value); }

#pragma mark -

#undef	string
#define string( __name ) \
		property (nonatomic, readonly) NSString * __name; \
		- (NSString *)__name; \
		+ (NSString *)__name;

#undef	def_string
#define def_string( __name, __value ) \
		dynamic __name; \
		- (NSString *)__name { return __value; } \
		+ (NSString *)__name { return __value; }

#pragma mark -

#if __has_feature(objc_arc)

#define	prop_readonly( type, name )		property (nonatomic, readonly) type name;
#define	prop_dynamic( type, name )		property (nonatomic, strong) type name;
#define	prop_assign( type, name )		property (nonatomic, assign) type name;
#define	prop_strong( type, name )		property (nonatomic, strong) type name;
#define	prop_weak( type, name )			property (nonatomic, weak) type name;
#define	prop_copy( type, name )			property (nonatomic, copy) type name;
#define	prop_unsafe( type, name )		property (nonatomic, unsafe_unretained) type name;

#else

#define	prop_readonly( type, name )		property (nonatomic, readonly) type name;
#define	prop_dynamic( type, name )		property (nonatomic, retain) type name;
#define	prop_assign( type, name )		property (nonatomic, assign) type name;
#define	prop_strong( type, name )		property (nonatomic, retain) type name;
#define	prop_weak( type, name )			property (nonatomic, assign) type name;
#define	prop_copy( type, name )			property (nonatomic, copy) type name;
#define	prop_unsafe( type, name )		property (nonatomic, assign) type name;

#endif

#define prop_retype( type, name )		property type name;

#pragma mark -

#define def_prop_readonly( type, name, ... ) \
		synthesize name = _##name; \
		+ (NSString *)property_##name { return macro_string( macro_join(__VA_ARGS__) ); }

#define def_prop_assign( type, name, ... ) \
		synthesize name = _##name; \
		+ (NSString *)property_##name { return macro_string( macro_join(__VA_ARGS__) ); }

#define def_prop_strong( type, name, ... ) \
		synthesize name = _##name; \
		+ (NSString *)property_##name { return macro_string( macro_join(__VA_ARGS__) ); }

#define def_prop_weak( type, name, ... ) \
		synthesize name = _##name; \
		+ (NSString *)property_##name { return macro_string( macro_join(__VA_ARGS__) ); }

#define def_prop_unsafe( type, name, ... ) \
		synthesize name = _##name; \
		+ (NSString *)property_##name { return macro_string( macro_join(__VA_ARGS__) ); }

#define def_prop_copy( type, name, ... ) \
		synthesize name = _##name; \
		+ (NSString *)property_##name { return macro_string( macro_join(__VA_ARGS__) ); }

#define def_prop_dynamic( type, name, ... ) \
		dynamic name; \
		+ (NSString *)property_##name { return macro_string( macro_join(__VA_ARGS__) ); }

#define def_prop_dynamic_copy( type, name, setName, ... ) \
		def_prop_custom( type, name, setName, copy ) \
		+ (NSString *)property_##name { return macro_string( macro_join(__VA_ARGS__) ); }

#define def_prop_dynamic_strong( type, name, setName, ... ) \
		def_prop_custom( type, name, setName, retain ) \
		+ (NSString *)property_##name { return macro_string( macro_join(__VA_ARGS__) ); }

#define def_prop_dynamic_unsafe( type, name, setName, ... ) \
		def_prop_custom( type, name, setName, assign ) \
		+ (NSString *)property_##name { return macro_string( macro_join(__VA_ARGS__) ); }

#define def_prop_dynamic_weak( type, name, setName, ... ) \
		def_prop_custom( type, name, setName, assign ) \
		+ (NSString *)property_##name { return macro_string( macro_join(__VA_ARGS__) ); }

#define def_prop_dynamic_pod( type, name, setName, pod_type ... ) \
		dynamic name; \
		- (type)name { return (type)[[self getAssociatedObjectForKey:#name] pod_type##Value]; } \
		- (void)setName:(type)obj { [self assignAssociatedObject:@((pod_type)obj) forKey:#name]; } \
		+ (NSString *)property_##name { return macro_string( macro_join(__VA_ARGS__) ); }

#define def_prop_custom( type, name, setName, attr ) \
		dynamic name; \
		- (type)name { return [self getAssociatedObjectForKey:#name]; } \
		- (void)setName:(type)obj { [self attr##AssociatedObject:obj forKey:#name]; }

#pragma mark -

@interface NSObject(Property)

+ (const char *)attributesForProperty:(NSString *)property;
- (const char *)attributesForProperty:(NSString *)property;

+ (NSDictionary *)extentionForProperty:(NSString *)property;
- (NSDictionary *)extentionForProperty:(NSString *)property;

+ (NSString *)extentionForProperty:(NSString *)property stringValueWithKey:(NSString *)key;
- (NSString *)extentionForProperty:(NSString *)property stringValueWithKey:(NSString *)key;

+ (NSArray *)extentionForProperty:(NSString *)property arrayValueWithKey:(NSString *)key;
- (NSArray *)extentionForProperty:(NSString *)property arrayValueWithKey:(NSString *)key;

- (id)getAssociatedObjectForKey:(const char *)key;
- (id)copyAssociatedObject:(id)obj forKey:(const char *)key;
- (id)retainAssociatedObject:(id)obj forKey:(const char *)key;
- (id)assignAssociatedObject:(id)obj forKey:(const char *)key;
- (void)removeAssociatedObjectForKey:(const char *)key;
- (void)removeAllAssociatedObjects;

@end
