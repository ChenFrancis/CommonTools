//
//  CBAdView.h
//  CBAdFlow
//
//  Created by xychen on 14-1-21.
//  Copyright (c) 2014年 CB. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CBImageInfo.h"

@protocol CBAdViewDelegate<NSObject>

@optional

- (void)tapImage:(CBImageInfo *)imgInfo withIndex:(NSInteger)pageIndex;

@end

@interface CBAdView : UIView <UIScrollViewDelegate>

@property (nonatomic,assign) id<CBAdViewDelegate> aDelegate;

@property (strong, nonatomic) UIScrollView *scroAd;
@property (strong, nonatomic) UIPageControl *pc;

- (id)initWithFrame:(CGRect)frame imageArray:(NSArray *)arrayImg;

// 设置自动滚动和切换时间
- (void)setAutoScroll:(BOOL)yesOrNo second:(CGFloat)second;

// 刷新Frame和图片
- (void)refreshFrame:(CGRect)frame imageArray:(NSArray *)arrayImg;

@end
