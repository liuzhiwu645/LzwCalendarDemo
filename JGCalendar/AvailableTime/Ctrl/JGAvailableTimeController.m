//
//  JGAvailableTimeController.m
//  EmpTraRent
//
//  Created by spring on 2019/11/25.
//  Copyright © 2019 spring. All rights reserved.
//

#import "JGAvailableTimeController.h"
#import "JGAvailableTimeTop.h" //顶部时间段
#import "JGAvailableTimeBottom.h"//底部
#import "JGAvailableCalendar.h"
#import "FYMethodTool.h"

@interface JGAvailableTimeController ()

@property (nonatomic, strong) JGAvailableTimeTop *Top;

@property (nonatomic, strong) JGAvailableCalendar *Calendar;

@property (nonatomic, strong) JGAvailableTimeBottom *Bottom;

@property (nonatomic, copy) NSString *qu_timeStr;
@property (nonatomic, copy) NSString *huan_timeStr;

@end

@implementation JGAvailableTimeController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"清空" target:self action:@selector(rightBarButtonItemClick)];

//    WEAKSELF;
//    self.popBlock = ^(UIBarButtonItem *backItem) {
//
//        if (weakSelf.navItemClick) {
//            weakSelf.navItemClick(@"监听返回");
//            [weakSelf.navigationController popViewControllerAnimated:NO];
//        }else {
//            [weakSelf.navigationController popViewControllerAnimated:NO];
//        }
//
//    };

}


- (void)rightBarButtonItemClick {
    
//    self.Calendar.isLeftCanSel = YES;
    
    [self.Calendar ClearAllSelectedDate];
}


