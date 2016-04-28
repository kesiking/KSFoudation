//
//  HSAppDetailsCollectionViewCell.m
//  HSOpenPlatform
//
//  Created by jinmiao on 16/2/23.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import "HSAppDetailsCollectionViewCell.h"
#import "HSAppDetailPicModel.h"



@interface HSAppDetailsCollectionViewCell ()

@property (strong,nonatomic) UIImageView *appDetailImageView;

@end

@implementation HSAppDetailsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.appDetailImageView];
    }
    return self;
}

-(void)setModel:(WeAppComponentBaseItem *)model{
    [super setModel:model];
    if (![model isKindOfClass:[HSAppDetailPicModel class]]) {
        return;
    }
    HSAppDetailPicModel *appDetailPicModel = (HSAppDetailPicModel *)model;
    [self.appDetailImageView sd_setImageWithURL:[NSURL URLWithString:appDetailPicModel.appImage]];
     
     
//    [self.appIconImageView sd_setImageWithURL:[NSURL URLWithqString:appModel.appIconUrl] placeholderImage:[UIImage imageNamed:appModel.placeholderImageStr]];
    //[UIImage imageNamed:appPreviewModel.appDetailPicName];
}


-(UIImageView *)appDetailImageView{
    if (!_appDetailImageView) {
        _appDetailImageView = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
    }
    return _appDetailImageView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
