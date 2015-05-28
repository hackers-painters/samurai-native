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

#import "Samurai_Log.h"
#import "Samurai_UnitTest.h"

#import "NSArray+Extension.h"
#import "NSMutableArray+Extension.h"

#if __SAMURAI_DEBUG__
#import "fishhook.h"
#endif	// #if __SAMURAI_DEBUG__

#import "_pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

#undef	MAX_BACKLOG
#define MAX_BACKLOG		(64)

#if __SAMURAI_LOGGING__
static const char * __prefix[] =
{
#if TARGET_IPHONE_SIMULATOR
	"<#[E]#>",
#else
	"[E]",
#endif
	
	"[W]",
	"[I]",
	"[P]",
	"",
};
#endif	// #if __SAMURAI_LOGGING__

#pragma mark -

#if __SAMURAI_DEBUG__

static void __NSLogv( NSString * format, va_list args )
{
	[[SamuraiLogger sharedInstance] file:nil line:0 func:nil level:LogLevel_Info format:format args:args];
}

static void __NSLog( NSString * format, ... )
{
	if ( nil == format || NO == [format isKindOfClass:[NSString class]] )
		return;
	
	va_list args;
	
	va_start( args, format );
	
	__NSLogv( format, args );
	
	va_end( args );
}

#endif	// #if __SAMURAI_DEBUG__

#pragma mark -

@implementation SamuraiLogger
{
	NSUInteger	_capture;
	NSUInteger	_indent;
}

@def_singleton( SamuraiLogger );

@def_prop_assign( BOOL,					enabled );

@def_prop_strong( NSMutableString *,	output );
@def_prop_strong( NSMutableArray *,		buffer );
@def_prop_assign( LogLevel,				filter );

@def_prop_copy( BlockType,				outputHandler );

+ (void)classAutoLoad
{
	[SamuraiLogger sharedInstance];
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.enabled = YES;
		self.output = [NSMutableString string];
		self.buffer = [NSMutableArray array];

	#if __SAMURAI_DEBUG__
		self.filter = LogLevel_All;
	#else
		self.filter = LogLevel_Error;
	#endif
		
	#if __SAMURAI_DEBUG__
		struct rebinding r[] = {
			{
				(char *)"NSLog",
				(void *)__NSLog
			},
			{
				(char *)"NSLogv",
				(void *)__NSLogv
			}
		};
		
		rebind_symbols( r, 2 );
	#endif	// #if __SAMURAI_DEBUG__
	}
	return self;
}

- (void)dealloc
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];

	self.output = nil;
	self.buffer = nil;

	self.outputHandler = nil;
}

- (void)toggle
{
	_enabled = _enabled ? NO : YES;
}

- (void)enable
{
	_enabled = YES;
}

- (void)disable
{
	_enabled = NO;
}

- (void)indent
{
	_indent += 1;
}

- (void)indent:(NSUInteger)tabs
{
	_indent += tabs;
}

- (void)unindent
{
	if ( _indent > 0 )
	{
		_indent -= 1;
	}
}

- (void)unindent:(NSUInteger)tabs
{
	if ( _indent < tabs )
	{
		_indent = 0;
	}
	else
	{
		_indent -= tabs;
	}
}

- (void)outputCapture
{
	if ( 0 == _capture )
	{
		[self.output setString:@""];
	}
	
	_capture += 1;
}

- (void)outputRelease
{
	if ( _capture > 0 )
	{
		_capture -= 1;
	}
}

- (void)file:(NSString *)file line:(NSUInteger)line func:(NSString *)func level:(LogLevel)level format:(NSString *)format, ...
{
#if __SAMURAI_LOGGING__
	
	if ( nil == format || NO == [format isKindOfClass:[NSString class]] )
		return;
	
	va_list args;
	va_start( args, format );
	
	[self file:file line:line func:func level:level format:format args:args];
	
	va_end( args );
	
#endif
}

