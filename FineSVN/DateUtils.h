//
// Created by 邵文武 on 14/9/21.
// Copyright (c) 2014 FineReport. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DateUtils : NSObject

/**
*  初始化函数
*/
+ (void)initializeStatics;

/**
*  NSCalendar的单例
*
*  @return 返回日历对象
*/
+ (NSCalendar *)sharedCalendar;

/**
*  NSDateFormatter的单例
*
*  @return 返回日期格式对象
*/
+ (NSDateFormatter *)shareDateFormatter;

/**
*  根据指定的日期格式，将字符串转化为日期
*
*  @param string 字符串
*  @param format 日期格式
*
*  @return 返回日期对象
*/
+ (NSDate *)dateFromString:(NSString *)string withFormat: (NSString *)format;

/**
*  根据指定的日期格式，将日期转化为字符串
*
*  @param date   日期
*  @param format 日期格式
*
*  @return 返回字符串
*/
+ (NSString *)stringFromDate:(NSDate *)date withFormat: (NSString *)format;

/**
*  获取指定年份和月份下的总天数
*
*  @param month 月份
*  @param year  年份
*
*  @return 返回总天数
*/
+ (NSInteger)numberOfDaysInMonth: (NSInteger)month inYear: (NSInteger)year;

/**
*  获取指定日期的时间戳
*
*  @param date 日期
*
*  @return 返回时间戳(精确到毫秒)
*/
+ (long long)utcTimeStamp: (NSDate *)date;
@end