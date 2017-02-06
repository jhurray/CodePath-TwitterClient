//
//  TWTwitterClient.m
//  CodePath-TwitterClient
//
//  Created by  Jeffrey Hurray on 1/18/17.
//  Copyright © 2017 Jeffrey Hurray. All rights reserved.
//

#import "TWTwitterClient.h"

#define kBaseURL @"https://api.twitter.com"
#define kConsumerSecret @"wVs3IvP6ZvlYuFh5Ap4ZcRJYtzITRGat1k6GQMZA15FRg5sqqK"
#define kConsumerKey @"j4xxHFfXovCFHzBlUY6Eydwfg"
#define kGet @"GET"
#define kPost @"POST"
#define kCallbackURL [NSURL URLWithString:@"cptwitterdemo://oauth"]

@interface TWTwitterClient ()

@property (nonatomic, copy) void(^onLoginSuccessBlock)();
@property (nonatomic, copy) void(^onLoginFailureBlock)();

@end

@implementation TWTwitterClient

+ (TWTwitterClient *)sharedInstance
{
    static TWTwitterClient *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TWTwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL] consumerKey:kConsumerKey consumerSecret:kConsumerSecret];
    });
    return instance;
}


- (void)loginWithSuccessBlock:(void(^)())successBlock failureBlock:(void(^)(NSError *error))failureBlock
{
    self.onLoginSuccessBlock = successBlock;
    self.onLoginFailureBlock = failureBlock;
    if (self.isAuthorized) {
        if (self.onLoginSuccessBlock) {
            self.onLoginSuccessBlock();
        }
    }
    else {
        [self fetchRequestTokenWithSuccessBlock:nil failureBlock:self.onLoginFailureBlock];
    }
}


- (void)openURL:(NSURL *)URL
{
    [self fetchAccessTokenFromURL:URL successBlock:^{
        
        if (self.onLoginSuccessBlock) {
            self.onLoginSuccessBlock();
        }
        
    } failureBlock:self.onLoginFailureBlock];
}


- (void)verifyCredentialsWithCompletion:(void(^)(TWUser *user))completion
{
    [self getWithPath:@"1.1/account/verify_credentials.json" parameters:nil successBlock:^(id responseObject) {
        NSDictionary *userDictionary = responseObject;
        TWUser *user = [[TWUser alloc] initWithDictionary:userDictionary];
        [TWUser setCurrentUser:user];
        if (completion) {
            completion(user);
        }
    } failureBlock:^(NSError *error) {
        if (completion) {
            completion(nil);
        }
    }];
}


- (void)fetchTweetsWithType:(TWTweetListType)type userName:(NSString *)userName successBlock:(void(^)(NSArray<TWTweet *> *tweets))successBlock failureBlock:(void(^)(NSError *error))failureBlock
{
    NSString *path;
    switch (type) {
        case TWTweetListTypeTimeline:
            path = @"/1.1/statuses/user_timeline.json";
            break;
        case TWTweetListTypeMentions:
            path = @"1.1/statuses/mentions_timeline.json";
            break;
        case TWTweetListTypeCustomUser:
            path = [NSString stringWithFormat:@"/1.1/statuses/user_timeline.json?screen_name=%@", userName];
            break;
        case TWTweetListTypeHome:
            path = @"/1.1/statuses/home_timeline.json?count=200";
            break;
        default:
            break;
    }
    
    [self getWithPath:path parameters:nil successBlock:^(id responseObject) {
        NSArray<TWTweet *> *tweets = [TWTweet listWithDictionaries:responseObject];
        if (successBlock) {
            successBlock(tweets);
        }
    } failureBlock:failureBlock];
}


