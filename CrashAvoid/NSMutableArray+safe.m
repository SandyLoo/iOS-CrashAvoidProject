//
//  NSMutableArray+safe.m
//  Test
//
//  Created by lushuangqiang on 2018/7/9.
//  Copyright © 2018年 lushuangqiang. All rights reserved.
//

#import "NSMutableArray+safe.h"
#import "CrashAvoidConst.h"

@implementation NSMutableArray (safe)
+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class arrayMClass = NSClassFromString(@"__NSArrayM");
        
        
        //objectAtIndex:
        [CrashAvoidManager exchangeInstanceMethod:arrayMClass method1Sel:@selector(objectAtIndex:) method2Sel:@selector(safeMethodObjectAtIndex:)];
        
        //objectAtIndexedSubscript
        [CrashAvoidManager exchangeInstanceMethod:arrayMClass method1Sel:@selector(objectAtIndexedSubscript:) method2Sel:@selector(safeMethodObjectAtIndexedSubscript:)];
        
        //setObject:atIndexedSubscript:
        [CrashAvoidManager exchangeInstanceMethod:arrayMClass method1Sel:@selector(setObject:atIndexedSubscript:) method2Sel:@selector(safeMethodSetObject:atIndexedSubscript:)];
        
        //removeObjectAtIndex:
        [CrashAvoidManager exchangeInstanceMethod:arrayMClass method1Sel:@selector(removeObjectAtIndex:) method2Sel:@selector(safeMethodRemoveObjectAtIndex:)];
        
        //insertObject:atIndex:
        [CrashAvoidManager exchangeInstanceMethod:arrayMClass method1Sel:@selector(insertObject:atIndex:) method2Sel:@selector(safeMethodInsertObject:atIndex:)];
        
        
        //getObjects:range:
        [CrashAvoidManager exchangeInstanceMethod:arrayMClass method1Sel:@selector(getObjects:range:) method2Sel:@selector(safeMethodGetObjects:range:)];

    });
}


//=================================================================
//                    array set object at index
//=================================================================
#pragma mark - get object from array


- (void)safeMethodSetObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    
    @try {
        [self safeMethodSetObject:obj atIndexedSubscript:idx];
    }
    @catch (NSException *exception) {
        [CrashAvoidManager noteErrorWithException:exception defaultToDo:AvoidCrashDefaultIgnore];
    }
    @finally {
        
    }
}


//=================================================================
//                    removeObjectAtIndex:
//=================================================================
#pragma mark - removeObjectAtIndex:

- (void)safeMethodRemoveObjectAtIndex:(NSUInteger)index {
    @try {
        [self safeMethodRemoveObjectAtIndex:index];
    }
    @catch (NSException *exception) {
        [CrashAvoidManager noteErrorWithException:exception defaultToDo:AvoidCrashDefaultIgnore];
    }
    @finally {
        
    }
}


//=================================================================
//                    insertObject:atIndex:
//=================================================================
#pragma mark - set方法
- (void)safeMethodInsertObject:(id)anObject atIndex:(NSUInteger)index {
    @try {
        [self safeMethodInsertObject:anObject atIndex:index];
    }
    @catch (NSException *exception) {
        [CrashAvoidManager noteErrorWithException:exception defaultToDo:AvoidCrashDefaultIgnore];
    }
    @finally {
        
    }
}


//=================================================================
//                           objectAtIndex:
//=================================================================
#pragma mark - objectAtIndex:

- (id)safeMethodObjectAtIndex:(NSUInteger)index {
    id object = nil;
    
    @try {
        object = [self safeMethodObjectAtIndex:index];
    }
    @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultReturnNil;
        [CrashAvoidManager noteErrorWithException:exception defaultToDo:defaultToDo];
    }
    @finally {
        return object;
    }
}

//=================================================================
//                     objectAtIndexedSubscript:
//=================================================================
#pragma mark - objectAtIndexedSubscript:
- (id)safeMethodObjectAtIndexedSubscript:(NSUInteger)idx {
    id object = nil;
    
    @try {
        object = [self safeMethodObjectAtIndexedSubscript:idx];
    }
    @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultReturnNil;
        [CrashAvoidManager noteErrorWithException:exception defaultToDo:defaultToDo];
    }
    @finally {
        return object;
    }
    
}


//=================================================================
//                         getObjects:range:
//=================================================================
#pragma mark - getObjects:range:

- (void)safeMethodGetObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
    
    @try {
        [self safeMethodGetObjects:objects range:range];
    } @catch (NSException *exception) {
        
        NSString *defaultToDo = AvoidCrashDefaultIgnore;
        [CrashAvoidManager noteErrorWithException:exception defaultToDo:defaultToDo];
        
    } @finally {
        
    }
}

@end
