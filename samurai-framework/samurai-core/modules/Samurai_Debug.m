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

#import "Samurai_Debug.h"
#import "Samurai_Log.h"
#import "Samurai_UnitTest.h"

#import "NSObject+Extension.h"
#import "NSArray+Extension.h"
#import "NSMutableArray+Extension.h"

#import "_pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

#undef	MAX_CALLSTACK_DEPTH
#define MAX_CALLSTACK_DEPTH	(64)

#pragma mark -

@interface SamuraiCallFrame()
+ (NSUInteger)hexValueFromString:(NSString *)text;
+ (id)parseFormat1:(NSString *)line;
+ (id)parseFormat2:(NSString *)line;
@end

#pragma mark -

@implementation SamuraiCallFrame

@def_prop_assign( CallFrameType,	type );
@def_prop_strong( NSString *,		process );
@def_prop_assign( NSUInteger,		entry );
@def_prop_assign( NSUInteger,		offset );
@def_prop_strong( NSString *,		clazz );
@def_prop_strong( NSString *,		method );

- (id)init
{
	self = [super init];
	if ( self )
	{
		_type = CallFrameType_Unknown;
	}
	return self;
}

- (void)dealloc
{
	self.process = nil;
	self.clazz = nil;
	self.method = nil;
}

- (NSString *)description
{
	if ( CallFrameType_ObjectC == _type )
	{
		return [NSString stringWithFormat:@"[O] %@(0x%08x + %llu) -> [%@ %@]", _process, (unsigned int)_entry, (unsigned long long)_offset, _clazz, _method];
	}
	else if ( CallFrameType_NativeC == _type )
	{
		return [NSString stringWithFormat:@"[C] %@(0x%08x + %llu) -> %@", _process, (unsigned int)_entry, (unsigned long long)_offset, _method];
	}
	else
	{
		return [NSString stringWithFormat:@"[X] <unknown>(0x%08x + %llu)", (unsigned int)_entry, (unsigned long long)_offset];
	}	
}

+ (NSUInteger)hexValueFromString:(NSString *)text
{
	unsigned int number = 0;
	[[NSScanner scannerWithString:text] scanHexInt:&number];
	return (NSUInteger)number;
}

+ (id)parseFormat1:(NSString *)line
{
//	example: peeper  0x00001eca -[PPAppDelegate application:didFinishLaunchingWithOptions:] + 106
	
	static __strong NSRegularExpression * __regex = nil;

	if ( nil == __regex )
	{
		NSError * error = NULL;
		NSString * expr = @"^[0-9]*\\s*([a-z0-9_]+)\\s+(0x[0-9a-f]+)\\s+-\\[([a-z0-9_]+)\\s+([a-z0-9_:]+)]\\s+\\+\\s+([0-9]+)$";
		
		__regex = [NSRegularExpression regularExpressionWithPattern:expr options:NSRegularExpressionCaseInsensitive error:&error];
	}

	NSTextCheckingResult * result = [__regex firstMatchInString:line options:0 range:NSMakeRange(0, [line length])];

	if ( result && (__regex.numberOfCaptureGroups + 1) == result.numberOfRanges )
	{
		SamuraiCallFrame * frame = [[SamuraiCallFrame alloc] init];
		if ( frame )
		{
			frame.type = CallFrameType_ObjectC;
			frame.process = [line substringWithRange:[result rangeAtIndex:1]];
			frame.entry = [self hexValueFromString:[line substringWithRange:[result rangeAtIndex:2]]];
			frame.clazz = [line substringWithRange:[result rangeAtIndex:3]];
			frame.method = [line substringWithRange:[result rangeAtIndex:4]];
			frame.offset = (NSUInteger)[[line substringWithRange:[result rangeAtIndex:5]] intValue];
			
			return frame;
		}
	}
	
	return nil;
}

+ (id)parseFormat2:(NSString *)line
{
//	example: UIKit 0x0105f42e UIApplicationMain + 1160
	
	static __strong NSRegularExpression * __regex = nil;
	
	if ( nil == __regex )
	{
		NSError * error = NULL;
		NSString * expr = @"^[0-9]*\\s*([a-z0-9_]+)\\s+(0x[0-9a-f]+)\\s+([a-z0-9_]+)\\s+\\+\\s+([0-9]+)$";
		
		__regex = [NSRegularExpression regularExpressionWithPattern:expr options:NSRegularExpressionCaseInsensitive error:&error];
	}
	
	NSTextCheckingResult * result = [__regex firstMatchInString:line options:0 range:NSMakeRange(0, [line length])];
	
	if ( result && (__regex.numberOfCaptureGroups + 1) == result.numberOfRanges )
	{
		SamuraiCallFrame * frame = [[SamuraiCallFrame alloc] init];
		if ( frame )
		{
			frame.type = CallFrameType_NativeC;
			frame.process = [line substringWithRange:[result rangeAtIndex:1]];
			frame.entry = [self hexValueFromString:[line substringWithRange:[result rangeAtIndex:2]]];
			frame.clazz = nil;
			frame.method = [line substringWithRange:[result rangeAtIndex:3]];
			frame.offset = (NSUInteger)[[line substringWithRange:[result rangeAtIndex:4]] intValue];
			
			return frame;
		}
	}

	return nil;
}

