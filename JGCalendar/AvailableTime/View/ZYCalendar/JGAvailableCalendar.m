//
//  JGAvailableCalendar.m
//  EmpTraRent
//
//  Created by spring on 2019/11/27.
//  Copyright © 2019 spring. All rights reserved.
//

#import "JGAvailableCalendar.h"
#import "JGAvailableCalendarCH.h"
#import "JGAvailableCalendarCCell.h"
#import "NSDate+JGCalendar.h"
#import "JGCalendarDayModel.h"
#import "FYMethodTool.h"
#import "JGAvailableTimeChooseActionSheet.h" //时间选取

#define MonthCount 13 //5个月

@interface JGAvailableCalendar () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionView *CollectionView;

@property (nonatomic, strong) NSMutableArray<NSMutableArray <JGCalendarDayModel *> *> *calendarMonth;

@property (nonatomic, strong) NSMutableArray<NSMutableArray <JGCalendarDayModel *> *> *array_valid; //有效的日期


//选中的 左侧 日期模型
@property (nonatomic, strong) JGCalendarDayModel *LeftModel;
//选中的 右侧 日期模型
@property (nonatomic, strong) JGCalendarDayModel *RightModel;

@property (nonatomic, strong) NSIndexPath *startIndexPath;

@end

static NSString * const JGAvailableCalendarCHId = @"JGAvailableCalendarCHId";
static NSString * const JGAvailableCalendarCCellId = @"JGAvailableCalendarCCellId";

@implementation JGAvailableCalendar

- (NSMutableArray *)calendarMonth {
    if (!_calendarMonth) {
        _calendarMonth = [NSMutableArray array];
        
        //当前时间 + 整备时长
        NSDateComponents *qucom = [FYMethodTool getCurrentTimeWithLastHour:3];
//
//        NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//
//        NSDate *date = [resultCalendar dateFromComponents:qucom];
        
        NSInteger currentI = 0;
        
        NSDate *date = [NSDate date];
        
        for (int i = 0; i < MonthCount; i ++) {
            
            NSMutableArray *DayArrM = [NSMutableArray array];
            NSMutableArray *DayArrM_value = [NSMutableArray array];

            //N月后的日期
            NSDate *Date = [date dayInTheFollowingMonth:i];
            //对象对应的月份的总天数
            NSInteger totalDaysInMonth = Date.totalDaysInMonth;
            //对象对应月份当月第一天的所属星期 就是空视图
            NSInteger firstWeekDayInMonth = Date.firstWeekDayInMonth == 0 ? 6 : Date.firstWeekDayInMonth-1;
            
            NSInteger TotalCount = totalDaysInMonth + firstWeekDayInMonth;
            NSInteger itemCount = TotalCount > 35 ? 42 : 35;
            
            for (int j = 1; j <= itemCount; j++) {

                JGCalendarDayModel *Model;

                if (j > firstWeekDayInMonth && j <= TotalCount) {
                    
                    Model = [JGCalendarDayModel calendarDayWithYear:Date.dateYear month:Date.dateMonth day:j - firstWeekDayInMonth];
                    if (Model.date.isItPassday) {
                        
                        Model.style = CellDayTypePast;
                    }
                    else if (Model.date.isItFutureday)
                    {
                        Model.style = CellDayTypePast;
                    }
                    else {
                        NSString *dateStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld",Model.year, Model.month,Model.day];
                        NSString *firsty = [NSString stringWithFormat:@"%ld-%02ld-%02ld", qucom.year,qucom.month,qucom.day];
                        
                        int isBig = [FYMethodTool compareDate:firsty withDate:dateStr toDateFormat:@"yyyy-MM-dd"];
                        if (isBig == 1) {
                            Model.style = CellDayTypePast;
                        }
                        else
                        {
                            NSLog(@"dateStr = %@ firsty =%@", dateStr, firsty);
                            if (currentI == 0) {
                                Model.style = CellDayTypeAllCanDay;
                                Model.qu_startTimeStr = [NSString stringWithFormat:@"%.2ld:%.2ld", qucom.hour, qucom.minute];
                                Model.qu_endTimeStr = @"22:00";
                                Model.huan_startTimeStr = @"08:00";
                                Model.huan_endTimeStr = @"20:00";
                                currentI = 1;
                            }
                            else
                            {
                                Model.style = CellDayTypeAllCanDay;
                                Model.qu_startTimeStr = @"06:00";
                                Model.qu_endTimeStr = @"22:00";
                                Model.huan_startTimeStr = @"08:00";
                                Model.huan_endTimeStr = @"20:00";
                            }

                            //将可用的日期放在一个数组中
                            [DayArrM_value addObject:Model];
                        }
                        
                        
                    }
                }else {
                    
                    Model = [[JGCalendarDayModel alloc] init];
                    Model.style = CellDayTypeEmpty;
                }
                
                [DayArrM addObject:Model];

            }

            [_calendarMonth addObject:DayArrM];
            [_array_valid addObject:DayArrM_value];

        }
    }
    return _calendarMonth;
}


