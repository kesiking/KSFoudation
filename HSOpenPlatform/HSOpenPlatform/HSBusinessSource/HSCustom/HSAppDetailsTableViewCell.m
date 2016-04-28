//
//  HSAppDetailsTableViewCell.m
//  HSOpenPlatform
//
//  Created by jinmiao on 16/2/22.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import "HSAppDetailsTableViewCell.h"

@interface HSAppDetailsTableViewCell ()

@property (strong,nonatomic) UICollectionView *collectionView;

@end

@implementation HSAppDetailsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //self.imageView.
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
