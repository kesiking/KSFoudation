//
//  KSReactViewController.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/23.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//
#ifdef USE_ReactNative
#import "KSReactViewController.h"
#import "RCTWrapperViewController.h"
#import "RCTWrapperViewController+KSReactNativeViewControllerListener.h"
#import "RCTRootView.h"
#import "RCTView.h"
#import "KSReactNavigationButton.h"
#import "RCTNavigator.h"
#import "UIView+React.h"
#import "KSModelStatusBasicInfo.h"

@interface KSReactViewController()<UINavigationControllerDelegate>

@property(nonatomic,strong)         NSURL*              jsCodeLocation;

@property(nonatomic,strong)         NSDictionary*       jsConstantsToExport;

@property(nonatomic,strong)         NSDictionary*       jsConstantsQuery;

@property(nonatomic,strong)         KSReactNavigationButton*                navigationButton;

@property(nonatomic,strong)         RCTRootView*                            rootView;

@property(nonatomic,weak)           id<UINavigationControllerDelegate>      reactNativeVCDelegate;

@property(nonatomic,weak)           UINavigationController*                 reactNativeVC;

@end

@implementation KSReactViewController

+(void)initialize{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ks_swizzleSelector([RCTWrapperViewController class], @selector(willMoveToParentViewController:), @selector(KSWillMoveToParentViewController:));
    });
}

-(id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query nativeParams:(NSDictionary *)nativeParams{
    self = [super initWithNavigatorURL:URL query:query nativeParams:nativeParams];
    if (self) {
        self.jsCodeLocation = URL;
        self.jsConstantsQuery = query;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reactNativeContentDidAppearNotification:) name:RCTContentDidAppearNotification object:nil];
    
    self.title = [self.jsConstantsToExport objectForKey:@"title"]?:@"reactNative";
    _rootView = [[RCTRootView alloc] initWithBundleURL:self.jsCodeLocation
                                                        moduleName:@"AwesomeProject"
                                                 initialProperties:[self.jsConstantsToExport objectForKey:@"passProps"]
                                                     launchOptions:nil];
    _rootView.reactViewController = self;
    [self.view addSubview:_rootView];
    _rootView.frame = self.view.bounds;
    
}

