//
//  DateTimePickerView.h
//  gsq
//
//  Created by guoshuqing on 2018/5/25.
//  Copyright © 2017年 guoshuqing. All rights reserved.
//

#import "ZYDateTimePickerView.h"
#import "UIColor+KQExpanded.h"

#define Device_Height [[UIScreen mainScreen] bounds].size.height
#define Device_Width  [[UIScreen mainScreen] bounds].size.width
#define TabbarSafeBottomMargin  ((IS_IPHONE_X || IS_IPHONE_XR || IS_IPHONE_XS || IS_IPHONE_XS_Max) ? 34.f : 0.f)
//iPhoneX
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//iPHoneXr
#define IS_IPHONE_XR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
//iPhoneXs
#define IS_IPHONE_XS ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//iPhoneXs Max
#define IS_IPHONE_XS_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)
@interface ZYDateTimePickerView()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSInteger yearRange;
    NSInteger dayRange;
    NSInteger startYear;
    NSInteger selectedYear;
    NSInteger selectedMonth;
    NSInteger selectedDay;
    NSInteger selectedHour;
    NSInteger selectedMinute;
    NSInteger selectedSecond;
    NSCalendar *calendar;
    //左边退出按钮
    UIButton *cancelButton;
    //右边的确定按钮
    UIButton *chooseButton;
    //title显示
    UILabel  *titleNameLabel;
    
}

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic,strong) NSString *string;
@property (nonatomic, strong) UIView *contentV;
@property (nonatomic, strong) UIView *bgView;
@end

@implementation ZYDateTimePickerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor hexStringToColor:@"#ffffff" andAlpha:0.5];
        self.alpha = 0;
        
        
        UIView *contentV = [[UIView alloc] initWithFrame:CGRectMake(0, Device_Height, Device_Width, 220)];
        contentV.backgroundColor = [UIColor clearColor];
        [self addSubview:contentV];
        self.contentV = contentV;
        
        self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 180)];
        self.pickerView.backgroundColor = [UIColor whiteColor]
        ;
        self.pickerView.dataSource=self;
        self.pickerView.delegate=self;
        
        [contentV addSubview:self.pickerView];
        //盛放按钮的View
        UIView *upVeiw = [[UIView alloc]initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, 30)];
        
        [contentV addSubview:upVeiw];
        //左边的取消按钮
        cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 104, 0, 50, 30);
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.backgroundColor = [UIColor hexStringToColor:@"#58595D"];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        //设置半圆角
        UIBezierPath *maskPathCancel = [UIBezierPath bezierPathWithRoundedRect:cancelButton.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerTopLeft) cornerRadii:CGSizeMake(5,5)];//圆角大小
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = cancelButton.bounds;
        maskLayer.path = maskPathCancel.CGPath;
        cancelButton.layer.mask = maskLayer;
        [upVeiw addSubview:cancelButton];
        
        //右边的确定按钮
        chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        chooseButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 52, 0, 50, 30);
        [chooseButton setTitle:@"确定" forState:UIControlStateNormal];
        chooseButton.backgroundColor = [UIColor hexStringToColor:@"#58595D"];
        chooseButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [chooseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [chooseButton addTarget:self action:@selector(configButtonClick) forControlEvents:UIControlEventTouchUpInside];
        //设置半圆角
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:chooseButton.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerTopLeft) cornerRadii:CGSizeMake(5,5)];//圆角大小
        CAShapeLayer *maskLayerSure = [[CAShapeLayer alloc] init];
        maskLayerSure.frame = chooseButton.bounds;
        maskLayerSure.path = maskPath.CGPath;
        chooseButton.layer.mask = maskLayerSure;
        [upVeiw addSubview:chooseButton];
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,100, 30)];
        self.titleL.textColor = [UIColor whiteColor];
        self.titleL.backgroundColor = [UIColor hexStringToColor:@"#58595D"];
        self.titleL.font = [UIFont systemFontOfSize:13];
        self.titleL.textAlignment = NSTextAlignmentCenter;
        //设置半圆角
        UIBezierPath *maskPathLabel= [UIBezierPath bezierPathWithRoundedRect:self.titleL.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerTopLeft) cornerRadii:CGSizeMake(5,5)];//圆角大小
        CAShapeLayer *maskLayerL = [[CAShapeLayer alloc] init];
        maskLayerL.frame = self.titleL.bounds;
        maskLayerL.path = maskPathLabel.CGPath;
        self.titleL.layer.mask = maskLayerL;
        [upVeiw addSubview:_titleL];
        //分割线
        UIView *splitView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, [UIScreen mainScreen].bounds.size.width, 0.5)];
        splitView.backgroundColor = [UIColor hexStringToColor:@"#F5F5F5"];
        [upVeiw addSubview:splitView];
        
        
        NSCalendar *calendar0 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
        comps = [calendar0 components:unitFlags fromDate:[NSDate date]];
        NSInteger year = [comps year];
        //起始结束时间
        startYear = year-70;
        yearRange=110;
        [self setCurrentDate:[NSDate date]];
    }
    return self;
}


