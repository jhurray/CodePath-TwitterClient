//
//  TWProfileViewController.h
//  CodePath-TwitterClient
//
//  Created by  Jeffrey Hurray on 1/31/17.
//  Copyright © 2017 Jeffrey Hurray. All rights reserved.
//

#import "TWBaseModuleViewController.h"
#import "TWUser.h"

@interface TWProfileViewController : TWBaseModuleViewController

- (instancetype)initWithNavigationDelegate:(TWNavigationDelegate *)navigationDelegate user:(TWUser *)user;

@end
