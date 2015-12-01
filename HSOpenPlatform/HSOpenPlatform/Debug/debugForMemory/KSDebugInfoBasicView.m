//
//  WeAppDebugInfoBasicView.m
//  WeAppSDK
//
//  Created by 逸行 on 15-2-10.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "KSDebugInfoBasicView.h"

@interface KSDebugInfoBasicView()

@property (nonatomic, strong) UILabel                       *titleLabel;
@property (nonatomic, strong) UILabel                       *infoLabel;

@end

@implementation KSDebugInfoBasicView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self load];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self load];
    }
    return self;
}

-(void)load{
    
}

-(void)unload{
    
}

-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,60, 30)];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [_titleLabel setTextColor:[UIColor redColor]];
        [_titleLabel setTextAlignment:NSTextAlignmentLeft];
        [_titleLabel setText:@""];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

-(UILabel *)infoLabel{
    if (_infoLabel == nil) {
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(70,0,250, 30)];
        [_infoLabel setBackgroundColor:[UIColor clearColor]];
        [_infoLabel setFont:[UIFont systemFontOfSize:15]];
        [_infoLabel setTextColor:[UIColor whiteColor]];
        [_infoLabel setTextAlignment:NSTextAlignmentLeft];
        [_infoLabel setText:@""];
        [self addSubview:_infoLabel];
    }
    return _infoLabel;
}

-(KSServiceDebug_PlotsView *)plotsView{
    if (_plotsView == nil) {
        _plotsView = [[KSServiceDebug_PlotsView alloc] initWithFrame:CGRectMake(0, 30,self.frame.size.width, self.frame.size.height - 30)];
        [self addSubview:_plotsView];
    }
    return _plotsView;
}

-(void)setLableInfo:(NSString*)info{
    self.infoLabel.text = info;
    [self.infoLabel sizeToFit];
}

-(void)setLableTitle:(NSString*)title{
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
    [self.infoLabel setFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 5, CGRectGetMinY(self.infoLabel.frame), self.infoLabel.frame.size.width, self.infoLabel.frame.size.height)];
}

-(void)dataDidChanged:(KSDebugMemoryModel *)debugModel{
    
}

- (void)dealloc
{
    [self unload];
    _infoLabel = nil;
}

@end
