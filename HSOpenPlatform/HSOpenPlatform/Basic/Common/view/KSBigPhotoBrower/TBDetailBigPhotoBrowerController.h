//
//  TBDetailBigPhotoBrowerController.h
//  TBTradeDetail
//
//  Created by sweety on 14/11/26.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBDetailNumberPageControl.h"

@class DetailHUDActivityView;

@protocol TBDetailBigPhotoModel <NSObject>
@end

@interface TBDetailBigPhotoModel : NSObject <TBDetailBigPhotoModel>

@property (nonatomic, strong) NSString *photoUrl;

@property (nonatomic, strong) NSString *photoDesc;

-(id)initWidthUrl:(NSString *)photoUrl description:(NSString *)descption;

-(id)initWidthUrl:(NSString *)photoUrl;

@end

//图片切换时的回调block
typedef void (^ChangeImageBlock)( int,int);
//看大图控件消失时刻的回调block
typedef void (^SimplePhotoBrowserVCDisapperBlock)(void);

@interface TBDetailBigPhotoBrowerController : UIView<UIScrollViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) NSArray<TBDetailBigPhotoModel> *photoList;
@property (nonatomic, strong) NSMutableArray   *imageViews;
@property (nonatomic, strong) NSMutableArray   *imgs;
@property (nonatomic, strong) UIImageView      *originalpicImage;
@property (nonatomic, strong) UIScrollView     *scrollView;
@property (nonatomic, strong) UIToolbar        *toolbar;
@property (nonatomic, strong) UIBarButtonItem  *leftArrowBtn;
@property (nonatomic, strong) UIBarButtonItem  *rightArrowBtn;
@property (nonatomic, strong) UIBarButtonItem  *actionsBtnItem;
@property (nonatomic, strong) NSTimer          *hideToolbarTimer;
@property (nonatomic, strong) UINavigationBar  *navBar;

@property (nonatomic, strong) DetailHUDActivityView  *savePhotoLoadingView;

@property (nonatomic, assign) NSUInteger       currentPage;
//NSInteger           lastPage;

@property (nonatomic, assign) NSInteger        selectedIndex;
@property (nonatomic, assign) NSInteger        lastIndex;

@property (nonatomic, assign) UIStatusBarStyle prevStatusBarStyle;
@property (nonatomic, assign) BOOL             prevStatusBarHidden;
@property (nonatomic, assign) BOOL             disableGuesture;
@property (nonatomic, assign) CGRect           maskFrame;
@property (nonatomic, strong) UIImageView      *maskImg;
@property (nonatomic, strong) UIPageControl    *pageControl;
@property (nonatomic, strong) TBDetailNumberPageControl *numberPageControl;
@property (nonatomic, assign) BOOL             showsPageControl;

@property (nonatomic,strong) ChangeImageBlock                  changeImageBlock;
@property (nonatomic,strong) SimplePhotoBrowserVCDisapperBlock simplePhotoBrowserVCDisapperBlock;


- (void)loadImageAtIndex:(NSUInteger)index;
-(void)gotoPage:(NSInteger)page animated:(BOOL)animation;
//- (void)showBars;
//- (void)hideBars:(NSTimer *)timer;
//- (void)refreshHideToolbarTimer;
-(void)replaceImages:(UIImage*)img;

- (void)saveToAlbum;

-(void)displayPhoto;

- (void)viewWillDisappear:(BOOL)animated;

@end
