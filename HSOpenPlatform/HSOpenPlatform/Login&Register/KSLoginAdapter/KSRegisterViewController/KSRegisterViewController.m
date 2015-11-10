//
//  KSRegisterViewController.m
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/9.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSRegisterViewController.h"
#import "KSRegisterView.h"
#import "KSLoginMaroc.h"

@interface KSRegisterViewController ()

@property (nonatomic,copy) registerActionBlock  registerActionBlock;

@property (nonatomic,copy) cancelActionBlock    cancelActionBlock;

@property (nonatomic,strong) KSRegisterView       *registerView;

@end

@implementation KSRegisterViewController

-(id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query nativeParams:(NSDictionary *)nativeParams{
    self = [self init];
    if (self) {
        self.registerActionBlock = [nativeParams objectForKey:@"registerActionBlock"];
        self.cancelActionBlock = [nativeParams objectForKey:@"cancelActionBlock"];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"注册";
    
    [self.view setBackgroundColor:KSLOGINBackgroundColor];
    [self.view addSubview:self.registerView];

}

-(KSRegisterView *)registerView{
    if (_registerView == nil) {
        _registerView = [[KSRegisterView alloc] initWithFrame:self.view.bounds];
        _registerView.registerActionBlock = self.registerActionBlock;
        _registerView.cancelActionBlock = self.cancelActionBlock;
    }
    return _registerView;
}

@end
