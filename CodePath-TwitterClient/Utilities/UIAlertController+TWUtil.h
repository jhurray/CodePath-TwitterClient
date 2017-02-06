//
//  UIAlertController+TWUtil.h
//  CodePath-TwitterClient
//
//  Created by  Jeffrey Hurray on 1/30/17.
//  Copyright © 2017 Jeffrey Hurray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (TWUtil)

+ (void)showGenericErrorFromViewController:(UIViewController *)viewController;
+ (void)showErroWithMessage:(NSString *)message viewController:(UIViewController *)viewController;

@end
