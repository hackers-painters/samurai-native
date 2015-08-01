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

#import "Samurai_CSSRuleCollector.h"
#import "Samurai_CSSRule.h"
#import "Samurai_CSSRuleSet.h"
#import "Samurai_CSSSelectorChecker.h"
#import "Samurai_CSSObject.h"
#import "Samurai_CSSArray.h"
#import "Samurai_CSSValue.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#if __SAMURAI_DEBUG__

#undef  IS_CSS_DEBUG
#define IS_CSS_DEBUG(__x) [[__x cssAttributes] hasObjectForKey:@"debug"] || [[__x cssAttributes] hasObjectForKey:@"debug-css"]

#else 

#undef  IS_CSS_DEBUG
#define IS_CSS_DEBUG(__x) NO

#endif

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiCSSRuleCollector

- (NSDictionary *)collectFromRuleSet:(SamuraiCSSRuleSet *)ruleSet forElement:(id<SamuraiCSSProtocol>)element
{
	if ( nil == element || nil == ruleSet )
		return nil;
	
	NSMutableArray * matchedRules = [NSMutableArray array];

// pseudoId
	
	[self collectMatchingRules:[ruleSet shadowPseudoElementRulesWithKey:[element cssShadowPseudoId]]
					forElement:element
				toMatchedRules:matchedRules];

// #id

	[self collectMatchingRules:[ruleSet idRulesWithKey:[element cssId]]
					forElement:element
				toMatchedRules:matchedRules];
	
// .Class
	
	for ( NSString * className in [element cssClasses] )
	{
		[self collectMatchingRules:[ruleSet classRulesWithKey:className]
						forElement:element
					toMatchedRules:matchedRules];
	}
	
//    if (element.isLink())
//        collectMatchingRules(matchRequest.ruleSet->linkPseudoClassRules(), cascadeOrder, matchRequest, ruleRange);

//    if (SelectorChecker::matchesFocusPseudoClass(element))
//        collectMatchingRules(matchRequest.ruleSet->focusPseudoClassRules(), cascadeOrder, matchRequest, ruleRange);

// Tag
	
	[self collectMatchingRules:[ruleSet tagRulesWithKey:[element cssTag]]
					forElement:element
				toMatchedRules:matchedRules];
	
// Universal
	
	[self collectMatchingRules:[ruleSet universalRules]
					forElement:element
				toMatchedRules:matchedRules];

    return [self buildResultFromMatchedRules:matchedRules forElement:element];;
}

#pragma mark -

- (void)collectMatchingRules:(NSArray *)rules forElement:(id<SamuraiCSSProtocol>)element toMatchedRules:(NSMutableArray *)matchedRules
{
    if ( nil == rules )
        return;

    for ( SamuraiCSSRule * ruleData in rules )
	{
		KatanaStyleRule *	rule = ruleData.rule;
		KatanaArray *		declarations = rule->declarations;
		
		if ( NULL == declarations || 0 == declarations->length )
			continue;
		
		SamuraiCSSSelectorChecker *				checker = [SamuraiCSSSelectorChecker new];
		SamuraiCSSSelectorCheckingContext *		context = [SamuraiCSSSelectorCheckingContext new];
		SamuraiCSSSelectorCheckerMatchResult *	matchResult = [SamuraiCSSSelectorCheckerMatchResult new];
		
		context.selector = ruleData.selector;
		context.element = element;

//    context.pseudo =
//    SelectorChecker checker(m_mode);
//    SelectorChecker::SelectorCheckingContext context(ruleData.selector(), m_context.element(), SelectorChecker::VisitedMatchEnabled);
//    context.elementStyle = m_style.get();
//    context.scope = scope;
//    context.pseudoId = m_pseudoStyleRequest.pseudoId;
//    context.scrollbar = m_pseudoStyleRequest.scrollbar;
//    context.scrollbarPart = m_pseudoStyleRequest.scrollbarPart;
//    context.isUARule = m_matchingUARules;
//    context.scopeContainsLastMatchedElement = m_scopeContainsLastMatchedElement;

		SamuraiCSSSelectorMatch match = [checker match:context result:matchResult];
		if ( SamuraiCSSSelectorMatches == match )
		{
			
// TODO: @(QFish) 检查伪类的逻辑
//    if (m_pseudoStyleRequest.pseudoId != NOPSEUDO && m_pseudoStyleRequest.pseudoId != result->dynamicPseudo)
//        return;

//		SamuraiCSSPseudoId dynamicPseudo = result.dynamicPseudo;
//		TODO: (@QFish) 检查 dynamicPseudo 来判断是否满足
//		addMatchedRule(&ruleData, result.specificity, cascadeOrder, matchRequest.styleSheetIndex, matchRequest.styleSheet);

			[matchedRules addObject:ruleData];
		}
	}
}

- (NSDictionary *)buildResultFromMatchedRules:(NSMutableArray *)matchedRules forElement:(id<SamuraiCSSProtocol>)element
{
#if __SAMURAI_DEBUG__
    if ( IS_CSS_DEBUG(element) )
    {
        PRINT( @">>>> Debug CSS at >>" );
        PRINT( @"Collecting rule for %@", element);
        TRAP();
    }
#endif // #if __SAMURAI_DEBUG__
    
	[matchedRules sortUsingComparator:^NSComparisonResult( SamuraiCSSRule * obj1, SamuraiCSSRule * obj2 ) {
		
		NSUInteger specificity1 = obj1.specificity;
		NSUInteger specificity2 = obj2.specificity;

#if __SAMURAI_DEBUG__
        if ( IS_CSS_DEBUG(element) )
        {
            PRINT(@"%@ | %@", obj1, obj2);
        }
#endif // #if __SAMURAI_DEBUG__
        
        return (specificity1 == specificity2) ? obj1.position > obj2.position : specificity1 > specificity2;
	}];

	NSMutableDictionary * style = nil;
    
    for ( SamuraiCSSRule * ruleData in matchedRules )
    {
        [[self class] collectDeclarations:ruleData.rule->declarations intoStyle:&style];
    }
    
#if __SAMURAI_DEBUG__
    if ( IS_CSS_DEBUG(element) )
    {
        PRINT( @"Result: %@", style );
    }
#endif // #if __SAMURAI_DEBUG__
    
	return style;
}

#pragma mark -

+ (void)collectDeclarations:(KatanaArray *)declarations intoStyle:(__autoreleasing NSMutableDictionary **)style
{
    if ( NULL == declarations )
        return;
    
    for ( size_t i = 0; i < declarations->length; i++ )
    {
        KatanaDeclaration * decl = declarations->data[i];
        
        if ( NULL == decl->property )
            continue;
        
        if ( nil == *style )
        {
            *style = [NSMutableDictionary dictionary];
        }
        
        NSString * key = [NSString stringWithUTF8String:decl->property];
        NSObject * val = [SamuraiCSSArray parseDeclaration:decl];
        
        if ( key && val )
        {
            SamuraiCSSArray * last = [*style valueForKey:key];
            
            if ( last ) // Already exists for current property,
            {
                if ( last.isImportant ) // If last one is important,
                {
                    if ( decl->important ) // and current one is impotrant too.
                    {
                        [*style setValue:val forKey:key]; // Replace it
                    }
                    // or do nothing
                }
                else // or just replace it
                {
                    [*style setValue:val forKey:key];
                }
            }
            else // or just set it
            {
                [*style setValue:val forKey:key];
            }
        }
    }
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, CSSRuleCollector )

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
