//
//  KSManWuTabBarViewController.m
//  basicFoundation
//
//  Created by 逸行 on 15-4-21.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "EHTabBarViewController.h"
#import "KSTabBarViewControllerProtocol.h"
#import "RDVTabBarItem.h"

@interface EHTabBarViewController ()<RDVTabBarControllerDelegate>

@property (nonatomic, strong) NSMutableDictionary* urltoClassInstrance;

@end

@implementation EHTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIViewController*)getViewControllerWithURL:(NSString*)url{
    if (url == nil) {
        return nil;
    }
    return [self.urltoClassInstrance objectForKey:url];
}

- (void)setupViewControllers{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"tabbarViewControllerRegister" ofType:@"plist"];
    NSArray *tabbarVCRegisterArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    NSMutableArray* navigationVCArray = [NSMutableArray array];
    NSMutableArray* tabbarNormalImages = [NSMutableArray array];
    NSMutableArray* tabbarSelectedImages = [NSMutableArray array];
    NSMutableArray* tabbarTitles = [NSMutableArray array];
    
    for (NSDictionary* viewControllerClassDict in tabbarVCRegisterArray) {
        if (![viewControllerClassDict isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        /******************/
        //viewControllerClass
        NSString* viewControllerClassName = [viewControllerClassDict objectForKey:@"viewControllerClassName"];
        if (viewControllerClassName == nil) {
            continue;
        }
        Class viewControllerClass = NSClassFromString(viewControllerClassName);
        if (viewControllerClass == nil) {
            continue;
        }
        if (viewControllerClass && [viewControllerClass isSubclassOfClass:[UIViewController class]]) {
            UIViewController *viewController = [[viewControllerClass alloc] init];
            [navigationVCArray addObject:viewController];
            // 设置 viewControllerURL 到 viewController的映射关系
            NSString* viewControllerURL = [viewControllerClassDict objectForKey:@"viewControllerURL"];
            if (viewControllerURL) {
                [self.urltoClassInstrance setObject:viewController forKey:viewControllerURL];
            }
        }
        /******************/
        /******************/
        //未选中 image
        NSString* tabbarNormalImage = [viewControllerClassDict objectForKey:@"tabbarNormalImage"];
        if (tabbarNormalImage) {
            [tabbarNormalImages addObject:tabbarNormalImage];
        }
        /******************/
        /******************/
        //选中 image
        NSString* tabbarSelectedImage = [viewControllerClassDict objectForKey:@"tabbarSelectedImage"];
        if (tabbarSelectedImage) {
            [tabbarSelectedImages addObject:tabbarSelectedImage];
        }
        /******************/
        /******************/
        //title
        NSString* tabbarTitle = [viewControllerClassDict objectForKey:@"tabbarTitle"];
        if (tabbarTitle) {
            [tabbarTitles addObject:tabbarTitle];
        }
        /******************/
    }
    [self setViewControllers:navigationVCArray];
    [self configTabBarItemWithNormalImages:tabbarNormalImages selectedImages:tabbarSelectedImages titles:tabbarTitles];
    self.delegate = self;
    [self.KSNavigationController rdv_setTabBarController:self];
}

- (void)configTabBarItemWithNormalImages:(NSArray*)normalImages
                            selectedImages:(NSArray*)selectedImages
                                  titles:(NSArray*)titles{
    
    [self.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navictr = (UINavigationController *)obj;
            
            navictr.navigationBar.translucent=NO;

            UIViewController *ctr=navictr.viewControllers[0];
            if (idx < [titles count]) {
                [ctr setTitle:titles[idx]];
            }
            ctr=nil;
        }else if([obj isKindOfClass:[UIViewController class]]){
            UINavigationController *navictr = ((UIViewController *)obj).KSNavigationController;
            if (navictr) {
                navictr.navigationBar.translucent=NO;
            }
        }
    }];
    
    NSInteger index = 0;
    
    for (RDVTabBarItem *item in [[self tabBar] items]) {
        item.backgroundColor=[UIColor clearColor];
        if (index >= [titles count]
            || index >= [selectedImages count]
            || index >= [normalImages count]) {
            continue;
        }
        
        [item setTitle:titles[index]];
        [item setTitlePositionAdjustment:UIOffsetMake(0, 2)];
        
        UIImage *selectedimage = [UIImage imageNamed:selectedImages[index]];
        UIImage *unselectedimage = [UIImage imageNamed:normalImages[index]];
        
        [item setImageSize:CGSizeMake(25, 25)];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        if (IOS_VERSION >= 7.0) {
            [item setSelectedTitleAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:RGB(0x23, 0x74, 0xfa)}];
            [item setUnselectedTitleAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:RGB(0x66, 0x66, 0x66)}];
        } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
            [item setSelectedTitleAttributes:@{UITextAttributeFont:[UIFont systemFontOfSize:10],UITextAttributeTextColor:RGB(0x23, 0x74, 0xfa)}];
            [item setUnselectedTitleAttributes:@{UITextAttributeFont:[UIFont systemFontOfSize:10],UITextAttributeTextColor:RGB(0x66, 0x66, 0x66)}];
