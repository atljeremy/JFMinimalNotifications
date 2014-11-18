//
//  JFMinimalNotificationArt.h
//  JFMinimalNotification
//
//  Created by Jeremy Fox on 11/17/14.
//  Copyright (c) 2014 Jeremy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFMinimalNotificationArt : NSObject

+ (UIImage*)imageOfCheckmarkWithColor:(UIColor*)color;

+ (UIImage*)imageOfCrossWithColor:(UIColor*)color;

+ (UIImage*)imageOfNoticeWithColor:(UIColor*)color;

+ (UIImage*)imageOfWarningWithColor:(UIColor*)color;

+ (UIImage*)imageOfInfoWithColor:(UIColor*)color;

+ (UIImage*)imageOfEditWithColor:(UIColor*)color;

+ (void)drawCheckmarkWithColor:(UIColor*)color;

+ (void)drawCrossWithColor:(UIColor*)color;

+ (void)drawNoticeWithColor:(UIColor*)color;

+ (void)drawWarningWithColor:(UIColor*)color;

+ (void)drawInfoWithColor:(UIColor*)color;

+ (void)drawEditWithColor:(UIColor*)color;

@end
