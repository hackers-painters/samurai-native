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

#import "Samurai_CSSProtocol.h"
#import "Samurai_CSSParser.h"

#import "Samurai_HtmlMediaQuery.h"

#import "Samurai_CSSRuleCollector.h"
#import "Samurai_CSSRuleSet.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiCSSValueWrapper

- (NSString *)description
{
    return self.rawValue;
}

@end

#pragma mark - 

@interface SamuraiCSSStyleSheet()

@prop_unsafe( KatanaOutput *, output );
@prop_strong( SamuraiCSSRuleCollector*, styleCollector );

@end

#pragma mark -

@implementation SamuraiCSSStyleSheet

@def_prop_strong( SamuraiCSSRuleSet *, ruleSet );
@def_prop_strong( SamuraiCSSRuleCollector*, styleCollector );
@def_prop_unsafe( KatanaOutput *, output)

- (id)init
{
	self = [super init];
	if ( self )
	{
        _ruleSet = [SamuraiCSSRuleSet new];
        _ruleSet.mediaQueryChecker = [SamuraiHtmlMediaQuery sharedInstance];
	}
	return self;
}

- (void)dealloc
{
    if ( self.output != NULL )
	{
        katana_destroy_output(self.output);
        self.output = NULL;
    }
}

#pragma mark -

+ (NSArray *)supportedExtensions
{
	return [NSArray arrayWithObjects:@"css", nil];
}

+ (NSArray *)supportedTypes
{
	return [NSArray arrayWithObjects:@"text/css", nil];
}

+ (NSString *)baseDirectory
{
	return @"/www/css";
}

#pragma mark -

- (NSDictionary *)queryForObject:(NSObject<SamuraiCSSProtocol> *)object
{
    return [self.styleCollector styleForElement:object];
}

- (NSDictionary *)queryForString:(NSString *)string
{
	ASSERT( 0 );
	
	// TODO:
	
	return nil;
}

#pragma mark -

- (BOOL)parse
{
	if ( nil == self.resContent || 0 == [self.resContent length] )
	{
	//	return NO;
		return YES;
	}

	self.output = [[SamuraiCSSParser sharedInstance] parseStylesheet:self.resContent];

	if ( self.output )
	{
//	#if __SAMURAI_DEBUG__
//		katana_dump_output( self.output );
//	#endif	// #if __SAMURAI_DEBUG__
		
		KatanaStylesheet * stylesheet = self.output->stylesheet;
		
		if ( stylesheet->rules.length )
		{
			[self.ruleSet addRulesFromSheet:stylesheet];
		}
	}

	return YES;
}

- (void)merge:(SamuraiCSSStyleSheet *)styleSheet
{
	if ( nil == styleSheet )
		return;
	
	if ( NO == [styleSheet isKindOfClass:[SamuraiCSSStyleSheet class]] )
		return;
    
    [self.ruleSet mergeWithRuleSet:styleSheet.ruleSet];
}

- (void)clear
{
    [self.ruleSet clear];
}

- (SamuraiCSSRuleCollector *)styleCollector
{
    if ( _styleCollector == nil ) {
         _styleCollector = [[SamuraiCSSRuleCollector alloc] initWithRuleSet:self.ruleSet];
    }
	
    return _styleCollector;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, CSSStyleSheet )

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
