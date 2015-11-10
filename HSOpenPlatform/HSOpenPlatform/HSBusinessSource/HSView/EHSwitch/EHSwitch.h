//
//  EHSwitch.h
//  eHome
//
//  Created by xtq on 15/9/22.
//  Copyright (c) 2015年 one. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SwitchChangedBlock)(BOOL on);

@interface EHSwitch : UIView

@property (nonatomic, assign)BOOL on;

@property (nonatomic, strong)SwitchChangedBlock switchChangedBlock;

- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end
