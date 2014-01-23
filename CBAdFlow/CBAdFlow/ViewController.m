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

@property (strong, nonatomic) CBAdView *cbAdView;

@end

@implementation ViewController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSMutableArray *arrayImg = [[NSMutableArray alloc] init];
    for (int i=0; i<1; i++)
    {
        CBImageInfo *imgInfo = [[CBImageInfo alloc] init];
        imgInfo.imgName = [NSString stringWithFormat:@"%d.jpg", (i+1)];
        [arrayImg addObject:imgInfo];
    }
    
    _cbAdView = [[CBAdView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 240) imageArray:arrayImg];
    _cbAdView.aDelegate = self;
    [_cbAdView setAutoScroll:YES second:2];
    [self.view addSubview:_cbAdView];
    
    UIButton *btnRefresh = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRefresh.frame = CGRectMake(0, 0, 110, 30);
    btnRefresh.backgroundColor = [UIColor whiteColor];
    [btnRefresh setTitle:@"点击刷新图片" forState:UIControlStateNormal];
    [btnRefresh setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnRefresh addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:btnRefresh aboveSubview:_cbAdView];
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

#pragma mark - ButtonAction
- (IBAction)refreshAction:(id)sender
{
    NSMutableArray *arrayImg = [[NSMutableArray alloc] init];
    for (int i=0; i<3; i++)
    {
        CBImageInfo *imgInfo = [[CBImageInfo alloc] init];
        imgInfo.imgName = [NSString stringWithFormat:@"%d.jpg", (i+1)];
        [arrayImg addObject:imgInfo];
    }
    
    [_cbAdView refreshFrame:_cbAdView.frame imageArray:arrayImg];
    [_cbAdView setAutoScroll:YES second:1];
}

@end
