//
//  EHHomeNavBarTItleView.m
//  eHome
//
//  Created by 孟希羲 on 15/6/19.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "HSNavBarTitleCustomView.h"

@interface HSNavBarTitleCustomView()

@property (nonatomic, strong) UILabel              *title;

@end

@implementation HSNavBarTitleCustomView

-(void)setupView{
    [super setupView];
    [self initSelectImage];
    [self initTitleButton];
}

-(void)initSelectImage{
    self.selectImage = [UIImage imageNamed:@"public_arrow_tbar_up"];
    self.unSelectImage = [UIImage imageNamed:@"public_arrow_tbar_down"];
}

-(void)initTitleButton{
    _btn = [[UIButton alloc] initWithFrame:self.bounds];
    /*
     * 注释btn的使用，因为不容易控制图标与文字位置
    [_btn setTitle:@"暂无用户" forState:UIControlStateNormal];
    [_btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
    [_btn setTitleColor:[UIColor colorWithWhite:1.0 alpha:1] forState:UIControlStateNormal];
    [_btn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [_btn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    _btn.titleLabel.textAlignment = NSTextAlignmentCenter;
     [_btn setImageEdgeInsets:UIEdgeInsetsMake((_btn.height - 10)/2, _btn.width - 40 - 18, (_btn.height - 10)/2, 40)];
     */
    [_btn setBackgroundColor:[UIColor clearColor]];
    [_btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btn];
    
    _title = [[UILabel alloc] initWithFrame:self.bounds];
    [_title setFont:[UIFont boldSystemFontOfSize:18]];
    [_title setTextAlignment:NSTextAlignmentCenter];
    [_title setTextColor:UINAVIGATIONBAR_TITLE_COLOR];
    [_title setText:@""];
    [_title sizeToFit];
    [self addSubview:_title];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_title.right + 4 , (self.height - 6)/2, 10, 6)];
    [_imageView setImage:self.unSelectImage];
    [self addSubview:_imageView];
    
    [self setBtnImage:NO];

}

-(void)buttonClicked:(id)sender{
    self.btnIsSelected = !self.btnIsSelected;
    [self setBtnImage:self.btnIsSelected];
    if (self.buttonClicedBlock) {
        self.buttonClicedBlock(self);
    }
}

-(void)setButtonSelected:(BOOL)isSelected{
    self.btnIsSelected = isSelected;
    [self buttonClicked:nil];
}

-(void)setBtnImage:(BOOL)isSelected{
    if (isSelected) {
        [_imageView setImage:self.selectImage];
    }else{
        [_imageView setImage:self.unSelectImage];
    }
}

-(void)setBtnTitle:(NSString*)title
{
    if (title.length > 7) {
        title = [title substringToIndex:7];
        title = [title stringByAppendingString:@"..."];
    }
    [_title setText:title];
    [_title sizeToFit];
    [self layoutIfNeeded];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [_btn setFrame:self.bounds];
    [_title setOrigin:CGPointMake((self.width - _title.width)/2, (self.height - _title.height)/2)];
    [_imageView setOrigin:CGPointMake(_title.right + 5, (self.height - _imageView.height)/2)];
}

@end
