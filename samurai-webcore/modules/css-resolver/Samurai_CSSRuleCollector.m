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
#import "Samurai_CSSParser.h"
#import "Samurai_CSSSelectorChecker.h"
#import "Samurai_CSSObject.h"
#import "Samurai_CSSArray.h"
#import "Samurai_CSSValue.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

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
	[matchedRules sortUsingComparator:^NSComparisonResult( SamuraiCSSRule * obj1, SamuraiCSSRule * obj2 ) {
		
		NSUInteger specificity1 = obj1.specificity;
		NSUInteger specificity2 = obj2.specificity;

        return (specificity1 == specificity2) ? obj1.position > obj2.position : specificity1 > specificity2;
	}];

	NSMutableDictionary * result = [[NSMutableDictionary alloc] init];
	NSMutableDictionary * importants = [[NSMutableDictionary alloc] init];

    for ( SamuraiCSSRule * ruleData in matchedRules )
    {
		NSDictionary * dict1 = [[SamuraiCSSParser sharedInstance] buildDictionary:ruleData.rule->declarations];
		NSDictionary * dict2 = [[SamuraiCSSParser sharedInstance] buildImportants:ruleData.rule->declarations];
		
		for ( NSString * key in dict1 )
		{
			NSObject * value = [dict1 objectForKey:key];
			
			if ( value )
			{
				[result setObject:value forKey:key];
			}
		}

		for ( NSString * key in dict2 )
		{
			NSObject * value = [dict2 objectForKey:key];
			
			if ( value )
			{
				[importants setObject:value forKey:key];
			}
		}
    }
	
// !important
	
	for ( NSString * key in importants )
	{
		NSObject * value = [importants objectForKey:key];
		
		if ( value )
		{
			[result setObject:value forKey:key];
		}
	}

	return result;
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
