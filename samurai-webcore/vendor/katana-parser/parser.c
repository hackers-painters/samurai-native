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

#include <assert.h>
#include <ctype.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>

#include "katana.h"
#include "selector.h"
#include "katana.tab.h"
#include "parser.h"
#include "tokenizer.h"

#include "foundation.h"

//#undef	assert
//#define assert(x)

#define breakpoint
#define KATANA_PARSER_STRING(literal) { literal, sizeof(literal) - 1 }

#pragma mark - === Header Start ===

typedef void (*KatanaArrayDeallocator)(KatanaParser* parser, void* e);

#undef  katana_destroy_array
#define katana_destroy_array(parser, callback, e) \
        katana_destroy_array_using_deallocator((parser), \
                    (KatanaArrayDeallocator)(&(callback)), (e))

#pragma mark - Free

void katana_destroy_stylesheet(KatanaParser* parser, KatanaStylesheet* e);
void katana_destroy_rule(KatanaParser* parser, KatanaRule* e);
void katana_destroy_font_face_rule(KatanaParser* parser, KatanaFontFaceRule* e);
void katana_destroy_import_rule(KatanaParser* parser, KatanaImportRule* e);
void katana_destroy_media_rule(KatanaParser* parser, KatanaMediaRule* e);
void katana_destroy_media_query(KatanaParser* parser, KatanaMediaQuery* e);
void katana_destroy_media_query_exp(KatanaParser* parser, KatanaMediaQueryExp* e);
void katana_destroy_keyframes_rule(KatanaParser* parser, KatanaKeyframesRule* e);
void katana_destroy_keyframe(KatanaParser* parser, KatanaKeyframe* e);
void katana_destroy_media_list(KatanaParser* parser, KatanaArray* e);
void katana_destroy_rule_list(KatanaParser* parser, KatanaArray* e);
void katana_destroy_style_rule(KatanaParser* parser, KatanaStyleRule* e);
void katana_destroy_qualified_name(KatanaParser* parser, KatanaQualifiedName* e);
void katana_destroy_selector(KatanaParser* parser, KatanaSelector* e);
void katana_destroy_rare_data(KatanaParser* parser, KatanaSelectorRareData* e);
void katana_destroy_declaration(KatanaParser* parser, KatanaDeclaration* e);
void katana_destroy_value(KatanaParser* parser, KatanaValue* e);
void katana_destroy_function(KatanaParser* parser, KatanaValueFunction* e);

void katana_destroy_array_using_deallocator(KatanaParser* parser,
                          KatanaArrayDeallocator deallocator, KatanaArray* array);

#pragma mark - === Header End ===

#pragma mark - Options & Output

extern int katanaparse(void* scanner, struct KatanaInternalParser * parser);

static KatanaOutput* katana_parse_with_options(const KatanaOptions* options,
                                               const char* bytes,
                                               size_t len,
                                               KatanaParserMode mode);

static KatanaOutput* katana_parse_fragment(const char* prefix,
                                           size_t pre_len,
                                           const char* string,
                                           size_t str_len,
                                           KatanaParserMode mode);

static const char* katana_stringify_value_list(KatanaParser* parser, KatanaArray* value_list);
static const char* katana_stringify_value(KatanaParser* parser, KatanaValue* value);

static void* malloc_wrapper(void* unused, size_t size) {
    return malloc(size);
}

static void free_wrapper(void* unused, void* ptr) {
    free(ptr);
}

const KatanaOptions kKatanaDefaultOptions = {
    &malloc_wrapper,
    &free_wrapper,
    NULL
};

static void output_init(KatanaParser* parser, KatanaParserMode mode)
{
    KatanaOutput* output = katana_parser_allocate(parser, sizeof(KatanaOutput));
    output->stylesheet = katana_new_stylesheet(parser);
    output->mode = mode;
    katana_array_init(parser, 0, &output->errors);
    parser->output = output;
}

void katana_destroy_output(KatanaOutput* output)
{
    if ( NULL == output )
        return;

    KatanaParser parser;
    parser.options = &kKatanaDefaultOptions;
    switch (output->mode) {
        case KatanaParserModeStylesheet:
            break;
        case KatanaParserModeRule:
            if ( NULL != output->rule ) {
                katana_destroy_rule(&parser, output->rule);
            }
            break;
        case KatanaParserModeKeyframeRule:
            if ( NULL != output->keyframe ) {
                katana_destroy_keyframe(&parser, output->keyframe);
            }
            break;
        case KatanaParserModeKeyframeKeyList:
            if ( NULL != output->keyframe_keys ) {
                katana_destroy_array(&parser, katana_destroy_value, output->keyframe_keys);
                katana_parser_deallocate(&parser, (void*) output->keyframe_keys);
                output->keyframe_keys = NULL;
            }
            break;
        case KatanaParserModeMediaList:
            if ( NULL != output->medias ) {
                katana_destroy_media_list(&parser, output->medias);
            }
            break;
        case KatanaParserModeValue:
            if ( NULL != output->values ) {
                katana_destroy_array(&parser, katana_destroy_value, output->values);
                katana_parser_deallocate(&parser, (void*) output->values);
                output->values = NULL;
            }
            break;
        case KatanaParserModeSelector:
            if ( NULL != output->selectors ) {
                katana_destroy_array(&parser, katana_destroy_selector, output->selectors);
                katana_parser_deallocate(&parser, (void*) output->selectors);
                output->selectors = NULL;
            }
            break;
        case KatanaParserModeDeclarationList:
            if ( NULL != output->declarations ) {
                katana_destroy_array(&parser, katana_destroy_declaration, output->declarations);
                katana_parser_deallocate(&parser, (void*) output->declarations);
                output->declarations = NULL;
            }
            break;
    }
    katana_destroy_stylesheet(&parser, output->stylesheet);
    katana_array_destroy(&parser, &output->errors);
    katana_parser_deallocate(&parser, output);
}

#pragma mark - Public parse

static const KatanaParserString kKatanaParserModePrefixs[] = {
    KATANA_PARSER_STRING(""),
    KATANA_PARSER_STRING("@-internal-rule "), // 16
    KATANA_PARSER_STRING("@-internal-keyframe-rule "), // 25
    KATANA_PARSER_STRING("@-internal-keyframe-key-list "), // 29
    KATANA_PARSER_STRING("@-internal-media-list "), // 22
    KATANA_PARSER_STRING("@-internal-value "), // 17
    KATANA_PARSER_STRING("@-internal-selector "), // 20
    KATANA_PARSER_STRING("@-internal-decls "), // 17
};

KatanaOutput* katana_parse(const char* str, size_t len, KatanaParserMode mode)
{
    switch (mode) {
        case KatanaParserModeStylesheet:
            return katana_parse_with_options(&kKatanaDefaultOptions, str, len, mode);
        case KatanaParserModeRule:
        case KatanaParserModeKeyframeRule:
        case KatanaParserModeKeyframeKeyList:
        case KatanaParserModeMediaList:
        case KatanaParserModeValue:
        case KatanaParserModeSelector:
        case KatanaParserModeDeclarationList: {
            KatanaParserString prefix = kKatanaParserModePrefixs[mode];
            return katana_parse_fragment(prefix.data, prefix.length, str, len, mode);
        }
        default:
            katana_print("Whoops, not support yet!");
            break;
    }
}

