//
//  TBLoadingView.h
//  Taobao2013
//
//  Created by 香象 on 1/31/13.
//  Copyright (c) 2013 Taobao.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WeAppLoadingViewType) {
    WeAppLoadingViewTypeDefault,
    WeAppLoadingViewTypeCircel,
};

@class KSCircleView;

@interface WeAppLoadingView : UIImageView{
    BOOL animating;
}

@property(nonatomic,assign)    WeAppLoadingViewType      loadingViewType;

@property(nonatomic,strong)    KSCircleView             *loadingView;

@end

@interface KSCircleView : UIView

@property(nonatomic,strong)    UIColor *circleColor;


- (void)startAnimating;

- (void)stopAnimating;

- (void)resetCircleLayers;


@end
