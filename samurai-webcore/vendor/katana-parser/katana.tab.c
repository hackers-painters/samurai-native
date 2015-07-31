/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison implementation for Yacc-like parsers in C

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

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.0.4"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 2

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1

/* Substitute the type names.  */
#define YYSTYPE         KATANASTYPE
#define YYLTYPE         KATANALTYPE
/* Substitute the variable and function names.  */
#define yyparse         katanaparse
#define yylex           katanalex
#define yyerror         katanaerror
#define yydebug         katanadebug
#define yynerrs         katananerrs


/* Copy the first part of user declarations.  */



#include "tokenizer.h"

#define YYENABLE_NLS 0
#define YYLTYPE_IS_TRIVIAL 1
#define YYMAXDEPTH 10000
    
#ifdef KATANA_BISON_DEBUG
#if KATANA_BISON_DEBUG
#ifdef YYDEBUG
#undef YYDEBUG
#define YYDEBUG 1
#endif
int yydebug = 1;
#endif // #ifdef KATANA_BISON_DEBUG
#endif // #ifdef KATANA_BISON_DEBUG



# ifndef YY_NULLPTR
#  if defined __cplusplus && 201103L <= __cplusplus
#   define YY_NULLPTR nullptr
#  else
#   define YY_NULLPTR 0
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* In a future release of Bison, this section will be replaced
   by #include "katana.tab.h".  */
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

/* Copy the second part of user declarations.  */



#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE
# if (defined __GNUC__                                               \
      && (2 < __GNUC__ || (__GNUC__ == 2 && 96 <= __GNUC_MINOR__)))  \
     || defined __SUNPRO_C && 0x5110 <= __SUNPRO_C
#  define YY_ATTRIBUTE(Spec) __attribute__(Spec)
# else
#  define YY_ATTRIBUTE(Spec) /* empty */
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# define YY_ATTRIBUTE_PURE   YY_ATTRIBUTE ((__pure__))
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# define YY_ATTRIBUTE_UNUSED YY_ATTRIBUTE ((__unused__))
#endif

#if !defined _Noreturn \
     && (!defined __STDC_VERSION__ || __STDC_VERSION__ < 201112)
# if defined _MSC_VER && 1200 <= _MSC_VER
#  define _Noreturn __declspec (noreturn)
# else
#  define _Noreturn YY_ATTRIBUTE ((__noreturn__))
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN \
    _Pragma ("GCC diagnostic push") \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")\
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif


#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined KATANALTYPE_IS_TRIVIAL && KATANALTYPE_IS_TRIVIAL \
             && defined KATANASTYPE_IS_TRIVIAL && KATANASTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
  YYLTYPE yyls_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE) + sizeof (YYLTYPE)) \
      + 2 * YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYSIZE_T yynewbytes;                                            \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / sizeof (*yyptr);                          \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, (Count) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYSIZE_T yyi;                         \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  32
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   1536

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  105
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  129
/* YYNRULES -- Number of rules.  */
#define YYNRULES  323
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  613

