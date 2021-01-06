//
//  JGAvailableTimeBottom.m
//  EmpTraRent
//
//  Created by spring on 2019/11/27.
//  Copyright © 2019 spring. All rights reserved.
//

#import "JGAvailableTimeBottom.h"
#import "FYMethodTool.h"

@interface JGAvailableTimeBottom ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIButton *AllDateBtn;
@property (nonatomic, strong) UIButton *PartDateBtn;
@property (nonatomic, strong) UIButton *NoDateBtn;

@property (nonatomic, strong) UILabel *TotalLbl;

@property (nonatomic, strong) UIButton *SureBtn;

@property (strong, nonatomic) UIPickerView *qu_pickerView;
@property (strong, nonatomic) UIPickerView *huan_pickerView;

@property (strong, nonatomic) NSMutableArray *array_qu;
@property (strong, nonatomic) NSMutableArray *array_huan;

@end


@implementation JGAvailableTimeBottom

-(instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;;
}

- (void)configUI_new {
    
    self.backgroundColor = [UIColor whiteColor];
    self.array_qu = [NSMutableArray array];
    self.array_huan = [NSMutableArray array];
    UIView *TopLine = [UIView new];
    TopLine.backgroundColor = JGHexColor(@"#E5E5EA");

    
    UILabel *labelQu = [[UILabel alloc] init];
    labelQu.text = @"取车时间";
    labelQu.font = [UIFont systemFontOfSize:15];
    labelQu.textColor = [UIColor blackColor];
    labelQu.textAlignment = NSTextAlignmentCenter;
    [self addSubview:labelQu];
    
    UILabel *labelhuan = [[UILabel alloc] init];
    labelhuan.text = @"还车时间";
    labelhuan.font = [UIFont systemFontOfSize:15];
    labelhuan.textColor = [UIColor blackColor];
    labelhuan.textAlignment = NSTextAlignmentCenter;
    [self addSubview:labelhuan];
    
    self.qu_pickerView = [UIPickerView new];
    _qu_pickerView.delegate = self;
    _qu_pickerView.dataSource = self;
    
    [self addSubview:_qu_pickerView];
    
    self.huan_pickerView = [UIPickerView new];
    _huan_pickerView.delegate = self;
    _huan_pickerView.dataSource = self;
    [self addSubview:_huan_pickerView];
    
    [labelQu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).multipliedBy(0.5);
        make.top.equalTo(@(16));
        make.size.equalTo(@(CGSizeMake(71, 19)));
    }];
    
    [labelhuan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).multipliedBy(1.5);
        make.size.equalTo(labelQu);
        make.centerY.equalTo(labelQu);
    }];
    
    _TotalLbl = [[UILabel alloc] init];
    _TotalLbl.textColor = [UIColor redColor];
    _TotalLbl.textAlignment = NSTextAlignmentCenter;
    _TotalLbl.font = [UIFont systemFontOfSize:15.0];
    _TotalLbl.hidden = YES;
    [self addSubview:_TotalLbl];
    
    _SureBtn = [UIButton new];
    _SureBtn.titleLabel.font = JGFont(16);
    _SureBtn.backgroundColor = JGRGBColor(180,166,153);
//    JGHexColor(@"#282828");
    _SureBtn.layer.cornerRadius = 5.0;
    [_SureBtn setTitle:@"确认时间" forState:UIControlStateNormal];
    [_SureBtn addTarget:self action:@selector(SureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addSubview:TopLine];
    [self addSubview:_SureBtn];
    
    
    [TopLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(@(0.5));
    }];
    
    [_SureBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(375-30, 44));
        make.bottom.equalTo(self.mas_bottom).offset(-13);
    }];
    
    [_qu_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(labelQu);
        make.top.equalTo(labelQu.mas_bottom).offset(5);
        make.width.equalTo(@(180));
        make.bottom.equalTo(self.SureBtn.mas_top).offset(-20);
    }];
    
    [_huan_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(labelhuan);
        make.top.equalTo(labelhuan.mas_bottom).offset(5);
        make.width.equalTo(@(180));
        make.bottom.equalTo(self.SureBtn.mas_top).offset(-20);
    }];
    
    [_TotalLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.SureBtn);
        make.top.equalTo(self.qu_pickerView.mas_bottom).offset(2);
        make.bottom.equalTo(self.SureBtn.mas_top).offset(-2);
        make.width.equalTo(self.SureBtn);
    }];
    
    //设置当前选中的时间
