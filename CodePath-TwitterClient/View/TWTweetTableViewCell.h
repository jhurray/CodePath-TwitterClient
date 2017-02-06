//
//  TWTweetTableViewCell.h
//  CodePath-TwitterClient
//
//  Created by  Jeffrey Hurray on 1/29/17.
//  Copyright © 2017 Jeffrey Hurray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWTweet.h"

@class TWTweetTableViewCell;
@protocol TWTweetTableViewCellDelegate <NSObject>

- (void)tweetTableViewCellProfileImageSelected:(TWTweetTableViewCell *)cell;
- (void)tweetTableViewCellReplySelected:(TWTweetTableViewCell *)cell;
- (void)tweetTableViewCellRetweetSelected:(TWTweetTableViewCell *)cell;
- (void)tweetTableViewCellFavoriteSelected:(TWTweetTableViewCell *)cell;

@end

@interface TWTweetTableViewCell : UITableViewCell

@property (nonatomic, strong) TWTweet *model;
@property (nonatomic, weak) id<TWTweetTableViewCellDelegate> delegate;

- (void)reloadData;

@end
