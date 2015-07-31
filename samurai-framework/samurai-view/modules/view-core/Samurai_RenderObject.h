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
#import "Samurai_ViewConfig.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_Tree.h"

#pragma mark -

#undef	INVALID_VALUE
#define	INVALID_VALUE			(HUGE_VALF)

#undef	NORMALIZE_VALUE
#define NORMALIZE_VALUE( __x )	((__x == INVALID_VALUE) ? 0.0f : __x)

#pragma mark -

#if __has_feature(objc_arc)

#undef	outlet
#define	outlet( type, name ) \
		property (nonatomic, unsafe_unretained) type name

#undef	def_outlet
#define	def_outlet( type, name, ... ) \
		synthesize name = _##name;

#else

#undef	outlet
#define	outlet( type, name ) \
		property (nonatomic, assign) type name

#undef	def_outlet
#define	def_outlet( type, name, ... ) \
		synthesize name = _##name;

#endif

#pragma mark -

@class SamuraiDomNode;
@class SamuraiDocument;
@class SamuraiRenderObject;
@class SamuraiRenderStyle;
@class SamuraiLayoutObject;

@interface NSObject(Renderer)

@prop_strong( SamuraiRenderObject *, renderer ); // memory leak, but no crash

+ (id)createInstanceWithRenderer:(SamuraiRenderObject *)renderer;	// override point
+ (id)createInstanceWithRenderer:(SamuraiRenderObject *)renderer identifier:(NSString *)identifier;	// override point

- (void)prepareForRendering;							// override point

- (CGSize)computeSizeBySize:(CGSize)size;				// override point
- (CGSize)computeSizeByWidth:(CGFloat)width;			// override point
- (CGSize)computeSizeByHeight:(CGFloat)height;			// override point

- (void)applyDom:(SamuraiDomNode *)dom;					// override point
- (void)applyStyle:(SamuraiRenderStyle *)style;			// override point
- (void)applyFrame:(CGRect)frame;						// override point

@end

#pragma mark -

@interface SamuraiRenderObject : SamuraiTreeNode

@prop_strong( NSNumber *,				id );
@prop_unsafe( SamuraiDomNode *,			dom );
@prop_strong( SamuraiRenderStyle *,		style );

@prop_strong( UIView *,					view );
@prop_strong( Class,					viewClass );

@prop_readonly( SamuraiRenderObject *,	root );
@prop_unsafe( SamuraiRenderObject *,	parent );
@prop_unsafe( SamuraiRenderObject *,	prev );
@prop_unsafe( SamuraiRenderObject *,	next );

+ (instancetype)renderObject;
+ (instancetype)renderObjectWithDom:(SamuraiDomNode *)dom andStyle:(SamuraiRenderStyle *)style;

- (UIView *)createViewWithIdentifier:(NSString *)identifier;		// override point

- (void)bindOutletsTo:(NSObject *)container;						// override point
- (void)unbindOutletsFrom:(NSObject *)container;					// override point

- (void)bindView:(UIView *)view;									// override point
- (void)unbindView;													// override point

- (void)bindDom:(SamuraiDomNode *)newDom;							// override point
- (void)unbindDom;													// override point

- (void)bindStyle:(SamuraiRenderStyle *)newStyle;					// override point
- (void)unbindStyle;												// override point

- (void)relayout;													// override point
- (void)restyle;													// override point
- (void)rechain;													// override point

- (CGSize)computeSize:(CGSize)bound;								// override point
- (CGFloat)computeWidth:(CGFloat)height;							// override point
- (CGFloat)computeHeight:(CGFloat)width;							// override point

- (SamuraiRenderObject *)prevObject;								// override point
- (SamuraiRenderObject *)nextObject;								// override point

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