- (void)file:(NSString *)file line:(NSUInteger)line func:(NSString *)func level:(LogLevel)level format:(NSString *)format args:(va_list)params
{
#if __SAMURAI_LOGGING__
	
	if ( NO == _enabled || level > _filter )
		return;

	[NSObject cancelPreviousPerformRequestsWithTarget:self];

	@autoreleasepool
	{
		const char * prefix = __prefix[level];
		if ( NULL == prefix )
		{
			prefix = "";
		}

		char tabs[256] = { 0 };
		for ( NSUInteger i = 0; i < _indent; ++i )
		{
			tabs[i] = '\t';
		}

		size_t plen = strlen(prefix);
		size_t diff = ((plen / 4 + 1) * 4) - plen;
		
		char padding[16] = { 0 };
		for ( size_t i = 0; i < diff; ++i )
		{
			padding[i] = ' ';
		}

		NSMutableString * content = [[NSMutableString alloc] initWithFormat:(NSString *)format arguments:params];
		if ( content )
		{
			if ( [content rangeOfString:@"\n"].length )
			{
				[content replaceOccurrencesOfString:@"\n"
										 withString:[NSString stringWithFormat:@"\n%s", _indent ? tabs : "\t\t"]
											options:NSCaseInsensitiveSearch
											  range:NSMakeRange(0, content.length)];
			}
		}
		
		if ( content && content.length )
		{
			NSMutableString * text = [[NSMutableString alloc] init];
			if ( text )
			{
				[text appendFormat:@"%s%s%s", prefix, padding, tabs];
				[text appendString:content];

				if ( [text rangeOfString:@"%"].length )
				{
					[text replaceOccurrencesOfString:@"%"
										  withString:@"%%"
											 options:NSLiteralSearch
											   range:NSMakeRange(0, text.length)];
				}
				
				if ( _capture )
				{
					[self.output appendString:text];
					[self.output appendString:@"\n"];
				}
				else
				{
					fprintf( stderr, "%s\n", [text UTF8String] );

					[self.buffer addObject:text];
				}

			#if __SAMURAI_DEBUG__
				
			#undef	MAX_CALLSTACK
			#define MAX_CALLSTACK	(8)

				if ( LogLevel_Error == level )
				{
					fprintf( stderr, "    %s(#%lu) %s\n", [[file lastPathComponent] UTF8String], (unsigned long)line, [func UTF8String] );
					
					void *	stacks[MAX_CALLSTACK + 1];
					
					int depth = backtrace( stacks, MAX_CALLSTACK );
					if ( depth )
					{
						char ** symbols = backtrace_symbols( stacks, (int)depth );
						if ( symbols )
						{
							for ( int i = 2; i < depth; ++i )
							{
								fprintf( stderr, "    | %s\n", (const char *)symbols[i] );
							}
							
							free( symbols );
						}
					}
				}

			#endif	// #if __SAMURAI_DEBUG__
			}
		}
	}

	[self performSelector:@selector(flush) withObject:nil afterDelay:0.01f inModes:@[(NSString *)kCFRunLoopCommonModes]];

#endif
}

- (void)flush
{
#if __SAMURAI_DEBUG__
	
	for ( NSString * text in [self.buffer copy] )
	{
		if ( self.outputHandler )
		{
			((BlockTypeVarg)self.outputHandler)( text );
		}
	}

#endif	// #if __SAMURAI_DEBUG__
	
	[self.buffer removeAllObjects];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( Core, Log )
{
}

DESCRIBE( info )
{
	// INFO

	INFO( nil );
	INFO( nil, nil );
	INFO( nil, @"" );
	INFO( nil, @"format %@", @"" );
	
	INFO( @"a", nil );
	INFO( @"a", @"" );
	INFO( @"a", @"format %@", @"" );
}

DESCRIBE( warn )
{
	// WARN
	
	WARN( nil );
	WARN( nil, nil );
	WARN( nil, @"" );
	WARN( nil, @"format %@", @"" );

	WARN( @"a", nil );
	WARN( @"a", @"" );
	WARN( @"a", @"format %@", @"" );
}

DESCRIBE( error )
{
	// ERROR

	ERROR( nil );
	ERROR( nil, nil );
	ERROR( nil, @"" );
	ERROR( nil, @"format %@", @"" );
	
	ERROR( @"a", nil );
	ERROR( @"a", @"" );
	ERROR( @"a", @"format %@", @"" );
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#import "_pragma_pop.h"
