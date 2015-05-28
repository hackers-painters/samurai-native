//
//  NSString+EMAdditions.m
//  EMString
//
//  Created by Tanguy Aladenise on 2014-11-27.
//  Copyright (c) 2014 Tanguy Aladenise. All rights reserved.
//


#import "NSString+EMAdditions.h"
#import "EMStringStylingConfiguration.h"


@implementation NSString (EMAdditions)


- (NSAttributedString *)attributedString
{
    // Automatically append the default text markup
    NSString *mutableString = [self stringByAppendingString:kEMDefaultCloseMarkup];
    mutableString           = [kEMDefaultMarkup stringByAppendingString:mutableString];
    
    // Apply styling to string
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:[self styleParagraphForString:mutableString]];
    // Default style need to be applied first
    string = [self defaultStyling:string];
    string = [self styleStrongForString:string];
    string = [self styleEmphasisForString:string];
    string = [self styleUnderlineForString:string];
    string = [self styleStrikethroughForString:string];
    string = [self styleHeaders:string];
    
    
    // For overide purpose, we MUST apply custom class styling in last.
    if ([EMStringStylingConfiguration sharedInstance].stylingClasses.count > 0) {
        // Apply custom class
        for (EMStylingClass *aStylingClass in [EMStringStylingConfiguration sharedInstance].stylingClasses) {
            string = [self applyStylingClass:aStylingClass forAttributedString:string];
        }
    }
    
    return string;
}


#pragma mark - Styling strin


/**
 *  Apply paragraph styling to given string
 *
 *  @param string The NSString to apply paragraph style
 *
 *  @return NSString with paragraph styling applied
 */
- (NSString *)styleParagraphForString:(NSString *)string
{
    // In the string remove paragraph opening markup
    string = [self clearMarkup:kEMParagraphMarkup forString:string];
    // Then replace closing paragraph markup with a return to line
    string = [string stringByReplacingOccurrencesOfString:kEMParagraphCloseMarkup withString:@""];
    // Finally check for empty spaces at beginning of paragraph
    string = [string stringByReplacingOccurrencesOfString:@"\n " withString:@"\n"];
    
    return string;
}


/**
 *  Apply default styling to given NSAttributed string
 *
 *  @param attributedString The NSAttributedString to use for apply styling
 *
 *  @return NSSAttributed string with styling applied
 */
- (NSAttributedString *)defaultStyling:(NSAttributedString *)attributedString
{
    EMStylingClass *stylingClass = [[EMStylingClass alloc] init];
    stylingClass.markup = kEMDefaultMarkup;
    stylingClass.attributes = @{NSFontAttributeName : [EMStringStylingConfiguration sharedInstance].defaultFont, NSForegroundColorAttributeName : [EMStringStylingConfiguration sharedInstance].defaultColor };
    return [self applyStylingClass:stylingClass forAttributedString:attributedString];
}


/**
 *  Apply strong styling to given NSAttributed string
 *
 *  @param attributedString The NSAttributedString to use for apply styling
 *
 *  @return NSSAttributed string with styling applied
 */
- (NSAttributedString *)styleStrongForString:(NSAttributedString *)attributedString
{
    EMStylingClass *stylingClass = [[EMStylingClass alloc] init];
    stylingClass.markup = kEMStrongMarkup;
    stylingClass.attributes = @{NSFontAttributeName : [EMStringStylingConfiguration sharedInstance].strongFont, NSForegroundColorAttributeName : [EMStringStylingConfiguration sharedInstance].strongColor };
    return [self applyStylingClass:stylingClass forAttributedString:attributedString];
}


/**
 *  Apply emphasis styling to given NSAttributed string
 *
 *  @param attributedString The NSAttributedString to use for apply styling
 *
 *  @return NSSAttributed string with styling applied
 */
- (NSAttributedString *)styleEmphasisForString:(NSAttributedString *)attributedString
{
    EMStylingClass *stylingClass = [[EMStylingClass alloc] init];
    stylingClass.markup = kEMEmphasisMarkup;
    stylingClass.attributes = @{NSFontAttributeName : [EMStringStylingConfiguration sharedInstance].emphasisFont, NSForegroundColorAttributeName : [EMStringStylingConfiguration sharedInstance].emphasisColor };
    return [self applyStylingClass:stylingClass forAttributedString:attributedString];
}


/**
 *  Apply underline styling to given NSAttributed string
 *
 *  @param attributedString The NSAttributedString to use for apply styling
 *
 *  @return NSSAttributed string with styling applied
 */
- (NSAttributedString *)styleUnderlineForString:(NSAttributedString *)attributedString
{
    EMStylingClass *stylingClass = [[EMStylingClass alloc] init];
    stylingClass.markup = kEMUnderlineMarkup;
    stylingClass.attributes = @{NSUnderlineStyleAttributeName : @([EMStringStylingConfiguration sharedInstance].underlineStyle) };
    return [self applyStylingClass:stylingClass forAttributedString:attributedString];
}


