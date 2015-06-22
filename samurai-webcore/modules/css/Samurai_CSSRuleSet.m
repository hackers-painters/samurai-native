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

#import "Samurai_CSSRuleSet.h"
#import "Samurai_CSSRuleCollector.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@interface SamuraiCSSRuleSet()

@property (nonatomic, assign) NSUInteger ruleCount;
@property (nonatomic, strong) NSMutableDictionary * idRules;
@property (nonatomic, strong) NSMutableDictionary * classRules;
@property (nonatomic, strong) NSMutableDictionary * tagRules;
@property (nonatomic, strong) NSMutableDictionary * shadowPseudoElementRules;
@property (nonatomic, strong) NSMutableDictionary * pseudoRules;
@property (nonatomic, strong) NSMutableArray * linkPseudoClassRules;
@property (nonatomic, strong) NSMutableArray * focusPseudoClassRules;
@property (nonatomic, strong) NSMutableArray * privateUniversalRules;
@property (nonatomic, strong) NSMutableArray * fontFaceRules;
@property (nonatomic, strong) NSMutableArray * keyframesRules;

@end

#pragma mark -

@implementation SamuraiCSSRuleSet

- (id)init
{
    self = [super init];
    
    if ( self )
    {
        _idRules = [NSMutableDictionary dictionary];
        _classRules = [NSMutableDictionary dictionary];
        _tagRules = [NSMutableDictionary dictionary];
        _shadowPseudoElementRules = [NSMutableDictionary dictionary];
        _linkPseudoClassRules = [NSMutableArray array];
        _pseudoRules = [NSMutableDictionary dictionary];
        _focusPseudoClassRules = [NSMutableArray array];
        _privateUniversalRules = [NSMutableArray array];
        _fontFaceRules = [NSMutableArray array];
        _keyframesRules = [NSMutableArray array];
    }
    
    return self;
}

- (void)dealloc
{
    [self clear];
    
    self.idRules               = nil;
    self.tagRules              = nil;
    self.classRules            = nil;
    self.pseudoRules           = nil;
    self.privateUniversalRules = nil;
}

- (void)clear
{
    [self.idRules removeAllObjects];
    [self.tagRules removeAllObjects];
    [self.classRules removeAllObjects];
    [self.pseudoRules removeAllObjects];
    [self.privateUniversalRules removeAllObjects];
}

- (NSArray *)universalRules
{
    return self.privateUniversalRules;
}

- (NSArray *)idRulesWithKey:(NSString *)key
{
    return self.idRules[key];
}

- (NSArray *)tagRulesWithKey:(NSString *)key
{
    return self.tagRules[key];
}

- (NSArray *)classRulesWithKey:(NSString *)key
{
    return self.classRules[key];
}

- (NSArray *)pseudoRulesWithKey:(NSString *)key
{
    return self.pseudoRules[key];
}

- (NSArray *)shadowPseudoElementRulesWithKey:(NSString *)key
{
    return self.shadowPseudoElementRules[key];
}

- (void)mergeWithRuleSet:(SamuraiCSSRuleSet *)ruleSet
{
    [self.idRules addEntriesFromDictionary:ruleSet.idRules];
    [self.tagRules addEntriesFromDictionary:ruleSet.tagRules];
    [self.classRules addEntriesFromDictionary:ruleSet.classRules];
    [self.pseudoRules addEntriesFromDictionary:ruleSet.pseudoRules];
    [self.privateUniversalRules addObjectsFromArray:ruleSet.privateUniversalRules];
    _ruleCount = self.idRules.count + self.tagRules.count + self.classRules.count + self.pseudoRules.count +
    self.privateUniversalRules.count;
}

- (void)addRulesFromSheet:(KatanaStylesheet *)sheet
{
    if ( !sheet )
        return;
    
    [self addChildRules:&sheet->imports];
    [self addChildRules:&sheet->rules];
}

