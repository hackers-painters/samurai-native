//
//     ____    _                        __     _      _____
//    / ___\  /_\     /\/\    /\ /\    /__\   /_\     \_   \
//    \ \    //_\\   /    \  / / \ \  / \//  //_\\     / /\/
//  /\_\ \  /  _  \ / /\/\ \ \ \_/ / / _  \ /  _  \ /\/ /_
//  \____/  \_/ \_/ \/    \/  \___/  \/ \_/ \_/ \_/ \____/
//
//	Copyright Samurai development team and other contributors
//
//	http://www.samurai-framework.com
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//

#import "Samurai_HtmlUserAgent.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_CSSParser.h"
#import "Samurai_CSSStyleSheet.h"

#import "Samurai_HtmlElementArticle.h"
#import "Samurai_HtmlElementAside.h"
#import "Samurai_HtmlElementBlockquote.h"
#import "Samurai_HtmlElementBody.h"
#import "Samurai_HtmlElementBr.h"
#import "Samurai_HtmlElementButton.h"
#import "Samurai_HtmlElementCanvas.h"
#import "Samurai_HtmlElementCaption.h"
#import "Samurai_HtmlElementCode.h"
#import "Samurai_HtmlElementCol.h"
#import "Samurai_HtmlElementColGroup.h"
#import "Samurai_HtmlElementDatalist.h"
#import "Samurai_HtmlElementDd.h"
#import "Samurai_HtmlElementDir.h"
#import "Samurai_HtmlElementDiv.h"
#import "Samurai_HtmlElementDl.h"
#import "Samurai_HtmlElementDt.h"
#import "Samurai_HtmlElementElement.h"
#import "Samurai_HtmlElementFieldset.h"
#import "Samurai_HtmlElementFooter.h"
#import "Samurai_HtmlElementForm.h"
#import "Samurai_HtmlElementH1.h"
#import "Samurai_HtmlElementH2.h"
#import "Samurai_HtmlElementH3.h"
#import "Samurai_HtmlElementH4.h"
#import "Samurai_HtmlElementH5.h"
#import "Samurai_HtmlElementH6.h"
#import "Samurai_HtmlElementHeader.h"
#import "Samurai_HtmlElementHgroup.h"
#import "Samurai_HtmlElementHr.h"
#import "Samurai_HtmlElementHtml.h"
#import "Samurai_HtmlElementImg.h"
#import "Samurai_HtmlElementInputButton.h"
#import "Samurai_HtmlElementInputCheckbox.h"
#import "Samurai_HtmlElementInputFile.h"
#import "Samurai_HtmlElementInputHidden.h"
#import "Samurai_HtmlElementInputImage.h"
#import "Samurai_HtmlElementInputPassword.h"
#import "Samurai_HtmlElementInputRadio.h"
#import "Samurai_HtmlElementInputReset.h"
#import "Samurai_HtmlElementInputSubmit.h"
#import "Samurai_HtmlElementInputText.h"
#import "Samurai_HtmlElementLabel.h"
#import "Samurai_HtmlElementLegend.h"
#import "Samurai_HtmlElementLi.h"
#import "Samurai_HtmlElementMain.h"
#import "Samurai_HtmlElementMeter.h"
#import "Samurai_HtmlElementNav.h"
#import "Samurai_HtmlElementOl.h"
#import "Samurai_HtmlElementOutput.h"
#import "Samurai_HtmlElementP.h"
#import "Samurai_HtmlElementPre.h"
#import "Samurai_HtmlElementProgress.h"
#import "Samurai_HtmlElementSection.h"
#import "Samurai_HtmlElementSelect.h"
#import "Samurai_HtmlElementSpan.h"
#import "Samurai_HtmlElementSub.h"
#import "Samurai_HtmlElementSup.h"
#import "Samurai_HtmlElementTable.h"
#import "Samurai_HtmlElementTbody.h"
#import "Samurai_HtmlElementTd.h"
#import "Samurai_HtmlElementTemplate.h"
#import "Samurai_HtmlElementText.h"
#import "Samurai_HtmlElementTextarea.h"
#import "Samurai_HtmlElementTfoot.h"
#import "Samurai_HtmlElementTh.h"
#import "Samurai_HtmlElementThead.h"
#import "Samurai_HtmlElementTime.h"
#import "Samurai_HtmlElementTr.h"
#import "Samurai_HtmlElementUl.h"
#import "Samurai_HtmlElementViewport.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiHtmlUserAgent

