//
//  HSCollectionItemView.m
//  HSOpenPlatform
//
//  Created by jinmiao on 15/10/19.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSCollectionItemView.h"
#import "HSCollectionItem.h"
#import "HSCollectionItemButton.h"


#define kCellWidth CGRectGetWidth([UIScreen mainScreen].bounds)
#define kMarginX 8
#define kMarginY 15
#define kStartTag 100
#define kButtonHeight (kHSCollectionItemTableViewCellHeight-10)


@implementation HSCollectionItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initAppItemButtons];
    }
    return self;
}

- (void)initAppItemButtons
{
    NSInteger width = kCellWidth/kCollectionItemCount;
    for (NSInteger i = 0; i < kCollectionItemCount; i++)
    {
        HSCollectionItemButton *btn = [[HSCollectionItemButton alloc] init];
        btn.frame = CGRectMake(i*width + kMarginX, kMarginY, width - 2*kMarginX, kButtonHeight - kMarginY);
        btn.tag = kStartTag + i;
        [self addSubview:btn];
    }
}

- (void)setupCollectionItems:(NSArray *)CollectionItemList
{
    for (NSInteger i = 0; i < kCollectionItemCount && i < CollectionItemList.count; i++)
    {
        HSCollectionItemButton *btn = (HSCollectionItemButton *)[self viewWithTag:kStartTag + i];
        HSCollectionItem *item = CollectionItemList[i];
        btn.tag = item.itemTag;
        [btn setImage:[UIImage imageNamed:item.itemImageName] forState:UIControlStateNormal];
        [btn setTitle:item.itemName forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)buttonTapped:(HSCollectionItemButton *)sender
{
    [self.viewDelegate collectionItemView:self actionWithTag:sender.tag];
}





    



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
