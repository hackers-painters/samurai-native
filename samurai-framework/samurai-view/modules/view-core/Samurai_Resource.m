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

#import "Samurai_Resource.h"
#import "Samurai_App.h"
#import "Samurai_Watcher.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiResource

@def_prop_assign( ResourcePolicy,	resPolicy );
@def_prop_strong( NSString *,		resPath );
@def_prop_strong( NSString *,		resType );
@def_prop_strong( NSString *,		resContent );

BASE_CLASS( SamuraiResource )

#pragma mark -

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.resPolicy = ResourcePolicy_Default;
	}
	return self;
}

- (void)dealloc
{
	self.resPath = nil;
	self.resType = nil;
	self.resContent = nil;
}

#pragma mark -

+ (Class)instanceClassForType:(NSString *)type
{
	if ( nil == type )
	{
		return self;
	}

	for ( NSString * className in [SamuraiResource subClasses] )
	{
		Class classType = NSClassFromString( className );
		
		if ( classType && [classType supportType:type] )
		{
			return classType;
		}
	}
	
	return nil;
}

+ (Class)instanceClassForExtension:(NSString *)extension
{
	if ( nil == extension )
	{
		return self;
	}

	for ( NSString * className in [SamuraiResource subClasses] )
	{
		Class classType = NSClassFromString( className );
		
		if ( classType && [classType supportExtension:extension] )
		{
			return classType;
		}
	}
	
	return nil;
}

#pragma mark -

+ (id)resource
{
	return [[self alloc] init];
}

+ (id)resourceForType:(NSString *)type
{
	Class resourceClass = [self instanceClassForType:type];
	
	if ( nil == resourceClass )
		return nil;

	return [[resourceClass alloc] init];
}

+ (id)resourceForExtension:(NSString *)extension
{
	Class resourceClass = [self instanceClassForExtension:extension];
	
	if ( nil == resourceClass )
		return nil;
	
	return [[resourceClass alloc] init];
}

+ (id)resourceWithData:(NSData *)data type:(NSString *)type baseURL:(NSString *)baseURL
{
	return [self resourceWithString:[data toString] type:type baseURL:baseURL];
}

+ (id)resourceWithString:(NSString *)string type:(NSString *)type baseURL:(NSString *)baseURL
{
	if ( nil == string || 0 == string.length )
		return nil;
	
	SamuraiResource * resource = [self resourceForType:type];
	if ( nil == resource )
		return nil;

	resource.resPolicy = ResourcePolicy_Default;
	resource.resType = type;
	resource.resPath = baseURL;
	resource.resContent = string;

	BOOL succeed = [resource parse];
	if ( NO == succeed )
		return nil;

	return resource;
}

+ (id)resourceWithURL:(NSString *)string
{
	return [self resourceWithURL:string type:nil];
}

+ (id)resourceWithURL:(NSString *)string type:(NSString *)type
{
	if ( nil == string )
		return nil;
	
	SamuraiResource * resource = nil;
	
	if ( nil == type )
	{
		NSURL * url = [NSURL URLWithString:string];
		if ( nil == url )
			return nil;
		
		NSString * extension = [[url.path lastPathComponent] pathExtension];

		if ( nil == extension || 0 == [extension length] )
		{
			resource = [self resourceForType:@"text/html"];
		}
		else
		{
			resource = [self resourceForExtension:extension];	
		}
	}
	else
	{
		resource = [self resourceForType:type];
	}

	resource.resPolicy = ResourcePolicy_Default;
	resource.resType = nil;
	resource.resPath = string;
	resource.resContent = nil;

	return resource;
}

