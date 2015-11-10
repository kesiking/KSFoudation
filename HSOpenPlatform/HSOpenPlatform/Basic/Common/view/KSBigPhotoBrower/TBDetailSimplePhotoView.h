//
//  TBDetailSimplePhotoView.h
//  TBTradeDetail
//
//  Created by sweety on 14/11/27.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBDetailSimplePhotoView : UIView <UIScrollViewDelegate>
{
    Class _originalClass;
}
- (void)setSelected:(BOOL)value animated:(BOOL)animated;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, assign) BOOL scaleEnabled, cropAndFit, showShadow;
@property (nonatomic, assign) float fitScale, minScale, maxScale, lastScale;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView   *scrollView;
@property (nonatomic, assign) id touchDelegate;

- (void)getOriginalPic:(NSString *)urlStr andImage:(UIImage *)image;


@end
