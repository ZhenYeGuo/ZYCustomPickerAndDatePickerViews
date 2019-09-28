//
//  ZYSingeRowPickerView.h
//  YiLianHealth
//
//  Created by 郭树清 on 2019/9/3.
//  Copyright © 2019 KuoShuChing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^PickerSelectRowBlock)(id result,NSInteger index);//

@interface ZYSingeRowPickerView : UIView

/**
 * 参数 数组
 */
@property (retain, nonatomic) NSArray *arrPickerData;

@property (retain, nonatomic) UIPickerView *pickerView;

/**
 * block
 */
@property (nonatomic, copy) PickerSelectRowBlock selectBlock;
/**
 * 显示view
 */
- (void)popPickerView;

/**
 *自定义方法 dai from
 */
-(instancetype)initWithFrame:(CGRect)frame Title:(NSString *)titleStr chooseTitleNSArray:(NSArray *)array;

/**
 *自定义方法
 */
-(instancetype)initWithTitle:(NSString *)titleStr chooseTitleNSArray:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
