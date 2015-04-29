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

// CSS Spec: http://www.w3.org/TR/css-syntax-3/

#ifndef __Katana__katana__
#define __Katana__katana__

#include <stdio.h>
#include <stdbool.h>
#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
    KatanaRuleUnkown,
    KatanaRuleStyle,
    KatanaRuleImport,
    KatanaRuleMedia,
    KatanaRuleFontFace,
    KatanaRuleSupports,
    KatanaRuleKeyframes,
    KatanaRuleCharset,
    KatanaRuleHost,
} KatanaRuleType;

typedef enum {
    KatanaMediaQueryRestrictorNone,
    KatanaMediaQueryRestrictorOnly,
    KatanaMediaQueryRestrictorNot,
} KatanaMediaQueryRestrictor;

typedef enum {
    KatanaSelectorMatchUnknown = 0,
    KatanaSelectorMatchTag,                 // Example: div
    KatanaSelectorMatchId,                  // Example: #id
    KatanaSelectorMatchClass,               // example: .class
    KatanaSelectorMatchPseudoClass,         // Example:  :nth-child(2)
    KatanaSelectorMatchPseudoElement,       // Example: ::first-line
    KatanaSelectorMatchPagePseudoClass,     // ??
    KatanaSelectorMatchAttributeExact,      // Example: E[foo="bar"]
    KatanaSelectorMatchAttributeSet,        // Example: E[foo]
    KatanaSelectorMatchAttributeList,       // Example: E[foo~="bar"]
    KatanaSelectorMatchAttributeHyphen,     // Example: E[foo|="bar"]
    KatanaSelectorMatchAttributeContain,    // css3: E[foo*="bar"]
    KatanaSelectorMatchAttributeBegin,      // css3: E[foo^="bar"]
    KatanaSelectorMatchAttributeEnd,        // css3: E[foo$="bar"]
    KatanaSelectorMatchFirstAttribute = KatanaSelectorMatchAttributeExact,
} KatanaSelectorMatch;

typedef enum {
    KatanaSelectorRelationSubSelector,      // "No space" combinator
    KatanaSelectorRelationDescendant,       // "Space" combinator
    KatanaSelectorRelationChild,            // > combinator
    KatanaSelectorRelationDirectAdjacent,   // + combinator
    KatanaSelectorRelationIndirectAdjacent, // ~ combinator
    KatanaSelectorRelationShadowPseudo,     // Special case of shadow DOM pseudo elements / shadow pseudo element
    KatanaSelectorRelationShadowDeep        // /shadow-deep/ combinator
} KatanaSelectorRelation;
    
