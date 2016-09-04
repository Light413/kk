//
//  TestVC.m
//  kantu
//
//  Created by gener on 16/8/31.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "TestVC.h"
#import <AFNetworking.h>
#import <AVFoundation/AVFoundation.h>

@interface TestVC ()<AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession * _avsession;
    
}

@end

@implementation TestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
    _avsession = [[AVCaptureSession alloc]init];
    AVCaptureDevice * _devices = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput * _input = [AVCaptureDeviceInput deviceInputWithDevice:_devices error:nil];
    
    [_avsession addInput:_input];
    
    AVCaptureMetadataOutput * _output = [[AVCaptureMetadataOutput alloc]init];
    [_avsession addOutput:_output];
    _output . metadataObjectTypes = @[AVMetadataObjectTypeQRCode] ;
    
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    _output.rectOfInterest=CGRectMake(0.5,0,0.5, 1);
    
    AVCaptureVideoPreviewLayer * _layer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:_avsession];
    [_layer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_layer setFrame:self.view.layer.bounds];
    
    [self.view.layer insertSublayer:_layer atIndex:0];
    
    [_avsession startRunning];
}

- (void)systemLightSwitch:(BOOL)open
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        if (open) {
            [device setTorchMode:AVCaptureTorchModeOn];
        } else {
            [device setTorchMode:AVCaptureTorchModeOff];
        }
        [device unlockForConfiguration];
    }
}

//<AVMetadataMachineReadableCodeObject: 0x125d52f80, type="org.iso.QRCode", bounds={ 0.5,0.4 0.3x0.5 }>corners { 0.5,0.8 0.8,0.8 0.8,0.4 0.5,0.4 }, time 41452981066083, stringValue "hello666687870108"
//)
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count > 0) {
        [_avsession stopRunning];
        AVMetadataMachineReadableCodeObject *_obj = metadataObjects[0];
        
        NSLog(@"result : %@",[_obj stringValue]);
    }
}


@end