/**
 *  Apply strikethrough styling to given NSAttributed string
 *
 *  @param attributedString The NSAttributedString to use for apply styling
 *
 *  @return NSSAttributed string with styling applied
 */
- (NSAttributedString *)styleStrikethroughForString:(NSAttributedString *)attributedString
{
    EMStylingClass *stylingClass = [[EMStylingClass alloc] init];
    stylingClass.markup = kEMStrikethroughMarkup;
    stylingClass.attributes = @{NSStrikethroughStyleAttributeName : @([EMStringStylingConfiguration sharedInstance].striketroughStyle) };
    return [self applyStylingClass:stylingClass forAttributedString:attributedString];
}


/**
 *  Apply headers styling to given NSAttributed string
 *
 *  @param attributedString The NSAttributedString to use for apply styling
 *
 *  @return NSSAttributed string with styling applied
 */
- (NSAttributedString *)styleHeaders:(NSAttributedString *)attributedString
{
    EMStylingClass *stylingClass = [[EMStylingClass alloc] init];
    stylingClass.markup          = kEMH1Markup;
    stylingClass.attributes      = @{NSFontAttributeName : [EMStringStylingConfiguration sharedInstance].h1Font, NSForegroundColorAttributeName : [EMStringStylingConfiguration sharedInstance].h1Color };
    stylingClass.displayBlock    = ![EMStringStylingConfiguration sharedInstance].h1DisplayInline;
    attributedString             = [self applyStylingClass:stylingClass forAttributedString:attributedString];
    
    stylingClass.markup          = kEMH2Markup;
    stylingClass.attributes      = @{NSFontAttributeName : [EMStringStylingConfiguration sharedInstance].h2Font, NSForegroundColorAttributeName : [EMStringStylingConfiguration sharedInstance].h2Color };
    stylingClass.displayBlock    = ![EMStringStylingConfiguration sharedInstance].h2DisplayInline;
    attributedString             = [self applyStylingClass:stylingClass forAttributedString:attributedString];
    
    stylingClass.markup          = kEMH3Markup;
    stylingClass.attributes      = @{NSFontAttributeName : [EMStringStylingConfiguration sharedInstance].h3Font, NSForegroundColorAttributeName : [EMStringStylingConfiguration sharedInstance].h3Color };
    stylingClass.displayBlock    = ![EMStringStylingConfiguration sharedInstance].h3DisplayInline;
    attributedString             = [self applyStylingClass:stylingClass forAttributedString:attributedString];
    
    stylingClass.markup          = kEMH4Markup;
    stylingClass.attributes      = @{NSFontAttributeName : [EMStringStylingConfiguration sharedInstance].h4Font, NSForegroundColorAttributeName : [EMStringStylingConfiguration sharedInstance].h4Color };
    stylingClass.displayBlock    = ![EMStringStylingConfiguration sharedInstance].h4DisplayInline;
    attributedString             = [self applyStylingClass:stylingClass forAttributedString:attributedString];
    
    stylingClass.markup          = kEMH5Markup;
    stylingClass.attributes      = @{NSFontAttributeName : [EMStringStylingConfiguration sharedInstance].h5Font, NSForegroundColorAttributeName : [EMStringStylingConfiguration sharedInstance].h5Color };
    stylingClass.displayBlock    = ![EMStringStylingConfiguration sharedInstance].h5DisplayInline;
    attributedString             = [self applyStylingClass:stylingClass forAttributedString:attributedString];
    
    stylingClass.markup          = kEMH6Markup;
    stylingClass.attributes      = @{NSFontAttributeName : [EMStringStylingConfiguration sharedInstance].h6Font, NSForegroundColorAttributeName : [EMStringStylingConfiguration sharedInstance].h6Color };
    stylingClass.displayBlock    = ![EMStringStylingConfiguration sharedInstance].h6DisplayInline;
    attributedString             = [self applyStylingClass:stylingClass forAttributedString:attributedString];
    
    
    return attributedString;
}


#pragma mark - Utils


/**
 *  Clear a given markup out a given string
 *
 *  @param markup The markup to find and remove
 *  @param string The string in which to exerce find and clean
 *
 *  @return The NSString resulting from clean operation
 */
- (NSString *)clearMarkup:(NSString *)markup forString:(NSString *)string
{
    return [string stringByReplacingOccurrencesOfString:markup withString:@""];
}


/**
 *  Apply a styling class for a given NSAttributedString
 *
 *  @param stylingClass     EMStylingClass to apply
 *  @param attributedString NSAttributedString to apply styling class
 *
 *  @return NSAttributedString styled with class
 */
