//
//  ViewController.m
//  ZYCustomPickerAndDatePickerView
//
//  Created by 郭树清 on 2019/9/19.
//  Copyright © 2019 KuoShuChing. All rights reserved.
//
#define weakSelf(weakSelf) __weak typeof(self)weakSelf = self;

#import "ViewController.h"
#import "UIButton+ZYExpandBtn.h"
#import "UIColor+KQExpanded.h"
//选择pickerView
#import "ZYSingeRowPickerView.h"
#import "ZYDateTimePickerView.h"

@interface ViewController ()<DateTimePickerViewDelegate>
//血型
@property (nonatomic,strong) NSArray *bloodTypeArray;
//民族
@property (nonatomic,strong) NSArray *nationArray;
//婚姻状况
@property (nonatomic,strong) NSArray *maritalStatusArray;
//工作
@property (nonatomic,strong) NSArray *jobArray;


@property (nonatomic,strong) UIButton *bloodTypeBtn;

@property (nonatomic,strong) UIButton *jobSelectBtn;

@property (nonatomic,strong) UIButton *nationSelectBtn;

//时间选择
@property (nonatomic,strong) UIButton *dateSelectBtn;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self singleViewSelelctViewAndAction];
    [self datePickerView];
    
}


#pragma mark   ------- 自定义单选框-------

- (void)singleViewSelelctViewAndAction{
    weakSelf(weakSelf)
    self.bloodTypeBtn = [UIButton ZYButtonWithTitle:@"选择血型" titleFont:[UIFont systemFontOfSize:16] Image:nil backgroundImage:nil backgroundColor:nil titleColor:[UIColor hexStringToColor:@"#333333"] frame:CGRectMake(15,100, 200, 50)];
    
    [self.bloodTypeBtn addClickBlock:^(UIButton *button) {
        [weakSelf pickerViewShowAndSelectResult:@"选择血型" andDataArray:weakSelf.bloodTypeArray btn:button];
    }];
    self.jobSelectBtn = [UIButton ZYButtonWithTitle:@"选择工作" titleFont:[UIFont systemFontOfSize:16] Image:nil backgroundImage:nil backgroundColor:nil titleColor:[UIColor hexStringToColor:@"#333333"] frame:CGRectMake(15,170, 200, 50)];
    [self.jobSelectBtn addClickBlock:^(UIButton *button) {
        [weakSelf pickerViewShowAndSelectResult:@"选择工作" andDataArray:weakSelf.jobArray btn:button];
    }];
    self.nationSelectBtn = [UIButton ZYButtonWithTitle:@"选择民族" titleFont:[UIFont systemFontOfSize:16] Image:nil backgroundImage:nil backgroundColor:nil titleColor:[UIColor hexStringToColor:@"#333333"] frame:CGRectMake(15,240, 200, 50)];
    [self.nationSelectBtn addClickBlock:^(UIButton *button) {
        [weakSelf pickerViewShowAndSelectResult:@"选择民族" andDataArray:weakSelf.nationArray btn:button];
    }];
    [self.view addSubview:self.jobSelectBtn];
    [self.view addSubview:self.nationSelectBtn];
    [self.view addSubview:self.bloodTypeBtn];
}


- (void)pickerViewShowAndSelectResult:(NSString*)selectTitleName andDataArray:(NSArray*)dataArray btn:(UIButton*)selectBtn{
    ZYSingeRowPickerView *picker = [[ZYSingeRowPickerView alloc] initWithTitle:selectTitleName chooseTitleNSArray:dataArray];
    picker.selectBlock = ^(id result, NSInteger index) {
        NSString *str = dataArray[index];
        [selectBtn setTitle:str forState:UIControlStateNormal];
    };
    [picker popPickerView];
    [self.view addSubview:picker];
}

- (NSArray*)bloodTypeArray{
    if (!_bloodTypeArray) {
        _bloodTypeArray = [NSArray arrayWithObjects:@"A型",@"B型",@"AB型",@"O型", nil];
    }
    return _bloodTypeArray;
}
- (NSArray*)nationArray{
    if (!_nationArray) {
        _nationArray = [NSArray arrayWithObjects:@"汉族", @"蒙古族", @"回族", @"藏族", @"维吾尔族", @"苗族", @"彝族", @"壮族", @"布依族", @"朝鲜族", @"满族", @"侗族", @"瑶族", @"白族", @"土家族",
                        @"哈尼族", @"哈萨克族", @"傣族", @"黎族", @"傈僳族", @"佤族", @"畲族", @"高山族", @"拉祜族", @"水族", @"东乡族", @"纳西族", @"景颇族", @"柯尔克孜族",
                        @"土族", @"达斡尔族", @"仫佬族", @"羌族", @"布朗族", @"撒拉族", @"毛南族", @"仡佬族", @"锡伯族", @"阿昌族", @"普米族", @"塔吉克族", @"怒族", @"乌孜别克族",
                        @"俄罗斯族", @"鄂温克族", @"德昂族", @"保安族", @"裕固族", @"京族", @"塔塔尔族", @"独龙族", @"鄂伦春族", @"赫哲族", @"门巴族", @"珞巴族", @"基诺族", nil];
    }
    return _nationArray;
}

- (NSArray*)jobArray{
    if (!_jobArray) {
        _jobArray = [NSArray arrayWithObjects:@"公司职员",@"医务人员", @"农民", @"商人", @"军人", @"教师", @"学生", @"公务员", @"工人", @"媒体", @"高管", @"其他", @"无",nil];
    }
    return _jobArray;
}



#pragma mark   ------- 时间选择-------
- (void)datePickerView{
    weakSelf(weakSelf)
    self.dateSelectBtn = [UIButton ZYButtonWithTitle:@"选择时间" titleFont:[UIFont systemFontOfSize:16] Image:nil backgroundImage:nil backgroundColor:nil titleColor:[UIColor hexStringToColor:@"#333333"] frame:CGRectMake(15,300, 200, 50)];
    
    [self.dateSelectBtn addClickBlock:^(UIButton *button) {
        [weakSelf dateSelectAction];
    }];
    [self.view addSubview:self.dateSelectBtn];
  
}
- (void)dateSelectAction{
    
    ZYDateTimePickerView *pickerView = [[ZYDateTimePickerView alloc] init];
    pickerView.titleL.text = @"日期";
    pickerView.delegate = self;
    pickerView.pickerViewMode = DatePickerViewDateMode;
    [self.view addSubview:pickerView];
    [pickerView showDateTimePickerView];
}

- (void)didClickFinishDateTimePickerView:(NSString *)date andDatePickerView:(UIView *)DateTimePickerView{
    
    [self.dateSelectBtn setTitle:[NSString stringWithFormat:@"%@",date] forState:UIControlStateNormal];
}


@end
