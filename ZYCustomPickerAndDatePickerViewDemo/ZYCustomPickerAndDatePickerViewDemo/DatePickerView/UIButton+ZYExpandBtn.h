//
//  UIButton+ZYExpandBtn.h
//  ZYExpandBtn
//
//  Created by GSQ on 2018/4/4.
//  Copyright © 2018年 GSQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZYButtonEdgeInsetsStyle) {
    ZYButtonEdgeInsetsStyleTop, // image在上，label在下
    ZYButtonEdgeInsetsStyleLeft, // image在左，label在右
    ZYButtonEdgeInsetsStyleBottom, // image在下，label在上
    ZYButtonEdgeInsetsStyleRight // image在右，label在左
};


#define  Font(f) [UIFont systemFontOfSize:(f)]

typedef void (^ButtonBlock)(UIButton *button);

@interface UIButton (ZYExpandBtn)

@property (nonatomic,strong) NSString *buttonId;//标识
@property (nonatomic,  copy) ButtonBlock block;//添加点击事件
@property (nonatomic,assign) UIEdgeInsets hitTestEdgeInsets;//点击区域，默认为（0，0，0，0）; 负的为扩大

//frame初始化
+(UIButton *)ZYButtonWithTitle:(NSString *)title  titleFont:(UIFont *)titleLabelFont Image:(UIImage *)image backgroundImage:(UIImage *)backgroundImage backgroundColor:(UIColor *)backgroundColor titleColor:(UIColor *)titleLabelColor frame:(CGRect)frame;
//约束初始化
+(UIButton *)ZYButtonNoFrameWithTitle:(NSString *)title  titleFont:(UIFont *)titleLabelFont Image:(UIImage *)image backgroundImage:(UIImage *)backgroundImage backgroundColor:(UIColor *)backgroundColor titleColor:(UIColor *)titleLabelColor;
//添加block
-(void)addClickBlock:(ButtonBlock)block;
/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(ZYButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;
@end
