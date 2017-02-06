//
//  TWTweetListViewController.h
//  CodePath-TwitterClient
//
//  Created by  Jeffrey Hurray on 1/29/17.
//  Copyright © 2017 Jeffrey Hurray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWBaseModuleViewController.h"
#import "TWTwitterClient.h"

@interface TWTweetListViewController : TWBaseModuleViewController

- (instancetype)initWithNavigationDelegate:(TWNavigationDelegate *)navigationDelegate type:(TWTweetListType)type userName:(NSString *)userName;

@property (nonatomic, assign) BOOL disableProfileNavigation;

@end
