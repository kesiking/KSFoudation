//
//  HSBusinessInfoBasicView.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/12.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSBusinessInfoBasicView.h"

@implementation HSBusinessInfoBasicView

-(void)setBussinessDetailModel:(HSDeviceInfoModel *)bussinessDetailModel{
    _bussinessDetailModel = bussinessDetailModel;
    if (bussinessDetailModel != nil) {
        [self reloadData];
    }
}

-(UIView *)topline{
    if (_topline == nil) {
        _topline = [TBDetailUITools drawDivisionLine:0
                                                yPos:0
                                           lineWidth:self.width];
        [_topline setBackgroundColor:HS_linecor1];
        [self addSubview:_topline];
    }
    return _topline;
}

-(UIView *)endline{
    if (_endline == nil) {
        _endline = [TBDetailUITools drawDivisionLine:0
                                                yPos:self.height - 0.5
                                           lineWidth:self.width];
        [_endline setBackgroundColor:HS_linecor1];
        [self addSubview:_endline];
    }
    return _endline;
}

-(void)reloadData{
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [_topline setWidth:self.width];
    [_endline setFrame:CGRectMake(_endline.origin.x, self.height - 0.5, self.width, _endline.height)];
}

-(CGSize)sizeThatFits:(CGSize)size{
    return size;
}

@end
