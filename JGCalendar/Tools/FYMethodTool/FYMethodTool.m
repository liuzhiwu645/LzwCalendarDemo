//
//  FYMethodTool.m
//  MapleLeafTrip
//
//  Created by cheng on 2020/12/4.
//  Copyright © 2020 FY_LZW. All rights reserved.
//

#import "FYMethodTool.h"

@implementation FYMethodTool

#pragma mark -- 时间大小比较
+ (BOOL)fy_comFirstTime:(NSString *)firTime secondTime:(NSString *)secondTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];// ------实例化一个NSDateFormatter对象

    [formatter setDateFormat:@"HH:mm"]; //这里的格式必须和String格式一致

    NSDate *date1 = [formatter dateFromString:firTime];

    NSDate *date2 =[formatter dateFromString:secondTime];

    NSComparisonResult result =[date1 compare:date2];

    NSLog(@"firTime = %@ secondTime = %@", firTime, secondTime);
    
    BOOL isResult;
    
    switch (result)

    {
    //date2比date1大
    case NSOrderedAscending:
            isResult = NO;
    break;
    //date1比date2大
    case NSOrderedDescending:
            isResult = YES;
    break;
    //date1相等于date2
    case NSOrderedSame:
            isResult = YES;

    break;

    default:

    break;

    }
    return isResult;
}
+ (BOOL)fy_compareFirstTime:(NSString *)firTime secondTime:(NSString *)secondTime dateFormater:(NSString *)dateFormater
{
    //说明2个时间相等
    if ([firTime isEqualToString:secondTime]) {
        return NO;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];// ------实例化一个NSDateFormatter对象

    [formatter setDateFormat:dateFormater]; //这里的格式必须和String格式一致

    NSDate *date1 = [formatter dateFromString:firTime];

    NSDate *date2 =[formatter dateFromString:secondTime];

    NSComparisonResult result =[date1 compare:date2];

    NSLog(@"firTime = %@ secondTime = %@", firTime, secondTime);
    
    BOOL isResult;
    
    switch (result)

    {
    //date2比date1大
    case NSOrderedAscending:
            isResult = NO;
    break;
    //date1比date2大
    case NSOrderedDescending:
            isResult = YES;
    break;
    //date1相等于date2
    case NSOrderedSame:
            isResult = NO;

    break;

    default:

    break;

    }
    return isResult;
}

+ (BOOL)fy_comNSDateTime:(NSDate *)firTime secondTime:(NSDate *)secondTime
{

    NSComparisonResult result =[firTime compare:secondTime];

    NSLog(@"firTime = %@ secondTime = %@", firTime, secondTime);
    
    BOOL isResult;
    
    switch (result)

    {
    //date2比date1大
    case NSOrderedAscending:
            isResult = NO;
    break;
    //date1比date2大
    case NSOrderedDescending:
            isResult = YES;
    break;
    //date1相等于date2
    case NSOrderedSame:
            isResult = NO;

    break;

    default:

    break;

    }
    return isResult;
}

/**
 *  判断当前时间是否处于某个时间段内
 *
 *  @param startTime        开始时间
 *  @param expireTime       结束时间
 */

+ (BOOL)validateWithStartTime:(NSString *)startTime withExpireTime:(NSString *)expireTime currentTime:(NSString *)current{
    
    if ([current isEqualToString:startTime] || [current isEqualToString:expireTime]) {
        return YES;
    }
    
    NSLog(@"startTime = %@ expireTime = %@ current = %@", startTime, expireTime, current);
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // 时间格式,此处遇到过坑,建议时间HH大写,手机24小时进制和12小时禁止都可以完美格式化
    [dateFormat setDateFormat:@"HH:mm"];
    NSDate *today = [dateFormat dateFromString:current];
    NSDate *start = [dateFormat dateFromString:startTime];
    NSDate *expire = [dateFormat dateFromString:expireTime];
    
    if ([today compare:start] == NSOrderedDescending && [today compare:expire] == NSOrderedAscending) {
        NSLog(@"在");
        return YES;
    }
    NSLog(@"不在");
    return NO;
}

