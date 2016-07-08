//
//  BadgeUtil.h
//  zhefengle
//
//  Created by dasheng on 16/7/2.
//  Copyright © 2016年 vanwell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum{
    BadgePositionTypeNormal = 1,
    BadgePositionTypeService = 2
}BadgePositionType;

@interface UIKitUtil : NSObject

+ (UILabel *)getLabelWithFont:(UIFont *)font textColor:(UIColor *)color;

/**
 *  画一条虚线.
 *
 *  @param bounds               虚线的bounds
 *  @param startPoint           虚线开始画得点
 *  @param endPoint             虚线结束的点
 *  @param lineColor            虚线高亮部分显示的颜色
 *  @param hightedLineLength    虚线高亮部分的长度
 *  @param normalLineLength     虚线普通部分的长度
 *  @param lintWidth            虚线的宽度
 *
 *  @return return value description
 */
+ (UIImageView *)getDashLineImageBounds:(CGRect)bounds fromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint lineColor:(UIColor *)lineColor hightedLineLength:(CGFloat)hightedLineLength normalLineLength:(CGFloat)normalLineLength lineWidth:(CGFloat)lintWidth;

/**
 *  设置badge
 *
 *  @param superView    父view
 *  @param number       数字
 *  @param positionType positionType description
 */
+ (void)setBadgeInView:(UIView *)superView number:(NSInteger)number positionType:(BadgePositionType)positionType;

/**
 *  设置badge
 *
 *  @param superView 父view
 *  @param number    数字
 *  @param point     以右上角为坐标原点
 */
+ (void)setBadgeInView:(UIView *)superView number:(NSInteger)number positionPoint:(CGPoint)point;

@end