typedef enum {
    KatanaPseudoNotParsed,
    KatanaPseudoUnknown,
    KatanaPseudoEmpty,
    KatanaPseudoFirstChild,
    KatanaPseudoFirstOfType,
    KatanaPseudoLastChild,
    KatanaPseudoLastOfType,
    KatanaPseudoOnlyChild,
    KatanaPseudoOnlyOfType,
    KatanaPseudoFirstLine,
    KatanaPseudoFirstLetter,
    KatanaPseudoNthChild,
    KatanaPseudoNthOfType,
    KatanaPseudoNthLastChild,
    KatanaPseudoNthLastOfType,
    KatanaPseudoLink,
    KatanaPseudoVisited,
    KatanaPseudoAny,
    KatanaPseudoAnyLink,
    KatanaPseudoAutofill,
    KatanaPseudoHover,
    KatanaPseudoDrag,
    KatanaPseudoFocus,
    KatanaPseudoActive,
    KatanaPseudoChecked,
    KatanaPseudoEnabled,
    KatanaPseudoFullPageMedia,
    KatanaPseudoDefault,
    KatanaPseudoDisabled,
    KatanaPseudoOptional,
    KatanaPseudoRequired,
    KatanaPseudoReadOnly,
    KatanaPseudoReadWrite,
    KatanaPseudoValid,
    KatanaPseudoInvalid,
    KatanaPseudoIndeterminate,
    KatanaPseudoTarget,
    KatanaPseudoBefore,
    KatanaPseudoAfter,
    KatanaPseudoBackdrop,
    KatanaPseudoLang,
    KatanaPseudoNot, // :not(selector), selector is Kind of KatanaSelector
    KatanaPseudoResizer,
    KatanaPseudoRoot,
    KatanaPseudoScope,
    KatanaPseudoScrollbar,
    KatanaPseudoScrollbarButton,
    KatanaPseudoScrollbarCorner,
    KatanaPseudoScrollbarThumb,
    KatanaPseudoScrollbarTrack,
    KatanaPseudoScrollbarTrackPiece,
    KatanaPseudoWindowInactive,
    KatanaPseudoCornerPresent,
    KatanaPseudoDecrement,
    KatanaPseudoIncrement,
    KatanaPseudoHorizontal,
    KatanaPseudoVertical,
    KatanaPseudoStart,
    KatanaPseudoEnd,
    KatanaPseudoDoubleButton,
    KatanaPseudoSingleButton,
    KatanaPseudoNoButton,
    KatanaPseudoSelection,
    KatanaPseudoLeftPage,
    KatanaPseudoRightPage,
    KatanaPseudoFirstPage,
    KatanaPseudoFullScreen,
    KatanaPseudoFullScreenDocument,
    KatanaPseudoFullScreenAncestor,
    KatanaPseudoInRange,
    KatanaPseudoOutOfRange,
    KatanaPseudoWebKitCustomElement,
    KatanaPseudoCue,
    KatanaPseudoFutureCue,
    KatanaPseudoPastCue,
    KatanaPseudoUnresolved,
    KatanaPseudoContent,
    KatanaPseudoHost,
    KatanaPseudoHostContext,
    KatanaPseudoShadow,
    KatanaPseudoSpatialNavigationFocus,
    KatanaPseudoListBox
} KatanaPseudoType;

typedef enum {
    KatanaAttributeMatchTypeCaseSensitive,
    KatanaAttributeMatchTypeCaseInsensitive,
} KatanaAttributeMatchType;

typedef enum {
    KATANA_VALUE_UNKNOWN = 0,
    KATANA_VALUE_NUMBER = 1,
    KATANA_VALUE_PERCENTAGE = 2,
    KATANA_VALUE_EMS = 3,
    KATANA_VALUE_EXS = 4,
    KATANA_VALUE_PX = 5,
    KATANA_VALUE_CM = 6,
    KATANA_VALUE_MM = 7,
    KATANA_VALUE_IN = 8,
    KATANA_VALUE_PT = 9,
    KATANA_VALUE_PC = 10,
    KATANA_VALUE_DEG = 11,
    KATANA_VALUE_RAD = 12,
    KATANA_VALUE_GRAD = 13,
    KATANA_VALUE_MS = 14,
    KATANA_VALUE_S = 15,
    KATANA_VALUE_HZ = 16,
    KATANA_VALUE_KHZ = 17,
    KATANA_VALUE_DIMENSION = 18,
    KATANA_VALUE_STRING = 19,
    KATANA_VALUE_URI = 20,
    KATANA_VALUE_IDENT = 21,
    KATANA_VALUE_ATTR = 22,
    KATANA_VALUE_COUNTER = 23,
    KATANA_VALUE_RECT = 24,
    KATANA_VALUE_RGBCOLOR = 25,

    KATANA_VALUE_VW = 26,
    KATANA_VALUE_VH = 27,
    KATANA_VALUE_VMIN = 28,
    KATANA_VALUE_VMAX = 29,
    KATANA_VALUE_DPPX = 30,
    KATANA_VALUE_DPI = 31,
    KATANA_VALUE_DPCM = 32,
    KATANA_VALUE_FR = 33,
    KATANA_VALUE_UNICODE_RANGE = 102,
    
    KATANA_VALUE_PARSER_OPERATOR = 103,
    KATANA_VALUE_PARSER_INTEGER = 104,
    KATANA_VALUE_PARSER_HEXCOLOR = 105,
    KATANA_VALUE_PARSER_FUNCTION = 0x100001,
    KATANA_VALUE_PARSER_LIST     = 0x100002,
    KATANA_VALUE_PARSER_Q_EMS    = 0x100003,
    
    KATANA_VALUE_PARSER_IDENTIFIER = 106,
    
    KATANA_VALUE_TURN = 107,
    KATANA_VALUE_REMS = 108,
    KATANA_VALUE_CHS = 109,
    
    KATANA_VALUE_COUNTER_NAME = 110,
    
    KATANA_VALUE_SHAPE = 111,
    
    KATANA_VALUE_QUAD = 112,
    
    KATANA_VALUE_CALC = 113,
    KATANA_VALUE_CALC_PERCENTAGE_WITH_NUMBER = 114,
    KATANA_VALUE_CALC_PERCENTAGE_WITH_LENGTH = 115,
    KATANA_VALUE_VARIABLE_NAME = 116,
    
    KATANA_VALUE_PROPERTY_ID = 117,
    KATANA_VALUE_VALUE_ID = 118
} KatanaValueUnit;

