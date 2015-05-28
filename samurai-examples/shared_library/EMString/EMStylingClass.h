//
//  EMStylingClass.h
//  EMString
//
//  Created by Tanguy Aladenise on 2014-12-04.
//  Copyright (c) 2014 Tanguy Aladenise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EMStylingClass : NSObject

/**
 *  Init method for EMStylingClass
 *
 *  @param markup The markup to identify styling. Must be in the form of : "<yourMarkup>".
 *
 *  @return An EMStylingClass instance
 */
- (EMStylingClass *)initWithMarkup:(NSString *)markup;


/**
 *  A given name for a styling class. Optional field.
 */
@property (nonatomic, strong) NSString *name;


/**
 *  The markup identifying the styling to apply in the string
 */
@property (nonatomic, strong) NSString *markup;


/**
 *  The display style for the markup to follow. By default element will be inline. If you want it to return to the line automatically pass this property to YES.
 */
@property (nonatomic, getter=isDisplayBlock) BOOL displayBlock;


/**
 *  The close markup for styling. Read-only property since close markup will be deducted from markup
 */
@property (nonatomic, strong, readonly) NSString *closeMarkup;


/**
 *  A dictionary containing the attributes to set for the NSAttributedString. For information about where to find the system-supplied attribute keys, see the overview section in NSAttributedString Class Reference.
    https://developer.apple.com/Library/ios/documentation/UIKit/Reference/NSAttributedString_UIKit_Additions/index.html#//apple_ref/doc/constant_group/Character_Attributes
 */
@property (nonatomic, strong) NSDictionary *attributes;


/**
 *  The color to apply to the string. Convenient setter to populate attributes.
 */
@property (nonatomic, strong) UIColor *color;

/**
 *  The font to apply to the string. Convenient setter to populate attributes.
 */
@property (nonatomic, strong) UIFont *font;


@end
