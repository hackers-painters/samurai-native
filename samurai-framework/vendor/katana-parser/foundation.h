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

#ifndef __Katana__foundation__
#define __Katana__foundation__

#include <stdio.h>
#include <ctype.h>

#ifdef __cplusplus
extern "C" {
#endif

#include "katana.h"
    
struct KatanaInternalParser;

/**
 *  Positon, for error debug
 */
typedef struct {
    unsigned int line;
    unsigned int column;
    unsigned int offset;
} KatanaSourcePosition;

/**
 *  String
 */
typedef struct {
    char* data;
    size_t length;
    size_t capacity;
} KatanaParserString;

extern const KatanaParserString kKatanaAsteriskString;

void katana_string_to_lowercase(struct KatanaInternalParser* parser, KatanaParserString* string);

// Initializes a new KatanaParserString.
void katana_string_init(struct KatanaInternalParser* parser, KatanaParserString* output);

// Appends some characters onto the end of the KatanaParserString.
void katana_string_append_characters(struct KatanaInternalParser* parser, const char* str, KatanaParserString* output);

// Prepends some characters at the start of the KatanaParserString.
void katana_string_prepend_characters(struct KatanaInternalParser* parser, const char* str, KatanaParserString* output);

// Transforms a KatanaParserString to characters.
const char* katana_string_to_characters(struct KatanaInternalParser * parser, const KatanaParserString* str);
// Transforms a KatanaParserString to characters with a char prepended at the start of the KatanaParserString.
const char* katana_string_to_characters_with_prefix_char(struct KatanaInternalParser * parser, const KatanaParserString* str, const char prefix);
    
// Appends a string onto the end of the KatanaParserString.
void katana_string_append_string(struct KatanaInternalParser* parser, KatanaParserString* str, KatanaParserString* output);
// Returns a bool value that indicates whether a given string matches the beginning characters of the receiver.
bool katana_string_has_prefix(const char* str, const char* prefix);

/**
 *  Number
 */
typedef struct {
    KatanaParserString raw;
    double val;
} KatanaParserNumber;

/**
 *  Array 
 */
// Initializes a new KatanaArray with the specified initial capacity.
void katana_array_init(struct KatanaInternalParser* parser, size_t initial_capacity,
                       KatanaArray* array);

// Frees the memory used by an KatanaArray.  Does not free the contained
// pointers, but you should free the pointers if necessary.
void katana_array_destroy(struct KatanaInternalParser* parser, KatanaArray* array);

// Adds a new element to an KatanaArray.
void katana_array_add(struct KatanaInternalParser* parser, void* element, KatanaArray* array);

// Removes and returns the element most recently added to the KatanaArray.
// Ownership is transferred to caller.  Capacity is unchanged.  If the array is
// empty, NULL is returned.
void* katana_array_pop(struct KatanaInternalParser* parser, KatanaArray* array);

// Inserts an element at a specific index.  This is potentially O(N) time, but
// is necessary for some of the spec's behavior.
void katana_array_insert_at(struct KatanaInternalParser* parser, void* element, int index,
                            KatanaArray* array);

// Removes an element from the array, or does nothing if the element is not in
// the array.
void katana_array_remove(struct KatanaInternalParser* parser, void* element, KatanaArray* array);

// Removes and returns an element at a specific index.  Note that this is
// potentially O(N) time and should be used sparingly.
void* katana_array_remove_at(struct KatanaInternalParser* parser, int index, KatanaArray* array);

/**
 *  An alloc / free method wrapper
 */
void* katana_parser_allocate(struct KatanaInternalParser* parser, size_t size);
void katana_parser_deallocate(struct KatanaInternalParser* parser, void* ptr);
    
#ifdef __cplusplus
}
#endif


#endif /* defined(__Katana__foundation__) */