KatanaOutput* katana_parse_in(FILE* fp)
{
//	assert(NULL != fp);
    if ( NULL == fp )
        return NULL;
    
    yyscan_t scanner;
    if (katanalex_init(&scanner)) {
        katana_print("no scanning today!");
        return NULL;
    }
    
    katanaset_in(fp, scanner);
    
    KatanaParser parser;
    parser.options = &kKatanaDefaultOptions;
    parser.scanner = &scanner;
    parser.default_namespace = kKatanaAsteriskString;
    parser.parsed_declarations = katana_new_array(&parser);
#if KATANA_PARSER_DEBUG
    parser.parsed_selectors = katana_new_array(&parser);
#endif // #if KATANA_PARSER_DEBUG
    parser.position = katana_parser_allocate(&parser, sizeof(KatanaSourcePosition));
    output_init(&parser, KatanaParserModeStylesheet);
    katanaparse(scanner, &parser);
    katanalex_destroy(scanner);
    katana_parser_clear_declarations(&parser);
    katana_parser_deallocate(&parser, parser.position);
#if KATANA_PARSER_DEBUG
    katana_destroy_array(&parser, katana_destroy_selector, parser.parsed_selectors);
    katana_parser_deallocate(&parser, parser.parsed_selectors);
#endif // #if KATANA_PARSER_DEBUG
    parser.scanner = NULL;
    KatanaOutput* output = parser.output;
    return output;
}

#pragma mark - Private parse

static KatanaOutput* katana_parse_fragment(const char* prefix,
                                           size_t pre_len,
                                           const char* str,
                                           size_t str_len,
                                           KatanaParserMode mode) {
    size_t len = pre_len + str_len + 1;
    char * source = malloc_wrapper(NULL, len);
    if ( source == NULL )
        return NULL;
    memcpy(source, prefix, pre_len);
    memcpy(source+pre_len, str, str_len);
    source[pre_len + str_len] = '\0';
    KatanaOutput * output = katana_parse_with_options(&kKatanaDefaultOptions, (void*)source, len, mode);
    free_wrapper(NULL, source);
    return output;
}

static KatanaOutput* katana_parse_with_options(const KatanaOptions* options,
                                               const char* bytes,
                                               size_t len,
                                               KatanaParserMode mode) {
//	assert(NULL != bytes);
	
    if ( NULL == bytes )
        return NULL;
    
    yyscan_t scanner;
    if (katanalex_init(&scanner)) {
        katana_print("no scanning today!");
        return NULL;
    }
        
    katana_scan_bytes(bytes, len, scanner);
    
    KatanaParser parser;
    parser.options = options;
    parser.scanner = &scanner;
    parser.default_namespace = kKatanaAsteriskString;
    parser.parsed_declarations = katana_new_array(&parser);
#if KATANA_PARSER_DEBUG
    parser.parsed_selectors = katana_new_array(&parser);
#endif // #if KATANA_PARSER_DEBUG
    parser.position = katana_parser_allocate(&parser, sizeof(KatanaSourcePosition));
    output_init(&parser, mode);
    katanaparse(scanner, &parser);
    katanalex_destroy(scanner);
    if ( KatanaParserModeDeclarationList != mode ) {
        katana_parser_clear_declarations(&parser);
    }
    katana_parser_deallocate(&parser, parser.position);
#if KATANA_PARSER_DEBUG
    katana_destroy_array(&parser, katana_destroy_selector, parser.parsed_selectors);
    katana_parser_deallocate(&parser, parser.parsed_selectors);
#endif // #if KATANA_PARSER_DEBUG
    parser.scanner = NULL;
    KatanaOutput* output = parser.output;
    return output;
}

#pragma mark - Fragment

void katana_parse_internal_rule(KatanaParser* parser, KatanaRule* e)
{
    parser->output->rule = e;
}

void katana_parse_internal_keyframe_rule(KatanaParser* parser, KatanaKeyframe* e)
{
    parser->output->keyframe = e;
}

void katana_parse_internal_keyframe_key_list(KatanaParser* parser, KatanaArray* e)
{
    parser->output->keyframe_keys = e;
}

void katana_parse_internal_value(KatanaParser* parser, KatanaArray* e)
{
    parser->output->values = e;
}

void katana_parse_internal_media_list(KatanaParser* parser, KatanaArray* e)
{
    parser->output->medias = e;
}

void katana_parse_internal_declaration_list(KatanaParser* parser, bool e)
{
    parser->output->declarations = parser->parsed_declarations;
}

void katana_parse_internal_selector(KatanaParser* parser, KatanaArray* e)
{
    parser->output->selectors = e;
}

#pragma mark - Vector

KatanaArray* katana_new_array(KatanaParser* parser) {
    KatanaArray* array = katana_parser_allocate(parser, sizeof(KatanaArray));
    katana_array_init(parser, 0, array);
    return array;
}

void katana_destroy_array_using_deallocator(KatanaParser* parser,
                          KatanaArrayDeallocator callback, KatanaArray* array) {
	
//	assert(NULL != array);
	
    if ( NULL == array )
        return;
    for (size_t i = 0; i < array->length; ++i) {
        callback(parser, array->data[i]);
    }
    katana_array_destroy(parser, array);
}

#pragma mark - Stylesheet

KatanaStylesheet* katana_new_stylesheet(KatanaParser* parser) {
    KatanaStylesheet* stylesheet =
        katana_parser_allocate(parser, sizeof(KatanaStylesheet));
    stylesheet->encoding = NULL;
    katana_array_init(parser, 0, &stylesheet->rules);
    katana_array_init(parser, 0, &stylesheet->imports);
    return stylesheet;
}

void katana_destroy_stylesheet(KatanaParser* parser, KatanaStylesheet* e)
{
//	assert(NULL != e);
	
    if ( NULL == e )
        return;
    
    // free encoding
    if ( e->encoding )
        katana_parser_deallocate(parser, (void*) e->encoding);

    // free imports
    for (size_t i = 0; i < e->imports.length; ++i) {
        katana_destroy_import_rule(parser, e->imports.data[i]);
    }
    katana_parser_deallocate(parser, (void*) e->imports.data);

    // free rules
    for (size_t i = 0; i < e->rules.length; ++i) {
        katana_destroy_rule(parser, e->rules.data[i]);
    }
    katana_parser_deallocate(parser, (void*) e->rules.data);

    // free e
    katana_parser_deallocate(parser, (void*) e);
}

void katana_destroy_rule(KatanaParser* parser, KatanaRule* rule)
{
    switch (rule->type) {
        case KatanaRuleStyle:
            katana_destroy_style_rule(parser, (KatanaStyleRule*)rule);
            break;
        case KatanaRuleImport:
            katana_destroy_import_rule(parser, (KatanaImportRule*)rule);
            break;
        case KatanaRuleFontFace:
            katana_destroy_font_face_rule(parser, (KatanaFontFaceRule*)rule);
            break;
        case KatanaRuleKeyframes:
            katana_destroy_keyframes_rule(parser, (KatanaKeyframesRule*)rule);
            break;
        case KatanaRuleMedia:
            katana_destroy_media_rule(parser, (KatanaMediaRule*)rule);
            break;
            
        default:
            break;
    }
}

void katana_destroy_rule_list(KatanaParser* parser, KatanaArray* rules)
{
    katana_destroy_array(parser, katana_destroy_rule, rules);
    katana_parser_deallocate(parser, (void*) rules);
}

#pragma mark - StyleRule

