//
//  HSFamilyAppIntroParentViewController.m
//  HSOpenPlatform
//
//  Created by jinmiao on 16/4/7.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import "HSFamilyAppIntroParentViewController.h"
#import "HSFamilyAppIntroViewController.h"

@interface HSFamilyAppIntroParentViewController ()

@property (strong, nonatomic) NSString *H5url;
@property (strong, nonatomic) NSDictionary *childNativeParams;

@end

@implementation HSFamilyAppIntroParentViewController


#pragma mark - Life Cycle
- (instancetype)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query nativeParams:(NSDictionary *)nativeParams {
    self = [super init];
    if (self) {
        self.title = [nativeParams objectForKey:@"appName"];
        self.childNativeParams = nativeParams;
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    HSFamilyAppIntroViewController *familyAppIntroViewController = [[HSFamilyAppIntroViewController alloc]initWithNavigatorURL:nil query:nil nativeParams:self.childNativeParams];
    [self addChildViewController:familyAppIntroViewController];
    familyAppIntroViewController.view.frame =  CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)- 60);
    [self.view addSubview:familyAppIntroViewController.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
