//
//  TWBaseViewController.m
//  CodePath-TwitterClient
//
//  Created by  Jeffrey Hurray on 1/30/17.
//  Copyright © 2017 Jeffrey Hurray. All rights reserved.
//

#import "TWBaseModuleViewController.h"

@interface TWBaseModuleViewController ()

@property (nonatomic, weak) TWNavigationDelegate *navigationDelegate;

@end

@implementation TWBaseModuleViewController

- (instancetype)initWithNavigationDelegate:(TWNavigationDelegate *)navigationDelegate
{
    self = [super initWithNibName:NSStringFromClass(self.class) bundle:nil];
    if (self) {
        self.navigationDelegate = navigationDelegate;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    return self;
}

@end
