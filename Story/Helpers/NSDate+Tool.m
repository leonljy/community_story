//
//  NSDate+Tool.m
//  Story
//
//  Created by Leonljy on 2015. 10. 16..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import "NSDate+Tool.h"

@implementation NSDate (Tool)


-(NSDate *)dateWithZeroSecond{
    NSDate *todayTimeAndMinute;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *todayComponents = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self];
    NSInteger theDay = [todayComponents day];
    NSInteger theMonth = [todayComponents month];
    NSInteger theYear = [todayComponents year];
    NSInteger hour = [todayComponents hour];
    NSInteger minute = [todayComponents minute];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:theDay];
    [components setMonth:theMonth];
    [components setYear:theYear];
    [components setHour:hour];
    [components setMinute:minute];
    [components setSecond:0];
    todayTimeAndMinute = [gregorian dateFromComponents:components];
    
    return todayTimeAndMinute;
}


-(NSString *)remainTime{    
    NSTimeInterval oneHour = 60 * 60;
    NSTimeInterval oneMinute = 60;
    NSString *remainTime;
    NSTimeInterval difference = [self timeIntervalSinceNow];
    NSInteger hour = floor(difference / oneHour);
    NSInteger minute = floor((difference - hour * oneHour) / oneMinute);
    NSInteger second = round(difference - hour * oneHour - minute * oneMinute);
    
    NSNumber *numberMin = [NSNumber numberWithInteger:minute];
    NSNumber *numberSecond = [NSNumber numberWithInteger:second];
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.minimumIntegerDigits = 2;
    
    remainTime = [NSString stringWithFormat:@"%@ : %@", [numberFormatter stringFromNumber:numberMin], [numberFormatter stringFromNumber:numberSecond]];
    return remainTime;
}
@end
