//
//  KSReactViewController.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/23.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//
#ifdef USE_ReactNative
#import "KSReactViewController.h"
#import "RCTRootView.h"

@interface KSReactViewController()

@property(nonatomic,strong)         NSURL*              jsCodeLocation;

@property(nonatomic,strong)         RCTRootView*        rootView;

@end

@implementation KSReactViewController

-(id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query nativeParams:(NSDictionary *)nativeParams{
    self = [super initWithNavigatorURL:URL query:query nativeParams:nativeParams];
    if (self) {
        self.jsCodeLocation = URL;
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    _rootView = [[RCTRootView alloc] initWithBundleURL:self.jsCodeLocation
                                                        moduleName:@"AwesomeProject"
                                                 initialProperties:nil
                                                     launchOptions:nil];
    [self.view addSubview:_rootView];
    _rootView.frame = self.view.bounds;
}

-(void)viewDidUnload{
    [super viewDidUnload];
    _rootView = nil;
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    _rootView = nil;
}

@end

#endif