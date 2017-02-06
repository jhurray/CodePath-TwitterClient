//
//  NSDate+TWUtil.h
//  CodePath-TwitterClient
//
//  Created by  Jeffrey Hurray on 1/30/17.
//  Copyright © 2017 Jeffrey Hurray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (TWUtil)

@property (nonatomic, readonly) NSString *tw_relativePastShortString;
@property (nonatomic, readonly) NSString *tw_longTimestampString;

@end