/* YYTRANSLATE[YYX] -- Symbol number corresponding to YYX as returned
   by yylex, with out-of-bounds checking.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   339

#define YYTRANSLATE(YYX)                                                \
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, without out-of-bounds checking.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,   103,     2,   104,     2,     2,
      94,    91,    20,    97,    95,   101,    18,   100,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    17,    93,
       2,   102,    99,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,    19,     2,    92,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    96,    21,    90,    98,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    22,    23,    24,    25,    26,    27,    28,    29,
      30,    31,    32,    33,    34,    35,    36,    37,    38,    39,
      40,    41,    42,    43,    44,    45,    46,    47,    48,    49,
      50,    51,    52,    53,    54,    55,    56,    57,    58,    59,
      60,    61,    62,    63,    64,    65,    66,    67,    68,    69,
      70,    71,    72,    73,    74,    75,    76,    77,    78,    79,
      80,    81,    82,    83,    84,    85,    86,    87,    88,    89
};

#if KATANADEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   344,   344,   345,   346,   347,   348,   349,   350,   351,
     356,   362,   368,   374,   381,   387,   393,   405,   406,   410,
     411,   414,   416,   417,   421,   422,   426,   427,   431,   432,
     436,   437,   440,   442,   446,   449,   451,   458,   459,   461,
     462,   463,   464,   465,   470,   476,   481,   488,   489,   493,
     494,   500,   506,   508,   509,   510,   511,   513,   517,   521,
     528,   534,   541,   544,   550,   557,   558,   562,   563,   567,
     570,   576,   582,   588,   592,   599,   602,   608,   611,   614,
     620,   623,   630,   631,   635,   642,   645,   649,   653,   657,
     665,   669,   676,   682,   688,   694,   697,   702,   706,   712,
     719,   726,   727,   728,   729,   733,   739,   742,   748,   751,
     757,   760,   761,   768,   782,   789,   795,   804,   810,   811,
     815,   816,   822,   826,   830,   838,   844,   848,   855,   858,
     878,   991,   997,  1019,  1020,  1021,  1022,  1031,  1032,  1036,
    1037,  1041,  1047,  1054,  1060,  1066,  1072,  1077,  1082,  1089,
    1090,  1091,  1104,  1119,  1122,  1125,  1129,  1134,  1139,  1144,
    1152,  1157,  1176,  1182,  1188,  1189,  1195,  1202,  1213,  1214,
    1215,  1219,  1229,  1237,  1246,  1247,  1251,  1257,  1264,  1269,
    1275,  1281,  1284,  1287,  1290,  1293,  1296,  1302,  1303,  1320,
    1332,  1374,  1378,  1389,  1404,  1423,  1427,  1443,  1456,  1470,
    1476,  1479,  1480,  1481,  1484,  1488,  1492,  1499,  1513,  1520,
    1526,  1532,  1539,  1550,  1551,  1555,  1559,  1566,  1569,  1572,
    1578,  1582,  1587,  1594,  1600,  1603,  1606,  1612,  1613,  1619,
    1620,  1622,  1623,  1624,  1625,  1626,  1627,  1629,  1630,  1631,
    1632,  1636,  1637,  1638,  1639,  1640,  1641,  1642,  1643,  1644,
    1645,  1646,  1647,  1648,  1649,  1650,  1651,  1652,  1653,  1654,
    1655,  1656,  1657,  1658,  1659,  1660,  1661,  1662,  1663,  1664,
    1665,  1669,  1672,  1675,  1681,  1682,  1686,  1689,  1692,  1695,
    1700,  1702,  1706,  1712,  1718,  1722,  1727,  1732,  1736,  1739,
    1745,  1749,  1753,  1759,  1760,  1764,  1766,  1767,  1774,  1776,
    1783,  1786,  1787,  1788,  1792,  1795,  1796,  1800,  1806,  1812,
    1816,  1819,  1819,  1822,  1827,  1832,  1834,  1835,  1836,  1837,
    1840,  1842,  1843,  1844
};
#endif

#if KATANADEBUG || YYERROR_VERBOSE || 1
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "TOKEN_EOF", "error", "$undefined", "LOWEST_PREC", "UNIMPORTANT_TOK",
  "KATANA_CSS_SGML_CD", "KATANA_CSS_WHITESPACE", "KATANA_CSS_INCLUDES",
  "KATANA_CSS_DASHMATCH", "KATANA_CSS_BEGINSWITH", "KATANA_CSS_ENDSWITH",
  "KATANA_CSS_CONTAINS", "KATANA_CSS_STRING", "KATANA_CSS_IDENT",
  "KATANA_CSS_NTH", "KATANA_CSS_HEX", "KATANA_CSS_IDSEL", "':'", "'.'",
  "'['", "'*'", "'|'", "KATANA_CSS_IMPORT_SYM", "KATANA_CSS_PAGE_SYM",
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
  "KATANA_CSS_HOSTCONTEXTFUNCTION", "KATANA_CSS_UNICODERANGE", "'}'",
  "')'", "']'", "';'", "'('", "','", "'{'", "'+'", "'~'", "'>'", "'/'",
  "'-'", "'='", "'#'", "'%'", "$accept", "stylesheet",
  "katana_internal_rule", "katana_internal_keyframe_rule",
  "katana_internal_keyframe_key_list", "katana_internal_decls",
  "katana_internal_value", "katana_internal_medialist",
  "katana_internal_selector", "space", "maybe_space", "maybe_sgml",
  "closing_brace", "closing_parenthesis", "closing_square_bracket",
  "semi_or_eof", "maybe_charset", "rule_list", "valid_rule", "before_rule",
  "rule", "block_rule_body", "block_rule_list", "block_rule_recovery",
  "block_valid_rule", "block_rule", "before_import_rule",
  "import_rule_start", "import", "namespace", "maybe_ns_prefix",
  "string_or_uri", "maybe_media_value", "media_query_exp",
  "media_query_exp_list", "maybe_and_media_query_exp_list",
  "maybe_media_restrictor", "valid_media_query", "media_query",
  "maybe_media_list", "media_list", "mq_list", "at_rule_body_start",
  "before_media_rule", "at_rule_header_end_maybe_space",
  "media_rule_start", "media", "medium", "supports",
  "before_supports_rule", "at_supports_rule_header_end",
  "supports_condition", "supports_negation", "supports_conjunction",
  "supports_disjunction", "supports_condition_in_parens",
  "supports_declaration_condition", "before_keyframes_rule",
  "keyframes_rule_start", "keyframes", "keyframe_name", "keyframes_rule",
  "keyframe_rule_list", "keyframe_rule", "key_list", "key",
  "keyframes_error_recovery", "before_font_face_rule", "font_face",
  "combinator", "maybe_unary_operator", "unary_operator",
  "maybe_space_before_declaration", "before_selector_list",
  "at_rule_header_end", "at_selector_end", "ruleset",
  "before_selector_group_item", "selector_list", "selector",
  "namespace_selector", "simple_selector", "Elementname",
  "specifier_list", "specifier", "class", "attr_name", "attr_match_type",
  "maybe_attr_match_type", "attrib", "match", "ident_or_string", "pseudo",
  "selector_recovery", "declaration_list", "decl_list", "declaration",
  "property", "prio", "ident_list", "track_names_list", "expr",
  "expr_recovery", "operator", "term", "unary_term", "function",
  "calc_func_term", "calc_func_operator", "calc_maybe_space",
  "calc_func_paren_expr", "calc_func_expr", "calc_function", "invalid_at",
  "at_rule_recovery", "at_rule_header_recovery", "at_rule_end",
  "regular_invalid_at_rule_header", "invalid_rule", "invalid_rule_header",
  "at_invalid_rule_header_end", "invalid_block",
  "invalid_square_brackets_block", "invalid_parentheses_block",
  "opening_parenthesis", "error_location", "location_label",
  "error_recovery", "rule_error_recovery", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,    58,    46,    91,
      42,   124,   272,   273,   274,   275,   276,   277,   278,   279,
     280,   281,   282,   283,   284,   285,   286,   287,   288,   289,
     290,   291,   292,   293,   294,   295,   296,   297,   298,   299,
     300,   301,   302,   303,   304,   305,   306,   307,   308,   309,
     310,   311,   312,   313,   314,   315,   316,   317,   318,   319,
     320,   321,   322,   323,   324,   325,   326,   327,   328,   329,
     330,   331,   332,   333,   334,   335,   336,   337,   338,   339,
     125,    41,    93,    59,    40,    44,   123,    43,   126,    62,
      47,    45,    61,    35,    37
};
# endif

#define YYPACT_NINF -413

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-413)))

#define YYTABLE_NINF -314

#define yytable_value_is_error(Yytable_value) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
    1014,   491,    23,    23,    23,    23,    23,    23,    23,    53,
    -413,  -413,  -413,  -413,  -413,  -413,  -413,  -413,  -413,  -413,
      66,    75,  -413,  -413,  -413,    78,  -413,   760,   876,  1289,
     272,   272,  -413,   183,  -413,  -413,    23,  -413,  -413,    93,
      61,     8,    49,    90,    99,    23,    23,   101,     9,  -413,
    -413,   110,   539,  -413,  -413,   111,   153,   192,  -413,   181,
    -413,   876,  -413,   188,  -413,  -413,   715,   205,    84,   204,
    -413,   233,   113,   759,  -413,   519,   519,  -413,  -413,  -413,
    -413,    23,    23,    23,  -413,  -413,  -413,  -413,  -413,  -413,
    -413,  -413,  -413,  -413,  -413,  -413,  -413,  -413,  -413,  -413,
    -413,  -413,  -413,    23,  -413,  -413,  -413,  -413,  -413,  -413,
    -413,  -413,  -413,  -413,  -413,    23,    23,    23,    23,    23,
    -413,  -413,    23,    23,  1426,    23,   758,  -413,    23,    23,
      23,  -413,    23,   165,    23,   172,  -413,    46,  -413,  -413,
     243,   107,    86,  -413,    39,  -413,  -413,   158,    23,  -413,
      23,    23,  -413,    23,    23,    64,  -413,    23,   242,   312,
     168,   271,  -413,   253,   268,   287,    23,  -413,  -413,    23,
      23,   195,    23,    23,  -413,  -413,    23,    23,  -413,  -413,
    -413,   218,   298,   955,   298,   298,   291,  -413,  -413,   431,
      38,  -413,  -413,   211,   876,    23,    23,    23,   309,   876,
    -413,  -413,   519,   519,   519,  -413,  -413,  -413,  -413,  -413,
    -413,   856,  1082,  -413,    83,  -413,  -413,    23,    23,  -413,
    -413,    23,    23,    23,  1289,  -413,  -413,  -413,  -413,   342,
      23,    23,  -413,  -413,  -413,   862,  -413,  -413,  -413,  -413,
    -413,  -413,  -413,  -413,  -413,  -413,  -413,  -413,  -413,  -413,
     481,    23,  -413,  -413,  -413,  -413,  -413,  -413,  -413,  -413,
     340,   315,  -413,    23,  -413,    23,  -413,   264,    23,     9,
    -413,  -413,  -413,  -413,  -413,   -18,  -413,  -413,   274,   302,
     211,   381,   371,    20,    20,   876,    20,    20,    20,  -413,
    -413,    50,   204,   396,   269,  -413,  -413,  -413,    23,  -413,
    -413,  -413,  -413,   313,  -413,   519,  -413,  -413,  -413,  -413,
     665,    20,    23,  1458,    20,  -413,  -413,  -413,   411,    23,
    -413,    47,    20,  -413,  -413,  -413,  -413,  -413,  -413,  -413,
     272,   339,  -413,  -413,   295,   750,   398,   374,   400,  -413,
    -413,   389,   183,   326,   572,   593,  -413,  -413,  -413,  -413,
    -413,   524,   936,   415,   572,    23,    23,   386,  -413,  -413,
    -413,    23,  -413,    23,   549,  -413,    23,   661,  -413,  -413,
     385,   399,   335,  -413,  -413,  -413,   336,  -413,    23,    23,
     372,  -413,  -413,    23,  -413,  -413,  -413,   143,  -413,    23,
     269,  -413,  -413,  -413,  -413,  -413,  -413,  -413,    23,  -413,
      23,  -413,  -413,  -413,  1082,  -413,  -413,    63,   155,  1347,
      55,  -413,    23,  -413,  -413,    23,   109,  -413,  -413,   -39,
     240,  -413,    67,    -4,  -413,   453,  -413,  -413,  -413,  -413,
    -413,  -413,  1149,  -413,   445,   373,    23,   424,  -413,  -413,
      86,    39,    23,   382,  -413,   214,   378,    23,    23,    23,
      23,    23,    23,  -413,    20,    20,    23,    20,  -413,    23,
     380,   876,  -413,   602,    20,   411,    23,    23,  -413,  -413,
      23,    23,  -413,  -413,  -413,  -413,   316,  -413,  -413,  -413,
    -413,  -413,  -413,   529,    23,   248,    23,    20,  -413,   373,
    -413,  -413,  -413,  -413,  -413,  -413,  -413,    23,    20,  -413,
     382,   382,   382,   382,  -413,   339,    23,  -413,  -413,    20,
    -413,   380,  -413,  -413,    23,   113,  -413,    55,    66,    66,
    -413,  -413,   379,  -413,  -413,  -413,  1289,  -413,    23,   109,
     208,   572,   460,    23,    23,  -413,  -413,  -413,  -413,  -413,
     109,   339,  -413,    23,   466,  -413,  -413,   557,   564,  1219,
     315,  -413,  1434,  -413,  -413,    23,    23,  -413,  -413,   109,
     282,  -413,   109,   466,    23,  -413,    38,  -413,  -413,   453,
    -413,   363,  -413,  -413,  -413,  -413,  -413,  -413,  -413,  -413,
     183,  -413,  1016,   109,  -413,  -413,    23,   379,  -413,    38,
    -413,  -413,  -413,   -39,    -4,  -413,  1149,  -413,   605,  -413,
      23,  -413,   610,   572,    20,  -413,  -413,   379,    23,    23,
    -413,  -413,  -413
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_uint16 yydefact[] =
{
      32,     0,    19,    19,    19,    19,    19,    19,    19,     0,
       4,     8,     9,     3,     6,     7,     5,    21,   313,    17,
      20,     0,    34,   307,   141,     0,   314,   142,     0,     0,
     138,   138,     1,    35,   320,    18,    19,   307,   313,     0,
       0,   202,     0,     0,     0,    19,    19,     0,     0,    42,
      41,     0,     0,    38,    43,     0,     0,     0,    40,     0,
      39,     0,    37,   162,   167,   166,   313,     0,     0,   163,
     153,   144,   147,     0,   149,   156,   158,   164,   168,   169,
     170,    19,    19,    19,   261,   262,   259,   258,   260,   244,
     245,   246,   247,   248,   249,   250,   251,   252,   253,   254,
     255,   256,   257,    19,   243,   242,   241,   263,   264,   265,
     266,   267,   268,   269,   270,    19,    19,    19,    19,    19,
     140,   139,    19,    19,     0,    19,     0,   220,    19,    19,
      19,   129,    19,     0,    19,     0,   137,     0,    22,    23,
      44,     0,     0,   291,     0,   315,    13,   203,    19,   313,
      19,    19,   313,    19,    19,     0,    73,    19,     0,     0,
      87,     0,    86,     0,    65,     0,    19,    67,    68,    19,
      19,     0,    19,    19,   119,   118,    19,    19,   144,   155,
     313,     0,     0,     0,     0,     0,     0,   171,   313,     0,
       0,   154,    16,     0,   150,    19,    19,    19,     0,     0,
     162,   163,   159,   161,   157,   165,   229,   230,   235,   231,
     233,     0,     0,   234,     0,   236,   239,    19,    19,   240,
      14,    19,    19,    19,     0,   222,   227,   237,   238,     0,
      19,    19,   126,   128,    12,     0,    21,   321,   315,   312,
     311,   322,   323,   315,    31,    30,    33,   315,   293,   294,
       0,    19,   205,   315,   313,   212,   320,    79,    78,   315,
       0,    80,    97,    19,   313,    19,    15,    88,    19,     0,
      10,    61,   314,    95,   143,     0,   116,    94,     0,     0,
     143,     0,   138,     0,     0,     0,     0,     0,     0,   189,
     315,    19,     0,     0,     0,    29,    28,   180,    19,   151,
     133,   134,   135,     0,   152,   160,    27,   313,    26,   272,
       0,     0,    19,     0,     0,   274,   284,   287,   280,    19,
     217,     0,     0,   232,   228,   225,   224,   226,   221,    11,
     138,     0,   313,    45,     0,     0,     0,     0,     0,   307,
      46,     0,    36,     0,     0,     0,   316,   317,   318,   319,
     206,     0,     0,     0,     0,    19,    19,    75,    81,   320,
     314,    19,    66,    19,     0,    92,    19,     0,   100,   102,
     103,   104,   101,   111,    92,    92,     0,   190,    19,    19,
       0,   195,   191,    19,   197,   198,   199,     0,   172,    19,
       0,   182,   183,   184,   185,   186,   181,   176,    19,   146,
      19,   315,   271,   273,     0,   275,   289,   281,     0,     0,
       0,   215,    19,   218,   219,    19,     0,   320,   298,     0,
       0,   295,     0,     0,   290,     0,   309,   310,    25,    24,
     308,   315,   214,    72,    69,     0,    19,     0,    90,   314,
       0,     0,    19,     0,   313,     0,     0,    19,    19,    19,
      19,    19,    19,    92,     0,     0,    19,     0,   178,    19,
       0,     0,   136,     0,     0,   280,     0,     0,   285,   286,
      19,    19,   288,   216,   127,   125,     0,   303,   313,   296,
     301,   302,   299,     0,    19,     0,    19,     0,    74,     0,
      91,    64,    62,    63,    49,   105,   315,    19,     0,    92,
       0,     0,     0,     0,   314,     0,    19,   194,   192,     0,
     196,     0,   188,   187,    19,   148,   283,     0,   276,   277,
     278,   279,     0,   320,   213,   315,     0,    71,    19,     0,
      44,     0,     0,    19,    19,   107,   109,   106,   108,   122,
       0,     0,   193,    19,   175,   282,   300,     0,     0,    70,
      76,    96,     0,    48,    21,    19,    19,   110,    49,     0,
       0,   132,     0,   175,    19,   174,     0,   313,    58,     0,
      57,     0,    54,    56,    55,    53,    52,   307,    59,    51,
      50,   112,     0,     0,   117,   320,    19,   121,   145,     0,
     173,   177,   320,   306,   305,   315,   214,    98,     0,   314,
      19,   179,     0,     0,     0,   123,   314,   304,    19,    19,
     124,   114,   113
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -413,  -413,  -413,  -413,  -413,  -413,  -413,  -413,  -413,  -281,
      -1,  -223,  -392,   177,  -280,  -117,  -413,  -413,   245,   -29,
    -413,   -74,  -413,  -413,  -413,  -413,  -413,  -220,  -413,   -50,
    -413,   237,  -413,    72,    26,  -413,  -413,  -413,   349,   -43,
    -413,  -413,  -333,  -413,   346,  -216,   -26,  -413,   -13,   489,
    -413,   102,  -413,  -413,  -413,  -228,  -413,  -413,   496,    -8,
    -413,  -413,  -413,    -9,   522,   226,  -413,   532,    15,  -413,
     286,   -14,  -412,  -413,   289,   392,    29,  -413,   517,   121,
     395,    71,   513,   -24,   -46,  -413,   299,  -413,    25,  -413,
     206,    87,  -413,   781,  -303,  -413,   555,  -413,     1,  -413,
    -413,  -193,  -178,  -413,  -118,   -99,  -413,   191,  -413,   136,
     207,   209,  -413,  -413,  -413,    11,  -413,    74,    76,  -413,
     -36,  -121,  -109,  -108,  -413,    -7,  -262,  -195,  -234
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     9,    10,    11,    12,    13,    14,    15,    16,    20,
      24,    33,   430,   309,   297,   246,    17,   140,    46,   235,
     236,   529,   530,   553,   568,   554,    47,    48,    49,    50,
     269,   169,   487,   156,   157,   358,   158,   159,   160,   161,
     162,   163,   442,    51,   279,    52,    53,   263,    54,   336,
     446,   368,   369,   370,   371,   372,   373,    56,   337,    58,
     176,   559,   560,   132,   133,   134,   587,   338,    60,   199,
     135,   124,    25,    61,   365,   193,    62,   461,    71,    72,
      73,    74,    75,    76,    77,    78,   294,   565,   566,    79,
     398,   514,    80,   190,    39,    40,    41,    42,   485,   321,
     125,   126,   311,   224,   127,   128,   129,   316,   409,   410,
     317,   318,   130,   425,    22,   418,   143,   339,   340,   579,
      37,   347,   348,   349,   243,    43,    44,   250,   141
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
      21,   144,    26,    27,    28,    29,    30,    31,   225,   171,
     364,    34,    23,   342,   397,   334,   136,   136,   310,   335,
     306,   167,   353,   249,   475,   218,   366,   248,   416,    19,
     205,   145,   241,   242,   314,   142,   322,   408,   295,   244,
     505,   451,   452,   343,   164,   165,   234,   306,   344,   203,
     149,   204,   345,    32,   477,   306,    19,   274,   351,   186,
     412,  -204,    38,   426,   354,   259,   150,   189,    18,   -17,
      19,   179,    35,    19,  -313,   470,   367,   -19,  -201,    38,
     206,   207,   208,   306,   307,   188,   244,    36,   168,   480,
      19,  -313,   247,   146,   541,   387,   319,   -19,   438,   -85,
     152,   148,   209,   151,   -19,   -19,   328,  -292,   237,   428,
     458,   308,   -77,   315,   210,   211,   212,   213,   214,   194,
     506,   215,   216,   166,   219,   437,   238,   226,   227,   228,
     296,   229,   245,   232,   170,   247,   172,   551,   308,   153,
     154,   230,   253,  -200,   346,   256,   308,   252,   561,   254,
     255,  -204,   257,   258,   260,   471,   261,   205,   205,   432,
     -17,    35,   238,   -19,   -17,   271,   534,   584,   272,   273,
     588,   275,   276,   281,   308,   277,   277,   490,   305,   245,
     282,   290,   285,   476,   408,   518,   519,   239,   138,   139,
     173,   597,   225,   155,   300,   301,   302,  -292,   313,   429,
    -292,   240,   540,  -292,   174,   175,   463,   177,   -47,   179,
     195,   196,   197,   198,   405,   495,   323,   324,   187,   188,
     325,   326,   327,   239,    19,   191,   464,   497,   341,   330,
     331,   -19,   -19,   192,  -200,  -200,   483,   240,   562,   247,
     233,   478,   539,    -2,   241,   242,    19,   352,  -207,   525,
     350,   251,   466,   -89,   152,   262,   467,   359,   366,   205,
     230,   231,   357,   265,   360,   299,   -77,   362,   136,   295,
     304,   266,   535,   536,   537,   538,   391,   392,   393,   394,
     395,   268,  -120,   585,   -19,   131,   591,   270,   -19,   547,
     388,   274,   419,   153,   154,   131,    18,   399,   -47,   188,
     401,   531,   481,   423,   289,   315,   298,   167,   367,   601,
     315,   404,   -82,   264,   225,   -19,   136,   237,   411,   -19,
     493,   441,   303,   491,   492,   417,   295,   346,   241,   242,
     548,   580,   569,   549,   -19,   238,   571,   605,  -207,  -201,
      38,  -207,   329,   -89,   610,   238,   -89,   155,   421,   -89,
    -138,   598,  -313,   355,   434,   435,   383,   356,   602,   361,
     439,   296,   440,   -85,   152,   443,   445,   241,   242,   120,
     374,   396,  -120,   121,   168,    18,   -77,   454,   455,   120,
     449,   450,   457,   121,   378,   379,   174,   175,   388,   596,
     313,   320,   512,   513,   377,   313,   239,   460,   375,   462,
     603,   546,   -82,   153,   154,   -82,   239,   -82,   -82,   389,
     240,   473,  -307,   400,   474,   -84,   237,   407,   296,   275,
     240,   277,   247,   420,   -83,   237,   422,   424,   436,  -201,
     447,   225,   453,   479,   238,   489,   482,   496,   241,   242,
     522,   494,   456,   238,   291,   448,   500,   501,   502,   503,
     504,   292,    70,   -85,    18,   509,   -85,   155,   511,   -85,
     381,   382,   486,   384,   385,   386,   600,   155,   120,   520,
     521,   523,   121,   481,   499,   247,   367,   556,   225,   564,
     333,  -211,   346,   524,   583,   526,   546,   402,   403,   241,
     242,   406,    18,   241,   242,   239,   532,    19,   413,   414,
     238,   552,   570,   -19,   239,   -84,   363,   488,   -84,   240,
     -84,   -84,   267,   544,   -83,   528,    55,   -83,   240,   -83,
     -83,   427,   278,    57,  -210,   346,   572,   550,   593,  -209,
     346,   433,   557,   558,    64,    65,    66,    67,    68,   573,
     152,   594,   563,   238,   574,   341,   136,   498,   238,   -85,
     152,   586,   -77,   137,   581,   582,   415,  -297,   237,    59,
     592,   239,   -77,   590,  -208,   346,   607,   575,   380,   376,
     280,  -211,   306,   346,  -211,   240,   238,   247,   178,   153,
     154,   576,   515,   238,   293,   599,   202,   472,   589,   153,
     154,   238,   390,   428,   346,   147,   459,   604,   543,   606,
     468,   517,  -223,   346,   239,  -130,   237,   611,   612,   239,
    -307,   237,   238,   465,  -210,     0,   469,  -210,   240,  -209,
     247,   238,  -209,   240,   238,   247,   577,     0,   578,   238,
       0,   507,   508,   155,   510,   -85,     0,   239,     0,     0,
       0,   516,   -85,   155,   239,   -85,     0,  -297,     0,     0,
    -297,   240,   239,  -297,  -208,     0,     0,  -208,   240,     0,
     247,     0,   444,   308,   527,   306,   240,    19,   247,     0,
       0,     0,     0,   239,   -19,   533,     0,    81,    82,     0,
      83,     0,   239,   429,     0,   239,   542,   240,     0,   247,
     239,     0,     0,  -223,   545,  -130,   240,     0,   247,   240,
    -307,  -130,     0,     0,   240,   -19,  -307,     0,   555,     0,
       0,     0,    84,    85,    86,    87,    88,    89,    90,    91,
      92,    93,    94,    95,    96,    97,    98,    99,   100,   101,
     102,   103,   180,   104,   105,   106,   107,   108,   109,   110,
     111,   112,   113,   114,   115,   116,     0,     0,     0,   117,
       0,   152,     0,     0,   118,   -19,   308,     0,   220,   119,
     221,     0,   120,   -77,     0,   222,   121,   223,   122,   123,
      81,    82,   200,    83,    64,    65,    66,    67,    68,   201,
     608,   609,   -60,     0,   -93,   -99,  -131,     0,    45,     0,
     153,   154,     0,     0,     0,   181,   182,  -115,   183,     0,
       0,     0,   184,   185,     0,    84,    85,    86,    87,    88,
      89,    90,    91,    92,    93,    94,    95,    96,    97,    98,
      99,   100,   101,   102,   103,     0,   104,   105,   106,   107,
     108,   109,   110,   111,   112,   113,   114,   115,   116,     0,
       0,     0,   117,   -85,   155,     0,   -85,   118,     0,     0,
       0,     0,   119,   221,     0,   120,   306,   307,   222,   121,
     223,   122,   123,   332,     0,     0,     0,     0,    81,    82,
       0,    83,     0,     0,     0,  -142,     0,  -142,  -142,  -142,
    -142,  -142,  -142,  -142,   -60,     0,   -93,   -99,  -131,    63,
      45,    64,    65,    66,    67,    68,    69,    70,     0,  -115,
    -313,     0,     0,    84,    85,    86,    87,    88,    89,    90,
      91,    92,    93,    94,    95,    96,    97,    98,    99,   100,
     101,   102,   103,     0,   104,   105,   106,   107,   108,   109,
     110,   111,   112,   113,   114,   115,   116,   431,     0,     0,
     117,     0,     0,     0,     0,   118,     0,   308,    81,    82,
     119,    83,     0,   120,     0,     0,   188,   121,     0,   122,
     123,    19,   283,   284,   286,   287,   288,     0,   -19,     0,
     -19,   -19,   -19,   -19,   -19,   -19,   -19,     0,     0,     0,
       0,     0,     0,    84,    85,    86,    87,    88,    89,    90,
      91,    92,    93,    94,    95,    96,    97,    98,    99,   100,
     101,   102,   103,     0,   104,   105,   106,   107,   108,   109,
     110,   111,   112,   113,   114,   115,   116,   595,     0,     0,
     117,     0,     0,     0,     0,   118,     0,     0,    81,    82,
     119,    83,     0,   120,     0,     0,     0,   121,     0,   122,
     123,     1,     0,     2,     3,     4,     5,     6,     7,     8,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    84,    85,    86,    87,    88,    89,    90,
      91,    92,    93,    94,    95,    96,    97,    98,    99,   100,
     101,   102,   103,   307,   104,   105,   106,   107,   108,   109,
     110,   111,   112,   113,   114,   115,   116,     0,     0,     0,
     117,     0,     0,     0,     0,   118,     0,     0,     0,     0,
     119,     0,     0,   120,     0,     0,     0,   121,     0,   122,
     123,     0,     0,     0,     0,     0,     0,     0,     0,    84,
      85,    86,    87,    88,    89,    90,    91,    92,    93,    94,
      95,    96,    97,    98,    99,   100,   101,   102,     0,     0,
     104,   105,   106,   107,   108,   109,   110,   111,   112,   113,
     114,    81,    82,     0,    83,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   312,     0,     0,   120,
       0,     0,     0,   121,     0,     0,     0,     0,   484,     0,
       0,     0,     0,     0,     0,     0,    84,    85,    86,    87,
      88,    89,    90,    91,    92,    93,    94,    95,    96,    97,
      98,    99,   100,   101,   102,   103,     0,   104,   105,   106,
     107,   108,   109,   110,   111,   112,   113,   114,   115,   116,
       0,    81,    82,   117,    83,     0,     0,     0,   118,     0,
       0,     0,     0,   119,   221,     0,   120,     0,     0,   222,
     121,   223,   122,   123,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    84,    85,    86,    87,
      88,    89,    90,    91,    92,    93,    94,    95,    96,    97,
      98,    99,   100,   101,   102,   103,     0,   104,   105,   106,
     107,   108,   109,   110,   111,   112,   113,   114,   115,   116,
       0,    81,    82,   117,    83,     0,     0,     0,   118,     0,
       0,     0,     0,   119,   221,     0,   120,     0,     0,   222,
     121,   223,   122,   123,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    84,    85,    86,    87,
      88,    89,    90,    91,    92,    93,    94,    95,    96,    97,
      98,    99,   100,   101,   102,   103,     0,   104,   105,   106,
     107,   108,   109,   110,   111,   112,   113,   114,   115,   116,
       0,     0,     0,   117,     0,     0,     0,     0,   118,     0,
       0,     0,     0,   119,     0,     0,   120,     0,     0,     0,
     121,     0,   122,   123,    84,    85,    86,    87,    88,    89,
      90,    91,    92,    93,    94,    95,    96,    97,    98,    99,
     100,   101,   102,     0,     0,   104,   105,   106,   107,   108,
     109,   110,   111,   112,   113,   114,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   567,     0,     0,     0,     0,
       0,   312,     0,     0,   120,     0,     0,  -142,   121,  -142,
    -142,  -142,  -142,  -142,  -142,  -142,   -60,     0,   -93,   -99,
    -131,     0,    45,     0,     0,     0,     0,     0,     0,     0,
       0,  -115,  -313,    84,    85,    86,    87,    88,    89,    90,
      91,    92,    93,    94,    95,    96,    97,    98,    99,   100,
     101,   102,   217,     0,   104,   105,   106,   107,   108,   109,
     110,   111,   112,   113,   114,    84,    85,    86,    87,    88,
      89,    90,    91,    92,    93,    94,    95,    96,    97,    98,
      99,   100,   101,   102,     0,     0,   104,   105,   106,   107,
     108,   109,   110,   111,   112,   113,   114
};

static const yytype_int16 yycheck[] =
{
       1,    37,     3,     4,     5,     6,     7,     8,   126,    52,
     272,    18,     1,   236,   294,   235,    30,    31,   211,   235,
       0,    12,   256,   144,   416,   124,    44,   144,   331,     6,
      76,    38,   141,   141,   212,    36,   214,   318,     0,     0,
     452,   374,   375,   238,    45,    46,     0,     0,   243,    73,
       1,    75,   247,     0,    93,     0,     6,    96,   253,    66,
      13,     0,     1,   343,   259,     1,    17,    68,     1,     6,
       6,    21,     6,     6,    13,    20,    94,    13,     0,     1,
      81,    82,    83,     0,     1,     1,     0,    12,    79,    93,
       6,    13,    96,     0,   506,   290,    13,    13,   360,     0,
       1,    93,   103,    13,    20,    21,   224,     0,     1,     0,
     390,    91,    13,   212,   115,   116,   117,   118,   119,     6,
     453,   122,   123,    22,   125,   359,    19,   128,   129,   130,
      92,   132,    93,   134,    24,    96,    25,   529,    91,    40,
      41,    95,   149,     0,     1,   152,    91,   148,   540,   150,
     151,    90,   153,   154,   155,   100,   157,   203,   204,   352,
      97,     6,    19,    96,   101,   166,   499,   559,   169,   170,
     562,   172,   173,   180,    91,   176,   177,   439,   202,    93,
     181,   188,   183,   417,   465,   466,   467,    80,     5,     6,
      37,   583,   310,    94,   195,   196,   197,    90,   212,    90,
      93,    94,   505,    96,    12,    13,   401,    26,     0,    21,
      97,    98,    99,   100,   313,   443,   217,   218,    13,     1,
     221,   222,   223,    80,     6,    21,   404,    13,   235,   230,
     231,    13,    14,     0,    91,    92,   431,    94,   541,    96,
      68,     1,   504,     0,   353,   353,     6,   254,     0,     1,
     251,    93,    97,     0,     1,    13,   101,   264,    44,   305,
      95,    96,   263,    95,   265,   194,    13,   268,   282,     0,
     199,     0,   500,   501,   502,   503,     7,     8,     9,    10,
      11,    13,     0,     1,    44,    13,   566,     0,    70,   523,
     291,    96,   335,    40,    41,    13,     1,   298,    90,     1,
     307,   496,   423,   339,    13,   404,    95,    12,    94,   589,
     409,   312,     0,     1,   432,    97,   330,     1,   319,   101,
     441,   364,    13,   440,   441,   332,     0,     1,   437,   437,
     525,   554,   552,   526,    94,    19,   552,   599,    90,     0,
       1,    93,     0,    90,   606,    19,    93,    94,   337,    96,
      68,   585,    13,    13,   355,   356,   285,    42,   592,    95,
     361,    92,   363,     0,     1,   366,   367,   476,   476,    97,
      96,   102,    90,   101,    79,     1,    13,   378,   379,    97,
      45,    46,   383,   101,    13,    14,    12,    13,   389,   582,
     404,   214,    12,    13,    13,   409,    80,   398,    96,   400,
     595,   522,    90,    40,    41,    93,    80,    95,    96,    13,
      94,   412,    96,   100,   415,     0,     1,     6,    92,   420,
      94,   422,    96,    25,     0,     1,    26,    38,    42,    90,
      45,   549,    96,   422,    19,   436,   425,   444,   547,   547,
     476,   442,    70,    19,    13,    46,   447,   448,   449,   450,
     451,    20,    21,    90,     1,   456,    93,    94,   459,    96,
     283,   284,    17,   286,   287,   288,   587,    94,    97,   470,
     471,   478,   101,   594,    96,    96,    94,    17,   596,    13,
     235,     0,     1,   484,   558,   486,   607,   310,   311,   598,
     598,   314,     1,   602,   602,    80,   497,     6,   321,   322,
      19,   530,   552,    12,    80,    90,   269,   435,    93,    94,
      95,    96,   163,   514,    90,   489,    27,    93,    94,    95,
      96,   344,   176,    27,     0,     1,   552,   528,   571,     0,
       1,   354,   533,   534,    15,    16,    17,    18,    19,   552,
       1,   577,   543,    19,   552,   552,   560,   445,    19,     0,
       1,   560,    13,    31,   555,   556,   330,     0,     1,    27,
     567,    80,    13,   564,     0,     1,   602,   552,   282,   280,
     178,    90,     0,     1,    93,    94,    19,    96,    61,    40,
      41,   552,   461,    19,   189,   586,    73,   410,   563,    40,
      41,    19,   293,     0,     1,    40,   390,   596,   511,   600,
     409,   465,     0,     1,    80,     0,     1,   608,   609,    80,
       0,     1,    19,   404,    90,    -1,   409,    93,    94,    90,
      96,    19,    93,    94,    19,    96,   552,    -1,   552,    19,
      -1,   454,   455,    94,   457,    96,    -1,    80,    -1,    -1,
      -1,   464,    93,    94,    80,    96,    -1,    90,    -1,    -1,
      93,    94,    80,    96,    90,    -1,    -1,    93,    94,    -1,
      96,    -1,     1,    91,   487,     0,    94,     6,    96,    -1,
      -1,    -1,    -1,    80,    13,   498,    -1,    12,    13,    -1,
      15,    -1,    80,    90,    -1,    80,   509,    94,    -1,    96,
      80,    -1,    -1,    91,   517,    90,    94,    -1,    96,    94,
      90,    96,    -1,    -1,    94,    44,    96,    -1,   531,    -1,
      -1,    -1,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,    61,    62,    63,    64,
      65,    66,    17,    68,    69,    70,    71,    72,    73,    74,
      75,    76,    77,    78,    79,    80,    -1,    -1,    -1,    84,
      -1,     1,    -1,    -1,    89,    94,    91,    -1,     0,    94,
      95,    -1,    97,    13,    -1,   100,   101,   102,   103,   104,
      12,    13,    13,    15,    15,    16,    17,    18,    19,    20,
     603,   604,    22,    -1,    24,    25,    26,    -1,    28,    -1,
      40,    41,    -1,    -1,    -1,    80,    81,    37,    83,    -1,
      -1,    -1,    87,    88,    -1,    47,    48,    49,    50,    51,
      52,    53,    54,    55,    56,    57,    58,    59,    60,    61,
      62,    63,    64,    65,    66,    -1,    68,    69,    70,    71,
      72,    73,    74,    75,    76,    77,    78,    79,    80,    -1,
      -1,    -1,    84,    93,    94,    -1,    96,    89,    -1,    -1,
      -1,    -1,    94,    95,    -1,    97,     0,     1,   100,   101,
     102,   103,   104,     1,    -1,    -1,    -1,    -1,    12,    13,
      -1,    15,    -1,    -1,    -1,    13,    -1,    15,    16,    17,
      18,    19,    20,    21,    22,    -1,    24,    25,    26,    13,
      28,    15,    16,    17,    18,    19,    20,    21,    -1,    37,
      38,    -1,    -1,    47,    48,    49,    50,    51,    52,    53,
      54,    55,    56,    57,    58,    59,    60,    61,    62,    63,
      64,    65,    66,    -1,    68,    69,    70,    71,    72,    73,
      74,    75,    76,    77,    78,    79,    80,     1,    -1,    -1,
      84,    -1,    -1,    -1,    -1,    89,    -1,    91,    12,    13,
      94,    15,    -1,    97,    -1,    -1,     1,   101,    -1,   103,
     104,     6,   181,   182,   183,   184,   185,    -1,    13,    -1,
      15,    16,    17,    18,    19,    20,    21,    -1,    -1,    -1,
      -1,    -1,    -1,    47,    48,    49,    50,    51,    52,    53,
      54,    55,    56,    57,    58,    59,    60,    61,    62,    63,
      64,    65,    66,    -1,    68,    69,    70,    71,    72,    73,
      74,    75,    76,    77,    78,    79,    80,     1,    -1,    -1,
      84,    -1,    -1,    -1,    -1,    89,    -1,    -1,    12,    13,
      94,    15,    -1,    97,    -1,    -1,    -1,   101,    -1,   103,
     104,    27,    -1,    29,    30,    31,    32,    33,    34,    35,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    47,    48,    49,    50,    51,    52,    53,
      54,    55,    56,    57,    58,    59,    60,    61,    62,    63,
      64,    65,    66,     1,    68,    69,    70,    71,    72,    73,
      74,    75,    76,    77,    78,    79,    80,    -1,    -1,    -1,
      84,    -1,    -1,    -1,    -1,    89,    -1,    -1,    -1,    -1,
      94,    -1,    -1,    97,    -1,    -1,    -1,   101,    -1,   103,
     104,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    47,
      48,    49,    50,    51,    52,    53,    54,    55,    56,    57,
      58,    59,    60,    61,    62,    63,    64,    65,    -1,    -1,
      68,    69,    70,    71,    72,    73,    74,    75,    76,    77,
      78,    12,    13,    -1,    15,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    94,    -1,    -1,    97,
      -1,    -1,    -1,   101,    -1,    -1,    -1,    -1,    39,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    47,    48,    49,    50,
      51,    52,    53,    54,    55,    56,    57,    58,    59,    60,
      61,    62,    63,    64,    65,    66,    -1,    68,    69,    70,
      71,    72,    73,    74,    75,    76,    77,    78,    79,    80,
      -1,    12,    13,    84,    15,    -1,    -1,    -1,    89,    -1,
      -1,    -1,    -1,    94,    95,    -1,    97,    -1,    -1,   100,
     101,   102,   103,   104,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    47,    48,    49,    50,
      51,    52,    53,    54,    55,    56,    57,    58,    59,    60,
      61,    62,    63,    64,    65,    66,    -1,    68,    69,    70,
      71,    72,    73,    74,    75,    76,    77,    78,    79,    80,
      -1,    12,    13,    84,    15,    -1,    -1,    -1,    89,    -1,
      -1,    -1,    -1,    94,    95,    -1,    97,    -1,    -1,   100,
     101,   102,   103,   104,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    47,    48,    49,    50,
      51,    52,    53,    54,    55,    56,    57,    58,    59,    60,
      61,    62,    63,    64,    65,    66,    -1,    68,    69,    70,
      71,    72,    73,    74,    75,    76,    77,    78,    79,    80,
      -1,    -1,    -1,    84,    -1,    -1,    -1,    -1,    89,    -1,
      -1,    -1,    -1,    94,    -1,    -1,    97,    -1,    -1,    -1,
     101,    -1,   103,   104,    47,    48,    49,    50,    51,    52,
      53,    54,    55,    56,    57,    58,    59,    60,    61,    62,
      63,    64,    65,    -1,    -1,    68,    69,    70,    71,    72,
      73,    74,    75,    76,    77,    78,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,     1,    -1,    -1,    -1,    -1,
      -1,    94,    -1,    -1,    97,    -1,    -1,    13,   101,    15,
      16,    17,    18,    19,    20,    21,    22,    -1,    24,    25,
      26,    -1,    28,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    37,    38,    47,    48,    49,    50,    51,    52,    53,
      54,    55,    56,    57,    58,    59,    60,    61,    62,    63,
      64,    65,    66,    -1,    68,    69,    70,    71,    72,    73,
      74,    75,    76,    77,    78,    47,    48,    49,    50,    51,
      52,    53,    54,    55,    56,    57,    58,    59,    60,    61,
      62,    63,    64,    65,    -1,    -1,    68,    69,    70,    71,
      72,    73,    74,    75,    76,    77,    78
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,    27,    29,    30,    31,    32,    33,    34,    35,   106,
     107,   108,   109,   110,   111,   112,   113,   121,     1,     6,
     114,   115,   219,   220,   115,   177,   115,   115,   115,   115,
     115,   115,     0,   116,   230,     6,    12,   225,     1,   199,
     200,   201,   202,   230,   231,    28,   123,   131,   132,   133,
     134,   148,   150,   151,   153,   154,   162,   163,   164,   172,
     173,   178,   181,    13,    15,    16,    17,    18,    19,    20,
      21,   183,   184,   185,   186,   187,   188,   189,   190,   194,
     197,    12,    13,    15,    47,    48,    49,    50,    51,    52,
      53,    54,    55,    56,    57,    58,    59,    60,    61,    62,
      63,    64,    65,    66,    68,    69,    70,    71,    72,    73,
      74,    75,    76,    77,    78,    79,    80,    84,    89,    94,
      97,   101,   103,   104,   176,   205,   206,   209,   210,   211,
     217,    13,   168,   169,   170,   175,   176,   169,     5,     6,
     122,   233,   115,   221,   225,   230,     0,   201,    93,     1,
      17,    13,     1,    40,    41,    94,   138,   139,   141,   142,
     143,   144,   145,   146,   115,   115,    22,    12,    79,   136,
      24,   144,    25,    37,    12,    13,   165,    26,   183,    21,
      17,    80,    81,    83,    87,    88,   230,    13,     1,   115,
     198,    21,     0,   180,     6,    97,    98,    99,   100,   174,
      13,    20,   187,   188,   188,   189,   115,   115,   115,   115,
     115,   115,   115,   115,   115,   115,   115,    66,   210,   115,
       0,    95,   100,   102,   208,   209,   115,   115,   115,   115,
      95,    96,   115,    68,     0,   124,   125,     1,    19,    80,
      94,   227,   228,   229,     0,    93,   120,    96,   120,   226,
     232,    93,   115,   230,   115,   115,   230,   115,   115,     1,
     115,   115,    13,   152,     1,    95,     0,   143,    13,   135,
       0,   115,   115,   115,    96,   115,   115,   115,   149,   149,
     180,   230,   115,   198,   198,   115,   198,   198,   198,    13,
     230,    13,    20,   185,   191,     0,    92,   119,    95,   186,
     115,   115,   115,    13,   186,   188,     0,     1,    91,   118,
     206,   207,    94,   176,   207,   210,   212,   215,   216,    13,
     118,   204,   207,   115,   115,   115,   115,   115,   209,     0,
     115,   115,     1,   123,   132,   150,   154,   163,   172,   222,
     223,   230,   116,   232,   232,   232,     1,   226,   227,   228,
     115,   232,   230,   233,   232,    13,    42,   115,   140,   230,
     115,    95,   115,   136,   231,   179,    44,    94,   156,   157,
     158,   159,   160,   161,    96,    96,   179,    13,    13,    14,
     175,   118,   118,   186,   118,   118,   118,   232,   115,    13,
     191,     7,     8,     9,    10,    11,   102,   119,   195,   115,
     100,   230,   118,   118,   115,   210,   118,     6,   114,   213,
     214,   115,    13,   118,   118,   170,   199,   230,   220,   144,
      25,   220,    26,   225,    38,   218,   119,   118,     0,    90,
     117,     1,   206,   118,   115,   115,    42,   233,   231,   115,
     115,   144,   147,   115,     1,   115,   155,    45,    46,    45,
      46,   147,   147,    96,   115,   115,    70,   115,   119,   195,
     115,   182,   115,   232,   207,   216,    97,   101,   212,   215,
      20,   100,   118,   115,   115,   117,   233,    93,     1,   220,
      93,   226,   220,   232,    39,   203,    17,   137,   138,   115,
     231,   120,   120,   226,   115,   160,   230,    13,   156,    96,
     115,   115,   115,   115,   115,   177,   147,   118,   118,   115,
     118,   115,    12,    13,   196,   184,   118,   214,   114,   114,
     115,   115,   225,   230,   115,     1,   115,   118,   139,   126,
     127,   232,   115,   118,   147,   160,   160,   160,   160,   231,
     199,   177,   118,   196,   115,   118,   226,   233,   232,   206,
     115,   117,   124,   128,   130,   118,    17,   115,   115,   166,
     167,   117,   199,   115,    13,   192,   193,     1,   129,   132,
     134,   150,   151,   153,   164,   173,   181,   222,   223,   224,
     116,   115,   115,   126,   117,     1,   168,   171,   117,   193,
     115,   119,   230,   144,   225,     1,   206,   117,   233,   115,
     226,   119,   233,   232,   203,   231,   115,   225,   118,   118,
     231,   115,   115
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,   105,   106,   106,   106,   106,   106,   106,   106,   106,
     107,   108,   109,   110,   111,   112,   113,   114,   114,   115,
     115,   116,   116,   116,   117,   117,   118,   118,   119,   119,
     120,   120,   121,   121,   121,   122,   122,   123,   123,   123,
     123,   123,   123,   123,   124,   125,   125,   126,   126,   127,
     127,   128,   129,   129,   129,   129,   129,   129,   130,   130,
     131,   132,   133,   133,   134,   135,   135,   136,   136,   137,
     137,   138,   138,   139,   139,   140,   140,   141,   141,   141,
     142,   142,   143,   143,   143,   144,   144,   145,   145,   145,
     146,   146,   147,   148,   149,   150,   151,   152,   153,   154,
     155,   156,   156,   156,   156,   157,   158,   158,   159,   159,
     160,   160,   160,   161,   161,   162,   163,   164,   165,   165,
     166,   166,   167,   167,   167,   168,   169,   169,   170,   170,
     171,   172,   173,   174,   174,   174,   174,   175,   175,   176,
     176,   177,   178,   179,   180,   181,   182,   183,   183,   184,
     184,   184,   184,   185,   185,   185,   186,   186,   186,   186,
     186,   186,   187,   187,   188,   188,   189,   189,   189,   189,
     189,   190,   191,   192,   193,   193,   194,   194,   194,   194,
     194,   195,   195,   195,   195,   195,   195,   196,   196,   197,
     197,   197,   197,   197,   197,   197,   197,   197,   197,   197,
     198,   199,   199,   199,   199,   200,   200,   201,   201,   201,
     201,   201,   202,   203,   203,   204,   204,   205,   205,   205,
     206,   206,   206,   207,   208,   208,   208,   209,   209,   209,
     209,   209,   209,   209,   209,   209,   209,   209,   209,   209,
     209,   210,   210,   210,   210,   210,   210,   210,   210,   210,
     210,   210,   210,   210,   210,   210,   210,   210,   210,   210,
     210,   210,   210,   210,   210,   210,   210,   210,   210,   210,
     210,   211,   211,   211,   212,   212,   213,   213,   213,   213,
     214,   214,   215,   215,   216,   216,   216,   216,   217,   217,
     218,   219,   220,   221,   221,   222,   222,   222,   222,   222,
     223,   223,   223,   223,   224,   224,   224,   225,   226,   227,
     228,   229,   229,   230,   231,   232,   232,   232,   232,   232,
     233,   233,   233,   233
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     3,     1,     1,     1,     1,     1,     1,     1,
       5,     5,     4,     4,     4,     5,     4,     1,     2,     0,
       1,     0,     2,     2,     1,     1,     1,     1,     1,     1,
       1,     1,     0,     5,     2,     0,     3,     1,     1,     1,
       1,     1,     1,     1,     0,     2,     2,     1,     2,     0,
       3,     2,     1,     1,     1,     1,     1,     1,     2,     2,
       0,     3,     6,     6,     6,     0,     2,     1,     1,     0,
       3,     6,     4,     1,     5,     1,     5,     0,     2,     2,
       2,     3,     1,     4,     3,     0,     1,     1,     2,     1,
       4,     5,     0,     0,     1,     3,     8,     1,    10,     0,
       0,     1,     1,     1,     1,     3,     4,     4,     4,     4,
       5,     1,     6,    10,    10,     0,     3,     9,     1,     1,
       1,     2,     0,     4,     5,     5,     2,     5,     2,     1,
       2,     0,     8,     2,     2,     2,     4,     1,     0,     1,
       1,     1,     0,     0,     0,     9,     0,     1,     6,     1,
       2,     3,     3,     1,     2,     2,     1,     2,     1,     2,
       3,     2,     1,     1,     1,     2,     1,     1,     1,     1,
       1,     2,     2,     2,     1,     0,     4,     9,     5,    10,
       3,     1,     1,     1,     1,     1,     1,     1,     1,     3,
       4,     4,     6,     7,     6,     4,     6,     4,     4,     4,
       3,     0,     1,     2,     1,     3,     4,     6,     8,     6,
       4,     3,     3,     2,     0,     2,     3,     3,     4,     4,
       1,     3,     2,     3,     2,     2,     2,     2,     3,     2,
       2,     2,     3,     2,     2,     2,     2,     2,     2,     2,
       2,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     4,     3,     4,     1,     2,     3,     3,     3,     3,
       0,     1,     5,     4,     1,     3,     3,     1,     5,     4,
       1,     3,     3,     2,     2,     2,     3,     5,     2,     3,
       5,     3,     3,     3,     4,     2,     2,     0,     3,     3,
       3,     1,     1,     0,     0,     0,     2,     2,     2,     2,
       0,     2,     2,     2
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                  \
do                                                              \
  if (yychar == YYEMPTY)                                        \
    {                                                           \
      yychar = (Token);                                         \
      yylval = (Value);                                         \
      YYPOPSTACK (yylen);                                       \
      yystate = *yyssp;                                         \
      goto yybackup;                                            \
    }                                                           \
  else                                                          \
    {                                                           \
      yyerror (&yylloc, scanner, parser, YY_("syntax error: cannot back up")); \
      YYERROR;                                                  \
    }                                                           \
while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256


/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */

