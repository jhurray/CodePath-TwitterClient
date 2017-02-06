//
//  TWBaseModel.m
//  CodePath-TwitterClient
//
//  Created by  Jeffrey Hurray on 1/18/17.
//  Copyright © 2017 Jeffrey Hurray. All rights reserved.
//

#import "TWBaseModel_Protected.h"

@implementation TWBaseModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (!dictionary) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        self.dictionary = dictionary;
    }
    return self;
}


- (instancetype)init
{
    [self doesNotRecognizeSelector:_cmd];
    return [self initWithDictionary:nil];
}


+ (NSArray<__kindof TWBaseModel *> *)listWithDictionaries:(NSArray<NSDictionary *> *)dictionaries
{
    NSMutableArray<__kindof TWBaseModel *> *models = [NSMutableArray arrayWithCapacity:dictionaries.count];
    for (NSDictionary *dictionary in dictionaries) {
        __kindof TWBaseModel *model = [[self alloc] initWithDictionary:dictionary];
        [models addObject:model];
    }
    return models;
}


- (NSDate *)createdAtDateWithDateString:(NSString *)dateString
{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
    });
    return [dateFormatter dateFromString:dateString];
}


- (NSURL *)URLWithKey:(NSString *)key
{
    NSString *value = self.dictionary[key];
    if (value != nil && [value isKindOfClass:[NSString class]]) {
        return [NSURL URLWithString:value];
    }
    return nil;
}

@end
