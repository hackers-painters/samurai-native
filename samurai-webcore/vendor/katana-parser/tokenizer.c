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

#include "tokenizer.h"
#include "katana.tab.h"
#include "katana.lex.h"
#include "parser.h"
#include "foundation.h"

#undef	assert
#define assert(x)

static inline double katana_characters_to_double(const char* data, size_t length, bool* ok);
static inline bool katana_is_html_space(char c);
static inline char* katana_normalize_text(yy_size_t* length, char *origin_text, yy_size_t origin_length, int tok);

#ifdef KATANA_FELX_DEBUG
#if KATANA_FELX_DEBUG
static char * katana_token_string(int tok);
#endif // #if KATANA_FELX_DEBUG
#endif // #ifdef KATANA_FELX_DEBUG

/**
 *  A hook function of flex, processing tokens which will be passed to bison
 *
 *  @param yylval    the medium for flex and bison
 *  @param yyscanner flex state
 *  @param tok       the type of token
 *
 *  @return the type of token
 */
int katana_tokenize(KATANASTYPE* lval , KATANALTYPE* loc, yyscan_t scanner, KatanaParser* parser, int tok)
{
    char* origin_text = katanaget_text(scanner);
    
    yy_size_t len = 0;
    
    char* text = katana_normalize_text(&len, origin_text, katanaget_leng(scanner), tok);
    
#ifdef KATANA_FELX_DEBUG
#if KATANA_FELX_DEBUG
    if ( tok == KATANA_CSS_WHITESPACE ) {
        katana_parser_log(parser, "【%30s】=>【%30s】: %s", "", "", katana_token_string(tok));
    } else {
        katana_parser_log(parser, "【%30s】=>【%30s】: %s", origin_text, text, katana_token_string(tok));
    }
#endif // #if KATANA_FELX_DEBUG
#endif // #ifdef KATANA_FELX_DEBUG
    yy_size_t length = len;
    switch ( tok ) {
        case KATANA_CSS_INCLUDES:
        case KATANA_CSS_DASHMATCH:
        case KATANA_CSS_BEGINSWITH:
        case KATANA_CSS_ENDSWITH:
        case KATANA_CSS_CONTAINS:
            break;
        case KATANA_CSS_STRING:
        case KATANA_CSS_IDENT:
        case KATANA_CSS_NTH:
            
        case KATANA_CSS_HEX:
        case KATANA_CSS_IDSEL:
            
        case KATANA_CSS_DIMEN:
        case KATANA_CSS_INVALIDDIMEN:
        case KATANA_CSS_URI:
        case KATANA_CSS_FUNCTION:
        case KATANA_CSS_ANYFUNCTION:
        case KATANA_CSS_CUEFUNCTION:
        case KATANA_CSS_NOTFUNCTION:
        case KATANA_CSS_CALCFUNCTION:
        case KATANA_CSS_MINFUNCTION:
        case KATANA_CSS_MAXFUNCTION:
        case KATANA_CSS_HOSTFUNCTION:
        case KATANA_CSS_HOSTCONTEXTFUNCTION:
        case KATANA_CSS_UNICODERANGE:
        {
            lval->string.data = text;
            lval->string.length = length;
        }
            break;
            
        case KATANA_CSS_IMPORT_SYM:
        case KATANA_CSS_PAGE_SYM:
        case KATANA_CSS_MEDIA_SYM:
        case KATANA_CSS_SUPPORTS_SYM:
        case KATANA_CSS_FONT_FACE_SYM:
        case KATANA_CSS_CHARSET_SYM:
        case KATANA_CSS_NAMESPACE_SYM:
//        case KATANA_CSS_VIEWPORT_RULE_SYM:
        case KATANA_INTERNAL_DECLS_SYM:
        case KATANA_INTERNAL_MEDIALIST_SYM:
        case KATANA_INTERNAL_RULE_SYM:
        case KATANA_INTERNAL_SELECTOR_SYM:
        case KATANA_INTERNAL_VALUE_SYM:
        case KATANA_INTERNAL_KEYFRAME_RULE_SYM:
        case KATANA_INTERNAL_KEYFRAME_KEY_LIST_SYM:
        case KATANA_INTERNAL_SUPPORTS_CONDITION_SYM:
        case KATANA_CSS_KEYFRAMES_SYM:
            break;
        case KATANA_CSS_QEMS:
            length--;
        case KATANA_CSS_GRADS:
        case KATANA_CSS_TURNS:
            length--;
        case KATANA_CSS_DEGS:
        case KATANA_CSS_RADS:
        case KATANA_CSS_KHERTZ:
        case KATANA_CSS_REMS:
            length--;
        case KATANA_CSS_MSECS:
        case KATANA_CSS_HERTZ:
        case KATANA_CSS_EMS:
        case KATANA_CSS_EXS:
        case KATANA_CSS_PXS:
        case KATANA_CSS_CMS:
        case KATANA_CSS_MMS:
        case KATANA_CSS_INS:
        case KATANA_CSS_PTS:
        case KATANA_CSS_PCS:
            length--;
        case KATANA_CSS_SECS:
        case KATANA_CSS_PERCENTAGE:
            length--;
        case KATANA_CSS_FLOATTOKEN:
            lval->number.val = katana_characters_to_double(text, length, NULL);
            lval->number.raw.data = text;
            lval->number.raw.length = len;
            break;
        case KATANA_CSS_INTEGER:
            lval->number.val = (int)katana_characters_to_double(text, length, NULL);
            lval->number.raw.data = text;
            lval->number.raw.length = len;

            break;
        default:
            break;
    }
    
    return tok;
}

