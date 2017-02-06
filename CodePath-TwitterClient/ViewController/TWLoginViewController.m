//
//  TWLoginViewController.m
//  CodePath-TwitterClient
//
//  Created by  Jeffrey Hurray on 1/18/17.
//  Copyright © 2017 Jeffrey Hurray. All rights reserved.
//

#import "TWLoginViewController.h"
#import "TWTwitterClient.h"

@interface TWLoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation TWLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginButton.layer.cornerRadius = 8;
    self.loginButton.clipsToBounds = YES;
}


- (IBAction)loginButtonSelected:(id)sender
{
    [[TWTwitterClient sharedInstance] loginWithSuccessBlock:^{
        NSLog(@"Login Success");
        [self.navigationDelegate showModule:TWNavigationModuleHome animated:YES completion:nil];
    } failureBlock:^(NSError *error) {
        NSLog(@"Login Error");
    }];
}

@end