-(void)measureViewFrame{
    if (![[self.jsConstantsQuery objectForKey:@"needNavigationBar"] boolValue]) {
        CGRect frame = self.view.frame;
        frame.size.height -= (self.navigationController.viewControllers.count > 1 ? 0 : (CGRectGetHeight(self.tabBarController.tabBar.bounds)));
        if (!CGRectEqualToRect(frame, self.view.frame)) {
            [self.view setFrame:frame];
        }
        return;
    }
    [super measureViewFrame];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![[self.jsConstantsQuery objectForKey:@"needNavigationBar"] boolValue]) {
        [self.navigationController setNavigationBarHidden:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (![[self.jsConstantsQuery objectForKey:@"needNavigationBar"] boolValue]) {
        [self.navigationController setNavigationBarHidden:NO];
    }
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

-(void)initBasicNavBarViewsWithNabigationBar:(UINavigationBar*)navigationBar{
    if (_navigationButton == nil) {
        _navigationButton = [KSReactNavigationButton buttonWithType:UIButtonTypeRoundedRect];
        [_navigationButton setFrame:CGRectMake(0, 0, 50, 44)];
        [_navigationButton setBackgroundColor:[UIColor clearColor]];
        [_navigationButton setImage:[UIImage imageNamed:@"nav_Black"] forState:UIControlStateNormal];
        [_navigationButton setImageEdgeInsets:UIEdgeInsetsMake((_navigationButton.height - 13)/2, (_navigationButton.width - 8)/2 - 10, (_navigationButton.height - 13)/2, (_navigationButton.width - 8)/2 + 10)];
        [_navigationButton addTarget:self action:@selector(backBarButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
        [navigationBar addSubview:_navigationButton];
    }else{
        [_navigationButton removeFromSuperview];
        [navigationBar addSubview:_navigationButton];
    }
}

-(void)backBarButtonItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)refreshDataRequest{
//    [self.rootView.bridge reload];
    [self backBarButtonItemClick];
}

-(void)reactNativeErrorMessageNotification:(NSNotification*)notification{
    NSString* errorMessage = [notification.userInfo objectForKey:@"message"];
    NSError *error = [NSError errorWithDomain:@"apiRequestErrorDomain" code:500 userInfo:@{NSLocalizedDescriptionKey: errorMessage?:@"数据有误，请稍后再试"}];
    if (self.isViewAppeared) {
        [self showErrorView:error];
    }
}

-(void)reactNativeContentDidAppearNotification:(NSNotification*)notification{
    if (![[self.jsConstantsQuery objectForKey:@"needNavigationBar"] boolValue]) {
        UINavigationController* reactNativeNavigationController = [self getReactNativeNavigationControllerWithView:self.rootView];
        [self initBasicNavBarViewsWithNabigationBar:reactNativeNavigationController.navigationBar];
        self.reactNativeVCDelegate = reactNativeNavigationController.delegate;
        reactNativeNavigationController.delegate = self;
        self.reactNativeVC = reactNativeNavigationController;
    }
}

-(UINavigationController*)getReactNativeNavigationControllerWithView:(UIView*)view{
    UINavigationController* reactNativeNavigationController = nil;
    for (UIView* subview in view.subviews) {
        if ([subview isKindOfClass:[RCTNavigator class]]) {
            UIViewController* reactViewController = [((RCTView*)subview) reactViewController];
            if ([reactViewController isKindOfClass:[UINavigationController class]]) {
                reactNativeNavigationController = (UINavigationController*)reactViewController;
                break;
            }
        }else{
            reactNativeNavigationController = [self getReactNativeNavigationControllerWithView:subview];
        }
    }
    return reactNativeNavigationController;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 懒加载    UINavigationControllerDelegate method
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.reactNativeVCDelegate && [self.reactNativeVCDelegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)]) {
        [self.reactNativeVCDelegate navigationController:navigationController willShowViewController:viewController animated:animated];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.reactNativeVCDelegate && [self.reactNativeVCDelegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)]) {
        [self.reactNativeVCDelegate navigationController:navigationController didShowViewController:viewController animated:animated];
    }
}

- (NSUInteger)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController NS_AVAILABLE_IOS(7_0){
    if (self.reactNativeVCDelegate && [self.reactNativeVCDelegate respondsToSelector:@selector(navigationControllerSupportedInterfaceOrientations:)]) {
        return [self.reactNativeVCDelegate navigationControllerSupportedInterfaceOrientations:navigationController];
    }
    return YES;
}

- (UIInterfaceOrientation)navigationControllerPreferredInterfaceOrientationForPresentation:(UINavigationController *)navigationController NS_AVAILABLE_IOS(7_0){
    if (self.reactNativeVCDelegate && [self.reactNativeVCDelegate respondsToSelector:@selector(navigationControllerPreferredInterfaceOrientationForPresentation:)]) {
        return [self.reactNativeVCDelegate navigationControllerPreferredInterfaceOrientationForPresentation:navigationController];
    }
    return UIInterfaceOrientationPortrait;
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController NS_AVAILABLE_IOS(7_0){
    if (self.reactNativeVCDelegate && [self.reactNativeVCDelegate respondsToSelector:@selector(navigationController:interactionControllerForAnimationController:)]) {
        return [self.reactNativeVCDelegate navigationController:navigationController interactionControllerForAnimationController:animationController];
    }
    return nil;
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0){
    if (self.reactNativeVCDelegate && [self.reactNativeVCDelegate respondsToSelector:@selector(navigationController:animationControllerForOperation:fromViewController:toViewController:)]) {
        return [self.reactNativeVCDelegate navigationController:navigationController animationControllerForOperation:operation fromViewController:fromVC toViewController:toVC];
    }
    if([navigationController.viewControllers count] > 1){
        [_navigationButton setHidden:YES];
    }else{
        [_navigationButton setHidden:NO];
    }
    return nil;
}

@end

#endif