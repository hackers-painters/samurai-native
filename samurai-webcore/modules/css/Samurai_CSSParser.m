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

#import "Samurai_CSSParser.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

@implementation SamuraiCSSParser

@def_singleton( SamuraiCSSParser )

- (id)init
{
	self = [super init];
	if ( self )
	{
	}
	return self;
}

- (void)dealloc
{
}

#pragma mark -

- (KatanaOutput *)parseStylesheet:(NSString *)text
{
    return katana_parse(text.UTF8String, text.length, KatanaParserModeStylesheet);
}

- (KatanaOutput *)parseMedia:(NSString *)text
{
    return katana_parse(text.UTF8String, text.length, KatanaParserModeMediaList);
}

- (KatanaOutput *)parseValue:(NSString *)text
{
    return katana_parse(text.UTF8String, text.length, KatanaParserModeValue);
}

- (KatanaOutput *)parseSelector:(NSString *)text
{
    return katana_parse(text.UTF8String, text.length, KatanaParserModeSelector);
}

- (NSDictionary *)parseDeclaration:(NSString *)text
{
    KatanaOutput * output = katana_parse(text.UTF8String, text.length, KatanaParserModeDeclarationList);
    
    if ( NULL != output )
    {
        KatanaArray * declarations = output->declarations;

        NSDictionary * style = nil;
        
        if ( declarations->length > 0 )
        {
            style = [NSMutableDictionary dictionary];

            for ( size_t i = 0; i < declarations->length; i++ )
            {
                KatanaDeclaration * decl = declarations->data[i];
                
                if ( decl->property )
                {
                    SamuraiCSSValueWrapper * wrapper = [SamuraiCSSValueWrapper new];
					
                    // TODO: @(QFish) copy values, but no need for right now.
                    // wrapper.values = decl->values;
					
                    wrapper.rawValue = [NSString stringWithUTF8String:decl->raw];
					
                    // NSLog( @"%@ %s :%@", [self.element cssClasses], decl->property, wrapper );
                    [style setValue:wrapper forKey:[NSString stringWithUTF8String:decl->property]];
                }
            }
        }
        
        katana_destroy_output(output);
        
        return style;
    }
    
    return NULL;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, CSSParser )

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