#pragma mark -- UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.pickerViewMode == DatePickerViewDateTimeMode) {
        return 5;
    }else if (self.pickerViewMode == DatePickerViewDateNoDayMode){
        return 2;
    }else if (self.pickerViewMode == DatePickerViewDateMode){
        return 3;
    }else if (self.pickerViewMode == DatePickerViewTimeMode){
        return 2;
    }
    return 0;
}


//确定每一列返回的东西
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.pickerViewMode == DatePickerViewDateTimeMode) {
        switch (component) {
            case 0:
            {
                return yearRange;
            }
                break;
            case 1:
            {
                return 12;
            }
                break;
            case 2:
            {
                return dayRange;
            }
                break;
            case 3:
            {
                return 24;
            }
                break;
            case 4:
            {
                return 60;
            }
                break;
                
            default:
                break;
        }
    }else if (self.pickerViewMode == DatePickerViewDateNoDayMode){
        switch (component) {
            case 0:
            {
                return yearRange;
            }
                break;
            case 1:
            {
                return 12;
            }
                break;
                
            default:
                break;
        }
    }else if (self.pickerViewMode == DatePickerViewDateMode){
        switch (component) {
            case 0:
            {
                return yearRange;
            }
                break;
            case 1:
            {
                return 12;
            }
                break;
            case 2:
            {
                return dayRange;
            }
                break;
    
            default:
                break;
        }
    }else if (self.pickerViewMode == DatePickerViewTimeMode){
        switch (component) {
            
            case 0:
            {
                return 24;
            }
                break;
            case 1:
            {
                return 60;
            }
                break;
                
            default:
                break;
        }
    }
    
    return 0;
}

