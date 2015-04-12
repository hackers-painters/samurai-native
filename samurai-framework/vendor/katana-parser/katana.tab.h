/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_KATANA_KATANA_TAB_H_INCLUDED
# define YY_KATANA_KATANA_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef KATANADEBUG
# if defined YYDEBUG
#if YYDEBUG
#   define KATANADEBUG 1
#  else
#   define KATANADEBUG 0
#  endif
# else /* ! defined YYDEBUG */
#  define KATANADEBUG 1
# endif /* ! defined YYDEBUG */
#endif  /* ! defined KATANADEBUG */
#if KATANADEBUG
extern int katanadebug;
#endif
/* "%code requires" blocks.  */


/*
*  Copyright (C) 2002-2003 Lars Knoll (knoll@kde.org)
*  Copyright (C) 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013 Apple Inc. All rights reserved.
*  Copyright (C) 2006 Alexey Proskuryakov (ap@nypop.com)
*  Copyright (C) 2008 Eric Seidel <eric@webkit.org>
*  Copyright (C) 2012 Intel Corporation. All rights reserved.
*  Copyright (C) 2015 QFish (im@qfi.sh)
*
*  This library is free software; you can redistribute it and/or
*  modify it under the terms of the GNU Lesser General Public
*  License as published by the Free Software Foundation; either
*  version 2 of the License, or (at your option) any later version.
*
*  This library is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
*  Lesser General Public License for more details.
*
*  You should have received a copy of the GNU Lesser General Public
*  License along with this library; if not, write to the Free Software
*  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
*
*/

#include "foundation.h"
#include "katana.h"



/* Token type.  */
#ifndef KATANATOKENTYPE
# define KATANATOKENTYPE
  enum katanatokentype
  {
    TOKEN_EOF = 0,
    LOWEST_PREC = 258,
    UNIMPORTANT_TOK = 259,
    KATANA_CSS_SGML_CD = 260,
    KATANA_CSS_WHITESPACE = 261,
    KATANA_CSS_INCLUDES = 262,
    KATANA_CSS_DASHMATCH = 263,
    KATANA_CSS_BEGINSWITH = 264,
    KATANA_CSS_ENDSWITH = 265,
    KATANA_CSS_CONTAINS = 266,
    KATANA_CSS_STRING = 267,
    KATANA_CSS_IDENT = 268,
    KATANA_CSS_NTH = 269,
    KATANA_CSS_HEX = 270,
    KATANA_CSS_IDSEL = 271,
    KATANA_CSS_IMPORT_SYM = 272,
    KATANA_CSS_PAGE_SYM = 273,
    KATANA_CSS_MEDIA_SYM = 274,
    KATANA_CSS_SUPPORTS_SYM = 275,
    KATANA_CSS_FONT_FACE_SYM = 276,
    KATANA_CSS_CHARSET_SYM = 277,
    KATANA_CSS_NAMESPACE_SYM = 278,
    KATANA_INTERNAL_DECLS_SYM = 279,
    KATANA_INTERNAL_MEDIALIST_SYM = 280,
    KATANA_INTERNAL_RULE_SYM = 281,
    KATANA_INTERNAL_SELECTOR_SYM = 282,
    KATANA_INTERNAL_VALUE_SYM = 283,
    KATANA_INTERNAL_KEYFRAME_RULE_SYM = 284,
    KATANA_INTERNAL_KEYFRAME_KEY_LIST_SYM = 285,
    KATANA_INTERNAL_SUPPORTS_CONDITION_SYM = 286,
    KATANA_CSS_KEYFRAMES_SYM = 287,
    KATANA_CSS_ATKEYWORD = 288,
    KATANA_CSS_IMPORTANT_SYM = 289,
    KATANA_CSS_MEDIA_NOT = 290,
    KATANA_CSS_MEDIA_ONLY = 291,
    KATANA_CSS_MEDIA_AND = 292,
    KATANA_CSS_MEDIA_OR = 293,
    KATANA_CSS_SUPPORTS_NOT = 294,
    KATANA_CSS_SUPPORTS_AND = 295,
    KATANA_CSS_SUPPORTS_OR = 296,
    KATANA_CSS_REMS = 297,
    KATANA_CSS_CHS = 298,
    KATANA_CSS_QEMS = 299,
    KATANA_CSS_EMS = 300,
    KATANA_CSS_EXS = 301,
    KATANA_CSS_PXS = 302,
    KATANA_CSS_CMS = 303,
    KATANA_CSS_MMS = 304,
    KATANA_CSS_INS = 305,
    KATANA_CSS_PTS = 306,
    KATANA_CSS_PCS = 307,
    KATANA_CSS_DEGS = 308,
    KATANA_CSS_RADS = 309,
    KATANA_CSS_GRADS = 310,
    KATANA_CSS_TURNS = 311,
    KATANA_CSS_MSECS = 312,
    KATANA_CSS_SECS = 313,
    KATANA_CSS_HERTZ = 314,
    KATANA_CSS_KHERTZ = 315,
    KATANA_CSS_DIMEN = 316,
    KATANA_CSS_INVALIDDIMEN = 317,
    KATANA_CSS_PERCENTAGE = 318,
    KATANA_CSS_FLOATTOKEN = 319,
    KATANA_CSS_INTEGER = 320,
    KATANA_CSS_VW = 321,
    KATANA_CSS_VH = 322,
    KATANA_CSS_VMIN = 323,
    KATANA_CSS_VMAX = 324,
    KATANA_CSS_DPPX = 325,
    KATANA_CSS_DPI = 326,
    KATANA_CSS_DPCM = 327,
    KATANA_CSS_FR = 328,
    KATANA_CSS_URI = 329,
    KATANA_CSS_FUNCTION = 330,
    KATANA_CSS_ANYFUNCTION = 331,
    KATANA_CSS_CUEFUNCTION = 332,
    KATANA_CSS_NOTFUNCTION = 333,
    KATANA_CSS_CALCFUNCTION = 334,
    KATANA_CSS_MINFUNCTION = 335,
    KATANA_CSS_MAXFUNCTION = 336,
    KATANA_CSS_HOSTFUNCTION = 337,
    KATANA_CSS_HOSTCONTEXTFUNCTION = 338,
    KATANA_CSS_UNICODERANGE = 339
  };
