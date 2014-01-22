//
//  ViewController.m
//  CBAdFlow
//
//  Created by xychen on 14-1-21.
//  Copyright (c) 2014年 CB. All rights reserved.
//

#import "ViewController.h"

#import "CBAdView.h"

@interface ViewController () <CBAdViewDelegate>

@end

@implementation ViewController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSMutableArray *arrayImg = [[NSMutableArray alloc] init];
    for (int i=0; i<3; i++)
    {
        CBImageInfo *imgInfo = [[CBImageInfo alloc] init];
        imgInfo.imgName = [NSString stringWithFormat:@"%d.jpg", (i+1)];
        [arrayImg addObject:imgInfo];
    }
    
    CBAdView *cbAdView = [[CBAdView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 240) imageArray:arrayImg];
    cbAdView.aDelegate = self;
    [self.view addSubview:cbAdView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CBAdViewDelegate
- (void)tapImage:(CBImageInfo *)imgInfo withIndex:(NSInteger)pageIndex
{
    NSLog(@"点击第%d张, imgInfo:%@", pageIndex, imgInfo);
}

@end
