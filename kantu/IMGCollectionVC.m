//
//  ViewController.m
//  kantu
//
//  Created by gener on 16/7/19.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "IMGCollectionVC.h"
#import "IMCollectionViewCell.h"
#import "IMGBigPicVC.h"
#import "BaseNavigationController.h"
@interface IMGCollectionVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *_collectionView;
    
    NSMutableArray *_dataArray;
    UIImage *_img;
    
    LKDBHelper *_helper;
}
@end

@implementation IMGCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self initSubviews];

    _helper = [LKDBHelper getUsingLKDBHelper];
    _dataArray = [[NSMutableArray alloc]init];
    
    [self loadData];
}

-(void)initSubviews
{
    self.title = self.albumNAME;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBtnAction:)];
    
    UICollectionViewFlowLayout *_layout = [[UICollectionViewFlowLayout alloc]init];
    _layout.minimumLineSpacing = 8;
    _layout.minimumInteritemSpacing = 5;//96/128
    float _w = (CURRNET_SCREEN_WIDTH - 30)/2.0;
    _layout.itemSize = CGSizeMake(_w, _w*4 / 3.0);
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, CURRNET_SCREEN_WIDTH, CURRENT_SCREEN_HEIGHT) collectionViewLayout:_layout];
    _collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _collectionView.delegate  =self;
    _collectionView.dataSource =self;
    _collectionView.backgroundColor  =[UIColor whiteColor];
    [_collectionView registerNib:[UINib nibWithNibName:@"IMCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"IMCollectionViewCellIdentifier"];
    [self.view addSubview:_collectionView];
}

-(void)loadData
{
    [_dataArray removeAllObjects];
    
    NSArray *_arr = [_helper search:[IMGModel class] where:[NSString stringWithFormat:@"albumID = '%@'",self.albumID] orderBy:@"imgName desc" offset:0 count:INT16_MAX];
    if (_arr.count > 0) {
        [_dataArray addObjectsFromArray:_arr];
    }
    
    [_collectionView reloadData];
}


- (void)addBtnAction:(id)sender {
    
    UIImagePickerController *_picker = [[UIImagePickerController alloc]init];
    _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _picker.delegate  =self;
    _picker.allowsEditing = YES;
    
    [self.navigationController presentViewController:_picker animated:YES completion:^{
        
    }];
    
    
}

#pragma mark - UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IMCollectionViewCell *_cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IMCollectionViewCellIdentifier" forIndexPath:indexPath];
    IMGModel *_m = [_dataArray objectAtIndex:indexPath.row];
    NSString *_imgPath = [NSString stringWithFormat:@"%@/%@",IMGFilePath,_m.imgName];

    _cell.imgView.image = [[UIImage alloc]initWithContentsOfFile:_imgPath];
    return _cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    IMGBigPicVC * vc = [[IMGBigPicVC alloc]init];
    vc.dataArray = _dataArray;
    vc.selectIndex = indexPath.row;
    
    BaseNavigationController*_navigationVC = [[BaseNavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:_navigationVC animated:YES completion:^{
        
    }];
}


//{
//    UIImagePickerControllerCropRect = "NSRect: {{0, 0}, {640, 634}}";
//    UIImagePickerControllerEditedImage = "<UIImage: 0x15ff486a0> size {640, 634} orientation 0 scale 1.000000";
//    UIImagePickerControllerMediaType = "public.image";
//    UIImagePickerControllerOriginalImage = "<UIImage: 0x15ffbed40> size {640, 635} orientation 0 scale 1.000000";
//    UIImagePickerControllerReferenceURL = "assets-library://asset/asset.JPG?id=11231BE8-1027-4184-9E85-F8F8D0589FEB&ext=JPG";
//}

#pragma mark UIImagePickerDelegate methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    _img = info[@"UIImagePickerControllerOriginalImage"];
    [self saveWithImg:_img];
    
   [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self loadData];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)saveWithImg:(UIImage *)img
{
    NSDateFormatter *_formatter = [[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"yyyyMMdd"];
    NSString *time = [_formatter stringFromDate:[NSDate date]];
    
    NSArray *_arr = [_helper search:[IMGModel class] where:[NSString stringWithFormat:@"imgDate = '%@'",time] orderBy:@"imgNumber desc" offset:0 count:INT16_MAX];
    IMGModel * _m  = nil;
    if (_arr && _arr.count > 0) {
        _m = [_arr firstObject];
    }

    IMGModel * addM = [[IMGModel alloc]init];
    if (_m) {
        addM.imgDate = _m.imgDate;
        addM.imgName = [NSString stringWithFormat:@"%@_%ld.png",_m.imgDate,[_m.imgNumber integerValue]+1];
        addM.imgNumber = [NSString stringWithFormat:@"%ld",[_m.imgNumber integerValue]+1];
        addM.albumID = self.albumID;
    }
    else
    {
        addM.imgDate = time;
        addM.imgName = [NSString stringWithFormat:@"%@_%d.png",time,0];
        addM.imgNumber = [NSString stringWithFormat:@"%d",0];
        addM.albumID = self.albumID;
    }
    [_helper insertToDB:addM];
    
    NSData *_data = UIImagePNGRepresentation(img);
    if (![[NSFileManager defaultManager]fileExistsAtPath:IMGFilePath isDirectory:nil]) {
        [[NSFileManager defaultManager]createDirectoryAtPath:IMGFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *_path = [NSString stringWithFormat:@"%@/%@",IMGFilePath,addM.imgName];
    [_data writeToFile:_path atomically:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
