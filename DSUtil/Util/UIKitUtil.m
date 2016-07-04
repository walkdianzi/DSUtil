//
//  BadgeUtil.m
//  zhefengle
//
//  Created by dasheng on 16/7/2.
//  Copyright © 2016年 vanwell. All rights reserved.
//

#import "UIKitUtil.h"

@interface UIKitUtilBadgeView : UILabel

@property (nonatomic, assign)BOOL isLayout;

@property (nonatomic) NSString *badgeValue;
// Badge background color
@property (nonatomic) UIColor *badgeBGColor;
// Badge text color
@property (nonatomic) UIColor *badgeTextColor;
// Badge font
@property (nonatomic) UIFont *badgeFont;
// Padding value for the badge
@property (nonatomic) CGFloat badgePadding;
// Minimum size badge to small
@property (nonatomic) CGFloat badgeMinSize;

@property BOOL shouldHideBadgeAtZero;
// Badge has a bounce animation when value changes
@property BOOL shouldAnimateBadge;

@end

@implementation UIKitUtilBadgeView

- (instancetype)init
{
    self = [super init];
    if (self) {
        // Default design initialization
        self.isLayout = YES;
        self.badgeBGColor   = [UIColor colorWithRed:255.0/255.0 green:22.0/255.0 blue:60.0/255.0 alpha:1];
        self.badgeTextColor = [UIColor whiteColor];
        self.badgeFont      = [UIFont systemFontOfSize:13.0];
        self.badgePadding   = 3;
        self.badgeMinSize   = 8;
        self.shouldHideBadgeAtZero = YES;
        self.shouldAnimateBadge = NO;
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)refreshBadge
{
    // Change new attributes
    self.textColor        = self.badgeTextColor;
    self.backgroundColor  = self.badgeBGColor;
    self.font             = self.badgeFont;
}

- (void)updateBadgeFrame
{
    // When the value changes the badge could need to get bigger
    // Calculate expected size to fit new value
    // Use an intermediate label to get expected size thanks to sizeToFit
    // We don't call sizeToFit on the true label to avoid bad display
    
    self.text = self.badgeValue;
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake([[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height) options:NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:self.font} context:nil];
    
    CGSize expectedLabelSize = rect.size;
    
    // Make sure that for small value, the badge will be big enough
    CGFloat minHeight = expectedLabelSize.height;
    
    // Using a const we make sure the badge respect the minimum size
    minHeight = (minHeight < self.badgeMinSize) ? self.badgeMinSize : expectedLabelSize.height;
    minHeight -= 1;
    CGFloat minWidth = expectedLabelSize.width+self.badgePadding+3;
    CGFloat padding = self.badgePadding;
    
    // Using const we make sure the badge doesn't get too smal
    minWidth = (minWidth < minHeight) ? minHeight : minWidth;
    //self.frame = CGRectMake(10, 10, minWidth + padding, minHeight + padding);
    if ([self.text integerValue]>0) {
        self.hidden = NO;
    }
    if (self.isLayout) {
        if (self.superview) {
            NSArray *constrains = self.superview.constraints;
            BOOL isWidth = NO;
            BOOL isHeight = NO;
            for (NSLayoutConstraint* constraint in constrains) {
                if (constraint.firstAttribute == NSLayoutAttributeWidth) {
                    constraint.constant = minWidth + padding;
                    isWidth = YES;
                }else if (constraint.firstAttribute == NSLayoutAttributeHeight){
                    constraint.constant = minHeight + padding;
                    isHeight = YES;
                }
            }
            if (!isWidth) {
                [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:minWidth + padding]];
            }
            if (!isHeight) {
                [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:minHeight + padding]];
            }
            
            [self layoutIfNeeded];
        }
    }else{
        CGRect frame = self.frame;
        frame.size.height = ceilf(minHeight + padding);
        frame.size.width = ceilf(minWidth + padding);
        self.frame = frame;
    }
    
    
    self.layer.cornerRadius = (minHeight + padding) / 2;
    self.layer.masksToBounds = YES;
}

- (void)updateBadgeValueAnimated:(BOOL)animated
{
    // Set the new value
    self.text = self.badgeValue;
    
    // Animate the size modification if needed
    
    [self updateBadgeFrame];
    
}

- (UILabel *)duplicateLabel:(UILabel *)labelToCopy
{
    UILabel *duplicateLabel = [[UILabel alloc] initWithFrame:labelToCopy.frame];
    duplicateLabel.text = labelToCopy.text;
    duplicateLabel.font = labelToCopy.font;
    
    return duplicateLabel;
}

