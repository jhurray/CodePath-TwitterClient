//
//  TWBaseModel_Protected.h
//  CodePath-TwitterClient
//
//  Created by  Jeffrey Hurray on 1/18/17.
//  Copyright © 2017 Jeffrey Hurray. All rights reserved.
//

#import "TWBaseModel.h"

#define TWModel(string, Class) ([[Class alloc] initWithDictionary:dictionary[string]])
#define TWNumber(string) ((NSNumber *)dictionary[string])
#define TWString(string) ((NSString *)dictionary[string])
#define TWBool(string) (TWNumber(string).boolValue)
#define TWInteger(string) (TWNumber(string).integerValue)
#define TWDate(string) ([self createdAtDateWithDateString:dictionary[string]])
#define TWURL(string) ([self URLWithKey:string])

@interface TWBaseModel ()

@property (nonatomic, strong) NSDictionary *dictionary;

- (NSDate *)createdAtDateWithDateString:(NSString *)dateString;
- (NSURL *)URLWithKey:(NSString *)key;

@end
