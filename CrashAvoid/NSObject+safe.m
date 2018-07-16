//
//  NSObject+safe.m
//  Test
//
//  Created by lushuangqiang on 2018/7/9.
//  Copyright © 2018年 lushuangqiang. All rights reserved.
//safeMethod

#import "NSObject+safe.h"
#import "CrashAvoidConst.h"

@implementation NSObject (safe)
+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //valueForKey:
        
        [CrashAvoidManager exchangeClassMethod:[self class] method1Sel:@selector(valueForKey:) method2Sel:@selector(safeMethodValueForKey:)];
        
        //setValue:forKey:
        [CrashAvoidManager exchangeInstanceMethod:[self class] method1Sel:@selector(setValue:forKey:) method2Sel:@selector(safeMethodSetValue:forKey:)];
        
        //setValue:forKeyPath:
        [CrashAvoidManager exchangeInstanceMethod:[self class] method1Sel:@selector(setValue:forKeyPath:) method2Sel:@selector(safeMethodSetValue:forKeyPath:)];
        
        //setValue:forUndefinedKey:
        [CrashAvoidManager exchangeInstanceMethod:[self class] method1Sel:@selector(setValue:forUndefinedKey:) method2Sel:@selector(safeMethodSetValue:forUndefinedKey:)];
        
        //setValuesForKeysWithDictionary:
        [CrashAvoidManager exchangeInstanceMethod:[self class] method1Sel:@selector(setValuesForKeysWithDictionary:) method2Sel:@selector(safeMethodSetValuesForKeysWithDictionary:)];
        
        //unreconized selector
        [CrashAvoidManager exchangeInstanceMethod:[self class] method1Sel:@selector(forwardingTargetForSelector:) method2Sel:@selector(safeMethodforwardingTargetForSelector:)];
        
    });
}


//=================================================================
//                     unreconized selector
//=================================================================

//方法一
-(id)safeMethodforwardingTargetForSelector:(SEL)aSelector
{
    
    NSString *selectorStr = NSStringFromSelector(aSelector);
    // 做一次类的判断，只对 UIResponder有效,这个地方可以根据情况自己改，最好不要写成NSObject，因为系统的某些方法也会走这里
    if ([[self class] isSubclassOfClass: NSClassFromString(@"UIResponder")])
    {
        NSString * name = @"NSInvalidArgumentException";
        NSString * reason = [NSString stringWithFormat:@"PROTECTOR: -[%@ %@]", [self class], selectorStr];
        NSString * info = [NSString stringWithFormat:@"PROTECTOR: unrecognized selector \"%@\" sent to instance: %p", selectorStr, self];
        
        NSException * exception = [NSException exceptionWithName:name reason:reason userInfo:@{@"info":info}];
        NSString *defaultToDo = AvoidCrashDefaultIgnore;
        [CrashAvoidManager noteErrorWithException:exception defaultToDo:defaultToDo];
        
        // 对保护器插入该方法的实现
        Class protectorCls = NSClassFromString(@"Protector");
        if (!protectorCls)
        {
            protectorCls = objc_allocateClassPair([NSObject class], "Protector", 0);
            objc_registerClassPair(protectorCls);
        }
        
        // 检查类中是否存在该方法，不存在则添加
        if (![self isExistSelector:aSelector inClass:protectorCls])
        {
            class_addMethod(protectorCls, aSelector, [self safeImplementation:aSelector],
                            [selectorStr UTF8String]);
        }
        
        Class Protector = [protectorCls class];
        id instance = [[Protector alloc] init];
        
        return instance;
    }
    else
    {
        return [self safeMethodforwardingTargetForSelector:aSelector];
    }
}

// 判断某个class中是否存在某个SEL
- (BOOL)isExistSelector: (SEL)aSelector inClass:(Class)currentClass
{
    BOOL isExist = NO;
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(currentClass, &methodCount);
    
    for (int i = 0; i < methodCount; i++)
    {
        Method temp = methods[i];
        SEL sel = method_getName(temp);
        NSString *methodName = NSStringFromSelector(sel);
        if ([methodName isEqualToString: NSStringFromSelector(aSelector)])
        {
            isExist = YES;
            break;
        }
    }
    return isExist;
}


