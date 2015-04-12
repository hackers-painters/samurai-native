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

#import "Samurai_Runtime.h"
#import "Samurai_Log.h"
#import "Samurai_UnitTest.h"

#import "NSArray+Extension.h"
#import "NSMutableArray+Extension.h"

#import "_pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSObject(Runtime)

+ (NSArray *)loadedClassNames
{
	static dispatch_once_t		once;
	static NSMutableArray *		classNames;
	
	dispatch_once( &once, ^
	{
		classNames = [[NSMutableArray alloc] init];

		unsigned int 	classesCount = 0;
        Class *		classes = objc_copyClassList( &classesCount );

		for ( unsigned int i = 0; i < classesCount; ++i )
		{
			Class classType = classes[i];
			
			if ( class_isMetaClass( classType ) )
				continue;
			
			Class superClass = class_getSuperclass( classType );
			
			if ( nil == superClass )
				continue;

			[classNames addObject:[NSString stringWithUTF8String:class_getName(classType)]];
		}

		[classNames sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		  return [obj1 compare:obj2];
		}];

		free( classes );
	});
	
	return classNames;
}

+ (NSArray *)subClasses
{
	NSMutableArray * results = [[NSMutableArray alloc] init];

	for ( NSString * className in [self loadedClassNames] )
	{
		Class classType = NSClassFromString( className );
		if ( classType == self )
			continue;

		if ( NO == [classType isSubclassOfClass:self] )
			continue;

		[results addObject:[classType description]];
	}
	
	return results;
}


+ (NSArray *)methods
{
	NSMutableArray * methodNames = [[NSMutableArray alloc] init];
		
	Class thisClass = self;
	
	while ( NULL != thisClass )
	{
		unsigned int	methodCount = 0;
		Method *		methodList = class_copyMethodList( thisClass, &methodCount );

		for ( unsigned int i = 0; i < methodCount; ++i )
		{
			SEL selector = method_getName( methodList[i] );
			if ( selector )
			{
				const char * cstrName = sel_getName(selector);
				if ( NULL == cstrName )
					continue;
				
				NSString * selectorName = [NSString stringWithUTF8String:cstrName];
				if ( NULL == selectorName )
					continue;

				[methodNames addObject:selectorName];
			}
		}
		
		free( methodList );

		thisClass = class_getSuperclass( thisClass );
		if ( thisClass == [NSObject class] )
		{
			break;
		}
	}

	return methodNames;
}

+ (NSArray *)methodsWithPrefix:(NSString *)prefix
{
	NSArray * methods = [self methods];
	
	if ( nil == methods || 0 == methods.count )
	{
		return nil;
	}
	
	if ( nil == prefix )
	{
		return methods;
	}
	
	NSMutableArray * result = [[NSMutableArray alloc] init];
	
	for ( NSString * selectorName in methods )
	{
		if ( NO == [selectorName hasPrefix:prefix] )
		{
			continue;
		}
		
		[result addObject:selectorName];
	}
	
	[result sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		return [obj1 compare:obj2];
	}];
	
	return result;
}

+ (void *)replaceSelector:(SEL)sel1 withSelector:(SEL)sel2
{
	Method method = class_getInstanceMethod( self, sel1 );

	IMP implement = (IMP)method_getImplementation( method );
	IMP implement2 = class_getMethodImplementation( self, sel2 );
	
	method_setImplementation( method, implement2 );
	
	return (void *)implement;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( Core, Runtime )
{
	
}
TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#import "_pragma_pop.h"
