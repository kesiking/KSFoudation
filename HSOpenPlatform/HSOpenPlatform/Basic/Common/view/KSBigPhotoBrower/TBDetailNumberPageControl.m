//
//  TBDetailNumberPageControl.m
//  TBTradeDetail
//
//  Created by chen shuting on 14/12/19.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "TBDetailNumberPageControl.h"

#define TBDETAIL_NUM_LABEL_WIDTH  42
#define TBDETAIL_NUM_LABEL_HEIGHT 14
#define TBDETAIL_NUM_HEIGHT       10
#define TBDETAIL_NUM_FONTSIZE     10
#define TBDETAIL_NUM_GAP          6

@interface TBDetailNumberPageControl ()
{
    UIColor *bgColor;
//    UIColor *borderColor;
}

@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIView  *bgView;

@end

@implementation TBDetailNumberPageControl

//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - System Method
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.width  = [TBDetailSystemUtil getCurrentDeviceWidth];
        bgColor     = [TBDetailUIStyle colorWithStyle:TBDetailColorStyle_Black alpha:0.4];
//        borderColor = [TBDetailUIStyle colorWithStyle:TBDetailColorStyle_Black alpha:0.16];
        [self addSubview:self.bgView];
        
//        [self drawEllipse];
    }
    return self;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Accessor
-(void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage      = currentPage;
    _numberLabel.text = [NSString stringWithFormat:@"%d/%d", _currentPage + 1, _numberOfPages];
}

-(void)setNumberOfPages:(NSInteger)numberOfPages
{
    _numberOfPages = numberOfPages;
    if (_numberOfPages <= 1) {
        _numberLabel.hidden = YES;
    }
//    [self setNeedsDisplay];
}

-(void)setHidesForSinglePage:(BOOL)hidesForSinglePage
{
    _hidesForSinglePage = hidesForSinglePage;
//    [self setNeedsDisplay];
}

-(UILabel *)numberLabel
{
    if (!_numberLabel) {
        CGRect frame = CGRectMake(0, 0, _bgView.width, _bgView.height + 2);
        _numberLabel = [[UILabel alloc] initWithFrame:frame];
        
        _numberLabel.textColor = [TBDetailUIStyle colorWithStyle:TBDetailColorStyle_White];
        _numberLabel.font      = [TBDetailUIStyle fontWithStyle:TBDetailFontStyle_EnglishBold
                                                   specificSize:TBDETAIL_NUM_FONTSIZE];
        _numberLabel.textAlignment   = NSTextAlignmentCenter;

        /*设置背景和mask*/
        _numberLabel.backgroundColor = [UIColor clearColor];
    }
    return _numberLabel;
}

//-(void)addSubLayerToView:(UIView *)view width:(CGFloat)width height:(CGFloat)height
//{
//    CALayer *paddingLayer = [[CALayer alloc] init];
//    paddingLayer.frame    = CGRectMake(-0.5, -0.5, width + 1, height + 1);
//    paddingLayer.borderColor  = borderColor.CGColor;
//    paddingLayer.borderWidth  = 0.5;
//    paddingLayer.cornerRadius = (height + 1) / 2;
//    [view.layer addSublayer:paddingLayer];
//}

-(UIView *)bgView
{
    if (!_bgView) {
        CGFloat x    = (self.width - TBDETAIL_NUM_LABEL_WIDTH) / 2;
        CGFloat y    = (self.height - TBDETAIL_NUM_LABEL_HEIGHT) / 2;
        CGRect frame = CGRectMake(x, y, TBDETAIL_NUM_LABEL_WIDTH, TBDETAIL_NUM_LABEL_HEIGHT);
        _bgView      = [[UIView alloc] initWithFrame:frame];
        
//        _bgView.backgroundColor    = [TBDetailUIStyle colorWithStyle:TBDetailColorStyle_Yellow];
        _bgView.backgroundColor = bgColor;
        _bgView.layer.cornerRadius = TBDETAIL_NUM_LABEL_HEIGHT / 2;
        
//        [self addSubLayerToView:_bgView width:_bgView.width height:_bgView.height];
        
        [_bgView addSubview:self.numberLabel];
    }
    return _bgView;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

//-(void)drawSingleEllipse:(CGFloat)x yPos:(CGFloat)y size:(CGFloat)size
//{
//    UIView *view            = [[UIView alloc] initWithFrame:CGRectMake(x, y, size, size)];
//    view.backgroundColor    = bgColor;
//    view.layer.cornerRadius = size / 2;
//    
//    [self addSubLayerToView:view width:size height:size];
//
//    [self addSubview:view];
//}
//
//-(void)drawOneSide:(NSInteger)number xPos:(CGFloat)x yPos:(CGFloat)y gap:(CGFloat)gap size:(CGFloat)size
//{
//    for (int i = 0; i < number; i++) {
//        [self drawSingleEllipse:x + gap * i yPos:y size:size];
//    }
//}
//
//-(void)drawEllipse
//{
//    CGFloat y    = self.bgView.top + (TBDETAIL_NUM_LABEL_HEIGHT - TBDETAIL_NUM_HEIGHT) / 2;
//    CGFloat size = TBDETAIL_NUM_HEIGHT;
//    CGFloat gap  = size + TBDETAIL_NUM_GAP;
//    NSInteger number = 2;
//
//    [self drawOneSide:number
//                 xPos:self.bgView.left - gap * 2
//                 yPos:y
//                  gap:gap
//                 size:size];
//    
//    [self drawOneSide:number
//                 xPos:self.bgView.right + TBDETAIL_NUM_GAP
//                 yPos:y
//                  gap:gap
//                 size:size];
//}

@end
