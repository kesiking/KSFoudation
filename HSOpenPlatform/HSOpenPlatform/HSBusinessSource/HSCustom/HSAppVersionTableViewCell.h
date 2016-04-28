//
//  HSAppVersionTableViewCell.h
//  HSOpenPlatform
//
//  Created by jinmiao on 16/3/1.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonClickedBlock)(void);

@interface HSAppVersionTableViewCell : UITableViewCell

@property (strong, nonatomic) ButtonClickedBlock buttonClickedBlock;

-(void)setAppVersion:(NSString *)appVersion appSize:(NSString *)appSize appLanguage:(NSString *)appLanguage compatibility:(NSString *)compatibility;

@end
