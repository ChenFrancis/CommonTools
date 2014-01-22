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

@property (nonatomic) BOOL isAutoScroll;// 自动滚动
@property (strong, nonatomic) NSTimer *timerScro;
@property (nonatomic) int timeInterval;// 滚动的时间间隔

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
        _isScrolling = NO;
        _isAutoScroll = NO;// 默认不能自动滚动
        
        self.backgroundColor = [UIColor darkGrayColor];
        
        self.scroAd = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.scroAd.pagingEnabled = YES;
        self.scroAd.showsHorizontalScrollIndicator = NO;
        self.scroAd.delegate = self;
        [self addSubview:self.scroAd];
        
        [self initUI:arrayImg];
    }
    return self;
}

- (void)initUI:(NSArray *)arrayImg
{
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
        self.pc.userInteractionEnabled = NO;
        self.pc.numberOfPages = arrayImg.count;
        self.pc.currentPage = 0;
        [self insertSubview:self.pc aboveSubview:self.scroAd];
    }
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
        [scrollView setContentOffset:CGPointMake(_arrayImg.count * CGRectGetWidth(scrollView.frame), 0) animated:NO];
        pageIndex = _arrayImg.count-1;
    }
    else if (_arrayImg.count+1 == currentPage)// 到尾了
    {
        // 翻到第一页
        [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:NO];
        pageIndex = 0;
    }
    else
    {
        pageIndex = currentPage-1;
    }
    
    // 如果是单页，则不会初始化分页控制器
    if (self.pc)
    {
        self.pc.currentPage = pageIndex;
    }
    
    NSLog(@"第%d页", pageIndex);
    _pageIndex = pageIndex;
    
    NSLog(@"滚动结束，可以点击");
    _isScrolling = NO;
}

#pragma mark - AutoScroll
- (void)setAutoScroll:(BOOL)yesOrNo second:(CGFloat)second
{
    if (_arrayImg.count < 2)// 小于两张图片，禁止自动滚动
    {
        return;
    }
    
    _isAutoScroll = yesOrNo;
    
    
    if (_isAutoScroll)
    {
        if (second > 0)
        {
            _timeInterval = second;
        }
        else
        {
            _timeInterval = 1;
        }
        
        [_timerScro invalidate];
        _timerScro = nil;
        
        _timerScro = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(scrollingImage) userInfo:nil repeats:YES];
    }
}

- (void)scrollingImage
{
    [self autoPagingScroll:self.scroAd];
}

- (void)autoPagingScroll:(UIScrollView *)scrollView
{
    CGFloat scroWidth = scrollView.frame.size.width;
    CGFloat offsetX = scrollView.contentOffset.x;// 翻页前的偏移量
    NSInteger page = offsetX / scroWidth;// 翻页前的页码
    
    if (_arrayImg.count == page)
    {
        [scrollView setContentOffset:CGPointZero animated:NO];
        NSLog(@"重头开始");
    }
    
    CGFloat pageOffsetX = scrollView.contentOffset.x + CGRectGetWidth(scrollView.frame);// 将要设置的偏移量
    [scrollView setContentOffset:CGPointMake(pageOffsetX, 0) animated:YES];
    
    NSInteger currentPage = pageOffsetX / scroWidth;
    NSInteger pageIndex = currentPage - 1;
    NSLog(@"第%d页", pageIndex);
    _pageIndex = pageIndex;
    
    // 如果是单页，则不会初始化分页控制器
    if (self.pc)
    {
        self.pc.currentPage = pageIndex;
    }
}

#pragma mark - Refresh Data
- (void)refreshFrame:(CGRect)frame imageArray:(NSArray *)arrayImg
{
    // 禁用计时器
    [_timerScro invalidate];
    _timerScro = nil;
    
    // 移除图片
    for (UIView *aView in self.scroAd.subviews)
    {
        [aView removeFromSuperview];
    }
    
    // 重新初始化
    self.frame = frame;
    self.scroAd.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
    _arrayImg = arrayImg;
    
    [self initUI:arrayImg];
}

@end