#endif

/* Value type.  */
#if ! defined KATANASTYPE && ! defined KATANASTYPE_IS_DECLARED

union KATANASTYPE
{



    bool boolean;
    char character;
    int integer;
    KatanaParserNumber number;
    KatanaParserString string;

    KatanaRule* rule;
    // The content of the three below HeapVectors are guaranteed to be kept alive by
    // the corresponding parsedRules, floatingMediaQueryExpList, and parsedKeyFrames
    // lists
    KatanaArray* ruleList;
    KatanaArray* mediaQueryExpList;
    KatanaArray* keyframeRuleList;

    KatanaSelector* selector;
    KatanaArray* selectorList;
    // CSSSelector::MarginBoxType marginBox;
    KatanaSelectorRelation relation;
    KatanaAttributeMatchType attributeMatchType;
    KatanaArray* mediaList;
    KatanaMediaQuery* mediaQuery;
    KatanaMediaQueryRestrictor mediaQueryRestrictor;
    KatanaMediaQueryExp* mediaQueryExp;
    KatanaValue* value;
    KatanaArray* valueList;
    KatanaKeyframe* keyframe;
    KatanaSourcePosition* location;


};

typedef union KATANASTYPE KATANASTYPE;
# define KATANASTYPE_IS_TRIVIAL 1
# define KATANASTYPE_IS_DECLARED 1
#endif

/* Location type.  */
#if ! defined KATANALTYPE && ! defined KATANALTYPE_IS_DECLARED
typedef struct KATANALTYPE KATANALTYPE;
struct KATANALTYPE
{
  int first_line;
  int first_column;
  int last_line;
  int last_column;
};
# define KATANALTYPE_IS_DECLARED 1
# define KATANALTYPE_IS_TRIVIAL 1
#endif



int katanaparse (void* scanner, struct KatanaInternalParser * parser);

#endif /* !YY_KATANA_KATANA_TAB_H_INCLUDED  */
