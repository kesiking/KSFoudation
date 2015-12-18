//
//  KSDebugRequestView.m
//  HSOpenPlatform
//
//  Created by xtq on 15/12/7.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "KSDebugRequestView.h"
#import "KSDebugOperationView.h"
#import "KSDebugManager.h"
#import "KSDebugURLProtocol.h"
#import "KSDebugRequestListView.h"
#import "KSDebugRequestManager.h"
#import "KSDebugRequestListToolBar.h"
#import "KSDebugRequestDetailToolBar.h"

@interface KSDebugRequestView ()

@property (nonatomic, strong) KSDebugRequestListView *requestListView;

@property (nonatomic, strong) KSDebugRequestListToolBar *listToolBar;

@property (nonatomic, strong) KSDebugRequestDetailToolBar *detailToolBar;

@end

@implementation KSDebugRequestView

+(void)load{
    NSMutableArray* array = [KSDebugOperationView getDebugViews];
    [array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"网络请求",@"title",NSStringFromClass([self class]),@"className", nil]];
}

-(void)setupView{
    [super setupView];
    self.infoLabel.hidden = YES;
    [KSDebugURLProtocol registerProtocol];
    [KSDebugRequestManager resetManager];
}


-(void)startDebug{
    [super startDebug];
    
    [self configUI];
    self.requestListView.requestArray = [KSDebugRequestManager sharedManager].requestArray;
    [self.requestListView reloadData];
    [self.listToolBar showTotalFlowCount];
}

-(void)endDebug{
    [super endDebug];
}

- (void)dealloc {
    [KSDebugURLProtocol unRegisterProtocol];
}


#pragma mark - Private Methods
- (void)showDebugTextView {
    self.detailToolBar.alpha = 0;
    self.detailToolBar.hidden = NO;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.requestListView.transform = CGAffineTransformMakeTranslation(-self.frame.size.width, 0);
        self.debugTextView.transform = CGAffineTransformMakeTranslation(-self.frame.size.width, 0);
        self.listToolBar.alpha = 0;
        self.detailToolBar.alpha = 1;
    } completion:^(BOOL finished) {
        self.listToolBar.hidden = YES;
        self.debugTextViewFrame = self.debugTextView.frame;
    }];
}

- (void)showDebugListView {
    self.listToolBar.alpha = 0;
    self.listToolBar.hidden = NO;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.requestListView.transform = CGAffineTransformIdentity;
        self.debugTextView.transform = CGAffineTransformIdentity;
        self.listToolBar.alpha = 1;
        self.detailToolBar.alpha = 0;
    } completion:^(BOOL finished) {
        self.detailToolBar.hidden = YES;
        self.debugTextViewFrame = self.debugTextView.frame;
    }];
}

- (void)showUploadVC {
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[self.debugTextView.attributedText] applicationActivities:nil];
    
#ifdef __IPHONE_8_0
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1 &&
        UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        UIPopoverPresentationController *ctrl = activityController.popoverPresentationController;
        ctrl.sourceView = self;
    }
#endif
    
    typeof(self) __weak __block weakSelf = self;
    activityController.completionHandler = ^(NSString * __nullable activityType, BOOL completed) {
        typeof(self) __strong strongSelf = weakSelf;
        strongSelf.hidden = NO;
        [strongSelf.debugViewReference addSubview:strongSelf];
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
        }];
        
    };
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
    [self.window.rootViewController presentViewController:activityController animated:YES completion:^{
        [self removeFromSuperview];
    }];
}

#pragma mark - Getters & Setters
- (void)configUI {
    self.debugTextView.text = nil;
    NSArray *subviewArray = @[self.requestListView,self.listToolBar,self.detailToolBar];
    for (UIView *view in subviewArray) {
        if (view.superview == nil) {
            [self addSubview:view];
        }
    }
    
    self.requestListView.transform = CGAffineTransformIdentity;
    self.debugTextView.transform = CGAffineTransformIdentity;
    self.listToolBar.hidden = NO;
    self.listToolBar.alpha = 1;
    self.detailToolBar.hidden = YES;

    
    CGRect frame = self.requestListView.frame;
    frame.origin.x += self.frame.size.width;
    self.debugTextViewFrame = frame;
    self.debugTextView.frame = frame;
}

- (KSDebugRequestListView *)requestListView {
    if (!_requestListView) {
        _requestListView = [[KSDebugRequestListView alloc]initWithFrame:self.debugTextViewFrame style:UITableViewStylePlain];
        typeof(self) __weak __block weakSelf = self;
        _requestListView.selectedRequestModelBlock = ^(KSDebugRequestModel *model) {
            typeof(self) __strong strongSelf = weakSelf;
            [strongSelf showDebugTextView];
            [strongSelf.debugTextView setContentOffset:CGPointZero];
            strongSelf.debugTextView.attributedText = [model getAttributedString];
            [strongSelf.detailToolBar showTotalFlowCount:model.responseExpectedContentLength];
        };
    }
    return _requestListView;
}

- (KSDebugRequestListToolBar *)listToolBar {
    if (!_listToolBar) {
        _listToolBar = [[KSDebugRequestListToolBar alloc]initWithFrame:self.infoLabel.frame];
        
        typeof(self) __weak __block weakSelf = self;
        _listToolBar.clearBtnClickedBlock = ^(){
            typeof(self) __strong strongSelf = weakSelf;
            [KSDebugRequestManager resetManager];
            strongSelf.requestListView.requestArray = [KSDebugRequestManager sharedManager].requestArray;
            [strongSelf.requestListView reloadData];
            [strongSelf.listToolBar showTotalFlowCount];
        };
        
        _listToolBar.sortBtnClickedBlock = ^(KSDebugRequestListShowType showType){
            typeof(self) __strong strongSelf = weakSelf;
            strongSelf.requestListView.requestArray = [KSDebugRequestManager sharedManager].requestArray;
            [strongSelf.requestListView reloadDataWithType:showType];
            [strongSelf.listToolBar showTotalFlowCount];
        };
    }
    return _listToolBar;
}

- (KSDebugRequestDetailToolBar *)detailToolBar {
    if (!_detailToolBar) {
        _detailToolBar = [[KSDebugRequestDetailToolBar alloc]initWithFrame:self.infoLabel.frame];
        _detailToolBar.hidden = YES;
        typeof(self) __weak __block weakSelf = self;
        _detailToolBar.returnBtnClickedBlock = ^(){
            [weakSelf showDebugListView];
        };
        _detailToolBar.uploadBtnClickedBlock = ^(){
            [weakSelf showUploadVC];
        };
    }
    return _detailToolBar;
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView* view = [super hitTest:point withEvent:event];
    return view;
}

@end
