//
//  TWTweetDetailViewController.h
//  CodePath-TwitterClient
//
//  Created by  Jeffrey Hurray on 1/31/17.
//  Copyright © 2017 Jeffrey Hurray. All rights reserved.
//

#import "TWBaseModuleViewController.h"

@class TWTweet;
@interface TWTweetDetailViewController : TWBaseModuleViewController

- (instancetype)initWithNavigationDelegate:(TWNavigationDelegate *)navigationDelegate tweet:(TWTweet *)tweet;

@end