- (NSAttributedString *)applyStylingClass:(EMStylingClass *)stylingClass forAttributedString:(NSAttributedString *)attributedString
{
    // Use a mutable attributed string to apply styling by occurence of markup
    NSMutableAttributedString *styleAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
    
    NSRange openMarkupRange;
    
    // Find range of open markup
    while((openMarkupRange = [styleAttributedString.mutableString rangeOfString:stylingClass.markup]).location != NSNotFound) {
        
        //        NSLog(@"debut markup range %lu - %lu", (unsigned long)openMarkupRange.location, (unsigned long)openMarkupRange.length);
        
        // Find range of close markup
        NSRange closeMarkupRange = [styleAttributedString.mutableString rangeOfString:stylingClass.closeMarkup];
        
        if (closeMarkupRange.location == NSNotFound) {
            NSLog(@"Error finding close markup %@. Make sure you open and close your markups correctly.", stylingClass.closeMarkup);
            return attributedString;
        }
        
        //        NSLog(@"close markup range %lu - %lu", (unsigned long)closeMarkupRange.location, (unsigned long)closeMarkupRange.length);
        
        // Calculate the style range that represent the string between the open and close markups
        NSRange styleRange = NSMakeRange(openMarkupRange.location, closeMarkupRange.location + closeMarkupRange.length - openMarkupRange.location);
        
        // Before applying style to the markup, make sure there is "sub" style that have been applied before.
        __block NSMutableArray *restoreStyle = [[NSMutableArray alloc] init];
        
        [styleAttributedString enumerateAttributesInRange:styleRange options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
            if (attrs.count > 0) {
                if (range.length < styleRange.length) {
                    [restoreStyle addObject:@{ @"range" : [NSValue valueWithRange:range], @"attrs" : attrs}];
                }
            }
        }];
        
        
        BOOL overrideMarkup = NO;
        
        // Apply style to markup
        
        // Check if one of the custom class is not overriding a default markup with a more complex styling
        for (EMStylingClass *aStylingClass in [EMStringStylingConfiguration sharedInstance].stylingClasses) {
            if ([aStylingClass.markup isEqualToString:stylingClass.markup]) {
                overrideMarkup = YES;
                [styleAttributedString addAttributes:aStylingClass.attributes range:styleRange];
            }
        }
        
        if (!overrideMarkup) {
            [styleAttributedString addAttributes:stylingClass.attributes range:styleRange];
        }
        
        // Restore "sub" style if necessary
        for (NSDictionary *style in restoreStyle) {
            [styleAttributedString addAttributes:style[@"attrs"] range:[style[@"range"] rangeValue]];
            
            // When restoring sub style, make sure the color/font of the new style is not overidden by the default color/font because of restoring mechanism.
            
            // Firt check if we are trying to apply a color to see if treatment is necessary
            if ([stylingClass.attributes valueForKey:NSForegroundColorAttributeName]) {
                // If we apply a color make sure we did not just re-apply the default color on that sub style.
                if ([[style[@"attrs"] valueForKey:NSForegroundColorAttributeName] isEqual:[EMStringStylingConfiguration sharedInstance].defaultColor]) {
                    // If we restored wrongly default color, we reapply custom color styling.
                    [styleAttributedString addAttribute:NSForegroundColorAttributeName value:[stylingClass.attributes valueForKey:NSForegroundColorAttributeName] range:[style[@"range"] rangeValue]];
                }
            }
            
            // Same thing for font
            if ([stylingClass.attributes valueForKey:NSFontAttributeName]) {
                if ([[style[@"attrs"] valueForKey:NSFontAttributeName] isEqual:[EMStringStylingConfiguration sharedInstance].defaultFont]) {
                    [styleAttributedString addAttribute:NSFontAttributeName value:[stylingClass.attributes valueForKey:NSFontAttributeName] range:[style[@"range"] rangeValue]];
                }
            }
        }
        
        // Remove opening markup in string
        [styleAttributedString.mutableString replaceCharactersInRange:NSMakeRange(openMarkupRange.location, openMarkupRange.length) withString:@""];
        
        // Refind range of closing markup because it moved since we removed opening markup
        closeMarkupRange = [styleAttributedString.mutableString rangeOfString:stylingClass.closeMarkup];
        
        // Remove closing markup in string
        NSString *replaceEndMarkupBy = @"";
        if (closeMarkupRange.location < styleAttributedString.string.length - stylingClass.closeMarkup.length && stylingClass.isDisplayBlock) {
            replaceEndMarkupBy = @"\n";
        }
        [styleAttributedString.mutableString replaceCharactersInRange:NSMakeRange(closeMarkupRange.location, closeMarkupRange.length) withString:replaceEndMarkupBy];
    }
    
    return styleAttributedString;
}


@end
