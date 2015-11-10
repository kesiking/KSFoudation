//
//  EHUserPicFromPhotosViewController.h
//  eHome
//
//  Created by xtq on 15/6/18.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FinishSelectedImageBlock) (NSData *selectedImageData);

@interface EHUserPicFromPhotosViewController : UIViewController

@property(nonatomic,strong)FinishSelectedImageBlock finishSelectedImageBlock;

@end