- (UICollectionView *)CollectionView {
    if (!_CollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        _CollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _CollectionView.backgroundColor = [UIColor whiteColor];
        _CollectionView.delegate = self;
        _CollectionView.dataSource = self;
        //        _CollectionView.scrollsToTop = NO;
        _CollectionView.showsVerticalScrollIndicator = NO;
        _CollectionView.showsHorizontalScrollIndicator = NO;
        
        
        [_CollectionView registerClass:[JGAvailableCalendarCH class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:JGAvailableCalendarCHId];
        
        [_CollectionView registerClass:[JGAvailableCalendarCCell class]
            forCellWithReuseIdentifier:JGAvailableCalendarCCellId];
    }
    return _CollectionView;
}


- (void)setTimeArr:(NSArray *)timeArr {
    _timeArr = timeArr;
    
    if (!timeArr.count) return;
    
    self.LeftModel = [timeArr firstObject];
    self.RightModel = [timeArr lastObject];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (self.LeftDateInfo) {
            self.LeftDateInfo(self.LeftModel);
        }
        
        if (self.RightDateInfo) {
            self.RightDateInfo(self.RightModel);
        }
    });
    [self AvailableTimeLogic:_startIndexPath];
    
    //滚动到 选中日期
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        if (self.startIndexPath == nil) {
            [self.CollectionView scrollToItemAtIndexPath:_LeftModel.startIndex atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        }
        else
        {
            [self.CollectionView scrollToItemAtIndexPath:self.startIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        }
          
        
    });
}


- (void)configUI {
    self.array_valid = [NSMutableArray array];
    self.startIndexPath = nil;
    [self addSubview:self.CollectionView];
    
    [_CollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.calendarMonth.count;
}

//指定有多少个子视图
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.calendarMonth objectAtIndex:section].count; //5*7
}

// 显示表头的数据
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader){ //头部视图
        
        JGAvailableCalendarCH *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:JGAvailableCalendarCHId forIndexPath:indexPath];
        JGCalendarDayModel *Model = [[self.calendarMonth objectAtIndex:indexPath.section] objectAtIndex:10];
        header.TitleLbl.text = [NSString stringWithFormat:@"%ld年%ld月",Model.date.dateYear, Model.date.dateMonth];
        return header;
    } else {  //尾部视图
        return  nil;
    }
}