//typedef enum {
//    KATANA_VALUE_PARSER_OPERATOR = 0x100000,
//    KATANA_VALUE_PARSER_FUNCTION = 0x100001,
//    KATANA_VALUE_PARSER_LIST     = 0x100002,
//    KATANA_VALUE_PARSER_Q_EMS    = 0x100003,
//} KatanaParserValueUnit;

typedef enum {
    KatanaValueInvalid = 0,
    KatanaValueInherit = 1,
    KatanaValueInitial = 2,
    KatanaValueNone = 3,
    KatanaValueCustom = 0x100010,
} KatanaValueID;

typedef struct {
    const char* local; // tag local name
    const char* prefix; // namesapce identifier
    const char* uri; // namesapce uri
} KatanaQualifiedName;

typedef struct {
  /** Data elements. This points to a dynamically-allocated array of capacity
   * elements, each a void* to the element itself, remember free each element.
   */
  void** data;

  /** Number of elements currently in the array. */
  unsigned int length;

  /** Current array capacity. */
  unsigned int capacity;

} KatanaArray;

typedef struct {
    const char* encoding;
    KatanaArray /* KatanaRule */ rules;
    KatanaArray /* KatanaImportRule */ imports;
} KatanaStylesheet;

typedef struct {
    const char* name;
    KatanaRuleType type;
} KatanaRule;
    
typedef struct {
    KatanaRule base;
    KatanaArray* /* KatanaSelector */ selectors;
    KatanaArray* /* KatanaDeclaration */ declarations;
} KatanaStyleRule;

typedef struct {
    const char* comment;
} KatanaComment; // unused for right

/**
 * The `@font-face` at-rule.
 */
typedef struct {
    KatanaRule base;
    KatanaArray* /* KatanaDeclaration */ declarations;
} KatanaFontFaceRule;

/**
 * The `@host` at-rule.
 */
typedef struct {
    KatanaRule base;
    KatanaArray* /* KatanaRule */ host;
} KatanaHostRule;

/**
 * The `@import` at-rule.
 */
typedef struct {
    KatanaRule base;
    /**
     * The part following `@import `
     */
    const char* href;
    /**
     * The media list belonging to this import rule
     */
    KatanaArray* /* KatanaMediaQuery* */ medias;
} KatanaImportRule;

/**
 * The `@keyframes` at-rule.
 * Spec: http://www.w3.org/TR/css3-animations/#keyframes
 */
typedef struct {
    KatanaRule base;
    /**
     * The vendor prefix in `@keyframes`, or `undefined` if there is none.
     */
    const char* name;
    KatanaArray* /* KatanaKeyframe */ keyframes;
} KatanaKeyframesRule;
    
typedef struct {
    KatanaArray* /* KatanaValue: `percentage`, `from`, `to` */ selectors;
    KatanaArray* /* KatanaDeclaration */ declarations;
} KatanaKeyframe;

/**
 * The `@media` at-rule.
 */
typedef struct {
    KatanaRule base;
    /**
     * The part following `@media `
     */
    KatanaArray* medias;
    /**
     * An `Array` of nodes with the types `rule`, `comment` and any of the
     at-rule types.
     */
    KatanaArray* /* KatanaRule */ rules;
} KatanaMediaRule;

