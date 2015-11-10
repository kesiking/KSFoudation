//
//  HSCollectionItemTableViewCell.m
//  HSOpenPlatform
//
//  Created by jinmiao on 15/10/20.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSCollectionItemTableViewCell.h"
#import "HSCollectionCellItemButton.h"


#define kCellWidth CGRectGetWidth([UIScreen mainScreen].bounds)
//#define kMarginX 15
//#define kMarginY 15
//#define kBtnWidth 115
#define kBtnHeight 150

//#define kBtnInterval 19
#define kStartTag 100





@implementation HSCollectionItemTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initAppItemButtons];
        [self initLineView];
    }
    return self;
}

- (void)initAppItemButtons
{
    
    NSInteger width = kCellWidth/kCollectionItemCount;
    for (NSInteger i = 0; i < kCollectionItemCount; i++)
    {
        HSCollectionCellItemButton *btn = [[HSCollectionCellItemButton alloc] init];
        //btn.frame = CGRectMake(kMarginX*SCREEN_SCALE + i*kBtnWidth*SCREEN_SCALE, kMarginY*SCREEN_SCALE, kBtnWidth*SCREEN_SCALE, kBtnHeight*SCREEN_SCALE);
        btn.frame = CGRectMake(i*width, 0, width, kBtnHeight*SCREEN_SCALE);
        btn.tag = kStartTag + i;
        [self.contentView addSubview:btn];
    }
}

- (void)setupCollectionItems:(NSArray *)CollectionItemList
{
    for (NSInteger i = 0; i < kCollectionItemCount && i < CollectionItemList.count; i++)
    {
        HSCollectionCellItemButton *btn = (HSCollectionCellItemButton *)[self.contentView viewWithTag:kStartTag + i];
        HSApplicationModel *item = CollectionItemList[i];
        btn.tag = [item.appId integerValue];
        //[btn sd_setImageWithURL:[NSURL URLWithString:item.appIconUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:item.placeholderImageStr]];
        [btn setImage:[UIImage imageNamed:item.placeholderImageStr] forState:UIControlStateNormal];
        [btn setTitle:item.appName forState:UIControlStateNormal];
        //[btn setBackgroundColor:self.colorArray[i]];
        [btn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)buttonTapped:(HSCollectionCellItemButton *)sender
{
    [self.cellDelegate collectionItemCell:self actionWithAppId:sender.tag];
}

-(void)initLineView{
    NSInteger width = kCellWidth/kCollectionItemCount;
    UIView *lineViewHorizontal = [[UIView alloc]initWithFrame:CGRectMake(0, 150 - 0.5, SCREEN_WIDTH, 0.5)];
    [lineViewHorizontal setBackgroundColor:RGB(0xda, 0xda, 0xda)];
    UIView *lineViewVertical = [[UIView alloc]initWithFrame:CGRectMake(width - 0.5, 0, 0.5, 150)];
    UIView *lineViewVertical2 = [[UIView alloc]initWithFrame:CGRectMake(2*width - 0.5, 0, 0.5, 150)];
    [lineViewVertical setBackgroundColor:RGB(0xda, 0xda, 0xda)];
    [lineViewVertical2 setBackgroundColor:RGB(0xda, 0xda, 0xda)];
    [self.contentView addSubview:lineViewHorizontal];
    [self.contentView addSubview:lineViewVertical];
    [self.contentView addSubview:lineViewVertical2];
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
