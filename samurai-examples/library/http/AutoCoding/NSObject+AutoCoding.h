//
//  NSObject+AutoCoding.h
//  AutoCoding
//
//  Created by QFish on 1/12/15.
//  Copyright (c) 2015 QFish. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AutoModelCoding <NSObject>
+ (id)processedValueForKey:(NSString *)key
               originValue:(id)originValue
            convertedValue:(id)convertedValue
                     class:(__unsafe_unretained Class)clazz
                  subClass:(__unsafe_unretained Class)subClazz;
@end

@interface NSObject (AutoModelCoding)

- (instancetype)ac_clone;

+ (instancetype)ac_objectWithAny:(id)any;
+ (instancetype)ac_objectWithDictionary:(NSDictionary *)dictionary;
+ (id)ac_objectsWithArray:(NSArray *)array objectClass:(Class)clazz;

- (NSString *)JSONStringRepresentation;

@end