#pragma mark -- UIPickerViewDelegate
//默认时间的处理
-(void)setCurrentDate:(NSDate *)currentDate
{
    //获取当前时间
    NSCalendar *calendar0 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    comps = [calendar0 components:unitFlags fromDate:currentDate];
    NSInteger year=[comps year];
    NSInteger month=[comps month];
    NSInteger day=[comps day];
    NSInteger hour=[comps hour];
    NSInteger minute=[comps minute];
    
    selectedYear=year;
    selectedMonth=month;
    selectedDay=day;
    selectedHour=hour;
    selectedMinute=minute;
    
    dayRange=[self isAllDay:year andMonth:month];
    
    if (self.pickerViewMode == DatePickerViewDateTimeMode) {
        [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
        [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
        [self.pickerView selectRow:day-1 inComponent:2 animated:NO];
        [self.pickerView selectRow:hour inComponent:3 animated:NO];
        [self.pickerView selectRow:minute inComponent:4 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
        [self pickerView:self.pickerView didSelectRow:month-1 inComponent:1];
        [self pickerView:self.pickerView didSelectRow:day-1 inComponent:2];
        [self pickerView:self.pickerView didSelectRow:hour inComponent:3];
        [self pickerView:self.pickerView didSelectRow:minute inComponent:4];
        
        
    }else if (self.pickerViewMode == DatePickerViewDateNoDayMode){
        [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
        [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
        [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
        [self pickerView:self.pickerView didSelectRow:month-1 inComponent:1];
        
    }else if (self.pickerViewMode == DatePickerViewDateMode){
        [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
        [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
        [self.pickerView selectRow:day-1 inComponent:2 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
        [self pickerView:self.pickerView didSelectRow:month-1 inComponent:1];
        [self pickerView:self.pickerView didSelectRow:day-1 inComponent:2];
    }else if (self.pickerViewMode == DatePickerViewTimeMode){
        [self.pickerView selectRow:hour inComponent:0 animated:NO];
        [self.pickerView selectRow:minute inComponent:1 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:hour inComponent:0];
        [self pickerView:self.pickerView didSelectRow:minute inComponent:1];
    }

    [self.pickerView reloadAllComponents];
}


-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(Device_Width*component/6.0, 0,Device_Width/6.0, 30)];
    label.font=[UIFont systemFontOfSize:15.0];
    label.tag=component*100+row;
    label.textAlignment=NSTextAlignmentCenter;
    if (self.pickerViewMode == DatePickerViewDateTimeMode) {
        switch (component) {
            case 0:
            {
                label.text=[NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
            }
                break;
            case 1:
            {
                label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
            }
                break;
            case 2:
            {

                label.text=[NSString stringWithFormat:@"%ld日",(long)row+1];
            }
                break;
            case 3:
            {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld时",(long)row];
            }
                break;
            case 4:
            {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld分",(long)row];
            }
                break;
            case 5:
            {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld秒",(long)row];
            }
                break;
                
            default:
                break;
        }
    }else if (self.pickerViewMode == DatePickerViewDateNoDayMode){
        switch (component) {
            case 0:
            {
                label.text=[NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
            }
                break;
            case 1:
            {
                label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
            }
                break;
            default:
                break;
        }

    }else if (self.pickerViewMode == DatePickerViewDateMode){
        switch (component) {
            case 0:
            {
                label.text=[NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
            }
                break;
            case 1:
            {
                label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
            }
                break;
            case 2:
            {
                label.text=[NSString stringWithFormat:@"%ld日",(long)row+1];
            }
                break;
                
            default:
                break;
        }
    }else if (self.pickerViewMode == DatePickerViewTimeMode){
        switch (component) {
            case 0:
            {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld时",(long)row];
            }
                break;
            case 1:
            {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld分",(long)row];
            }
                break;
                
            default:
                break;
        }
    }
    return label;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (self.pickerViewMode == DatePickerViewDateTimeMode) {
        return ([UIScreen mainScreen].bounds.size.width-40)/5;
    }else if (self.pickerViewMode == DatePickerViewDateNoDayMode){
        return ([UIScreen mainScreen].bounds.size.width-40)/2;
    }else if (self.pickerViewMode == DatePickerViewDateMode){
        return ([UIScreen mainScreen].bounds.size.width-40)/3;
    }else if (self.pickerViewMode == DatePickerViewTimeMode){
        return ([UIScreen mainScreen].bounds.size.width-40)/2;
    }
    return 0;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}
// 监听picker的滑动
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.pickerViewMode == DatePickerViewDateTimeMode) {
        switch (component) {
            case 0:
            {
                selectedYear=startYear + row;
                dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 1:
            {
                selectedMonth=row+1;
                dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                if (dayRange < selectedDay) {
                    selectedDay = dayRange;
                }
                [self.pickerView reloadComponent:2];
            }
                break;
            case 2:
            {
                selectedDay=row+1;
            }
                break;
            case 3:
            {
                selectedHour=row;
            }
                break;
            case 4:
            {
                selectedMinute=row;
            }
                break;
                
            default:
                break;
        }
        _string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld",selectedYear,selectedMonth,selectedDay,selectedHour,selectedMinute];
    }else if (self.pickerViewMode == DatePickerViewDateNoDayMode){
        switch (component) {
            case 0:
            {
                selectedYear=startYear + row;
            }
                break;
            case 1:
            {
                selectedMonth=row+1;
            }
                break;
            default:
                break;
        }
        _string =[NSString stringWithFormat:@"%ld-%.2ld",selectedYear,selectedMonth];
    }else if (self.pickerViewMode == DatePickerViewDateMode){
        switch (component) {
            case 0:
            {
                selectedYear=startYear + row;
                dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 1:
            {
                selectedMonth=row+1;
                dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                if (dayRange < selectedDay) {
                    selectedDay = dayRange;
                }
                [self.pickerView reloadComponent:2];
            }
                break;
            case 2:
            {
                selectedDay=row+1;
            }
                break;
                
            default:
                break;
        }
        
        _string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld",selectedYear,selectedMonth,selectedDay];
    }else if (self.pickerViewMode == DatePickerViewTimeMode){
        switch (component) {
            case 0:
            {
                selectedHour=row;
            }
                break;
            case 1:
            {
                selectedMinute=row;
            }
                break;
            default:
                break;
        }
        _string =[NSString stringWithFormat:@"%.2ld:%.2ld",selectedHour,selectedMinute];
    }
}



#pragma mark -- show and hidden
- (void)showDateTimePickerView{
    [self setCurrentDate:[NSDate date]];
    self.frame = CGRectMake(0, 0, Device_Width, Device_Height);
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 1;
        self->_contentV.frame = CGRectMake(0, Device_Height-220-TabbarSafeBottomMargin, Device_Width, 220);
    } completion:^(BOOL finished) {

    }];
}
- (void)hideDateTimePickerView{
    
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 0;
        self->_contentV.frame = CGRectMake(0, Device_Height, Device_Width, 220);
    } completion:^(BOOL finished) {

        self.frame = CGRectMake(0, Device_Height, Device_Width, Device_Height);
    }];

}
#pragma mark - private
//取消的隐藏
- (void)cancelButtonClick
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didClickCancelDateTimePickerView)]) {
        [self.delegate didClickCancelDateTimePickerView];
    }
    
    [self hideDateTimePickerView];
    
}

//确认的隐藏
-(void)configButtonClick
{
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didClickFinishDateTimePickerView: andDatePickerView:)]) {
        [self.delegate didClickFinishDateTimePickerView:_string andDatePickerView:self];
    }
    [self hideDateTimePickerView];
}

-(NSInteger)isAllDay:(NSInteger)year andMonth:(NSInteger)month
{
    int day=0;
    switch(month)
    {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            day=31;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            day=30;
            break;
        case 2:
        {
            if(((year%4==0)&&(year%100!=0))||(year%400==0)){
                day=29;
                break;
            }else{
                day=28;
                break;
            }
        }
        default:
            break;
    }
    return day;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hideDateTimePickerView];
}

@end
