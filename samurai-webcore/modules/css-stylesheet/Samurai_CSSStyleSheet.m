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

#import "Samurai_CSSStyleSheet.h"
#import "Samurai_CSSMediaQuery.h"
#import "Samurai_CSSParser.h"

#import "Samurai_CSSProtocol.h"
#import "Samurai_CSSRule.h"
#import "Samurai_CSSRuleSet.h"
#import "Samurai_CSSRuleCollector.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@interface SamuraiCSSStyleSheet ()
@prop_unsafe( KatanaOutput *,                   output );
@end

@implementation SamuraiCSSStyleSheet

@def_prop_unsafe( KatanaOutput *,               output );
@def_prop_strong( SamuraiCSSRuleSet *,			ruleSet );
@def_prop_strong( SamuraiCSSRuleCollector *,	collector );

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.ruleSet = [[SamuraiCSSRuleSet alloc] init];
		self.collector = [[SamuraiCSSRuleCollector alloc] init];
	}
	return self;
}

- (void)dealloc
{
    if ( _output )
	{
        katana_destroy_output( _output );
		
        _output = NULL;
    }
	
	self.ruleSet = nil;
	self.collector = nil;
}

#pragma mark -

+ (NSArray *)supportedExtensions
{
	return [NSArray arrayWithObjects:@"css", nil];
}

+ (NSArray *)supportedTypes
{
	return [NSArray arrayWithObjects:@"text/css", nil];
}

+ (NSString *)baseDirectory
{
	return @"/www/css";
}

#pragma mark -

- (NSDictionary *)queryForObject:(NSObject<SamuraiCSSProtocol> *)object
{
	return [self.collector collectFromRuleSet:self.ruleSet forElement:object];
}

- (NSDictionary *)queryForString:(NSString *)string
{
	SamuraiCSSCondition * condition = [[SamuraiCSSCondition alloc] init];

	if ( [string hasPrefix:@"#"] )
	{
		condition.cssId = [string substringFromIndex:1];
	}
	else if ( [string hasPrefix:@"."] )
	{
		condition.cssClasses = [NSArray arrayWithObject:[string substringFromIndex:1]];
	}
	else
	{
		condition.cssTag = string;
	}
	
	return [self.collector collectFromRuleSet:self.ruleSet forElement:condition];
}

#pragma mark -

- (BOOL)parse
{
	if ( nil == self.resContent || 0 == [self.resContent length] )
	{
	//	return NO;
		return YES;
	}

	_output = [[SamuraiCSSParser sharedInstance] parseStylesheet:self.resContent];

	if ( _output )
	{
		KatanaStylesheet * stylesheet = _output->stylesheet;
		
		if ( stylesheet && stylesheet->imports.length )
		{
			/*
			for ( unsigned int i = 0; i < stylesheet->imports.length; i++ )
			{
				KatanaImportRule * rule = stylesheet->imports.data[i];
				
				if ( [[SamuraiCSSMediaQuery sharedInstance] testMediaQueries:rule->medias] )
				{
					SamuraiCSSStyleSheet * styleSheet = nil;

					NSString *	href = [NSString stringWithUTF8String:rule->href];
					NSString *	basePath = self.resPath;

					NSString *	fileName = [[href lastPathComponent] stringByDeletingPathExtension];
					NSString *	fileExt = [[href lastPathComponent] pathExtension];
					NSString *	filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileExt];
					
					if ( filePath && [[NSFileManager defaultManager] fileExistsAtPath:filePath] )
					{
						styleSheet = [SamuraiCSSStyleSheet resourceAtPath:filePath];
					}
					else if ( [href hasPrefix:@"http://"] || [href hasPrefix:@"https://"] )
					{
						styleSheet = [SamuraiCSSStyleSheet resourceWithURL:href];
					}
					else if ( [href hasPrefix:@"//"] )
					{
						styleSheet = [SamuraiCSSStyleSheet resourceWithURL:[@"http:" stringByAppendingString:href]];
					}
					else if ( [basePath hasPrefix:@"http://"] || [basePath hasPrefix:@"https://"] )
					{
						NSURL * url = [NSURL URLWithString:href relativeToURL:[NSURL URLWithString:basePath]];
						
						styleSheet = [SamuraiCSSStyleSheet resourceWithURL:[url absoluteString]];
					}
					else
					{
						NSString * cssPath;
						
						cssPath = [basePath stringByDeletingLastPathComponent];
						cssPath = [cssPath stringByAppendingPathComponent:href];
						cssPath = [cssPath stringByStandardizingPath];
						
						styleSheet = [SamuraiCSSStyleSheet resourceAtPath:cssPath];
					}
					
					if ( styleSheet )
					{
						BOOL succeed = [styleSheet parse];
						if ( succeed )
						{
							[self.ruleSet mergeWithRuleSet:styleSheet.ruleSet];
						}
					}
				}
			}
			*/
		}

		if ( stylesheet && stylesheet->rules.length )
		{
			[self.ruleSet addStyleRules:&_output->stylesheet->rules];
		}
	}
	
	return YES;
}

- (void)merge:(SamuraiCSSStyleSheet *)styleSheet
{
	if ( nil == styleSheet )
		return;
	
	if ( NO == [styleSheet isKindOfClass:[SamuraiCSSStyleSheet class]] )
		return;
    
    if ( nil == styleSheet.output )
        return;
        

    [self.ruleSet addStyleRules:&styleSheet.output->stylesheet->rules];
}

- (void)clear
{
	[self.ruleSet clear];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, CSSStyleSheet )

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
