//
//  TWTweet.h
//  CodePath-TwitterClient
//
//  Created by  Jeffrey Hurray on 1/22/17.
//  Copyright © 2017 Jeffrey Hurray. All rights reserved.
//

#import "TWBaseModel.h"
#import "TWUser.h"

@interface TWTweet : TWBaseModel

@property (nonatomic, copy, readonly) NSString *ID;
@property (nonatomic, strong, readonly) NSDate *createdAt;
@property (nonatomic, assign, readonly) NSInteger favoriteCount;
@property (nonatomic, assign, getter=isFavorited, readonly) BOOL favorited;
@property (nonatomic, assign, readonly) NSInteger retweetCount;
@property (nonatomic, assign, getter=isRetweeted, readonly) BOOL retweeted;
@property (nonatomic, copy, readonly) NSString *text;
@property (nonatomic, strong, readonly) TWUser *user;
@property (nonatomic, strong, readonly) TWTweet *retweet;

@end
