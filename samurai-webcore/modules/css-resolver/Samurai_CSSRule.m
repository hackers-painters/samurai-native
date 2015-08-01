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

#import "Samurai_CSSRule.h"
#import "Samurai_CSSParser.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#import "../../vendor/katana-parser/parser.h"
#import "../../vendor/katana-parser/selector.h"

#pragma mark -

@interface SamuraiCSSRule ()
@prop_strong( NSString *,           selectorName );
@end

@implementation SamuraiCSSRule

@def_prop_strong( NSString *,           selectorName );
@def_prop_unsafe( KatanaStyleRule *,	rule );
@def_prop_unsafe( KatanaSelector *,		selector );

@def_prop_assign( NSUInteger,			position );
@def_prop_assign( NSInteger,			specificity );

- (instancetype)initWithRule:(KatanaStyleRule *)rule
                    selector:(KatanaSelector *)selector
                    position:(NSUInteger)position
{
    self = [super init];
    if ( self )
    {
        _rule        = rule;
        _selector    = selector;
        _position    = position;
        _specificity = -1;
	}
    return self;
}

- (NSInteger)specificity
{
    if ( _specificity == -1 ) {
        _specificity = katana_calc_specificity_for_selector( self.selector );
    }
    
    return _specificity;
}

- (void)dealloc
{
	self.rule = nil;
	self.selector = nil;
}

- (NSString *)description
{
    if ( !self.selectorName )
    {
        KatanaParser parser;
        parser.options = &kKatanaDefaultOptions;
        KatanaParserString * string = katana_selector_to_string(&parser, self.selector, NULL);
        const char* text = katana_string_to_characters(&parser, string);
        katana_parser_deallocate(&parser, (void*) string->data);
        katana_parser_deallocate(&parser, (void*) string);
        NSString * selectorName = [NSString stringWithUTF8String:text];
        katana_parser_deallocate(&parser, (void*) text);
        
        self.selectorName = selectorName;
    }
   
    return [NSString stringWithFormat:@"%@: %ld %ld", self.selectorName, self.specificity, self.position];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, CSSRule )

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
