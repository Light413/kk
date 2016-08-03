//
//  KKDateFormatter.m
//  kantu
//
//  Created by gener on 16/8/3.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "KKDateFormatter.h"

@implementation KKDateFormatter

-(NSString *)stringFromDateWithFormatter:(NSString *)s
{
    NSDateFormatter * _dateF = [[NSDateFormatter alloc]init];
    [_dateF setDateFormat:s];
   return [_dateF stringFromDate:[NSDate date]];
}

+(NSString*)stringFromDateWithFormatter:(NSString *)s
{
    return [[self alloc] stringFromDateWithFormatter:s];
}

@end
