//
//  TBDetailBigPhotoBrowerController.m
//  TBTradeDetail
//
//  Created by sweety on 14/11/26.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "TBDetailBigPhotoBrowerController.h"
#import "TBDetailSimplePhotoView.h"
#import "DetailHUDActivityView.h"

static CGFloat const detailAnimationDuration = 0.5;
static CGFloat const detailAlpha = 0.95;

#define detailShowToolbarTimeout     6
#define detailPhotoActionsTag        100
#define detailPhotoActionSave        0
#define detailPhotoActionOriginalpic 1

@implementation TBDetailBigPhotoModel

-(id)initWidthUrl:(NSString *)photoUrl description:(NSString *)descption
{
    self = [super init];
    if (self) {
        _photoUrl  = photoUrl;
        _photoDesc = descption;
    }
    return self;
}

-(id)initWidthUrl:(NSString *)photoUrl
{
    return [self initWidthUrl:photoUrl description:nil];
}

@end

@interface TBDetailBigPhotoBrowerController ()
{
    BOOL isUseNumberPageControl;
}

@property (nonatomic, strong) UILabel *imgDescLabel;
@property (nonatomic, strong) UIView  *imgDescBg;

@end


@implementation TBDetailBigPhotoBrowerController

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _selectedIndex = 0;
        _currentPage = 0;
        _showsPageControl=YES;
        
        _prevStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
        _prevStatusBarHidden = [UIApplication sharedApplication].statusBarHidden;
    }
    
    return self;
}

-(void)dealloc
{
    if (_scrollView) {
        _scrollView.delegate = nil;
    }
}

-(void)displayPhoto{
    [self loadView];
    [self viewDidLoad];
    [self viewWillAppear:NO];
    [self viewDidAppear:NO];
}

#pragma mark - Accessor
-(TBDetailNumberPageControl *)numberPageControl
{
    if (!_numberPageControl) {
        CGRect frame       = CGRectMake(0.0f, self.bounds.size.height - 40.0f, 0.0, 20.0f);
        _numberPageControl = [[TBDetailNumberPageControl alloc] initWithFrame:frame];
        
        _numberPageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        _numberPageControl.center           = CGPointMake(self.bounds.size.width / 2,
                                                          self.bounds.size.height - 40.f);
        _numberPageControl.hidesForSinglePage = YES;
    }
    _numberPageControl.currentPage   = _currentPage;
    _numberPageControl.numberOfPages = [_photoList count];
    return _numberPageControl;
}

-(UIPageControl *)pageControl
{
    if (!_pageControl) {
        CGRect frame = CGRectMake(0.0f, self.bounds.size.height - 40.0f, 0.0, 20.0f);
        _pageControl = [[UIPageControl alloc] initWithFrame:frame];
        _pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        _pageControl.center           = CGPointMake(self.bounds.size.width/2, self.bounds.size.height - 30.0f);

        _pageControl.hidesForSinglePage = YES;
        //        [_pageControl addTarget:self action:@selector(showPage) forControlEvents:UIControlEventValueChanged];
    }
    _pageControl.numberOfPages = [_photoList count];
    _pageControl.currentPage   = _currentPage;
    return _pageControl;
}

#pragma mark -
#pragma mark View lifecycle

- (void)loadView {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:detailAlpha];
    
    
}

- (void)setupImages {
    NSLog(@"-----------");
    UILongPressGestureRecognizer *pan =[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpress:)] ;
    [self addGestureRecognizer:pan];
    
    CGSize size = _scrollView.frame.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    _scrollView.zoomScale = 1.0;
    _scrollView.contentSize = CGSizeMake(width*[_photoList count], height);
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    _imageViews = [[NSMutableArray alloc] initWithCapacity:[_photoList count]];
    
    for (int i = 0; i < [_photoList count]; ++i) {
        TBDetailSimplePhotoView *ascrView = [[TBDetailSimplePhotoView alloc] initWithFrame:CGRectMake(width*i, 0, width, height)];
        ascrView.touchDelegate = self;
        ascrView.image = [_imgs count]>i ? [_imgs objectAtIndex:i]:nil;
        [_imageViews addObject:ascrView];
        [_scrollView addSubview:ascrView];
    }
    
    if ([_photoList count] > 0) {
        [self loadImageAtIndex:_selectedIndex];
        
        _scrollView.contentOffset = CGPointMake(_selectedIndex * size.width, 0);
    }
    
    _currentPage = _selectedIndex;
    
    _maskImg=[[UIImageView alloc] initWithFrame:CGRectZero];
    _maskImg.contentMode=UIViewContentModeScaleAspectFit;
    _maskImg.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self addSubview:_maskImg];
    _maskImg.hidden=YES;
    
}

