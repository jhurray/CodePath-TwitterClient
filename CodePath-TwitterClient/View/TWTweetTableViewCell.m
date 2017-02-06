//
//  TWTweetTableViewCell.m
//  CodePath-TwitterClient
//
//  Created by  Jeffrey Hurray on 1/29/17.
//  Copyright © 2017 Jeffrey Hurray. All rights reserved.
//

#import "TWTweetTableViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "NSDate+TWUtil.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "TWTweetButtonTrayManager.h"

@interface TWTweetTableViewCell () <TWTweetButtonTray, TWTweetButtonTrayManagerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *retweetedByLabel;
@property (nonatomic, strong) TWTweetButtonTrayManager *buttonManager;

@end

@implementation TWTweetTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.profileImageView.layer.cornerRadius = 8;
    [self.profileImageView bk_whenTapped:^{
        [self.delegate tweetTableViewCellProfileImageSelected:self];
    }];
    self.buttonManager = [[TWTweetButtonTrayManager alloc] initWithTweetButtonTray:self];
    self.buttonManager.delegate = self;
}


- (void)reloadData
{
    [self.profileImageView setImageWithURL:self.model.user.profileImageURL];
    self.nameLabel.text = self.model.user.name;
    self.handleLabel.text = self.model.user.handle;
    self.timestampLabel.text = self.model.createdAt.tw_relativePastShortString;
    self.contentLabel.text = self.model.text;
    self.retweetedByLabel.text = [NSString stringWithFormat:@"%@ retweeted", self.model.retweet.user.name];
    BOOL showRetweeted = (self.model.retweet != nil);
    self.retweetHeightConstraint.constant = showRetweeted ? 24 : 0;
    [self.buttonManager reloadData];
    [self setNeedsUpdateConstraints];
}


#pragma mark - TWTweetButtonTray
- (TWTweet *)tweet
{
    return self.model;
}


- (void)tweetButtonTrayReplySelected:(TWTweet *)tweet
{
    [self.delegate tweetTableViewCellReplySelected:self];
}


- (void)tweetButtonTrayRetweetSelected:(TWTweet *)tweet
{
    [self.delegate tweetTableViewCellRetweetSelected:self];
}


- (void)tweetButtonTrayFavoriteSelected:(TWTweet *)tweet
{
    [self.delegate tweetTableViewCellFavoriteSelected:self];
}

@end
