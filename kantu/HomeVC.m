//
//  HomeVC.m
//  kantu
//
//  Created by gener on 16/8/3.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "HomeVC.h"
#import "AlbumListVC.h"
#import "MusicViewController.h"
#import "TestVC.h"

@interface HomeVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray * _dataArray;
}

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Coool";
    self.view.backgroundColor = DefaultBgColor;
    _dataArray = [[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"menulist" ofType:@"plist"]];
    
    [self initSubviews];
}

-(void)initSubviews
{
//    UIButton * _btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.view addSubview:_btn];
//    [_btn setTitle:@"ENTER" forState:UIControlStateNormal];
//    [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
//    [_btn addTarget:self action:@selector(btnBeginClick) forControlEvents:UIControlEventTouchUpInside];
//    [_btn setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forState:UIControlStateNormal];
//    [_btn setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forState:UIControlStateHighlighted];
//    
//    [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.view).with.offset(0);
//        make.trailing.equalTo(self.view).with.offset(0);
//        make.bottom.equalTo(self.view).with.offset(0);
//        make.height.mas_equalTo(45);
//    }];
    
    UITableView *_tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [self.view addSubview:_tableview];
    _tableview.tableFooterView = [[UIView alloc]init];
    
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}


-(void)btnBeginClick
{

}

#pragma mark - 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * _cellReuseIdentifier  = @"_cellReuseIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:_cellReuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_cellReuseIdentifier];
    }
    NSDictionary * dic  = _dataArray[indexPath.row];
    cell.textLabel.text = dic[@"TITLE"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        NSLog(@"不支持指纹识别");
        return;
    }
    
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    
    LAContext * ctx = [[LAContext alloc]init];
    
    dispatch_semaphore_wait(sem, dispatch_time(DISPATCH_TIME_NOW, DISPATCH_TIME_FOREVER));
    if ([ctx canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
        NSLog(@"is support");
        
        [ctx evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"需要验证你的指纹信息" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                NSLog(@"is success");
                dispatch_async(dispatch_get_main_queue(), ^{
                    dispatch_semaphore_signal(sem);
                });
                
            }
            else
            {
                NSLog(@"is cancle");
            }
            
        }];
    }

    dispatch_semaphore_wait(sem, dispatch_time(DISPATCH_TIME_NOW, DISPATCH_TIME_FOREVER));
    NSDictionary * dic  = _dataArray[indexPath.row];
    NSString * _identifier = dic[@"ID"];
    
    if ([_identifier isEqualToString:@"photoBrowserId"]) {
        UIViewController * vc = [[AlbumListVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([_identifier isEqualToString:@"musicId"])
    {
        UIViewController * vc = [[MusicViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([_identifier isEqualToString:@"afnId"])
    {
        UIViewController * vc = [[TestVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


-(void)testTouchID
{
    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        NSLog(@"不支持指纹识别");
        return;
    }
    
    LAContext * ctx = [[LAContext alloc]init];
    if ([ctx canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
        NSLog(@"is support");
        
        [ctx evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"需要验证你的指纹信息" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                NSLog(@"is success");
            }
            else
            {
                NSLog(@"is cancle");
            }
            
        }];
    }
    else
    {
        NSLog(@"testTouchID not support");
    }
}



@end





















