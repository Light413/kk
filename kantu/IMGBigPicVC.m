//
//  IMGBigPicVC.m
//  kantu
//
//  Created by gener on 16/8/8.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "IMGBigPicVC.h"
#import "IMGBigCell.h"

#define kSpaceWidth 20

@interface IMGBigPicVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
{
    UICollectionView * _collectionView;
}
@end

@implementation IMGBigPicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = [NSString stringWithFormat:@"%ld / %ld",++_selectIndex,_dataArray.count];
    
    [self initSubviews];
    [self initNavigationBar];

    [_collectionView reloadData];
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:--_selectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    [[UINavigationBar appearance] setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:19/255.0 green:153/255.0 blue:231/255.0 alpha:1]] forBarMetrics:UIBarMetricsDefault];
}

-(void)initNavigationBar
{
    UIButton * _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = CGRectMake(0, 0, 60, 60);
    [_btn setImageEdgeInsets:UIEdgeInsetsMake(10, 0, 10, 40)];
    
    [_btn setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_btn];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    self.navigationController.navigationBar.backIndicatorImage = nil;
}

-(void)backBtnAction  :(UIButton*)btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)imageWithColor:(UIColor*)color
{
    CGRect rect=CGRectMake(0,0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(void)tapAction
{
    BOOL _b = self.navigationController.navigationBar.hidden;
    [self showNavigationBar:_b];
}

-(void)showNavigationBar:(BOOL)show
{
    [[UIApplication sharedApplication]setStatusBarHidden:!show];
//    [self.navigationController setNavigationBarHidden:!show animated:NO];
    self.navigationController.navigationBar.hidden = !show;
}

#pragma mark - init
-(void)initSubviews
{
    UICollectionViewFlowLayout *_layout = [[UICollectionViewFlowLayout alloc]init];
    _layout.minimumLineSpacing = kSpaceWidth;
    _layout.itemSize = [self.view bounds].size;
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _layout.sectionInset = UIEdgeInsetsMake(0, kSpaceWidth / 2.0, 0, kSpaceWidth/2.0);
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:_layout];
    _collectionView.frame = CGRectMake(-kSpaceWidth / 2.0, 0, CURRNET_SCREEN_WIDTH + kSpaceWidth, CURRENT_SCREEN_HEIGHT);
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.delegate  =self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"IMGBigCell" bundle:nil] forCellWithReuseIdentifier:@"IMGBigCellIdentifier"];
    _collectionView.pagingEnabled = YES;
    
    [self.view addSubview:_collectionView];
    
    UITapGestureRecognizer * _tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    
    [self.view addGestureRecognizer:_tapGes];
}


#pragma mark -
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IMGBigCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IMGBigCellIdentifier" forIndexPath:indexPath];
    IMGModel *_m = [_dataArray objectAtIndex:indexPath.row];
    NSString *_imgPath = [NSString stringWithFormat:@"%@/%@",IMGFilePath,_m.imgName];
    cell.imgPath = _imgPath;
    cell.scrollView.delegate = self;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    ((IMGBigCell*)cell).scrollView.zoomScale = 1.0;
}

#pragma mark - UIScrollViewDelegate

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return scrollView.subviews[0];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _collectionView) {
        float _p = scrollView.contentOffset.x / (CURRNET_SCREEN_WIDTH + kSpaceWidth) + 1;
        self.title = [NSString stringWithFormat:@"%ld / %ld",(NSInteger)_p,_dataArray.count];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
