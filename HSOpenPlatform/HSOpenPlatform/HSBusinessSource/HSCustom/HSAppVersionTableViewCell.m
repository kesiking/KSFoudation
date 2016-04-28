//
//  HSAppVersionTableViewCell.m
//  HSOpenPlatform
//
//  Created by jinmiao on 16/3/1.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import "HSAppVersionTableViewCell.h"
#import "Masonry.h"

@interface HSAppVersionTableViewCell ()

@property (strong,nonatomic) UILabel *titleLabel;
@property (strong,nonatomic) UILabel *systemLabel;
@property (strong,nonatomic) UILabel *versionLabel;
@property (strong,nonatomic) UILabel *compatibilityLabel;
@property (strong,nonatomic) UIButton *downloadButton;

@end

@implementation HSAppVersionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.systemLabel];
        [self.contentView addSubview:self.versionLabel];
        [self.contentView addSubview:self.compatibilityLabel];
        [self.contentView addSubview:self.downloadButton];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(20*SCREEN_SCALE);
        make.left.equalTo(self.contentView.mas_top).with.offset(15*SCREEN_SCALE);
    }];
    
    [self.systemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(15*SCREEN_SCALE);
        make.left.equalTo(self.contentView.mas_top).with.offset(15*SCREEN_SCALE);
    }];
    
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(15*SCREEN_SCALE);
        make.left.equalTo(self.contentView.mas_left).with.offset(80*SCREEN_SCALE);
    }];
    
    [self.compatibilityLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.versionLabel.mas_bottom).with.offset(6*SCREEN_SCALE);
        make.left.equalTo(self.contentView.mas_left).with.offset(80*SCREEN_SCALE);
    }];
    
    [self.downloadButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.contentView.mas_top).with.offset(50*SCREEN_SCALE);
        make.right.equalTo(self.contentView.mas_right).with.offset(-20*SCREEN_SCALE);
        make.size.mas_equalTo(CGSizeMake(43*SCREEN_SCALE, 25*SCREEN_SCALE));
    }];
    
}

-(void)setAppVersion:(NSString *)appVersion appSize:(NSString *)appSize appLanguage:(NSString *)appLanguage compatibility:(NSString *)compatibility{
    self.versionLabel.text = [NSString stringWithFormat:@"%@|%@|%@",appVersion,appSize,appLanguage];
    self.compatibilityLabel.text = [NSString stringWithFormat:@"兼容性:%@",compatibility];
}


#pragma mark - UI

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = HS_font5;
        _titleLabel.textColor = HS_FontCor2;
        _titleLabel.text = @"适配系统";
    }
    return _titleLabel;
}
-(UILabel *)systemLabel{
    if (!_systemLabel) {
        _systemLabel = [[UILabel alloc]init];
        _systemLabel.textAlignment = NSTextAlignmentLeft;
        _systemLabel.font = HS_font5;
        _systemLabel.textColor = HS_FontCor4;
        _systemLabel.text = @"iOS";
    }
    return _systemLabel;
}

-(UILabel *)versionLabel{
    if (!_versionLabel) {
        _versionLabel = [[UILabel alloc]init];
        _versionLabel.textAlignment = NSTextAlignmentLeft;
        _versionLabel.textColor = [UIColor grayColor];
        _versionLabel.font = HS_font5;
        _versionLabel.textColor = HS_FontCor4;
        //_versionLabel.text = @"V1";

    }
    return _versionLabel;
}

-(UILabel *)compatibilityLabel{
    if (!_compatibilityLabel) {
        _compatibilityLabel = [[UILabel alloc]init];
        _compatibilityLabel.textAlignment = NSTextAlignmentLeft;
        _compatibilityLabel.textColor = [UIColor grayColor];
        _compatibilityLabel.font = HS_font5;
        //_compatibilityLabel.text = @"兼容性";

    }
    return _compatibilityLabel;
}

-(UIButton *)downloadButton{
    if (!_downloadButton) {
        _downloadButton = [[UIButton alloc]init];
        [_downloadButton setTitle:@"下载" forState:UIControlStateNormal];
        //[_downloadButton setTitleColor:RGB(0x23, 0x74, 0xfa) forState:UIControlStateNormal];
        [_downloadButton setTitleColor:HS_FontCor5 forState:UIControlStateNormal];
        //_downloadButton.titleLabel.text = @"下载";
        //_downloadButton.titleLabel.textColor = RGB(0x23, 0x74, 0xfa);
        _downloadButton.titleLabel.font = HS_font5;
        _downloadButton.layer.borderWidth = 0.5;
        _downloadButton.layer.borderColor = HS_FontCor5.CGColor;
        _downloadButton.layer.cornerRadius = 3;
        _downloadButton.clipsToBounds = YES;
        [_downloadButton addTarget:self action:@selector(downloadButtonClicked) forControlEvents:UIControlEventTouchUpInside];

        //_downloadButton.titleLabel.layer.borderColor = RGB(0x23, 0x74, 0xfa).CGColor;
        

    }
    return _downloadButton;
}

-(void)downloadButtonClicked{
    !self.buttonClickedBlock?:self.buttonClickedBlock();
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
