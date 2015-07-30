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

#import "Samurai_HtmlDocumentWorkflow.h"
#import "Samurai_HtmlDocumentWorklet_10Begin.h"
#import "Samurai_HtmlDocumentWorklet_20ParseDomTree.h"
#import "Samurai_HtmlDocumentWorklet_30ParseResource.h"
#import "Samurai_HtmlDocumentWorklet_40MergeStyleTree.h"
#import "Samurai_HtmlDocumentWorklet_50MergeDomTree.h"
#import "Samurai_HtmlDocumentWorklet_60ApplyStyleTree.h"
#import "Samurai_HtmlDocumentWorklet_70BuildRenderTree.h"
#import "Samurai_HtmlDocumentWorklet_80Finish.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiHtmlDocumentWorklet
@end

#pragma mark -

@implementation SamuraiHtmlDocumentWorkflow_All

- (id)init
{
	self = [super init];
	if ( self )
	{
		[self.worklets addObject:[SamuraiHtmlDocumentWorklet_10Begin worklet]];
		[self.worklets addObject:[SamuraiHtmlDocumentWorklet_20ParseDomTree worklet]];
		[self.worklets addObject:[SamuraiHtmlDocumentWorklet_30ParseResource worklet]];
		[self.worklets addObject:[SamuraiHtmlDocumentWorklet_40MergeStyleTree worklet]];
		[self.worklets addObject:[SamuraiHtmlDocumentWorklet_50MergeDomTree worklet]];
		[self.worklets addObject:[SamuraiHtmlDocumentWorklet_60ApplyStyleTree worklet]];
		[self.worklets addObject:[SamuraiHtmlDocumentWorklet_70BuildRenderTree worklet]];
		[self.worklets addObject:[SamuraiHtmlDocumentWorklet_80Finish worklet]];
	}
	return self;
}

- (void)dealloc
{
}

@end

#pragma mark -

@implementation SamuraiHtmlDocumentWorkflow_Parser

- (id)init
{
	self = [super init];
	if ( self )
	{
		[self.worklets addObject:[SamuraiHtmlDocumentWorklet_10Begin worklet]];
		[self.worklets addObject:[SamuraiHtmlDocumentWorklet_20ParseDomTree worklet]];
		[self.worklets addObject:[SamuraiHtmlDocumentWorklet_30ParseResource worklet]];
	}
	return self;
}

- (void)dealloc
{
}

@end

#pragma mark -

@implementation SamuraiHtmlDocumentWorkflow_Render

- (id)init
{
	self = [super init];
	if ( self )
	{
		[self.worklets addObject:[SamuraiHtmlDocumentWorklet_40MergeStyleTree worklet]];
		[self.worklets addObject:[SamuraiHtmlDocumentWorklet_50MergeDomTree worklet]];
		[self.worklets addObject:[SamuraiHtmlDocumentWorklet_60ApplyStyleTree worklet]];
		[self.worklets addObject:[SamuraiHtmlDocumentWorklet_70BuildRenderTree worklet]];
		[self.worklets addObject:[SamuraiHtmlDocumentWorklet_80Finish worklet]];
	}
	return self;
}

- (void)dealloc
{
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlDocumentWorkflow )

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
