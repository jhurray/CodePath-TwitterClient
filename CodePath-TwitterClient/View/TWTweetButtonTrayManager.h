//
//  TWTweetButtonTrayManager.h
//  CodePath-TwitterClient
//
//  Created by  Jeffrey Hurray on 2/2/17.
//  Copyright © 2017 Jeffrey Hurray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TWTweet;
@protocol TWTweetButtonTray <NSObject>

@property (nonatomic, weak, readonly) UIButton *replyButton;
@property (nonatomic, weak, readonly) UIButton *retweetButton;
@property (nonatomic, weak, readonly) UIButton *favoriteButton;
@property (nonatomic, readonly) TWTweet *tweet;

@end

@protocol TWTweetButtonTrayManagerDelegate <NSObject>

- (void)tweetButtonTrayReplySelected:(TWTweet *)tweet;
- (void)tweetButtonTrayRetweetSelected:(TWTweet *)tweet;
- (void)tweetButtonTrayFavoriteSelected:(TWTweet *)tweet;

@end

@interface TWTweetButtonTrayManager : NSObject

@property (nonatomic, weak) id<TWTweetButtonTrayManagerDelegate> delegate;

- (instancetype)initWithTweetButtonTray:(id<TWTweetButtonTray>)buttonTray;

- (void)reloadData;

@end
