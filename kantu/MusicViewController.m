//
//  MusicViewController.m
//  kantu
//
//  Created by gener on 16/8/12.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "MusicViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface MusicViewController ()<AVAudioPlayerDelegate>
{
    AVAudioPlayer * _player;
    UILabel * _timeLab;
    NSTimer * _timer;
}
@end

@implementation MusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"music";
    self.view.backgroundColor = DefaultBgColor;
    
    [self initSubviews];
    
    [self initData];
    
}

-(void)initSubviews
{
     _timeLab = [[UILabel alloc]init];
    [self.view addSubview:_timeLab];
    _timeLab.backgroundColor = [UIColor lightGrayColor];
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).with.offset(10);
        make.trailing.equalTo(self.view).with.offset(-10);
        make.top.equalTo(self.view).with.offset(100);
        make.height.mas_equalTo(30);
    }];
    
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor lightGrayColor];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"Start" forState:UIControlStateNormal];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).with.offset(0);
        make.trailing.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(self.view).with.offset(0);
        make.height.mas_equalTo(50);
    }];
    
}

-(void)initData
{
    NSError * error;
//    NSString * _url = [[NSBundle mainBundle]pathForResource:@"梁静茹-偶阵雨" ofType:@"mp3"];
//    NSData * _data = [[NSData alloc]initWithContentsOfFile:_url];
//    _player = [[AVAudioPlayer alloc]initWithData:_data error:&error];
    //http://audio.xmcdn.com/group5/M00/EA/37/wKgDtVSRS8DT3Bo7AA98QRJYwRc523.mp3
    
    NSData * _data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://audio.xmcdn.com/group5/M00/EA/37/wKgDtVSRS8DT3Bo7AA98QRJYwRc523.mp3"]];
    _player = [[AVAudioPlayer alloc]initWithData:_data error:&error];
    
    _player.delegate  = self;
    _player.volume = 0.3;
#if TARGET_OS_IOS
    [_player prepareToPlay];
#endif
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}


-(void)timerAction
{
    _timeLab.text = [NSString stringWithFormat:@"%.1f : %.1f",_player.currentTime,_player.duration];
}


-(void)btnAction :(UIButton *)btn
{
    if ([_player isPlaying]) {
        [btn setTitle:@"Start" forState:UIControlStateNormal];
        [_player pause];
        [_timer setFireDate:[NSDate distantFuture]];
    }
    else
    {
        [btn setTitle:@"Pause" forState:UIControlStateNormal];
        [_player play];
        [_timer setFireDate:[NSDate distantPast]];
    }
    
}

#pragma mark - AVAudioPlayerDelegate
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag) {
        NSLog(@"play end");
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
