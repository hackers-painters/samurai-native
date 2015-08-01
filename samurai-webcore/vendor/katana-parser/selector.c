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
#include <assert.h>

#undef	assert
#define assert(x)

// Refs:
// http://www.w3.org/TR/css3-selectors/
//

static KatanaPseudoType name_to_pseudo_type(const char* name, bool hasArguments);

bool katana_selector_crosses_tree_scopes(const KatanaSelector* selector)
{
    // TODO: To be supported
    return false;
}

// bool katana_is_attribute_selector(const KatanaSelector* selector)
// {
//     return selector->match == KatanaSelectorMatchAttributeExact
//     || selector->match == KatanaSelectorMatchAttributeSet
//     || selector->match == KatanaSelectorMatchAttributeList
//     || selector->match == KatanaSelectorMatchAttributeHyphen
//     || selector->match == KatanaSelectorMatchAttributeContain
//     || selector->match == KatanaSelectorMatchAttributeBegin
//     || selector->match == KatanaSelectorMatchAttributeEnd;
// }

KatanaPseudoType katana_parse_pseudo_type(const char* name, bool hasArguments)
{
    KatanaPseudoType pseudoType = name_to_pseudo_type(name, hasArguments);
    if (pseudoType != KatanaPseudoUnknown)
        return pseudoType;
    
    if (katana_string_has_prefix(name, "-webkit-"))
        return KatanaPseudoWebKitCustomElement;
    
    return KatanaPseudoUnknown;
}

void katana_selector_extract_pseudo_type(KatanaSelector* selector)
{
    if (selector->pseudo == KatanaPseudoUnknown)
        selector->pseudo = KatanaPseudoUnknown;
    
    if (selector->match != KatanaSelectorMatchPseudoClass && selector->match != KatanaSelectorMatchPseudoElement && selector->match != KatanaSelectorMatchPagePseudoClass)
        return;
    bool hasArguments = (NULL != selector->data->argument) || (NULL != selector->data->selectors);    
    selector->pseudo = katana_parse_pseudo_type(selector->data->value, hasArguments);
    
    bool element = false; // pseudo-element
    bool compat = false; // single colon compatbility mode
    bool isPagePseudoClass = false; // Page pseudo-class
    
    switch (selector->pseudo) {
        case KatanaPseudoAfter:
        case KatanaPseudoBefore:
        case KatanaPseudoFirstLetter:
        case KatanaPseudoFirstLine:
            compat = true;
        case KatanaPseudoBackdrop:
        case KatanaPseudoCue:
        case KatanaPseudoResizer:
        case KatanaPseudoScrollbar:
        case KatanaPseudoScrollbarCorner:
        case KatanaPseudoScrollbarButton:
        case KatanaPseudoScrollbarThumb:
        case KatanaPseudoScrollbarTrack:
        case KatanaPseudoScrollbarTrackPiece:
        case KatanaPseudoSelection:
        case KatanaPseudoWebKitCustomElement:
        case KatanaPseudoContent:
        case KatanaPseudoShadow:
            element = true;
            break;
        case KatanaPseudoUnknown:
        case KatanaPseudoEmpty:
        case KatanaPseudoFirstChild:
        case KatanaPseudoFirstOfType:
        case KatanaPseudoLastChild:
        case KatanaPseudoLastOfType:
        case KatanaPseudoOnlyChild:
        case KatanaPseudoOnlyOfType:
        case KatanaPseudoNthChild:
        case KatanaPseudoNthOfType:
        case KatanaPseudoNthLastChild:
        case KatanaPseudoNthLastOfType:
        case KatanaPseudoLink:
        case KatanaPseudoVisited:
        case KatanaPseudoAny:
        case KatanaPseudoAnyLink:
        case KatanaPseudoAutofill:
        case KatanaPseudoHover:
        case KatanaPseudoDrag:
        case KatanaPseudoFocus:
        case KatanaPseudoActive:
        case KatanaPseudoChecked:
        case KatanaPseudoEnabled:
        case KatanaPseudoFullPageMedia:
        case KatanaPseudoDefault:
        case KatanaPseudoDisabled:
        case KatanaPseudoOptional:
        case KatanaPseudoRequired:
        case KatanaPseudoReadOnly:
        case KatanaPseudoReadWrite:
        case KatanaPseudoScope:
        case KatanaPseudoValid:
        case KatanaPseudoInvalid:
        case KatanaPseudoIndeterminate:
        case KatanaPseudoTarget:
        case KatanaPseudoLang:
        case KatanaPseudoNot:
        case KatanaPseudoRoot:
        case KatanaPseudoWindowInactive:
        case KatanaPseudoCornerPresent:
        case KatanaPseudoDecrement:
        case KatanaPseudoIncrement:
        case KatanaPseudoHorizontal:
        case KatanaPseudoVertical:
        case KatanaPseudoStart:
        case KatanaPseudoEnd:
        case KatanaPseudoDoubleButton:
        case KatanaPseudoSingleButton:
        case KatanaPseudoNoButton:
        case KatanaPseudoNotParsed:
        case KatanaPseudoFullScreen:
        case KatanaPseudoFullScreenDocument:
        case KatanaPseudoFullScreenAncestor:
        case KatanaPseudoInRange:
        case KatanaPseudoOutOfRange:
        case KatanaPseudoFutureCue:
        case KatanaPseudoPastCue:
        case KatanaPseudoHost:
        case KatanaPseudoHostContext:
        case KatanaPseudoUnresolved:
        case KatanaPseudoSpatialNavigationFocus:
        case KatanaPseudoListBox:
            break;
        case KatanaPseudoFirstPage:
        case KatanaPseudoLeftPage:
        case KatanaPseudoRightPage:
            isPagePseudoClass = true;
            break;
    }
    
    bool matchPagePseudoClass = (selector->match == KatanaSelectorMatchPagePseudoClass);
    if (matchPagePseudoClass != isPagePseudoClass)
        selector->pseudo = KatanaPseudoUnknown;
    else if (selector->match == KatanaSelectorMatchPseudoClass && element) {
        if (!compat)
            selector->pseudo = KatanaPseudoUnknown;
        else
            selector->match = KatanaSelectorMatchPseudoElement;
    } else if (selector->match == KatanaSelectorMatchPseudoElement && !element)
        selector->pseudo = KatanaPseudoUnknown;
}

