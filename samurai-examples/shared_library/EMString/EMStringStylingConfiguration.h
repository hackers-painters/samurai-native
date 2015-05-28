//
//  EMStringStylingConfiguration.h
//  EMString
//
//  Created by Tanguy Aladenise on 2014-11-27.
//  Copyright (c) 2014 Tanguy Aladenise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EMStylingClass.h"


@interface EMStringStylingConfiguration : NSObject


/**
 *  Singleton instance of EMStringStyleConfiguration. Use this class to setup the styling you need for your strings.
 *
 *  @return An singleton instance of EMStringStylingConfiguration
 */
+ (EMStringStylingConfiguration *)sharedInstance;


/**
 *  Add a styling class EMStylingClass to configuration
 *
 *  @param stylingClass The EMStylingClass to add
 */
- (void)addNewStylingClass:(EMStylingClass *)stylingClass;


/**
 *  The array of EMStylingClass
 */
@property (nonatomic, strong, readonly) NSArray *stylingClasses;


// Fonts

/**
 *  The font for default markup.
 */
@property (strong, nonatomic) UIFont *defaultFont;

/**
 *  The color for default markup.
 */
@property (strong, nonatomic) UIColor *defaultColor;

/**
 *  The font for strong markup.
 */
@property (strong, nonatomic) UIFont *strongFont;

/**
 *  The color for strong markup.
 */
@property (strong, nonatomic) UIColor *strongColor;


/**
 *  The font for emphasis markup.
 */
@property (strong, nonatomic) UIFont *emphasisFont;

/**
 *  The color for emphasis markup.
 */
@property (strong, nonatomic) UIColor *emphasisColor;


/**
 *  The font for h1 markup.
 */
@property (strong, nonatomic) UIFont *h1Font;

/**
 *  The color for h1 markup.
 */
@property (strong, nonatomic) UIColor *h1Color;

/**
 *  The display style for h1 markup.
 */
@property (nonatomic) BOOL h1DisplayInline;


/**
 *  The font for h2 markup.
 */
@property (strong, nonatomic) UIFont *h2Font;

/**
 *  The color for h2 markup.
 */
@property (strong, nonatomic) UIColor *h2Color;

/**
 *  The display style for h2 markup.
 */
@property (nonatomic) BOOL h2DisplayInline;


/**
 *  The font for h3 markup.
 */
@property (strong, nonatomic) UIFont *h3Font;

/**
 *  The color for h3 markup.
 */
@property (strong, nonatomic) UIColor *h3Color;

/**
 *  The display style for h3 markup.
 */
@property (nonatomic) BOOL h3DisplayInline;


/**
 *  The font for h4 markup.
 */
@property (strong, nonatomic) UIFont *h4Font;

/**
 *  The color for h4 markup.
 */
@property (strong, nonatomic) UIColor *h4Color;

/**
 *  The display style for h4 markup.
 */
@property (nonatomic) BOOL h4DisplayInline;


/**
 *  The font for h5 markup.
 */
@property (strong, nonatomic) UIFont *h5Font;

/**
 *  The color for h5 markup.
 */
@property (strong, nonatomic) UIColor *h5Color;

/**
 *  The display style for h5 markup.
 */
@property (nonatomic) BOOL h5DisplayInline;


/**
 *  The font for h6 markup.
 */
@property (strong, nonatomic) UIFont *h6Font;

/**
 *  The color for h6 markup.
 */
@property (strong, nonatomic) UIColor *h6Color;

/**
 *  The display style for h6 markup.
 */
@property (nonatomic) BOOL h6DisplayInline;



// Options


/**
 *  NSUnderlineStyle for underlining text
 */
@property (nonatomic) NSUnderlineStyle underlineStyle;


/**
 *  NSUnderlineStyle for striketrough text
 */
@property (nonatomic) NSUnderlineStyle striketroughStyle;


@end
