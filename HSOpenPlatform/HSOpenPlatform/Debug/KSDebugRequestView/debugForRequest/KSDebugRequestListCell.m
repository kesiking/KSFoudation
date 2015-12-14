//
//  KSDebugRequestListCell.m
//  HSOpenPlatform
//
//  Created by xtq on 15/12/7.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "KSDebugRequestListCell.h"

@interface KSDebugRequestListCell ()

@property (nonatomic, strong) UILabel *urlLabel;

@property (nonatomic, strong) UILabel *statusCodeLabel;

@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation KSDebugRequestListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.urlLabel];
        [self.contentView addSubview:self.statusCodeLabel];
        [self.contentView addSubview:self.detailLabel];
    }
    return self;
}

- (void)setRequestModel:(KSDebugRequestModel *)requestModel {
    _requestModel = requestModel;
    
    self.urlLabel.text = requestModel.requestURLString;
    self.statusCodeLabel.text = [NSString stringWithFormat:@"%ld",requestModel.responseStatusCode];
    

    NSString *dateStr = [NSString stringWithFormat:@"%@",requestModel.startTime];
    NSRange range = NSMakeRange(11, 8);
    dateStr = [dateStr substringWithRange:range];
    
    self.detailLabel.text = [NSString stringWithFormat:@"%@ %@（%.2fs）(%@) %@",requestModel.requestHTTPMethod,requestModel.responseMIMEType,requestModel.spendedTime,requestModel.responseExpectedContentLength,dateStr];
    
    UIColor *statusCodeColor = [UIColor colorWithRed:0.96 green:0.15 blue:0.11 alpha:1];;
    if (requestModel.responseStatusCode == 200) {
        statusCodeColor = [UIColor colorWithRed:0.11 green:0.76 blue:0.13 alpha:1];
    }
    self.statusCodeLabel.textColor = statusCodeColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.urlLabel.frame = CGRectMake(15, 0, self.frame.size.width -15, self.frame.size.height/2.0);
    self.statusCodeLabel.frame = CGRectMake(15, self.frame.size.height/2.0, 30, self.frame.size.height/2.0);
    self.detailLabel.frame = CGRectMake(45, self.frame.size.height/2.0, self.frame.size.width - 45, self.frame.size.height/2.0);
}

#pragma mark - Getters
- (UILabel *)urlLabel {
    if (!_urlLabel) {
        _urlLabel = [[UILabel alloc]init];
        _urlLabel.font = [UIFont systemFontOfSize:12];
        _urlLabel.textColor = [UIColor colorWithRed:0.24f green:0.51f blue:0.78f alpha:1.00f];
    }
    return _urlLabel;
}

- (UILabel *)statusCodeLabel {
    if (!_statusCodeLabel) {
        _statusCodeLabel = [[UILabel alloc]init];
        _statusCodeLabel.font = [UIFont systemFontOfSize:12];
        _statusCodeLabel.textColor = [UIColor colorWithRed:0.24f green:0.51f blue:0.78f alpha:1.00f];
    }
    return _statusCodeLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc]init];
        _detailLabel.font = [UIFont systemFontOfSize:12];
    }
    return _detailLabel;
}

@end
