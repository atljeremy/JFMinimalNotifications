//
//  NSInvocation+Constructors.h
//  OO Design Patterns Practice
//
//  Created by Jeremy Fox on 6/12/14.
//  Copyright (c) 2014 RentPath, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSInvocation (Constructors)

+ (id)invocationWithTarget:(NSObject*)target selector:(SEL)selector;
+ (id)invocationWithClass:(Class)targetClass instanceSelector:(SEL)selector;
+ (id)invocationWithClass:(Class)targetClass classSelector:(SEL)selector;
+ (id)invocationWithProtocol:(Protocol*)targetProtocol selector:(SEL)selector;

@end
