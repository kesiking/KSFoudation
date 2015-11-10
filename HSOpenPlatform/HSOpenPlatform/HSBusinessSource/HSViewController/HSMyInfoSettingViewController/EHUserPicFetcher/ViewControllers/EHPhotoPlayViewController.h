//
//  EHPhotoPlayViewController.h
//  eHome
//
//  Created by xtq on 15/6/19.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FinishSelectedImageBlock) (NSData *selectedImageData);

@interface EHPhotoPlayViewController : UIViewController

@property(nonatomic,strong)UIImage *bigImage;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)FinishSelectedImageBlock finishSelectedImageBlock;

@end