//指定子视图
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JGAvailableCalendarCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JGAvailableCalendarCCellId forIndexPath:indexPath];
    JGCalendarDayModel *Model = [[self.calendarMonth objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.Model = Model;
    
    if ([self.LeftModel.date isEqual:Model.date]) {
        self.startIndexPath = indexPath;
        Model.bgType = CellDayTypeSelLeft;
        cell.SelectedBg.backgroundColor = JGRGBColor(255,186,76);
        cell.TitleLbl.text = [NSString stringWithFormat:@"%ld\n取车",Model.day];
    }
    else if ([self.RightModel.date isEqual:Model.date])
    {
        Model.bgType = CellDayTypeSelRight;
        cell.SelectedBg.backgroundColor = JGRGBColor(255,186,76);
        cell.TitleLbl.text = [NSString stringWithFormat:@"%ld\n还车",Model.day];
    }
    else
    {
        cell.SelectedBg.backgroundColor = [UIColor colorWithRed:(255)/255.0 green:(186)/255.0 blue:(76)/255.0 alpha:0.15];
        cell.TitleLbl.text = [NSString stringWithFormat:@"%ld",Model.day];
    }
    [cell setNeedsLayout];
    return cell;
}

#pragma mark - 详情 -
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JGLog(@"%d - %d", self.isLeftCanSel, self.isRightCanSel);
    JGCalendarDayModel *Model = [[self.calendarMonth objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if (Model.style != CellDayTypeAllCanDay) {
        //点击时间范围内不可操作
        return;
    }
    //清除状态
    if (self.RightModel != nil && self.LeftModel != nil) {
        _startIndexPath = indexPath;
        [self ClearAllSelectedDate];
        _isLeftCanSel = YES;
    }
    WEAKSELF;
    if (Model.style == CellDayTypeAllCanDay) {
            //记录左侧模型
            if (weakSelf.isLeftCanSel) {
                
                weakSelf.LeftModel = [Model copy];
                weakSelf.LeftModel.startIndex = indexPath;
                weakSelf.startIndexPath = indexPath;
                weakSelf.LeftModel.qu_startTimeStr = Model.qu_startTimeStr;
                weakSelf.LeftModel.qu_endTimeStr = Model.qu_endTimeStr;
                weakSelf.LeftModel.timeStr = _qu_CurrentSelectedTime;//Model.qu_endTimeStr
                weakSelf.RightModel = nil;
                //设置还车可选范围
                [self fy_dealWithArrayAndObject:Model];
            }
            
            //记录右侧模型
            if (weakSelf.isRightCanSel) {
                
                //判断租的天数不能小于一天
                Model.timeStr = _huan_CurrentSelectedTime;
                weakSelf.RightModel = [Model copy];
                weakSelf.RightModel.timeStr = _huan_CurrentSelectedTime; //_huan_CurrentSelectedTime;
                weakSelf.RightModel.huan_startTimeStr = Model.huan_startTimeStr;
                weakSelf.RightModel.huan_endTimeStr = Model.huan_endTimeStr;
                weakSelf.RightModel.endIndex = indexPath;
                
                BOOL isBigNew = [FYMethodTool compareDate:weakSelf.LeftModel.toString withDate:weakSelf.RightModel.toString toDateFormat:@"yyyy-MM-dd"];
                
                if (isBigNew) {
                    NSInteger totay = [FYMethodTool dateTimeDifferenceWithStartTime:weakSelf.LeftModel.toString endTime:weakSelf.RightModel.toString];
                    if (totay < 1) {
                        [weakSelf ReSetAvailableTimeLogic];
                        
                        BOOL isBig = [FYMethodTool fy_comFirstTime:_qu_CurrentSelectedTime secondTime:Model.qu_endTimeStr];
                        if (isBig) {
    //                        weakSelf.LeftModel = [Model copy];
    //                        weakSelf.startIndexPath = indexPath;
    //                        weakSelf.LeftModel.timeStr = _qu_CurrentSelectedTime;
    //                        weakSelf.LeftModel.qu_startTimeStr = Model.qu_startTimeStr;
    //                        weakSelf.LeftModel.qu_endTimeStr = Model.qu_endTimeStr;
                            weakSelf.RightModel = nil;
                            NSString *str = [NSString stringWithFormat:@"租车天数至少为1天, %@ 不在取车的营业范围内!,还车的营业时间为 %@:%@",_qu_CurrentSelectedTime, Model.qu_startTimeStr, Model.huan_endTimeStr];
                            dispatch_main_async_safe((^{
                                [JGToast showWithText:str];
                            }))
                        }
                        else
                        {
                            NSLog(@"310 租车天数至少为1天!");
                            weakSelf.RightModel = nil;
                            dispatch_main_async_safe((^{
                                [JGToast showWithText:@"租车天数至少为1天"];
                            }))
                        }
                        
                        
                    }
                    else
                    {
                        Model.timeStr = _huan_CurrentSelectedTime;
                        weakSelf.RightModel = [Model copy];
                        weakSelf.RightModel.timeStr = _huan_CurrentSelectedTime;
                        weakSelf.RightModel.huan_startTimeStr = Model.huan_startTimeStr;
                        weakSelf.RightModel.huan_endTimeStr = Model.huan_endTimeStr;
                        weakSelf.RightModel.endIndex = indexPath;
                    }
                }
            }
            
            if (weakSelf.LeftModel != nil && weakSelf.RightModel != nil) {
                
               //比较选中的两个日期
                int result = [NSDate compareOneDay:[NSDate dateFromString:weakSelf.RightModel.toString] withAnotherDay:[NSDate dateFromString:weakSelf.LeftModel.toString]];
                
                JGLog(@"\n%@ \n %@", self.LeftModel.toString, self.RightModel.toString);
                
                NSInteger Index = -1;
                //判断选中的两个日期间是否都可以租车
                for (NSArray *MonthArr in weakSelf.calendarMonth) {
                    
                    for (JGCalendarDayModel *Mo in MonthArr) {
                 
                        //比较两个日期
                        int lResult = [NSDate compareOneDay:Mo.date withAnotherDay:weakSelf.LeftModel.date];
                        int rResult = [NSDate compareOneDay:Mo.date withAnotherDay:weakSelf.RightModel.date];
                        
                         if (lResult == 1 && rResult == -1) {
                          
                             if (Mo.style == CellDayTypeAllDay) {
                                 Index = 10;
                                 break;
                             }
                         }
                    }
                    if (Index == 10) {
                        break;
                    }
                }
                
                if (Index == -1) {
                    
                    //先复原
                    [weakSelf ReSetAvailableTimeLogic];
                    
                    if (result == -1) {
                        weakSelf.LeftModel = [Model copy];
                        weakSelf.LeftModel.timeStr = _qu_CurrentSelectedTime;
                        weakSelf.LeftModel.qu_startTimeStr = Model.qu_startTimeStr;
                        weakSelf.LeftModel.qu_endTimeStr = Model.qu_endTimeStr;
                        weakSelf.LeftModel.startIndex = indexPath;
                        weakSelf.RightModel = nil;
                        _startIndexPath = indexPath;
                        //可使用时间渲染
                        [weakSelf AvailableTimeLogic:_startIndexPath];
                        
                    }else if (result == 1) {
                        //可使用时间渲染
                        [weakSelf AvailableTimeLogic:_startIndexPath];
                    }else {
                        dispatch_main_async_safe(^{
                            [JGToast showWithText:@"租车时间段不合理，请重新选择"];
                        })
                    }
                }else {
                    
                    dispatch_main_async_safe(^{
                        [JGToast showWithText:@"租车时间段不合理，请重新选择"];
                    })
                }
            }else {
                //可使用时间渲染
                [weakSelf AvailableTimeLogic:_startIndexPath];
            }
    }
}


- (void)ReSetAvailableTimeLogic {
    
    
    for (NSArray *MonthArr in self.calendarMonth) {
        
        for (JGCalendarDayModel *Mo in MonthArr) {
            
            Mo.bgType = CellDayTypeSelHide;
        }
    }
}



#pragma mark - 已选时间渲染 -
- (void)AvailableTimeLogic:(NSIndexPath *)indexPath {
    
    /*
     CellDayTypeSelHide = 0, //默认隐藏
     CellDayTypeSelRound,  //被选中日期 全部切圆
     CellDayTypeSelLeft,    //被选中日期 背景 左侧切圆角
     CellDayTypeSelCenter,  //被选中日期 背景 不切圆角
     CellDayTypeSelRight    //被选中日期 背景 右侧侧切圆角
     */
    for (NSArray *MonthArr in self.calendarMonth) {
        
        for (JGCalendarDayModel *Mo in MonthArr) {
            
            
            Mo.bgType = CellDayTypeSelHide;
            
            BOOL isSameDay = (self.LeftModel.year == self.RightModel.year && self.LeftModel.month == self.RightModel.month && self.LeftModel.day == self.RightModel.day);
            
            if (self.RightModel == nil || isSameDay) { //只选了左侧一个时间值
                
                //比较两个日期
                int result = [NSDate compareOneDay:Mo.date withAnotherDay:self.LeftModel.date];
                if (result == 0) {
                    Mo.bgType = CellDayTypeSelRound;
                }
            }else {//选取了两个时间值
                
                //这个地方是选择还车是,重置取车可以选择365;
                if ([Mo.recovery isEqualToString:@"1"]) {
                    Mo.style = CellDayTypeAllCanDay;
                }
                    //比较两个日期
                    int lResult = [NSDate compareOneDay:Mo.date withAnotherDay:self.LeftModel.date];
                    int rResult = [NSDate compareOneDay:Mo.date withAnotherDay:self.RightModel.date];
                    
                    /*
                     1周日 2周一 3周二 4周三 5周四 6周五 7周六
                     */
                    
                    if (lResult == 0) {
                        
                        if (Mo.week == 1 || Mo.day == Mo.date.numberOfDaysInCurrentMonth) {
                            Mo.bgType = CellDayTypeSelRound;
                        }else {
                            Mo.bgType = CellDayTypeSelLeft;
                        }
                    }
                    
                    if (rResult == 0) {
                        
                        if (Mo.week == 2 || Mo.day == 1) {
                            Mo.bgType = CellDayTypeSelRound;
                        }else {
                            Mo.bgType = CellDayTypeSelRight;
                        }
                    }
                    
                    if (lResult == 1 && rResult == -1) {
                        
                        if (Mo.day == 1 && Mo.week == 1) {
                            
                            Mo.bgType = CellDayTypeSelRound;
                        }else if (Mo.week == 2 || Mo.day == 1) {
                            
                            Mo.bgType = CellDayTypeSelLeft;
                        }else if (Mo.week == 1 || Mo.day == Mo.date.numberOfDaysInCurrentMonth) {
                            
                            Mo.bgType = CellDayTypeSelRight;
                        }else {
                            
                            Mo.bgType = CellDayTypeSelCenter;
                        }
                    }
                }
        }
    }
    NSLog(@"current = %@  %@   %@   %@", _qu_CurrentSelectedTime, self.LeftModel.qu_startTimeStr, self.LeftModel.qu_endTimeStr, self.LeftModel.timeStr);
    if (self.LeftDateInfo) {
        self.LeftDateInfo(self.LeftModel);
    }
    
    if (self.RightDateInfo) {
        //判断取车的HH:mm 是否在还车营业时间范围内
        BOOL isContent = [FYMethodTool validateWithStartTime:self.RightModel.huan_startTimeStr withExpireTime:self.RightModel.huan_endTimeStr currentTime:_qu_CurrentSelectedTime];
        if (isContent) {
            _huan_CurrentSelectedTime = _qu_CurrentSelectedTime;
            self.RightModel.timeStr = self.LeftModel.timeStr;
        };
        self.RightDateInfo(self.RightModel);
    }
    
    [self.CollectionView reloadData];

}


// 表头尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return  CGSizeMake(kDeviceWidth, 50);
}

// 表尾尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

//返回每个子视图的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat W = (kDeviceWidth - 28.0) / 7.0;
    return CGSizeMake(W, W);
}

