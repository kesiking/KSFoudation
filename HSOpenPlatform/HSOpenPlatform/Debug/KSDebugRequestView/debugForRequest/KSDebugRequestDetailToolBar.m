//
//  KSDebugRequestDetailToolBar.m
//  HSOpenPlatform
//
//  Created by xtq on 15/12/9.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "KSDebugRequestDetailToolBar.h"

@interface KSDebugRequestDetailToolBar ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *returnBtn;

@property (nonatomic, strong) UIButton *uploadBtn;

@end

@implementation KSDebugRequestDetailToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.returnBtn];
        [self addSubview:self.uploadBtn];
    }
    return self;
}

- (void)showTotalFlowCount:(NSString *)flowCount {
    self.titleLabel.text = [NSString stringWithFormat:@"流量共 %@",flowCount];
}

- (void)returnBtnClick:(id)sender {
    !self.returnBtnClickedBlock?:self.returnBtnClickedBlock();
}

- (void)uploadBtnClick:(id)sender {
    !self.uploadBtnClickedBlock?:self.uploadBtnClickedBlock();
}

#pragma mark - Getters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width - 160)/2.0, 0, 160, 40)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)returnBtn {
    if (!_returnBtn) {
        _returnBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_returnBtn setTitle:@"返回" forState:UIControlStateNormal];
        [_returnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _returnBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_returnBtn addTarget:self action:@selector(returnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _returnBtn;
}

- (UIButton *)uploadBtn {
    if (!_uploadBtn) {
        _uploadBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 40, 0, 40, 40)];
        [_uploadBtn setTitle:@"上传" forState:UIControlStateNormal];
        [_uploadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _uploadBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_uploadBtn addTarget:self action:@selector(uploadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _uploadBtn;
}

@end
