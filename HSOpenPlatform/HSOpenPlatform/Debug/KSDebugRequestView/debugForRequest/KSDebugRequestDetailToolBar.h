//
//  KSDebugRequestDetailToolBar.h
//  HSOpenPlatform
//
//  Created by xtq on 15/12/9.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnBtnClickedBlock)(void);

typedef void (^UploadBtnClickedBlock)(void);

@interface KSDebugRequestDetailToolBar : UIView

@property (nonatomic, strong) ReturnBtnClickedBlock returnBtnClickedBlock;

@property (nonatomic, strong) UploadBtnClickedBlock uploadBtnClickedBlock;

- (void)showTotalFlowCount:(NSString *)flowCount;

@end
