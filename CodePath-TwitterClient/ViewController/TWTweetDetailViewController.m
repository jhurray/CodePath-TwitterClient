//
//  TWTweetDetailViewController.m
//  CodePath-TwitterClient
//
//  Created by  Jeffrey Hurray on 1/31/17.
//  Copyright © 2017 Jeffrey Hurray. All rights reserved.
//

#import "TWTweetDetailViewController.h"
#import "TWTweet.h"
#import "TWTweetButtonTrayManager.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "NSDate+TWUtil.h"
#import "TWTwitterClient.h"
#import "UIAlertController+TWUtil.h"
#import <BlocksKit/UIView+BlocksKit.h>

@interface TWTweetDetailViewController () <TWTweetButtonTray, TWTweetButtonTrayManagerDelegate>

@property (nonatomic, strong) TWTweet *model;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetContentView;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetHeightConstraint;
@property (nonatomic, strong) TWTweetButtonTrayManager *buttonManager;
@property (nonatomic, copy) void(^tweetActionCompletion)(TWTweet *, NSError *);

@end

@implementation TWTweetDetailViewController

- (instancetype)initWithNavigationDelegate:(TWNavigationDelegate *)navigationDelegate tweet:(TWTweet *)tweet
{
    self = [super initWithNavigationDelegate:navigationDelegate];
    if (self) {
        self.model = tweet;
        
        __typeof(self) __weak weakSelf = self;
        self.tweetActionCompletion = ^(TWTweet *tweet, NSError *error) {
            if (!error) {
                weakSelf.model = tweet;
                [weakSelf reloadData];
            }
            else {
                [UIAlertController showGenericErrorFromViewController:weakSelf];
            }
        };
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.imageView bk_whenTapped:^{
        [self.navigationDelegate showUser:self.tweet.user];
    }];
    
    self.buttonManager = [[TWTweetButtonTrayManager alloc] initWithTweetButtonTray:self];
    self.buttonManager.delegate = self;
    [self reloadData];
}


- (void)reloadData
{
    [self.imageView setImageWithURL:self.model.user.profileImageURL];
    self.nameLabel.text = self.model.user.name;
    self.handleLabel.text = self.model.user.handle;
    self.timestampLabel.text = self.model.createdAt.tw_longTimestampString;
    self.tweetContentView.text = self.model.text;
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%ld favorites", self.model.favoriteCount];
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%ld retweets", self.model.retweetCount];
    self.retweetLabel.text = [NSString stringWithFormat:@"%@ retweeted", self.model.retweet.user.name];
    BOOL showRetweeted = (self.model.retweet != nil);
    self.retweetHeightConstraint.constant = showRetweeted ? 24 : 0;
    [self.buttonManager reloadData];
}


#pragma mark - TWTweetButtonTray
- (TWTweet *)tweet
{
    return self.model;
}


- (void)tweetButtonTrayReplySelected:(TWTweet *)tweet
{
    [self.navigationDelegate showComposeWithRetweet:tweet];
}


- (void)tweetButtonTrayRetweetSelected:(TWTweet *)tweet
{
    if (tweet.isRetweeted) {
        [[TWTwitterClient sharedInstance] unretweetTweetWithID:tweet.ID completion:self.tweetActionCompletion];
    }
    else {
        [[TWTwitterClient sharedInstance] retweetTweetWithID:tweet.ID completion:self.tweetActionCompletion];
    }
}


- (void)tweetButtonTrayFavoriteSelected:(TWTweet *)tweet
{
    if (tweet.isFavorited) {
        [[TWTwitterClient sharedInstance] unfavoriteTweetWithID:tweet.ID completion:self.tweetActionCompletion];
    }
    else {
        [[TWTwitterClient sharedInstance] favoriteTweetWithID:tweet.ID completion:self.tweetActionCompletion];
    }
}

@end