//    if ([_array_qu containsObject:[NSString stringWithFormat:@"%@", _LeftModel.timeStr]]) {
//        NSInteger currentInde = [_array_qu indexOfObject:_LeftModel.timeStr];
//        [_qu_pickerView selectRow:currentInde inComponent:0 animated:YES];
//    }
//    else
//    {
//        [_qu_pickerView selectRow:1 inComponent:0 animated:YES];
//    }
//
//    if ([_array_huan containsObject:[NSString stringWithFormat:@"%@", _RightModel.timeStr]]) {
//        NSInteger currentInde = [_array_huan indexOfObject:_RightModel.timeStr];
//        [_huan_pickerView selectRow:currentInde inComponent:0 animated:YES];
//    }
//    else
//    {
//        [_huan_pickerView selectRow:1 inComponent:0 animated:YES];
//    }
    
}


- (void)setLeftModel:(JGCalendarDayModel *)LeftModel {
    _LeftModel = LeftModel;
    if (_LeftModel != nil) {
        _array_qu = [self fy_dateDealWithStartTime:_LeftModel.qu_startTimeStr endTime:_LeftModel.qu_endTimeStr];
        [self.qu_pickerView reloadAllComponents];

        NSLog(@"226 = %@", LeftModel.timeStr);
        //设置当前选中的时间
        if ([_array_qu containsObject:[NSString stringWithFormat:@"%@", _LeftModel.timeStr]]) {
            NSInteger currentInde = [_array_qu indexOfObject:_LeftModel.timeStr];
            [_qu_pickerView selectRow:currentInde inComponent:0 animated:YES];
            NSLog(@"currentInde = %ld", currentInde);
        }
        else
        {
            [_qu_pickerView selectRow:0 inComponent:0 animated:YES];
            _LeftModel.timeStr = [_array_qu firstObject];
        }
        
//        [self.qu_pickerView reloadAllComponents];
        [self CalculateDate];
    }
    else
    {
        _TotalLbl.hidden = YES;
        [_array_qu removeAllObjects];
        [_array_qu addObject:@"请选择还车日期"];
        [self.qu_pickerView reloadAllComponents];
    }
}

- (void)setRightModel:(JGCalendarDayModel *)RightModel {
    _RightModel = RightModel;
    
    if (RightModel != nil) {
        _array_huan = [self fy_dateDealWithStartTime:_RightModel.huan_startTimeStr endTime:_RightModel.huan_endTimeStr];
        [self.huan_pickerView reloadAllComponents];

        //判断取车的小时分钟是否有,如果没有,显示营业结束时间
        if (_LeftModel.timeStr.length) { //
            
            if ([_array_huan containsObject:_LeftModel.timeStr]) {
                
                if ([_array_huan containsObject:_RightModel.timeStr]) {
                    NSInteger currentInde = [_array_huan indexOfObject:_RightModel.timeStr];
                    [_huan_pickerView selectRow:currentInde inComponent:0 animated:YES];
                }
                else
                {
                    NSInteger currentInde = [_array_huan indexOfObject:_LeftModel.timeStr];
                    [_huan_pickerView selectRow:currentInde inComponent:0 animated:YES];
                }
            }
            else
            {
                if ([_array_huan containsObject:_RightModel.timeStr]) {
                    NSInteger currentInde = [_array_huan indexOfObject:_RightModel.timeStr];
                    [_huan_pickerView selectRow:currentInde inComponent:0 animated:YES];
                }
                else
                {
                    [_huan_pickerView selectRow:_array_huan.count-1 inComponent:0 animated:YES];
                }
            }
        }
        else
        {
            [_huan_pickerView selectRow:[_array_huan count]-1 inComponent:0 animated:YES];
        }
        
        [self CalculateDate];
    }
    else
    {
        _TotalLbl.hidden = YES;
        [_array_huan removeAllObjects];
        [_array_huan addObject:@"请选择还车日期"];
        [self.huan_pickerView reloadAllComponents];
        //默认选中第一个
//        [_huan_pickerView selectRow:0 inComponent:0 animated:NO];
    }
    
}