- (void)addChildRules:(KatanaArray *)childRules
{
    for (int i=0; i<childRules->length; i++)
    {
        KatanaRule* rule = childRules->data[i];
        
        switch ( rule->type )
        {
            case KatanaRuleStyle:
                [self addStyleRule:(KatanaStyleRule *)rule];
                break;
            case KatanaRuleImport:
            {
                KatanaImportRule * import = (KatanaImportRule *)rule;
                
                if ( self.mediaQueryChecker &&
                    [self.mediaQueryChecker testMediaQueries:import->medias] )
                {
                    // TODO: @(QFish) handle import rule
                }
            }
                break;
            case KatanaRuleFontFace:
            {
                // TODO: @(QFish) handle font-face rule
            }
                break;
            case KatanaRuleKeyframes:
            {
                // TODO: @(QFish) handle keyframes rule
            }
                break;
            case KatanaRuleMedia:
            {
                KatanaMediaRule * mediaRule = (KatanaMediaRule *)rule;
                
                if ( self.mediaQueryChecker &&
                    [self.mediaQueryChecker testMediaQueries:mediaRule->medias] )
                {
                    [self addChildRules:mediaRule->rules];
                }
            }
                break;
            case KatanaRuleSupports:
            case KatanaRuleCharset:
            case KatanaRuleHost:
            case KatanaRuleUnkown:
                break;
        }
    }
}

- (void)addStyleRule:(KatanaStyleRule *)rule
{
    for (int i=0; i<rule->selectors->length; i++)
    {
        KatanaSelector * selector = rule->selectors->data[i];
        
        SamuraiCSSRuleData * data = [[SamuraiCSSRuleData alloc] initWithRule:rule
                                                                    selector:selector position:(self.ruleCount++)];
        
        [self collectFeaturesFromRuleData];
        
        if ( ![self findBestRuleSetAndAddWithSelector:selector ruleData:data] )
        {
            [_privateUniversalRules addObject:data];
        }
    }
}

- (void)collectFeaturesFromRuleData
{
    
}

- (BOOL)findBestRuleSetAndAddWithSelector:(KatanaSelector *)selector ruleData:(SamuraiCSSRuleData *)ruleData
{
    if ( selector->match == KatanaSelectorMatchId )
    {
        [self addToRuleSet:_idRules key:selector->data->value ruleData:ruleData selector:selector];
        return YES;
    }
    
    if ( selector->match == KatanaSelectorMatchClass )
    {
        [self addToRuleSet:_classRules key:selector->data->value ruleData:ruleData selector:selector];
        return YES;
    }
    
    //    if ( [selector isCustomPseudoElement] )
    //    {
    //        [self addToRuleSet:_shadowPseudoElementRules key:selector->data->value ruleData:ruleData selector:selector];
    //        return YES;
    //    }
    //
    //    if ( [selector isCommonPseudoClassSelector] )
    //    {
    //        switch ( selector->pseudoType )
    //        {
    //            case KatanaSelectorPseudoLink:
    //            case KatanaSelectorPseudoVisited:
    //            case KatanaSelectorPseudoAnyLink:
    //                [_linkPseudoClassRules addObject:ruleData];
    //                return true;
    //            case KatanaSelectorPseudoFocus:
    //                [_focusPseudoClassRules addObject:ruleData];
    //                return true;
    //            default:
    //                return true;
    //        }
    //    }
    
    if ( selector->match == KatanaSelectorMatchTag )
    {
        // If this is part of a subselector chain, recurse ahead to find a narrower set (ID/class/:pseudo)
        
        if ( selector->relation == KatanaSelectorRelationSubSelector )
        {
            KatanaSelector * next = selector->tagHistory;
            if ( next != NULL && (next->match == KatanaSelectorMatchClass
                                  || next->match == KatanaSelectorMatchId)
                //                || [next isCommonPseudoClassSelector]
                )
            {
                if ( [self findBestRuleSetAndAddWithSelector:next ruleData:ruleData] )
                {
                    return YES;
                }
            }
        }
        
        //        if ( ![selector->tag.localName isEqualToString:@"*"] )
        {
            [self addToRuleSet:_tagRules key:selector->tag->local ruleData:ruleData selector:selector];
        }
    }
    
    return NO;
}

- (void)addToRuleSet:(NSMutableDictionary *)map
                 key:(const char*)key
            ruleData:(SamuraiCSSRuleData *)ruleData
            selector:(KatanaSelector *)selector
{
    if (!key || !map || !ruleData)
        return;
    
    NSString * string = [NSString stringWithUTF8String:key];
    
    NSMutableArray * rules = [map objectForKey:string];
    
    if (!rules)
    {
        rules = [NSMutableArray array];
        [map setValue:rules forKey:string];
    }
    
    [rules addObject:ruleData];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, CSSRuleSet )

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
