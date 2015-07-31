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
#import "Samurai_ViewConfig.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_DomNode.h"
#import "Samurai_Document.h"
#import "Samurai_StyleSheet.h"
#import "Samurai_Script.h"
#import "Samurai_RenderObject.h"
#import "Samurai_RenderStyle.h"
#import "Samurai_Resource.h"
#import "Samurai_ResourceFetcher.h"

#pragma mark -

typedef enum
{
	TemplateState_Created = 0,
	TemplateState_Loading,
	TemplateState_Loaded,
	TemplateState_Failed,
	TemplateState_Cancelled
} TemplateState;

#pragma mark -

@class SamuraiTemplate;

@interface NSObject(TemplateResponder)

@prop_strong( SamuraiTemplate *, template );

- (void)loadTemplate:(NSString *)urlOrFile;
- (void)loadTemplate:(NSString *)urlOrFile type:(NSString *)type;

- (void)handleTemplate:(SamuraiTemplate *)template;

@end

#pragma mark -

@interface SamuraiTemplate : NSObject

@joint( stateChanged );

@prop_strong( SamuraiDocument *,		document );

@prop_assign( NSTimeInterval,			timeoutSeconds );
@prop_assign( BOOL,						timeout );

@prop_assign( BOOL,						responderDisabled );
@prop_unsafe( id,						responder );

@prop_copy( BlockType,					stateChanged );
@prop_assign( TemplateState,			state );
@prop_readonly( BOOL,					created );
@prop_readonly( BOOL,					loading );
@prop_readonly( BOOL,					loaded );
@prop_readonly( BOOL,					failed );
@prop_readonly( BOOL,					cancelled );

+ (SamuraiTemplate *)template;

- (void)loadClass:(Class)clazz;
- (void)loadFile:(NSString *)file;
- (void)loadURL:(NSString *)url type:(NSString *)type;

- (void)stopLoading;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
