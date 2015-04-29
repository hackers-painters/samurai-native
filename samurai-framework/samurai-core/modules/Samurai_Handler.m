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

#import "Samurai_Handler.h"
#import "Samurai_Trigger.h"
#import "Samurai_UnitTest.h"

#import "_pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

typedef void (^ __handlerBlockType )( id object );

#pragma mark -

@implementation NSObject(BlockHandler)

- (SamuraiHandler *)blockHandlerOrCreate
{
	SamuraiHandler * handler = [self getAssociatedObjectForKey:"blockHandler"];
	
	if ( nil == handler )
	{
		handler = [[SamuraiHandler alloc] init];
		
		[self retainAssociatedObject:handler forKey:"blockHandler"];
	}
	
	return handler;
}

- (SamuraiHandler *)blockHandler
{
	return [self getAssociatedObjectForKey:"blockHandler"];
}

- (void)addBlock:(id)block forName:(NSString *)name
{
	SamuraiHandler * handler = [self blockHandlerOrCreate];
	
	if ( handler )
	{
		[handler addHandler:block forName:name];
	}
}

- (void)removeBlockForName:(NSString *)name
{
	SamuraiHandler * handler = [self blockHandler];
	
	if ( handler )
	{
		[handler removeHandlerForName:name];
	}
}

- (void)removeAllBlocks
{
	SamuraiHandler * handler = [self blockHandler];
	
	if ( handler )
	{
		[handler removeAllHandlers];
	}
	
	[self removeAssociatedObjectForKey:"blockHandler"];
}

@end

#pragma mark -

@implementation SamuraiHandler
{
	NSMutableDictionary * _blocks;
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		_blocks = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[_blocks removeAllObjects];
	_blocks = nil;
}

- (BOOL)trigger:(NSString *)name
{
	return [self trigger:name withObject:nil];
}

- (BOOL)trigger:(NSString *)name withObject:(id)object
{
	if ( nil == name )
		return NO;

	__handlerBlockType block = (__handlerBlockType)[_blocks objectForKey:name];
	if ( nil == block )
		return NO;

	block( object );
	return YES;
}

- (void)addHandler:(id)handler forName:(NSString *)name
{
	if ( nil == name )
		return;

	if ( nil == handler )
	{
		[_blocks removeObjectForKey:name];
	}
	else
	{
		[_blocks setObject:handler forKey:name];
	}
}

- (void)removeHandlerForName:(NSString *)name
{
	if ( nil == name )
		return;

	[_blocks removeObjectForKey:name];
}

- (void)removeAllHandlers
{
	[_blocks removeAllObjects];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( Core, Handler )

DESCRIBE( before )
{
}

DESCRIBE( after )
{
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#import "_pragma_pop.h"
