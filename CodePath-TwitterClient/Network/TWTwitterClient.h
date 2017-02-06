//
//  TWTwitterClient.h
//  CodePath-TwitterClient
//
//  Created by  Jeffrey Hurray on 1/18/17.
//  Copyright © 2017 Jeffrey Hurray. All rights reserved.
//

#import <BDBOAuth1Manager/BDBOAuth1SessionManager.h>
#import "TWTweet.h"

typedef NS_ENUM(NSInteger, TWTweetListType) {
    TWTweetListTypeHome,
    TWTweetListTypeTimeline,
    TWTweetListTypeMentions,
    TWTweetListTypeCustomUser,
};

@interface TWTwitterClient : BDBOAuth1SessionManager

+ (TWTwitterClient *)sharedInstance;

- (void)loginWithSuccessBlock:(void(^)())successBlock failureBlock:(void(^)(NSError *error))failureBlock;
- (void)openURL:(NSURL *)URL;
- (void)fetchTweetsWithType:(TWTweetListType)type userName:(NSString *)userName successBlock:(void(^)(NSArray<TWTweet *> *tweets))successBlock failureBlock:(void(^)(NSError *error))failureBlock;
- (void)postTweetWithStatus:(NSString *)status inReplyToTweet:(TWTweet *)tweet completion:(void(^)(TWTweet *tweet, NSError *error))completion;
- (void)retweetTweetWithID:(NSString *)ID completion:(void(^)(TWTweet *tweet, NSError *error))completion;
- (void)favoriteTweetWithID:(NSString *)ID completion:(void(^)(TWTweet *tweet, NSError *error))completion;
- (void)unretweetTweetWithID:(NSString *)ID completion:(void(^)(TWTweet *tweet, NSError *error))completion;
- (void)unfavoriteTweetWithID:(NSString *)ID completion:(void(^)(TWTweet *tweet, NSError *error))completion;

@end
