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

#import "Samurai_Document.h"
#import "Samurai_DomNode.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiDocument

@def_prop_strong( NSString *,				href );
@def_prop_strong( NSString *,				type );
@def_prop_strong( NSString *,				media );

@def_prop_strong( SamuraiDomNode *,			domTree );
@def_prop_strong( SamuraiStyleSheet *,		styleTree );
@def_prop_strong( SamuraiRenderObject *,	renderTree );

@def_prop_strong( NSMutableArray *,			externalImports );
@def_prop_strong( NSMutableArray *,			externalScripts );
@def_prop_strong( NSMutableArray *,			externalStylesheets );

BASE_CLASS( SamuraiDocument )

+ (SamuraiDocument *)document
{
	return [[self alloc] init];
}

+ (SamuraiDocument *)document:(SamuraiDomNode *)domNode
{
	SamuraiDocument * document = [[self alloc] init];
	document.domTree = domNode;
	return document;
}

- (SamuraiDocument *)childDocument
{
	return [[[self class] alloc] init];
}

- (SamuraiDocument *)childDocument:(SamuraiDomNode *)domNode
{
	SamuraiDocument * document = [[[self class] alloc] init];
	document.domTree = domNode;
	[self appendNode:document];
	return document;
}

#pragma mark -

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.externalImports = [[NSMutableArray alloc] init];
		self.externalScripts = [[NSMutableArray alloc] init];
		self.externalStylesheets = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc
{
	self.href = nil;
	self.type = nil;
	self.media = nil;
	
	self.domTree = nil;
	self.styleTree = nil;
	self.renderTree = nil;

	self.externalImports = nil;
	self.externalScripts = nil;
	self.externalStylesheets = nil;
}

#pragma mark -

- (void)deepCopyFrom:(id)obj
{
}

#pragma mark -

- (void)clear
{
	self.domTree = nil;
	self.renderTree = nil;
}

- (BOOL)parse
{
	return [super parse];
}

- (BOOL)reflow
{
	return YES;
}

#pragma mark -

- (void)configureForView:(UIView *)view
{
	
}

- (void)configureForViewController:(UIViewController *)viewController
{
	
}

#pragma mark -

- (NSString *)uniqueIdentifier
{
	return nil;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, Document )

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
