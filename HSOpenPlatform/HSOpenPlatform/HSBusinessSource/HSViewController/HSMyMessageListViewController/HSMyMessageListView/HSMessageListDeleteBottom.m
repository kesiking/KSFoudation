//
//  ManWuCommodityDeleteBottom.m
//  basicFoundation
//
//  Created by 逸行 on 15-5-7.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "HSMessageListDeleteBottom.h"
#import "TBDetailSKUButton.h"

@interface HSMessageListDeleteBottom()

@property (nonatomic,strong) TBDetailSKUButton              *deleteBtn;

@end

@implementation HSMessageListDeleteBottom

-(void)setupView{
    [super setupView];
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.deleteBtn];
}

-(TBDetailSKUButton *)deleteBtn{
    if (_deleteBtn == nil) {
        CGRect rect = self.bounds;
        rect.origin.x = 53;
        rect.origin.y = (self.bounds.size.height - 40)/2;
        rect.size.width = self.bounds.size.width - 2 * rect.origin.x;
        rect.size.height = 40;
        _deleteBtn = [[TBDetailSKUButton alloc] initWithFrame:rect];
        
        _deleteBtn.reversesTitleShadowWhenHighlighted = NO;
        _deleteBtn.adjustsImageWhenHighlighted = NO;
        _deleteBtn.backgroundColor = RGB_A(0x00, 0x00, 0x00, 0.7);
        
        [_deleteBtn addTarget:self
                     action:@selector(deleteButtonClicked:)
           forControlEvents:UIControlEventTouchUpInside];
        
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn.titleLabel setFont:EHFont0];
        [_deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:UINEXTBUTTON_UNSELECT_COLOR forState:UIControlStateDisabled];
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"btn_complete_n"] forState:UIControlStateNormal];
        [_deleteBtn setImage:[UIImage imageNamed:@"btn_Delete"] forState:UIControlStateNormal];
        [_deleteBtn setImageEdgeInsets:UIEdgeInsetsMake(11.5, -7, 13.5, 0)];
        
        _deleteBtn.layer.cornerRadius = 5;
        _deleteBtn.layer.masksToBounds = YES;
        
        [self resizeButton:_deleteBtn];
        
        /*设置不同状态下的字体颜色*/
        [self setButtonStyle:_deleteBtn withStatus:UIControlStateNormal];
    }
    return _deleteBtn;
}

-(void)resizeButton:(TBDetailSKUButton*)button{
    button.clipsToBounds            = YES;
    button.titleLabel.numberOfLines = 2;
    button.titleLabel.font          = [UIFont boldSystemFontOfSize:17];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
}

-(void)setButtonStyle:(TBDetailSKUButton *)button withStatus:(UIControlState)state
{
    switch (state) {
        case UIControlStateSelected:{
            /*select状态*/
            button.buttonDidSeleced = YES;
            [button setTitleColor:[TBDetailUIStyle colorWithStyle:TBDetailColorStyle_Tag]
                         forState:UIControlStateNormal];
            [button setBorderColor:[TBDetailUIStyle colorWithStyle:TBDetailColorStyle_ComponentBg2]
                          forState:UIControlStateNormal];
        }
            break;
        case UIControlStateNormal:
        default:{
            /*normal状态*/
            button.buttonDidSeleced = NO;
            [button setTitleColor:[TBDetailUIStyle colorWithStyle:TBDetailColorStyle_Tag]
                         forState:UIControlStateNormal];
            [button setBorderColor:[TBDetailUIStyle colorWithStyle:TBDetailColorStyle_LineColor1]
                          forState:UIControlStateNormal];
        }
            break;
    }
}

-(void)deleteButtonClicked:(id)sender{
    if (self.deleteViewDidClickedBlock) {
        self.deleteViewDidClickedBlock();
    }
}

@end
