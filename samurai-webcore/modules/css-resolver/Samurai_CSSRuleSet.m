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
#import "Samurai_CSSRule.h"
#import "Samurai_CSSRuleCollector.h"
#import "Samurai_CSSMediaQuery.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiCSSRuleSet
{
	NSUInteger _ruleSeed;
}

@def_prop_strong( NSMutableDictionary *,	idRules );
@def_prop_strong( NSMutableDictionary *,	tagRules );
@def_prop_strong( NSMutableDictionary *,	classRules );
@def_prop_strong( NSMutableDictionary *,	pseudoRules );
@def_prop_strong( NSMutableArray *,			fontFaceRules );
@def_prop_strong( NSMutableArray *,			keyframesRules );
@def_prop_strong( NSMutableArray *,			linkPseudoClassRules );
@def_prop_strong( NSMutableArray *,			focusPseudoClassRules );
@def_prop_strong( NSMutableArray *,			privateUniversalRules );
@def_prop_strong( NSMutableDictionary *,	shadowPseudoElementRules );

- (id)init
{
    self = [super init];
    
    if ( self )
    {
		_ruleSeed = 0;

        self.idRules					= [NSMutableDictionary dictionary];
		self.tagRules					= [NSMutableDictionary dictionary];
        self.classRules					= [NSMutableDictionary dictionary];
		self.pseudoRules				= [NSMutableDictionary dictionary];
		self.fontFaceRules				= [NSMutableArray array];
		self.keyframesRules				= [NSMutableArray array];
        self.privateUniversalRules		= [NSMutableArray array];
		self.shadowPseudoElementRules	= [NSMutableDictionary dictionary];
    }
	
    return self;
}

- (void)dealloc
{
    [self clear];
    
	self.idRules					= nil;
	self.tagRules					= nil;
	self.classRules					= nil;
	self.pseudoRules				= nil;
	self.fontFaceRules				= nil;
	self.keyframesRules				= nil;
	self.linkPseudoClassRules		= nil;
	self.focusPseudoClassRules		= nil;
	self.privateUniversalRules		= nil;
	self.shadowPseudoElementRules	= nil;
}

- (void)clear
{
	[self.idRules removeAllObjects];
	[self.tagRules removeAllObjects];
	[self.classRules removeAllObjects];
	[self.pseudoRules removeAllObjects];
	[self.fontFaceRules removeAllObjects];
	[self.keyframesRules removeAllObjects];
	[self.linkPseudoClassRules removeAllObjects];
	[self.focusPseudoClassRules removeAllObjects];
	[self.privateUniversalRules removeAllObjects];
	[self.shadowPseudoElementRules removeAllObjects];
}

- (NSArray *)universalRules
{
    return self.privateUniversalRules;
}

- (NSArray *)idRulesWithKey:(NSString *)key
{
	if ( nil == key )
		return nil;
	
    return [self.idRules objectForKey:key];
}

- (NSArray *)tagRulesWithKey:(NSString *)key
{
	if ( nil == key )
		return nil;

    return [self.tagRules objectForKey:key];
}

- (NSArray *)classRulesWithKey:(NSString *)key
{
	if ( nil == key )
		return nil;

    return [self.classRules objectForKey:key];
}

- (NSArray *)pseudoRulesWithKey:(NSString *)key
{
	if ( nil == key )
		return nil;

    return [self.pseudoRules objectForKey:key];
}

- (NSArray *)shadowPseudoElementRulesWithKey:(NSString *)key
{
	if ( nil == key )
		return nil;

    return [self.shadowPseudoElementRules objectForKey:key];
}

#pragma mark -

- (void)addStyleRule:(KatanaStyleRule *)rule
{
	for ( unsigned int i = 0; i < rule->selectors->length; i++ )
	{
		KatanaSelector * selector = rule->selectors->data[i];

		SamuraiCSSRule * data = [[SamuraiCSSRule alloc] initWithRule:rule
															selector:selector
															position:_ruleSeed++];

		TODO( "collect features from rule data" );

		BOOL found = [self findBestRuleSetAndAddWithSelector:selector ruleData:data];
		if ( NO == found )
		{
			[self.privateUniversalRules addObject:data];
		}
	}
}

- (void)addStyleRules:(KatanaArray *)childRules
{
    for ( unsigned int i = 0; i < childRules->length; i++ )
    {
        KatanaRule * rule = childRules->data[i];
        
        switch ( rule->type )
        {
            case KatanaRuleStyle:
			{
                [self addStyleRule:(KatanaStyleRule *)rule];
			}
			break;
				
            case KatanaRuleImport:
            {
                KatanaImportRule * import = (KatanaImportRule *)rule;
                
                if ( [[SamuraiCSSMediaQuery sharedInstance] testMediaQueries:import->medias] )
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
                
                if ( [[SamuraiCSSMediaQuery sharedInstance] testMediaQueries:mediaRule->medias] )
                {
                    [self addStyleRules:mediaRule->rules];
                }
            }
			break;
	
            case KatanaRuleSupports:
            case KatanaRuleCharset:
            case KatanaRuleHost:
            case KatanaRuleUnkown:
			default:
			break;
        }
    }
}

#pragma mark -

- (BOOL)findBestRuleSetAndAddWithSelector:(KatanaSelector *)selector ruleData:(SamuraiCSSRule *)ruleData
{
    if ( selector->match == KatanaSelectorMatchId )
    {
        [self addToRuleSet:self.idRules
					   key:@(selector->data->value)
				  ruleData:ruleData
				  selector:selector];
		
        return YES;
    }
    
    if ( selector->match == KatanaSelectorMatchClass )
    {
        [self addToRuleSet:self.classRules
					   key:@(selector->data->value)
				  ruleData:ruleData
				  selector:selector];
		
        return YES;
    }
    
//    if ( [selector isCustomPseudoElement] )
//    {
//        [self addToRuleSet:self.shadowPseudoElementRules key:@(selector->data->value) ruleData:ruleData selector:selector];
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
//                [self.linkPseudoClassRules addObject:ruleData];
//                return true;
//            case KatanaSelectorPseudoFocus:
//                [self.focusPseudoClassRules addObject:ruleData];
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
			
            if ( NULL != next && (next->match == KatanaSelectorMatchClass
								  || next->match == KatanaSelectorMatchId
				//                || [next isCommonPseudoClassSelector]
								  ))
            {
                if ( [self findBestRuleSetAndAddWithSelector:next ruleData:ruleData] )
                {
                    return YES;
                }
            }
        }

		[self addToRuleSet:self.tagRules
					   key:@(selector->tag->local)
				  ruleData:ruleData
				  selector:selector];
    }
    
    return NO;
}

- (void)addToRuleSet:(NSMutableDictionary *)map
                 key:(NSString *)key
            ruleData:(SamuraiCSSRule *)ruleData
            selector:(KatanaSelector *)selector
{
    if ( nil == key || nil == map || nil == ruleData )
        return;
    
    NSMutableArray * rules = [map objectForKey:key];

	if ( nil == rules )
    {
        rules = [NSMutableArray array];
		
        [map setValue:rules forKey:key];
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
