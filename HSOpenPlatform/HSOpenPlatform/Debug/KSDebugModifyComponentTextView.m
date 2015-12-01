//
//  WeAppDebugModifyComponentTextView.m
//  WeAppSDK
//
//  Created by 逸行 on 15-2-6.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "KSDebugModifyComponentTextView.h"

@interface KSDebugModifyComponentTextView()

@property(nonatomic, assign)  CGRect      closeButtonFrame;
@property(nonatomic, strong)  UIButton*   modifyButton;

@end

@implementation KSDebugModifyComponentTextView

-(void)setupView{
    [super setupView];
}

-(void)startDebug{
    [super startDebug];
    UIButton *closeButton = [self valueForKey:@"closeButton"];
    [closeButton setFrame:CGRectMake(closeButton.frame.origin.x, closeButton.frame.origin.y, closeButton.frame.size.width / 2, closeButton.frame.size.height)];
    self.closeButtonFrame = closeButton.frame;
    self.modifyButton.hidden = NO;
}

-(UIButton *)modifyButton{
    if (_modifyButton == nil) {
        _modifyButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.closeButtonFrame), CGRectGetMinY(self.closeButtonFrame), CGRectGetWidth(self.closeButtonFrame), CGRectGetHeight(self.closeButtonFrame))];
        _modifyButton.backgroundColor = [UIColor orangeColor];
        _modifyButton.layer.masksToBounds = YES;
        _modifyButton.layer.cornerRadius = 10;
        [_modifyButton setTitle:@"修改" forState:UIControlStateNormal];
        [_modifyButton addTarget:self action:@selector(modifyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_modifyButton];
    }
    return _modifyButton;
}

-(NSDictionary*)generateDictionaryWithString:(NSString*)text{
    if (text == nil) {
        return nil;
    }
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return json;
}

-(void)modifyButtonClick:(id)sender{
    
}

@end
