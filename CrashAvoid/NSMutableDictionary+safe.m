//
//  NSMutableDictionary+safe.m
//  Test
//
//  Created by lushuangqiang on 2018/7/9.
//  Copyright © 2018年 lushuangqiang. All rights reserved.
//

#import "NSMutableDictionary+safe.h"
#import "CrashAvoidConst.h"

@implementation NSMutableDictionary (safe)
+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class dictionaryM = NSClassFromString(@"__NSDictionaryM");
        
        //setObject:forKey:
        [CrashAvoidManager exchangeInstanceMethod:dictionaryM method1Sel:@selector(setObject:forKey:) method2Sel:@selector(safeMethodSetObject:forKey:)];
        
        //setObject:forKeyedSubscript:
        [CrashAvoidManager exchangeInstanceMethod:dictionaryM method1Sel:@selector(setObject:forKeyedSubscript:) method2Sel:@selector(safeMethodSetObject:forKeyedSubscript:)];
        
        
        //removeObjectForKey:
        Method removeObjectForKey = class_getInstanceMethod(dictionaryM, @selector(removeObjectForKey:));
        Method safeMethodRemoveObjectForKey = class_getInstanceMethod(dictionaryM, @selector(safeMethodRemoveObjectForKey:));
        method_exchangeImplementations(removeObjectForKey, safeMethodRemoveObjectForKey);
        
    });
}


//=================================================================
//                       setObject:forKey:
//=================================================================
#pragma mark - setObject:forKey:

- (void)safeMethodSetObject:(id)anObject forKey:(id<NSCopying>)aKey {
    
    @try {
        [self safeMethodSetObject:anObject forKey:aKey];
    }
    @catch (NSException *exception) {
        [CrashAvoidManager noteErrorWithException:exception defaultToDo:AvoidCrashDefaultIgnore];
    }
    @finally {
        
    }
}

//=================================================================
//                  setObject:forKeyedSubscript:
//=================================================================
#pragma mark - setObject:forKeyedSubscript:
- (void)safeMethodSetObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
    @try {
        [self safeMethodSetObject:obj forKeyedSubscript:key];
    }
    @catch (NSException *exception) {
        [CrashAvoidManager noteErrorWithException:exception defaultToDo:AvoidCrashDefaultIgnore];
    }
    @finally {
        
    }
}


//=================================================================
//                       removeObjectForKey:
//=================================================================
#pragma mark - removeObjectForKey:

- (void)safeMethodRemoveObjectForKey:(id)aKey {
    
    @try {
        [self safeMethodRemoveObjectForKey:aKey];
    }
    @catch (NSException *exception) {
        [CrashAvoidManager noteErrorWithException:exception defaultToDo:AvoidCrashDefaultIgnore];
    }
    @finally {
        
    }
}


@end
