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

#import "Samurai_Workflow.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiViewWorklet

+ (instancetype)worklet
{
	return [[self alloc] init];
}

- (BOOL)processWithContext:(id)context
{
	UNUSED( context );

	return YES;
}

@end

#pragma mark -

@implementation SamuraiWorkflow

@def_prop_unsafe( NSObject *,		context );
@def_prop_strong( NSMutableArray *,	worklets );

+ (instancetype)workflow
{
	return [[self alloc] init];
}

+ (instancetype)workflowWithContext:(NSObject *)context
{
	SamuraiWorkflow * workflow = [[self alloc] init];
	workflow.context = context;
	return workflow;
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.worklets = [NSMutableArray array];
	}
	return self;
}

- (void)dealloc
{
	[self.worklets removeAllObjects];
	self.worklets = nil;
}

- (BOOL)process
{
	INFO( @" " );
	INFO( @"Workflow '%@', start", [[self class] description] );

	for ( SamuraiViewWorklet * worklet in self.worklets )
	{
		INFO( @"  [%@]", [[worklet class] description] );

		[[SamuraiLogger sharedInstance] indent:2];
	//	[[SamuraiLogger sharedInstance] disable];

		BOOL succeed = [worklet processWithContext:self.context];

	//	[[SamuraiLogger sharedInstance] enable];
		[[SamuraiLogger sharedInstance] unindent:2];
		
		if ( NO == succeed )
			break;
	}

	INFO( @"workflow '%@', done", [[self class] description] );
	INFO( @" " );

	return YES;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, Workflow )

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
