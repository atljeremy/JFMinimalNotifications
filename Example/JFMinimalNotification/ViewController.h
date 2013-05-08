//
//  ViewController.h
//  JFMinimalNotification
//
//  Created by Jeremy Fox on 5/4/13.
//  Copyright (c) 2013 Jeremy Fox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
- (IBAction)show:(id)sender;
- (IBAction)dismiss:(id)sender;
- (IBAction)setErrorStyle:(id)sender;
- (IBAction)setSuccessStyle:(id)sender;
- (IBAction)setDefaultStyle:(id)sender;
- (IBAction)setLeftView:(id)sender;
- (IBAction)setRightView:(id)sender;
- (IBAction)removeLeftView:(id)sender;
- (IBAction)removeRightView:(id)sender;

@end
