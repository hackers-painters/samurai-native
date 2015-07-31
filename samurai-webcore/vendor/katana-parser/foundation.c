//
//  foundation.c
//  Katana
//
//  Created by QFish on 3/19/15.
//  Copyright (c) 2015 QFish. All rights reserved.
//

#include "foundation.h"
#include "parser.h"

#include <string.h>
#include <stdbool.h>
#include <assert.h>

//#undef	assert
//#define assert(x)

struct KatanaInternalParser;

const KatanaParserString kKatanaAsteriskString = {"*", 1};

static const size_t kDefaultStringBufferSize = 12;

static void maybe_resize_string(struct KatanaInternalParser* parser,
                                size_t additional_chars,
                                KatanaParserString* str) {
    size_t new_length = str->length + additional_chars;
    size_t new_capacity = str->capacity;
    while (new_capacity < new_length) {
        new_capacity *= 2;
    }
    if (new_capacity != str->capacity) {
        char* new_data = katana_parser_allocate(parser, new_capacity);
        memset(new_data, 0, str->length);
        memcpy(new_data, str->data, str->length);
        katana_parser_deallocate(parser, str->data);
        str->data = new_data;
        str->capacity = new_capacity;
    }
}

void katana_string_init(struct KatanaInternalParser* parser,
                        KatanaParserString* output) {
    output->data = katana_parser_allocate(parser, kDefaultStringBufferSize);
    memset( output->data, 0, sizeof(kDefaultStringBufferSize) );
    output->length = 0;
    output->capacity = kDefaultStringBufferSize;
}

void katana_string_append_characters(struct KatanaInternalParser* parser,
                                     const char* str, KatanaParserString* output)
{
    size_t len = strlen(str);
    maybe_resize_string(parser, len, output);
    memcpy(output->data + output->length, str, len);
    output->length += len;
}

void katana_string_prepend_characters(struct KatanaInternalParser* parser,
                                      const char* str,
                                      KatanaParserString* output)
{
    size_t len = strlen(str);
    size_t new_length = output->length + len;
    char* new_data = katana_parser_allocate(parser, new_length);
    memcpy(new_data, str, len);
    memcpy(new_data+len, output->data, output->length);
    katana_parser_deallocate(parser, output->data);
    output->data = new_data;
    output->length = new_length;
    output->capacity = new_length;
}

void katana_string_append_string(struct KatanaInternalParser* parser,
                                 KatanaParserString* str,
                                 KatanaParserString* output) {
    maybe_resize_string(parser, str->length, output);
    memcpy(output->data + output->length, str->data, str->length);
    output->length += str->length;
}

bool katana_string_has_prefix(const char* str, const char* prefix)
{
    size_t pre_len = strlen(prefix);
    size_t str_len = strlen(str);
    return pre_len <= str_len && strncasecmp(prefix, str, pre_len);
}

void katana_string_to_lowercase(struct KatanaInternalParser* parser,
                                KatanaParserString* str)
{
    if ( !str )
        return;
    // FIXME: @(QFish) the char* in string piece is const, to find a better way
    char *c = (char*)str->data;
    for (size_t i=0; i < str->length; i++) {
        *c = tolower(*c);
        c++;
    }
}


#pragma mark - String

const char* katana_string_to_characters(struct KatanaInternalParser * parser, const KatanaParserString* str)
{
//	assert(NULL != str);
    if (NULL == str)
        return NULL;
    
    char* buffer = katana_parser_allocate(parser, sizeof(char) * (str->length + 1));
    memcpy(buffer, str->data, str->length);
    buffer[str->length] = '\0';
    return buffer;
}

const char* katana_string_to_characters_with_prefix_char(struct KatanaInternalParser * parser, const KatanaParserString* str, const char prefix)
{
//	assert(NULL != str);
    if (NULL == str)
        return NULL;
    
    char* buffer = katana_parser_allocate(parser, sizeof(char) * (str->length + 2));
    memcpy((buffer + 1), str->data, str->length);
    buffer[0] = prefix;
    buffer[str->length] = '\0';
    return buffer;
}

/**
 * Array
 */
void katana_array_init(struct KatanaInternalParser* parser,
                       size_t initial_capacity, KatanaArray* array) {
    array->length = 0;
    array->capacity = (unsigned int)initial_capacity;
    if (initial_capacity > 0) {
        array->data = katana_parser_allocate(parser, sizeof(void*) * initial_capacity);
    } else {
        array->data = NULL;
    }
}

void katana_array_destroy(struct KatanaInternalParser* parser,
                          KatanaArray* array) {
    if (array->capacity > 0) {
        katana_parser_deallocate(parser, array->data);
    }
}

static void enlarge_array_if_full(struct KatanaInternalParser* parser,
                                  KatanaArray* array) {
    if (array->length >= array->capacity) {
        if (array->capacity) {
            size_t old_num_bytes = sizeof(void*) * array->capacity;
            array->capacity *= 2;
            size_t num_bytes = sizeof(void*) * array->capacity;
            void** temp = katana_parser_allocate(parser, num_bytes);
            memcpy(temp, array->data, old_num_bytes);
            katana_parser_deallocate(parser, array->data);
            array->data = temp;
        } else {
            // 0-capacity array; no previous array to deallocate.
            array->capacity = 2;
            array->data = katana_parser_allocate(parser, sizeof(void*) * array->capacity);
        }
    }
}

void katana_array_add(struct KatanaInternalParser* parser,
                      void* element, KatanaArray* array)
{
    enlarge_array_if_full(parser, array);
	
//	assert(array->data);
//	assert(array->length < array->capacity);
	
	if ( array->length >= array->capacity )
		return;
	
    array->data[array->length++] = element;
}

void* katana_array_pop(struct KatanaInternalParser* parser,
                       KatanaArray* array) {
    if (array->length == 0) {
        return NULL;
    }
    return array->data[--array->length];
}

int katana_array_index_of(KatanaArray* array, void* element)
{
    for (int i = 0; i < array->length; ++i)
	{
        if (array->data[i] == element) {
            return i;
        }
    }
	
    return -1;
}

void katana_array_insert_at(struct KatanaInternalParser* parser,
                            void* element, int index,
                            KatanaArray* array) {
	
	if ( index < 0 )
		return;
	
	if ( index > array->length )
		return;

//	assert(index >= 0);
//	assert(index <= array->length);
	
    enlarge_array_if_full(parser, array);
    ++array->length;
    memmove(&array->data[index + 1], &array->data[index],
            sizeof(void*) * (array->length - index - 1));
    array->data[index] = element;
}

void katana_array_remove(struct KatanaInternalParser* parser,
                         void* node, KatanaArray* array) {
    int index = katana_array_index_of(array, node);
    if (index == -1) {
        return;
    }
	
    katana_array_remove_at(parser, index, array);
}

void* katana_array_remove_at(struct KatanaInternalParser* parser,
                             int index, KatanaArray* array) {
	
	if ( index < 0 )
		return NULL;

	if ( index >= array->length )
		return NULL;
	
//	assert(index >= 0);
//	assert(index < array->length);
	
    void* result = array->data[index];
    memmove(&array->data[index], &array->data[index + 1],
            sizeof(void*) * (array->length - index - 1));
    --array->length;
    return result;
}

/**
 *  An alloc / free method
 */
void* katana_parser_allocate(struct KatanaInternalParser* parser, size_t size) {
    return parser->options->allocator(parser->options->userdata, size);
}

void katana_parser_deallocate(struct KatanaInternalParser* parser, void* ptr) {
    parser->options->deallocator(parser->options->userdata, ptr);
}