- (void)removeBadge
{
    // Animate badge removal
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformMakeScale(0, 0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - Setters

- (void)setBadgeValue:(NSString *)badgeValue
{
    // Set new value
    _badgeValue = badgeValue;
    
    // When changing the badge value check if we need to remove the badge
    if (!badgeValue || [badgeValue isEqualToString:@""] || ([badgeValue isEqualToString:@"0"] && self.shouldHideBadgeAtZero)) {
        //[self removeBadge];
    }else {
        if ([badgeValue integerValue]>99) {
            _badgeValue = @"99+";
        }
        [self updateBadgeValueAnimated:YES];
    }
}

- (void)setBadgeBGColor:(UIColor *)badgeBGColor
{
    _badgeBGColor = badgeBGColor;
    
    if (self) {
        [self refreshBadge];
    }
}

- (void)setBadgeTextColor:(UIColor *)badgeTextColor
{
    _badgeTextColor = badgeTextColor;
    
    if (self) {
        [self refreshBadge];
    }
}

- (void)setBadgeFont:(UIFont *)badgeFont
{
    _badgeFont = badgeFont;
    
    if (self) {
        [self refreshBadge];
    }
}

- (void)setBadgePadding:(CGFloat)badgePadding
{
    _badgePadding = badgePadding;
    
    if (self) {
        [self updateBadgeFrame];
    }
}

- (void)setBadgeMinSize:(CGFloat)badgeMinSize
{
    _badgeMinSize = badgeMinSize;
    
    if (self) {
        [self updateBadgeFrame];
    }
}

@end

#pragma mark - 类方法

@implementation UIKitUtil

+ (UILabel *)getLabelWithFont:(UIFont *)font textColor:(UIColor *)color
{
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor whiteColor];
    label.font = font;
    label.textColor = color;
    return label;
}

//画一条虚线
+ (UIImageView *)getDashLineImageBounds:(CGRect)bounds fromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint lineColor:(UIColor *)lineColor hightedLineLength:(CGFloat)hightedLineLength normalLineLength:(CGFloat)normalLineLength lineWidth:(CGFloat)lintWidth{
    UIImageView *dashLine = [[UIImageView alloc]initWithFrame:bounds];
    UIGraphicsBeginImageContext(dashLine.frame.size);
    [dashLine.image drawInRect:dashLine.bounds];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    
    CGFloat lengths[] = {hightedLineLength,normalLineLength};
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, lineColor.CGColor);
    CGContextSetLineDash(line, 0, lengths, lintWidth);  //画虚线
    CGContextMoveToPoint(line, startPoint.x, startPoint.y);    //开始画线
    CGContextAddLineToPoint(line, endPoint.x,endPoint.y);
    CGContextStrokePath(line);
    dashLine.image = UIGraphicsGetImageFromCurrentImageContext();
    return dashLine;
}

+ (void)setBadgeInView:(UIView *)superView number:(NSInteger)number positionType:(BadgePositionType)positionType{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (UIView *subview in superView.subviews) {
            if ([subview isKindOfClass:[UIKitUtilBadgeView class]]) {
                UIKitUtilBadgeView *badge = (UIKitUtilBadgeView *)subview;
                if (number != 0) {
                    [badge setHidden:NO];
                    [badge setBadgeValue:[NSString stringWithFormat:@"%ld",(long)number]];
                }else{
                    [badge setHidden:YES];
                    [badge setBadgeValue:[NSString stringWithFormat:@"%ld",(long)number]];
                }
                [badge layoutIfNeeded];
                return;
            }
        }
        UIKitUtilBadgeView * badge = [[UIKitUtilBadgeView alloc] init];
        badge.frame = CGRectMake(0, 0, 5, 5);
        badge.translatesAutoresizingMaskIntoConstraints = NO;
        [superView addSubview:badge];
        [superView bringSubviewToFront:badge];
        switch (positionType) {
            case BadgePositionTypeNormal:{
                
                [superView addConstraint:[NSLayoutConstraint constraintWithItem:badge attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1.0 constant:-8]];
                [superView addConstraint:[NSLayoutConstraint constraintWithItem:badge attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-8]];
            }
                break;
            case BadgePositionTypeService:{
                
                [superView addConstraint:[NSLayoutConstraint constraintWithItem:badge attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
                [superView addConstraint:[NSLayoutConstraint constraintWithItem:badge attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-18]];
            }
                break;
            default:
                break;
        }
        if (number != 0) {
            [badge setHidden:NO];
            [badge setBadgeValue:[NSString stringWithFormat:@"%ld",(long)number]];
        }else{
            [badge setHidden:YES];
            [badge setBadgeValue:[NSString stringWithFormat:@"%ld",(long)number]];
        }
        [badge layoutIfNeeded];
    });
}

@end
