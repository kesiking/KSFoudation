//
//  EHPhotoBrowserViewController.h
//  eHome
//
//  Created by xtq on 15/6/19.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef void (^FinishSelectedImageBlock) (NSData *selectedImageData);

@interface EHPhotoBrowserViewController : UIViewController

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)ALAssetsGroup *group;
@property(nonatomic,strong)FinishSelectedImageBlock finishSelectedImageBlock;

@end
