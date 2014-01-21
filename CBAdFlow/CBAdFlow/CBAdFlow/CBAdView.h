//
//  CBAdView.h
//  CBAdFlow
//
//  Created by xychen on 14-1-21.
//  Copyright (c) 2014年 CB. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CBImageInfo.h"

@interface CBAdView : UIView <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scroAd;
@property (strong, nonatomic) UIPageControl *pc;

- (id)initWithFrame:(CGRect)frame imageArray:(NSArray *)arrayImg;

@end
