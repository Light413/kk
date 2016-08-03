//
//  KKDateFormatter.h
//  kantu
//
//  Created by gener on 16/8/3.
//  Copyright © 2016年 Light. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DateStyleALLTime  @"yyyyMMddHHmmSS"

@interface KKDateFormatter : NSObject

+(NSString*)stringFromDateWithFormatter:(NSString *)s;

@end