@def_prop_assign( CGFloat,					thinSize );
@def_prop_assign( CGFloat,					mediumSize );
@def_prop_assign( CGFloat,					thickSize );

@def_prop_strong( UIFont *,					defaultFont );
@def_prop_strong( NSMutableDictionary *,	defaultElements );
@def_prop_strong( NSMutableArray *,			defaultStyleSheets );
@def_prop_strong( NSMutableDictionary *,	defaultCSSValue );
@def_prop_strong( NSMutableArray *,			defaultCSSInherition );
@def_prop_strong( NSMutableArray *,			defaultDOMAttributedStyle );

@def_singleton( SamuraiHtmlUserAgent )

+ (void)load
{
	[SamuraiHtmlUserAgent sharedInstance];
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.thinSize		= 1.0f;
		self.mediumSize		= 2.0f;
		self.thickSize		= 3.0f;
		self.defaultFont	= [UIFont systemFontOfSize:14.0f];

		[self loadStyleSheets];
		[self loadElements];
		[self loadCSSValue];
		[self loadCSSInheration];
		[self loadDOMAttributedStyle];
	}
	return self;
}

- (void)dealloc
{
	self.defaultFont = nil;
	self.defaultElements = nil;
	self.defaultStyleSheets = nil;
	self.defaultCSSValue = nil;
	self.defaultCSSInherition = nil;
	self.defaultDOMAttributedStyle = nil;
}

- (void)loadStyleSheets
{
	self.defaultStyleSheets = [NSMutableArray array];
	
	SamuraiCSSStyleSheet * styleSheet;
 
	styleSheet = [SamuraiCSSStyleSheet resourceAtPath:@"html.css"];
	
	if ( styleSheet && [styleSheet parse] )
	{
		[self.defaultStyleSheets addObject:styleSheet];
	}
	
	styleSheet = [SamuraiCSSStyleSheet resourceAtPath:@"html+native.css"];
	
	if ( styleSheet && [styleSheet parse] )
	{
		[self.defaultStyleSheets addObject:styleSheet];
	}

	styleSheet = [SamuraiCSSStyleSheet resourceAtPath:@"html+samurai.css"];
	
	if ( styleSheet && [styleSheet parse] )
	{
		[self.defaultStyleSheets addObject:styleSheet];
	}
}

- (void)loadElements
{
	self.defaultElements = [NSMutableDictionary dictionary];
	
	self.defaultElements[@"html"] = [SamuraiHtmlElementHtml class];
}

