//
//  TWUser.m
//  CodePath-TwitterClient
//
//  Created by  Jeffrey Hurray on 1/22/17.
//  Copyright © 2017 Jeffrey Hurray. All rights reserved.
//

#import "TWUser.h"
#import "TWBaseModel_Protected.h"

@interface TWUser ()

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *handle;
@property (nonatomic, copy) NSString *screenName;
@property (nonatomic, assign) NSInteger friendsCount;
@property (nonatomic, assign) NSInteger followersCount;
@property (nonatomic, assign) NSInteger tweetCount;
@property (nonatomic, strong) NSURL *profileImageURL;
@property (nonatomic, strong) NSURL *profileBackgroundImageURL;

@end

static TWUser * p_currentUser;
static NSString * const kTWCurrentUserKey = @"kTWCurrentUserKey";

@implementation TWUser

+ (TWUser *)currentUser
{
    if (!p_currentUser) {
        NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:kTWCurrentUserKey];
        if (data) {
            NSDictionary *currentUserDictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:data];
            if (currentUserDictionary) {
                p_currentUser = [[TWUser alloc] initWithDictionary:currentUserDictionary];
            }
        }
    }
    return p_currentUser;
}


+ (void)setCurrentUser:(TWUser *)currentUser
{
    if (currentUser && currentUser.dictionary) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:currentUser.dictionary];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kTWCurrentUserKey];
        p_currentUser = [[TWUser alloc] initWithDictionary:currentUser.dictionary];
    }
}


- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        self.ID = TWString(@"id_str");
        self.createdAt = TWDate(@"created_at");
        self.name = TWString(@"name");
        self.screenName = TWString(@"screen_name");
        self.handle = [NSString stringWithFormat:@"@%@", self.screenName];
        self.friendsCount = TWInteger(@"friends_count");
        self.followersCount = TWInteger(@"followers_count");
        self.tweetCount = TWInteger(@"statuses_count");
        self.profileImageURL = TWURL(@"profile_image_url_https");
        self.profileBackgroundImageURL = TWURL(@"profile_banner_url");
    }
    return self;
}

@end