- (void)CalculateDate {
    
    _TotalLbl.hidden = !(self.LeftModel.toString.length && self.RightModel.toString.length);
    
    
    if (self.LeftModel.toString.length && self.RightModel.toString.length) {
        
        NSInteger totalDay = [FYMethodTool dateTimeDifferenceWithStartTime:_LeftModel.toString endTime:_RightModel.toString];

        if (totalDay > 90) {
            _TotalLbl.hidden = NO;
            _TotalLbl.text = @"最大租车天数不能大于90天!";
            _SureBtn.backgroundColor = [UIColor lightGrayColor];
            _SureBtn.enabled = NO;
        }
        else if (totalDay == 0)
        {
            _TotalLbl.hidden = NO;
            _TotalLbl.text = @"最小租车天数不能小于1天!";
            _SureBtn.backgroundColor = [UIColor lightGrayColor];
            _SureBtn.enabled = NO;
        }
        else
        {
            _TotalLbl.hidden = YES;
            _SureBtn.backgroundColor = JGRGBColor(180,166,153);
            _SureBtn.enabled = YES;
        }
    }
    
}


- (void)SureBtnClick {
    
    JGLog(@"%@ - %@", self.LeftModel.toString, self.RightModel.toString);
    if (!self.LeftModel.toString.length) {
        dispatch_main_async_safe(^{
            [JGToast showWithText:@"请选择取车时间!"];
        })
        return;;
    }
    
    if (!self.RightModel.toString.length) {
        dispatch_main_async_safe(^{
            [JGToast showWithText:@"请选择还车时间!"];
        })
        return;;
    }
    if (self.LeftModel.toString.length && self.RightModel.toString.length && self.TimeBackInfo) {
        self.TimeBackInfo(@[self.LeftModel,self.RightModel]);
        return;
    }
    
    
    if (!self.LeftModel.toString.length && !self.RightModel.toString.length && self.TimeBackInfo) {

        self.TimeBackInfo(@[]);
    }    
}
#pragma mark - UIPickerViewDataSource Implementation
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // Returns
    if (_qu_pickerView == pickerView) {
        return  _array_qu.count;
    }
    return _array_huan.count;
}
#pragma mark UIPickerViewDelegate Implementation

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 25;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_qu_pickerView == pickerView) {
        return  _array_qu[row];
    }
    return _array_huan[row];
    return nil;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *labelText = (UILabel *)view;
    if (labelText == nil) {
        labelText = [[UILabel alloc] init];
        labelText.textColor = [UIColor darkGrayColor];
        labelText.textAlignment = NSTextAlignmentCenter;
        labelText.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
    }
    labelText.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return labelText;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
 
    if (pickerView == _qu_pickerView) {
        //刷新数据
        if (_LeftModel != nil) {
            _LeftModel.timeStr = _array_qu[row];
            if (self.blockTimeHM) {
                _blockTimeHM(@"1", _LeftModel);
            }
            [self fy_huanExitTime:_array_qu[row]];
        }
        else
        {
            NSLog(@"LeftModel == nil");
            [JGToast showWithText:@"请先选开始租车时间"];
        }
        
    }
    else
    {
        //没有还车时间,就不滚动了
        if (_RightModel != nil) {
            _RightModel.timeStr = _array_huan[row];
            
            [self CalculateDate];
            
            if (self.blockTimeHM) {
                _blockTimeHM(@"2",_RightModel);
            }
        }
        else
        {
            [JGToast showWithText:@"请先选结束租车时间"];
        }
    }
    
    [pickerView reloadAllComponents];
}
#pragma mark -- 判断滚动取车的时间,还车时间是否有,有就联动,没有就不联动
- (void)fy_huanExitTime:(NSString *)timestr
{
    //如果住的天数是90天, 需要重置_array_huan 数据
    if (_RightModel != nil) {
        NSInteger totalDay = [FYMethodTool dateTimeDifferenceWithStartTime:_LeftModel.toString endTime:_RightModel.toString];

        if (totalDay == 90) {
            //timestr 取车滚动的time 就是还车的最大值
            if ([_array_huan containsObject:timestr]) {
                _RightModel.timeStr = timestr;
//                [_array_huan removeAllObjects];
//                _array_huan = [self fy_dateDealWithStartTime:_RightModel.huan_startTimeStr endTime:timestr];
//                [_huan_pickerView reloadAllComponents];
                NSInteger currentH = [_array_huan indexOfObject:timestr];
                [_huan_pickerView selectRow:currentH inComponent:0 animated:YES];
            }
            else
            {
                [_array_huan removeAllObjects];
                _array_huan = [self fy_dateDealWithStartTime:_RightModel.huan_startTimeStr endTime:_RightModel.huan_endTimeStr];
                [_huan_pickerView reloadAllComponents];
                NSLog(@"332 = 不在");
                [_huan_pickerView selectRow:[_array_huan count]-1 inComponent:0 animated:YES];
            }
        }
        else if (totalDay > 90)
        {
            if ([_array_huan containsObject:timestr]) {
                _RightModel.timeStr = timestr;
                NSInteger currentH = [_array_huan indexOfObject:timestr];
                [_huan_pickerView selectRow:currentH inComponent:0 animated:YES];
            }
        }
        else
        {
            //不在90天
            if ([_array_huan containsObject:timestr]) {
                //重新赋值
                _RightModel.timeStr = timestr;
                NSInteger currentH = [_array_huan indexOfObject:timestr];
                [_huan_pickerView selectRow:currentH inComponent:0 animated:YES];
                if (self.blockTimeHM) {
                    _blockTimeHM(@"3", _RightModel);
                }
            }
            else
            {
                NSLog(@"350 不包含");
            }
            
        }
        [self CalculateDate];
    }

}

