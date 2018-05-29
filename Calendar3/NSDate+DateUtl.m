//
//  NSDate+DateUtl.m
//  Calendar3
//
//  Created by SONE MASANORI on 2014/03/25.
//  Copyright (c) 2014年 SONE MASANORI. All rights reserved.
//

#import "NSDate+DateUtl.h"

@implementation NSDate (DateUtl)

- (NSDate *) toLocalTime
{
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: self];
    return [NSDate dateWithTimeInterval: seconds sinceDate: self];
}

- (NSDate *) toGlobalTime
{
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = -[tz secondsFromGMTForDate:self];
    return [NSDate dateWithTimeInterval:seconds sinceDate:self];
}

- (NSString *) toNSString
{
    // NsDate => NSString変換用のフォーマッタを作成
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]]; // Localeの指定
    //[df setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    [df setDateFormat:@"yyyy/MM/dd"];
    
    return [df stringFromDate:self];

}

- (NSString *) toNSStringYM
{
    // NsDate => NSString変換用のフォーマッタを作成
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]]; // Localeの指定
    //[df setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    [df setDateFormat:@"yyyy年MM月"];
    
    return [df stringFromDate:self];
    
}
@end
