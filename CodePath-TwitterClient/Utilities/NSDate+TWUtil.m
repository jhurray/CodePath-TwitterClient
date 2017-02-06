//
//  NSDate+TWUtil.m
//  CodePath-TwitterClient
//
//  Created by  Jeffrey Hurray on 1/30/17.
//  Copyright © 2017 Jeffrey Hurray. All rights reserved.
//

#import "NSDate+TWUtil.h"

@implementation NSDate (TWUtil)

- (NSString *)tw_relativePastShortString
{
    NSTimeInterval timeSinceNow = self.timeIntervalSinceNow;
    if (timeSinceNow > 0) {
        return nil;
    }
    timeSinceNow = -timeSinceNow;
    if (timeSinceNow < 60) {
        return [NSString stringWithFormat:@"%ds", (int)floor(timeSinceNow)];
    }
    timeSinceNow /= 60;
    if (timeSinceNow < 60) {
        return [NSString stringWithFormat:@"%dm", (int)floor(timeSinceNow)];
    }
    timeSinceNow /= 60;
    if (timeSinceNow < 24) {
        return [NSString stringWithFormat:@"%dh", (int)floor(timeSinceNow)];
    }
    timeSinceNow /= 24;
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterShortStyle;
    });
    return [formatter stringFromDate:self];
}


- (NSString *)tw_longTimestampString
{
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.timeStyle = formatter.dateStyle = NSDateFormatterMediumStyle;
    });
    return [formatter stringFromDate:self];
}

@end