KatanaRule* katana_new_style_rule(KatanaParser* parser, KatanaArray* selectors)
{
//	assert(NULL != selectors);
	
    if ( NULL == selectors )
        return NULL;
    
    KatanaStyleRule* rule = katana_parser_allocate(parser, sizeof(KatanaStyleRule));
    rule->base.name = "style";
    rule->base.type = KatanaRuleStyle;
    rule->selectors = selectors;
    // Do not check parser->parsed_declarations, when we encounter something like `selectors {}`, treat it as valid.
    rule->declarations = parser->parsed_declarations;
    katana_parser_reset_declarations(parser);
    
    return (KatanaRule*)rule;
}

void katana_destroy_style_rule(KatanaParser* parser, KatanaStyleRule* e)
{
//	assert(e->selectors->length);

    katana_destroy_array(parser, katana_destroy_selector, e->selectors);
    katana_parser_deallocate(parser, (void*) e->selectors);

    katana_destroy_array(parser, katana_destroy_declaration, e->declarations);
    katana_parser_deallocate(parser, (void*) e->declarations);
    
    // katana_parser_deallocate(parser, (void*) e->base.name);
    katana_parser_deallocate(parser, (void*) e);
}

#pragma mark - @namespace

void katana_add_namespace(KatanaParser* parser, KatanaParserString* prefix, KatanaParserString* uri)
{
    // TODO: No need for right now
}

#pragma mark - @font-face

KatanaRule* katana_new_font_face(KatanaParser* parser)
{
    KatanaFontFaceRule* rule = katana_parser_allocate(parser, sizeof(KatanaFontFaceRule));
    rule->base.name = "font-face";
    rule->base.type = KatanaRuleFontFace;
    rule->declarations = parser->parsed_declarations;

    katana_parser_reset_declarations(parser);
    
    return (KatanaRule*)rule;
}

void katana_destroy_font_face_rule(KatanaParser* parser, KatanaFontFaceRule* e)
{
    katana_destroy_array(parser, katana_destroy_declaration, e->declarations);
    katana_parser_deallocate(parser, (void*) e->declarations);
    // katana_parser_deallocate(parser, (void*) e->base.name);
    katana_parser_deallocate(parser, (void*) e);
}

#pragma mark - @keyframes

KatanaRule* katana_new_keyframes_rule(KatanaParser* parser, KatanaParserString* name, KatanaArray* keyframes, bool isPrefixed)
{
    KatanaKeyframesRule * rule = katana_parser_allocate(parser, sizeof(KatanaKeyframesRule));
    rule->base.name = "keyframes";
    rule->base.type = KatanaRuleKeyframes;
    rule->name = katana_string_to_characters(parser, name);
    rule->keyframes = keyframes;
    return (KatanaRule*)rule;
}

void katana_destroy_keyframes_rule(KatanaParser* parser, KatanaKeyframesRule * e)
{
    katana_parser_clear_keyframes(parser, e->keyframes);
    katana_parser_deallocate(parser, (void*) e->name);
    katana_parser_deallocate(parser, (void*) e);
}

KatanaKeyframe* katana_new_keyframe(KatanaParser* parser, KatanaArray* selectors)
{
    KatanaKeyframe* keyframe = katana_parser_allocate(parser, sizeof(KatanaKeyframe));
    keyframe->selectors = selectors;
    keyframe->declarations = parser->parsed_declarations;
    katana_parser_reset_declarations(parser);
    return keyframe;
}

void katana_destroy_keyframe(KatanaParser* parser, KatanaKeyframe* e)
{
    katana_destroy_array(parser, katana_destroy_value, e->selectors);
    katana_parser_deallocate(parser, (void*) e->selectors);
    
    katana_destroy_array(parser, katana_destroy_declaration, e->declarations);
    katana_parser_deallocate(parser, (void*) e->declarations);

    katana_parser_deallocate(parser, (void*) e);
}

KatanaArray* katana_new_Keyframe_list(KatanaParser* parser)
{
    return katana_new_array(parser);
}

void katana_keyframe_rule_list_add(KatanaParser* parser, KatanaKeyframe* keyframe, KatanaArray* list)
{
//	assert(keyframe);
	
	if ( NULL == keyframe )
		return;
	
    katana_array_add(parser, keyframe, list);
}

void katana_parser_clear_keyframes(KatanaParser* parser, KatanaArray* keyframes)
{
    katana_destroy_array(parser, katana_destroy_keyframe, keyframes);
    katana_parser_deallocate(parser, (void*) keyframes);
}

#pragma mark - @charset

void katana_set_charset(KatanaParser* parser, KatanaParserString* charset)
{
//    parser->output->stylesheet->encoding = katana_string_to_characters(parser, charset);
}

#pragma mark - @import

KatanaRule* katana_new_import_rule(KatanaParser* parser, KatanaParserString* href, KatanaArray* media)
{
    KatanaImportRule* rule = katana_parser_allocate(parser, sizeof(KatanaImportRule));
    rule->base.name = "import";
    rule->base.type = KatanaRuleImport;
    rule->href = katana_string_to_characters(parser, href);
    rule->medias = media;
    return (KatanaRule*)rule;
}

void katana_destroy_import_rule(KatanaParser* parser, KatanaImportRule* e)
{
    katana_destroy_array(parser, katana_destroy_media_query, e->medias);
    katana_parser_deallocate(parser, (void*) e->medias);
    // katana_parser_deallocate(parser, (void*) e->base.name);
    katana_parser_deallocate(parser, (void*) e->href);
    katana_parser_deallocate(parser, (void*) e);
}

#pragma mark - Value

KatanaValue* katana_new_value(KatanaParser* parser)
{
    return katana_parser_allocate(parser, sizeof(KatanaValue));
}

void katana_destroy_value(KatanaParser* parser, KatanaValue* e)
{
    switch (e->unit) {
        case KATANA_VALUE_URI:
        case KATANA_VALUE_IDENT:
        case KATANA_VALUE_STRING:
        case KATANA_VALUE_DIMENSION:
        case KATANA_VALUE_UNICODE_RANGE:
        case KATANA_VALUE_PARSER_HEXCOLOR:
        {
            katana_parser_deallocate(parser, (void*) e->string);
        }
            break;
        case KATANA_VALUE_PARSER_LIST:
        {
            katana_destroy_array(parser, katana_destroy_value, e->list);
            katana_parser_deallocate(parser, (void*) e->list);
        }
            break;
        case KATANA_VALUE_PARSER_FUNCTION:
        {
            katana_destroy_function(parser, e->function);
        }
            break;
        case KATANA_VALUE_NUMBER:
        case KATANA_VALUE_PERCENTAGE:
        case KATANA_VALUE_PX:
        case KATANA_VALUE_CM:
        case KATANA_VALUE_MM:
        case KATANA_VALUE_IN:
        case KATANA_VALUE_PT:
        case KATANA_VALUE_PC:
        case KATANA_VALUE_DEG:
        case KATANA_VALUE_RAD:
        case KATANA_VALUE_GRAD:
        case KATANA_VALUE_TURN:
        case KATANA_VALUE_MS:
        case KATANA_VALUE_S:
        case KATANA_VALUE_HZ:
        case KATANA_VALUE_KHZ:
        case KATANA_VALUE_EMS:
        case KATANA_VALUE_PARSER_Q_EMS:
        case KATANA_VALUE_EXS:
        case KATANA_VALUE_REMS:
        case KATANA_VALUE_CHS:
        case KATANA_VALUE_VW:
        case KATANA_VALUE_VH:
        case KATANA_VALUE_VMIN:
        case KATANA_VALUE_VMAX:
        case KATANA_VALUE_DPPX:
        case KATANA_VALUE_DPI:
        case KATANA_VALUE_DPCM:
        case KATANA_VALUE_FR:
            katana_parser_deallocate(parser, (void*) e->raw);
            break;
        default:
            break;
    }
    
    katana_parser_deallocate(parser, (void*) e);
}