- (void)postTweetWithStatus:(NSString *)status inReplyToTweet:(TWTweet *)tweet completion:(void (^)(TWTweet *, NSError *))completion
{
    NSParameterAssert(status != nil);
    NSDictionary *params = tweet != nil ? @{@"status":status} : @{@"status":status, @"in_reply_to_status_id":tweet.ID};
    [self postWithPath:@"1.1/statuses/update.json" parameters:params successBlock:^(id responseObject) {
        if (completion) {
            NSDictionary *tweetDictionary = responseObject;
            TWTweet *tweet = [[TWTweet alloc] initWithDictionary:tweetDictionary];
            completion(tweet, nil);
        }
    } failureBlock:^(NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
}


- (void)retweetTweetWithID:(NSString *)ID completion:(void(^)(TWTweet *tweet, NSError *error))completion
{
    [self performRetweetActionForTweet:@"retweet" ID:ID completion:completion];
}


- (void)favoriteTweetWithID:(NSString *)ID completion:(void(^)(TWTweet *tweet, NSError *error))completion
{
    [self performFavoriteActionForTweet:@"create" ID:ID completion:completion];
}


- (void)unretweetTweetWithID:(NSString *)ID completion:(void(^)(TWTweet *tweet, NSError *error))completion
{
    [self performRetweetActionForTweet:@"unretweet" ID:ID completion:completion];
}


- (void)unfavoriteTweetWithID:(NSString *)ID completion:(void(^)(TWTweet *tweet, NSError *error))completion
{
    [self performFavoriteActionForTweet:@"destroy" ID:ID completion:completion];
}


- (void)performFavoriteActionForTweet:(NSString *)action ID:(NSString *)ID completion:(void(^)(TWTweet *tweet, NSError *error))completion
{
    NSParameterAssert(ID != nil);
    NSParameterAssert(action != nil);
    NSString *path = [NSString stringWithFormat:@"1.1/favorites/%@.json", action];
    [self postWithPath:path parameters:@{@"id":ID} successBlock:^(id responseObject) {
        if (completion) {
            NSDictionary *tweetDictionary = responseObject;
            TWTweet *tweet = [[TWTweet alloc] initWithDictionary:tweetDictionary];
            completion(tweet, nil);
        }
    } failureBlock:^(NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
}

- (void)performRetweetActionForTweet:(NSString *)action ID:(NSString *)ID completion:(void(^)(TWTweet *tweet, NSError *error))completion
{
    NSParameterAssert(ID != nil);
    NSString *path = [NSString stringWithFormat:@"1.1/statuses/%@/%@.json", action, ID];
    [self postWithPath:path parameters:nil successBlock:^(id responseObject) {
        if (completion) {
            NSDictionary *tweetDictionary = responseObject;
            TWTweet *tweet = [[TWTweet alloc] initWithDictionary:tweetDictionary];
            TWTweet *tweetForCompletion = ([action isEqualToString:@"retweet"] ? tweet.retweet : tweet);
            completion(tweetForCompletion, nil);
        }
    } failureBlock:^(NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
}


- (void)getWithPath:(NSString *)path parameters:(NSDictionary *)parameters successBlock:(void(^)(id responseObject))successBlock failureBlock:(void(^)(NSError *error))failureBlock
{
    [self GET:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}


- (void)postWithPath:(NSString *)path parameters:(NSDictionary *)parameters successBlock:(void(^)(id responseObject))successBlock failureBlock:(void(^)(NSError *error))failureBlock
{
    [self POST:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}


- (void)fetchRequestTokenWithSuccessBlock:(void(^)())successBlock failureBlock:(void(^)(NSError *error))failureBlock
{
    static NSString * const kRequestPath = @"oauth/request_token";
    //[self deauthorize];
    [self fetchRequestTokenWithPath:kRequestPath method:kGet callbackURL:kCallbackURL scope:nil success:^(BDBOAuth1Credential *requestToken) {
        
        NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        
        [[UIApplication sharedApplication] openURL:authURL options:@{} completionHandler:^(BOOL success) {
            NSLog(@"Got Request Token");
            if (success) {
                if (successBlock) {
                    successBlock();
                }
            }
            else if (failureBlock) {
                failureBlock(nil);
            }
        }];
        
    } failure:^(NSError *error) {
        NSLog(@"Error Getting Request Token");
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}


- (void)fetchAccessTokenFromURL:(NSURL *)URL successBlock:(void(^)())successBlock failureBlock:(void(^)(NSError *error))failureBlock
{
    static NSString * const kRequestPath = @"oauth/access_token";
    
    BDBOAuth1Credential *requestToken = [BDBOAuth1Credential credentialWithQueryString:URL.query];
    [self fetchAccessTokenWithPath:kRequestPath method:kPost requestToken:requestToken success:^(BDBOAuth1Credential *accessToken) {
        NSLog(@"Got Access Token");
        [self.requestSerializer saveAccessToken:accessToken];
        [self verifyCredentialsWithCompletion:^(TWUser *user) {
            if (successBlock) {
                successBlock();
            }
        }];
    } failure:^(NSError *error) {
        NSLog(@"Error Getting Access Token");
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}


@end