bool katana_selector_matches_pseudo_element(KatanaSelector* selector)
{
    if (selector->pseudo == KatanaPseudoUnknown)
        katana_selector_extract_pseudo_type(selector);
    return selector->match == KatanaSelectorMatchPseudoElement;
}

bool katana_selector_is_custom_pseudo_element(KatanaSelector* selector)
{
    return selector->match == KatanaSelectorMatchPseudoElement && selector->pseudo == KatanaPseudoWebKitCustomElement;
}

bool katana_selector_is_direct_adjacent(KatanaSelector* selector)
{
    return selector->relation == KatanaSelectorRelationDirectAdjacent || selector->relation == KatanaSelectorRelationIndirectAdjacent;
}

bool katana_selector_is_adjacent(KatanaSelector* selector)
{
    return selector->relation == KatanaSelectorRelationDirectAdjacent;
}

bool katana_selector_is_shadow(KatanaSelector* selector)
{
    return selector->relation == KatanaSelectorRelationShadowPseudo || selector->relation == KatanaSelectorRelationShadowDeep;
}

bool katana_selector_is_sibling(KatanaSelector* selector)
{
    katana_selector_extract_pseudo_type(selector);

    KatanaPseudoType type = selector->pseudo;
    return selector->relation == KatanaSelectorRelationDirectAdjacent
        || selector->relation == KatanaSelectorRelationIndirectAdjacent
        || type == KatanaPseudoEmpty
        || type == KatanaPseudoFirstChild
        || type == KatanaPseudoFirstOfType
        || type == KatanaPseudoLastChild
        || type == KatanaPseudoLastOfType
        || type == KatanaPseudoOnlyChild
        || type == KatanaPseudoOnlyOfType
        || type == KatanaPseudoNthChild
        || type == KatanaPseudoNthOfType
        || type == KatanaPseudoNthLastChild
        || type == KatanaPseudoNthLastOfType;
}

bool katana_selector_is_attribute(const KatanaSelector* selector)
{
    return selector->match >= KatanaSelectorMatchFirstAttribute;
}

bool katana_selector_is_content_pseudo_element(KatanaSelector* selector)
{
    katana_selector_extract_pseudo_type(selector);
    return selector->match == KatanaSelectorMatchPseudoElement && selector->pseudo == KatanaPseudoContent;
}

bool katana_selector_is_shadow_pseudo_element(KatanaSelector* selector)
{
    return selector->match == KatanaSelectorMatchPseudoElement
            && selector->pseudo == KatanaPseudoShadow;
}