KatanaValueFunction* katana_new_function(KatanaParser* parser, KatanaParserString* name, KatanaArray* args)
{
    KatanaValueFunction* func = katana_parser_allocate(parser, sizeof(KatanaValueFunction));
    func->name = katana_string_to_characters(parser, name);
    func->args = args;
    return func;
}

void katana_destroy_function(KatanaParser* parser, KatanaValueFunction* e)
{
    katana_destroy_array(parser, katana_destroy_value, e->args);
    katana_parser_deallocate(parser, (void*) e->args);
    katana_parser_deallocate(parser, (void*) e->name);
    katana_parser_deallocate(parser, (void*) e);
}

KatanaValue* katana_new_number_value(KatanaParser* parser, int sign, KatanaParserNumber* value, KatanaValueUnit unit)
{
    KatanaValue* v = katana_new_value(parser);
    v->id = KatanaValueInvalid;
    v->isInt = false;
    v->fValue = sign * value->val;
    v->unit = unit;
    if ( 1 == sign ) {
        v->raw = katana_string_to_characters(parser, &value->raw);
    } else {
        v->raw = katana_string_to_characters_with_prefix_char(parser, &value->raw, '-');
    }
    return v;
}

KatanaValue* katana_new_dimension_value(KatanaParser* parser, KatanaParserNumber* value, KatanaValueUnit unit)
{
    KatanaValue* v = katana_new_value(parser);
    v->id = KatanaValueInvalid;
    v->isInt = false;
    v->fValue = value->val;
    v->raw = katana_string_to_characters(parser, &value->raw);
    v->unit = unit;
    return v;
}

KatanaValue* katana_new_operator_value(KatanaParser* parser, int value)
{
    KatanaValue* v = katana_new_value(parser);
    v->id = KatanaValueInvalid;
    v->isInt = false;
    v->unit = KATANA_VALUE_PARSER_OPERATOR;
    v->iValue = value;
    return v;
}

KatanaValue* katana_new_ident_value(KatanaParser* parser, KatanaParserString* value)
{
    KatanaValue* v = katana_new_value(parser);
    // is it necessary to do this ?
    // v.id = cssValueKeywordID(string);
    v->id = KatanaValueCustom;
    v->isInt = false;
    v->unit = KATANA_VALUE_IDENT;
    v->string = katana_string_to_characters(parser, value);
    return v;
}

KatanaValue* katana_new_function_value(KatanaParser* parser, KatanaParserString* name, KatanaArray* args)
{
    KatanaValueFunction* func = katana_new_function(parser, name, args);
    KatanaValue* value = katana_new_value(parser);
    value->unit = KATANA_VALUE_PARSER_FUNCTION;
    value->function = func;
    return value;
}

KatanaValue* katana_new_list_value(KatanaParser* parser, KatanaArray* list)
{
    KatanaValue* value = katana_new_value(parser);
    value->unit = KATANA_VALUE_PARSER_LIST;
    value->list = list;
    return value;
}

void katana_value_set_string(KatanaParser* parser, KatanaValue* value, KatanaParserString* string)
{
    value->string = katana_string_to_characters(parser, string);
}

void katana_value_set_sign(KatanaParser* parser, KatanaValue* value, int sign)
{
    value->fValue *= sign;
    
    if ( sign < 0 ) {
        const char* raw = value->raw;
        size_t len = strlen(raw);
        char* new_str = katana_parser_allocate(parser, sizeof(char) * (len + 2));
        strcpy(new_str + 1, raw);
        new_str[0] = '-';
        new_str[len + 1] = '\0';
        value->raw = new_str;
        katana_parser_deallocate(parser, (void*) raw);
    }
}

#pragma mark - ValueList

KatanaArray* katana_new_value_list(KatanaParser* parser)
{
    return katana_new_array(parser);
}

void katana_value_list_insert(KatanaParser* parser, KatanaValue* value, int index, KatanaArray* list)
{
//	assert(NULL != value);
	
    if ( value == NULL)
        return;
    katana_array_insert_at(parser, value, index, list);
}

void katana_value_list_add(KatanaParser* parser, KatanaValue* value, KatanaArray* list)
{
//	assert(NULL != value);
	
    if ( value == NULL)
        return;
    katana_array_add(parser, value, list);
}

void katana_value_list_steal_values(KatanaParser* parser, KatanaArray* values, KatanaArray* list)
{
//	assert(NULL != values && values->length);
	
    if ( values == NULL || 0 == values->length )
        return;
	
    for ( size_t i = 0; i < values->length; ++i )
	{
        katana_value_list_add(parser, values->data[i], list);
	}
	
    katana_parser_deallocate(parser, (void*) values);
}

#pragma mark - Declaration

bool katana_new_declaration(KatanaParser* parser, KatanaParserString* name, bool important, KatanaArray* values)
{
    KatanaDeclaration * decl = katana_parser_allocate(parser, sizeof(KatanaDeclaration));
    decl->property = katana_string_to_characters(parser, name);
    decl->important = important;
    decl->values = values;
    decl->raw = katana_stringify_value_list(parser, values);
    katana_array_add(parser, decl, parser->parsed_declarations);
    
    return true;
}

void katana_destroy_declaration(KatanaParser* parser, KatanaDeclaration* e)
{
    katana_destroy_array(parser, katana_destroy_value, e->values);
    katana_parser_deallocate(parser, (void*) e->values);
    katana_parser_deallocate(parser, (void*) e->raw);
    katana_parser_deallocate(parser, (void*) e->property);
    katana_parser_deallocate(parser, (void*) e);
}

void katana_parser_clear_declarations(KatanaParser* parser)
{
    katana_destroy_array(parser, katana_destroy_declaration, parser->parsed_declarations);
    katana_parser_deallocate(parser, (void*) parser->parsed_declarations);
    parser->parsed_declarations = NULL;
}

void katana_parser_reset_declarations(KatanaParser* parser)
{
    parser->parsed_declarations = katana_new_array(parser);
}

#pragma mark - @media

KatanaRule* katana_new_media_rule(KatanaParser* parser, KatanaArray* medias, KatanaArray* rules)
{
//	assert(NULL != medias && NULL != rules);
    
    if ( medias == NULL || rules == NULL )
        return NULL;
    
    KatanaMediaRule* rule = katana_parser_allocate(parser, sizeof(KatanaMediaRule));
    rule->base.name = "media";
    rule->base.type = KatanaRuleMedia;
    rule->medias = medias;
    rule->rules = rules;
    return (KatanaRule*)rule;
}

void katana_destroy_media_rule(KatanaParser* parser, KatanaMediaRule* e)
{
    katana_destroy_media_list(parser, (void*) e->medias);
    katana_destroy_rule_list(parser,  (void*) e->rules),
    // katana_parser_deallocate(parser,  (void*) e->base.name);
    katana_parser_deallocate(parser,  (void*) e);
}

#pragma mark - MediaList

KatanaArray* katana_new_media_list(KatanaParser* parser)
{
    return katana_new_array(parser);
}

void katana_media_list_add(KatanaParser* parser, KatanaMediaQuery* media_query, KatanaArray* medias)
{
    // debug here
//    katana_print_media_query(parser, media_query);
    if ( NULL != media_query ) {
        katana_array_add(parser, media_query, medias);
    }
}

