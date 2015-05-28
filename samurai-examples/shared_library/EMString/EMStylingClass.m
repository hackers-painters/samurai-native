//
//  EMStylingClass.m
//  EMString
//
//  Created by Tanguy Aladenise on 2014-12-04.
//  Copyright (c) 2014 Tanguy Aladenise. All rights reserved.
//

#import "EMStylingClass.h"

@interface EMStylingClass()

/**
 *  Attributes for styling class
 */
@property (strong, nonatomic) NSMutableDictionary *mutableAttributes;


@end


@implementation EMStylingClass


@synthesize attributes = _attributes;


- (EMStylingClass *)initWithMarkup:(NSString *)markup
{
    self = [[EMStylingClass alloc] init];
    if (self) {
        self.markup = markup;
    }
    
    return self;
}


#pragma mark - Setters


- (void)setColor:(UIColor *)color
{
    _color = color;
    [self.mutableAttributes setObject:color forKey:NSForegroundColorAttributeName];
}


- (void)setFont:(UIFont *)font
{
    _font = font;
    [self.mutableAttributes setValue:font forKey:NSFontAttributeName];
}


- (void)setAttributes:(NSDictionary *)attributes
{
    [self.mutableAttributes addEntriesFromDictionary:attributes];
}


#pragma mark - Getters

/**
 *  Getter for closeMarkup. Return a value based on markup
 *
 *  @return The close markup NSString
 */
- (NSString *)closeMarkup
{
    return [self.markup stringByReplacingOccurrencesOfString:@"<" withString:@"</"];
}


- (NSMutableDictionary *)mutableAttributes
{
    if (!_mutableAttributes) {
        _mutableAttributes = [[NSMutableDictionary alloc] init];
    }
    
    [_mutableAttributes addEntriesFromDictionary:self.attributes];
    
    return _mutableAttributes;
}


- (NSDictionary *)attributes
{
    return _mutableAttributes.copy;
}

@end
