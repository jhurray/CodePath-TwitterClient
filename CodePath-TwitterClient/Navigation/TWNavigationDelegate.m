//
//  TWNavigationDelegate.m
//  CodePath-TwitterClient
//
//  Created by  Jeffrey Hurray on 1/30/17.
//  Copyright © 2017 Jeffrey Hurray. All rights reserved.
//

#import "TWNavigationDelegate.h"
#import "TWTweetListViewController.h"
#import "TWLoginViewController.h"
#import "TWNavigationMenuAnimator.h"
#import "TWNavigationMenuViewController.h"
#import "TWTweetComposeViewController.h"
#import "TWTwitterClient.h"
#import "TWProfileViewController.h"
#import "TWTweetDetailViewController.h"

@interface TWNavigationDelegate () <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) TWNavigationMenuAnimator *menuAnimator;
@property (nonatomic, strong) NSMapTable<NSNumber *, UIViewController *> *moduleToViewControllerMapping;

@end

@implementation TWNavigationDelegate

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.moduleToViewControllerMapping = [NSMapTable mapTableWithKeyOptions:NSMapTableCopyIn valueOptions:NSMapTableStrongMemory];
        [self setupNavigationBarAppearance];
        self.navigationController = [[UINavigationController alloc] init];
        self.menuAnimator = [[TWNavigationMenuAnimator alloc] init];
        TWNavigationModule module = [TWTwitterClient sharedInstance].isAuthorized ? TWNavigationModuleHome : TWNavigationModuleLogin;
        [self showModule:module animated:NO completion:nil];
    }
    return self;
}


- (void)setupNavigationBarAppearance
{
    UIColor *color = [UIColor colorWithRed:0.00 green:0.67 blue:0.93 alpha:1.0];
    [[UINavigationBar appearance] setTintColor:color];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName:color
                                                           }];
}


- (UIViewController *)currentViewController
{
    return self.navigationController.topViewController;
}


- (UIViewController *)rootViewController
{
    return self.navigationController.viewControllers[0];
}


- (void)showModule:(TWNavigationModule)module animated:(BOOL)animated completion:(void(^)())completion
{
    UIViewController *viewController = [self.moduleToViewControllerMapping objectForKey:@(module)];
    
    if (!viewController) {
        switch (module) {
            case TWNavigationModuleHome:
                viewController = [[TWTweetListViewController alloc] initWithNavigationDelegate:self type:TWTweetListTypeHome userName:nil];
                viewController.title = @"Home";
                break;
            case TWNavigationModuleTimeline:
                viewController = [[TWTweetListViewController alloc] initWithNavigationDelegate:self type:TWTweetListTypeTimeline userName:nil];
                viewController.title = @"Timeline";
                break;
            case TWNavigationModuleProfile:
                viewController = [[TWProfileViewController alloc] initWithNavigationDelegate:self user:[TWUser currentUser]];
                viewController.title = @"Profile";
                break;
            case TWNavigationModuleBieber:
                viewController = [[TWTweetListViewController alloc] initWithNavigationDelegate:self type:TWTweetListTypeCustomUser userName:@"justinbieber"];
                viewController.title = @"Bieber";
                break;
            case TWNavigationModuleMentions:
                viewController = [[TWTweetListViewController alloc] initWithNavigationDelegate:self type:TWTweetListTypeMentions userName:nil];
                viewController.title = @"Mentions";
                break;
            case TWNavigationModuleLogin:
                viewController = [[TWLoginViewController alloc] initWithNavigationDelegate:self];
                viewController.title = @"Log In";
                [[TWTwitterClient sharedInstance] deauthorize];
                break;
            default:
                break;
        }
        
        if (module != TWNavigationModuleLogin) {
            viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(showSidebar)];
            [self addComposeButtonToViewController:viewController];
        }
        [self.moduleToViewControllerMapping setObject:viewController forKey:@(module)];
    }
    
    self.navigationController.viewControllers = @[viewController];
}


- (void)addComposeButtonToViewController:(UIViewController *)viewController
{
    UIButton *composeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    composeButton.frame = CGRectMake(0, 0, 44, 44);
    [composeButton addTarget:self action:@selector(showCompose) forControlEvents:UIControlEventTouchUpInside];
    [composeButton setImage:[UIImage imageNamed:@"edit-icon"] forState:UIControlStateNormal];
    viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:composeButton];
}


- (void)showCompose
{
    [self showComposeWithRetweet:nil];
}


- (void)showSidebar
{
    TWNavigationMenuViewController *menuViewController = [[TWNavigationMenuViewController alloc] initWithNavigationDelegate:self];
    menuViewController.transitioningDelegate = self;
    menuViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self.navigationController presentViewController:menuViewController animated:YES completion:nil];
}


- (void)showUser:(TWUser *)user
{
    TWProfileViewController *viewController = [[TWProfileViewController alloc] initWithNavigationDelegate:self user:user];
    viewController.title = user.handle;
    [self addComposeButtonToViewController:viewController];
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)showTweet:(TWTweet *)tweet
{
    TWTweetDetailViewController *viewController = [[TWTweetDetailViewController alloc] initWithNavigationDelegate:self tweet:tweet];
    viewController.title = tweet.user.handle;
    [self addComposeButtonToViewController:viewController];
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)showComposeWithRetweet:(TWTweet *)retweet
{
    TWTweetComposeViewController *composeViewController = [[TWTweetComposeViewController alloc] initWithNavigationDelegate:self];
    composeViewController.retweet = retweet;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:composeViewController];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}


#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self.menuAnimator;
}


- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self.menuAnimator;
}

@end
