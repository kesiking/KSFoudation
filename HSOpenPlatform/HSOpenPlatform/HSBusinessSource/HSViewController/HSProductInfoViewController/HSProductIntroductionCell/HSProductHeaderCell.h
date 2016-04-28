//
//  HSProductHeaderCell.h
//  HSOpenPlatform
//
//  Created by xtq on 16/2/23.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSProductInfoModel.h"

@interface HSProductHeaderCell : UITableViewCell

- (void)configWithName:(NSString *)name title:(NSString *)title iconUrl:(NSString *)iconUrl price:(NSString *)price;

@end