/**
 *  Format token
 *
 *  @param length
 *  @param origin_text   original text from the flex
 *  @param origin_length formatted length
 *  @param tok
 *
 *  @return normalized text
 */
static inline char* katana_normalize_text(yy_size_t* length, char *origin_text, yy_size_t origin_length, int tok)
{
    char * start = origin_text;
    yy_size_t l = origin_length;
    switch ( tok ) {
        case KATANA_CSS_STRING:
            l--;
            /* nobreak */
        case KATANA_CSS_HEX:
        case KATANA_CSS_IDSEL:
            start++;
            l--;
            break;
        case KATANA_CSS_URI:
            // "url("{w}{string}{w}")"
            // "url("{w}{url}{w}")"
            // strip "url(" and ")"
            start += 4;
            l -= 5;
            // strip {w}
            while (l && katana_is_html_space(*start)) {
                ++start;
                --l;
            }
            while (l && katana_is_html_space(start[l - 1]))
                --l;
            if (l && (*start == '"' || *start == '\'')) {
                assert(l >= 2 && start[l - 1] == *start);
                ++start;
                l -= 2;
            }
            break;
        default:
            break;
    }
    
    *length = l;
    return start;
}

double katana_characters_to_double(const char* data, size_t length, bool* ok)
{
    if (!length) {
        if (ok)
            *ok = false;
        return 0.0;
    }
    
    char bytes[length + 1];
    for (unsigned i = 0; i < length; ++i)
        bytes[i] = data[i] < 0x7F ? data[i] : '?';
    bytes[length] = '\0';
    char* end;
    double val = strtod(bytes, &end);
    if (ok)
        *ok = (end == 0 || *end == '\0');
    return val;
}

