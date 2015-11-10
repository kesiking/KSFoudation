//
//  EHUserPicFromCameraViewController.h
//  eHome
//
//  Created by xtq on 15/6/18.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FinishSelectedImageBlock) (NSData *selectedImageData);

@interface EHUserPicFromCameraViewController : UIViewController

@property(nonatomic,strong)FinishSelectedImageBlock finishSelectedImageBlock;

- (void)showCamera;

@end
