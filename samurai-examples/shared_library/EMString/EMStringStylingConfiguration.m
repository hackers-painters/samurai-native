//
//  EMStringStyling.m
//  EMString
//
//  Created by Tanguy Aladenise on 2014-11-27.
//  Copyright (c) 2014 Tanguy Aladenise. All rights reserved.
//


#import "EMStringStylingConfiguration.h"


@interface EMStringStylingConfiguration()


/**
 *  NSMutable array of EMStylingClass
 */
@property (nonatomic, strong) NSMutableArray *mutableStylingClasses;


@end


@implementation EMStringStylingConfiguration


#pragma Init


/**
 *  Singleton instance of EMStringStylingConfiguration
 *
 *  @return An instance of EMStringStylingConfiguration
 */
+ (EMStringStylingConfiguration *)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[EMStringStylingConfiguration alloc] init];
    });
    return sharedInstance;
}


- (void)addNewStylingClass:(EMStylingClass *)stylingClass
{
    if ([self.stylingClasses containsObject:stylingClass]) {
        NSLog(@"Class already added");
        return;
    }
    
    [self.mutableStylingClasses addObject:stylingClass];
}


#pragma mark - Getters


#pragma mark - Fonts


- (UIFont *)defaultFont
{
    // Return system font if no default font was provided
    return (_defaultFont) ?: [UIFont systemFontOfSize:16];
}

- (UIFont *)strongFont
{
    if (_strongFont) {
        return _strongFont;
    }
    
    // Try to determine to best font available for strong behavior
    UIFont *font = [self findFontByAppendingStyle:@"Bold"];
    
    return (font) ?: [UIFont boldSystemFontOfSize:self.defaultFont.pointSize];
}


- (UIFont *)emphasisFont
{
    if (_emphasisFont) {
        return _emphasisFont;
    }
    
    // Try to determine to best font available for emphasis behavior
    UIFont *font = [self findFontByAppendingStyle:@"Italic"];

    return (font) ?: [UIFont italicSystemFontOfSize:self.defaultFont.pointSize];
}

// For headers, retrieve default font and apply +3 points to point size per header layer (h6 = +3pts. h1 = +18pts)

- (UIFont *)h1Font
{
    return (_h1Font) ?: [UIFont fontWithName:self.defaultFont.familyName size:self.defaultFont.pointSize + 18];
}


- (UIFont *)h2Font
{
    return (_h2Font) ?: [UIFont fontWithName:self.defaultFont.familyName size:self.defaultFont.pointSize + 15];
}


- (UIFont *)h3Font
{
    return (_h3Font) ?: [UIFont fontWithName:self.defaultFont.familyName size:self.defaultFont.pointSize + 12];
}


- (UIFont *)h4Font
{
    return (_h4Font) ?: [UIFont fontWithName:self.defaultFont.familyName size:self.defaultFont.pointSize + 9];
}


- (UIFont *)h5Font
{
    return (_h5Font) ?: [UIFont fontWithName:self.defaultFont.familyName size:self.defaultFont.pointSize + 6];
}


- (UIFont *)h6Font
{
    return (_h6Font) ?: [UIFont fontWithName:self.defaultFont.familyName size:self.defaultFont.pointSize + 3];
}


/**
 *  Try to find a matching font for a given style. Basically algo will take default font familly name and try to append -Italic or -ItaliceMT to it. And see 
 *  if font exists
 *
 *  @param style The NSString representing the style to find. eg: "italic"
 *
 *  @return UIFont instance. Will be nil if not font was find.
 */
- (UIFont *)findFontByAppendingStyle:(NSString *)style
{
    UIFont *font;
    
    // This logic is only necessary if default font is not system
    if (![self useDefaultSystemFont]) {
        
        // Try to find the style font family name automatically
        NSString *styleFontName = [self.defaultFont.familyName stringByAppendingString:[NSString stringWithFormat:@"-%@", style.capitalizedString]];
        font = [UIFont fontWithName:styleFontName size:self.defaultFont.pointSize];
        
        if (!font) {
            styleFontName = [styleFontName stringByAppendingString:@"MT"];
            font = [UIFont fontWithName:styleFontName size:self.defaultFont.pointSize];
        }
        
        if (!font) {
            NSLog(@"EMString was not able to find a font %@ automatically for your custom default font : %@. The system default font for %@ will be use instead.", style, self.defaultFont.familyName, style);
        }
    }
    
    return font;
}


/**
 *  Check if configuration uses system default font.
 *
 *  @return BOOL value. Yes if default font is equal to system default font.q
 */
- (BOOL)useDefaultSystemFont
{
    if ([self.defaultFont.familyName isEqualToString:[UIFont systemFontOfSize:16].familyName]) {
        return YES;
    }
    
    return NO;
}

#pragma mark - Colors


- (UIColor *)defaultColor
{
    return (_defaultColor) ?: [UIColor blackColor];
}


- (UIColor *)strongColor
{
    return (_strongColor) ?: self.defaultColor;
}


- (UIColor *)emphasisColor
{
    return (_emphasisColor) ?: self.defaultColor;
}


- (UIColor *)h1Color
{
    return (_h1Color) ?: self.defaultColor;
}


- (UIColor *)h2Color
{
    return (_h2Color) ?: self.defaultColor;
}


- (UIColor *)h3Color
{
    return (_h3Color) ?: self.defaultColor;
}


- (UIColor *)h4Color
{
    return (_h4Color) ?: self.defaultColor;
}


- (UIColor *)h5Color
{
    return (_h5Color) ?: self.defaultColor;
}


- (UIColor *)h6Color
{
    return (_h6Color) ?: self.defaultColor;
}


#pragma mark - Options


- (NSUnderlineStyle)underlineStyle
{
    return (_underlineStyle == NSUnderlineStyleNone) ?: NSUnderlineStyleSingle;
}


- (NSUnderlineStyle)striketroughStyle
{
    return (_striketroughStyle == NSUnderlineStyleNone) ?: NSUnderlineStyleSingle;
}


#pragma mark - Lazy instantiation


- (NSMutableArray *)mutableStylingClasses
{
    if (!_mutableStylingClasses) {
        _mutableStylingClasses = [[NSMutableArray alloc] init];
    }
    
    return _mutableStylingClasses;
}


- (NSMutableArray *)stylingClasses
{
    return self.mutableStylingClasses.copy;
}

@end
