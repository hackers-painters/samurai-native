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

#ifndef __Katana__selector__
#define __Katana__selector__

#include <stdio.h>
#include "katana.h"
#include "parser.h"

#ifdef __cplusplus
extern "C" {
#endif

KatanaParserString* katana_selector_to_string(KatanaParser* parser, KatanaSelector* selector, KatanaParserString* next);
    
bool katana_selector_crosses_tree_scopes(const KatanaSelector* selector);
bool katana_selector_matches_pseudo_element(KatanaSelector* selector);
bool katana_selector_is_custom_pseudo_element(KatanaSelector* selector);
bool katana_selector_is_direct_adjacent(KatanaSelector* selector);
bool katana_selector_is_adjacent(KatanaSelector* selector);
bool katana_selector_is_shadow(KatanaSelector* selector);
bool katana_selector_is_sibling(KatanaSelector* selector);
bool katana_selector_is_attribute(const KatanaSelector* selector);
bool katana_selector_is_content_pseudo_element(KatanaSelector* selector);
bool katana_selector_is_shadow_pseudo_element(KatanaSelector* selector);
bool katana_selector_is_host_pseudo_class(KatanaSelector* selector);
bool katana_selector_is_tree_boundary_crossing(KatanaSelector* selector);
bool katana_selector_is_insertion_point_crossing(KatanaSelector* selector);
    
#ifdef __cplusplus
}
#endif

#endif /* defined(__Katana__selector__) */