- (void)setupNavBar {
    _navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 44)];
    _navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _navBar.tintColor = [UIColor colorWithWhite:40/255.0 alpha:1.0];
    _navBar.barStyle = UIBarStyleBlackTranslucent;
    _navBar.backgroundColor = [UIColor clearColor];
    _navBar.translucent = YES;
    
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@""];
    [_navBar setItems:[NSArray arrayWithObject:navItem]];
    
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                style:UIBarButtonItemStyleBordered
                                                               target:self
                                                               action:@selector(backBtnClicked:)];
    _navBar.topItem.leftBarButtonItem = backBtn;
    
    _navBar.hidden=YES;
    [self addSubview:_navBar];
}


- (void)setupToolbar {
    
    _leftArrowBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"leftArrow.png"]
                                                     style:UIBarButtonItemStylePlain target:self action:@selector(gotoPrevPage:)];
    _rightArrowBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"rightArrow.png"]
                                                      style:UIBarButtonItemStylePlain target:self action:@selector(gotoNextPage:)];
    _leftArrowBtn.enabled = NO;
    _rightArrowBtn.enabled = NO;
    
    _actionsBtnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                    target:self action:@selector(showPhotoActions:)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil action:nil];
    UIBarButtonItem *placeHolder = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                 target:nil action:NULL];
    placeHolder.width = 40.0;
    
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-44, self.bounds.size.width, 44)];
    _toolbar.barStyle = UIBarStyleBlackTranslucent;
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _toolbar.items = [NSArray arrayWithObjects:
                      placeHolder,
                      flexSpace,
                      _leftArrowBtn,     // 左箭头
                      flexSpace,
                      _rightArrowBtn,    // 右箭头
                      flexSpace,
                      _actionsBtnItem,       // 操作按钮
                      nil];
    _toolbar.hidden=YES;
    [self addSubview:_toolbar];
}


- (void)setupPageControl {
    if ([_photoList count] <= 1) {
        _showsPageControl = NO;
    } else {
        _showsPageControl = YES;
    }
    
    if (_showsPageControl) {
        if ([_photoList count] > 5) {
            [self addSubview:self.numberPageControl];
            isUseNumberPageControl = YES;
        } else {
            [self addSubview:self.pageControl];
            isUseNumberPageControl = NO;
        }
    }
}

-(void)setupPictureDesc
{
    [self addSubview:self.imgDescBg];
}