bool katana_selector_is_host_pseudo_class(KatanaSelector* selector)
{
    return selector->match == KatanaSelectorMatchPseudoClass && (selector->pseudo == KatanaPseudoHost || selector->pseudo == KatanaPseudoHostContext);
}

bool katana_selector_is_tree_boundary_crossing(KatanaSelector* selector)
{
    katana_selector_extract_pseudo_type(selector);
    return selector->match == KatanaSelectorMatchPseudoClass && (selector->pseudo == KatanaPseudoHost || selector->pseudo == KatanaPseudoHostContext);
}

bool katana_selector_is_insertion_point_crossing(KatanaSelector* selector)
{
    katana_selector_extract_pseudo_type(selector);
    return (selector->match == KatanaSelectorMatchPseudoClass && selector->pseudo == KatanaPseudoHostContext)
        || (selector->match == KatanaSelectorMatchPseudoElement && selector->pseudo == KatanaPseudoContent);
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
    
    bool tag_is_implicit = true;
    
    if (selector->match == KatanaSelectorMatchTag && tag_is_implicit)
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
                case KatanaPseudoAny:
                case KatanaPseudoNot:
                case KatanaPseudoHost:
                case KatanaPseudoHostContext: {
                    if ( cs->data->selectors ) {
                        KatanaArray* sels = cs->data->selectors;
                        for (size_t i=0; i<sels->length; i++) {
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
                }
                    break;
                case KatanaPseudoLang:
                case KatanaPseudoNthChild:
                case KatanaPseudoNthLastChild:
                case KatanaPseudoNthOfType:
                case KatanaPseudoNthLastOfType: {
                    katana_string_append_characters(parser, cs->data->argument, string);
                    katana_string_append_characters(parser, ")", string);
                }
                    break;
                default:
                    break;
            }
        } else if (cs->match == KatanaSelectorMatchPseudoElement) {
            katana_string_append_characters(parser, "::", string);
            katana_string_append_characters(parser, cs->data->value, string);
        } else if (katana_selector_is_attribute(cs)) {
            katana_string_append_characters(parser, "[", string);
            if (NULL != cs->data->attribute->prefix) {
                katana_string_append_characters(parser, cs->data->attribute->prefix, string);
                katana_string_append_characters(parser, "|", string);
            }
            katana_string_append_characters(parser, cs->data->attribute->local, string);
            switch (cs->match) {
                case KatanaSelectorMatchAttributeExact:
                    katana_string_append_characters(parser, "=", string);
                    break;
                case KatanaSelectorMatchAttributeSet:
                    katana_string_append_characters(parser, "]", string);
                    break;
                case KatanaSelectorMatchAttributeList:
                    katana_string_append_characters(parser, "~=", string);
                    break;
                case KatanaSelectorMatchAttributeHyphen:
                    katana_string_append_characters(parser, "|=", string);
                    break;
                case KatanaSelectorMatchAttributeBegin:
                    katana_string_append_characters(parser, "^=", string);
                    break;
                case KatanaSelectorMatchAttributeEnd:
                    katana_string_append_characters(parser, "$=", string);
                    break;
                case KatanaSelectorMatchAttributeContain:
                    katana_string_append_characters(parser, "*=", string);
                    break;
                default:
                    break;
            }
            if (cs->match != KatanaSelectorMatchAttributeSet) {
                katana_string_append_characters(parser, "\"", string);
                katana_string_append_characters(parser, cs->data->value, string);
                katana_string_append_characters(parser, "\"", string);
                if (cs->data->bits.attributeMatchType == KatanaAttributeMatchTypeCaseInsensitive)
                    katana_string_append_characters(parser, " i", string);
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
    switch ( selector->match ) {
        case KatanaSelectorMatchId:
            return 0x10000;
            
        case KatanaSelectorMatchPseudoClass:
        case KatanaSelectorMatchAttributeExact:
        case KatanaSelectorMatchClass:
        case KatanaSelectorMatchAttributeSet:
        case KatanaSelectorMatchAttributeList:
        case KatanaSelectorMatchAttributeHyphen:
        case KatanaSelectorMatchPseudoElement:
        case KatanaSelectorMatchAttributeContain:
        case KatanaSelectorMatchAttributeBegin:
        case KatanaSelectorMatchAttributeEnd:
            return 0x100;
            
        case KatanaSelectorMatchTag:
            return !strcasecmp(selector->tag->local, "*") ? 0 : 1;
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
    
    static const unsigned idMask = 0xff0000;
    static const unsigned classMask = 0xff00;
    static const unsigned elementMask = 0xff;
    
    unsigned total = 0;
    unsigned temp = 0;
    
    for (const KatanaSelector * next = selector; next; next = next->tagHistory)
    {
        temp = total + calc_specificity_for_one_selector(next);

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

// Could be made smaller and faster by replacing pointer with an
// offset into a string buffer and making the bit fields smaller but
// that could not be maintained by hand.
typedef struct {
    const char* string;
    unsigned type:8;
} KatanaNameToPseudoStruct;

// These tables should be kept sorted.
const static KatanaNameToPseudoStruct kPseudoTypeWithoutArgumentsMap[] = {
    {"-internal-list-box",            KatanaPseudoListBox},
    {"-internal-media-controls-cast-button", KatanaPseudoWebKitCustomElement},
    {"-internal-media-controls-overlay-cast-button", KatanaPseudoWebKitCustomElement},
    {"-internal-spatial-navigation-focus", KatanaPseudoSpatialNavigationFocus},
    {"-webkit-any-link",              KatanaPseudoAnyLink},
    {"-webkit-autofill",              KatanaPseudoAutofill},
    {"-webkit-drag",                  KatanaPseudoDrag},
    {"-webkit-full-page-media",       KatanaPseudoFullPageMedia},
    {"-webkit-full-screen",           KatanaPseudoFullScreen},
    {"-webkit-full-screen-ancestor",  KatanaPseudoFullScreenAncestor},
    {"-webkit-full-screen-document",  KatanaPseudoFullScreenDocument},
    {"-webkit-resizer",               KatanaPseudoResizer},
    {"-webkit-scrollbar",             KatanaPseudoScrollbar},
    {"-webkit-scrollbar-button",      KatanaPseudoScrollbarButton},
    {"-webkit-scrollbar-corner",      KatanaPseudoScrollbarCorner},
    {"-webkit-scrollbar-thumb",       KatanaPseudoScrollbarThumb},
    {"-webkit-scrollbar-track",       KatanaPseudoScrollbarTrack},
    {"-webkit-scrollbar-track-piece", KatanaPseudoScrollbarTrackPiece},
    {"active",                        KatanaPseudoActive},
    {"after",                         KatanaPseudoAfter},
    {"backdrop",                      KatanaPseudoBackdrop},
    {"before",                        KatanaPseudoBefore},
    {"checked",                       KatanaPseudoChecked},
    {"content",                       KatanaPseudoContent},
    {"corner-present",                KatanaPseudoCornerPresent},
    {"cue",                           KatanaPseudoWebKitCustomElement},
    {"decrement",                     KatanaPseudoDecrement},
    {"default",                       KatanaPseudoDefault},
    {"disabled",                      KatanaPseudoDisabled},
    {"double-button",                 KatanaPseudoDoubleButton},
    {"empty",                         KatanaPseudoEmpty},
    {"enabled",                       KatanaPseudoEnabled},
    {"end",                           KatanaPseudoEnd},
    {"first",                         KatanaPseudoFirstPage},
    {"first-child",                   KatanaPseudoFirstChild},
    {"first-letter",                  KatanaPseudoFirstLetter},
    {"first-line",                    KatanaPseudoFirstLine},
    {"first-of-type",                 KatanaPseudoFirstOfType},
    {"focus",                         KatanaPseudoFocus},
    {"future",                        KatanaPseudoFutureCue},
    {"horizontal",                    KatanaPseudoHorizontal},
    {"host",                          KatanaPseudoHost},
    {"hover",                         KatanaPseudoHover},
    {"in-range",                      KatanaPseudoInRange},
    {"increment",                     KatanaPseudoIncrement},
    {"indeterminate",                 KatanaPseudoIndeterminate},
    {"invalid",                       KatanaPseudoInvalid},
    {"last-child",                    KatanaPseudoLastChild},
    {"last-of-type",                  KatanaPseudoLastOfType},
    {"left",                          KatanaPseudoLeftPage},
    {"link",                          KatanaPseudoLink},
    {"no-button",                     KatanaPseudoNoButton},
    {"only-child",                    KatanaPseudoOnlyChild},
    {"only-of-type",                  KatanaPseudoOnlyOfType},
    {"optional",                      KatanaPseudoOptional},
    {"out-of-range",                  KatanaPseudoOutOfRange},
    {"past",                          KatanaPseudoPastCue},
    {"read-only",                     KatanaPseudoReadOnly},
    {"read-write",                    KatanaPseudoReadWrite},
    {"required",                      KatanaPseudoRequired},
    {"right",                         KatanaPseudoRightPage},
    {"root",                          KatanaPseudoRoot},
    {"scope",                         KatanaPseudoScope},
    {"selection",                     KatanaPseudoSelection},
    {"shadow",                        KatanaPseudoShadow},
    {"single-button",                 KatanaPseudoSingleButton},
    {"start",                         KatanaPseudoStart},
    {"target",                        KatanaPseudoTarget},
    {"unresolved",                    KatanaPseudoUnresolved},
    {"valid",                         KatanaPseudoValid},
    {"vertical",                      KatanaPseudoVertical},
    {"visited",                       KatanaPseudoVisited},
    {"window-inactive",               KatanaPseudoWindowInactive},
};

const static KatanaNameToPseudoStruct kPseudoTypeWithArgumentsMap[] = {
    {"-webkit-any(",      KatanaPseudoAny},
    {"cue(",              KatanaPseudoCue},
    {"host(",             KatanaPseudoHost},
    {"host-context(",     KatanaPseudoHostContext},
    {"lang(",             KatanaPseudoLang},
    {"not(",              KatanaPseudoNot},
    {"nth-child(",        KatanaPseudoNthChild},
    {"nth-last-child(",   KatanaPseudoNthLastChild},
    {"nth-last-of-type(", KatanaPseudoNthLastOfType},
    {"nth-of-type(",      KatanaPseudoNthOfType},
};

static const KatanaNameToPseudoStruct* lower_bound(const KatanaNameToPseudoStruct *map,
                                                   size_t count, const char* key);

static KatanaPseudoType name_to_pseudo_type(const char* name, bool hasArguments)
{
    if (NULL == name)
        return KatanaPseudoUnknown;
    
    const KatanaNameToPseudoStruct* pseudoTypeMap;
    size_t count;
    
    if (hasArguments) {
        pseudoTypeMap = kPseudoTypeWithArgumentsMap;
        count = sizeof(kPseudoTypeWithArgumentsMap) / sizeof(KatanaNameToPseudoStruct);
    } else {
        pseudoTypeMap = kPseudoTypeWithoutArgumentsMap;
        count = sizeof(kPseudoTypeWithoutArgumentsMap) / sizeof(KatanaNameToPseudoStruct);
    }
    
    const KatanaNameToPseudoStruct* match = lower_bound(pseudoTypeMap, count, name);
    if ( match == (pseudoTypeMap + count)
         || 0 != strcasecmp(match->string, name) )
        return KatanaPseudoUnknown;
    
    return match->type;
}

static const KatanaNameToPseudoStruct* lower_bound(const KatanaNameToPseudoStruct *array,
                                                   size_t size, const char* key) {
    const KatanaNameToPseudoStruct* it;
    const KatanaNameToPseudoStruct* first = array;
    size_t count = size, step;
    while (count > 0) {
        it = first;
        step = count / 2;
        it += step;
        if (strncmp(it->string, key, strlen(key)) < 0) {
            first = ++it;
            count -= step + 1;
        } else count = step;
    }
    return first;
}

#if KATANA_PARSER_DEBUG

void test_lower_bound()
{
    const KatanaNameToPseudoStruct* pseudoTypeMap;
    size_t count;
    
    pseudoTypeMap = kPseudoTypeWithArgumentsMap;
    count = sizeof(kPseudoTypeWithArgumentsMap) / sizeof(KatanaNameToPseudoStruct);
    
    for ( size_t i = 0; i < count; i++ ) {
        const KatanaNameToPseudoStruct* res = lower_bound(pseudoTypeMap, count, pseudoTypeMap[i].string);
        assert(pseudoTypeMap[i].type == res->type);
    }
    
    pseudoTypeMap = kPseudoTypeWithoutArgumentsMap;
    count = sizeof(kPseudoTypeWithoutArgumentsMap) / sizeof(KatanaNameToPseudoStruct);
    
    for ( size_t i = 0; i < count; i++ ) {
        const KatanaNameToPseudoStruct* res = lower_bound(pseudoTypeMap, count, pseudoTypeMap[i].string);
        assert(pseudoTypeMap[i].type == res->type);
    }
}

#endif // #if KATANA_PARSER_DEBUG
