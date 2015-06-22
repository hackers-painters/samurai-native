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

#import "UIView+SignalHandling.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation UIView(SignalHandling)

- (NSString *)signalNamespace
{
	return [[self class] description];
}

- (NSString *)signalTag
{
	return self.renderer.dom.domId;
}

- (NSString *)signalDescription
{
	if ( self.renderer.dom.domTag && self.renderer.dom.domId )
	{
		return [NSString stringWithFormat:@"%@, <%@ id='%@'/>", [[self class] description], self.renderer.dom.domTag, self.renderer.dom.domId];
	}
	else if ( self.renderer.dom.domTag )
	{
		return [NSString stringWithFormat:@"%@, <%@/>", [[self class] description], self.renderer.dom.domTag];
	}
	else
	{
		return [NSString stringWithFormat:@"%@", [[self class] description]];
	}
}

- (id)signalResponders
{
	return [self nextResponder];
}

- (id)signalAlias
{
	NSMutableArray * array = [NSMutableArray nonRetainingArray];
	
	if ( self.renderer.dom.domId && self.renderer.dom.domTag )
	{
		[array addObject:[NSString stringWithFormat:@"%@____%@", self.renderer.dom.domTag, self.renderer.dom.domId]];
	}

	if ( self.renderer.dom.domId )
	{
		[array addObject:self.renderer.dom.domId];
	}

	return array;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, UIView_SignalHandling )

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