- (void)viewDidLoad {
    _scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    
    [self addSubview:_scrollView];
    
    [self setupNavBar];
    [self setupToolbar];
    [self setupPageControl];
    [self setupPictureDesc];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewWillAppear:(BOOL)animated {
    //	[super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:animated];
    [self hideBars:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    //    [super viewDidAppear:animated];
    //    [self showBars];
    [self setupImages];
//    [self setupPictureDesc];
}

- (void)viewWillDisappear:(BOOL)animated {
    @try {
        //    [self showBars];
        _disableGuesture=YES;
        NSLog(@"1");
        [self setPageControlHidden];
        TBDetailSimplePhotoView*sim=[_imageViews objectAtIndex:_currentPage];
        _maskImg.image=sim.imageView.image;
        
        /*公共部分*/
        _imgDescBg.hidden  = YES;
        _scrollView.hidden = YES;
        _maskImg.hidden    = NO;
        
        if (_lastIndex==_currentPage) {
            [UIView animateWithDuration:.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                _maskImg.frame       = _maskFrame ;
                _maskImg.alpha = 0.3;
                self.backgroundColor = [UIColor clearColor];
            } completion:^(BOOL finished) {
                self.hidden      = YES;
                _disableGuesture = NO;                
            }];
        }else{
            _maskImg.image = [_imgs objectAtIndex:_currentPage];
            self.backgroundColor=[UIColor clearColor];
            [UIView animateWithDuration:.4 animations:^{
                _maskImg.transform = CGAffineTransformMakeScale(.5,.5);
                _maskImg.alpha     = .3;
            } completion:^(BOOL finished) {
                //            _maskImg.hidden=YES;
                self.hidden      = YES;
                _disableGuesture = NO;
                _maskImg.alpha   = 1;
                _maskImg.transform=CGAffineTransformMakeScale(1,1);
                
            }];
        }
        
        [_hideToolbarTimer invalidate];
        _hideToolbarTimer = nil;
        
        [[UIApplication sharedApplication] setStatusBarStyle:_prevStatusBarStyle animated:YES];
        
#if (defined(__IPHONE_3_2) && __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_3_2)
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
#else
        [[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
#endif
    }
    @catch (NSException *exception) {
        
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    
    int page = floor(_scrollView.contentOffset.x / _scrollView.bounds.size.width);
    CGSize size;
    CGRect screenframe = [[UIScreen mainScreen] bounds];
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        size = CGSizeMake(screenframe.size.width, screenframe.size.height);
    } else {
        size = CGSizeMake(screenframe.size.height, screenframe.size.width);
    }
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    //_scrollView.zoomScale = 1.0;
    _scrollView.contentSize = CGSizeMake(width*[_photoList count], height);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentOffset = CGPointMake(page * width, 0);
    
    [UIView commitAnimations];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
}


#pragma mark - Desc Label
-(UIView *)imgDescBg
{
    if (!_imgDescBg) {
        CGRect frame = CGRectMake(0, 0, 200, 30);
        _imgDescBg   = [[UIView alloc] initWithFrame:frame];
        
        _imgDescBg.backgroundColor    = [TBDetailUIStyle colorWithStyle:TBDetailColorStyle_Title0
                                                                  alpha:0.5];
        _imgDescBg.layer.cornerRadius = _imgDescBg.height / 2;
        [_imgDescBg addSubview:self.imgDescLabel];
    }
    return _imgDescBg;
}

-(UILabel *)imgDescLabel
{
    if (!_imgDescLabel) {
        CGRect frame            = CGRectMake(0, 0, 200, 30);
        _imgDescLabel           = [[UILabel alloc] initWithFrame:frame];
        _imgDescLabel.textColor = [TBDetailUIStyle colorWithStyle:TBDetailColorStyle_White];
        _imgDescLabel.font      = [TBDetailUIStyle fontWithStyle:TBDetailFontStyle_Chinese
                                                            size:TBDetailFontSize_Title0];
        _imgDescLabel.backgroundColor = [UIColor clearColor];
        _imgDescLabel.textAlignment   = NSTextAlignmentCenter;
    }
    return _imgDescLabel;
}

#pragma mark -

-(void)configDescLabel:(NSString *)desc
{
    if ([TBDetailUITools checkEmptyString:desc]) {
        self.imgDescBg.hidden = YES;
        return;
    }
    
    self.imgDescBg.hidden  = NO;
    self.imgDescLabel.text = desc;
    CGFloat horizontalGap  = 20;

    CGSize size = [desc sizeWithFont:self.imgDescLabel.font
                   constrainedToSize:CGSizeMake(self.width - horizontalGap * 2, 30)];
    CGFloat width  = ceilf(size.width);
    CGFloat height = self.imgDescBg.height;

    
    CGFloat bgWidth = width + horizontalGap * 2;
    CGFloat x       = round(self.width - bgWidth) / 2;
    CGFloat y       = round(self.height - height - 84);

    
    self.imgDescLabel.frame = CGRectMake(horizontalGap, 0, width, height);
    self.imgDescBg.frame    = CGRectMake(x, y, bgWidth, height);
    self.imgDescBg.layer.cornerRadius = (self.imgDescBg.height) / 2;
}

- (void)loadImageAtIndex:(NSUInteger)index {
    @try {
        TBDetailSimplePhotoView *aView = [_imageViews objectAtIndex:index];
        TBDetailBigPhotoModel *model   = [_photoList objectAtIndex:index];

        aView.image    = [_imgs objectAtIndex:index];
        aView.imageURL = model.photoUrl;
       
        NSLog(@"aView.imageURL:%@-,%@",aView.imageURL, model.photoUrl);
        
        [self configDescLabel:model.photoDesc];
        _leftArrowBtn.enabled  = index > 0;
        _rightArrowBtn.enabled = index < ([_photoList count] -1);
        
        //    self.title = [NSString stringWithFormat:@"%d of %d", index+1, [photos count]];
        //    navBar.topItem.title = self.title;
        
        //    if (!_navigationController.navigationBarHidden) {
        //        [self refreshHideToolbarTimer];
        //    }
        
        _currentPage = index;
        [self updatePageControl:_currentPage];
    }
    @catch (NSException *exception) {
        
    }
}

#pragma mark -
#pragma mark Show and hide bars

//- (void)refreshHideToolbarTimer {
//    if ([_hideToolbarTimer isValid]) {
//        [_hideToolbarTimer invalidate];
//    }
//    
//    _hideToolbarTimer = nil;
//    
//    _hideToolbarTimer = [NSTimer scheduledTimerWithTimeInterval:kShowToolbarTimeout
//                                                         target:self
//                                                       selector:@selector(hideBars:)
//                                                       userInfo:nil
//                                                        repeats:NO];
//}

//- (void)showBars {
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
//    
//    _toolbar.hidden = NO;
//    _toolbar.alpha = 1.0;
//    
//    _navBar.hidden=NO;
//    
//    [self refreshHideToolbarTimer];
//}

- (void)hideBars:(NSTimer *)timer {
    if (timer != nil && timer != _hideToolbarTimer) {
        return;
    }
    
    _hideToolbarTimer = nil;
    
#if (defined(__IPHONE_3_2) && __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_3_2)
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
#else
    [[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
#endif
    
    [UIView beginAnimations:nil context:NULL];
    _navBar.hidden = YES;
    _toolbar.hidden = YES;
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark TBDetailSimplePhotoView delegate

- (void)touchOnPhotoView:(TBDetailSimplePhotoView *)photoView {
    
    [self viewWillDisappear:YES];
    if(self.simplePhotoBrowserVCDisapperBlock!=nil){
        self.simplePhotoBrowserVCDisapperBlock();
    }
    
    //    if (_navBar.hidden == YES) {
    //        [self showBars];
    //    } else {
    //        [self hideBars:nil];
    //    }
}

#pragma mark - Page Control
-(void)updatePageControl:(NSInteger)currentPage
{
    if (_showsPageControl) {
        if (isUseNumberPageControl) {
            _numberPageControl.currentPage = currentPage;
            _numberPageControl.hidden      = NO;
        } else {
            _pageControl.currentPage = currentPage;
            _pageControl.hidden      = NO;
        }
    }
}

-(NSInteger)getCurrentIndexOnPageControl
{
    if (_showsPageControl) {
        if (isUseNumberPageControl) {
            return _numberPageControl.currentPage;
        } else {
            return _pageControl.currentPage;
        }
    } else {
        return 0;
    }
}

-(void)setPageControlHidden
{
    if (isUseNumberPageControl) {
        _numberPageControl.hidden = YES;
    } else {
        _pageControl.hidden       = YES;
    }
}

#pragma mark -
#pragma mark Toolbar and navbar actions

- (void)backBtnClicked:(id)sender {
    [self viewWillDisappear:YES];
}

- (void)showPhotoActions:(id)sender {
    NSLog(@"showphoto");
}

-(void)longpress:(UIGestureRecognizer *) sender {
    if (sender.state == UIGestureRecognizerStateBegan&&!_disableGuesture)
    {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"保存图片到相册",@"查看原图", nil];
        
        sheet.tag = detailPhotoActionsTag;
        [sheet showInView:self];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == detailPhotoActionsTag) {
        if (buttonIndex == detailPhotoActionSave) {
            [self saveToAlbum];
        }else if(buttonIndex == detailPhotoActionOriginalpic){
            [self getOriginalpic];
        }
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [_savePhotoLoadingView animateToHide];
    
    if (error) {
        if ([[error localizedDescription] isEqualToString:@"数据不可用"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存失败了"
                                                            message:@"请在 设置->隐私->照片 中开启淘宝对照片的访问权限"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存失败"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            
        }
        
    }else{
        [WeAppToast toast:@"图片已经保存到你的相册~"];
    }
}

- (void)getOriginalpic{
    if (_currentPage <=[_imageViews count] && _currentPage <= [_photoList count]) {
        TBDetailBigPhotoModel *model = [_photoList objectAtIndex:_currentPage];
        NSString *url = [model.photoUrl stringByReplacingOccurrencesOfString:@"q90." withString:@"."];
        if ([url length]>0) {
            UIImageView *tempView = [[UIImageView alloc] init];
            __block TBDetailSimplePhotoView *aView = [_imageViews objectAtIndex:_currentPage];
            [tempView setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image,NSError *error,SDImageCacheType cacheType){
                [aView getOriginalPic:url andImage:image];
            }];
        }
    }
}

- (void)saveToAlbum {
    TBDetailSimplePhotoView *photoView = [_imageViews objectAtIndex:_currentPage];
    UIImage *image = photoView.imageView.image;
    
    if (image != nil) {
        if (_savePhotoLoadingView == nil) {
            _savePhotoLoadingView = [[DetailHUDActivityView alloc] initWithFrame:self.bounds];
            _savePhotoLoadingView.textLabel.text = @"正在保存";
        }
        [self addSubview:_savePhotoLoadingView];
        
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
}


- (void)showPage {
    _currentPage = [self getCurrentIndexOnPageControl];
    [self loadImageAtIndex:_currentPage];
}


- (void)gotoPage:(NSUInteger)page {
    [self gotoPage:page animated:YES];
}

- (CGRect)rectInsetsForRect:(CGRect)frame ratio:(CGFloat)ratio
{
    CGFloat dx;
    CGFloat dy;
    
    dx = frame.size.width*ratio;
    dy = frame.size.height*ratio;
    
    return CGRectInset(frame, dx, dy);
}


-(void)replaceImages:(UIImage*)img{
    if (_imgs.count>_currentPage) {
        [_imgs replaceObjectAtIndex:_currentPage withObject:img];
    }
}

-(void)gotoPage:(NSInteger)page animated:(BOOL)animation{
    if (!animation) {
        _lastIndex=page;
        [self viewWillAppear:NO];
        if (_imgs.count>0) {
            
            _maskImg.frame=_maskFrame;
            _maskImg.image= [_imgs count]>page?[_imgs objectAtIndex:page]:nil;
            _maskImg.hidden=NO;
            _scrollView.hidden=YES;
            self.alpha=1;
            self.backgroundColor=[UIColor colorWithWhite:0 alpha:detailAlpha];
            
            [UIView animateWithDuration:detailAnimationDuration
                             animations:^{
                                 _maskImg.frame=        self.bounds;
                             }
                             completion:^(BOOL finished) {
                                 _maskImg.hidden=YES;
                                 _scrollView.hidden=NO;
                             }];
        }
    }
    if (page >= 0 && page < [_photoList count]) {
        [_scrollView setZoomScale:1.0 animated:animation];
        [_scrollView setContentOffset:CGPointMake(page * _scrollView.frame.size.width, 0) animated:animation];
        [self updatePageControl:_currentPage];
        [self loadImageAtIndex:page];
    }
    
}


- (void)gotoPrevPage:(id)sender {
    if (_currentPage > 0) {
        [self gotoPage:_currentPage-1];
    }
}

- (void)gotoNextPage:(id)sender {
    if (_currentPage < [_photoList count]-1) {
        [self gotoPage:_currentPage+1];
    }
}

#pragma mark -
#pragma mark UIScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self hideBars:nil];
}

//ScrollView 划动的动画结束后调用.
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = _scrollView.frame.size.width;
    NSInteger page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    //NSLog(@"page = %d, lastPage = %d", page, lastPage);
    
    if (_currentPage != page) {
        if(self.changeImageBlock!=nil){
            self.changeImageBlock(_currentPage,page);
        }
        [self loadImageAtIndex:page];
    }

    /*最后一张offset复原*/
    CGFloat scrollOffsetThreshold = scrollView.contentSize.width - pageWidth+10;
    CGFloat x = page * pageWidth;
    BOOL lastPage = (_pageControl.numberOfPages == 0) || page == _pageControl.numberOfPages - 1;
    if (lastPage && scrollView.contentOffset.x > x
        && scrollOffsetThreshold > scrollView.contentOffset.x) {
        /*滑动到最后一张，并且未到阈值*/
        [scrollView setContentOffset:CGPointMake(x, scrollView.contentOffset.y)
                            animated:YES];
    }
}

@end
