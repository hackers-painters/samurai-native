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

#ifndef __Katana__parser__
#define __Katana__parser__

#include <stdio.h>
#include <stdlib.h>
#include "katana.lex.h"

#ifdef __cplusplus
extern "C" {
#endif
    
#define KATANA_FELX_DEBUG            0
#define KATANA_BISON_DEBUG           0
#define KATANA_PARSER_DEBUG          0
#define KATANA_PARSER_LOG_ENABLE     0
    
#pragma mark - Parser

struct KatanaInternalOutput;
struct KatanaInternalOptions;

typedef void* (*KatanaAllocatorFunction)(void* userdata, size_t size);

typedef void (*KatanaDeallocatorFunction)(void* userdata, void* ptr);

typedef struct KatanaInternalOptions {
    KatanaAllocatorFunction allocator;
    KatanaDeallocatorFunction deallocator;
    void* userdata;
} KatanaOptions;

extern const KatanaOptions kKatanaDefaultOptions;

typedef struct KatanaInternalParser {
    // Settings for this parse run.
    const struct KatanaInternalOptions* options;
    
    // Output for the parse.
    struct KatanaInternalOutput* output;
    
    // The flex tokenizer info
    yyscan_t* scanner;
    
    // The floating declarations
    KatanaArray* parsed_declarations;
#if KATANA_PARSER_DEBUG
    // The floating selectors
    KatanaArray* parsed_selectors;
#endif // #if KATANA_PARSER_DEBUG
    
    KatanaSourcePosition* position;
    KatanaParserString default_namespace;
    
} KatanaParser;
    
#pragma mark - Vector

KatanaArray* katana_new_array(KatanaParser* parser);

#pragma mark - Stylesheet

KatanaStylesheet* katana_new_stylesheet(KatanaParser* parser);
void katana_parser_reset_declarations(KatanaParser* parser);

#pragma mark - @namespace

void katana_add_namespace(KatanaParser* parser, KatanaParserString* prefix, KatanaParserString* uri);

#pragma mark - @fontface

KatanaRule* katana_new_font_face(KatanaParser* parser);

#pragma mark - @keyframes

KatanaRule* katana_new_keyframes_rule(KatanaParser* parser, KatanaParserString* name, KatanaArray* keyframes, bool isPrefixed);
KatanaKeyframe* katana_new_keyframe(KatanaParser* parser, KatanaArray* selectors);
KatanaArray* katana_new_Keyframe_list(KatanaParser* parser);
void katana_keyframe_rule_list_add(KatanaParser* parser, KatanaKeyframe* keyframe, KatanaArray* list);
void katana_parser_clear_keyframes(KatanaParser* parser, KatanaArray* keyframes);

#pragma mark - @charset

void katana_set_charset(KatanaParser* parser, KatanaParserString* charset);

#pragma mark - @import

KatanaRule* katana_new_import_rule(KatanaParser* parser, KatanaParserString* href, KatanaArray* media);

#pragma mark - Value

KatanaValue* katana_new_value(KatanaParser* parser);
KatanaValue* katana_new_dimension_value(KatanaParser* parser, KatanaParserNumber* value, KatanaValueUnit unit);
KatanaValue* katana_new_number_value(KatanaParser* parser, int sign, KatanaParserNumber* value, KatanaValueUnit unit);
KatanaValue* katana_new_operator_value(KatanaParser* parser, int value);
KatanaValue* katana_new_ident_value(KatanaParser* parser, KatanaParserString* value);
KatanaValue* katana_new_function_value(KatanaParser* parser, KatanaParserString* name, KatanaArray* args);
KatanaValue* katana_new_list_value(KatanaParser* parser, KatanaArray* list);

void katana_value_set_string(KatanaParser* parser, KatanaValue* value, KatanaParserString* string);
void katana_value_set_sign(KatanaParser* parser, KatanaValue* value, int sign);

#pragma mark - ValueList

KatanaArray* katana_new_value_list(KatanaParser* parser);
void katana_value_list_add(KatanaParser* parser, KatanaValue* value, KatanaArray* list);
void katana_value_list_insert(KatanaParser* parser, KatanaValue* value, int index, KatanaArray* list);
void katana_value_list_steal_values(KatanaParser* parser, KatanaArray* values, KatanaArray* list);

#pragma mark - @media

KatanaRule* katana_new_media_rule(KatanaParser* parser, KatanaArray* medias, KatanaArray* rules);

#pragma mark - MediaList

KatanaArray* katana_new_media_list(KatanaParser* parser);
void katana_media_list_add(KatanaParser* parser, KatanaMediaQuery* media_query, KatanaArray* medias);

#pragma mark - MediaQuery

KatanaMediaQuery* katana_new_media_query(KatanaParser* parser, KatanaMediaQueryRestrictor r, KatanaParserString *type, KatanaArray* exps);

#pragma mark - MedaiQueryExp

// i.e. (min-width: 960px)
KatanaMediaQueryExp * katana_new_media_query_exp(KatanaParser* parser, KatanaParserString* feature, KatanaArray* values);

#pragma mark - MedaiQueryExp List

KatanaArray* katana_new_media_query_exp_list(KatanaParser* parser);
void katana_media_query_exp_list_add(KatanaParser* parser, KatanaMediaQueryExp* exp, KatanaArray* list);

#pragma mark - RuleList

KatanaArray* katana_new_rule_list(KatanaParser* parser);
KatanaArray* katana_rule_list_add(KatanaParser* parser, KatanaRule* rule, KatanaArray* rule_list);

#pragma mark - StyleRule

KatanaRule* katana_new_style_rule(KatanaParser* parser, KatanaArray* selectors);

#pragma mark - Property

void katana_start_declaration(KatanaParser* parser);
void katana_end_declaration(KatanaParser* parser, bool flag, bool ended);
void katana_set_current_declaration(KatanaParser* parser, KatanaParserString* tag);
bool katana_new_declaration(KatanaParser* parser, KatanaParserString* name, bool important, KatanaArray* values);
void katana_parser_clear_declarations(KatanaParser* parser);

#pragma mark - Selector

void katana_start_selector(KatanaParser* parser);
void katana_end_selector(KatanaParser* parser);

KatanaQualifiedName * katana_new_qualified_name(KatanaParser* parser, KatanaParserString* prefix, KatanaParserString* localName, KatanaParserString* uri);

KatanaSelector* katana_new_selector(KatanaParser* parser);
KatanaSelector* katana_sink_floating_selector(KatanaParser* parser, KatanaSelector* selector);
KatanaSelector* katana_rewrite_specifier_with_Elementname(KatanaParser* parser, KatanaParserString* tag, KatanaSelector* specifier);
KatanaSelector* katana_rewrite_specifier_with_namespace_if_needed(KatanaParser* parser, KatanaSelector* specifier);
KatanaSelector* katana_rewrite_specifiers(KatanaParser* parser, KatanaSelector* specifiers, KatanaSelector* newSpecifier);

void katana_adopt_selector_list(KatanaParser* parser, KatanaArray* selectors, KatanaSelector* selector);
void katana_selector_append(KatanaParser* parser, KatanaSelector* selector, KatanaSelector* new_selector, KatanaSelectorRelation relation);
void katana_selector_insert(KatanaParser* parser, KatanaSelector* selector, KatanaSelector* new_selector, KatanaSelectorRelation before, KatanaSelectorRelation after);
void katana_selector_prepend_with_Elementname(KatanaParser* parser, KatanaSelector* selector, KatanaParserString* tag);

KatanaArray* katana_new_selector_list(KatanaParser* parser);
KatanaArray* katana_reusable_selector_list(KatanaParser* parser);
void katana_selector_list_shink(KatanaParser* parser, int capacity, KatanaArray* list);
void katana_selector_list_add(KatanaParser* parser, KatanaSelector* selector, KatanaArray* list);

void katana_selector_set_value(KatanaParser* parser, KatanaSelector* selector, KatanaParserString* value);
void katana_selector_set_argument(KatanaParser* parser, KatanaSelector* selector, KatanaParserString* argument);
void katana_selector_set_argument_with_number(KatanaParser* parser, KatanaSelector* selector, int sign, KatanaParserNumber* value);

bool katana_parse_attribute_match_type(KatanaParser* parser, KatanaAttributeMatchType, KatanaParserString* attr);

bool katana_selector_is_simple(KatanaParser* parser, KatanaSelector* selector);
void katana_selector_extract_pseudo_type(KatanaSelector* selector);
    
#pragma mark - Universal rule parse flow

void katana_add_rule(KatanaParser* parser, KatanaRule* rule);

void katana_start_rule(KatanaParser* parser);
void katana_end_rule(KatanaParser* parser, bool ended);

void katana_start_rule_header(KatanaParser* parser, KatanaRuleType type);
void katana_end_rule_header(KatanaParser* parser);
void katana_end_invalid_rule_header(KatanaParser* parser);
void katana_start_rule_body(KatanaParser* parser);

#pragma mark - String

bool katana_string_is_function(KatanaParserString* string);
void katana_string_clear(KatanaParser* parser, KatanaParserString* string);

#pragma mark - Fragment
    
void katana_parse_internal_rule(KatanaParser* parser, KatanaRule* e);
void katana_parse_internal_keyframe_rule(KatanaParser* parser, KatanaKeyframe* e);
void katana_parse_internal_keyframe_key_list(KatanaParser* parser, KatanaArray* e);
void katana_parse_internal_value(KatanaParser* parser, KatanaArray* e);
void katana_parse_internal_media_list(KatanaParser* parser, KatanaArray* e);
void katana_parse_internal_declaration_list(KatanaParser* parser, bool e);
void katana_parse_internal_selector(KatanaParser* parser, KatanaArray* e);
    
#pragma mark - Debug

// Bison error
void katanaerror(KATANALTYPE* yyloc, void* scanner, KatanaParser * parser, char*);

// Bison parser location
KatanaSourcePosition* katana_parser_current_location(KatanaParser* parser, KATANALTYPE* yylloc);

// Log
void katana_parser_log(KatanaParser* parser, const char * format, ...);

// Error
void katana_parser_resume_error_logging();
void katana_parser_report_error(KatanaParser* parser, KatanaSourcePosition* pos, const char *, ...);

// print
void katana_print(const char * format, ...);
    
void katana_print_stylesheet(KatanaParser* parser, KatanaStylesheet* sheet);
void katana_print_rule(KatanaParser* parser, KatanaRule* rule);
void katana_print_font_face_rule(KatanaParser* parser, KatanaFontFaceRule* rule);
void katana_print_import_rule(KatanaParser* parser, KatanaImportRule* rule);
    
void katana_print_media_query_exp(KatanaParser* parser, KatanaMediaQueryExp* exp);
void katana_print_media_query(KatanaParser* parser, KatanaMediaQuery* query);
void katana_print_media_list(KatanaParser* parser, KatanaArray* medias);
void katana_print_media_rule(KatanaParser* parser, KatanaMediaRule* rule);

void katana_print_keyframes_rule(KatanaParser* parser, KatanaKeyframesRule* rule);
void katana_print_keyframe(KatanaParser* parser, KatanaKeyframe* keyframe);

void katana_print_style_rule(KatanaParser* parser, KatanaStyleRule* rule);
void katana_print_selector(KatanaParser* parser, KatanaSelector* selector);
void katana_print_selector_list(KatanaParser* parser, KatanaArray* selectors);
void katana_print_declaration(KatanaParser* parser, KatanaDeclaration* decl);
void katana_print_declaration_list(KatanaParser* parser, KatanaArray* declarations);
void katana_print_value_list(KatanaParser* parser, KatanaArray* values);


#ifdef __cplusplus
}
#endif

#endif /* defined(__Katana__parser__) */
