//
// Created by 邵文武 on 14/9/21.
// Copyright (c) 2014 FineReport. All rights reserved.
//

#import "DateUtils.h"

#define SECOND_TIME 1
#define MINUTE_TIME 60
#define HOUR_TIME 60*60
#define DAY_TIME 24*60*60

@implementation DateUtils

static NSCalendar *calendar = nil;
static NSDateFormatter *dateFormatter = nil;
static NSInteger datetimeUnit = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;

#pragma mark - Initialize
+ (void)initializeStatics
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (calendar == nil) {
            calendar = [NSCalendar currentCalendar];
        }
        if (dateFormatter == nil){
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        }
    });
}

+ (NSCalendar *)sharedCalendar
{
    [self initializeStatics];
    return calendar;
}

+ (NSDateFormatter *)shareDateFormatter
{
    [self initializeStatics];
    return dateFormatter;
}

+ (long long)utcTimeStamp: (NSDate *)date
{
    return [date timeIntervalSince1970] * 1000;
}

+ (NSDate *)dateFromString:(NSString *)string withFormat: (NSString *)format
{
    NSDateFormatter *formatter = [[self class] shareDateFormatter];
    [formatter setDateFormat:format];
    return [formatter dateFromString:string];
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat: (NSString *)format
{
    if(date == nil){
        return @"";
    }
    NSDateFormatter *formatter = [[self class] shareDateFormatter];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
}

@end