//
//  TWUser.h
//  CodePath-TwitterClient
//
//  Created by  Jeffrey Hurray on 1/22/17.
//  Copyright © 2017 Jeffrey Hurray. All rights reserved.
//

#import "TWBaseModel.h"

@interface TWUser : TWBaseModel

@property (nonatomic, copy, readonly) NSString *ID;
@property (nonatomic, strong, readonly) NSDate *createdAt;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *handle;
@property (nonatomic, copy, readonly) NSString *screenName;
@property (nonatomic, assign, readonly) NSInteger friendsCount;
@property (nonatomic, assign, readonly) NSInteger followersCount;
@property (nonatomic, assign, readonly) NSInteger tweetCount;
@property (nonatomic, strong, readonly) NSURL *profileImageURL;
@property (nonatomic, strong, readonly) NSURL *profileBackgroundImageURL;

@property (class, nonatomic) TWUser *currentUser;

@end
