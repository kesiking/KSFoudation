//
//  KSLineBorderTextField.m
//  eHome
//
//  Created by 孟希羲 on 15/6/15.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSLineBorderTextField.h"

@interface KSLineBorderTextField()

@property (nonatomic, strong)  UIView*          lineView;

@property (nonatomic, strong)  UIView*          defaultLineView;

@end

@implementation KSLineBorderTextField

-(instancetype)init{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    
    self.lineEdgeInsets = UIEdgeInsetsZero;
    
    _defaultLineView = [[UIView alloc] initWithFrame:CGRectMake(0,  self.height - 0.5, self.frame.size.width, 0.5)];
    _defaultLineView.hidden = NO;
    [self addSubview:_defaultLineView];
    
    self.colorNotEditing = [UIColor colorWithWhite:0x99/255.0 alpha:1.0];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0,  self.height - 0.5, self.frame.size.width, 0.5)];
    _lineView.hidden = YES;
    [self addSubview:_lineView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.lineView setFrame:CGRectMake(self.lineEdgeInsets.left,  self.height - 0.5 - self.lineEdgeInsets.bottom, self.frame.size.width - self.lineEdgeInsets.left - self.lineEdgeInsets.right, 0.5)];
    [self.defaultLineView setFrame:CGRectMake(self.lineEdgeInsets.left,  self.height - 0.5 - self.lineEdgeInsets.bottom, self.frame.size.width - self.lineEdgeInsets.left - self.lineEdgeInsets.right, 0.5)];
}

-(void)setIsSecurityField:(BOOL)isSecurityField{
    _isSecurityField = isSecurityField;
    if (isSecurityField) {
        UIButton* rigthBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        rigthBtn.backgroundColor = [UIColor clearColor];
        [rigthBtn setImage:self.rightNormalImage?:[UIImage imageNamed:@"ico_input_password_gray"] forState:UIControlStateNormal];
        [rigthBtn setImageEdgeInsets:UIEdgeInsetsMake((rigthBtn.frame.size.height - 20)/2, (rigthBtn.frame.size.width - 30)/2, (rigthBtn.frame.size.height - 20)/2, (rigthBtn.frame.size.width - 30)/2)];
        [rigthBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.rightView = rigthBtn;
        self.rightViewMode = UITextFieldViewModeWhileEditing;
    }
}

-(void)setRightNormalImage:(UIImage *)rightNormalImage{
    _rightNormalImage = rightNormalImage;
    [self setupRightViewImage];
}

-(void)setRightSelectImage:(UIImage *)rightSelectImage{
    _rightSelectImage = rightSelectImage;
    [self setupRightViewImage];
}

-(void)setColorWhileEditing:(UIColor *)colorWhileEditing{
    _colorWhileEditing = colorWhileEditing;
    self.lineView.backgroundColor = colorWhileEditing;
}

-(void)setColorNotEditing:(UIColor *)colorNotEditing{
    _colorNotEditing = colorNotEditing;
    self.defaultLineView.backgroundColor = colorNotEditing;
}

-(void)setIsTextEditing:(BOOL)isTextEditing{
    _isTextEditing = isTextEditing;
    self.lineView.hidden = !isTextEditing;
}

-(void)rightBtnClicked:(id)sender{
    self.enabled = NO;
    self.secureTextEntry = !self.secureTextEntry;
    self.enabled = YES;
    [self becomeFirstResponder];
    [self setupRightViewImage];
}

-(void)setText:(NSString *)text{
    [super setText:text];
}

-(void)setupRightViewImage{
    // 修改密码可见展示
    UIView *rightView = self.rightView;
    if (rightView && [rightView isKindOfClass:[UIButton class]]) {
        UIButton* rightButton = (UIButton*)rightView;
        if (self.secureTextEntry) {
            [rightButton setImage:self.rightNormalImage?:[UIImage imageNamed:@"ico_input_password_gray"] forState:UIControlStateNormal];
        }else{
            [rightButton setImage:self.rightSelectImage?:[UIImage imageNamed:@"ico_input_password_press"] forState:UIControlStateNormal];
        }
    }
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    /*
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //指定直线样式
    CGContextSetLineCap(context,kCGLineCapSquare);
    //直线宽度
    CGContextSetLineWidth(context,0.5);
    //设置颜色
    CGContextSetRGBStrokeColor(context,0x99/255.0, 0x99/255.0, 0x99/255.0, 1.0);
    //开始绘制
    CGContextBeginPath(context);
    //画笔移动到点(31,170)
    CGContextMoveToPoint(context,self.bounds.origin.x, CGRectGetMaxY(self.bounds));
    //下一点
    CGContextAddLineToPoint(context,CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds));
    //绘制完成
    CGContextStrokePath(context);
     */
}

@end
