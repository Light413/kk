//
//  IMGBigCell.m
//  kantu
//
//  Created by gener on 16/8/8.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "IMGBigCell.h"

@implementation IMGBigCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.userInteractionEnabled = YES;
//    UIPinchGestureRecognizer *_pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
//    [self.imageView addGestureRecognizer:_pinch];
    
//    UIPanGestureRecognizer *_panges = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panActin:)];
//    [self.imageView addGestureRecognizer:_panges];
    
    UILongPressGestureRecognizer * _logPress =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(logPress:)];
    [self.imageView addGestureRecognizer:_logPress];
}

-(void)logPress :(UILongPressGestureRecognizer *)ges
{
    if (ges.state == UIGestureRecognizerStateBegan) {
        UIActionSheet * _sheet = [[UIActionSheet alloc]initWithTitle:@"save" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存到相册" otherButtonTitles:@"删除", nil];
        [_sheet showInView:self.superview];
    }

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0://delete
            if (_deletePictureBlock) {
                _deletePictureBlock();
            }
            break;
            
        case 1:UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, nil, nil);break;
        default:break;
    }

}

-(void)tapAction:(UIPinchGestureRecognizer*)gesture
{
    UIView * _img = gesture.view;
    _img.transform = CGAffineTransformScale(_img.transform, gesture.scale, gesture.scale);
    
    gesture.scale = 1.0;
}

-(void)panActin:(UIPanGestureRecognizer *)panGestureRecognizer
{
//    UIView * _img = panges.view;
//    CGPoint _point = [panges translationInView:_img.superview];
//    
//    _img.transform = CGAffineTransformMakeTranslation(_point.x, _point.y);
//    
////    [panges setTranslation:CGPointZero inView:_img.superview];
    CGPoint translation = [panGestureRecognizer translationInView:self.imageView];
    panGestureRecognizer.view.center = CGPointMake(panGestureRecognizer.view.center.x + translation.x,
                                         panGestureRecognizer.view.center.y + translation.y);
    [panGestureRecognizer setTranslation:CGPointZero inView:self.imageView];
}


-(void)setImgPath:(NSString *)imgPath
{
    self.imageView.transform = CGAffineTransformIdentity;
    UIImage *_img = [[UIImage alloc]initWithContentsOfFile:imgPath];
    _img =[_img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.imageView.image = _img;
}

@end