#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)                                \
    do                                                                  \
      if (N)                                                            \
        {                                                               \
          (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;        \
          (Current).first_column = YYRHSLOC (Rhs, 1).first_column;      \
          (Current).last_line    = YYRHSLOC (Rhs, N).last_line;         \
          (Current).last_column  = YYRHSLOC (Rhs, N).last_column;       \
        }                                                               \
      else                                                              \
        {                                                               \
          (Current).first_line   = (Current).last_line   =              \
            YYRHSLOC (Rhs, 0).last_line;                                \
          (Current).first_column = (Current).last_column =              \
            YYRHSLOC (Rhs, 0).last_column;                              \
        }                                                               \
    while (0)
#endif

#define YYRHSLOC(Rhs, K) ((Rhs)[K])


/* Enable debugging if requested.  */
#if KATANADEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)


/* YY_LOCATION_PRINT -- Print the location on the stream.
   This macro was not mandated originally: define only if we know
   we won't break user code: when these are the locations we know.  */

#ifndef YY_LOCATION_PRINT
# if defined KATANALTYPE_IS_TRIVIAL && KATANALTYPE_IS_TRIVIAL

/* Print *YYLOCP on YYO.  Private, do not rely on its existence. */

YY_ATTRIBUTE_UNUSED
static unsigned
yy_location_print_ (FILE *yyo, YYLTYPE const * const yylocp)
{
  unsigned res = 0;
  int end_col = 0 != yylocp->last_column ? yylocp->last_column - 1 : 0;
  if (0 <= yylocp->first_line)
    {
      res += YYFPRINTF (yyo, "%d", yylocp->first_line);
      if (0 <= yylocp->first_column)
        res += YYFPRINTF (yyo, ".%d", yylocp->first_column);
    }
  if (0 <= yylocp->last_line)
    {
      if (yylocp->first_line < yylocp->last_line)
        {
          res += YYFPRINTF (yyo, "-%d", yylocp->last_line);
          if (0 <= end_col)
            res += YYFPRINTF (yyo, ".%d", end_col);
        }
      else if (0 <= end_col && yylocp->first_column < end_col)
        res += YYFPRINTF (yyo, "-%d", end_col);
    }
  return res;
 }

#  define YY_LOCATION_PRINT(File, Loc)          \
  yy_location_print_ (File, &(Loc))

# else
#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
# endif
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value, Location, scanner, parser); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*----------------------------------------.
| Print this symbol's value on YYOUTPUT.  |
`----------------------------------------*/

static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep, YYLTYPE const * const yylocationp, void* scanner, struct KatanaInternalParser * parser)
{
  FILE *yyo = yyoutput;
  YYUSE (yyo);
  YYUSE (yylocationp);
  YYUSE (scanner);
  YYUSE (parser);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# endif
  YYUSE (yytype);
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep, YYLTYPE const * const yylocationp, void* scanner, struct KatanaInternalParser * parser)
{
  YYFPRINTF (yyoutput, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  YY_LOCATION_PRINT (yyoutput, *yylocationp);
  YYFPRINTF (yyoutput, ": ");
  yy_symbol_value_print (yyoutput, yytype, yyvaluep, yylocationp, scanner, parser);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yytype_int16 *yyssp, YYSTYPE *yyvsp, YYLTYPE *yylsp, int yyrule, void* scanner, struct KatanaInternalParser * parser)
{
  unsigned long int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[yyssp[yyi + 1 - yynrhs]],
                       &(yyvsp[(yyi + 1) - (yynrhs)])
                       , &(yylsp[(yyi + 1) - (yynrhs)])                       , scanner, parser);
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, yylsp, Rule, scanner, parser); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !KATANADEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !KATANADEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
static YYSIZE_T
yystrlen (const char *yystr)
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            /* Fall through.  */
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
                yytype_int16 *yyssp, int yytoken)
{
  YYSIZE_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
  YYSIZE_T yysize = yysize0;
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat. */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Number of reported tokens (one for the "unexpected", one per
     "expected"). */
  int yycount = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[*yyssp];
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYSIZE_T yysize1 = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (! (yysize <= yysize1
                         && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
                    return 2;
                  yysize = yysize1;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    YYSIZE_T yysize1 = yysize + yystrlen (yyformat);
    if (! (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
      return 2;
    yysize = yysize1;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          yyp++;
          yyformat++;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep, YYLTYPE *yylocationp, void* scanner, struct KatanaInternalParser * parser)
{
  YYUSE (yyvaluep);
  YYUSE (yylocationp);
  YYUSE (scanner);
  YYUSE (parser);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/*----------.
| yyparse.  |
`----------*/

