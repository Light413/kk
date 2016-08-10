//
//  IMGBigCell.h
//  kantu
//
//  Created by gener on 16/8/8.
//  Copyright © 2016年 Light. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMGBigCell : UICollectionViewCell<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property(nonatomic,copy)NSString * imgPath;

@property(nonatomic,copy)void(^deletePictureBlock)();

@end
