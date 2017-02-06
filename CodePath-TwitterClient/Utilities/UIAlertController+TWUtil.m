//
//  UIAlertController+TWUtil.m
//  CodePath-TwitterClient
//
//  Created by  Jeffrey Hurray on 1/30/17.
//  Copyright © 2017 Jeffrey Hurray. All rights reserved.
//

#import "UIAlertController+TWUtil.h"

@implementation UIAlertController (TWUtil)

+ (void)showGenericErrorFromViewController:(UIViewController *)viewController
{
    [self showErroWithMessage:@"Something went wrong 😱" viewController:viewController];
}


+ (void)showErroWithMessage:(NSString *)message viewController:(UIViewController *)viewController
{
    NSCParameterAssert(viewController != nil);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"👍" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // Do nothing
    }];
    [alert addAction:action];
    [viewController presentViewController:alert animated:YES completion:nil];
}

@end