- (void)loadCSSValue
{
	self.defaultCSSValue = [NSMutableDictionary dictionary];
	
//	self.defaultCSSValue[@"animation"]					= @"none 0 ease 0 1 normal";
//	self.defaultCSSValue[@"animation-name"]				= @"none";
//	self.defaultCSSValue[@"animation-duration"]			= @"0";
//	self.defaultCSSValue[@"animation-timing-function"]	= @"ease";
//	self.defaultCSSValue[@"animation-delay"]			= @"0";
//	self.defaultCSSValue[@"animation-iteration-count"]	= @"1";
//	self.defaultCSSValue[@"animation-direction"]		= @"normal";
//	self.defaultCSSValue[@"animation-play-state"]		= @"running";
//	self.defaultCSSValue[@"animation-fill-mode"]		= @"none";
	
//	self.defaultCSSValue[@"background-attachment"]		= @"scroll";
//	self.defaultCSSValue[@"background-color"]			= @"transparent";
//	self.defaultCSSValue[@"background-image"]			= @"none";
//	self.defaultCSSValue[@"background-position"]		= @"0% 0%";
//	self.defaultCSSValue[@"background-repeat"]			= @"repeat";
//	self.defaultCSSValue[@"background-clip"]			= @"border-box";
//	self.defaultCSSValue[@"background-origin"]			= @"padding-box";
//	self.defaultCSSValue[@"background-size"]			= @"auto";

//	self.defaultCSSValue[@"border-width"]				= @"medium";
//	self.defaultCSSValue[@"border-top-width"]			= @"medium";
//	self.defaultCSSValue[@"border-left-width"]			= @"medium";
//	self.defaultCSSValue[@"border-right-width"]			= @"medium";
//	self.defaultCSSValue[@"border-bottom-width"]		= @"medium";
	
//	self.defaultCSSValue[@"border-image"]				= @"none 100% 1 0 stretch";
//	self.defaultCSSValue[@"border-image-outset"]		= @"0";
//	self.defaultCSSValue[@"border-image-repeat"]		= @"stretch";
//	self.defaultCSSValue[@"border-image-slice"]			= @"100%";
//	self.defaultCSSValue[@"border-image-source"]		= @"none";
//	self.defaultCSSValue[@"border-image-width"]			= @"none";

	self.defaultCSSValue[@"border-radius"]				= @"0";

	self.defaultCSSValue[@"box-shadow"]					= @"none";

//	self.defaultCSSValue[@"outline"]					= @"invert none medium";
//	self.defaultCSSValue[@"outline-color"]				= @"invert";
//	self.defaultCSSValue[@"outline-style"]				= @"none";
//	self.defaultCSSValue[@"outline-width"]				= @"medium";

//	self.defaultCSSValue[@"overflow-x"]					= @"visible";
//	self.defaultCSSValue[@"overflow-y"]					= @"visible";
//	self.defaultCSSValue[@"overflow-style"]				= @"auto";
//	self.defaultCSSValue[@"rotation"]					= @"0";
//	self.defaultCSSValue[@"rotation-point"]				= @"50% 50%";

	self.defaultCSSValue[@"opacity"]					= @"1";

	self.defaultCSSValue[@"width"]						= @"auto";
	self.defaultCSSValue[@"height"]						= @"auto";
	self.defaultCSSValue[@"max-width"]					= @"none";
	self.defaultCSSValue[@"max-height"]					= @"none";
	self.defaultCSSValue[@"min-width"]					= @"none";
	self.defaultCSSValue[@"min-height"]					= @"none";

//	self.defaultCSSValue[@"box-align"]					= @"stretch";
//	self.defaultCSSValue[@"box-direction"]				= @"normal";
//	self.defaultCSSValue[@"box-flex"]					= @"0.0";
//	self.defaultCSSValue[@"box-flex-group"]				= @"1";
//	self.defaultCSSValue[@"box-lines"]					= @"single";
//	self.defaultCSSValue[@"box-ordinal-group"]			= @"1";
//	self.defaultCSSValue[@"box-orient"]					= @"inline-axis";
//	self.defaultCSSValue[@"box-pack"]					= @"start";

	self.defaultCSSValue[@"font-size"]					= @"medium";
	self.defaultCSSValue[@"font-size-adjust"]			= @"none";
	self.defaultCSSValue[@"font-stretch"]				= @"normal";
	self.defaultCSSValue[@"font-style"]					= @"normal";
	self.defaultCSSValue[@"font-variant"]				= @"normal";
	self.defaultCSSValue[@"font-weight"]				= @"normal";
	
//	self.defaultCSSValue[@"content"]					= @"normal";
//	self.defaultCSSValue[@"counter-increment"]			= @"none";
//	self.defaultCSSValue[@"counter-reset"]				= @"none";
	
//	self.defaultCSSValue[@"grid-columns"]				= @"none";
//	self.defaultCSSValue[@"grid-rows"]					= @"none";
	
//	self.defaultCSSValue[@"target"]						= @"current window above";
//	self.defaultCSSValue[@"target-name"]				= @"current";
//	self.defaultCSSValue[@"target-new"]					= @"window";
//	self.defaultCSSValue[@"target-position"]			= @"above";
	
//	self.defaultCSSValue[@"list-style"]					= @"disc outside none";
//	self.defaultCSSValue[@"list-style-image"]			= @"none";
//	self.defaultCSSValue[@"list-style-position"]		= @"outside";
//	self.defaultCSSValue[@"list-style-type"]			= @"disc";
	
//	self.defaultCSSValue[@"margin"]						= @"0";
//	self.defaultCSSValue[@"margin-top"]					= @"0";
//	self.defaultCSSValue[@"margin-left"]				= @"0";
//	self.defaultCSSValue[@"margin-right"]				= @"0";
//	self.defaultCSSValue[@"margin-bottom"]				= @"0";

//	self.defaultCSSValue[@"column-count"]				= @"auto";
//	self.defaultCSSValue[@"column-fill"]				= @"balance";
//	self.defaultCSSValue[@"column-gap"]					= @"normal";
//	self.defaultCSSValue[@"column-rule"]				= @"medium none black";
//	self.defaultCSSValue[@"column-rule-color"]			= @"black";
//	self.defaultCSSValue[@"column-rule-style"]			= @"none";
//	self.defaultCSSValue[@"column-rule-width"]			= @"medium";
//	self.defaultCSSValue[@"column-span"]				= @"1";
//	self.defaultCSSValue[@"column-width"]				= @"auto";
//	self.defaultCSSValue[@"columns"]					= @"auto auto";

//	self.defaultCSSValue[@"padding"]					= @"0";
//	self.defaultCSSValue[@"padding-top"]				= @"0";
//	self.defaultCSSValue[@"padding-left"]				= @"0";
//	self.defaultCSSValue[@"padding-right"]				= @"0";
//	self.defaultCSSValue[@"padding-bottom"]				= @"0";

//	self.defaultCSSValue[@"top"]						= @"auto";
//	self.defaultCSSValue[@"left"]						= @"auto";
//	self.defaultCSSValue[@"right"]						= @"auto";
//	self.defaultCSSValue[@"bottom"]						= @"auto";

	self.defaultCSSValue[@"clear"]						= @"none";
	self.defaultCSSValue[@"clip"]						= @"auto";
	self.defaultCSSValue[@"cursor"]						= @"auto";
	self.defaultCSSValue[@"display"]					= @"inline";
	self.defaultCSSValue[@"float"]						= @"none";
	self.defaultCSSValue[@"overflow"]					= @"visible";
	self.defaultCSSValue[@"position"]					= @"static";
	self.defaultCSSValue[@"vertical-align"]				= @"baseline";
	self.defaultCSSValue[@"visibility"]					= @"visible";
	self.defaultCSSValue[@"z-index"]					= @"auto";
	
	self.defaultCSSValue[@"border-collapse"]			= @"separate";
//	self.defaultCSSValue[@"caption-side"]				= @"top";
//	self.defaultCSSValue[@"empty-cells"]				= @"show";
//	self.defaultCSSValue[@"table-layout"]				= @"auto";
	
//	self.defaultCSSValue[@"direction"]					= @"ltr";
//	self.defaultCSSValue[@"letter-spacing"]				= @"normal";
//	self.defaultCSSValue[@"line-height"]				= @"normal";
	self.defaultCSSValue[@"text-align"]					= @"left";
	self.defaultCSSValue[@"text-decoration"]			= @"none";
	self.defaultCSSValue[@"text-transform"]				= @"none";
//	self.defaultCSSValue[@"white-space"]				= @"normal";
//	self.defaultCSSValue[@"word-spacing"]				= @"normal";
//	self.defaultCSSValue[@"hanging-punctuation"]		= @"none";
//	self.defaultCSSValue[@"punctuation-trim"]			= @"none";
//	self.defaultCSSValue[@"text-emphasis"]				= @"none";
//	self.defaultCSSValue[@"text-justify"]				= @"auto";
//	self.defaultCSSValue[@"text-outline"]				= @"none";
//	self.defaultCSSValue[@"text-overflow"]				= @"clip";
//	self.defaultCSSValue[@"text-shadow"]				= @"none";
	self.defaultCSSValue[@"text-wrap"]					= @"normal";
	self.defaultCSSValue[@"word-break"]					= @"normal";
	self.defaultCSSValue[@"word-wrap"]					= @"normal";
	
//	self.defaultCSSValue[@"transform"]					= @"none";
//	self.defaultCSSValue[@"transform-origin"]			= @"50% 50% 0";
//	self.defaultCSSValue[@"transform-style"]			= @"flat";
//	self.defaultCSSValue[@"perspective"]				= @"none";
//	self.defaultCSSValue[@"perspective-origin"]			= @"50% 50%";
//	self.defaultCSSValue[@"backface-visibility"]		= @"visible";
	
//	self.defaultCSSValue[@"transition"]					= @"all 0 ease 0";
//	self.defaultCSSValue[@"transition-property"]		= @"all";
//	self.defaultCSSValue[@"transition-duration"]		= @"0";
//	self.defaultCSSValue[@"transition-timing-function"]	= @"ease";
//	self.defaultCSSValue[@"transition-delay"]			= @"0";
	
//	self.defaultCSSValue[@"appearance"]					= @"normal";
	self.defaultCSSValue[@"box-sizing"]					= @"content-box";
//	self.defaultCSSValue[@"outline-offset"]				= @"0";
//	self.defaultCSSValue[@"resize"]						= @"none";	
}