+ (NSDate *)fy_thisTimeString:(NSString *)timeString lastDay:(NSInteger)day
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];// ------实例化一个NSDateFormatter对象

    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"]; //这里的格式必须和String格式一致
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:+day];
    [comps setHour:0];
    [comps setMinute:0];
    NSCalendar *cal = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [formatter dateFromString:timeString];
    NSDate *mDate = [cal dateByAddingComponents:comps toDate:date options:0];
    NSLog(@"mDate = %@ timeString = %@", mDate, timeString);
    return mDate;
}
+ (NSDate *)fy_getthisTimeString:(NSString *)timeString nextYear:(NSInteger)nextYear nextMoth:(NSInteger)nextMoth nextDay:(NSInteger)nextDay
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];// ------实例化一个NSDateFormatter对象

    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"]; //这里的格式必须和String格式一致
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:+nextYear];
    [comps setMonth:+nextMoth];
    [comps setDay:+nextDay];
    NSCalendar *cal = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [formatter dateFromString:timeString];
    NSDate *mDate = [cal dateByAddingComponents:comps toDate:date options:0];
    NSLog(@"191 timeString = %@", [formatter stringFromDate:mDate]);
    return mDate;
}

+ (NSInteger)fy_comManyDaysDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime
{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *startDate = [dateFormatter dateFromString:startTime];
        NSDate *endDate = [dateFormatter dateFromString:endTime];
    
        NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMinute;//只比较天数差异
    //比较的结果是NSDateComponents类对象
    NSDateComponents *delta = [calendar components:unit fromDate:startDate toDate:endDate options:0];
    NSUInteger zuMinte= [delta minute];
   
    NSInteger day1 = 0;
    
    if (zuMinte > 0) {
        day1 = 1;
    }
    
    return delta.day + day1;
}

+ (NSDate *)fy_thisFontTimestring:(NSString *)timeString fontHour:(NSInteger)fontHour
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];// ------实例化一个NSDateFormatter对象

    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"]; //这里的格式必须和String格式一致
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:0];
    [comps setHour:-fontHour];
    [comps setMinute:0];
    NSCalendar *cal = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [formatter dateFromString:timeString];
    NSDate *mDate = [cal dateByAddingComponents:comps toDate:date options:0];
    NSLog(@"fontHour = %@ timeString = %@", mDate, timeString);
    return mDate;
}

- (NSArray *)fy_returnWhithDateString:(NSString *)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSDate *date = [dateFormatter dateFromString:string];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSMutableArray *array = [NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:hour], [NSNumber numberWithInteger:minute],nil];
    return array;
}

+ (NSDateComponents *)fy_retuenComponentsWithTimestring:(NSString *)timestr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //设置时间格式
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *date = [formatter dateFromString:timestr];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSCalendar *cal = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *mDate = [cal dateByAddingComponents:comps toDate:date options:0];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitWeekday;
    NSDateComponents *huan_components = [calendar components:unitFlags fromDate:mDate];
    return huan_components;
}
+(NSString *)getCurrentTimes{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSLog(@"currentTimeString =  %@",currentTimeString);
    return currentTimeString;
}

+(NSString *)dateTransfromStringWithDate:(NSDate *)date
{
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
     NSString *strDate = [dateFormatter stringFromDate:date];
     return strDate;
}

+ (NSInteger)fy_comPareMoreDifferenceWithStartTime:(NSDate *)startDate endTime:(NSDate *)endDate{

    //利用NSCalendar比较日期的差异
    NSCalendar *calendar = [NSCalendar currentCalendar];
    /**
     * 要比较的时间单位,常用如下,可以同时传：
     *    NSCalendarUnitDay : 天
     *    NSCalendarUnitYear : 年
     *    NSCalendarUnitMonth : 月
     *    NSCalendarUnitHour : 时
     *    NSCalendarUnitMinute : 分
     *    NSCalendarUnitSecond : 秒
     */
    NSCalendarUnit unit = NSCalendarUnitMinute;//只比较天数差异
    //比较的结果是NSDateComponents类对象
    NSDateComponents *delta = [calendar components:unit fromDate:startDate toDate:endDate options:0];
    NSUInteger zuMinte= [delta minute];
    NSLog(@"%ld分",zuMinte);

    NSInteger zuDay = 0;
    zuDay = zuMinte / 1440;
    if (zuMinte % 1440 > 0) {
        zuDay = zuDay + 1;
    }
    return zuDay;
}

