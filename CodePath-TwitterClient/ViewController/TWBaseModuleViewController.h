//
//  TWBaseViewController.h
//  CodePath-TwitterClient
//
//  Created by  Jeffrey Hurray on 1/30/17.
//  Copyright © 2017 Jeffrey Hurray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWNavigationDelegate.h"

@interface TWBaseModuleViewController : UIViewController

- (instancetype)initWithNavigationDelegate:(TWNavigationDelegate *)navigationDelegate;

@property (nonatomic, weak, readonly) TWNavigationDelegate *navigationDelegate;

@end
