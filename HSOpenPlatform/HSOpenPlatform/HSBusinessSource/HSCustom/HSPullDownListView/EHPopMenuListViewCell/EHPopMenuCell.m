//
//  EHPopMenuCell.m
//  eHome
//
//  Created by 孟希羲 on 15/7/9.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHPopMenuCell.h"
#import "EHPopMenuModel.h"

@implementation EHPopMenuCell

-(void)setupView{
    [super setupView];
    self.backgroundColor = [UIColor clearColor];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [_titleLabel setFrame:CGRectMake(0, (self.height - _titleLabel.height)/2, self.width, _titleLabel.height)];
    [_iconImageView setFrame:CGRectMake(0, (self.height - _iconImageView.height)/2, _iconImageView.width, _iconImageView.height)];
}

-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 20)];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setTextColor:EHCor5];
        [_titleLabel setFont:EHFont2];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

-(UIImageView *)iconImageView{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [self addSubview:_iconImageView];
    }
    return _iconImageView;
}

-(void)configCellImageWithCellView:(id<KSViewCellProtocol>)cell Frame:(CGRect)rect componentItem:(EHPopMenuModel *)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    if (componentItem.iconImage) {
        [self.iconImageView setImage:componentItem.iconImage];
    }else if(componentItem.iconImageUrl){
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:componentItem.iconImageUrl]];
    }
}

-(void)configCellLabelWithCellView:(id<KSViewCellProtocol>)cell Frame:(CGRect)rect componentItem:(EHPopMenuModel *)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    [self.titleLabel setText:componentItem.titleText];
}

- (void)configCellWithCellView:(id<KSViewCellProtocol>)cell Frame:(CGRect)rect componentItem:(WeAppComponentBaseItem *)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    [super configCellWithCellView:cell Frame:rect componentItem:componentItem extroParams:extroParams];
    
    EHPopMenuModel* popMenuComponentItem = (EHPopMenuModel*)componentItem;
    if (![popMenuComponentItem isKindOfClass:[EHPopMenuModel class]]) {
        return;
    }
    [self configCellLabelWithCellView:cell Frame:rect componentItem:popMenuComponentItem extroParams:extroParams];
    [self configCellImageWithCellView:cell Frame:rect componentItem:popMenuComponentItem extroParams:extroParams];
}

- (void)didSelectCellWithCellView:(id<KSViewCellProtocol>)cell componentItem:(WeAppComponentBaseItem *)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    
}


@end