#endif
        }
        index++;
    }
    UIImage* backgroundImage = [UIImage imageNamed:@"public_bg_bottombar"];
    self.tabBar.backgroundView.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
}

-(BOOL)tabBarController:(RDVTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    // 与登陆相关
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UIViewController* rootVC = viewController.childViewControllers[0];
        if ([rootVC conformsToProtocol:@protocol(KSTabBarViewControllerProtocol)] && [rootVC respondsToSelector:@selector(shouldSelectViewController:)]) {
            return [((id<KSTabBarViewControllerProtocol>)rootVC) shouldSelectViewController:self];
        }
    }else if ([viewController isKindOfClass:[UIViewController class]]){
        if ([viewController conformsToProtocol:@protocol(KSTabBarViewControllerProtocol)] && [viewController respondsToSelector:@selector(shouldSelectViewController:)]) {
            return [((id<KSTabBarViewControllerProtocol>)viewController) shouldSelectViewController:self];
        }
    }
    
    return NO;
}

-(void)tabBarController:(RDVTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UIViewController* rootVC = viewController.childViewControllers[0];
        if ([rootVC conformsToProtocol:@protocol(KSTabBarViewControllerProtocol)] && [rootVC respondsToSelector:@selector(didSelectViewController:)]) {
            [((id<KSTabBarViewControllerProtocol>)rootVC) didSelectViewController:self];
        }
    }else if ([viewController isKindOfClass:[UIViewController class]] && [viewController respondsToSelector:@selector(didSelectViewController:)]){
        if ([viewController conformsToProtocol:@protocol(KSTabBarViewControllerProtocol)]) {
            return [((id<KSTabBarViewControllerProtocol>)viewController) didSelectViewController:self];
        }
    }
}

- (void)tabBarController:(RDVTabBarController *)tabBarController didSelectSameViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UIViewController* rootVC = viewController.childViewControllers[0];
        if ([rootVC conformsToProtocol:@protocol(KSTabBarViewControllerProtocol)] && [rootVC respondsToSelector:@selector(didSelectSameViewController:)]) {
            [((id<KSTabBarViewControllerProtocol>)rootVC) didSelectSameViewController:self];
        }
    }else if ([viewController isKindOfClass:[UIViewController class]]){
        if ([viewController conformsToProtocol:@protocol(KSTabBarViewControllerProtocol)] && [viewController respondsToSelector:@selector(didSelectSameViewController:)]) {
            return [((id<KSTabBarViewControllerProtocol>)viewController) didSelectSameViewController:self];
        }
    }
}

// override by subclass
- (CGRect)selectViewControllerRectForBounds:(CGRect)bounds{
    if ([[self selectedViewController] conformsToProtocol:@protocol(KSTabBarViewControllerProtocol)] && [[self selectedViewController] respondsToSelector:@selector(selectViewControllerRectForBounds:)]) {
        return [((id<KSTabBarViewControllerProtocol>)[self selectedViewController]) selectViewControllerRectForBounds:bounds];
    }
    return [super selectViewControllerRectForBounds:bounds];
}

-(NSMutableDictionary *)urltoClassInstrance{
    if (_urltoClassInstrance == nil) {
        _urltoClassInstrance = [[NSMutableDictionary alloc] init];
    }
    return _urltoClassInstrance;
}

-(void)dealloc
{
    self.delegate = nil;
    [self.urltoClassInstrance removeAllObjects];
    self.urltoClassInstrance = nil;
}

@end

@implementation UIViewController (KSManWuTabBarViewController)

-(UINavigationController *)KSNavigationController{
    if ([self isKindOfClass:[RDVTabBarController class]]) {
        return self.navigationController;
    }else if ([self isKindOfClass:[UINavigationController class]]){
        return (UINavigationController*)self;
    }else{
        UINavigationController* nav = self.navigationController;
        if (nav == nil) {
            RDVTabBarController* tabBarVC = self.rdv_tabBarController;
            return tabBarVC.navigationController;
        }
    }
    return self.navigationController;
}

@end

@implementation EHTabBarViewController (UIApplication)

+(EHTabBarViewController*)getTabBarViewController{
    UIViewController* navigationViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
    if (![navigationViewController isKindOfClass:[UINavigationController class]]) {
        for (UIWindow* window in [[UIApplication sharedApplication] windows]) {
            if ([window.rootViewController isKindOfClass:[UINavigationController class]]) {
                navigationViewController = window.rootViewController;
                break;
            }
        }
    }
    return (EHTabBarViewController*)navigationViewController.rdv_tabBarController;
}

@end
