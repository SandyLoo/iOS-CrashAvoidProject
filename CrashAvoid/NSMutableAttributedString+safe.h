//
//  NSMutableAttributedString+safe.h
//  Test
//
//  Created by lushuangqiang on 2018/7/9.
//  Copyright © 2018年 lushuangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (safe)

@end


/**
 *  Can avoid crash method
 *
 *  1.- (instancetype)initWithString:(NSString *)str
 *  2.- (instancetype)initWithString:(NSString *)str attributes:(NSDictionary<NSString *,id> *)attrs
 */
