//
//  FYMethodTool.h
//  MapleLeafTrip
//
//  Created by cheng on 2020/12/4.
//  Copyright © 2020 FY_LZW. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYMethodTool : NSObject

/*
 时间大小比较
 */
+ (BOOL)fy_comFirstTime:(NSString *)firTime secondTime:(NSString *)secondTime;

/*
 时间大小比较
 */
+ (BOOL)fy_compareFirstTime:(NSString *)firTime secondTime:(NSString *)secondTime dateFormater:(NSString *)dateFormater;

/**
 *  判断当前时间是否处于某个时间段内
 *
 *  @param startTime        开始时间
 *  @param expireTime       结束时间
 */
+ (BOOL)validateWithStartTime:(NSString *)startTime withExpireTime:(NSString *)expireTime currentTime:(NSString *)current;


//获取某个时间之后的几天时间
+ (NSDate *)fy_thisTimeString:(NSString *)timeString lastDay:(NSInteger)day;

//比较2个日期相差几天
+ (NSInteger)fy_comManyDaysDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;


//获取某个时间之前的时间
+ (NSDate *)fy_thisFontTimestring:(NSString *)timeString fontHour:(NSInteger)fontHour;

/*
 日期大小比较
 */
+ (BOOL)fy_comNSDateTime:(NSDate *)firTime secondTime:(NSDate *)secondTime;

//获取小时, 分钟
+ (NSArray *)fy_returnWhithDateString:(NSString *)string;

//获取某个时间之后的几天时间
+ (NSDate *)fy_getthisTimeString:(NSString *)timeString nextYear:(NSInteger)nextYear nextMoth:(NSInteger)nextMoth nextDay:(NSInteger)nextDay;

//传入时间字符串, 返回一个NSDateComponents对象
+ (NSDateComponents *)fy_retuenComponentsWithTimestring:(NSString *)timestr;

+ (NSString *)getCurrentTimes;

+ (NSString *)dateTransfromStringWithDate:(NSDate *)date;

+ (NSInteger)fy_comPareMoreDifferenceWithStartTime:(NSDate *)startDate endTime:(NSDate *)endDate;

+ (NSDateComponents *)getCurrentTimeWithLastHour:(NSInteger)hourLast;

+ (NSInteger)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;

/**判断两个日期的大小

 *date01 : 第一个日期

 *date02 : 第二个日期

 *format : 日期格式 如：@"yyyy-MM-dd HH:mm"

 *return : 0（等于）1（大于）-1（小于）

 */
+ (BOOL)compareDate:(NSString*)date01 withDate:(NSString*)date02 toDateFormat:(NSString*)format;

@end

NS_ASSUME_NONNULL_END
