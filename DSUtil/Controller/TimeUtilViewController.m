//
//  TimeUtilViewController.m
//  DSUtil
//
//  Created by dasheng on 16/7/4.
//  Copyright © 2016年 dasheng. All rights reserved.
//

#import "TimeUtilViewController.h"
#import "TimeUtil.h"

@implementation TimeUtilViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    NSLog(@"%@",[TimeUtil getNowTime]);
    
    NSLog(@"%@",[TimeUtil yearArray]);
}

@end
