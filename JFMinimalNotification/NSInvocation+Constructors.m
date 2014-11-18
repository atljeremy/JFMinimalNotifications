//
//  NSInvocation+Constructors.m
//  OO Design Patterns Practice
//
//  Created by Jeremy Fox on 6/12/14.
//  Copyright (c) 2014 RentPath, Inc. All rights reserved.
//

#import "NSInvocation+Constructors.h"
#import <objc/runtime.h>

@implementation NSInvocation (Constructors)

+ (id)invocationWithTarget:(NSObject*)target selector:(SEL)selector
{
    NSMethodSignature* sig = [target methodSignatureForSelector:selector];
    NSInvocation* inv = [NSInvocation invocationWithMethodSignature:sig];
    [inv setTarget:target];
    [inv setSelector:selector];
    return inv;
}

+ (id)invocationWithClass:(Class)targetClass instanceSelector:(SEL)selector
{
    Method method = class_getInstanceMethod(targetClass, selector);
    struct objc_method_description* desc = method_getDescription(method);
    if (desc == NULL || desc->name == NULL)
        return nil;
    
    NSMethodSignature* sig = [NSMethodSignature signatureWithObjCTypes:desc->types];
    NSInvocation* inv = [NSInvocation invocationWithMethodSignature:sig];
    [inv setSelector:selector];
    return inv;
}

+ (id)invocationWithClass:(Class)targetClass classSelector:(SEL)selector
{
    Method method = class_getClassMethod(targetClass, selector);
    struct objc_method_description* desc = method_getDescription(method);
    if (desc == NULL || desc->name == NULL)
        return nil;
    
    NSMethodSignature* sig = [NSMethodSignature signatureWithObjCTypes:desc->types];
    NSInvocation* inv = [NSInvocation invocationWithMethodSignature:sig];
    [inv setSelector:selector];
    return inv;
}

+ (id)invocationWithProtocol:(Protocol*)targetProtocol selector:(SEL)selector
{
    struct objc_method_description desc;
    BOOL required = YES;
    desc = protocol_getMethodDescription(targetProtocol, selector, required, YES);
    if (desc.name == NULL) {
        required = NO;
        desc = protocol_getMethodDescription(targetProtocol, selector, required, YES);
    }
    if (desc.name == NULL)
        return nil;
    
    NSMethodSignature* sig = [NSMethodSignature signatureWithObjCTypes:desc.types];
    NSInvocation* inv = [NSInvocation invocationWithMethodSignature:sig];
    [inv setSelector:selector];
    return inv;
}

@end