void katana_destroy_media_list(KatanaParser* parser, KatanaArray* medias)
{
    katana_destroy_array(parser, katana_destroy_media_query, medias);
    katana_parser_deallocate(parser, (void*) medias);
}

#pragma mark - MediaQuery

KatanaMediaQuery* katana_new_media_query(KatanaParser* parser, KatanaMediaQueryRestrictor r, KatanaParserString *type, KatanaArray* exps)
{
    KatanaMediaQuery* media_query = katana_parser_allocate(parser, sizeof(KatanaMediaQuery));
    media_query->restrictor = r;
    media_query->type = type == NULL ? NULL : katana_string_to_characters(parser, type);
    media_query->expressions = exps;
    return media_query;
}

void katana_destroy_media_query(KatanaParser* parser, KatanaMediaQuery* e)
{
    katana_destroy_array(parser, katana_destroy_media_query_exp, e->expressions);
    katana_parser_deallocate(parser, (void*) e->expressions);
    if ( NULL != e->type ) {
        katana_parser_deallocate(parser, (void*) e->type);
    }
    katana_parser_deallocate(parser, (void*) e);
}

#pragma mark - MedaiQueryExp

KatanaMediaQueryExp * katana_new_media_query_exp(KatanaParser* parser, KatanaParserString* feature, KatanaArray* values)
{
//	assert( NULL != feature );
	
    if ( NULL == feature )
        return NULL;
    
    KatanaMediaQueryExp* exp = katana_parser_allocate(parser, sizeof(KatanaMediaQueryExp));
    exp->feature = katana_string_to_characters(parser, feature);
    exp->values = values;
    exp->raw = katana_stringify_value_list(parser, values);
    return exp;
}

void katana_destroy_media_query_exp(KatanaParser* parser, KatanaMediaQueryExp* e)
{
    if ( NULL != e->values ) {
        katana_destroy_array(parser, katana_destroy_value, e->values);
        katana_parser_deallocate(parser, e->values);
    }
    katana_parser_deallocate(parser, (void*) e->raw);
    katana_parser_deallocate(parser, (void*) e->feature);
    katana_parser_deallocate(parser, (void*) e);
}

#pragma mark - MedaiQueryExp List

void katana_media_query_exp_list_add(KatanaParser* parser, KatanaMediaQueryExp* exp, KatanaArray* list)
{
//	assert(NULL != exp);
	
    if ( NULL == exp )
        return;
	
    katana_array_add(parser, exp, list);
}

KatanaArray* katana_new_media_query_exp_list(KatanaParser* parser)
{
    return katana_new_array(parser);
}

#pragma mark - RuleList

KatanaArray* katana_new_rule_list(KatanaParser* parser)
{
    return katana_new_array(parser);
}

KatanaArray* katana_rule_list_add(KatanaParser* parser, KatanaRule* rule, KatanaArray* rule_list)
{
    if ( NULL != rule ) {
        if ( NULL == rule_list )
            rule_list = katana_new_rule_list(parser);
        katana_array_add(parser, rule, rule_list);
    }
    
    return rule_list;
}

#pragma mark - Declaration

void katana_start_declaration(KatanaParser* parser)
{
    katana_parser_log(parser, "katana_start_declaration");   
}

void katana_end_declaration(KatanaParser* parser, bool flag, bool ended)
{
    katana_parser_log(parser, "katana_end_declaration");
}

void katana_set_current_declaration(KatanaParser* parser, KatanaParserString* tag)
{
    katana_parser_log(parser, "katana_set_current_declaration");
}

#pragma mark - Selector

void katana_start_selector(KatanaParser* parser)
{
    katana_parser_log(parser, "katana_start_selector");
}

void katana_end_selector(KatanaParser* parser)
{
    katana_parser_log(parser, "katana_end_selector");
}

KatanaQualifiedName * katana_new_qualified_name(KatanaParser* parser, KatanaParserString* prefix, KatanaParserString* local, KatanaParserString* uri)
{
    KatanaQualifiedName* name = katana_parser_allocate(parser, sizeof(KatanaQualifiedName));
    name->prefix = prefix == NULL ? NULL : katana_string_to_characters(parser, prefix);
    name->local = local == NULL ? NULL : katana_string_to_characters(parser, local);
    name->uri = uri == NULL ? NULL : katana_string_to_characters(parser, uri);
    return name;
}

void katana_destroy_qualified_name(KatanaParser* parser,  KatanaQualifiedName* e)
{
    katana_parser_deallocate(parser, (void*) e->local);
    katana_parser_deallocate(parser, (void*) e->prefix);
    katana_parser_deallocate(parser, (void*) e->uri);
    katana_parser_deallocate(parser, (void*) e);
}

KatanaSelectorRareData* katana_new_rare_data(KatanaParser* parser)
{
    KatanaSelectorRareData* data = katana_parser_allocate(parser, sizeof(KatanaSelectorRareData));
    data->value = NULL;
    data->attribute = NULL;
    data->argument = NULL;
    data->selectors = NULL;
    return data;
}

void katana_destroy_rare_data(KatanaParser* parser, KatanaSelectorRareData* e)
{
    if ( NULL != e->value )
        katana_parser_deallocate(parser, (void*) e->value);
    
    if ( NULL != e->argument )
        katana_parser_deallocate(parser, (void*) e->argument);
    
    if ( NULL != e->attribute )
        katana_destroy_qualified_name(parser, e->attribute);

    if ( NULL != e->selectors ) {
        katana_destroy_array(parser, katana_destroy_selector, e->selectors);
        katana_parser_deallocate(parser, (void*) e->selectors);
    }
    
    katana_parser_deallocate(parser, e);
}

KatanaSelector* katana_new_selector(KatanaParser* parser)
{
    KatanaSelector* selector = katana_parser_allocate(parser, sizeof(KatanaSelector));
    selector->data = katana_new_rare_data(parser);
    selector->tag = NULL;
    selector->match = 0;
    selector->relation = 0;
    selector->specificity = 0;
    selector->tag = NULL;
    selector->tagHistory = NULL;
#if KATANA_PARSER_DEBUG
    katana_array_add(parser, selector, parser->parsed_selectors);
#endif // #if KATANA_PARSER_DEBUG
    return selector;
}

KatanaSelector* katana_sink_floating_selector(KatanaParser* parser, KatanaSelector* selector)
{
#if KATANA_PARSER_DEBUG
    katana_array_remove(parser, selector, parser->parsed_selectors);
#endif // #if KATANA_PARSER_DEBUG
    return selector;
}

void katana_destroy_one_selector(KatanaParser* parser, KatanaSelector* e)
{
    katana_destroy_rare_data(parser, e->data);
    
    if ( e->tag  != NULL )
        katana_destroy_qualified_name(parser, e->tag);
    
    katana_parser_deallocate(parser, e);
}

void katana_destroy_selector(KatanaParser* parser, KatanaSelector* e)
{
    KatanaSelector *p = e, *q;
    while ( p ) {
        q = p->tagHistory;
        katana_destroy_one_selector(parser, p);
        p = q;
    }
}