/**
 * Media Query Exp List
 * Spec: http://www.w3.org/TR/mediaqueries-4/
 */

typedef struct {
    KatanaMediaQueryRestrictor restrictor;
    const char* type;
    KatanaArray* expressions;
    bool ignored;
} KatanaMediaQuery;

typedef struct {
    const char* feature;
    KatanaArray* values;
    const char* raw;
} KatanaMediaQueryExp;

typedef struct {
    const char* value;
    union {
        struct {
            int a; // Used for :nth-*
            int b; // Used for :nth-*
        } nth;
        KatanaAttributeMatchType attributeMatchType; // used for attribute selector (with value)
    } bits;
    KatanaQualifiedName* attribute;
    const char* argument; // Used for :contains, :lang, :nth-*
    KatanaArray* selectors; ; // Used for :any and :not
} KatanaSelectorRareData;

typedef struct KatanaSelector {
    size_t specificity;
    KatanaSelectorMatch match;
    KatanaPseudoType pseudo;
    KatanaSelectorRelation relation;
    KatanaQualifiedName* tag;
    KatanaSelectorRareData* data;
    struct KatanaSelector* tagHistory;
} KatanaSelector;
    
unsigned katana_calc_specificity_for_selector(KatanaSelector* selector);

typedef struct {
    const char* property;
    KatanaArray* values;
    const char* string;
    bool important;
    const char* raw;
} KatanaDeclaration;

typedef struct {
    const char* name;
    KatanaArray* args;
} KatanaValueFunction;

typedef struct KatanaValue {
    KatanaValueID id;
    bool isInt;
    union {
        int iValue;
        double fValue;
        const char* string;
        KatanaValueFunction* function;
        KatanaArray* list;
    };
    KatanaValueUnit unit;
    const char* raw;
} KatanaValue;

/**
 * The `@charset` at-rule.
 */
typedef struct {
    KatanaRule base;
    /**
     * The encoding information
     */
    const char* encoding;
} KatanaCharsetRule;
    
typedef struct {
    int code;
    const char* message;
} KatanaError;

// TODO: @document
// TODO: @page
// TODO: @supports
// TODO: custom-at-rule

/**
 * Parser mode
 */
typedef enum KatanaParserMode {
    KatanaParserModeStylesheet,
    KatanaParserModeRule,
    KatanaParserModeKeyframeRule,
    KatanaParserModeKeyframeKeyList,
    KatanaParserModeMediaList,
    KatanaParserModeValue,
    KatanaParserModeSelector,
    KatanaParserModeDeclarationList,
} KatanaParserMode;
    
typedef struct KatanaInternalOutput {
    // Complete CSS string
    KatanaStylesheet* stylesheet;
    union {
        // fragmental CSS string
        KatanaRule* rule;
        KatanaKeyframe* keyframe;
        KatanaArray* keyframe_keys;
        KatanaArray* values;
        KatanaArray* medias;
        KatanaArray* declarations;
        KatanaArray* selectors;
    };
    KatanaParserMode mode;
    KatanaArray /* KatanaError */ errors;
} KatanaOutput;

/**
 *  Parse a complete or fragmental CSS string
 *
 *  @param str  Input CSS string
 *  @param len  Length of the input CSS string
 *  @param mode Parser mode, depends on the input
 *
 *  @return The result of parsing
 */
KatanaOutput* katana_parse(const char* str, size_t len, KatanaParserMode mode);

/**
 *  Parse a complete CSS file
 *
 *  @param fp `FILE` point to the CSS file
 *
 *  @return The result of parsing
 */
KatanaOutput* katana_parse_in(FILE* fp);

/**
 *  Free the output
 *
 *  @param output The result of parsing
 */
void katana_destroy_output(KatanaOutput* output);

/**
 *  Print the formatted CSS string
 *
 *  @param output The result of parsing
 *
 *  @return The origin output
 */
KatanaOutput* katana_dump_output(KatanaOutput* output);

#ifdef __cplusplus
}
#endif

#endif /* defined(__Katana__katana__) */
