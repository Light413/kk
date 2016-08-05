//
//  IMGModel.h
//  kantu
//
//  Created by gener on 16/7/25.
//  Copyright © 2016年 Light. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMGModel : NSObject
@property(nonatomic,copy)NSString * imgName;//imgDate + imgNumber
@property(nonatomic,copy)NSString * imgDate;
@property(nonatomic,copy)NSString * imgNumber;
@property(nonatomic,copy)NSString * albumID;

@end
