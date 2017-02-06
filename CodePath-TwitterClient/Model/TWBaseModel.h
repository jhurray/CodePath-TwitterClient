//
//  TWBaseModel.h
//  CodePath-TwitterClient
//
//  Created by  Jeffrey Hurray on 1/18/17.
//  Copyright © 2017 Jeffrey Hurray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWBaseModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary NS_DESIGNATED_INITIALIZER;

+ (NSArray<__kindof TWBaseModel *> *)listWithDictionaries:(NSArray<NSDictionary *> *)dictionaries;

@end
