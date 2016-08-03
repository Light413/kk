//
//  HomeVC.m
//  kantu
//
//  Created by gener on 16/8/3.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "HomeVC.h"
#import "AlbumListVC.h"

@interface HomeVC ()

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Coool";
    self.view.backgroundColor = DefaultBgColor;
    
    [self initSubviews];
}

-(void)initSubviews
{
    UIButton * _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_btn];
    [_btn setTitle:@"ENTER" forState:UIControlStateNormal];
    [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_btn addTarget:self action:@selector(btnBeginClick) forControlEvents:UIControlEventTouchUpInside];
    [_btn setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forState:UIControlStateNormal];
    [_btn setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forState:UIControlStateHighlighted];
    
    [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).with.offset(0);
        make.trailing.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(self.view).with.offset(0);
        make.height.mas_equalTo(45);
    }];
}


-(void)btnBeginClick
{
    UIViewController * vc = [[AlbumListVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