+ (id)unknown
{
	return [[SamuraiCallFrame alloc] init];
}

+ (id)parse:(NSString *)line
{
	if ( 0 == [line length] )
		return nil;

	id frame1 = [SamuraiCallFrame parseFormat1:line];
	if ( frame1 )
		return frame1;
	
	id frame2 = [SamuraiCallFrame parseFormat2:line];
	if ( frame2 )
		return frame2;

	return nil;
}

@end

#pragma mark -

@implementation SamuraiDebugger

@def_singleton(SamuraiDebugger)

@def_prop_readonly( NSArray *,	callstack );

#if __SAMURAI_DEBUG__
static void __uncaughtExceptionHandler( NSException * exception )
{
	fprintf( stderr, "\nUncaught exception: %s\n%s",
			[[exception description] UTF8String],
			[[[exception callStackSymbols] description] UTF8String] );

	TRAP();
}
#endif	// #if __SAMURAI_DEBUG__

#if __SAMURAI_DEBUG__
static void __uncaughtSignalHandler( int signal )
{
	fprintf( stderr, "\nUncaught signal: %d", signal );

	TRAP();
}
#endif	// #if __SAMURAI_DEBUG__

+ (void)classAutoLoad
{
#if __SAMURAI_DEBUG__
	NSSetUncaughtExceptionHandler( &__uncaughtExceptionHandler );
	
	signal( SIGABRT,	&__uncaughtSignalHandler );
	signal( SIGILL,		&__uncaughtSignalHandler );
	signal( SIGSEGV,	&__uncaughtSignalHandler );
	signal( SIGFPE,		&__uncaughtSignalHandler );
	signal( SIGBUS,		&__uncaughtSignalHandler );
	signal( SIGPIPE,	&__uncaughtSignalHandler );
#endif

	[SamuraiDebugger sharedInstance];
}

- (NSArray *)callstack
{
	return [[SamuraiDebugger sharedInstance] callstack:MAX_CALLSTACK_DEPTH];
}

- (NSArray *)callstack:(NSInteger)depth;
{
	NSMutableArray * array = [[NSMutableArray alloc] init];

	void * stacks[MAX_CALLSTACK_DEPTH] = { 0 };

	int frameCount = backtrace( stacks, MIN((int)depth, MAX_CALLSTACK_DEPTH) );
	if ( frameCount )
	{
		char ** symbols = backtrace_symbols( stacks, (int)frameCount );
		if ( symbols )
		{
			for ( int i = 0; i < frameCount; ++i )
			{
				NSString * line = [NSString stringWithUTF8String:(const char *)symbols[i]];
				if ( 0 == [line length] )
					continue;
				
				SamuraiCallFrame * frame = [SamuraiCallFrame parse:line];
				if ( frame )
				{
					[array addObject:frame];
				}
			}
			
			free( symbols );
		}
	}
	
	return array;
}

- (void)trap
{
#if __SAMURAI_DEBUG__
#if defined(__ppc__)
	asm("trap");
#elif defined(__i386__) ||  defined(__amd64__)
	asm("int3");
#endif
#endif
}

- (void)trace
{
	[self trace:MAX_CALLSTACK_DEPTH];
}

- (void)trace:(NSInteger)depth
{
	NSArray * callstack = [self callstack:depth];

	if ( callstack && callstack.count )
	{
		PRINT( [callstack description] );
	}
}

@end

#pragma mark -

@implementation NSObject(Debug)

- (id)debugQuickLookObject
{
#if __SAMURAI_DEBUG__
	
	SamuraiLogger * logger = [SamuraiLogger sharedInstance];
	
	[logger outputCapture];

	[self dump];
	
	[logger outputRelease];
	
	return logger.output;
	
#else	// #if __SAMURAI_DEBUG__
	
	return nil;
	
#endif	// #if __SAMURAI_DEBUG__
}

- (void)dump
{
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( Core, Debug )
{
}

DESCRIBE( before )
{
}

DESCRIBE( backtrace )
{
	NSArray * emptyFrames = [[SamuraiDebugger sharedInstance] callstack:0];
	EXPECTED( emptyFrames );
	EXPECTED( emptyFrames.count == 0 );
	
	NSArray * maxFrames = [[SamuraiDebugger sharedInstance] callstack:100000];
	EXPECTED( maxFrames );
	EXPECTED( maxFrames.count );
	
	NSArray * frames = [[SamuraiDebugger sharedInstance] callstack:1];
	EXPECTED( frames && frames.count );
	EXPECTED( [[frames objectAtIndex:0] isKindOfClass:[SamuraiCallFrame class]] );
	
	TRACE();

	[[SamuraiDebugger sharedInstance] trace];
	[[SamuraiDebugger sharedInstance] trace:0];
	[[SamuraiDebugger sharedInstance] trace:1];
	[[SamuraiDebugger sharedInstance] trace:100000];
}

DESCRIBE( after )
{
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#import "_pragma_pop.h"