KatanaSelector* katana_rewrite_specifier_with_Elementname(KatanaParser* parser, KatanaParserString* tag, KatanaSelector* specifier)
{
    // TODO: (@QFish) check if css3 support
    bool supported = true;
    
    if ( supported ) {
        KatanaSelector* prepend = katana_new_selector(parser);
        prepend->tag = katana_new_qualified_name(parser, NULL, tag, &parser->default_namespace);
        prepend->match = KatanaSelectorMatchTag;
        prepend->tagHistory = katana_sink_floating_selector(parser, specifier);
        prepend->relation = KatanaSelectorRelationSubSelector;
        return prepend;
    }
    
    return specifier;
}

KatanaSelector* katana_rewrite_specifier_with_namespace_if_needed(KatanaParser* parser, KatanaSelector* specifiers)
{
    // TODO: @(QFish) add logic
    return specifiers;
}

KatanaSelector* katana_rewrite_specifiers(KatanaParser* parser, KatanaSelector* specifiers, KatanaSelector* newSpecifier)
{
    if (katana_selector_crosses_tree_scopes(newSpecifier)) {
        // Unknown pseudo element always goes at the top of selector chain.
        katana_selector_append(parser, newSpecifier, katana_sink_floating_selector(parser, specifiers), KatanaSelectorRelationShadowPseudo);
        return newSpecifier;
    }
    if (katana_selector_is_content_pseudo_element(newSpecifier)) {
        katana_selector_append(parser, newSpecifier, katana_sink_floating_selector(parser, specifiers), KatanaSelectorRelationSubSelector);
        return newSpecifier;
    }
    if (katana_selector_crosses_tree_scopes(specifiers)) {
        // Specifiers for unknown pseudo element go right behind it in the chain.
        katana_selector_insert(parser, specifiers, katana_sink_floating_selector(parser, newSpecifier), KatanaSelectorRelationSubSelector, KatanaSelectorRelationShadowPseudo);
        return specifiers;
    }
    if (katana_selector_is_content_pseudo_element(specifiers)) {
        katana_selector_insert(parser, specifiers, katana_sink_floating_selector(parser, newSpecifier), KatanaSelectorRelationSubSelector, KatanaSelectorRelationSubSelector);
        return specifiers;
    }

    katana_selector_append(parser, specifiers, katana_sink_floating_selector(parser, newSpecifier), KatanaSelectorRelationSubSelector);
    return specifiers;
}

void katana_adopt_selector_list(KatanaParser* parser, KatanaArray* selectors, KatanaSelector* selector)
{
    katana_parser_log(parser, "katana_adopt_selector_list");
    selector->data->selectors = selectors;
}

void katana_selector_append(KatanaParser* parser, KatanaSelector* selector, KatanaSelector* new_selector, KatanaSelectorRelation relation)
{
    katana_parser_log(parser, "katana_selector_append");
    KatanaSelector* end = selector;
    while (NULL != end->tagHistory)
        end = end->tagHistory;
    end->relation = relation;
    end->tagHistory = new_selector;
}

void katana_selector_insert(KatanaParser* parser, KatanaSelector* selector, KatanaSelector* new_selector, KatanaSelectorRelation before, KatanaSelectorRelation after)
{
    katana_parser_log(parser, "katana_selector_insert");

    if (selector->tagHistory)
        new_selector->tagHistory = selector;
    selector->relation = before;
    new_selector->relation = after;
    selector->tagHistory = selector;
}

void katana_selector_prepend_with_Elementname(KatanaParser* parser, KatanaSelector* selector, KatanaParserString* tag)
{
    katana_parser_log(parser, "katana_selector_prepend_with_Elementname");

    KatanaSelector* prev = katana_new_selector(parser);
    prev->tag = katana_new_qualified_name(parser, NULL, tag, &parser->default_namespace);
    selector->tagHistory = prev;
    selector->relation = KatanaSelectorRelationSubSelector;
}

KatanaArray* katana_new_selector_list(KatanaParser* parser)
{
    return katana_new_array(parser);
}

KatanaArray* katana_reusable_selector_list(KatanaParser* parser)
{
    return katana_new_array(parser);
}

void katana_selector_list_shink(KatanaParser* parser, int capacity, KatanaArray* list)
{

}

void katana_selector_list_add(KatanaParser* parser, KatanaSelector* selector, KatanaArray* list)
{
//	assert(NULL != selector);
	
    if ( NULL == selector )
        return;
        
    katana_array_add(parser, selector, list);
}

void katana_selector_set_value(KatanaParser* parser, KatanaSelector* selector, KatanaParserString* value)
{
    selector->data->value = katana_string_to_characters(parser, value);
}

void katana_selector_set_argument_with_number(KatanaParser* parser, KatanaSelector* selector, int sign, KatanaParserNumber* value)
{
    if ( 1 == sign ) {
        selector->data->argument = katana_string_to_characters(parser, &value->raw);
    } else {
        selector->data->argument = katana_string_to_characters_with_prefix_char(parser, &value->raw, '-');
    }
}

void katana_selector_set_argument(KatanaParser* parser, KatanaSelector* selector, KatanaParserString* argument)
{
    selector->data->argument = katana_string_to_characters(parser, argument);
}

bool katana_parse_attribute_match_type(KatanaParser* parser, KatanaAttributeMatchType type, KatanaParserString* attr)
{
    return true;
}

bool katana_selector_is_simple(KatanaParser* parser, KatanaSelector* selector)
{
    if (NULL != selector->data->selectors)
        return false;
    
    if (NULL == selector->tagHistory)
        return true;
    // TODO: @(QFish) check more.
    return false;
}

#pragma mark - Universal rule parse flow

void katana_add_rule(KatanaParser* parser, KatanaRule* rule)
{
//	assert( NULL != rule );
	
    if ( NULL == rule )
        return;
    
    switch ( rule->type ) {
        case KatanaRuleImport:
            katana_array_add(parser, rule, &parser->output->stylesheet->imports);
            break;
        default:
            katana_array_add(parser, rule, &parser->output->stylesheet->rules);
            break;
    }
}

void katana_start_rule(KatanaParser* parser)
{
    katana_parser_log(parser, "katana_start_rule");
}

void katana_end_rule(KatanaParser* parser, bool ended)
{
    katana_parser_log(parser, "katana_end_rule");
}

void katana_start_rule_header(KatanaParser* parser, KatanaRuleType type)
{
    katana_parser_log(parser, "katana_start_rule_header");
}

void katana_end_rule_header(KatanaParser* parser)
{
    katana_parser_log(parser, "katana_end_rule_header");
}

void katana_end_invalid_rule_header(KatanaParser* parser)
{
    katana_parser_log(parser, "katana_end_invalid_rule_header");
}

void katana_start_rule_body(KatanaParser* parser)
{
    katana_parser_log(parser, "katana_start_rule_body");
}

#pragma mark - String

bool katana_string_is_function(KatanaParserString* string)
{
    return string && (string->length > 0) && (string->data[string->length - 1] == '(');
}

void katana_string_clear(KatanaParser* parser, KatanaParserString* string)
{
	printf("==%s==\n", string->data);
    katana_parser_deallocate(parser, (void*) string->data);
    katana_parser_deallocate(parser, (void*) string);
}

#pragma mark - Error

void katanaerror(YYLTYPE* yyloc, void* scanner, struct KatanaInternalParser * parser, char* error)
{
#ifdef KATANA_PARSER_DEBUG
#if KATANA_PARSER_DEBUG
    katana_print("[Error] %d.%d - %d.%d: %s at %s\n",
           yyloc->first_line,
           yyloc->first_column,
           yyloc->last_line,
           yyloc->last_column,
           error,
           katanaget_text(parser->scanner));

    YYSTYPE * s = katanaget_lval(parser->scanner);

//	struct yy_buffer_state state = katana_get_previous_state(parser->scanner);
//    s, (*yy_buffer_stack[0]).yy_ch_buf);
//    
//    katana_print("%s", s->);
#endif // #if KATANA_PARSER_DEBUG
#endif // #ifdef KATANA_PARSER_DEBUG

}