int
yyparse (void* scanner, struct KatanaInternalParser * parser)
{
/* The lookahead symbol.  */
int yychar;


/* The semantic value of the lookahead symbol.  */
/* Default value used for initialization, for pacifying older GCCs
   or non-GCC compilers.  */
YY_INITIAL_VALUE (static YYSTYPE yyval_default;)
YYSTYPE yylval YY_INITIAL_VALUE (= yyval_default);

/* Location data for the lookahead symbol.  */
static YYLTYPE yyloc_default
# if defined KATANALTYPE_IS_TRIVIAL && KATANALTYPE_IS_TRIVIAL
  = { 1, 1, 1, 1 }
# endif
;
YYLTYPE yylloc = yyloc_default;

    /* Number of syntax errors so far.  */
    int yynerrs;

    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.
       'yyls': related to locations.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    /* The location stack.  */
    YYLTYPE yylsa[YYINITDEPTH];
    YYLTYPE *yyls;
    YYLTYPE *yylsp;

    /* The locations where the error started and ended.  */
    YYLTYPE yyerror_range[3];

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;
  YYLTYPE yyloc;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N), yylsp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yylsp = yyls = yylsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  yylsp[0] = yylloc;
  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        YYSTYPE *yyvs1 = yyvs;
        yytype_int16 *yyss1 = yyss;
        YYLTYPE *yyls1 = yyls;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * sizeof (*yyssp),
                    &yyvs1, yysize * sizeof (*yyvsp),
                    &yyls1, yysize * sizeof (*yylsp),
                    &yystacksize);

        yyls = yyls1;
        yyss = yyss1;
        yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yytype_int16 *yyss1 = yyss;
        union yyalloc *yyptr =
          (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
        YYSTACK_RELOCATE (yyls_alloc, yyls);
#  undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;
      yylsp = yyls + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
                  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex (&yylval, &yylloc, scanner, parser);
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END
  *++yylsp = yylloc;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];

  /* Default location.  */
  YYLLOC_DEFAULT (yyloc, (yylsp - yylen), yylen);
  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 10:

    {
        katana_parse_internal_rule(parser, (yyvsp[-2].rule));
    }

    break;

  case 11:

    {
        katana_parse_internal_keyframe_rule(parser, (yyvsp[-2].keyframe));
    }

    break;

  case 12:

    {
        katana_parse_internal_keyframe_key_list(parser, (yyvsp[-1].valueList));
    }

    break;

  case 13:

    {
        /* can be empty */
        katana_parse_internal_declaration_list(parser, (yyvsp[-1].boolean));
    }

    break;

  case 14:

    {
        katana_parse_internal_value(parser, (yyvsp[-1].valueList));
    }

    break;

  case 15:

    {
        katana_parse_internal_media_list(parser, (yyvsp[-1].mediaList));
    }

    break;

  case 16:

    {
        katana_parse_internal_selector(parser, (yyvsp[-1].selectorList));
    }

    break;

  case 33:

    {
        /* create a charset rule and push to stylesheet rules */
        katana_set_charset(parser, &(yyvsp[-2].string));
    }

    break;

  case 36:

    {
        if ((yyvsp[-1].rule))
            katana_add_rule(parser, (yyvsp[-1].rule));
    }

    break;

  case 44:

    {
        katana_start_rule(parser);
    }

    break;

  case 45:

    {
        (yyval.rule) = (yyvsp[0].rule);
        // parser->m_hadSyntacticallyValidCSSRule = true;
        katana_end_rule(parser, !!(yyval.rule));
    }

    break;

  case 46:

    {
        (yyval.rule) = 0;
        katana_end_rule(parser, false);
    }

    break;

  case 49:

    { (yyval.ruleList) = 0; }

    break;

  case 50:

    {
      (yyval.ruleList) = katana_rule_list_add(parser, (yyvsp[-1].rule), (yyvsp[-2].ruleList));
    }

    break;

  case 51:

    {
        katana_end_rule(parser, false);
    }

    break;

  case 58:

    {
        (yyval.rule) = (yyvsp[0].rule);
        katana_end_rule(parser, !!(yyval.rule));
    }

    break;

  case 59:

    {
        (yyval.rule) = 0;
        katana_end_rule(parser, false);
    }

    break;

  case 60:

    {
        katana_start_rule_header(parser, KatanaRuleImport);
    }

    break;

  case 61:

    {
        katana_end_rule_header(parser);
        katana_start_rule_body(parser);
    }

    break;

  case 62:

    {
        (yyval.rule) = katana_new_import_rule(parser, &(yyvsp[-4].string), (yyvsp[-1].mediaList));
    }

    break;

  case 63:

    {
        (yyval.rule) = 0;
    }

    break;

  case 64:

    {
        katana_add_namespace(parser, &(yyvsp[-3].string), &(yyvsp[-2].string));
        (yyval.rule) = 0;
    }

    break;

  case 65:

    { /*$$.clear()*/ }

    break;

  case 69:

    {
        (yyval.valueList) = 0;
    }

    break;

  case 70:

    {
        (yyval.valueList) = (yyvsp[0].valueList);
    }

    break;

  case 71:

    {
        katana_string_to_lowercase(parser, &(yyvsp[-3].string));
        (yyval.mediaQueryExp) = katana_new_media_query_exp(parser, &(yyvsp[-3].string), (yyvsp[-1].valueList));
        if (!(yyval.mediaQueryExp))
            YYERROR;
    }

    break;

  case 72:

    {
        YYERROR;
    }

    break;

  case 73:

    {
        (yyval.mediaQueryExpList) = katana_new_media_query_exp_list(parser);
        katana_media_query_exp_list_add(parser, (yyvsp[0].mediaQueryExp), (yyval.mediaQueryExpList));   
    }

    break;

  case 74:

    {
        (yyval.mediaQueryExpList) = (yyvsp[-4].mediaQueryExpList);
        katana_media_query_exp_list_add(parser, (yyvsp[0].mediaQueryExp), (yyval.mediaQueryExpList));   
    }

    break;

  case 75:

    {
        (yyval.mediaQueryExpList) = katana_new_media_query_exp_list(parser);
    }

    break;

  case 76:

    {
        (yyval.mediaQueryExpList) = (yyvsp[-1].mediaQueryExpList);
    }

    break;

  case 77:

    {
        (yyval.mediaQueryRestrictor) = KatanaMediaQueryRestrictorNone;
    }

    break;

  case 78:

    {
        (yyval.mediaQueryRestrictor) = KatanaMediaQueryRestrictorOnly;
    }

    break;

  case 79:

    {
        (yyval.mediaQueryRestrictor) = KatanaMediaQueryRestrictorNot;
    }

    break;

  case 80:

    {
        (yyval.mediaQuery) = katana_new_media_query(parser, KatanaMediaQueryRestrictorNone, NULL, (yyvsp[-1].mediaQueryExpList));
    }

    break;

  case 81:

    {
        katana_string_to_lowercase(parser, &(yyvsp[-1].string));
        (yyval.mediaQuery) = katana_new_media_query(parser, (yyvsp[-2].mediaQueryRestrictor), &(yyvsp[-1].string), (yyvsp[0].mediaQueryExpList));
    }

    break;

  case 83:

    {
        katana_parser_report_error(parser, (yyvsp[-1].location), "parser->lastLocationLabel(), InvalidMediaQueryCSSError");
        (yyval.mediaQuery) = katana_new_media_query(parser, KatanaMediaQueryRestrictorNot, NULL, NULL);
    }

    break;

  case 84:

    {
        katana_parser_report_error(parser, (yyvsp[-1].location), "parser->lastLocationLabel(), InvalidMediaQueryCSSError");
        (yyval.mediaQuery) = katana_new_media_query(parser, KatanaMediaQueryRestrictorNot, NULL, NULL);
    }

    break;

  case 85:

    {
        (yyval.mediaList) = katana_new_media_list(parser);
    }

    break;

  case 87:

    {
        (yyval.mediaList) = katana_new_media_list(parser);
        katana_media_list_add(parser, (yyvsp[0].mediaQuery), (yyval.mediaList));
    }

    break;

  case 88:

    {
        (yyval.mediaList) = (yyvsp[-1].mediaList);
        katana_media_list_add(parser, (yyvsp[0].mediaQuery), (yyval.mediaList));
    }

    break;

  case 89:

    {
        (yyval.mediaList) = (yyvsp[0].mediaList);
        // $$->addMediaQuery(parser->sinkFloatingMediaQuery(parser->createFloatingNotAllQuery()));
        katana_parser_log(parser, "createFloatingNotAllQuery");
    }

    break;

  case 90:

    {
        (yyval.mediaList) = katana_new_media_list(parser);
        katana_media_list_add(parser, (yyvsp[-3].mediaQuery), (yyval.mediaList));
    }

    break;

  case 91:

    {
        (yyval.mediaList) = (yyvsp[-4].mediaList);
        katana_media_list_add(parser, (yyvsp[-3].mediaQuery), (yyval.mediaList));
    }

    break;

  case 92:

    {
        katana_start_rule_body(parser);
    }

    break;

  case 93:

    {
        katana_start_rule_header(parser, KatanaRuleMedia);
    }

    break;

  case 94:

    {
        katana_end_rule_header(parser);
    }

    break;

  case 96:

    {
        (yyval.rule) = katana_new_media_rule(parser, (yyvsp[-6].mediaList), (yyvsp[-1].ruleList));
    }

    break;

  case 98:

    {
        // $$ = parser->createSupportsRule($4, $9);
    }

    break;

  case 99:

    {
        // parser->startRuleHeader(CSSRuleSourceData::SUPPORTS_RULE);
        // parser->markSupportsRuleHeaderStart();
    }

    break;

  case 100:

    {
        // parser->endRuleHeader();
        // parser->markSupportsRuleHeaderEnd();
    }

    break;

  case 105:

    {
        // $$ = !$3;
    }

    break;

  case 106:

    {
        // $$ = $1 && $4;
    }

    break;

  case 107:

    {
        // $$ = $1 && $4;
    }

    break;

  case 108:

    {
        // $$ = $1 || $4;
    }

    break;

  case 109:

    {
        // $$ = $1 || $4;
    }

    break;

  case 110:

    {
        // $$ = $3;
    }

    break;

  case 112:

    {
        // katana_parser_report_error(parser, $3, InvalidSupportsConditionCSSError);
        // $$ = false;
    }

    break;

  case 113:

    {
        // $$ = false;
        // CSSPropertyID id = cssPropertyID($3);
        // if (id != CSSPropertyInvalid) {
        //     parser->m_valueList = parser->sinkFloatingValueList($7);
        //     int oldParsedProperties = parser->m_parsedProperties.size();
        //     $$ = parser->parseValue(id, $8);
        //     // We just need to know if the declaration is supported as it is written. Rollback any additions.
        //     if ($$)
        //         parser->rollbackLastProperties(parser->m_parsedProperties.size() - oldParsedProperties);
        // }
        // parser->m_valueList = nullptr;
        // parser->endProperty($8, false);
    }

    break;

  case 114:

    {
        // $$ = false;
        // parser->endProperty(false, false, GeneralCSSError);
    }

    break;

  case 115:

    {
        katana_start_rule_header(parser, KatanaRuleKeyframes);
    }

    break;

  case 116:

    {
        (yyval.boolean) = false;
    }

    break;

  case 117:

    {
        (yyval.rule) = katana_new_keyframes_rule(parser, &(yyvsp[-7].string), (yyvsp[-1].keyframeRuleList), (yyvsp[-8].boolean));
    }

    break;

  case 121:

    {
        katana_parser_clear_declarations(parser);
        katana_parser_reset_declarations(parser);
    }

    break;

  case 122:

    {
        (yyval.keyframeRuleList) = katana_new_Keyframe_list(parser);
        katana_parser_resume_error_logging();
    }

    break;

  case 123:

    {
        (yyval.keyframeRuleList) = (yyvsp[-3].keyframeRuleList);
        katana_keyframe_rule_list_add(parser, (yyvsp[-2].keyframe), (yyval.keyframeRuleList));
    }

    break;

  case 124:

    {
        katana_parser_clear_declarations(parser);
        katana_parser_reset_declarations(parser);
        katana_parser_resume_error_logging();
    }

    break;

  case 125:

    {
        (yyval.keyframe) = katana_new_keyframe(parser, (yyvsp[-4].valueList));
    }

    break;

  case 126:

    {
        (yyval.valueList) = katana_new_value_list(parser);
        katana_value_list_add(parser, (yyvsp[-1].value), (yyval.valueList));
    }

    break;

  case 127:

    {
        (yyval.valueList) = (yyvsp[-4].valueList);
        katana_value_list_add(parser, (yyvsp[-1].value), (yyval.valueList));
    }

    break;

  case 128:

    {
        (yyval.value) = katana_new_number_value(parser, (yyvsp[-1].integer), &(yyvsp[0].number), KATANA_VALUE_NUMBER);
    }

    break;

  case 129:

    {
        if (!strcasecmp((yyvsp[0].string).data, "from")) {
            KatanaParserNumber number;
            number.val = 0;
            number.raw = (KatanaParserString){"from", 4};
            (yyval.value) = katana_new_number_value(parser, 1, &number, KATANA_VALUE_NUMBER);
        }
        else if (!strcasecmp((yyvsp[0].string).data, "to")) {
            KatanaParserNumber number;
            number.val = 100;
            number.raw = (KatanaParserString){"to", 4};
            (yyval.value) = katana_new_number_value(parser, 1, &number, KATANA_VALUE_NUMBER);
        }
        else {
            YYERROR;
        }
    }

    break;

  case 130:

    {
        // katana_parser_report_error(parser, parser->lastLocationLabel(), InvalidKeyframeSelectorCSSError);
        katana_parser_clear_declarations(parser);
        katana_parser_reset_declarations(parser);
        katana_parser_report_error(parser, NULL, "InvalidKeyframeSelectorCSSError");
    }

    break;

  case 131:

    {
        katana_start_rule_header(parser, KatanaRuleFontFace);
    }

    break;

  case 132:

    {
        (yyval.rule) = katana_new_font_face(parser);
    }

    break;

  case 133:

    { (yyval.relation) = KatanaSelectorRelationDirectAdjacent; }

    break;

  case 134:

    { (yyval.relation) = KatanaSelectorRelationIndirectAdjacent; }

    break;

  case 135:

    { (yyval.relation) = KatanaSelectorRelationChild; }

    break;

  case 136:

    {
        if (!strcasecmp((yyvsp[-2].string).data, "deep"))
            (yyval.relation) = KatanaSelectorRelationShadowDeep;
        else
            YYERROR;
    }

    break;

  case 138:

    { (yyval.integer) = 1; }

    break;

  case 139:

    { (yyval.integer) = -1; }

    break;

  case 140:

    { (yyval.integer) = 1; }

    break;

  case 141:

    {
        katana_start_declaration(parser);
    }

    break;

  case 142:

    {
        katana_start_rule_header(parser, KatanaRuleStyle);
        katana_start_selector(parser);
    }

    break;

  case 143:

    {
        katana_end_rule_header(parser);
    }

    break;

  case 144:

    {
        katana_end_selector(parser);
    }

    break;

  case 145:

    {
        (yyval.rule) = katana_new_style_rule(parser, (yyvsp[-7].selectorList));
    }

    break;

  case 146:

    {
        katana_start_selector(parser);
    }

    break;

  case 147:

    {
        (yyval.selectorList) = katana_reusable_selector_list(parser);
        katana_selector_list_shink(parser, 0, (yyval.selectorList));
        katana_selector_list_add(parser, katana_sink_floating_selector(parser, (yyvsp[0].selector)), (yyval.selectorList));
    }

    break;

  case 148:

    {
        (yyval.selectorList) = (yyvsp[-5].selectorList);
        katana_selector_list_add(parser, katana_sink_floating_selector(parser, (yyvsp[0].selector)), (yyval.selectorList));
    }

    break;

  case 151:

    {
        (yyval.selector) = (yyvsp[0].selector);
        KatanaSelector * end = (yyval.selector);
        if ( NULL != end ) {
            while (NULL != end->tagHistory)
                end = end->tagHistory;
            end->relation = KatanaSelectorRelationDescendant;
            // if ($1->isContentPseudoElement())
            //     end->setRelationIsAffectedByPseudoContent();
            end->tagHistory = katana_sink_floating_selector(parser, (yyvsp[-2].selector));
        }
    }

    break;

  case 152:

    {
        (yyval.selector) = (yyvsp[0].selector);
        KatanaSelector * end = (yyval.selector);
        if ( NULL != end ) {
            while (NULL != end->tagHistory)
                end = end->tagHistory;
            end->relation = (yyvsp[-1].relation);
            // if ($1->isContentPseudoElement())
            //     end->setRelationIsAffectedByPseudoContent();
            end->tagHistory = katana_sink_floating_selector(parser, (yyvsp[-2].selector));
        }
    }

    break;

  case 153:

    { 
        katana_string_clear(parser, &(yyval.string));
    }

    break;

  case 154:

    {
        (yyval.string) = kKatanaAsteriskString;
    }

    break;

  case 156:

    {
        (yyval.selector) = katana_new_selector(parser);
        (yyval.selector)->match = KatanaSelectorMatchTag;
        (yyval.selector)->tag = katana_new_qualified_name(parser, NULL, &(yyvsp[0].string), &parser->default_namespace);
    }

    break;

  case 157:

    {
        (yyval.selector) = katana_rewrite_specifier_with_Elementname(parser, &(yyvsp[-1].string), (yyvsp[0].selector));
        if (!(yyval.selector))
            YYERROR;
    }

    break;

  case 158:

    {
        (yyval.selector) = katana_rewrite_specifier_with_namespace_if_needed(parser, (yyvsp[0].selector));
        if (!(yyval.selector))
            YYERROR;
    }

    break;

  case 159:

    {
        (yyval.selector) = katana_new_selector(parser);
        (yyval.selector)->match = KatanaSelectorMatchTag;
        (yyval.selector)->tag = katana_new_qualified_name(parser, &(yyvsp[-1].string), &(yyvsp[0].string), &(yyvsp[-1].string));
        // $$ = parser->createFloatingSelectorWithTagName(parser->determineNameInNamespace($1, $2));
        // if (!$$)
        //     YYERROR;
    }

    break;

  case 160:

    {
        // $$ = parser->rewriteSpecifiersWithElementName($1, $2, $3);
        // if (!$$)
        //     YYERROR;
    }

    break;

  case 161:

    {
        // $$ = parser->rewriteSpecifiersWithElementName($1, starAtom, $2);
        // if (!$$)
        //     YYERROR;
    }

    break;

  case 162:

    {
        // FIXME: 标签名是否区分大写
        // if (parser->m_context.isHTMLDocument())
        //     parser->tokenToLowerCase($1);
        (yyval.string) = (yyvsp[0].string);
    }

    break;

  case 163:

    {
        (yyval.string) = kKatanaAsteriskString;
    }

    break;

  case 165:

    {
        (yyval.selector) = katana_rewrite_specifiers(parser, (yyvsp[-1].selector), (yyvsp[0].selector));
    }

    break;

  case 166:

    {
        (yyval.selector) = katana_new_selector(parser);
        (yyval.selector)->match =KatanaSelectorMatchId;
        // if (isQuirksModeBehavior(parser->m_context.mode()))
            // parser->tokenToLowerCase($1);
        katana_selector_set_value(parser, (yyval.selector), &(yyvsp[0].string));
    }

    break;

  case 167:

    {
        if ((yyvsp[0].string).data[0] >= '0' && (yyvsp[0].string).data[0] <= '9') {
            YYERROR;
        } else {
            (yyval.selector) = katana_new_selector(parser);
            (yyval.selector)->match =KatanaSelectorMatchId;
            // if (isQuirksModeBehavior(parser->m_context.mode()))
                // parser->tokenToLowerCase($1);
            katana_selector_set_value(parser, (yyval.selector), &(yyvsp[0].string));
        }
    }

    break;

  case 171:

    {
        (yyval.selector) = katana_new_selector(parser);
        (yyval.selector)->match = KatanaSelectorMatchClass;
        // if (isQuirksModeBehavior(parser->m_context.mode()))
        //     parser->tokenToLowerCase($2);
        katana_selector_set_value(parser, (yyval.selector), &(yyvsp[0].string));
    }

    break;

  case 172:

    {
        // if (parser->m_context.isHTMLDocument())
        //     parser->tokenToLowerCase($1);
        (yyval.string) = (yyvsp[-1].string);
    }

    break;

  case 173:

    {
        KatanaAttributeMatchType attrMatchType = KatanaAttributeMatchTypeCaseSensitive;
        if (!katana_parse_attribute_match_type(parser, attrMatchType, &(yyvsp[-1].string)))
            YYERROR;
        (yyval.attributeMatchType) = attrMatchType;
    }

    break;

  case 175:

    { (yyval.attributeMatchType) = KatanaAttributeMatchTypeCaseSensitive; }

    break;

  case 176:

    {
        (yyval.selector) = katana_new_selector(parser);
        (yyval.selector)->data->attribute = katana_new_qualified_name(parser, NULL, &(yyvsp[-1].string), NULL);
        (yyval.selector)->data->bits.attributeMatchType = KatanaAttributeMatchTypeCaseSensitive;
        (yyval.selector)->match = KatanaSelectorMatchAttributeSet;
    }

    break;

  case 177:

    {
        (yyval.selector) = katana_new_selector(parser);
        (yyval.selector)->data->attribute = katana_new_qualified_name(parser, NULL, &(yyvsp[-6].string), NULL);
        (yyval.selector)->data->bits.attributeMatchType = (yyvsp[-1].attributeMatchType);
        (yyval.selector)->match = (yyvsp[-5].integer);
        katana_selector_set_value(parser, (yyval.selector), &(yyvsp[-3].string));
    }

    break;

  case 178:

    {
        // $$ = parser->createFloatingSelector();
        // $$->setAttribute(parser->determineNameInNamespace($3, $4), CSSSelector::CaseSensitive);
        // $$->setMatch(CSSSelector::Set);
    }

    break;

  case 179:

    {
        // $$ = parser->createFloatingSelector();
        // $$->setAttribute(parser->determineNameInNamespace($3, $4), $9);
        // $$->setMatch((CSSSelector::Match)$5);
        // $$->setValue($7);
    }

    break;

  case 180:

    {
        YYERROR;
    }

    break;

  case 181:

    {
        (yyval.integer) = KatanaSelectorMatchAttributeExact;
    }

    break;

  case 182:

    {
        (yyval.integer) = KatanaSelectorMatchAttributeList;
    }

    break;

  case 183:

    {
        (yyval.integer) = KatanaSelectorMatchAttributeHyphen;
    }

    break;

  case 184:

    {
        (yyval.integer) = KatanaSelectorMatchAttributeBegin;
    }

    break;

  case 185:

    {
        (yyval.integer) = KatanaSelectorMatchAttributeEnd;
    }

    break;

  case 186:

    {
        (yyval.integer) = KatanaSelectorMatchAttributeContain;
    }

    break;

  case 189:

    {
        if (katana_string_is_function(&(yyvsp[0].string)))
            YYERROR;
        (yyval.selector) = katana_new_selector(parser);
        (yyval.selector)->match = KatanaSelectorMatchPseudoClass;
        katana_string_to_lowercase(parser, &(yyvsp[0].string));
        katana_selector_set_value(parser, (yyval.selector), &(yyvsp[0].string));
        katana_selector_extract_pseudo_type((yyval.selector));
        // if ($$->pseudo == KatanaSelectorPseudoUnknown) {
        //     katana_parser_report_error(parser, $2, InvalidSelectorPseudoCSSError);
        //     YYERROR;
    }

    break;

  case 190:

    {
        if (katana_string_is_function(&(yyvsp[0].string)))
            YYERROR;
        (yyval.selector) = katana_new_selector(parser);
        (yyval.selector)->match = KatanaSelectorMatchPseudoElement;
        katana_string_to_lowercase(parser, &(yyvsp[0].string));
        katana_selector_set_value(parser, (yyval.selector), &(yyvsp[0].string));
        katana_selector_extract_pseudo_type((yyval.selector));
        // FIXME: This call is needed to force selector to compute the pseudoType early enough.
        // CSSSelector::PseudoType type = $$->pseudoType();
        // if (type == CSSSelector::PseudoUnknown) {
        //     katana_parser_report_error(parser, $3, InvalidSelectorPseudoCSSError);
        //     YYERROR;
    }

    break;

  case 191:

    {
        YYERROR;
    }

    break;

  case 192:

    {
        (yyval.selector) = katana_new_selector(parser);
        (yyval.selector)->match = KatanaSelectorMatchPseudoClass;
        katana_selector_set_argument(parser, (yyval.selector), &(yyvsp[-2].string));
        katana_selector_set_value(parser, (yyval.selector), &(yyvsp[-4].string));
        katana_selector_extract_pseudo_type((yyval.selector));
        // CSSSelector::PseudoType type = $$->pseudoType();
        // if (type == CSSSelector::PseudoUnknown)
        //     YYERROR;
    }

    break;

  case 193:

    {
        (yyval.selector) = katana_new_selector(parser);
        (yyval.selector)->match = KatanaSelectorMatchPseudoClass;
        katana_selector_set_argument_with_number(parser, (yyval.selector), (yyvsp[-3].integer), &(yyvsp[-2].number));
        katana_selector_set_value(parser, (yyval.selector), &(yyvsp[-5].string));
        katana_selector_extract_pseudo_type((yyval.selector));
    //     $$ = parser->createFloatingSelector();
    //     $$->setMatch(CSSSelector::PseudoClass);
    //     $$->setArgument(AtomicString::number($4 * $5));
    //     $$->setValue($2);
    //     CSSSelector::PseudoType type = $$->pseudoType();
    //     if (type == CSSSelector::PseudoUnknown)
            // YYERROR;
    }

    break;

  case 194:

    {
        (yyval.selector) = katana_new_selector(parser);
        (yyval.selector)->match = KatanaSelectorMatchPseudoClass;
        katana_selector_set_argument(parser, (yyval.selector), &(yyvsp[-2].string));
        
        katana_string_to_lowercase(parser, &(yyvsp[-4].string));
        katana_selector_set_value(parser, (yyval.selector), &(yyvsp[-4].string));
        katana_selector_extract_pseudo_type((yyval.selector));
        // CSSSelector::PseudoType type = $$->pseudoType();
        // if (type == CSSSelector::PseudoUnknown)
        //     YYERROR;
        // else if (type == CSSSelector::PseudoNthChild ||
        //          type == CSSSelector::PseudoNthOfType ||
        //          type == CSSSelector::PseudoNthLastChild ||
        //          type == CSSSelector::PseudoNthLastOfType) {
        //     if (!isValidNthToken($4))
        //         YYERROR;
        // }
    }

    break;

  case 195:

    {
        YYERROR;
    }

    break;

  case 196:

    {
        if (!katana_selector_is_simple(parser, (yyvsp[-2].selector)))
            YYERROR;
        else {
            (yyval.selector) = katana_new_selector(parser);
            (yyval.selector)->match = KatanaSelectorMatchPseudoClass;
            (yyval.selector)->pseudo = KatanaPseudoNot;

            KatanaArray* array = katana_new_array(parser);
            katana_selector_list_add(parser, katana_sink_floating_selector(parser, (yyvsp[-2].selector)), array);
            katana_adopt_selector_list(parser, array, (yyval.selector));

            katana_string_to_lowercase(parser, &(yyvsp[-4].string));
            katana_selector_set_value(parser, (yyval.selector), &(yyvsp[-4].string));
        }
    }

    break;

  case 197:

    {
        YYERROR;
    }

    break;

  case 198:

    {
        YYERROR;
    }

    break;

  case 199:

    {
        YYERROR;
    }

    break;

  case 201:

    { (yyval.boolean) = false; }

    break;

  case 203:

    {
        (yyval.boolean) = (yyvsp[-1].boolean) || (yyvsp[0].boolean);
    }

    break;

  case 205:

    {
        katana_start_declaration(parser);
        (yyval.boolean) = (yyvsp[-2].boolean);
    }

    break;

  case 206:

    {
        katana_start_declaration(parser);
        (yyval.boolean) = (yyvsp[-3].boolean) || (yyvsp[-2].boolean);
    }

    break;

  case 207:

    {
        (yyval.boolean) = false;
        bool isPropertyParsed = false;
        // unsigned int oldParsedProperties = parser->parsedProperties->length;
        (yyval.boolean) = katana_new_declaration(parser, &(yyvsp[-5].string), (yyvsp[0].boolean), (yyvsp[-1].valueList));
        if (!(yyval.boolean)) {
            // parser->rollbackLastProperties(parser->m_parsedProperties.size() - oldParsedProperties);
            katana_parser_report_error(parser, (yyvsp[-2].location), "InvalidPropertyValueCSSError");
        } else {
            isPropertyParsed = true;
        }
        katana_end_declaration(parser, (yyvsp[0].boolean), isPropertyParsed);
    }

    break;

  case 208:

    {
        /* When we encounter something like p {color: red !important fail;} we should drop the declaration */
        katana_parser_report_error(parser, (yyvsp[-4].location), "InvalidPropertyValueCSSError");
        katana_end_declaration(parser, false, false);
        (yyval.boolean) = false;
    }

    break;

  case 209:

    {
        katana_parser_report_error(parser, (yyvsp[-2].location), "InvalidPropertyValueCSSError");
        katana_end_declaration(parser, false, false);
        (yyval.boolean) = false;
    }

    break;

  case 210:

    {
        katana_parser_report_error(parser, (yyvsp[-1].location), "PropertyDeclarationCSSError");
        katana_end_declaration(parser, false, false);
        (yyval.boolean) = false;
    }

    break;

  case 211:

    {
        katana_parser_report_error(parser, (yyvsp[-1].location), "PropertyDeclarationCSSError");
        (yyval.boolean) = false;
    }

    break;

  case 212:

    {
        // $$ = cssPropertyID($2);
        // parser->setCurrentProperty($$);
        // if ($$ == CSSPropertyInvalid)
        //     katana_parser_report_error(parser, $1, InvalidPropertyCSSError);
        (yyval.string) = (yyvsp[-1].string);
        katana_set_current_declaration(parser, &(yyval.string));
    }

    break;

  case 213:

    { (yyval.boolean) = true; }

    break;

  case 214:

    { (yyval.boolean) = false; }

    break;

  case 215:

    {
        (yyval.valueList) = katana_new_value_list(parser);
        katana_value_list_add(parser, katana_new_ident_value(parser, &(yyvsp[-1].string)), (yyval.valueList));
    }

    break;

  case 216:

    {
        (yyval.valueList) = (yyvsp[-2].valueList);
        katana_value_list_add(parser, katana_new_ident_value(parser, &(yyvsp[-1].string)), (yyval.valueList));
    }

    break;

  case 217:

    {
        (yyval.value) = katana_new_list_value(parser, NULL);
    }

    break;

  case 218:

    {
        (yyval.value) = katana_new_list_value(parser, (yyvsp[-1].valueList));
    }

    break;

  case 219:

    {
        YYERROR;
    }

    break;

  case 220:

    {
        (yyval.valueList) = katana_new_value_list(parser);
        katana_value_list_add(parser, (yyvsp[0].value), (yyval.valueList));
    }

    break;

  case 221:

    {
        (yyval.valueList) = (yyvsp[-2].valueList);
        katana_value_list_add(parser, katana_new_operator_value(parser, (yyvsp[-1].character)), (yyval.valueList));
        katana_value_list_add(parser, (yyvsp[0].value), (yyval.valueList));
    }

    break;

  case 222:

    {
        (yyval.valueList) = (yyvsp[-1].valueList);
        katana_value_list_add(parser, (yyvsp[0].value), (yyval.valueList));
    }

    break;

  case 223:

    {
        katana_parser_report_error(parser, (yyvsp[-1].location), "PropertyDeclarationCSSError");
    }

    break;

  case 224:

    {
        (yyval.character) = '/';
    }

    break;

  case 225:

    {
        (yyval.character) = ',';
    }

    break;

  case 226:

    {
        (yyval.character) = '=';
    }

    break;

  case 228:

    {
      (yyval.value) = (yyvsp[-1].value);
      // $$->fValue *= $1;
      katana_value_set_sign(parser, (yyval.value), (yyvsp[-2].integer));

  }

    break;

  case 229:

    { (yyval.value) = katana_new_value(parser); (yyval.value)->id = KatanaValueInvalid; (yyval.value)->isInt = false; katana_value_set_string(parser, (yyval.value), &(yyvsp[-1].string)); (yyval.value)->unit = KATANA_VALUE_STRING; }

    break;

  case 230:

    { (yyval.value) = katana_new_ident_value(parser, &(yyvsp[-1].string)); }

    break;

  case 231:

    { (yyval.value) = katana_new_value(parser); (yyval.value)->id = KatanaValueInvalid; katana_value_set_string(parser, (yyval.value), &(yyvsp[-1].string)); (yyval.value)->isInt = false; (yyval.value)->unit = KATANA_VALUE_DIMENSION; }

    break;

  case 232:

    { (yyval.value) = katana_new_value(parser); (yyval.value)->id = KatanaValueInvalid; katana_value_set_string(parser, (yyval.value), &(yyvsp[-1].string)); (yyval.value)->isInt = false; (yyval.value)->unit = KATANA_VALUE_DIMENSION; }

    break;

  case 233:

    { (yyval.value) = katana_new_value(parser); (yyval.value)->id = KatanaValueInvalid; katana_value_set_string(parser, (yyval.value), &(yyvsp[-1].string)); (yyval.value)->isInt = false; (yyval.value)->unit = KATANA_VALUE_URI; }

    break;

  case 234:

    { (yyval.value) = katana_new_value(parser); (yyval.value)->id = KatanaValueInvalid; katana_value_set_string(parser, (yyval.value), &(yyvsp[-1].string)); (yyval.value)->isInt = false; (yyval.value)->unit = KATANA_VALUE_UNICODE_RANGE; }

    break;

  case 235:

    { (yyval.value) = katana_new_value(parser); (yyval.value)->id = KatanaValueInvalid; katana_value_set_string(parser, (yyval.value), &(yyvsp[-1].string)); (yyval.value)->isInt = false; (yyval.value)->unit = KATANA_VALUE_PARSER_HEXCOLOR; }

    break;

  case 236:

    { (yyval.value) = katana_new_value(parser); (yyval.value)->id = KatanaValueInvalid; (yyval.value)->string = "#"; (yyval.value)->isInt = false; (yyval.value)->unit = KATANA_VALUE_PARSER_HEXCOLOR; }

    break;

  case 239:

    { /* Handle width: %; */ (yyval.value) = katana_new_value(parser); (yyval.value)->id = KatanaValueInvalid; (yyval.value)->isInt = false; (yyval.value)->unit = 0; }

    break;

  case 241:

    { (yyval.value) = katana_new_number_value(parser, 1, &(yyvsp[0].number), KATANA_VALUE_NUMBER); (yyval.value)->isInt = true; }

    break;

  case 242:

    { (yyval.value) = katana_new_number_value(parser, 1, &(yyvsp[0].number), KATANA_VALUE_NUMBER); }

    break;

  case 243:

    { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_PERCENTAGE); }

    break;

  case 244:

    { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_PX); }

    break;

  case 245:

    { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_CM); }

    break;

  case 246:

    { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_MM); }

    break;

  case 247:

    { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_IN); }

    break;

  case 248:

    { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_PT); }

    break;

  case 249:

    { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_PC); }

    break;

  case 250:

    { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_DEG); }

    break;

  case 251:

    { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_RAD); }

    break;

  case 252:

    { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_GRAD); }

    break;

  case 253:

    { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_TURN); }

    break;

  case 254:

    { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_MS); }

    break;

  case 255:

    { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_S); }

    break;

  case 256:

    { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_HZ); }

    break;

  case 257:

    { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_KHZ); }

    break;

  case 258:

    { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_EMS); }

    break;

  case 259:

    { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_PARSER_Q_EMS); }

    break;

  case 260:

    { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_EXS); }

    break;

  case 261:

    {  (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_REMS); /* if (parser->m_styleSheet) parser->m_styleSheet->parserSetUsesRemUnits(true); */ }

    break;

  case 262:

    { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_CHS); }

    break;

  case 263:

    { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_VW); }

    break;

  case 264:

    { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_VH); }

    break;

  case 265:

    { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_VMIN); }

    break;

  case 266:

    { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_VMAX); }

    break;

  case 267:

    { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_DPPX); }

    break;

  case 268:

    { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_DPI); }

    break;

  case 269:

    { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_DPCM); }

    break;

  case 270:

    { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_FR); }

    break;

  case 271:

    {
        (yyval.value) = katana_new_function_value(parser, &(yyvsp[-3].string), (yyvsp[-1].valueList));
    }

    break;

  case 272:

    {
        (yyval.value) = katana_new_function_value(parser, &(yyvsp[-2].string), NULL);
    }

    break;

  case 273:

    {
        YYERROR;
    }

    break;

  case 275:

    { (yyval.value) = (yyvsp[0].value); (yyval.value)->fValue *= (yyvsp[-1].integer); }

    break;

  case 276:

    {
        (yyval.character) = '+';
    }

    break;

  case 277:

    {
        (yyval.character) = '-';
    }

    break;

  case 278:

    {
        (yyval.character) = '*';
    }

    break;

  case 279:

    {
        (yyval.character) = '/';
    }

    break;

  case 282:

    {
        (yyval.valueList) = (yyvsp[-2].valueList);
        katana_value_list_insert(parser, katana_new_operator_value(parser, '('), 0, (yyval.valueList));
        katana_new_operator_value(parser, ')');
        katana_value_list_add(parser, katana_new_operator_value(parser, ')'), (yyval.valueList));
    }

    break;

  case 283:

    {
        YYERROR;
    }

    break;

  case 284:

    {
        (yyval.valueList) = katana_new_value_list(parser);
        katana_value_list_add(parser, (yyvsp[0].value), (yyval.valueList));
    }

    break;

  case 285:

    {
        (yyval.valueList) = (yyvsp[-2].valueList);
        katana_value_list_add(parser, katana_new_operator_value(parser, (yyvsp[-1].character)), (yyval.valueList));
        katana_value_list_add(parser, (yyvsp[0].value), (yyval.valueList));
    }

    break;

  case 286:

    {
        (yyval.valueList) = (yyvsp[-2].valueList);
        katana_value_list_add(parser, katana_new_operator_value(parser, (yyvsp[-1].character)), (yyval.valueList));
        katana_value_list_steal_values(parser, (yyvsp[0].valueList), (yyval.valueList));
    }

    break;

  case 288:

    {
        (yyval.value) = katana_new_function_value(parser, &(yyvsp[-4].string), (yyvsp[-2].valueList));
    }

    break;

  case 289:

    {
        YYERROR;
    }

    break;

  case 292:

    {
        katana_parser_report_error(parser, (yyvsp[-1].location), "InvalidRuleCSSError");
    }

    break;

  case 297:

    {
        // katana_parser_report_error(parser, $4, InvalidSupportsConditionCSSError);
        // parser->popSupportsRuleData();
    }

    break;

  case 299:

    {
        // katana_parser_resume_error_logging();
        // katana_parser_report_error(parser, $1, "InvalidRuleCSSError regular_invalid_at_rule_header");
    }

    break;

  case 300:

    {
        katana_parser_report_error(parser, (yyvsp[-3].location), "InvalidRuleCSSError invalid_rule");
    }

    break;

  case 304:

    {
        katana_parser_report_error(parser, (yyvsp[-2].location), "InvalidRuleCSSError invalid_rule_header");
    }

    break;

  case 307:

    {
        katana_end_invalid_rule_header(parser);
   }

    break;

  case 308:

    {
        katana_parser_report_error(parser, parser->position, "invalidBlockHit");
    }

    break;

  case 313:

    {
        (yyval.location) = katana_parser_current_location(parser, &yylloc);
    }

    break;

  case 314:

    {
        // parser->setLocationLabel(parser->currentLocation());
    }

    break;



      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;
  *++yylsp = yyloc;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (&yylloc, scanner, parser, YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = (char *) YYSTACK_ALLOC (yymsg_alloc);
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (&yylloc, scanner, parser, yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }

  yyerror_range[1] = yylloc;

  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval, &yylloc, scanner, parser);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ /* DISABLES CODE */ (0))
     goto yyerrorlab;

  yyerror_range[1] = yylsp[1-yylen];
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYTERROR;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;

      yyerror_range[1] = *yylsp;
      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp, yylsp, scanner, parser);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  yyerror_range[2] = yylloc;
  /* Using YYLLOC is tempting, but would change the location of
     the lookahead.  YYLOC is available though.  */
  YYLLOC_DEFAULT (yyloc, yyerror_range, 2);
  *++yylsp = yyloc;

  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (&yylloc, scanner, parser, YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval, &yylloc, scanner, parser);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[*yyssp], yyvsp, yylsp, scanner, parser);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}

