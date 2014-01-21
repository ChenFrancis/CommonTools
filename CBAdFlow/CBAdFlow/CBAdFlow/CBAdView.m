//
//  CBAdView.m
//  CBAdFlow
//
//  Created by xychen on 14-1-21.
//  Copyright (c) 2014年 CB. All rights reserved.
//

#import "CBAdView.h"

@implementation CBAdView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor darkGrayColor];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame imageArray:(NSArray *)arrayImg
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor darkGrayColor];
        
        self.scroAd = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.scroAd.pagingEnabled = YES;
        self.scroAd.showsHorizontalScrollIndicator = NO;
        self.scroAd.delegate = self;
        [self addSubview:self.scroAd];
        
        for (CBImageInfo *imgInfo in arrayImg)
        {
            NSUInteger index = [arrayImg indexOfObject:imgInfo];
            
            UIImage *img = [UIImage imageNamed:imgInfo.imgName];
            
            CGRect ivRect = CGRectMake(index * CGRectGetWidth(self.scroAd.frame), 0, CGRectGetWidth(self.scroAd.frame), CGRectGetHeight(self.scroAd.frame));
            UIImageView *iv = [[UIImageView alloc] initWithFrame:ivRect];
            iv.image = img;
            [self.scroAd addSubview:iv];
            
            CGSize contentSize = self.scroAd.frame.size;
            contentSize.width = CGRectGetMaxX(iv.frame);
            self.scroAd.contentSize = contentSize;
            
        }
        
        self.pc = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-20, CGRectGetWidth(self.scroAd.frame), 20)];
        self.pc.numberOfPages = arrayImg.count;
        [self insertSubview:self.pc aboveSubview:self.scroAd];
        
    }
    return self;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

// scrollView已经停止滚动,每次停止都会调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat scroWidth = scrollView.frame.size.width;
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger currentPage = offsetX / scroWidth;
    self.pc.currentPage = currentPage;
}

@end
