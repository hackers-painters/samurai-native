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

@interface SamuraiCSSRuleData ()
@property (nonatomic, readwrite) NSUInteger specificity;
@end

@implementation SamuraiCSSRuleData

- (instancetype)initWithRule:(KatanaStyleRule *)rule
                    selector:(KatanaSelector *)selector
                    position:(NSUInteger)position
{
    self = [super init];
    if (self) {
        _rule = rule;
        _specificity = ULONG_MAX;
        _position = position;
        _selector = selector;
    }
    return self;
}

- (NSUInteger)specificity
{
    if ( _specificity == ULONG_MAX ) {
        _specificity = katana_calc_specificity_for_selector(_selector);
    }
    return _specificity;
}

@end

@interface SamuraiCSSRuleCollector()

@property (nonatomic, strong, readonly) SamuraiCSSRuleSet * ruleSet;
@property (nonatomic, strong, readonly) id<SamuraiCSSProtocol> element;
@property (nonatomic, strong) NSMutableArray * matchedRules;
@property (nonatomic, strong) NSMutableDictionary * style;
@end

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

- (void)collect
{
    [self clearMatchedRules];
    [self collectRulesForStyleable:self.element ruleSet:self.ruleSet];
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
                // NSLog( @"%@ %s :%@", [self.element cssClasses], decl->property, wrapper );
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

- (void)collectRulesForStyleable:(id<SamuraiCSSProtocol>)element ruleSet:(SamuraiCSSRuleSet *)ruleSet
{
    // #id
    if ( [element cssId] )
    {
        [self collectMatchingRulesForList:[ruleSet idRulesWithKey:[element cssId]]];
    }
    // .class
    if ( [element cssClasses] )
    {
        for ( NSString * className in [element cssClasses] )
        {
            [self collectMatchingRulesForList:[ruleSet classRulesWithKey:className]];
        }
    }
    //   // :pseudo
    //    if ( [element supportPseudo] )
    //    {
    //        for ( NSString * pseudo in self.element.stylePseudos )
    //        {
    //            [self collectMatchingRulesForList:[ruleSet pseudoRulesWithKey:pseudo]];
    //        }
    //    }
    //
    // element
    if ( [element cssTag] )
    {
        [self collectMatchingRulesForList:[ruleSet tagRulesWithKey:[element cssTag]]];
    }
    // * or ...
    [self collectMatchingRulesForList:[ruleSet universalRules]];
}

- (void)collectMatchingRulesForList:(NSArray *)rules
{
    if ( !rules )
        return;
    
    for ( SamuraiCSSRuleData * ruleData in rules )
    {
        if ( [self ruleMatchesStylable:self.element ruleData:ruleData] )
        {
            [self.matchedRules addObject:ruleData];
        }
    }
}

- (BOOL)ruleMatchesStylable:(id<SamuraiCSSProtocol>)element ruleData:(SamuraiCSSRuleData *)ruleData
{
    SamuraiCSSSelectorMatch matches = \
    [SamuraiCSSSelectorChecker checkSelector:ruleData.selector
                                     element:self.element
                                       attrs:nil];
    
    return matches == SamuraiCSSSelectorMatches;
}

- (NSMutableArray *)matchedRules
{
    if ( !_matchedRules ) {
        _matchedRules = [NSMutableArray array];
    }
    return _matchedRules;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "_pragma_pop.h"