void katana_parser_log(KatanaParser* parser, const char * format, ...)
{
#ifdef KATANA_PARSER_LOG_ENABLE
#if KATANA_PARSER_LOG_ENABLE
    va_list args;
    va_start(args, format);
    printf(" -> ");
    vprintf(format, args);
    printf("\n");
    va_end(args);
    fflush(stdout);
#endif // #if KATANA_PARSER_LOG_ENABLE
#endif // #ifdef KATANA_PARSER_LOG_ENABLE
}

void katana_parser_resume_error_logging()
{
    
}

void katana_parser_report_error(KatanaParser* parser, KatanaSourcePosition* pos, const char* format, ...)
{
#ifdef KATANA_PARSER_DEBUG
#if KATANA_PARSER_DEBUG
    printf("[ERROR] %d.%d - %d.%d : ", pos->line, pos->column, katanaget_lineno(*parser->scanner), katanaget_column(*parser->scanner) );
    va_list args;
    va_start(args, format);
    vprintf(format, args);
    va_end(args);
    printf("\n");
    fflush(stdout);
#endif // #if KATANA_PARSER_DEBUG
#endif // #ifdef KATANA_PARSER_DEBUG
}

#pragma mark - Position

void katana_print_position(YYLTYPE* yyloc)
{
    katana_print(NULL,
                 "Loaction %d.%d - %d.%d",
                 yyloc->first_line,
                 yyloc->first_column,
                 yyloc->last_line,
                 yyloc->last_column
                 );
}

KatanaSourcePosition* katana_parser_current_location(KatanaParser* parser, YYLTYPE* yylloc)
{
    parser->position->line = katanaget_lineno(*parser->scanner);
    parser->position->column = katanaget_column(*parser->scanner);
    //    katana_print_position(yylloc);
    return parser->position;
}

#pragma mark - Log

void katana_print(const char * format, ...)
{
    va_list args;
    va_start(args, format);
    vprintf(format, args);
	printf("\n");
    va_end(args);
    fflush(stdout);
}

void katana_print_stylesheet(KatanaParser* parser, KatanaStylesheet* sheet)
{
    katana_print("stylesheet with ");
    katana_print("%d rules.\n", sheet->rules.length);
    for (size_t i = 0; i < sheet->imports.length; ++i) {
        katana_print_rule(parser, sheet->imports.data[i]);
    }
    for (size_t i = 0; i < sheet->rules.length; ++i) {
        katana_print_rule(parser, sheet->rules.data[i]);
    }
    katana_print("\n");
}

void katana_print_rule(KatanaParser* parser, KatanaRule* rule)
{
    if ( NULL == rule ) {
        breakpoint;
        return;
    }
    
    switch (rule->type) {
        case KatanaRuleStyle:
            katana_print_style_rule(parser, (KatanaStyleRule*)rule);
            break;
        case KatanaRuleImport:
            katana_print_import_rule(parser, (KatanaImportRule*)rule);
            break;
        case KatanaRuleFontFace:
            katana_print_font_face_rule(parser, (KatanaFontFaceRule*)rule);
            break;
        case KatanaRuleKeyframes:
            katana_print_keyframes_rule(parser, (KatanaKeyframesRule*)rule);
            break;
        case KatanaRuleMedia:
            katana_print_media_rule(parser, (KatanaMediaRule*)rule);
            break;
        case KatanaRuleSupports:
            break;
        case KatanaRuleUnkown:
            break;
            
        default:
            break;
    }
}

void katana_print_import_rule(KatanaParser* parser, KatanaImportRule* rule)
{
    katana_print("@%s ", rule->base.name);
    katana_print("url(%s)", rule->href);
    katana_print(";\n");
}

void katana_print_keyframes_rule(KatanaParser* parser, KatanaKeyframesRule* rule)
{
    katana_print("@%s ", rule->base.name);
    katana_print("%s {\n", rule->name);
    for (size_t i = 0; i < rule->keyframes->length; ++i) {
        katana_print_keyframe(parser, rule->keyframes->data[i]);
    }
    katana_print("}\n");
}

void katana_print_keyframe(KatanaParser* parser, KatanaKeyframe* keyframe)
{
//	assert( NULL != keyframe );
	
    if ( NULL == keyframe )
        return;
    
    for (size_t i = 0; i < keyframe->selectors->length; ++i) {
        KatanaValue* value = keyframe->selectors->data[i];
        if ( value->unit == KATANA_VALUE_NUMBER ) {
            katana_print("%s", value->raw);
        }
        if ( i != keyframe->selectors->length -1 ) {
            katana_print(", ");
        }
    }
    katana_print(" {\n");
    katana_print_declaration_list(parser, keyframe->declarations);
    katana_print("}\n");
}

void katana_print_media_query_exp(KatanaParser* parser, KatanaMediaQueryExp* exp)
{
    katana_print("(");
    if (NULL != exp->feature) {
        katana_print("%s", exp->feature);
    }
    if ( exp->values && exp->values->length ) {
        const char* str = katana_stringify_value_list(parser, exp->values);
        katana_print(": %s", str);
        katana_parser_deallocate(parser, (void*) str);
    }
    katana_print(")");
}

void katana_print_media_query(KatanaParser* parser, KatanaMediaQuery* query)
{
    // For now ignored is always false
//    if ( !query->ignored ) {
        // print restrictor
        switch ( query->restrictor ) {
            case KatanaMediaQueryRestrictorOnly:
                katana_print("only ");
                break;
            case KatanaMediaQueryRestrictorNot:
                katana_print("not ");
                break;
            case KatanaMediaQueryRestrictorNone:
                break;
        }
        
        if ( NULL == query->expressions || 0 == query->expressions->length ) {
            if ( NULL != query->type ) {
                katana_print("%s", query->type);
            }
            return;
        }
        
        if ( (NULL != query->type && !strcasecmp(query->type, "all")) || query->restrictor != KatanaMediaQueryRestrictorNone) {
            if ( NULL != query->type ) {
                katana_print("%s", query->type);
            }
            katana_print(" and ");
        }
        
        katana_print_media_query_exp(parser, query->expressions->data[0]);
        
        for (size_t i = 1; i < query->expressions->length; ++i) {
            katana_print(" and ");
            katana_print_media_query_exp(parser, query->expressions->data[i]);
        }
//    } else {
//        // If query is invalid, serialized text should turn into "not all".
//        katana_print("not all");
//    }
}

void katana_print_media_list(KatanaParser* parser, KatanaArray* medias)
{
    bool first = true;
    for (size_t i = 0; i < medias->length; ++i) {
        if (!first)
            katana_print(", ");
        else
            first = false;
        katana_print_media_query(parser, (KatanaMediaQuery*)medias->data[i]);
    }
}

void katana_print_media_rule(KatanaParser* parser, KatanaMediaRule* rule)
{
    katana_print("@%s ", rule->base.name);
    
    if ( rule->medias->length ) {
        katana_print_media_list(parser, rule->medias);
    }
    
    if ( rule->medias->length ) {
        katana_print(" {\n");
        for (size_t i = 0; i < rule->rules->length; ++i) {
            katana_print_style_rule(parser, rule->rules->data[i]);
        }
        katana_print("}\n");
    } else {
        katana_print(";\n");
    }
}

