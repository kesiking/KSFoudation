//
//  EHUserPicFetcherView.h
//  eHome
//
//  Created by xtq on 15/6/16.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FinishSelectedImageBlock) (NSData *selectedImageData);

@interface EHUserPicFetcherView : UIView

/**
 *  获取图片接口。显示头像获取方式的自定义弹窗。
 *
 *  @param target 传入源(UIViewController)
 */
- (void)showFromTarget:(id)target;

@property(nonatomic,strong)FinishSelectedImageBlock finishSelectedImageBlock;

@end
