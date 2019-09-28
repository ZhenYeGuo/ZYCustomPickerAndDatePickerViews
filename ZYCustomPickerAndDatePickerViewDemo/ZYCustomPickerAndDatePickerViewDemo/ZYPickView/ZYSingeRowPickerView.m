//
//  ZYSingeRowPickerView.m
//  YiLianHealth
//
//  Created by 郭树清 on 2019/9/3.
//  Copyright © 2019 KuoShuChing. All rights reserved.
//

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

#define PICKERVIEW_HEIGHT   256

#import "ZYSingeRowPickerView.h"
#import <Masonry.h>
#import "UIColor+KQExpanded.h"

@interface ZYSingeRowPickerView () <UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSInteger selectRow;
}

@end

@implementation ZYSingeRowPickerView


-(instancetype)initWithFrame:(CGRect)frame Title:(NSString *)titleStr chooseTitleNSArray:(NSArray *)array{
    
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    if (self) {
        
        [self addSubviewUIpickerViewAndButton:titleStr chooseArray:array];
    }
    return self;
}

-(instancetype)initWithTitle:(NSString *)titleStr chooseTitleNSArray:(NSArray *)array{
    
    self = [super initWithFrame:CGRectMake(0, 0, Device_Height, Device_Height)];
    self.backgroundColor = [UIColor clearColor];
    if (self) {
        [self addSubviewUIpickerViewAndButton:titleStr chooseArray:array];
    }
    return self;
}
-(void)addSubviewUIpickerViewAndButton:(NSString *)titleStr chooseArray:(NSArray *)pickerDataArray{
    // 背景view
    UIView *baseView = [[UIView alloc] init];
    baseView.backgroundColor = [UIColor clearColor];
    [self addSubview:baseView];
    [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
     make.height.mas_equalTo(PICKERVIEW_HEIGHT);
    }];
    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = titleStr;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:13.0];
    titleLabel.backgroundColor = [UIColor hexStringToColor:@"#58595D"];
    [baseView addSubview:titleLabel];
    titleLabel.layer.cornerRadius = 4;
    titleLabel.clipsToBounds = YES;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(baseView).offset(1);
        make.top.equalTo(baseView);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(25);
    }];
    
    // 分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor hexStringToColor:@"#58595D"];
    [baseView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(-2);
        make.left.equalTo(baseView);
        make.right.equalTo(baseView);
        make.height.mas_equalTo(2);
    }];
    
    // 确定 按钮
    UIButton *btnOK = [[UIButton alloc] init];
    [btnOK setTitle:@"确定" forState:UIControlStateNormal];
    [btnOK setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnOK.titleLabel.font = [UIFont systemFontOfSize:13];
    btnOK.backgroundColor = [UIColor hexStringToColor:@"#58595D"];
    [btnOK addTarget:self action:@selector(pickerViewBtnOK:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:btnOK];
    btnOK.layer.cornerRadius = 4;
    btnOK.clipsToBounds = YES;
    [btnOK mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(baseView).offset(-1);
        make.top.equalTo(baseView);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(25);
    }];
    //取消  按钮
    UIButton *btnCancel = [[UIButton alloc] init];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    btnCancel.backgroundColor = [UIColor hexStringToColor:@"#58595D"];
    btnCancel.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(pickerViewBtnCancel) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:btnCancel];
    btnCancel.layer.cornerRadius = 4;
    btnCancel.clipsToBounds = YES;
    [btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(btnOK.mas_left).offset(-4);
        make.top.equalTo(baseView);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(25);
    }];
    //选择内容 @【】；
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.backgroundColor = [UIColor whiteColor];
    [baseView addSubview:pickerView];
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(baseView);
        make.bottom.equalTo(baseView).offset(-TabbarSafeBottomMargin);
        make.top.equalTo(lineView.mas_bottom);
    }];
    
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    [baseView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pickerView.mas_bottom);
        make.left.right.bottom.equalTo(baseView);
    }];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerViewBtnCancel)];
    [self addGestureRecognizer:tapGesture];
    _pickerView = pickerView;
    // 数据源数组
    _arrPickerData = pickerDataArray;
}


#pragma mark - UIPickerViewDataSource
//返回多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    //    return self.number;
    return 1;
}

//每列对应多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (_arrPickerData.count == 0) {
        return 0;
    }
    return _arrPickerData.count;
}
//每行显示的数据
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return _arrPickerData[row];
}
#pragma mark - UIPickerViewDelegate
//选中pickerView的某一行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectRow = row;
}
//行高
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 50.0;
}
#pragma mark - Private Menthods

//弹出pickerView
- (void)popPickerView
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.frame = CGRectMake(0, 0, Device_Width, Device_Height);
                     }];
}



//确定
- (void)pickerViewBtnOK:(id)sender{
    
    if (self.selectBlock) {
        if (_arrPickerData.count == 0) {
            return;
        }
        self.selectBlock(_arrPickerData[selectRow],selectRow);
    }
    [self removeFromSuperview];
}

//取消
- (void)pickerViewBtnCancel
{
    
    [self removeFromSuperview];
    
}

@end
