//
//  CBTextView.h
//  CBTextView
//
//  Created by ly on 13-9-18.
//  Copyright (c) 2013年 ly. All rights reserved.
//

#import <UIKit/UIKit.h>
//动画时间
#define kAnimationDuration 0.2

//view高度
#define kViewHeight 200
#define navigationHeight (64)
#define toolBarHeight (44)
#define keyboardRemainHeight(keyboardHeight) (SCREEN_HEIGHT - self.textViewInsets.top - self.textViewInsets.bottom - keyboardHeight)
#define textViewHeight(viewHeight,keyboardHeight) MIN(viewHeight,keyboardRemainHeight(keyboardHeight))

@interface WeAppBasicTextView : UIView
{
    UIColor *defaultTextColor;
}

@property (strong, nonatomic) UITextView                *textView;

@property (strong, nonatomic) UIImageView               *backgroundImage;

@property (strong, nonatomic) NSString                  *placeHolder;

@property (strong, nonatomic) NSString                  *prevText;

@property (strong, nonatomic) UIColor                   *placeHolderColor;

@property (weak, nonatomic)   id<UITextViewDelegate>    aDelegate;

@property (assign, nonatomic) UIEdgeInsets              textViewInsets;

@end