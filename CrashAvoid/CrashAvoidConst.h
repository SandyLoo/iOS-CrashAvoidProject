//
//  CrashAvoidConst.h
//  Test
//
//  Created by lushuangqiang on 2018/7/9.
//  Copyright © 2018年 lushuangqiang. All rights reserved.
//


#ifndef CrashAvoidConst_h
#define CrashAvoidConst_h

#import "CrashAvoidManager.h"
#import <objc/runtime.h>


static NSString * const AvoidCrashDefaultReturnNil     = @"return nil to avoid crash.";
static NSString * const AvoidCrashDefaultIgnore        = @"ignore this operation to avoid crash.";
static NSString * const AvoidCrashSeparator            = @"================================================================";
static NSString * const AvoidCrashSeparatorWithFlag    = @"============================= Log===============================";

static NSString * const key_errorName        = @"errorName";
static NSString * const key_errorReason      = @"errorReason";
static NSString * const key_errorPlace       = @"errorPlace";
static NSString * const key_defaultToDo      = @"defaultToDo";
static NSString * const key_callStackSymbols = @"callStackSymbols";
static NSString * const key_exception        = @"exception";

#endif /* CrashAvoidConst_h */
