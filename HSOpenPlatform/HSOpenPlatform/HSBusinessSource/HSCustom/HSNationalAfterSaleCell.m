//
//  HSNationalAfterSaleCell.m
//  HSOpenPlatform
//
//  Created by xtq on 15/11/9.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSNationalAfterSaleCell.h"

static NSString *const kHSPositionImageName     = @"icon_Businesshall_Position";
static NSString *const kHSPhoneImageName        = @"icon_Businesshall_Phone";
static NSString *const kHSArrorImageName        = @"icon_Arrow";

@interface HSNationalAfterSaleCell ()

@property (nonatomic, strong)UIImageView *appImv;

@property (nonatomic, strong)UIImageView *addressImv;

@property (nonatomic, strong)UIImageView *telImv;

@property (nonatomic, strong)UIImageView *mailImv;

@property (nonatomic, strong)UILabel     *addressLabel;

@property (nonatomic, strong)UILabel     *telLabel;

@property (nonatomic, strong)UILabel     *mailLabel;

@end

@implementation HSNationalAfterSaleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.appImv];
        [self.contentView addSubview:self.addressImv];
        [self.contentView addSubview:self.telImv];
        [self.contentView addSubview:self.mailImv];
        [self.contentView addSubview:self.addressLabel];
        [self.contentView addSubview:self.telLabel];
        [self.contentView addSubview:self.mailLabel];
    }
    return self;
}

- (void)setModel:(HSNationalAfterSaleModel *)model {
    _model = model;
    
    NSURL *imageUrl = [NSURL URLWithString:model.appIconUrl];
    UIImage *placeholderImage = [UIImage imageNamed:model.placeholderImageStr];
    [self.appImv sd_setImageWithURL:imageUrl placeholderImage:placeholderImage options:SDWebImageLowPriority];
    
    self.addressImv.image  = [UIImage imageNamed:kHSPositionImageName];
    self.telImv.image      = [UIImage imageNamed:kHSPhoneImageName];
    self.mailImv.image     = [UIImage imageNamed:kHSPositionImageName];

    self.addressLabel.text = model.addressDes;
    self.telLabel.text     = model.afterSalePhone;
    self.mailLabel.text    = model.afterSaleMail;
}


#pragma mark - Config Subviews
- (void)layoutSubviews {
    [super layoutSubviews];
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);

    self.appImv.frame = CGRectMake(caculateNumber(15), caculateNumber(20), caculateNumber(60), caculateNumber(60));
    self.addressImv.frame = CGRectMake(caculateNumber(100), caculateNumber(10), caculateNumber(20), caculateNumber(20));
    self.telImv.frame = CGRectMake(caculateNumber(100), caculateNumber(40), caculateNumber(20), caculateNumber(20));
    self.mailImv.frame = CGRectMake(caculateNumber(100), caculateNumber(70), caculateNumber(20), caculateNumber(20));
    self.addressLabel.frame = CGRectMake(caculateNumber(135), caculateNumber(10), self.width - caculateNumber(150), caculateNumber(20));
    self.telLabel.frame = CGRectMake(caculateNumber(135), caculateNumber(40), self.width - caculateNumber(150), caculateNumber(20));
    self.mailLabel.frame = CGRectMake(caculateNumber(135), caculateNumber(70), self.width - caculateNumber(150), caculateNumber(20));
}

- (UIImageView *)appImv {
    if (!_appImv) {
        _appImv = [[UIImageView alloc]init];
    }
    return _appImv;
}

- (UIImageView *)addressImv {
    if (!_addressImv) {
        _addressImv = [[UIImageView alloc]init];
    }
    return _addressImv;
}

- (UIImageView *)telImv {
    if (!_telImv) {
        _telImv = [[UIImageView alloc]init];
    }
    return _telImv;
}

- (UIImageView *)mailImv {
    if (!_mailImv) {
        _mailImv = [[UIImageView alloc]init];
    }
    return _mailImv;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.font = EHFont5;
        _addressLabel.textColor = EHCor5;
    }
    return _addressLabel;
}

- (UILabel *)telLabel {
    if (!_telLabel) {
        _telLabel = [[UILabel alloc]init];
        _telLabel.font = EHFont5;
        _telLabel.textColor = EHCor5;
    }
    return _telLabel;
}

- (UILabel *)mailLabel {
    if (!_mailLabel) {
        _mailLabel = [[UILabel alloc]init];
        _mailLabel.font = EHFont5;
        _mailLabel.textColor = EHCor5;
    }
    return _mailLabel;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