//设置每个子视图的缩进
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    //UIEdgeInsets insets = {top, left, bottom, right};
    return UIEdgeInsetsMake(0, 14, 0, 14);
}

//设置子视图上下之间的距离
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0;
}

//设置子视图左右之间的距离
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0;
}


//清除所有选中的日期
- (void)ClearAllSelectedDate {
    
    for (NSArray *MonthArr in self.calendarMonth) {
        
        for (JGCalendarDayModel *Mo in MonthArr) {
            
            Mo.bgType = CellDayTypeSelHide;
            if ([Mo.recovery isEqualToString:@"1"]) {
                Mo.style = CellDayTypeAllCanDay;
            }
        }
    }
    
    self.LeftModel = nil;
    self.RightModel = nil;

    
    if (self.LeftDateInfo) {
        self.LeftDateInfo(self.LeftModel);
    }
    
    if (self.RightDateInfo) {
        self.RightDateInfo(self.RightModel);
    }
    
    [self.CollectionView reloadData];
    
    //滚动到 选中日期 29号 新增
    [self.CollectionView scrollToItemAtIndexPath:_startIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    
}

-(void)setQu_CurrentSelectedTime:(NSString *)qu_CurrentSelectedTime
{
    _qu_CurrentSelectedTime = qu_CurrentSelectedTime;
}

-(void)setHuan_CurrentSelectedTime:(NSString *)huan_CurrentSelectedTime
{
    _huan_CurrentSelectedTime = huan_CurrentSelectedTime;
    NSLog(@"huan_CurrentSelectedTime = %@", huan_CurrentSelectedTime);
}
#pragma mark -- 获取数组中所有元素
- (void)fy_dealWithArrayAndObject:(JGCalendarDayModel *)model
{
    
    NSMutableArray *arrayTemp = [NSMutableArray array];
    NSInteger totalCount =0;
    for (NSMutableArray *arr in self.calendarMonth) {
        
        for (NSInteger i = 0; i < arr.count; i++) {
            
            JGCalendarDayModel *modelBL = arr[i];
            
            if (model == modelBL) {
                totalCount = 1;
            }
            
            if (totalCount == 1 && modelBL.style == CellDayTypeAllCanDay) {
                
                if (arrayTemp.count > 90) {
                    modelBL.style = CellDayTypePast;
                    modelBL.recovery = @"1";
                }
                else
                {
                    [arrayTemp addObject:modelBL];
                }
                
            }
            
        }
    }
//    NSLog(@"arrayTemp = %@", arrayTemp);


}

-(void)setIsLeftCanSel:(BOOL)isLeftCanSel
{
    _isLeftCanSel = isLeftCanSel;
}

-(void)setIsRightCanSel:(BOOL)isRightCanSel
{
    _isRightCanSel = isRightCanSel;
}

#pragma mark --
- (void)fy_scrollerTop
{
    [self.CollectionView scrollToItemAtIndexPath:_startIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

@end
