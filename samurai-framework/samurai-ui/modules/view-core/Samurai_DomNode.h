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

#import "Samurai_Core.h"
#import "Samurai_Event.h"
#import "Samurai_UIConfig.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_Tree.h"

#pragma mark -

typedef enum
{
	DomNodeType_Unknown = 0,
	DomNodeType_Document,
	DomNodeType_Comment,
	DomNodeType_Element,
	DomNodeType_Text,
	DomNodeType_Data
} DomNodeType;

#pragma mark -

@class SamuraiDocument;
@class SamuraiStyleSheet;

@interface SamuraiDomNode : SamuraiTreeNode

@prop_strong( NSNumber *,				id );
@prop_assign( DomNodeType,				type );

@prop_unsafe( SamuraiDocument *,		document );
@prop_unsafe( SamuraiDomNode *,			parent );
@prop_unsafe( SamuraiDomNode *,			prev );
@prop_unsafe( SamuraiDomNode *,			next );

@prop_unsafe( SamuraiDomNode *,			shadowHost );
@prop_strong( SamuraiDomNode *,			shadowRoot );

@prop_strong( NSString *,				domId );
@prop_strong( NSString *,				domTag );
@prop_strong( NSString *,				domText );
@prop_strong( NSString *,				domName );
@prop_strong( NSString *,				domNamespace );
@prop_strong( NSMutableDictionary *,	domAttributes );
@prop_strong( NSString *,				domStyleInline );
@prop_strong( NSMutableArray *,			domStyleClasses );
@prop_strong( NSMutableDictionary *,	domStyleComputed );

+ (instancetype)domNode;

- (void)attach:(SamuraiDocument *)document;
- (void)detach;

- (NSString *)computeHref;
- (NSString *)computeIdPath;
- (NSString *)computeTagPath;
- (NSString *)computeNamePath;

- (NSString *)computeInnerText;
- (NSString *)computeOuterText;

- (NSArray *)getElementsById:(NSString *)domId;
- (NSArray *)getElementsByName:(NSString *)domName;
- (NSArray *)getElementsByTagName:(NSString *)domTag;

- (SamuraiDomNode *)getFirstElementById:(NSString *)domId;
- (SamuraiDomNode *)getFirstElementByName:(NSString *)domName;
- (SamuraiDomNode *)getFirstElementByTagName:(NSString *)domTag;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
