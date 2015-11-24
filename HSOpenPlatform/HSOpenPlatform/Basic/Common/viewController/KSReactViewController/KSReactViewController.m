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
#import "KSModelStatusBasicInfo.h"

@interface KSReactViewController()

@property(nonatomic,strong)         NSURL*              jsCodeLocation;

@property(nonatomic,strong)         NSDictionary*       jsConstantsToExport;

@property(nonatomic,strong)         RCTRootView*        rootView;

@end

@implementation KSReactViewController

RCT_EXPORT_MODULE();

-(id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query nativeParams:(NSDictionary *)nativeParams{
    self = [super initWithNavigatorURL:URL query:query nativeParams:nativeParams];
    if (self) {
        self.jsCodeLocation = URL;
        NSMutableDictionary* newNativeParams = [NSMutableDictionary dictionary];
        if (nativeParams) {
            [nativeParams enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                if ([obj isKindOfClass:[NSDictionary class]]
                    || [obj isKindOfClass:[NSArray class]]
                    || [obj isKindOfClass:[NSString class]]
                    || [obj isKindOfClass:[NSNumber class]]) {
                    [newNativeParams setObject:obj forKey:key];
                }else if ([obj isKindOfClass:[WeAppComponentBaseItem class]]){
                    NSDictionary* objDict = [((WeAppComponentBaseItem*)obj) toDictionary];
                    if (objDict) {
                        [newNativeParams setObject:objDict forKey:key];
                    }
                }
            }];
        }
        self.jsConstantsToExport = newNativeParams;
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reactNativeErrorMessageNotification:) name:HSReactNativeErrorMessageNotification object:nil];
    
    self.title = [self.jsConstantsToExport objectForKey:@"title"]?:@"reactNative";
    _rootView = [[RCTRootView alloc] initWithBundleURL:self.jsCodeLocation
                                                        moduleName:@"AwesomeProject"
                                                 initialProperties:[self.jsConstantsToExport objectForKey:@"passProps"]
                                                     launchOptions:nil];
    _rootView.reactViewController = self;
    [self.view addSubview:_rootView];
    _rootView.frame = self.view.bounds;
    
    ((KSModelStatusBasicInfo*)self.statusHandler.statusInfo).actionButtonTitleForErrorBlock = ^(NSError*error){
        return @"稍后再试";
    };
}

-(void)viewDidUnload{
    [super viewDidUnload];
    _rootView = nil;
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    _rootView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)reactNativeErrorMessageNotification:(NSNotification*)notification{
    NSString* errorMessage = [notification.userInfo objectForKey:@"message"];
    NSError *error = [NSError errorWithDomain:@"apiRequestErrorDomain" code:500 userInfo:@{NSLocalizedDescriptionKey: errorMessage?:@"数据有误，请稍后再试"}];
    if (self.isViewAppeared) {
        [self showErrorView:error];
    }
}

@end

#endif