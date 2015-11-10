//
//  HSAppCollectionView.m
//  HSOpenPlatform
//
//  Created by jinmiao on 15/10/21.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSAppCollectionView.h"


@implementation HSAppCollectionView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataArray = [[NSArray alloc]init];
        self.dataSource = self;
        self.delegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableFooterView = [[UIView alloc]init];
    }
    return self;
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.dataArray.count + kCollectionItemCount - 1)/kCollectionItemCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HSCollectionItemTableViewCell *cell = [[HSCollectionItemTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kHSCollectionItemTableViewCell"];
    NSInteger index = indexPath.row;
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:kCollectionItemCount];
    for (NSInteger i = 0; i < kCollectionItemCount && index*kCollectionItemCount + i < self.dataArray.count; i++)
    {
        [list addObject:self.dataArray[index*kCollectionItemCount + i]];
        //[list addObject:_functionCollectionItemList[index*kCollectionItemCount + i]];
    }
    
    cell.cellDelegate = self;
//    if (indexPath.row%2 ==0) {
//        
//        UIColor *color1 = [UIColor whiteColor];
//        UIColor *color2 = [UIColor whiteColor];
//        UIColor *color3 = [UIColor whiteColor];
//        cell.colorArray = @[color1,color2,color3];
//    }
//    else {
//        cell.backgroundColor = RGB(0xf4, 0xf4, 0xf9);
//
//        UIColor *color1 = RGB(0xa8, 0xee, 0x00);
//        UIColor *color2 = RGB(0x34, 0x95, 0xff);
//        UIColor *color3 = RGB(0x7e, 0xc1, 0xff);
//        cell.colorArray = @[color1,color2,color3];
//    }
    [cell setupCollectionItems:list];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    //UITableViewCellSeparatorStyleNone
    //cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHSCollectionItemTableViewCellHeight*SCREEN_SCALE;
    
}

#pragma mark - HSCollectionItemTableViewCellDelegate

- (void)collectionItemCell:(HSCollectionItemTableViewCell *)cell actionWithAppId:(NSInteger)tag{
    NSString *appId = [NSString stringWithFormat: @"%ld", (long)tag];
    self.appIdBlock(appId);
    
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