void katana_print_selector(KatanaParser* parser, KatanaSelector* selector)
{
    KatanaParserString * string = katana_selector_to_string(parser, selector, NULL);
    const char* text = katana_string_to_characters(parser, string);
    katana_parser_deallocate(parser, (void*) string->data);
    katana_parser_deallocate(parser, (void*) string);
    katana_print("%s", text);
    katana_parser_deallocate(parser, (void*) text);
}

void katana_print_selector_list(KatanaParser* parser, KatanaArray* selectors)
{
    for (size_t i = 0; i < selectors->length; ++i) {
        katana_print_selector(parser, selectors->data[i]);
        if ( i != selectors->length -1 ) {
            katana_print(",\n");
        }
    }
}

void katana_print_style_rule(KatanaParser* parser, KatanaStyleRule* rule)
{
    katana_print_selector_list(parser, rule->selectors);
    katana_print(" {\n");
    
    if ( rule->declarations->length ) {
        katana_print_declaration_list(parser, rule->declarations);
    } else {
        katana_print("  /*no rule*/\n");
    }
    
    katana_print("}\n");
}

void katana_print_declaration(KatanaParser* parser, KatanaDeclaration* decl)
{
    const char* str = katana_stringify_value_list(parser, decl->values);
    katana_print("%s: %s", decl->property, str);
    katana_parser_deallocate(parser, (void*) str);
    if ( decl->important ) {
        katana_print(" !important");
    }
}

void katana_print_declaration_list(KatanaParser* parser, KatanaArray* declarations)
{
    for (size_t i = 0; i < declarations->length; ++i) {
        katana_print("  ");
        katana_print_declaration(parser, declarations->data[i]);
        katana_print(";\n");
    }
}

void katana_print_value_list(KatanaParser* parser, KatanaArray* values)
{
    const char* str = katana_stringify_value_list(parser, values);
    katana_print("%s", str);
    katana_parser_deallocate(parser, (void*) str);
}

void katana_print_font_face_rule(KatanaParser* parser, KatanaFontFaceRule* rule)
{
    katana_print("@%s {", rule->base.name);
    katana_print_declaration_list(parser, rule->declarations);
    katana_print("}\n");
}

KatanaOutput* katana_dump_output(KatanaOutput* output)
{
    if ( NULL == output )
        return output;
    
    KatanaParser parser;
    parser.options = &kKatanaDefaultOptions;

    switch (output->mode) {
        case KatanaParserModeStylesheet:
            katana_print_stylesheet(&parser, output->stylesheet);
            break;
        case KatanaParserModeRule:
            katana_print_rule(&parser, output->rule);
            break;
        case KatanaParserModeKeyframeRule:
            katana_print_keyframe(&parser, output->keyframe);
            break;
        case KatanaParserModeKeyframeKeyList:
            katana_print_value_list(&parser, output->keyframe_keys);
            break;
        case KatanaParserModeMediaList:
            katana_print_media_list(&parser, output->medias);
            break;
        case KatanaParserModeValue:
            katana_print_value_list(&parser, output->values);
            break;
        case KatanaParserModeSelector:
            katana_print_selector_list(&parser, output->selectors);
            break;
        case KatanaParserModeDeclarationList:
            katana_print_declaration_list(&parser, output->declarations);
            break;
    }
    katana_print("\n");
    return output;
}

#pragma mark - Stringify

static const char* katana_stringify_value_list(KatanaParser* parser, KatanaArray* values)
{
    if (NULL == values)
        return NULL;
    KatanaParserString * buffer = katana_parser_allocate(parser, sizeof(KatanaParserString));
    katana_string_init(parser, buffer);
    for (size_t i = 0; i < values->length; ++i) {
        KatanaValue* value = values->data[i];
        const char* value_str = katana_stringify_value(parser, value);
        katana_string_append_characters(parser, value_str, buffer);
        katana_parser_deallocate(parser, (void*) value_str);
        value_str = NULL;
        if ( i < values->length - 1 ) {
            if ( value->unit != KATANA_VALUE_PARSER_OPERATOR ) {
                if ( i < values->length - 2 ) {
                    value = values->data[i+1];
                    if ( value->unit != KATANA_VALUE_PARSER_OPERATOR ) {
                        katana_string_append_characters(parser, " ", buffer);
                    }
                } else {
                    katana_string_append_characters(parser, " ", buffer);
                }
            }
        }
    }
    const char * str = katana_string_to_characters(parser, (KatanaParserString*)buffer);
    katana_parser_deallocate(parser, buffer->data);
    katana_parser_deallocate(parser, (void*) buffer);
    return str;
}

static const char* katana_stringify_value(KatanaParser* parser, KatanaValue* value)
{
    // TODO: @(QFish) Handle this more gracefully X).
    char str[256];
    
    switch (value->unit) {
        case KATANA_VALUE_NUMBER:
        case KATANA_VALUE_PERCENTAGE:
        case KATANA_VALUE_EMS:
        case KATANA_VALUE_EXS:
        case KATANA_VALUE_REMS:
        case KATANA_VALUE_CHS:
        case KATANA_VALUE_PX:
        case KATANA_VALUE_CM:
        case KATANA_VALUE_DPPX:
        case KATANA_VALUE_DPI:
        case KATANA_VALUE_DPCM:
        case KATANA_VALUE_MM:
        case KATANA_VALUE_IN:
        case KATANA_VALUE_PT:
        case KATANA_VALUE_PC:
        case KATANA_VALUE_DEG:
        case KATANA_VALUE_RAD:
        case KATANA_VALUE_GRAD:
        case KATANA_VALUE_MS:
        case KATANA_VALUE_S:
        case KATANA_VALUE_HZ:
        case KATANA_VALUE_KHZ:
        case KATANA_VALUE_TURN:
            snprintf(str, sizeof(str), "%s", value->raw);
            break;
        case KATANA_VALUE_IDENT:
            snprintf(str, sizeof(str), "%s", value->string);
            break;
        case KATANA_VALUE_STRING:
            // FIXME: @(QFish) Do we need double quote or not ?
//            snprintf(str, sizeof(str), "\"%s\"", value->string);
            snprintf(str, sizeof(str), "%s", value->string);
            break;
        case KATANA_VALUE_PARSER_FUNCTION:
        {
            const char* args_str = katana_stringify_value_list(parser, value->function->args);
            snprintf(str, sizeof(str), "%s%s)", value->function->name, args_str);
            katana_parser_deallocate(parser, (void*) args_str);
            break;
        }
        case KATANA_VALUE_PARSER_OPERATOR:
            if (value->iValue != '=') {
                snprintf(str, sizeof(str), " %c ", value->iValue);
            } else {
                snprintf(str, sizeof(str), " %c", value->iValue);
            }
            break;
        case KATANA_VALUE_PARSER_LIST:
            return katana_stringify_value_list(parser, value->list);
            break;
        case KATANA_VALUE_PARSER_HEXCOLOR:
            snprintf(str, sizeof(str), "#%s", value->string);
            break;
        case KATANA_VALUE_URI:
            snprintf(str, sizeof(str), "url(%s)", value->string);
            break;
        default:
            katana_print("KATANA: Unknown Value unit.");
            break;
    }

    size_t len = strlen(str);
    char* dest = katana_parser_allocate(parser, len+1);
    strcpy(dest, str);
    dest[len] = '\0';
    return dest;
}