#ifdef KATANA_FELX_DEBUG
#if KATANA_FELX_DEBUG
static char * katana_token_table[] = {
    "TOKEN_EOF", "LOWEST_PREC", "UNIMPORTANT_TOK",
    "KATANA_CSS_SGML_CD", "KATANA_CSS_WHITESPACE", "KATANA_CSS_INCLUDES",
    "KATANA_CSS_DASHMATCH", "KATANA_CSS_BEGINSWITH", "KATANA_CSS_ENDSWITH",
    "KATANA_CSS_CONTAINS", "KATANA_CSS_STRING", "KATANA_CSS_IDENT",
    "KATANA_CSS_NTH", "KATANA_CSS_HEX", "KATANA_CSS_IDSEL", "KATANA_CSS_IMPORT_SYM", "KATANA_CSS_PAGE_SYM",
    "KATANA_CSS_MEDIA_SYM", "KATANA_CSS_SUPPORTS_SYM",
    "KATANA_CSS_FONT_FACE_SYM", "KATANA_CSS_CHARSET_SYM",
    "KATANA_CSS_NAMESPACE_SYM", "KATANA_INTERNAL_DECLS_SYM",
    "KATANA_INTERNAL_MEDIALIST_SYM", "KATANA_INTERNAL_RULE_SYM",
    "KATANA_INTERNAL_SELECTOR_SYM", "KATANA_INTERNAL_VALUE_SYM",
    "KATANA_INTERNAL_KEYFRAME_RULE_SYM",
    "KATANA_INTERNAL_KEYFRAME_KEY_LIST_SYM",
    "KATANA_INTERNAL_SUPPORTS_CONDITION_SYM", "KATANA_CSS_KEYFRAMES_SYM",
    "KATANA_CSS_ATKEYWORD", "KATANA_CSS_IMPORTANT_SYM",
    "KATANA_CSS_MEDIA_NOT", "KATANA_CSS_MEDIA_ONLY", "KATANA_CSS_MEDIA_AND",
    "KATANA_CSS_MEDIA_OR", "KATANA_CSS_SUPPORTS_NOT",
    "KATANA_CSS_SUPPORTS_AND", "KATANA_CSS_SUPPORTS_OR", "KATANA_CSS_REMS",
    "KATANA_CSS_CHS", "KATANA_CSS_QEMS", "KATANA_CSS_EMS", "KATANA_CSS_EXS",
    "KATANA_CSS_PXS", "KATANA_CSS_CMS", "KATANA_CSS_MMS", "KATANA_CSS_INS",
    "KATANA_CSS_PTS", "KATANA_CSS_PCS", "KATANA_CSS_DEGS", "KATANA_CSS_RADS",
    "KATANA_CSS_GRADS", "KATANA_CSS_TURNS", "KATANA_CSS_MSECS",
    "KATANA_CSS_SECS", "KATANA_CSS_HERTZ", "KATANA_CSS_KHERTZ",
    "KATANA_CSS_DIMEN", "KATANA_CSS_INVALIDDIMEN", "KATANA_CSS_PERCENTAGE",
    "KATANA_CSS_FLOATTOKEN", "KATANA_CSS_INTEGER", "KATANA_CSS_VW",
    "KATANA_CSS_VH", "KATANA_CSS_VMIN", "KATANA_CSS_VMAX", "KATANA_CSS_DPPX",
    "KATANA_CSS_DPI", "KATANA_CSS_DPCM", "KATANA_CSS_FR", "KATANA_CSS_URI",
    "KATANA_CSS_FUNCTION", "KATANA_CSS_ANYFUNCTION",
    "KATANA_CSS_CUEFUNCTION", "KATANA_CSS_NOTFUNCTION",
    "KATANA_CSS_CALCFUNCTION", "KATANA_CSS_MINFUNCTION",
    "KATANA_CSS_MAXFUNCTION", "KATANA_CSS_HOSTFUNCTION",
    "KATANA_CSS_HOSTCONTEXTFUNCTION", "KATANA_CSS_UNICODERANGE" };

static char * katana_token_string(int tok)
{
    if (tok > 257)
    {
        return katana_token_table[tok-257];
    }
    else if ( 0 == tok )
    {
        return katana_token_table[0];
    }
    else
    {
        char* unicode = malloc(2);
        unicode[0] = (char)tok;
        unicode[1] = '\0';
        return unicode;
    }
}
#endif // #if KATANA_FELX_DEBUG
#endif // #ifdef KATANA_FELX_DEBUG

inline bool katana_is_html_space(char c)
{
    return c <= ' ' && (c == ' ' || c == '\n' || c == '\t' || c == '\r' || c == '\f');
}

//inline int katana_to_ascii_hex_value(char c)
//{
//    //    ASSERT(isASCIIHexDigit(c));
//    return c < 'A' ? c - '0' : (c - 'A' + 10) & 0xF;
//}

//inline bool katana_is_ascii_hex_digit(char c)
//{
//    return (c >= '0' && c <= '9') || ((c | 0x20) >= 'a' && (c | 0x20) <= 'f');
//}