- (void)configUI {
    self.qu_timeStr = @"";
    self.huan_timeStr = @"";
    
    
    
    if (self.timeArr.count != 2) {
        //2019-01-01 18:00
        //取车
        NSDateComponents *qucom = [FYMethodTool getCurrentTimeWithLastHour:3];
        //数据还原时必须有开始时间和结束时间
        JGCalendarDayModel *quModel = [[JGCalendarDayModel alloc] init];
        quModel.timeStr = [NSString stringWithFormat:@"%.2ld:%.2ld", qucom.hour, qucom.minute];
//        quModel.currentAndPreTime = [NSString stringWithFormat:@"%.2ld:%.2ld", qucom.hour, qucom.minute];
        _qu_timeStr = [NSString stringWithFormat:@"%.2ld:%.2ld", qucom.hour, qucom.minute];
        quModel.year = qucom.year;
        quModel.style = CellDayTypeAllCanDay;
        quModel.month = [[NSString stringWithFormat:@"%.2ld", qucom.month] integerValue];
        quModel.day = [[NSString stringWithFormat:@"%.2ld", qucom.day] integerValue];
        //2019-01-01 18:00
        quModel.week = qucom.weekday-1;
        quModel.qu_startTimeStr = _qu_timeStr;
        quModel.qu_endTimeStr = @"22:00";
        //通过这个判断还车是否在营业时间范围内
        NSString *qu_str = [NSString stringWithFormat:@"%.2ld:%.2ld", qucom.hour, qucom.minute];
        
        //判断 qu_str 是否在还车的营业时间范围内
        
        BOOL isContent = [FYMethodTool validateWithStartTime:@"08:00" withExpireTime:@"20:00" currentTime:qu_str];
        
        JGCalendarDayModel *huanModel = [[JGCalendarDayModel alloc] init];

        if (isContent) {
            //在
            NSDateComponents *huancom = [FYMethodTool getCurrentTimeWithLastHour:48];
            //显示和取车一样的小时:分钟
            huanModel.timeStr = qu_str;
            _huan_timeStr = qu_str;
            huanModel.year = huancom.year;
    //        huanModel.currentAndPreTime = @"";
            huanModel.style = CellDayTypeAllCanDay;
            huanModel.month = [[NSString stringWithFormat:@"%.2ld", huancom.month] integerValue];;
            huanModel.day = [[NSString stringWithFormat:@"%.2ld", huancom.day] integerValue];
            huanModel.week = huancom.weekday-1;
            huanModel.huan_startTimeStr = @"08:00";
            huanModel.huan_endTimeStr = @"20:00";
            self.timeArr = @[quModel, huanModel];
        }
        else
        {
//            BOOL isBigStart = [FYMethodTool fy_comFirstTime:@"08:00" secondTime:qu_str];
//            
//            if (isBigStart) {
//
//            }
//            else
//            {
//
//            }
            //不在
            NSDateComponents *huancom = [FYMethodTool getCurrentTimeWithLastHour:48];
            //显示还车营业介素时间
            huanModel.timeStr = @"20:00";
            _huan_timeStr = @"20:00";
            huanModel.year = huancom.year;
    //        huanModel.currentAndPreTime = @"";
            huanModel.style = CellDayTypeAllCanDay;
            huanModel.month = [[NSString stringWithFormat:@"%.2ld", huancom.month] integerValue];;
            huanModel.day = [[NSString stringWithFormat:@"%.2ld", huancom.day] integerValue];
            huanModel.week = huancom.weekday-1;
            huanModel.huan_startTimeStr = @"08:00";
            huanModel.huan_endTimeStr = @"20:00";
            self.timeArr = @[quModel, huanModel];
        }
               
        
    }
    else
    {
        //获取之前选中的小时分钟
        JGCalendarDayModel *quModel = [self.timeArr firstObject];
        JGCalendarDayModel *huanModel = [self.timeArr lastObject];
        _qu_timeStr = quModel.timeStr;
        quModel.qu_startTimeStr = @"06:00";
        quModel.qu_endTimeStr = @"22:00";
        
        _huan_timeStr = huanModel.timeStr;
        huanModel.huan_startTimeStr = @"08:00";
        huanModel.huan_endTimeStr = @"20:00";
    }
    
    
    WEAKSELF;
    _Top = [JGAvailableTimeTop new];

    _Top.LeftDateBtnClick = ^(UIButton *btn) {
        
        weakSelf.Calendar.isLeftCanSel = btn.selected;
    };
    
    _Top.RightDateBtnClick = ^(UIButton *btn) {
        
        weakSelf.Calendar.isRightCanSel = btn.selected;
    };
    
    
    _Calendar = [JGAvailableCalendar new];
    _Calendar.items = self.items;
    _Calendar.timeArr = self.timeArr;
    _Calendar.qu_CurrentSelectedTime = _qu_timeStr;
    _Calendar.huan_CurrentSelectedTime = _huan_timeStr;
    _Calendar.LeftDateInfo = ^(JGCalendarDayModel *LModel) {
        NSLog(@"LModel = %@", LModel.timeStr);
            weakSelf.Top.LeftModel = LModel;
            weakSelf.Bottom.LeftModel = LModel;
    };
    
    _Calendar.RightDateInfo = ^(JGCalendarDayModel *RModel) {
        NSLog(@"LModel timeStr = %@ ---RModel = %@", RModel.timeStr, RModel);
        weakSelf.Top.RightModel = RModel;
        weakSelf.Bottom.RightModel = RModel;
    };
    
    
    _Bottom = [[JGAvailableTimeBottom alloc] init];
    [_Bottom configUI_new];
    _Bottom.LeftModel = [_timeArr firstObject];
    _Bottom.RightModel = [_timeArr lastObject];
    _Bottom.TimeBackInfo = ^(id data) {
        if (weakSelf.TimeBackInfo) {
            weakSelf.TimeBackInfo(data);
        }
        
        [weakSelf.navigationController popViewControllerAnimated:NO];
    };
    //滚动数据时,给Top更新数据
    _Bottom.blockTimeHM = ^(NSString * _Nonnull type, JGCalendarDayModel * _Nonnull modelData) {
        NSLog(@"type = %@", type);
        if ([type isEqualToString:@"1"]) {
            //取车
            weakSelf.Top.LeftModel = modelData;
            [weakSelf.Top fy_settingBtnSelectedStatesWithType:@"2"];
            weakSelf.Calendar.qu_CurrentSelectedTime = modelData.timeStr;
        }
        else if ([type isEqualToString:@"3"])
        {
            [weakSelf.Top fy_settingBtnSelectedStatesWithType:@"2"];
            weakSelf.Top.RightModel = modelData;
            weakSelf.Calendar.qu_CurrentSelectedTime = modelData.timeStr;
            weakSelf.Calendar.huan_CurrentSelectedTime = modelData.timeStr;
        }
        else
        {
            //还车
            [weakSelf.Top fy_settingBtnSelectedStatesWithType:@"1"];
            weakSelf.Top.RightModel = modelData;
            weakSelf.Calendar.huan_CurrentSelectedTime = modelData.timeStr;
        }
    };
    
    
    [self.view addSubview:_Top];
    [self.view addSubview:_Calendar];
    [self.view addSubview:_Bottom];

    
    [_Top mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).mas_offset(SJHeight);
        make.height.equalTo(@(90)); //144
    }];
    
    [_Calendar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_Top);
        make.top.equalTo(_Top.mas_bottom);
        make.bottom.equalTo(_Bottom.mas_top);
    }];
    
    [_Bottom mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_Top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@(213)); //IphoneXTabbarH
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
