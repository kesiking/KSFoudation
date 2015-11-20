//
//  ManWuCommoditySortViewCell.m
//  basicFoundation
//
//  Created by 逸行 on 15-5-6.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "HSBusinessUserListInfoViewCell.h"
#import "HSBusinessUserAccountInfoModel.h"
#import "KSTableViewController.h"

#define businessImageViewWidth  (26)
#define businessImageViewHeight (25)

#define BussinessDetailBorderLeft   (15.0)
#define BussinessDetailBorderRight  (BussinessDetailBorderLeft)
#define BussinessDetailWidth        (self.width - BussinessDetailBorderLeft - BussinessDetailBorderRight)

#define BussinessDetailBorderTop    (0.0)
#define BussinessDetailBorderBottom (0.0)

@implementation HSBusinessUserListInfoViewCell

-(void)setupView{
    [super setupView];
    self.backgroundColor = [UIColor whiteColor];
    self.businessUsercommodityImageView.hidden = YES;
    [self updateFrame];
}

-(void)updateFrame{
    [self.businessUsercommoditytitleLabel sizeToFit];
    [self.businessUsercommoditytitleLabel setFrame:CGRectMake(BussinessDetailBorderLeft, (self.height - self.businessUsercommoditytitleLabel.height)/2, self.businessUsercommoditytitleLabel.width, self.businessUsercommoditytitleLabel.height)];
    [self.businessUsercommoditynameLabel sizeToFit];
    [self.businessUsercommoditynameLabel setFrame:CGRectMake(self.width - self.businessUsercommoditynameLabel.width - (BussinessDetailBorderRight), (self.height - self.businessUsercommoditynameLabel.height)/2, self.businessUsercommoditynameLabel.width, self.businessUsercommoditynameLabel.height)];
    if (!self.businessUsercommodityImageView.hidden) {
        [self.businessUsercommodityImageView setFrame:CGRectMake(self.businessUsercommoditynameLabel.left - businessImageViewWidth - 10, (self.height - businessImageViewHeight)/2, businessImageViewWidth, businessImageViewHeight)];
    }
}

-(UILabel *)businessUsercommoditytitleLabel{
    if (_businessUsercommoditytitleLabel == nil) {
        _businessUsercommoditytitleLabel = [[UILabel alloc] init];
        _businessUsercommoditytitleLabel.font = [UIFont systemFontOfSize:EHSiz2];
        [_businessUsercommoditytitleLabel setTextColor:EHCor5];
        _businessUsercommoditytitleLabel.numberOfLines = 1;
        _businessUsercommoditytitleLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:_businessUsercommoditytitleLabel];
    }
    return _businessUsercommoditytitleLabel;
}

-(UILabel *)businessUsercommoditynameLabel{
    if (_businessUsercommoditynameLabel == nil) {
        _businessUsercommoditynameLabel = [[UILabel alloc] init];
        _businessUsercommoditynameLabel.font = [UIFont systemFontOfSize:EHSiz2];
        [_businessUsercommoditynameLabel setTextColor:EHCor5];
        _businessUsercommoditynameLabel.numberOfLines = 1;
        _businessUsercommoditynameLabel.backgroundColor = [UIColor whiteColor];
        [_businessUsercommoditynameLabel setTextAlignment:NSTextAlignmentRight];
        [self addSubview:_businessUsercommoditynameLabel];
    }
    return _businessUsercommoditynameLabel;
}

-(UIImageView *)businessUsercommodityImageView{
    if (_businessUsercommodityImageView == nil) {
        _businessUsercommodityImageView = [[UIImageView alloc] init];
        [_businessUsercommodityImageView setImage:[UIImage imageNamed:@"icon_householder"]];
        [self addSubview:_businessUsercommodityImageView];
    }
    return _businessUsercommodityImageView;
}

- (void)configCellWithCellView:(id<KSViewCellProtocol>)cell Frame:(CGRect)rect componentItem:(WeAppComponentBaseItem *)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    if (![componentItem isKindOfClass:[HSBusinessUserAccountInfoModel class]]) {
        return;
    }
    HSBusinessUserAccountInfoModel* accountInfoModel = (HSBusinessUserAccountInfoModel*)componentItem;
    self.businessUsercommoditytitleLabel.text = accountInfoModel.userAccountPhone;
    self.businessUsercommoditynameLabel.text = accountInfoModel.userAccountNickName?:accountInfoModel.userAccountName;
    self.businessUsercommodityImageView.hidden = !accountInfoModel.isUserAccountHousehold;
    
    [self updateFrame];
}

-(void)refreshCellImagesWithComponentItem:(WeAppComponentBaseItem *)componentItem extroParams:(KSCellModelInfoItem *)extroParams{
    
}

- (void)didSelectCellWithCellView:(id<KSViewCellProtocol>)cell componentItem:(WeAppComponentBaseItem *)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    
}

@end
