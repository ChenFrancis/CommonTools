//
//  ViewController.m
//  CBBackgroundTimer
//
//  Created by xychen on 14-2-14.
//  Copyright (c) 2014年 CB. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSTimer *testTimer;
    float _second;
    UILabel *_lblSecond;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    /*
     参考代码
     http://code.eoe.cn/456/title/_iOS_NSTimer%E5%9C%A8%E5%90%8E%E5%8F%B0%E8%BF%90%E8%A1%8C
     
     */
    
    _lblSecond = [[UILabel alloc] init];
    _lblSecond.frame = CGRectMake(50, 50, 100, 50);
    _lblSecond.text = @"";
    _lblSecond.textAlignment = NSTextAlignmentCenter;
    _lblSecond.textColor = [UIColor blackColor];
    _lblSecond.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_lblSecond];
    
    [self setBackgroundTimer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBackgroundTimer
{
    _second = 0.0;
    
    UIApplication *app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid) {
                [app endBackgroundTask:bgTask];
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        testTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(addSecond) userInfo:nil repeats:YES];
        [testTimer fire];
        [[NSRunLoop currentRunLoop] addTimer:testTimer forMode:NSRunLoopCommonModes];
        
        [[NSRunLoop currentRunLoop] run];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid) {
                [app endBackgroundTask:bgTask];
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
}

// 倒计时
- (void)addSecond
{
    _second += 0.5;
    _lblSecond.text = [NSString stringWithFormat:@"%.1f", _second];
}

@end
