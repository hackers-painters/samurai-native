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
#import "Samurai_CSSRuleSet.h"
#import "Samurai_CSSSelectorChecker.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@interface SamuraiCSSRuleData ()
@property (nonatomic, readwrite) NSInteger specificity;
@end

#pragma mark -

@implementation SamuraiCSSRuleData

- (instancetype)initWithRule:(KatanaStyleRule *)rule
                    selector:(KatanaSelector *)selector
                    position:(NSUInteger)position
{
    self = [super init];
    if (self) {
        _rule = rule;
        _specificity = -1;
        _position = position;
        _selector = selector;
    }
    return self;
}

- (NSInteger)specificity
{
    if ( _specificity == -1 ) {
        _specificity = katana_calc_specificity_for_selector(_selector);
    }
    return _specificity;
}

@end

#pragma mark -

@interface SamuraiCSSRuleCollector()

@property (nonatomic, strong, readonly) SamuraiCSSRuleSet * ruleSet;
@property (nonatomic, strong, readonly) id<SamuraiCSSProtocol> element;
@property (nonatomic, strong) NSMutableArray * matchedRules;
@property (nonatomic, strong) NSMutableDictionary * style;
@end

#pragma mark -

@implementation SamuraiCSSRuleCollector

- (instancetype)initWithRuleSet:(SamuraiCSSRuleSet *)ruleSet;
{
    self = [super init];
    if (self) {
        _ruleSet = ruleSet;
    }
    return self;
}

- (NSDictionary *)styleForElement:(id<SamuraiCSSProtocol>)element
{
    if ( _element != element )
    {
        _element = element;
        
        [self collect];
        [self buildStyle];
    }
    
    return self.style;
}

#pragma mark -

- (void)collectMatchingRules:(id<SamuraiCSSProtocol>)element ruleSet:(SamuraiCSSRuleSet *)ruleSet
{
    NSString * pseudoId = [element cssShadowPseudoId];
    
    if ( !pseudoId )
    {
        [self collectMatchingRulesForList:[ruleSet shadowPseudoElementRulesWithKey:pseudoId]];
    }
    // ID
    if ( [element cssId] )
    {
        [self collectMatchingRulesForList:[ruleSet idRulesWithKey:[element cssId]]];
    }
    // .Class
    if ( [element cssClasses] )
    {
        for ( NSString * className in [element cssClasses] )
        {
            [self collectMatchingRulesForList:[ruleSet classRulesWithKey:className]];
        }
    }
//    if (element.isLink())
//        collectMatchingRulesForList(matchRequest.ruleSet->linkPseudoClassRules(), cascadeOrder, matchRequest, ruleRange);
//    if (SelectorChecker::matchesFocusPseudoClass(element))
//        collectMatchingRulesForList(matchRequest.ruleSet->focusPseudoClassRules(), cascadeOrder, matchRequest, ruleRange);

    // Tag
    if ( [element cssTag] )
    {
        [self collectMatchingRulesForList:[ruleSet tagRulesWithKey:[element cssTag]]];
    }
    // universal
    [self collectMatchingRulesForList:[ruleSet universalRules]];
}

- (void)collectMatchingRulesForList:(NSArray *)rules
{
    if ( !rules )
        return;
    
    for ( SamuraiCSSRuleData * rule in rules )
        [self collectRuleIfMatches:rule];
}

- (void)collectRuleIfMatches:(SamuraiCSSRuleData *)ruleData
{
    KatanaStyleRule * rule = ruleData.rule;
    KatanaArray * declarations = rule->declarations;
    
    if ( NULL == declarations || 0 == declarations->length )
        return;
    
    SamuraiCSSSelectorCheckerMatchResult *result = [SamuraiCSSSelectorCheckerMatchResult new];
    
    if ( [self ruleMatches:ruleData result:result] )
    {
//        SamuraiCSSPseudoId dynamicPseudo = result.dynamicPseudo;
        // TODO: (@QFish) 检查 dynamicPseudo 来判断是否满足
//        addMatchedRule(&ruleData, result.specificity, cascadeOrder, matchRequest.styleSheetIndex, matchRequest.styleSheet);
        [self.matchedRules addObject:ruleData];
    }
}

- (BOOL)ruleMatches:(SamuraiCSSRuleData *)ruleData result:(SamuraiCSSSelectorCheckerMatchResult *)result
{
    SamuraiCSSSelectorChecker * selectorChecker = [SamuraiCSSSelectorChecker new];
    SamuraiCSSSelectorCheckingContext * context = [SamuraiCSSSelectorCheckingContext new];
    context.selector = ruleData.selector;
    context.element = self.element;
//    context.pseudo =
//    SelectorChecker selectorChecker(m_mode);
//    SelectorChecker::SelectorCheckingContext context(ruleData.selector(), m_context.element(), SelectorChecker::VisitedMatchEnabled);
//    context.elementStyle = m_style.get();
//    context.scope = scope;
//    context.pseudoId = m_pseudoStyleRequest.pseudoId;
//    context.scrollbar = m_pseudoStyleRequest.scrollbar;
//    context.scrollbarPart = m_pseudoStyleRequest.scrollbarPart;
//    context.isUARule = m_matchingUARules;
//    context.scopeContainsLastMatchedElement = m_scopeContainsLastMatchedElement;
    SamuraiCSSSelectorMatch match = [selectorChecker match:context result:result];
    if (match != SamuraiCSSSelectorMatches)
        return NO;
    // TODO: @(QFish) 检查伪类的逻辑
//    if (m_pseudoStyleRequest.pseudoId != NOPSEUDO && m_pseudoStyleRequest.pseudoId != result->dynamicPseudo)
//        return false;
    return YES;
}

#pragma mark -

- (void)collect
{
    [self clearMatchedRules];
    [self collectMatchingRules:self.element ruleSet:self.ruleSet];
    [self sortAndTransferMatchedRules];
}

- (void)buildStyle
{
    if ( _style ) {
        [_style removeAllObjects];
    } else {
        _style = [NSMutableDictionary dictionary];
    }
    
    for ( SamuraiCSSRuleData * ruleData in self.matchedRules )
    {
        KatanaStyleRule * rule = ruleData.rule;
        
        for (size_t i=0; i<rule->declarations->length; i++)
        {
            KatanaDeclaration * decl = rule->declarations->data[i];
            
            if ( decl->property )
            {
                SamuraiCSSValueWrapper * wrapper = [SamuraiCSSValueWrapper new];
                // TODO: @(QFish) copy values, but no need for right now.
                // wrapper.values = decl->values;
                wrapper.rawValue = [NSString stringWithUTF8String:decl->raw];
//                 NSLog( @"%@ %s :%@", [self.element cssClasses], decl->property, wrapper );
                [self.style setValue:wrapper forKey:[NSString stringWithUTF8String:decl->property]];
            }
        }
    }
}

- (void)sortAndTransferMatchedRules
{
    [_matchedRules sortUsingComparator:^NSComparisonResult(SamuraiCSSRuleData * obj1, SamuraiCSSRuleData * obj2) {
        NSUInteger specificity1 = obj1.specificity;
        NSUInteger specificity2 = obj2.specificity;
        // TODO: @(QFish) should consider position
        //        return (specificity1 == specificity2) ? obj1.position > obj2.position : specificity1 > specificity2;
        return specificity1 > specificity2;
    }];
}

#pragma mark -

- (void)clearMatchedRules
{
    [_matchedRules removeAllObjects];
}

- (NSMutableArray *)matchedRules
{
    if ( !_matchedRules ) {
        _matchedRules = [NSMutableArray array];
    }
    return _matchedRules;
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
