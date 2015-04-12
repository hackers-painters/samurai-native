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

#import "ServiceMonitorFPSModel.h"

#pragma mark -

#undef	MAX_HISTORY
#define MAX_HISTORY	(128)

#pragma mark -

@implementation ServiceMonitorFPSModel
{
	CADisplayLink *		_displayLink;
	CFTimeInterval		_timestamp;
	NSUInteger			_frameCount;
}

@def_prop_assign( NSUInteger,		fps );
@def_prop_strong( NSMutableArray *,	history );

@def_singleton( ServiceMonitorFPSModel )

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.fps = 0;
		self.history = [[NSMutableArray alloc] init];
		
		for ( NSUInteger i = 0; i < MAX_HISTORY; ++i )
		{
			[self.history addObject:@(0)];
		}

		_displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateFrameCount)];
		[_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
	}
	return self;
}

- (void)dealloc
{
	if ( _displayLink )
	{
		[_displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
		_displayLink = nil;
	}
	
	[self.history removeAllObjects];
	self.history = nil;
}

- (void)update
{
	[self.history removeObjectAtIndex:0];
	[self.history removeLastObject];

	[self.history addObject:[NSNumber numberWithFloat:self.fps]];
	
	if ( [self.history count] > MAX_HISTORY )
	{
		[self.history removeObjectsInRange:NSMakeRange(0, [self.history count] - MAX_HISTORY)];
	}
	
	[self.history insertObject:[NSNumber numberWithFloat:0.0f] atIndex:0];
	[self.history addObject:[NSNumber numberWithFloat:self.maxFPS]];
}

- (void)updateFrameCount
{
	_frameCount += 1;

	CFTimeInterval now = CACurrentMediaTime();
	CFTimeInterval diff = now - _timestamp;

	if ( diff >= 1.0f )
	{
		self.fps = _frameCount;
		
		if ( self.fps > self.maxFPS )
		{
			self.maxFPS = self.fps;
		}
		
		_timestamp = now;
		_frameCount = 0;
	}
}

@end
