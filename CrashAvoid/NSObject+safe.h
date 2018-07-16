//
//  NSObject+safe.h
//  Test
//
//  Created by lushuangqiang on 2018/7/9.
//  Copyright © 2018年 lushuangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (safe)

@end


/**
 *  Can avoid crash method
 *  1.- (nullable id)valueForKey:(NSString *)key;
 *  2.- (void)setValue:(id)value forKey:(NSString *)key
 *  3.- (void)setValue:(id)value forKeyPath:(NSString *)keyPath
 *  4.- (void)setValue:(id)value forUndefinedKey:(NSString *)key //这个方法一般用来重写，不会主动调用
 *  6.- (void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues
 *  6. unrecognized selector sent to instance

 */
