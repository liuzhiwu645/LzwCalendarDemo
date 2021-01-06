//
//  JGAvailableCalendar.h
//  EmpTraRent
//
//  Created by spring on 2019/11/27.
//  Copyright © 2019 spring. All rights reserved.
//

#import "JGBaseView.h"
#import "JGCarCalendarModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JGAvailableCalendar : JGBaseView
//左侧是否可选时间
@property (nonatomic, assign) BOOL isLeftCanSel;
//右侧是否可选时间
@property (nonatomic, assign) BOOL isRightCanSel;

//会把被占用的日期返回给你们，如果该车每天都可租，不曾被占用， items 就是 []
//"type": "2"// 1 全天不可租 2 半天不可租
@property (nonatomic, strong) NSArray *items;

//记录上次选择的数据 时间
@property (nonatomic, strong) NSArray *timeArr;

//左侧日期
@property (nonatomic, copy) ReturnBackInfo LeftDateInfo;
//右侧日期
@property (nonatomic, copy) ReturnBackInfo RightDateInfo;

//清除所有选中的日期
- (void)ClearAllSelectedDate;

//标记当前选中的取车HH:mm
@property (nonatomic, copy) NSString *qu_CurrentSelectedTime;
//标记当前选中的还车HH:mm
@property (nonatomic, copy) NSString *huan_CurrentSelectedTime;

@end

NS_ASSUME_NONNULL_END
