//
//  KSDebugRequestListToolBar.m
//  HSOpenPlatform
//
//  Created by xtq on 15/12/9.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "KSDebugRequestListToolBar.h"
#import "KSDebugRequestModel.h"

static NSString * const KSDebugRequestSortDefaultTitle = @"按时间排序";
static NSString * const KSDebugRequestSortByVCTitle    = @"按页面排序";

@interface KSDebugRequestListToolBar ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *clearBtn;

@property (nonatomic, strong) UIButton *sortBtn;

@property (nonatomic, assign) KSDebugRequestListShowType showType;

@end

@implementation KSDebugRequestListToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSNumber *showType = [defaults objectForKey:KSDebugRequestShowTypeKey];
        if (!showType) {
            showType = @(KSDebugRequestListShowTypeDefault);
        }
        self.showType = [showType integerValue];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.clearBtn];
        [self addSubview:self.sortBtn];
    }
    return self;
}

- (void)showTotalFlowCount {
    long long flowCount = [[[NSUserDefaults standardUserDefaults] objectForKey:KSDebugRequestFlowCountKey] longLongValue];
    self.titleLabel.text = [NSString stringWithFormat:@"流量共 %@",[KSDebugRequestModel getDataLengthStrWithLength:flowCount]];
}

- (void)clearBtnClick {
    !self.clearBtnClickedBlock?:self.clearBtnClickedBlock();
}

- (void)sortBtnClick {
    switch (self.showType) {
        case KSDebugRequestListShowTypeDefault: {
            [self.sortBtn setTitle:KSDebugRequestSortDefaultTitle forState:UIControlStateNormal];
            self.showType = KSDebugRequestListShowTypeSortByVC;
        }
            break;
        case KSDebugRequestListShowTypeSortByVC: {
            [self.sortBtn setTitle:KSDebugRequestSortByVCTitle forState:UIControlStateNormal];
            self.showType = KSDebugRequestListShowTypeDefault;
        }
            break;
        default:
            break;
    }
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:@(self.showType) forKey:KSDebugRequestShowTypeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];

    !self.sortBtnClickedBlock?:self.sortBtnClickedBlock(self.showType);
}

#pragma mark - Getters & Setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width - 160)/2.0, 0, 160, 40)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)clearBtn {
    if (!_clearBtn) {
        _clearBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_clearBtn setTitle:@"清除" forState:UIControlStateNormal];
        [_clearBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _clearBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_clearBtn addTarget:self action:@selector(clearBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearBtn;
}

- (UIButton *)sortBtn {
    if (!_sortBtn) {
        _sortBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 80, 0, 70, 40)];
        [_sortBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sortBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _sortBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_sortBtn addTarget:self action:@selector(sortBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        switch (self.showType) {
            case KSDebugRequestListShowTypeDefault:
                [self.sortBtn setTitle:KSDebugRequestSortByVCTitle forState:UIControlStateNormal];
                break;
            case KSDebugRequestListShowTypeSortByVC:
                [self.sortBtn setTitle:KSDebugRequestSortDefaultTitle forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }
    return _sortBtn;
}

@end
