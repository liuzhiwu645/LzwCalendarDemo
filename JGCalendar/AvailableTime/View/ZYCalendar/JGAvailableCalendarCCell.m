//
//  JGAvailableCalendarCCell.m
//  EmpTraRent
//
//  Created by spring on 2019/11/27.
//  Copyright © 2019 spring. All rights reserved.
//

#import "JGAvailableCalendarCCell.h"

@interface JGAvailableCalendarCCell ()


@property (nonatomic, strong) UIImageView *BgIcon;

@property (nonatomic, strong) UIImageView *DelIcon;


@end


@implementation JGAvailableCalendarCCell

- (void)configUI {
    
    _SelectedBg = [[UIView alloc] initWithFrame:CGRectMake(1, 1, self.contentView.frame.size.width-2, self.contentView.frame.size.height-2)];
    _SelectedBg.backgroundColor = [UIColor colorWithRed:(255)/255.0 green:(186)/255.0 blue:(76)/255.0 alpha:0.15];
    //    JGHexColor(@"#7588FF");
    
    _BgIcon = [UIImageView new];
    _BgIcon.hidden = YES;
    
    _TitleLbl = [UILabel new];
    _TitleLbl.textColor = [UIColor blackColor];
//    JG333Color;
    _TitleLbl.numberOfLines = 0;
    _TitleLbl.adjustsFontSizeToFitWidth = YES;
    _TitleLbl.textAlignment = NSTextAlignmentCenter;
    _TitleLbl.font = JGFont(16);
    
    _DelIcon = [UIImageView new];
   
    [self addSubview:_SelectedBg];
    [self addSubview:_BgIcon];
    [self addSubview:_TitleLbl];
    [self addSubview:_DelIcon];

//    [_SelectedBg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).mas_offset(1.0);
//        make.right.equalTo(self.mas_right).mas_offset(-1.0);
//        make.centerY.equalTo(self.mas_centerY);
//        make.height.equalTo(@(35));
//    }];
    
    [_BgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(_TitleLbl);
        make.width.height.equalTo(@(35));
    }];
    
    [_TitleLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
        make.width.height.equalTo(self.SelectedBg);
    }];
    
    [_DelIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(_TitleLbl);
    }];
}


- (void)setModel:(JGCalendarDayModel *)Model {
    _Model = Model;
    
    _TitleLbl.hidden = (Model.style == CellDayTypeEmpty);
    
    
    /*
     CellDayTypeEmpty,   //不显示
     CellDayTypePast,    //过去的日期
     CellDayTypeAllDay,    //全天不可租
     CellDayTypePartDay,    //半天不可租
     CellDayTypeAllCanDay,    //全天可租
     CellDayTypeClick    //被点击的日期
     */
    
    _TitleLbl.text = [NSString stringWithFormat:@"%ld", Model.day];
    _SelectedBg.hidden = (Model.bgType == CellDayTypeSelHide);

    
    _DelIcon.hidden = YES;
    _BgIcon.hidden = YES;

    if (Model.style == CellDayTypePast) {
        
        _TitleLbl.textColor = JG999Color;
        
    }else if (Model.style == CellDayTypeAllDay) {
        
        _DelIcon.hidden = NO;
        _DelIcon.image = JGImage(@"calendar_del_line");
        _TitleLbl.textColor = JG999Color;
    }else if (Model.style == CellDayTypePartDay) {
        
//        _BgIcon.hidden = NO;
        _BgIcon.image = JGImage(@"calendar_part_time_big");
        _TitleLbl.textColor = JG333Color;
    }else if (Model.style == CellDayTypeAllCanDay) {
        
//        _BgIcon.hidden = NO;
        _BgIcon.image = JGImage(@"calendar_all_time_big");
        _TitleLbl.textColor = JG333Color;
    }
    
    
    if (Model.bgType != CellDayTypeSelHide) {
        
        _DelIcon.hidden = YES;
        _BgIcon.hidden = YES;
        _TitleLbl.textColor = [UIColor whiteColor];
    }

//    [self layoutIfNeeded];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    /*
     CellDayTypeSelHide = 0, //默认隐藏
     CellDayTypeSelRound,  //被选中日期 全部切圆
     CellDayTypeSelLeft,    //被选中日期 背景 左侧切圆角
     CellDayTypeSelCenter,  //被选中日期 背景 不切圆角
     CellDayTypeSelRight    //被选中日期 背景 右侧侧切圆角
     */
    
//    JGLog(@"bgType:%ld",(long)self.Model.bgType);
    if (self.Model.bgType == CellDayTypeSelLeft) {

        [JGCommonTools configArbitraryCornerRadiusView:_SelectedBg cornerRadius:8 withType:ArbitraryCornerRadiusViewTypeTopLeftBottomLeft];
    }else if (self.Model.bgType == CellDayTypeSelRight) {

        [JGCommonTools configArbitraryCornerRadiusView:_SelectedBg cornerRadius:8 withType:ArbitraryCornerRadiusViewTypeTopRightBottomRight];
    }else if (self.Model.bgType == CellDayTypeSelCenter) {

        [JGCommonTools configArbitraryCornerRadiusView:_SelectedBg cornerRadius:0 withType:ArbitraryCornerRadiusViewTypeDefault];
    }else if (self.Model.bgType == CellDayTypeSelRound) {

        [JGCommonTools configArbitraryCornerRadiusView:_SelectedBg cornerRadius:0 withType:ArbitraryCornerRadiusViewTypeTopLeftBottomLeft];
        [JGCommonTools configArbitraryCornerRadiusView:_SelectedBg cornerRadius:0 withType:ArbitraryCornerRadiusViewTypeDefault];
    }
    else
    {
        [JGCommonTools configArbitraryCornerRadiusView:_SelectedBg cornerRadius:0 withType:ArbitraryCornerRadiusViewTypeDefault];
    }
}



@end