// 一个安全的方法实现
- (IMP)safeImplementation:(SEL)aSelector
{
    IMP imp = imp_implementationWithBlock(^()
                                          
    {
        
        NSLog(@"PROTECTOR: %@ Done", NSStringFromSelector(aSelector));
        
    });
    return imp;
}





//方法二  （这个方法由于消息已经走到了 safeMethodForwardInvocation， 对性能消耗较大，不建议使用）
// [CrashAvoidManager exchangeInstanceMethod:[self class] method1Sel:@selector(methodSignatureForSelector:) method2Sel:@selector(safeMethodMethodSignatureForSelector:)];
// [CrashAvoidManager exchangeInstanceMethod:[self class] method1Sel:@selector(forwardInvocation:) method2Sel:@selector(safeMethodForwardInvocation:)];

//-(void)exampleMethod{}
//
//- (NSMethodSignature *)safeMethodMethodSignatureForSelector:(SEL)aSelector {
//
//    NSMethodSignature *ms = [self safeMethodMethodSignatureForSelector:aSelector];
//
//    if (ms == nil) {
//        if ([self isKindOfClass:NSClassFromString(@"UIResponder")]) {
//            ms = [[self class] instanceMethodSignatureForSelector:@selector(exampleMethod)];
//        }
//    }
//    return ms;
//}
//
//
//- (void)safeMethodForwardInvocation:(NSInvocation *)anInvocation {
//
//    @try {
//        [self safeMethodForwardInvocation:anInvocation];
//
//    } @catch (NSException *exception) {
//        NSString *defaultToDo = AvoidCrashDefaultIgnore;
//        [CrashAvoidManager noteErrorWithException:exception defaultToDo:defaultToDo];
//
//    } @finally {
//
//    }
//}


//=================================================================
//                         valueForKey:
//=================================================================

-(nullable id)safeMethodValueForKey:(NSString *)key
{
    id object = nil;
    @try {
        object = [self safeMethodValueForKey:key];
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
//                         setValue:forKey:
//=================================================================
#pragma mark - setValue:forKey:

- (void)safeMethodSetValue:(id)value forKey:(NSString *)key {
    @try {
        [self safeMethodSetValue:value forKey:key];
    }
    @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultIgnore;
        [CrashAvoidManager noteErrorWithException:exception defaultToDo:defaultToDo];
    }
    @finally {
        
    }
}


//=================================================================
//                     setValue:forKeyPath:
//=================================================================
#pragma mark - setValue:forKeyPath:

- (void)safeMethodSetValue:(id)value forKeyPath:(NSString *)keyPath {
    @try {
        [self safeMethodSetValue:value forKeyPath:keyPath];
    }
    @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultIgnore;
        [CrashAvoidManager noteErrorWithException:exception defaultToDo:defaultToDo];
    }
    @finally {
        
    }
}



//=================================================================
//                     setValue:forUndefinedKey:
//=================================================================
#pragma mark - setValue:forUndefinedKey:

- (void)safeMethodSetValue:(id)value forUndefinedKey:(NSString *)key {
    @try {
        [self safeMethodSetValue:value forUndefinedKey:key];
    }
    @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultIgnore;
        [CrashAvoidManager noteErrorWithException:exception defaultToDo:defaultToDo];
    }
    @finally {
        
    }
}


//=================================================================
//                  setValuesForKeysWithDictionary:
//=================================================================
#pragma mark - setValuesForKeysWithDictionary:

- (void)safeMethodSetValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues {
    @try {
        [self safeMethodSetValuesForKeysWithDictionary:keyedValues];
    }
    @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultIgnore;
        [CrashAvoidManager noteErrorWithException:exception defaultToDo:defaultToDo];
    }
    @finally {
        
    }
}

@end