+ (id)resourceAtPath:(NSString *)path
{
	if ( nil == path )
		return nil;
	
	path = [path stringByStandardizingPath];

	NSString *	pathComponent = [path lastPathComponent];
	NSUInteger	pathDotIndex = [pathComponent rangeOfString:@"."].location;
	
	if ( NSNotFound == pathDotIndex )
	{
		ERROR( @"Unknown resource type" );
		return nil;
	}
	
	NSString *	fileName = [pathComponent substringToIndex:pathDotIndex];
	NSString *	fileExt = [pathComponent substringFromIndex:(pathDotIndex + 1)];
	NSString *	filePath = nil;
	NSString *	fileContent = nil;
	
	if ( nil == fileExt )
	{
		ERROR( @"Unknown resource type" );
		return nil;
	}
	
	SamuraiResource * resource = [self resourceForExtension:fileExt];
	if ( nil == resource )
	{
		ERROR( @"Unknown resource type" );
		return nil;
	}

	NSError * error = nil;
	
	do
	{
	#if TARGET_IPHONE_SIMULATOR
		
		if ( [SamuraiWatcher sharedInstance].sourcePath )
		{
			NSString * srcPath = nil;
			
			if ( [path hasPrefix:[SamuraiWatcher sharedInstance].sourcePath] )
			{
				srcPath = path;
			}
			else
			{
				srcPath = [[[SamuraiWatcher sharedInstance].sourcePath stringByAppendingPathComponent:path] stringByStandardizingPath];
			}
			
			if ( srcPath )
			{
				fileContent = [NSString stringWithContentsOfFile:srcPath encoding:NSUTF8StringEncoding error:&error];
				
				if ( nil == fileContent )
				{
					fileContent = [NSString stringWithContentsOfFile:path encoding:NSISOLatin2StringEncoding error:&error];
				}

				if ( fileContent )
				{
					filePath = srcPath;
					break;
				}
			}
		}
		
	#endif	// #if TARGET_IPHONE_SIMULATOR
		
		NSString * docPath = [[[NSBundle mainBundle] pathForResource:fileName ofType:fileExt inDirectory:[path stringByDeletingLastPathComponent]] stringByStandardizingPath];
		NSString * resPath = [[[NSBundle mainBundle] pathForResource:fileName ofType:fileExt] stringByStandardizingPath];
		NSString * wwwPath = [[[NSBundle mainBundle] pathForResource:fileName ofType:fileExt inDirectory:[[resource class] baseDirectory]] stringByStandardizingPath];

		if ( docPath )
		{
			fileContent = [NSString stringWithContentsOfFile:docPath encoding:NSUTF8StringEncoding error:&error];
			
			if ( nil == fileContent )
			{
				fileContent = [NSString stringWithContentsOfFile:path encoding:NSISOLatin2StringEncoding error:&error];
			}

			if ( fileContent )
			{
				filePath = docPath;
				break;
			}
		}
		
		if ( resPath )
		{
			fileContent = [NSString stringWithContentsOfFile:resPath encoding:NSUTF8StringEncoding error:&error];
			
			if ( nil == fileContent )
			{
				fileContent = [NSString stringWithContentsOfFile:path encoding:NSISOLatin2StringEncoding error:&error];
			}

			if ( fileContent )
			{
				filePath = resPath;
				break;
			}
		}
		
		if ( wwwPath )
		{
			fileContent = [NSString stringWithContentsOfFile:wwwPath encoding:NSUTF8StringEncoding error:&error];
			
			if ( nil == fileContent )
			{
				fileContent = [NSString stringWithContentsOfFile:path encoding:NSISOLatin2StringEncoding error:&error];
			}
			
			if ( fileContent )
			{
				filePath = wwwPath;
				break;
			}
		}
		
		if ( path )
		{
			fileContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];

			if ( nil == fileContent )
			{
				fileContent = [NSString stringWithContentsOfFile:path encoding:NSISOLatin2StringEncoding error:&error];
			}
			
			if ( fileContent )
			{
				filePath = path;
				break;
			}
		}
		
	} while ( 0 );
	
	if ( nil == fileContent )
	{
		ERROR( @"Failed to resource\n%@", [error description] );
		return nil;
	}

	resource.resPolicy = ResourcePolicy_Default;
	resource.resContent = fileContent;
	resource.resPath = filePath;
	resource.resType = nil;

	return resource;
}

+ (id)resourceForClass:(Class)clazz
{
	if ( nil == clazz )
		return nil;

	Class baseClass = [self baseClass];
	
	if ( nil == baseClass )
	{
		baseClass = [NSObject class];
	}
	
	for ( Class thisClass = self; thisClass != baseClass; )
	{
		NSArray * extensions = [self supportedExtensionsForClass:thisClass];

		for ( NSString * extension in extensions )
		{
			NSString * fileName = [NSString stringWithFormat:@"%s.%@", class_getName(thisClass), extension];

			SamuraiResource * resource = [self resourceAtPath:fileName];
			if ( resource )
			{
				return resource;
			}
		}

		thisClass = class_getSuperclass( thisClass );
		if ( nil == thisClass )
			break;
	}

	return nil;
}

#pragma mark -

+ (NSArray *)supportedTypesForClass:(Class)clazz
{
	NSMutableArray * types = [NSMutableArray array];
	
	Class baseClass = [self baseClass];
	
	if ( nil == baseClass )
	{
		baseClass = [NSObject class];
	}
	
	for ( Class thisClass = self; thisClass != baseClass; )
	{
		[types addObjectsFromArray:[thisClass supportedTypes]];
		
		thisClass = class_getSuperclass( thisClass );
		if ( nil == thisClass )
			break;
	}
	
	return types;
}

+ (NSArray *)supportedExtensionsForClass:(Class)clazz
{
	NSMutableArray * types = [NSMutableArray array];
	
	Class baseClass = [self baseClass];
	
	if ( nil == baseClass )
	{
		baseClass = [NSObject class];
	}
	
	for ( Class thisClass = self; thisClass != baseClass; )
	{
		[types addObjectsFromArray:[thisClass supportedExtensions]];
		
		thisClass = class_getSuperclass( thisClass );
		if ( nil == thisClass )
			break;
	}

	return types;
}

+ (BOOL)supportType:(NSString *)type
{
	if ( nil == type )
		return NO;
	
	NSArray * supportedTypes = [self supportedTypes];

	for ( NSString * supportedType in supportedTypes )
	{
		if ( NSOrderedSame == [type compare:supportedType options:NSCaseInsensitiveSearch] )
		{
			return YES;
		}
	}
	
	return NO;
}

+ (BOOL)supportExtension:(NSString *)extension
{
	if ( nil == extension )
		return NO;

	NSArray * supportedExtensions = [self supportedExtensions];
	
	for ( NSString * supportedExtension in supportedExtensions )
	{
		if ( NSOrderedSame == [extension compare:supportedExtension options:NSCaseInsensitiveSearch] )
		{
			return YES;
		}
	}
	
	return NO;
}

#pragma mark -

+ (NSArray *)supportedTypes
{
	return @[];
}

+ (NSArray *)supportedExtensions
{
	return @[];
}

+ (NSString *)baseDirectory
{
	return nil;
}

- (BOOL)isRemote
{
	if ( self.resPath )
	{
		if ( [self.resPath hasPrefix:@"http://"] || [self.resPath hasPrefix:@"https://"] )
		{
			return YES;
		}
	}

	return NO;
}

- (BOOL)parse
{
	return NO;
}

- (void)merge:(SamuraiResource *)another
{
}

- (void)clear
{
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, Resource )

DESCRIBE( before )
{
}

DESCRIBE( after )
{
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "_pragma_pop.h"
