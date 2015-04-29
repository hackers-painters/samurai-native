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

#import "Samurai_ModelManager.h"
#import "Samurai_Model.h"

#import "_pragma_push.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiModelManager
{
	NSMutableArray * _models;
}

@def_singleton( SamuraiModelManager )

+ (void)classAutoLoad
{
	[SamuraiModelManager sharedInstance];
	
	for ( NSString * className in [SamuraiModel subClasses] )
	{
		Class classType = NSClassFromString( className );

		if ( nil == classType )
			continue;

		if ( [classType instancesRespondToSelector:@selector(sharedInstance)] )
		{
			[classType sharedInstance];
		}
	}
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		_models = [NSMutableArray nonRetainingArray];
	}
	return self;
}

- (void)dealloc
{
	[_models removeAllObjects];
	_models = nil;
}

- (NSArray *)loadedModels
{
	NSMutableArray * array = [NSMutableArray nonRetainingArray];
	[array addObjectsFromArray:_models];
	return array;
}

- (NSArray *)loadedModelsByClass:(Class)clazz
{
	if ( 0 == _models.count )
		return nil;
	
	NSMutableArray * array = [NSMutableArray nonRetainingArray];
	
	for ( SamuraiModel * model in _models )
	{
		if ( [model isKindOfClass:clazz] )
		{
			[array addObject:model];
		}
	}

	return array;
}

- (void)addModel:(id)model
{
	if ( NO == [_models containsObject:model] )
	{
		[_models addObject:model];
	}
}

- (void)removeModel:(id)model
{
	[_models removeObject:model];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( Model, ModelManager )

DESCRIBE( before )
{
}

DESCRIBE( after )
{
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#import "_pragma_pop.h"
