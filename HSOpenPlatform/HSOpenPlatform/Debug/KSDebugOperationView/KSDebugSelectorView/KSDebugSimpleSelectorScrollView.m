//
//  KSDebugSimpleSelectorScrollView.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/12/1.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "KSDebugSimpleSelectorScrollView.h"
#import "KSDebugSelectorButton.h"

@interface KSDebugSimpleSelectorScrollView ()

@property (nonatomic,strong) UIImageView *imageScrollIndicatorView;


@end

@implementation KSDebugSimpleSelectorScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setupView {
    [super setupView];
    //add subclass setupView code
    _imageScrollIndicatorView = [[UIImageView alloc] init];
    _imageScrollIndicatorView.frame = CGRectZero;
    _imageScrollIndicatorView.opaque = YES;
    
    [_scrollView addSubview:_imageScrollIndicatorView];
    
    _scrollView.backgroundColor = [UIColor whiteColor];
    
    self.itemViewClass = [KSDebugSelectorButton class];
}

- (void)dealloc
{
    self.delegate = nil;
    self.sourceDelegate = nil;
}

-(void)setNeedIndicatorView:(BOOL)needIndicatorView{
    _needIndicatorView = needIndicatorView;
    _imageScrollIndicatorView.hidden = !needIndicatorView;
}

-(UIImageView*)getIndicatorView{
    if (_imageScrollIndicatorView) {
        return _imageScrollIndicatorView;
    }
    return nil;
}

