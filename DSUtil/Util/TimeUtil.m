 //
//  SLUtil.m
//  TalkThings
//
//  Created by ZQD on 14-9-11.
//  Copyright (c) 2014年 Sillon. All rights reserved.
//

#import "TimeUtil.h"
#import <sys/utsname.h>

@implementation TimeUtil

+(NSString *)getNowTime{
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    NSString  *datetime=[NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld",(long)[dateComponent year],(long)[dateComponent month],(long)[dateComponent day],(long)[dateComponent hour],(long)[dateComponent minute]];
    return datetime;
}

+(long)getTimeDistance:(NSString *)time{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:time];
    
    NSTimeInterval  timeInterval = [destDate timeIntervalSinceNow];
    
    return  timeInterval;
}

+(NSString *)getTimeByTimeStamp:(NSString *)time{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:MM:ss"];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[time integerValue]];
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
}

+(NSString *)getTimeStamp{
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    
    return timeString;
}

+(NSArray *)yearArray{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
    
    int year = (int)[dateComponent year];
    
    NSMutableArray *_mutableArray = [[NSMutableArray alloc] init];
    for (int i=1915; i <= year; i++) {
        [_mutableArray addObject:[NSString stringWithFormat:@"%d年",i]];
    }
    
    return _mutableArray;
}

+(NSArray *)monthArray{
    
    
    NSMutableArray *_mutableArray = [[NSMutableArray alloc] init];
    for (int i=1; i <= 12; i++) {
        [_mutableArray addObject:[NSString stringWithFormat:@"%d月",i]];
    }
    
    return _mutableArray;
}

+(NSArray *)dayArray{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]];
    
    NSUInteger numberOfDaysInMonth = range.length;
    
    NSMutableArray *_mutableArray = [[NSMutableArray alloc] init];
    
    for (int i=1; i<= numberOfDaysInMonth; i++) {
        [_mutableArray addObject:[NSString stringWithFormat:@"%d日",i]];
    }
    
    return _mutableArray;
}

@end
