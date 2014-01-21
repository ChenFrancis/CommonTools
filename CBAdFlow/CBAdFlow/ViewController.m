//
//  ViewController.m
//  CBAdFlow
//
//  Created by xychen on 14-1-21.
//  Copyright (c) 2014年 CB. All rights reserved.
//

#import "ViewController.h"

#import "CBAdView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    /*
    UILabel *lbl = [[UILabel alloc] init];
    lbl.frame = CGRectMake(0, 0, 80, 40);
    lbl.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, CGRectGetHeight(self.view.frame)/2);
    lbl.text = @"首页";
    lbl.textAlignment = UITextAlignmentCenter;
    lbl.textColor = [UIColor blackColor];
    lbl.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lbl];
    
    self.title = lbl.text;
     */
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSMutableArray *arrayImg = [[NSMutableArray alloc] init];
    for (int i=0; i<3; i++)
    {
        CBImageInfo *imgInfo = [[CBImageInfo alloc] init];
        imgInfo.imgName = [NSString stringWithFormat:@"%d.jpg", (i+1)];
        [arrayImg addObject:imgInfo];
    }
    
    CBAdView *cbAdView = [[CBAdView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 240) imageArray:arrayImg];
    [self.view addSubview:cbAdView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