- (void)loadCSSInheration
{
	self.defaultCSSInherition = [NSMutableArray arrayWithObjects:

		@"border-collapse",
		@"border-spacing",
		@"caption-side",
		
		@"cursor",
		
		@"direction",
		@"text-align",
		@"text-indent",
		@"text-overflow",
		@"text-transform",
		@"text-decoration",
		@"white-space",
								 
		@"empty-cells",
		
		@"color",
		@"font",
		@"font-family",
		@"font-size",
		@"font-style",
		@"font-variant",
		@"font-weight",
		@"letter-spacing",
		@"line-height",
		@"word-spacing",
		@"word-wrap",
		
		@"list-style",
		@"list-style-image",
		@"list-style-position",
		@"list-style-type",
		
		@"orphans",
		@"widows",
		
		@"quotes",
		
		@"azimuth",
		@"elevation",
		@"pitch-range",
		@"pitch",
		@"richness",
		@"speak-header",
		@"speak-numeral",
		@"speak-punctuation",
		@"speak",
		@"speech-rate",
		@"stress",
		@"voice-family",
		@"volume",
		
		@"visibility",
		
		@"whitespace",
		
	nil];
}

- (void)loadDOMAttributedStyle
{
	self.defaultDOMAttributedStyle = [NSMutableArray arrayWithObjects:
								
	//	DOM							CSS

	@[	@"width",					@"width"					],
	@[	@"height",					@"height"					],
	@[	@"background",				@"background"				],
	@[	@"bgcolor",					@"background-color"			],
	@[	@"direction",				@"rtl"						],
	@[	@"align",					@"float"					],
	@[	@"clear",					@"clear"					],
	@[	@"border",					@"border"					],
//	@[	@"border",					@"border-top-width"			],
//	@[	@"border",					@"border-left-width"		],
//	@[	@"border",					@"border-right-width"		],
//	@[	@"border",					@"border-bottom-width"		],
	@[	@"cellspacing",				@"cell-spacing"				],
	@[	@"cellpadding",				@"cell-padding"				],

	nil];
}

- (void)importStyleSheet:(NSString *)path
{
	if ( nil == path )
		return;
	
	SamuraiCSSStyleSheet * styleSheet = [SamuraiCSSStyleSheet resourceAtPath:path];
	
	if ( styleSheet && [styleSheet parse] )
	{
		[self.defaultStyleSheets addObject:styleSheet];
	}
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlUserAgent )

DESCRIBE( before )
{
}

DESCRIBE( after )
{
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "_pragma_pop.h"
