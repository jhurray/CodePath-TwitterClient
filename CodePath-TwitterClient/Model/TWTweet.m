//
//  TWTweet.m
//  CodePath-TwitterClient
//
//  Created by  Jeffrey Hurray on 1/22/17.
//  Copyright © 2017 Jeffrey Hurray. All rights reserved.
//

#import "TWTweet.h"
#import "TWBaseModel_Protected.h"

@interface TWTweet ()

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, assign) NSInteger favoriteCount;
@property (nonatomic, assign, getter=isFavorited) BOOL favorited;
@property (nonatomic, assign) NSInteger retweetCount;
@property (nonatomic, assign, getter=isRetweeted) BOOL retweeted;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) TWUser *user;
@property (nonatomic, strong) TWTweet *retweet;

@end

@implementation TWTweet

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        self.ID = TWString(@"id_str");
        self.createdAt = TWDate(@"created_at");
        self.favoriteCount = TWInteger(@"favorite_count");
        self.favorited = TWBool(@"favorited");
        self.retweetCount = TWInteger(@"retweet_count");
        self.retweeted = TWBool(@"retweeted");
        self.text = TWString(@"text");
        self.user = TWModel(@"user", TWUser);
        self.retweet = TWModel(@"retweeted_status", TWTweet);
    }
    return self;
}

@end
