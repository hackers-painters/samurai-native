//
//  NSString+EMAdditions.h
//  EMString
//
//  Created by Tanguy Aladenise on 2014-11-27.
//  Copyright (c) 2014 Tanguy Aladenise. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMMarkupProperty.h"
#import "EMStringStylingConfiguration.h"


@interface NSString (EMAdditions)

/**
 *  Return the styled attributedString according to markup contained in the string.
 */
@property (readonly, copy) NSAttributedString *attributedString;


@end
