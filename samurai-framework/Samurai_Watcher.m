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

#import "Samurai_Watcher.h"

#import "_pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiWatcher

@def_prop_strong( NSMutableArray *,		sourceFiles );
@def_prop_strong( NSString *,			sourcePath );

@def_notification( SourceFileDidChanged )
@def_notification( SourceFileDidRemoved )

@def_singleton( SamuraiWatcher )

- (id)init
{
	self = [super init];
	if ( self )
	{
	}
	return self;
}

- (void)dealloc
{
	[self.sourceFiles removeAllObjects];
	self.sourceFiles = nil;
}

#pragma mark -

- (void)watch:(NSString *)path
{
	self.sourcePath = [[NSString stringWithFormat:@"%@/../", path] stringByStandardizingPath];
	
#if (TARGET_IPHONE_SIMULATOR)
	[self scanSourceFiles];
#endif	// #if (TARGET_IPHONE_SIMULATOR)
}

#if (TARGET_IPHONE_SIMULATOR)

- (void)scanSourceFiles
{
	if ( nil == self.sourceFiles )
	{
		self.sourceFiles = [[NSMutableArray alloc] init];
	}

	[self.sourceFiles removeAllObjects];
	
	NSString * basePath = [[self.sourcePath stringByStandardizingPath] copy];
	if ( nil == basePath )
		return;
	
	NSDirectoryEnumerator *	enumerator = [[NSFileManager defaultManager] enumeratorAtPath:basePath];
	if ( enumerator )
	{
		for ( ;; )
		{
			NSString * filePath = [enumerator nextObject];
			if ( nil == filePath )
				break;

			NSString * fileName = [filePath lastPathComponent];
			NSString * fileExt = [fileName pathExtension];
			NSString * fullPath = [basePath stringByAppendingPathComponent:filePath];
			
			BOOL isDirectory = NO;
			BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDirectory];
			if ( exists && NO == isDirectory )
			{
				BOOL isValid = NO;
				
				for ( NSString * extension in @[ @"xml", @"html", @"htm", @"css" ] )
				{
					if ( NSOrderedSame == [fileExt compare:extension] )
					{
						isValid = YES;
						break;
					}
				}
				
				if ( isValid )
				{
					[self.sourceFiles addObject:fullPath];
				}
			}
		}
	}
	
	for ( NSString * file in self.sourceFiles )
	{
		[self watchSourceFile:file];
	}
}

- (void)watchSourceFile:(NSString *)filePath
{
	int fileHandle = open( [filePath UTF8String], O_EVTONLY );
	if ( fileHandle )
	{
		unsigned long				mask = DISPATCH_VNODE_DELETE | DISPATCH_VNODE_WRITE | DISPATCH_VNODE_EXTEND;
		__block dispatch_queue_t	queue = dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 );
		__block dispatch_source_t	source = dispatch_source_create( DISPATCH_SOURCE_TYPE_VNODE, fileHandle, mask, queue );
		
		@weakify(self)
		
		__block id eventHandler = ^
		{
			@strongify(self)
			
			unsigned long flags = dispatch_source_get_data( source );
			if ( flags )
			{
				dispatch_source_cancel( source );
				dispatch_async( dispatch_get_main_queue(), ^
				{
					BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:NULL];
					if ( exists )
					{
						[SamuraiWatcher notify:SamuraiWatcher.SourceFileDidChanged withObject:filePath];
					}
					else
					{
						[SamuraiWatcher notify:SamuraiWatcher.SourceFileDidRemoved withObject:filePath];
					}
				});
				
				[self watchSourceFile:filePath];
			}
		};
		
		__block id cancelHandler = ^
		{
			close( fileHandle );
		};
		
		dispatch_source_set_event_handler( source, eventHandler );
		dispatch_source_set_cancel_handler( source, cancelHandler );
		dispatch_resume(source);
	}
}

#endif	// #if (TARGET_IPHONE_SIMULATOR)

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#import "_pragma_pop.h"
