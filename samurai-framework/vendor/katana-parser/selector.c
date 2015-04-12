/**
 * Copyright (c) 2015 QFish <im@qfi.sh>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#include "selector.h"
#include "util.h"
#include "string.h"

// Refs:
// http://www.w3.org/TR/css3-selectors/
// https://github.com/nwjs/blink/blob/nw12/Source/core/css/CSSSelector.cpp

bool katana_selector_is_content_pseudo_element(const KatanaSelector* selector)
{
    return selector->match == KatanaSelectorMatchPseudoElement
            && selector->pseudo == KatanaSelectorPseudoString
            && !strncasecmp(selector->data->value, "content", sizeof("content"));
}

bool katana_selector_is_shadow_pseudo_element(const KatanaSelector* selector)
{
    return selector->match == KatanaSelectorMatchPseudoElement
            && selector->pseudo == KatanaSelectorPseudoString
            && !strncasecmp(selector->data->value, "shadow", sizeof("shadow"));
}
// TODO: To be supported
//- (BOOL)isCommonPseudoClassSelector
//{
//    if (_match != KatanaSelectorMatchPseudoClass)
//        return false;
//    KatanaSelectorPseudoType pseudoType = self.pseudoType;
//    return pseudoType == KatanaSelectorPseudoLink
//    || pseudoType == KatanaSelectorPseudoAnyLink
//    || pseudoType == KatanaSelectorPseudoVisited
//    || pseudoType == KatanaSelectorPseudoFocus;
//}

bool katana_selector_crosses_tree_scopes(const KatanaSelector* selector)
{
// TODO: To be supported
//    return [self isCustomPseudoElement]
//    || self.pseudoType == KatanaSelectorPseudoCue
//    || self.pseudoType == KatanaSelectorPseudoShadow;

    return false;
}

bool katana_selector_has_sibling(const KatanaSelector* selector)
{
    // KatanaSelectorPseudoType type = self.pseudoType;
    return selector->relation == KatanaSelectorRelationDirectAdjacent
    || selector->relation == KatanaSelectorRelationIndirectAdjacent;
}

bool katana_is_attribute_selector(const KatanaSelector* selector)
{
    return selector->match == KatanaSelectorMatchExact
    || selector->match == KatanaSelectorMatchSet
    || selector->match == KatanaSelectorMatchList
    || selector->match == KatanaSelectorMatchHyphen
    || selector->match == KatanaSelectorMatchContain
    || selector->match == KatanaSelectorMatchBegin
    || selector->match == KatanaSelectorMatchEnd;
}

KatanaParserString* katana_build_relation_selector_string(KatanaParser* parser, const char* relation, KatanaParserString* string, KatanaParserString* next, KatanaSelector* tagHistory)
{
    if ( NULL != relation ) {
        katana_string_prepend_characters(parser, relation, string);
    }
    
    if ( NULL != next ) {
        katana_string_append_string(parser, next, string);
    }
    
    KatanaParserString * result = katana_selector_to_string(parser, tagHistory, (KatanaParserString*)string);
    katana_parser_deallocate(parser, (void*) string->data);
    katana_parser_deallocate(parser, (void*) string);
    return result;
}

KatanaParserString* katana_selector_to_string(KatanaParser* parser, KatanaSelector* selector, KatanaParserString* next)
{
    KatanaParserString* string = katana_parser_allocate(parser, sizeof(KatanaParserString));
    katana_string_init(parser, string);
    
    bool tagIsForNamespaceRule = true;
    
    if (selector->match == KatanaSelectorMatchTag && tagIsForNamespaceRule)
    {
        if ( NULL == selector->tag->prefix )
            katana_string_append_characters(parser, selector->tag->local, string);
        else {
            katana_string_append_characters(parser, selector->tag->prefix, string);
            katana_string_append_characters(parser, "|", string);
            katana_string_append_characters(parser, selector->tag->local, string);
        }
    }

    const KatanaSelector* cs = selector;

    while (true) {
        if (cs->match == KatanaSelectorMatchId) {
            katana_string_append_characters(parser, "#", string);
            katana_string_append_characters(parser, cs->data->value, string);
        } else if (cs->match == KatanaSelectorMatchClass) {
            katana_string_append_characters(parser, ".", string);
            katana_string_append_characters(parser, cs->data->value, string);
        } else if (cs->match == KatanaSelectorMatchPseudoClass || cs->match == KatanaSelectorMatchPagePseudoClass) {
            katana_string_append_characters(parser, ":", string);
            katana_string_append_characters(parser, cs->data->value, string);
            
            switch (cs->pseudo) {
                case KatanaSelectorPseudoNot:
                    if ( cs->data->selectors ) {
                        KatanaArray* sels = cs->data->selectors;
                        for (int i=0; i<sels->length; i++) {
                            KatanaParserString* str = katana_selector_to_string(parser, sels->data[i], NULL);
                            katana_string_append_string(parser, str, string);
                            katana_parser_deallocate(parser, (void*) str->data);
                            katana_parser_deallocate(parser, (void*) str);
                            if ( i != sels->length -1 ) {
                                katana_string_append_characters(parser, ", ", string);
                            }
                        }
                        katana_string_append_characters(parser, ")", string);
                    }
                    break;
                case KatanaSelectorPseudoFunction: {
                    katana_string_append_characters(parser, cs->data->argument, string);
                    katana_string_append_characters(parser, ")", string);
                    }
                break;
//                case KatanaSelectorPseudoLang:
//                case KatanaSelectorPseudoNthChild:
//                case KatanaSelectorPseudoNthLastChild:
//                case KatanaSelectorPseudoNthOfType:
//                case KatanaSelectorPseudoNthLastOfType:
//                    katana_string_append_characters(parser, cs->argument, string);
//                    katana_string_append_characters(parser, ")", string);
//                    break;
//                case KatanaSelectorPseudoAny: {
//                    const KatanaSelector* firstSubSelector = cs->selectorList[0];
//                    for (const KatanaSelector* subSelector = firstSubSelector; subSelector; subSelector = subSelector.tagHistory) {
//                        if (subSelector != firstSubSelector)
//                            katana_string_append_characters(parser, ",", string);
//                        katana_string_append_characters(parser, [subSelector description], string);
//                    }
//                    katana_string_append_characters(parser, ")", string);
//                    break;
//                }
//                case KatanaSelectorPseudoHost:
//                case KatanaSelectorPseudoHostContext: {
//                    if (cs->selectorList) {
//                        const KatanaSelector* firstSubSelector = cs->selectorList[0];
//                        for (const KatanaSelector* subSelector = firstSubSelector; subSelector; subSelector = subSelector.tagHistory) {
//                            if (subSelector != firstSubSelector)
//                                katana_string_append_characters(parser, ",", string);
//                            katana_string_append_characters(parser, [subSelector description], string);
//                        }
//                        katana_string_append_characters(parser, ")", string);
//                    }
//                    break;
//                }
                default:
                    break;
            }
        } else if (cs->match == KatanaSelectorMatchPseudoElement) {
            katana_string_append_characters(parser, "::", string);
            katana_string_append_characters(parser, cs->data->value, string);
//            if (cs->pseudoType == KatanaSelectorPseudoContent) {
//                if (cs->relation == KatanaSelectorRelationSubSelector && cs->tagHistory)
//                    return [NSString stringWithFormat:@"%@%@%@", cs->tagHistory, str, rightSide];
//            }
        } else if (katana_is_attribute_selector(cs)) {
            katana_string_append_characters(parser, "[", string);
            if (NULL != cs->data->attribute->prefix) {
                katana_string_append_characters(parser, cs->data->attribute->prefix, string);
                katana_string_append_characters(parser, "|", string);
            }
            katana_string_append_characters(parser, cs->data->attribute->local, string);
            switch (cs->match) {
                case KatanaSelectorMatchExact:
                    katana_string_append_characters(parser, "=", string);
                    break;
                case KatanaSelectorMatchSet:
                    // set has no operator or value, just the attrName
                    katana_string_append_characters(parser, "]", string);
                    break;
                case KatanaSelectorMatchList:
                    katana_string_append_characters(parser, "~=", string);
                    break;
                case KatanaSelectorMatchHyphen:
                    katana_string_append_characters(parser, "|=", string);
                    break;
                case KatanaSelectorMatchBegin:
                    katana_string_append_characters(parser, "^=", string);
                    break;
                case KatanaSelectorMatchEnd:
                    katana_string_append_characters(parser, "$=", string);
                    break;
                case KatanaSelectorMatchContain:
                    katana_string_append_characters(parser, "*=", string);
                    break;
                default:
                    break;
            }
            if (cs->match != KatanaSelectorMatchSet) {
                katana_string_append_characters(parser, "\"", string);
                katana_string_append_characters(parser, cs->data->value, string);
                katana_string_append_characters(parser, "\"", string);
                katana_string_append_characters(parser, "]", string);
            }
        }
        if (cs->relation != KatanaSelectorRelationSubSelector || !cs->tagHistory)
            break;
        cs = cs->tagHistory;
    }

    KatanaSelector* tagHistory = cs->tagHistory;

    if ( NULL != tagHistory ) {
        switch (cs->relation) {
            case KatanaSelectorRelationDescendant:
            {
                return katana_build_relation_selector_string(parser, " ", string, next, tagHistory);
            }
            case KatanaSelectorRelationChild:
            {
                return katana_build_relation_selector_string(parser, " > ", string, next, tagHistory);
            }
            case KatanaSelectorRelationShadowDeep:
            {
                return katana_build_relation_selector_string(parser, " /deep/ ", string, next, tagHistory);
            }
            case KatanaSelectorRelationDirectAdjacent:
            {
                return katana_build_relation_selector_string(parser, " + ", string, next, tagHistory);
            }
            case KatanaSelectorRelationIndirectAdjacent:
            {
                return katana_build_relation_selector_string(parser, " ~ ", string, next, tagHistory);
            }
            case KatanaSelectorRelationSubSelector:
            {
                return NULL;
            }
            case KatanaSelectorRelationShadowPseudo:
            {
                return katana_build_relation_selector_string(parser, NULL, string, next, tagHistory);
            }
        }
    }
    
    if ( NULL != next ) {
        katana_string_append_string(parser, (KatanaParserString*)next, string);
    }
    
    return (KatanaParserString*)string;
}

unsigned calc_specificity_for_one_selector(const KatanaSelector* selector)
{
    // FIXME: Pseudo-elements and pseudo-classes do not have the same specificity. This function
    // isn't quite correct.
    switch ( selector->match ) {
        case KatanaSelectorMatchId:
            return 0x10000;
            
        case KatanaSelectorMatchPseudoClass:
        //            // FIXME: PsuedoAny should base the specificity on the sub-selectors.
        //            // See http://lists.w3.org/Archives/Public/www-style/2010Sep/0530.html
        //            if (self.pseudoType == PseudoClassNot && selectorList())
        //                return selectorList()->first()->specificityForOneSelector();
        //            FALLTHROUGH;
        case KatanaSelectorMatchExact:
        case KatanaSelectorMatchClass:
        case KatanaSelectorMatchSet:
        case KatanaSelectorMatchList:
        case KatanaSelectorMatchHyphen:
        case KatanaSelectorMatchPseudoElement:
        case KatanaSelectorMatchContain:
        case KatanaSelectorMatchBegin:
        case KatanaSelectorMatchEnd:
            return 0x100;
            
        case KatanaSelectorMatchTag:
            return !strncasecmp(selector->tag->local, "*", 1) ? 1 : 0;
        case KatanaSelectorMatchUnknown:
        case KatanaSelectorMatchPagePseudoClass:
            return 0;
    }
    
    return 0;
}

unsigned katana_calc_specificity_for_selector(KatanaSelector* selector)
{
    if ( NULL == selector ) {
        return 0;
    }
    // make sure the result doesn't overflow
    //    static const unsigned maxValueMask = 0xffffff;
    static const unsigned idMask = 0xff0000;
    static const unsigned classMask = 0xff00;
    static const unsigned elementMask = 0xff;
    
    //    if (isForPage())
    //        return specificityForPage() & maxValueMask;
    
    unsigned total = 0;
    unsigned temp = 0;
    
    for (const KatanaSelector * next = selector; next; next = next->tagHistory)
    {
        temp = total + calc_specificity_for_one_selector(next);
        // Clamp each component to its max in the case of overflow.
        if ((temp & idMask) < (total & idMask))
            total |= idMask;
        else if ((temp & classMask) < (total & classMask))
            total |= classMask;
        else if ((temp & elementMask) < (total & elementMask))
            total |= elementMask;
        else
            total = temp;
    }
    return total;
}
