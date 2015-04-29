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

#import "Samurai_CSSSelectorChecker.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

@implementation SamuraiCSSSelectorChecker

+ (BOOL)selectorTagMatches:(id<SamuraiCSSProtocol>)element selector:(KatanaSelector *)selector
{
    if ( !selector->tag )
        return true;
    
    NSString * localName = [NSString stringWithUTF8String:selector->tag->local];
    
    if ( NSOrderedSame == [localName compare:[element cssTag] options:NSCaseInsensitiveSearch] )
        return true;
    if ( [localName isEqualToString:@"*"] )
        return true;
    
    return false;
}

+ (BOOL)checkOneSelector:(KatanaSelector *)selector element:(id<SamuraiCSSProtocol>)element attrs:(NSSet *)attrs
{
    if ( nil == element )
        return false;
    
    if ( selector->match == KatanaSelectorMatchTag )
    {
        return [self selectorTagMatches:element selector:selector];
    }
    
    //    if (  [selector hasAttribute] )
    //    {
    if ( selector->data->value )
    {
        NSString * value = [NSString stringWithUTF8String:selector->data->value];
        
        if ( selector->match == KatanaSelectorMatchClass )
            return [element cssClasses] && [[element cssClasses] containsObject:value];
        
        if ( selector->match == KatanaSelectorMatchId )
            return [element cssId] && [[element cssId] isEqualToString:value];
        
        //        // TODO: attribute check
        //    }
        
        // TODO: pseudoClass check
        if ( selector->match == KatanaSelectorMatchPseudoClass || selector->match == KatanaSelectorMatchUnknown )
        {
            // any ":pseudo" is true.
            // TODO: should check if element has PseudoClass
            BOOL matched = true;
            
            //        switch ( selector->pseudoType )
            //        {
            //            case KatanaSelectorPseudoFirstChild:
            //                matched = [element isFirstChild];
            //                break;
            //            case KatanaSelectorPseudoLastChild:
            //                matched = [element isLastChild];
            //                break;
            //            case KatanaSelectorPseudoNthChild:
            //                matched = [element isNthChild:[selector->argument integerValue]];
            //                break;
            //            case KatanaSelectorPseudoUnknown:
            //            default:
            //                matched = true;
            //                break;
            //        }
            
            return matched;
        }
    }
    
    // TODO: PseudoElement check
    
    return false;
}

// Recursive check of selectors and combinators
// It can return 4 different values:
// * SelectorMatches          - the selector matches the element e
// * SelectorFailsLocally     - the selector fails for the element e
// * SelectorFailsAllSiblings - the selector fails for e and any sibling of e
// * SelectorFailsCompletely  - the selector fails for e and any sibling or ancestor of e
+ (SamuraiCSSSelectorMatch)checkSelector:(KatanaSelector*)selector element:(id<SamuraiCSSProtocol>)element attrs:(NSSet *)attrs
{
    if ( !element || ![element cssIsElement] )
        return SamuraiCSSSelectorFailsCompletely;
    
    // first selector has to match
    BOOL checked = [self checkOneSelector:selector element:element attrs:attrs];
    if ( !checked )
        return SamuraiCSSSelectorFailsLocally;
    
    // The rest of the selectors has to match
    NSUInteger relation = selector->relation;
    
    // Prepare next sel
    selector = selector->tagHistory;
    if ( !selector )
        return SamuraiCSSSelectorMatches;
    
    // get the elment shadow pointer
    id<SamuraiCSSProtocol> shadow = element;
    
    switch (relation) {
        case KatanaSelectorRelationDescendant: // selector1 selector2, 1 is 2's ancestor
            while (true)
            {
                SamuraiCSSSelectorMatch match = [self checkSelector:selector element:shadow attrs:attrs];
                if ( match != SamuraiCSSSelectorFailsLocally )
                    return match;
                shadow = [shadow cssParent];
            }
            break;
        case KatanaSelectorRelationChild: // selector1 > selector2, 1 is 2's parent
        {
            shadow = [shadow cssParent];
            return [self checkSelector:selector element:shadow attrs:attrs];
        }
        case KatanaSelectorRelationDirectAdjacent: // selector1 + selector2, 1 is 2's closest brother
        {
            shadow = [shadow cssSiblingAtIndex:-1];
            return [self checkSelector:selector element:shadow attrs:attrs];
        }
        case KatanaSelectorRelationIndirectAdjacent: // selector1 ~ selector2, 1 is 2's older brother
        {
            NSArray * siblings = [shadow cssPreviousSiblings];
            
            for ( id<SamuraiCSSProtocol> brother in siblings )
            {
                if ( SamuraiCSSSelectorMatches == [self checkSelector:selector element:brother attrs:attrs] )
                    return SamuraiCSSSelectorMatches;
            }
            return SamuraiCSSSelectorFailsLocally;
        }
        case KatanaSelectorRelationSubSelector:       // selector:pseudo
        case KatanaSelectorRelationShadowPseudo:      // selector::pseudo
        {
            // TODO: check more ~ check more ~
            return [self checkSelector:selector element:shadow attrs:attrs];
        }
    }
    
    return SamuraiCSSSelectorFailsCompletely;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "_pragma_pop.h"