-(void)setScrollIndicatorViewRate:(CGFloat)rate{
    if (self.imageScrollIndicatorView && self.needIndicatorView) {
        CGFloat newPositon = rate * self.buttonWidth;
        [UIView animateWithDuration:0.3 delay:0 options: UIViewAnimationOptionCurveEaseOut animations:^(){
            [self.imageScrollIndicatorView setFrame:CGRectMake(newPositon + (self.buttonWidth - self.imageScrollIndicatorView.frame.size.width)/2, self.imageScrollIndicatorView.frame.origin.y,  self.imageScrollIndicatorView.frame.size.width,  self.imageScrollIndicatorView.frame.size.height)];
        } completion:nil];
    }
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [_scrollView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TBSNSBasicSelectorProtocol method

-(void)setSelectorProperty:(KSDebugBasicMenuItemView*)itemView withIndex:(NSUInteger)index isSelect:(BOOL)isSelect{
    if (![itemView isMemberOfClass:self.itemViewClass]) {
        return;
    }
    KSDebugSelectorButton *btn = (KSDebugSelectorButton*)itemView;
    
    /***************************
     NSString *selectorName = nil;
     if (self.sourceDelegate && [self.sourceDelegate respondsToSelector:@selector(selectorView:selectorNameRowAtIndex:)]) {
     selectorName = [self.sourceDelegate selectorView:self selectorNameRowAtIndex:index];
     }
     //由设置函数setSelectorViewProperty的delegate实现
     else{
     if (self.dataSource == nil || [self.dataSource count] <= 0 || index > [self.dataSource count]) {
     return;
     }
     
     id object = [self.dataSource objectAtIndex:index];
     
     if (object == nil) {
     return;
     }
     
     if ([object isKindOfClass:[NSString class]]) {
     selectorName = (NSString*)object;
     }else if([object isKindOfClass:[NSDictionary class]]){
     NSDictionary *dicObject = (NSDictionary*)object;
     selectorName = [dicObject objectForKey:@"title"];
     }else if([object isKindOfClass:[TBModel class]] && [object respondsToSelector:@selector(title)]){
     selectorName = [object performSelector:@selector(title)];
     }
     }
     
     if (selectorName && selectorName.length > 0) {
     [btn setTitle:selectorName forState:UIControlStateNormal];
     }
     **************************/
    
    
    if (self.sourceDelegate && [self.sourceDelegate respondsToSelector:@selector(setSelectorViewProperty:itemView:withIndex:isSelect:)]) {
        [self.sourceDelegate setSelectorViewProperty:self itemView:btn withIndex:index isSelect:isSelect];
    }
}

//设置Selector的长宽属性
-(void)setSelectorFrame:(NSUInteger)pluginCnt defaultIndex:(NSUInteger)defaultIndex{
    [super setSelectorFrame:pluginCnt defaultIndex:defaultIndex];
    //重设需要的高度
    self.buttonHeight = self.frame.size.height;
    if (self.needIndicatorView) {
        self.imageScrollIndicatorView.frame = CGRectMake((self.buttonWidth - 28)/2, self.buttonHeight - 7, 28, 1);
    }
    
    if (self.sourceDelegate && [self.sourceDelegate respondsToSelector:@selector(setSelectorFrame:)]){
        [self.sourceDelegate setSelectorFrame:self];
    }else if (self.sourceDelegate && [self.sourceDelegate respondsToSelector:@selector(setSelectorFrame:buttonWidth:buttonHeight:)]) {
        //利用指针传递实现，该方法主要用于测试指针传值 -- 逸行
        CGFloat *buttonHeight = &_buttonHeight;
        CGFloat *buttonWidth = &_buttonWidth;
        *buttonHeight = self.buttonHeight;
        *buttonWidth = self.buttonWidth;
        [self.sourceDelegate setSelectorFrame:self buttonWidth:buttonWidth buttonHeight:buttonHeight];
    }
}

//Selector被选中时触发的事件，返回新选中的itemView与之前的itemView，如果需要做变化就继承该函数
-(BOOL)itemViewSelected:(KSDebugBasicMenuItemView*)itemView withOldItemView:(KSDebugBasicMenuItemView*)oldItemView{
    if (![itemView isMemberOfClass:self.itemViewClass] || ![oldItemView isMemberOfClass:self.itemViewClass]) {
        return NO;
    }
    KSDebugSelectorButton *btn = (KSDebugSelectorButton*)itemView;
    
    KSDebugSelectorButton *oldBtn = (KSDebugSelectorButton*)oldItemView;
    
    //如果按钮是重复按下的
    if (btn == oldBtn) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectorView:didSelectSameRowAtIndex:)]) {
            [self.delegate selectorView:self didSelectSameRowAtIndex:[self getIndexWithSelector:btn]];
        }
        return NO;
    }
    
    //改变当前选中btn的高亮状态以及还原之前的选中的oldBtn的状态
    if (self.sourceDelegate && [self.sourceDelegate respondsToSelector:@selector(changeSelectorViewProperty:itemView:withIndex:isSelect:)]) {
        NSUInteger newIndex = [self getIndexWithSelector:btn];
        NSUInteger oldIndex = [self getIndexWithSelector:oldBtn];
        
        [self.sourceDelegate changeSelectorViewProperty:self itemView:btn withIndex:newIndex isSelect:YES];
        [self.sourceDelegate changeSelectorViewProperty:self itemView:oldBtn withIndex:oldIndex isSelect:NO];
    }
    
    if (self.needIndicatorView) {
        [UIView animateWithDuration:0.3 delay:0 options: UIViewAnimationOptionCurveEaseOut animations:^(){
            [self.imageScrollIndicatorView setFrame:CGRectMake(btn.frame.origin.x + (btn.frame.size.width - self.imageScrollIndicatorView.frame.size.width)/2, self.imageScrollIndicatorView.frame.origin.y, self.imageScrollIndicatorView.frame.size.width, self.imageScrollIndicatorView.frame.size.height)];
        } completion:nil];
    }
    
    return YES;
}

//Selector被选中时触发的事件，返回新选中的itemView以及index值
-(void)itemViewSelected:(KSDebugBasicMenuItemView*)itemView atIndex:(NSUInteger)index{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectorView:didSelectRowAtIndex:)]) {
        [self.delegate selectorView:self didSelectRowAtIndex:index];
    }
}

//当Selector的容器SelectorScrollView完成配置后会调用
-(void)didSelectorScrollViewFinished:(UIScrollView*)scrollView{
    if (self.needIndicatorView) {
        [scrollView bringSubviewToFront:self.imageScrollIndicatorView];
    }
}

@end
