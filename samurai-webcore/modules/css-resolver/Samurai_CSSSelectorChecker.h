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

#import "Samurai.h"
#import "Samurai_CSSProtocol.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "katana.h"

#pragma mark -

typedef NS_ENUM( NSUInteger, SamuraiCSSSelectorMatch )
{
    SamuraiCSSSelectorMatches,
    SamuraiCSSSelectorFailsLocally,
    SamuraiCSSSelectorFailsAllSiblings,
    SamuraiCSSSelectorFailsCompletely,
};

typedef NS_ENUM( NSUInteger, SamuraiCSSPseudoId )
{
    // Static pseudo styles. Dynamic ones are produced on the fly.
    // The order must be NOP ID, public IDs, and then internal IDs.
    // If you add or remove a public ID, you must update _pseudoBits in ComputedStyle.
	
    NOPSEUDO,
    FIRST_LINE,
    FIRST_LETTER,
    BEFORE,
    AFTER,
    BACKDROP,
    SELECTION,
    FIRST_LINE_INHERITED,
    SCROLLBAR,
	
	// Internal IDs follow:
	
	SCROLLBAR_THUMB,
    SCROLLBAR_BUTTON,
    SCROLLBAR_TRACK,
    SCROLLBAR_TRACK_PIECE,
    SCROLLBAR_CORNER,
    RESIZER,
    INPUT_LIST_BUTTON,
	
    // Special values follow:
	
    AFTER_LAST_INTERNAL_PSEUDOID,
    FIRST_PUBLIC_PSEUDOID = FIRST_LINE,
    FIRST_INTERNAL_PSEUDOID = SCROLLBAR_THUMB,
    PUBLIC_PSEUDOID_MASK = ((1 << FIRST_INTERNAL_PSEUDOID) - 1) & ~((1 << FIRST_PUBLIC_PSEUDOID) - 1),
    PSEUDO_ElementMASK = (1 << (BEFORE - 1)) | (1 << (AFTER - 1)) | (1 << (BACKDROP - 1))
};

#pragma mark -

@interface SamuraiCSSSelectorCheckerMatchResult : NSObject

@prop_assign( SamuraiCSSPseudoId,		dynamicPseudo );
@prop_assign( NSUInteger,				specificity );

@end

#pragma mark -

@interface SamuraiCSSSelectorCheckingContext : NSObject

@prop_assign( KatanaSelector *,			selector );
@prop_assign( SamuraiCSSPseudoId,		pseudoId );
@prop_assign( NSUInteger,				elementStyle );
@prop_assign( BOOL,						isSubSelector );

@prop_unsafe( id<SamuraiCSSProtocol>,	element );
@prop_unsafe( id<SamuraiCSSProtocol>,	previousElement );

- (id)initWithContext:(SamuraiCSSSelectorCheckingContext *)context;

@end

#pragma mark -

/**
 *  Supported Selector:
 *
 *  - tag
 *  - #id
 *  - .class
 *  - :pseudo
		- :nth-child(an+b|odd|even)
        - :first-child
        - :last-child
        - :only-child
 *  - Group
		- <selector><selector>
 *  - Combinator
		- <selector> <selector>
 		- <selector> > <selector>
 		- <selector> + <selector>
 		- <selector> ~ <selector>
 *	- Attribute
		- [attribute]
		- [attribute=value]
		- [attribute|=value]
		- [attribute^=value]
		- [attribute$=value]
		- [attribute~=value]
		- [attribute*=value]
 *
 */

@interface SamuraiCSSSelectorChecker : NSObject

@prop_strong( SamuraiCSSSelectorCheckingContext *,	context );

- (SamuraiCSSSelectorMatch)match:(SamuraiCSSSelectorCheckingContext *)context
						  result:(SamuraiCSSSelectorCheckerMatchResult *)result;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
