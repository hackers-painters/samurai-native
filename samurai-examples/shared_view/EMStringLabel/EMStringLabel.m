//
//  EMStylingClass.m
//  EMString
//
//  Created by Tanguy Aladenise on 2014-12-04.
//  Copyright (c) 2014 Tanguy Aladenise. All rights reserved.
//

#import "EMStringLabel.h"
#import "NSString+EMAdditions.h"
#import "Samurai.h"

@implementation EMStringLabel

#pragma mark -

- (id)serialize
{
	return [super serialize];
}

- (void)unserialize:(id)obj
{
	[super unserialize:[[obj toString] attributedString]];
}

- (void)zerolize
{
	[super zerolize];
}

@end
