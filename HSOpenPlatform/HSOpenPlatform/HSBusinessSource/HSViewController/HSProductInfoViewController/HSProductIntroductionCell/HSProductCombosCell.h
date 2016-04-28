//
//  HSProductCombosCell.h
//  HSOpenPlatform
//
//  Created by xtq on 16/2/23.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSProductInfoModel.h"

#define kProductMenuBtnHeight 30
#define kProductMenuBtnYSpace 14

typedef void(^ProductComboSelectedBlock)(NSUInteger selectedIndex);

@interface HSProductCombosCell : UITableViewCell

@property (nonatomic, copy) ProductComboSelectedBlock productComboSelectedBlock;

- (void)setTitle:(NSString *)title Content:(NSString *)content CombosArray:(NSArray *)menusArray SelectedIndex:(NSUInteger)index;

@end