- (void)configurePickerView:(UIPickerView *)pickerView
{
    pickerView.showsSelectionIndicator = NO;
}


- (NSMutableArray *)fy_dateDealWithStartTime:(NSString *)startTime endTime:(NSString *)endTime
{
    
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *array_min = [NSMutableArray arrayWithObjects:@"00",@"15",@"30",@"45", nil];

    NSArray *arrayStart = [startTime componentsSeparatedByString:@":"];
    
    NSArray *arrayEnd = [endTime componentsSeparatedByString:@":"];

    NSInteger startHour = [[arrayStart firstObject] integerValue];
    
    NSInteger endHourHour = [[arrayEnd firstObject] integerValue];

    
    NSInteger startMin = [[arrayStart lastObject] integerValue];
    
    NSInteger endMin = [[arrayEnd lastObject] integerValue];

    
    for (NSInteger i = startHour; i<=endHourHour; i++) {
        NSString *totalTimestr = @"";

        if (i == startHour) {
            if (startMin <= 0) {
                
                totalTimestr = [NSString stringWithFormat:@"%.2ld:%@", i,@"00"];
                [array addObject:totalTimestr];
            }
             if (startMin <= 15)
            {
                totalTimestr = [NSString stringWithFormat:@"%.2ld:%@", i,@"15"];
                [array addObject:totalTimestr];
            }
             if (startMin <= 30)
            {
                totalTimestr = [NSString stringWithFormat:@"%.2ld:%@", i,@"30"];
                [array addObject:totalTimestr];
            }
             if (startMin <= 45)
            {
                totalTimestr = [NSString stringWithFormat:@"%.2ld:%@", i,@"45"];
                [array addObject:totalTimestr];
            }
            
        }
        if (i == endHourHour)
        {
            if (endMin == 0) {
                totalTimestr = [NSString stringWithFormat:@"%.2ld:%@", i,@"00"];
                [array addObject:totalTimestr];
            }
             if (endMin == 15)
            {
                totalTimestr = [NSString stringWithFormat:@"%.2ld:%@", i,@"15"];
                [array addObject:totalTimestr];
            }
             if (endMin == 30)
            {
                totalTimestr = [NSString stringWithFormat:@"%.2ld:%@", i,@"30"];
                [array addObject:totalTimestr];
            }
             if (endMin == 45)
            {
                totalTimestr = [NSString stringWithFormat:@"%.2ld:%@", i,@"45"];
                [array addObject:totalTimestr];
            }
        }
        if (i > startHour && i < endHourHour)
        {
            for (NSString *minStr in array_min) {
                totalTimestr = [NSString stringWithFormat:@"%.2ld:%@", i ,minStr];
                [array addObject:totalTimestr];
            }
        }
    }
    
    return array;
}

@end
