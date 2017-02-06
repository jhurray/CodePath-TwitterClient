//
//  TWNavigationDelegate.h
//  CodePath-TwitterClient
//
//  Created by  Jeffrey Hurray on 1/30/17.
//  Copyright © 2017 Jeffrey Hurray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TWNavigationModule) {
    TWNavigationModuleHome,
    TWNavigationModuleTimeline,
    TWNavigationModuleMentions,
    TWNavigationModuleBieber,
    TWNavigationModuleProfile,
    TWNavigationModuleLogin,
    TWNavigationModuleCount,
    
};

@class TWUser, TWTweet;

@interface TWNavigationDelegate : NSObject

@property (nonatomic, strong, readonly) UINavigationController *navigationController;
@property (nonatomic, readonly) UIViewController *rootViewController;
@property (nonatomic, readonly) UIViewController *currentViewController;

- (void)showModule:(TWNavigationModule)module animated:(BOOL)animated completion:(void(^)())completion;
- (void)showUser:(TWUser *)user;
- (void)showTweet:(TWTweet *)tweet;
- (void)showComposeWithRetweet:(TWTweet *)retweet;

@end
