//
//  AlbumListVC.m
//  kantu
//
//  Created by gener on 16/8/3.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "AlbumListVC.h"
#import "KKDateFormatter.h"

#import "IMGCollectionVC.h"

@interface AlbumModel : NSObject
@property(nonatomic,copy)NSString * NAME;
@property(nonatomic,copy)NSString * ID;
@property(nonatomic,copy)NSString * DATE;
@end

@implementation AlbumModel

@end

@interface AlbumListVC ()<UIAlertViewDelegate>
{
    LKDBHelper * _helper;
    NSMutableArray * _dataArray;
}
@end

@implementation AlbumListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Album";
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    [self initSubviews];
    [self initData];
}

-(void)initData
{
    _helper = [LKDBHelper getUsingLKDBHelper];
    _dataArray = [[NSMutableArray alloc]init];
    
    NSArray *_arr = [_helper search:[AlbumModel class] where:nil orderBy:@"DATE desc" offset:0 count:100];
    if (_arr.count  > 0) {
        [_dataArray addObjectsFromArray:_arr];
        [self.tableView reloadData];
    }
}

-(void)initSubviews
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 50);
    btn.selected = NO;
    [btn setTitle:@"编辑" forState:UIControlStateNormal];
    [btn setTitle:@"完成" forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    UIButton *newBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     newBtn.frame = CGRectMake(0, 0, 250, 50);
    [newBtn setTitle:@"新建" forState:UIControlStateNormal];
    [newBtn addTarget:self action:@selector(newbtnAction) forControlEvents:UIControlEventTouchUpInside];
    newBtn.backgroundColor = DefaultBgColor;
    [newBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    newBtn.titleLabel.font  =[UIFont boldSystemFontOfSize:16];
    
    self.tableView.tableHeaderView = newBtn;
}

-(void)newbtnAction
{
    UIAlertView * _alert = [[UIAlertView alloc]initWithTitle:@"新建相册" message:@"请输入相册名称" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    _alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *tf  = [_alert  textFieldAtIndex:0];
    tf.placeholder = @"标题";
    
    [_alert show];
}

-(void)btnAction:(UIButton*)btn
{
    btn.selected = !btn.selected;
    
    [self.tableView setEditing:btn.selected animated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        UITextField *tf  = [alertView  textFieldAtIndex:0];
        if (tf.text.length > 0) {
            NSString * _time = [KKDateFormatter stringFromDateWithFormatter:DateStyleALLTime];
            AlbumModel * _m = [[AlbumModel alloc]init];
            _m.NAME = tf.text;
            _m.ID = _time;
            _m.DATE = _time;
            [_helper insertToDB:_m];
            
            NSArray *_arr = [_helper search:[AlbumModel class] where:nil orderBy:@"DATE desc" offset:0 count:100];
            if (_arr.count  > 0) {
                [_dataArray removeAllObjects];
                [_dataArray addObjectsFromArray:_arr];
                [self.tableView reloadData];
            }
            [self.tableView reloadData];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    AlbumModel *_m = _dataArray[indexPath.row];
    cell.textLabel.text = _m.NAME;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlbumModel *_m = _dataArray[indexPath.row];
    IMGCollectionVC * _vc = [[IMGCollectionVC alloc]init];
    _vc.albumNAME = _m.NAME;
    _vc.albumID = _m.ID;
    
    [self.navigationController pushViewController:_vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        AlbumModel *m = _dataArray[indexPath.row];
        //...删除该相册下图片
        [self deleteFileWithAlbumID:m.ID];
        [_helper deleteWithClass:[AlbumModel class] where:[NSString stringWithFormat:@"ID = '%@'",m.ID]];
         
        [_dataArray removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

-(void)deleteFileWithAlbumID:(NSString*)ID
{
    NSArray *_arr = [_helper search:[IMGModel class] where:[NSString stringWithFormat:@"albumID = '%@'",ID] orderBy:nil offset:0 count:INT16_MAX];
    for (int i =0; i < _arr.count; i++) {
        IMGModel *_m = [_arr objectAtIndex:i];
        NSString *_imgPath = [NSString stringWithFormat:@"%@/%@",IMGFilePath,_m.imgName];
        
        [[NSFileManager defaultManager]removeItemAtPath:_imgPath error:nil];
        [_helper deleteToDB:_m];
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
