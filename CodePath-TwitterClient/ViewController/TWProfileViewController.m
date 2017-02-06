//
//  TWProfileViewController.m
//  CodePath-TwitterClient
//
//  Created by  Jeffrey Hurray on 1/31/17.
//  Copyright © 2017 Jeffrey Hurray. All rights reserved.
//

#import "TWProfileViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "TWTweetListViewController.h"

@interface TWProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *tweetsLabel;

@property (nonatomic, strong) TWUser *user;

@end

@implementation TWProfileViewController

- (instancetype)initWithNavigationDelegate:(TWNavigationDelegate *)navigationDelegate user:(TWUser *)user
{
    self = [super initWithNavigationDelegate:navigationDelegate];
    if (self) {
        self.user = user;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    TWUser *user = self.user;
    [self.backgroundImageView setImageWithURL:user.profileBackgroundImageURL];
    [self.profileImageView setImageWithURL:user.profileImageURL];
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.nameLabel.text = user.name;
    self.handleLabel.text = user.handle;
    self.followersLabel.text = [NSString stringWithFormat:@"%ld followers", user.followersCount];
    self.followingLabel.text = [NSString stringWithFormat:@"%ld following", user.friendsCount];
    self.tweetsLabel.text = [NSString stringWithFormat:@"%ld tweets", user.tweetCount];
    
    TWTweetListViewController *viewController = [[TWTweetListViewController alloc] initWithNavigationDelegate:self.navigationDelegate type:TWTweetListTypeCustomUser userName:user.screenName];
    viewController.disableProfileNavigation = YES;
    [viewController beginAppearanceTransition:YES animated:NO];
    viewController.view.frame = self.containerView.bounds;
    [self addChildViewController:viewController];
    [self.containerView addSubview:viewController.view];
    [viewController endAppearanceTransition];
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    for (UIViewController *viewController in self.childViewControllers) {
        viewController.view.frame = self.containerView.bounds;
    }
}

@end
