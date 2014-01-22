//
//  CBAdView.m
//  CBAdFlow
//
//  Created by xychen on 14-1-21.
//  Copyright (c) 2014年 CB. All rights reserved.
//

#import "CBAdView.h"

@interface CBAdView ()

@property (strong, nonatomic) NSArray *arrayImg;
@property (nonatomic) NSInteger pageIndex;
@property (nonatomic) BOOL isScrolling;// 禁止用户在滚动时点击

@end

@implementation CBAdView

#pragma mark - Init
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
        _arrayImg = arrayImg;
        
        self.backgroundColor = [UIColor darkGrayColor];
        
        self.scroAd = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.scroAd.pagingEnabled = YES;
        self.scroAd.showsHorizontalScrollIndicator = NO;
        self.scroAd.delegate = self;
        [self addSubview:self.scroAd];
        
        // 记录 index 偏移量
        NSInteger indexOffset = 0;
        if (arrayImg.count > 1)//图片数大于1，设置前后循环页
        {
            indexOffset = 1;
        }
        else// 否则不允许循环
        {
            indexOffset = 0;
        }
        
        // 初始化主内容
        for (CBImageInfo *imgInfo in arrayImg)
        {
            NSUInteger index = [arrayImg indexOfObject:imgInfo] + indexOffset;
            
            UIImage *img = [UIImage imageNamed:imgInfo.imgName];
            
            CGRect ivRect = CGRectMake(index * CGRectGetWidth(self.scroAd.frame), 0, CGRectGetWidth(self.scroAd.frame), CGRectGetHeight(self.scroAd.frame));
            UIImageView *iv = [[UIImageView alloc] initWithFrame:ivRect];
            [self addImageViewSingleTap:iv];
            
            iv.image = img;
            [self.scroAd addSubview:iv];
            
            // 设置 contentSize
            CGSize contentSize = self.scroAd.frame.size;
            contentSize.width = CGRectGetMaxX(iv.frame);
            self.scroAd.contentSize = contentSize;
        }
        
        // 加入页首、页尾
        if (arrayImg.count > 1)
        {
            // 第一页的前一页
            CBImageInfo *imgInfo = [arrayImg lastObject];
            UIImage *img = [UIImage imageNamed:imgInfo.imgName];
            CGRect ivRect = CGRectMake(0, 0, CGRectGetWidth(self.scroAd.frame), CGRectGetHeight(self.scroAd.frame));
            UIImageView *iv = [[UIImageView alloc] initWithFrame:ivRect];
            iv.image = img;
            [self.scroAd addSubview:iv];
            
            // 最后一页的后一页
            CBImageInfo *imgInfo2 = [arrayImg firstObject];
            UIImage *img2 = [UIImage imageNamed:imgInfo2.imgName];
            CGRect ivRect2 = CGRectMake((arrayImg.count+1) * CGRectGetWidth(self.scroAd.frame), 0, CGRectGetWidth(self.scroAd.frame), CGRectGetHeight(self.scroAd.frame));
            UIImageView *iv2 = [[UIImageView alloc] initWithFrame:ivRect2];
            iv2.image = img2;
            [self.scroAd addSubview:iv2];
            
            // 设置 contentSize
            CGSize contentSize = self.scroAd.frame.size;
            contentSize.width = CGRectGetMaxX(iv2.frame);
            self.scroAd.contentSize = contentSize;
            
            // 设置 offset 显示第一页
            [self.scroAd setContentOffset:CGPointMake(CGRectGetWidth(self.scroAd.frame), 0) animated:NO];
            
            // 分页控制
            self.pc = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-20, CGRectGetWidth(self.scroAd.frame), 20)];
            self.pc.numberOfPages = arrayImg.count;
            self.pc.currentPage = 0;
            [self insertSubview:self.pc aboveSubview:self.scroAd];
        }
    }
    return self;
}

#pragma mark - GestureRecognizer
// 图片单击手势
- (void)addImageViewSingleTap:(UIImageView *)iv
{
    iv.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewSingleTapAction:)];
    singleTap.numberOfTapsRequired = 1; // 单击
    [iv addGestureRecognizer:singleTap];
}

#pragma mark - Tap Action
// 图片单击事件
- (void)imageViewSingleTapAction:(UITapGestureRecognizer*)recognizer
{
    NSLog(@"点击%@", recognizer);
    
    if (_isScrolling)// 正在滚动，禁止点击
    {
        return;
    }
    
    if (self.aDelegate && [self.aDelegate respondsToSelector:@selector(tapImage:withIndex:)])
    {
        CBImageInfo *imgInfo = [_arrayImg objectAtIndex:_pageIndex];
        [self.aDelegate tapImage:imgInfo withIndex:_pageIndex];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"正在滚动，禁用点击");
    _isScrolling = YES;
}

// scrollView已经停止滚动,每次停止都会调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat scroWidth = scrollView.frame.size.width;
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger currentPage = offsetX / scroWidth;
    NSInteger pageIndex = 0;
    if (0 == currentPage)// 到头了
    {
        // 翻到最后一页
        [scrollView setContentOffset:CGPointMake(_arrayImg.count * CGRectGetWidth(self.scroAd.frame), 0) animated:NO];
        pageIndex = _arrayImg.count-1;
    }
    else if (_arrayImg.count+1 == currentPage)// 到尾了
    {
        // 翻到第一页
        [scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scroAd.frame), 0) animated:NO];
        pageIndex = 0;
    }
    else
    {
        pageIndex = currentPage-1;
    }
    
    self.pc.currentPage = pageIndex;
    _pageIndex = pageIndex;
    
    NSLog(@"滚动结束，可以点击");
    _isScrolling = NO;
}

@end
