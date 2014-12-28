/*
 * NSInvocation+Constructors
 *
 * Created by Jeremy Fox on 5/4/13.
 * Copyright (c) 2013 Jeremy Fox. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

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
