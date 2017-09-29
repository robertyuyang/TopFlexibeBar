//
//  TopFiexibleBar.m
//  TopFlexibleBarDemo
//
//  Created by Robert Yu on 29/09/2017.
//  Copyright © 2017 Robert Yu. All rights reserved.
//

#import "TopFiexibleBar.h"

@interface TopFiexibleBar()<UIScrollViewDelegate>
@property (nonatomic, strong) UIView* segmentedBackground;

@property (nonatomic, weak) UIScrollView* scrollView;
@property (nonatomic, weak) id<UIScrollViewDelegate> oldScrollViewDelegate;
@property (nonatomic, weak) UIView* contentView;

@property (nonatomic) CGFloat height;
@property (nonatomic, assign)  CGFloat visibleTop;
@property (nonatomic, assign)  CGFloat invisibleTop;
@property (nonatomic, assign)  CGFloat middleVisibleTop;


@property (nonatomic, assign) BOOL scrollViewDragingUp;
@property (nonatomic, assign) BOOL scrollViewDragingDown;

@end
@implementation TopFiexibleBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setupUI];
    }
    return self;
}

-(void)setupUI {
    
    self.height = self.frame.size.height;
    self.visibleTop = 0;
    self.invisibleTop = 0 - self.height;
    self.middleVisibleTop =  (- self.height) /2.0;
    
    self.backgroundColor = [UIColor clearColor];
    self.layer.masksToBounds = YES;
    
    UIView* segmentedBackground = [[UIView alloc] initWithFrame:self.frame];
    segmentedBackground.backgroundColor = [UIColor whiteColor];
    segmentedBackground.layer.masksToBounds = YES;
    self.segmentedBackground = segmentedBackground;
    [self addSubview:segmentedBackground];
    
    
    
    
}

- (void)setScrollView:(UIScrollView*)scrollView contentView:(UIView*)contentView {
    self.scrollView = scrollView;
    self.contentView = contentView;
    
    [contentView removeFromSuperview];
    [self.segmentedBackground addSubview:contentView];
    
    
    scrollView.contentInset = UIEdgeInsetsMake(self.frame.size.height, 0, 0, 0);
    
    self.oldScrollViewDelegate =  self.scrollView.delegate;
    self.scrollView.delegate = self;
    
}


- (void)BookShelfCollectionViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGRect frame =  self.segmentedBackground.frame;
    
    
        //
    //如果用户上下拖拽后，顶端分类bar停在显示一部分的状态时（没有完全推走也没有完全显示），则需要特殊处理，
    //如果显示一多半，则分类bar向下显示完全
    //如果显示一小半，则分类bar向上运动隐藏。此时，如果scrollview顶端露出来了，需要随顶端bar往上移动
    
    
    _scrollViewDragingUp = NO;
    _scrollViewDragingDown = NO;
    
    if(frame.origin.y == self.visibleTop || frame.origin.y == self.invisibleTop){
        return;
    }
    
    
    
    CGFloat willMoveUpOffset = 0;
    if(frame.origin.y < self.middleVisibleTop){
        willMoveUpOffset = frame.origin.y - self.invisibleTop;
        frame.origin.y = self.invisibleTop;
        
    }
    else{//显示一多半
        frame.origin.y = self.visibleTop;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.segmentedBackground.frame = frame;
        if(willMoveUpOffset > 0){
            if((scrollView.contentOffset.y + scrollView.contentInset.top) < self.height) {
                [scrollView setContentOffset:CGPointMake(0, self.height - scrollView.contentInset.top ) animated:NO];
                
            }
        }
    }];
    
}
- (void)BookShelfCollectionViewDidScroll:(UIScrollView *)scrollView  {
    
    if(scrollView.contentSize.height < scrollView.frame.size.height){
        return;
    }
    
    UIPanGestureRecognizer *pan = scrollView.panGestureRecognizer;
    if(pan && pan.state == UIGestureRecognizerStatePossible){
        return;
        NSLog(@"dddddnopan%d ", pan.state);
    }
    //获取到拖拽的速度 >0 向下拖动 <0 向上拖动
    CGFloat velocity = [pan velocityInView:scrollView].y;
    
    CGFloat top = self.segmentedBackground.frame.origin.y;
    
    
    static CGFloat startDraggingY = 0;
    static CGFloat startDraggingSegmentY = 0;
    
    
    CGRect frame =  self.segmentedBackground.frame;
    
    if(velocity < 0) {//up
        if((scrollView.contentOffset.y + scrollView.contentInset.top) < 0) {
            return;
        }
        if(_scrollViewDragingUp) {
            frame.origin.y = startDraggingSegmentY - (scrollView.contentOffset.y - startDraggingY) ;
            if(frame.origin.y <= self.invisibleTop){
                frame.origin.y = self.invisibleTop;
                _scrollViewDragingUp = NO;
            }
            self.segmentedBackground.frame = frame;
            NSLog(@"ddddddddframe:%@", NSStringFromCGRect(frame));
        }
        else{
            if(frame.origin.y > self.invisibleTop) {
                startDraggingY = scrollView.contentOffset.y;
                startDraggingSegmentY = frame.origin.y;
                _scrollViewDragingUp = YES;
                _scrollViewDragingDown = NO;
            }
        }
        
        
    }
    else
    {//down
        if(_scrollViewDragingDown) {
            frame.origin.y = startDraggingSegmentY + (startDraggingY - scrollView.contentOffset.y) ;
            if(frame.origin.y >= self.visibleTop){
                frame.origin.y = self.visibleTop;
                _scrollViewDragingDown = NO;
            }
            self.segmentedBackground.frame = frame;
        }
        else{
            if(frame.origin.y < self.visibleTop) {
                startDraggingY = scrollView.contentOffset.y;
                startDraggingSegmentY = frame.origin.y;
                _scrollViewDragingDown = YES;
                _scrollViewDragingUp = NO;
            }
        }
        
    }
    
    NSLog(@("velocity %f"), scrollView.contentOffset.y);
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(!decelerate){
        [self BookShelfCollectionViewDidEndDecelerating:scrollView];
    }
    
    [self.oldScrollViewDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self BookShelfCollectionViewDidEndDecelerating:scrollView];
    [self.oldScrollViewDelegate scrollViewDidEndDecelerating:scrollView];
}// called when scroll view grinds to a halt


- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self BookShelfCollectionViewDidScroll:scrollView];
    [self.oldScrollViewDelegate scrollViewDidScroll:scrollView];
}


@end
