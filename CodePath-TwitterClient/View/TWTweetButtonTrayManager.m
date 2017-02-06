//
//  TWTweetButtonTrayManager.m
//  CodePath-TwitterClient
//
//  Created by  Jeffrey Hurray on 2/2/17.
//  Copyright © 2017 Jeffrey Hurray. All rights reserved.
//

#import "TWTweetButtonTrayManager.h"
#import <BlocksKit/UIControl+BlocksKit.h>
#import "TWTweet.h"

@interface TWTweetButtonTrayManager ()

// Expectation is that button tray will be held strongly
// Weak to avoid reference cycles
@property (nonatomic, weak) id<TWTweetButtonTray> buttonTray;
@property (nonatomic, readonly) TWTweet *tweet;

@end

@implementation TWTweetButtonTrayManager

- (instancetype)initWithTweetButtonTray:(id<TWTweetButtonTray>)buttonTray
{
    self = [super init];
    if (self) {
        self.buttonTray = buttonTray;
        [[self.buttonTray retweetButton] bk_addEventHandler:^(id sender) {
            [self onRetweet];
        } forControlEvents:UIControlEventTouchUpInside];
        [[self.buttonTray replyButton] bk_addEventHandler:^(id sender) {
            [self onReply];
        } forControlEvents:UIControlEventTouchUpInside];
        [[self.buttonTray favoriteButton] bk_addEventHandler:^(id sender) {
            [self onFavorite];
        } forControlEvents:UIControlEventTouchUpInside];
        [self reloadData];
    }
    return self;
}


- (TWTweet *)tweet
{
    return self.buttonTray.tweet;
}


- (void)onReply
{
    [self.delegate tweetButtonTrayReplySelected:self.tweet];
}


- (void)onRetweet
{
    [self.delegate tweetButtonTrayRetweetSelected:self.tweet];
}


- (void)onFavorite
{
    [self.delegate tweetButtonTrayFavoriteSelected:self.tweet];
}


- (void)reloadData
{
    UIImage *favoriteImage = [UIImage imageNamed:(self.tweet.isFavorited ? @"favor-icon-red" : @"favor-icon")];
    UIImage *retweetImage = [UIImage imageNamed:(self.tweet.isRetweeted ? @"retweet-icon-green" : @"retweet-icon")];
    UIImage *replyImage = [UIImage imageNamed:@"reply-icon"];
    
    [self styleButton:self.buttonTray.replyButton text:nil image:replyImage];
    [self styleButton:self.buttonTray.retweetButton text:@(self.tweet.retweetCount).stringValue image:retweetImage];
    [self styleButton:self.buttonTray.favoriteButton text:@(self.tweet.favoriteCount).stringValue image:favoriteImage];
}


- (void)styleButton:(UIButton *)button text:(NSString *)text image:(UIImage *)image
{
    if (image) {
        [button setImage:image forState:UIControlStateNormal];
    }
    if (text) {
        [button setTitle:text forState:UIControlStateNormal];
        button.titleLabel.textColor = [UIColor grayColor];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
    }
}


@end