+ (NSDateComponents *)getCurrentTimeWithLastHour:(NSInteger)hourLast
{
    NSTimeInterval threeHourSeconds = hourLast * 60 * 60;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];// ------实例化一个NSDateFormatter对象
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *now = [[NSDate alloc] initWithTimeIntervalSinceNow:threeHourSeconds];
    
    NSLog(@"now date is: %@", now);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    NSInteger year = [dateComponent year];
    NSInteger month =  [dateComponent month];
    NSInteger day = [dateComponent day];
    NSInteger hour =  [dateComponent hour];
    NSInteger minute =  [dateComponent minute];
    NSInteger second = [dateComponent second];
    NSInteger weakDay = [dateComponent weekday] - 1;
    
    if(0 < minute && minute <= 15){
        minute = 15;
    }else if(15 < minute && minute <= 30){
        minute = 30;
    }else if(30 < minute && minute <= 45){
        minute = 45;
    }else if(45 < minute && minute<=59){
        threeHourSeconds = hourLast * 60 * 60+(60-minute)*60;
        NSDate *nowAdd = [[NSDate alloc] initWithTimeIntervalSinceNow:threeHourSeconds];
        NSDateComponents *add_dateComponent = [calendar components:unitFlags fromDate:nowAdd];
        year = [add_dateComponent year];
        month =  [add_dateComponent month];
        day = [add_dateComponent day];
        hour =  [add_dateComponent hour];
        minute =  [add_dateComponent minute];
        second = [add_dateComponent second];
        weakDay = [add_dateComponent weekday] - 1;
        dateComponent = add_dateComponent;
    }
    else{
    minute = 0;
    }
    
    //判断小时分钟是否在营业时间范围内
    NSString *currentTime = [NSString stringWithFormat:@"%.2ld:%.2ld", hour, minute];
    
    BOOL isContent = [self validateWithStartTime:@"08:00" withExpireTime:@"22:00" currentTime:currentTime];
    if (isContent) {
        NSString *currentTime = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld", year, month,day, hour,minute];
        NSDate *cuDate = [formatter dateFromString:currentTime];
        
        NSDateComponents *dateComponent_new = [calendar components:unitFlags fromDate:cuDate];
        return dateComponent_new;
    }
    else
    {
        //如果小于营业开始时间
        BOOL isBigStart = [self fy_comFirstTime:@"08:00" secondTime:currentTime];
        if (isBigStart) {
            //明天的营业开始时间
            NSString *currentTime = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld %@", year, month,day, @"08:00"];
            NSDate *cuDate = [self fy_getthisTimeString:currentTime nextYear:0 nextMoth:0 nextDay:+0];
            NSDateComponents *dateComponent_new = [calendar components:unitFlags fromDate:cuDate];
            return dateComponent_new;
        }
        else
        {
            //明天的营业开始时间
            NSString *currentTime = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld %@", year, month,day, @"08:00"];
            NSDate *cuDate = [self fy_getthisTimeString:currentTime nextYear:0 nextMoth:0 nextDay:+1];
                    
            NSDateComponents *dateComponent_new = [calendar components:unitFlags fromDate:cuDate];
            return dateComponent_new;
        }
        
        
    }
    
}
//两个时间相差多少天多少小时多少分
+ (NSInteger)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime {
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *startDate =[date dateFromString:startTime];
    NSDate *endDdate = [date dateFromString:endTime];
    
    
    //利用NSCalendar比较日期的差异
    NSCalendar *calendar = [NSCalendar currentCalendar];
    /**
     * 要比较的时间单位,常用如下,可以同时传：
     *    NSCalendarUnitDay : 天
     *    NSCalendarUnitYear : 年
     *    NSCalendarUnitMonth : 月
     *    NSCalendarUnitHour : 时
     *    NSCalendarUnitMinute : 分
     *    NSCalendarUnitSecond : 秒
     */
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;//只比较天数差异
    //比较的结果是NSDateComponents类对象
    NSDateComponents *delta = [calendar components:unit fromDate:startDate toDate:endDdate options:0];
//    //打印
//    JGLog(@"%@",delta);
//    //获取其中的"天"
//    JGLog(@"%ld",delta.day);
//    JGLog(@"%ld",delta.hour);
//    JGLog(@"%ld",delta.minute);
    // 天
    NSInteger day = delta.day;

    // 小时
    NSInteger house = delta.hour;
    // 分
    NSInteger minute = delta.minute;
    
    if (day < 1) {
        return 0;
    }
    
    
    if (house != 0 || minute != 0) {
        return (day + 1);
    }else {
        return (day);
    }
}

+ (BOOL)compareDate:(NSString*)date01 withDate:(NSString*)date02 toDateFormat:(NSString*)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];// ------实例化一个NSDateFormatter对象

    [formatter setDateFormat:format]; //这里的格式必须和String格式一致

    NSDate *date1 = [formatter dateFromString:date01];

    NSDate *date2 =[formatter dateFromString:date02];

    NSComparisonResult result =[date1 compare:date2];
    
    BOOL isResult;
    
    switch (result)

    {
    //date2比date1大
    case NSOrderedAscending:
            isResult = NO;
    break;
    //date1比date2大
    case NSOrderedDescending:
            isResult = YES;
    break;
    //date1相等于date2
    case NSOrderedSame:
            isResult = NO;

    break;

    default:

    break;

    }
    return isResult;
}


@end
