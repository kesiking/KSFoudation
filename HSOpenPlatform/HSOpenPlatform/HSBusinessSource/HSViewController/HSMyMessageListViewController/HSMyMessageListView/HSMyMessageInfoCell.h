//
//  HSMyMessageInfoCell.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/19.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSDeleteBtnViewCell.h"

@interface HSMyMessageInfoCell : KSDeleteBtnViewCell

@property (weak, nonatomic) IBOutlet UILabel                *messageTimeLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel     *messageInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton               *messageCheckDetailInfoButton;
@property (weak, nonatomic) IBOutlet UIButton               *messageInfoButton;
@property (weak, nonatomic) IBOutlet UIImageView            *messageBackgroundImageView;


@end
