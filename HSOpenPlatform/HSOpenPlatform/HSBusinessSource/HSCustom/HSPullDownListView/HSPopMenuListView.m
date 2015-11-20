//
//  EHPopMenuLIstView.m
//  eHome
//
//  Created by 孟希羲 on 15/7/9.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "HSPopMenuListView.h"
#import "EHPopMenuModel.h"
#import "EHPopMenuCell.h"

@interface HSPopMenuListView()

@property (nonatomic,strong) UIButton*                      bgCancelBtn;

@property (nonatomic,strong) UIImageView*                   tableViewBgImageView;

@property (nonatomic,strong) KSTableViewController*         tableViewCtl;

@property (nonatomic,strong) KSDataSource*                  dataSourceRead;

@property (nonatomic,strong) KSDataSource*                  dataSourceWrite;

@property (nonatomic, weak)  UIView*                        currentSuperView;

@property (nonatomic,assign) CGPoint                        targetPoint;

@end


@implementation HSPopMenuListView

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 类方法
+(void)showMenuViewWithTitleTextArray:(NSArray*)titleTextArray menuSelectedBlock:(menuListSelectedBlock)menuSelectedBlock{
    [self showMenuViewWithTitleTextArray:titleTextArray menuSelectedBlock:menuSelectedBlock onView:[[UIApplication sharedApplication] keyWindow] atPoint:CGPointZero];
}

+(void)showMenuViewWithTitleTextArray:(NSArray*)titleTextArray menuSelectedBlock:(menuListSelectedBlock)menuSelectedBlock onView:(UIView *)view atPoint:(CGPoint)point{
    [self showMenuViewWithTitleTextArray:titleTextArray menuSelectedBlock:menuSelectedBlock menuDidCancelBlock:nil onView:view atPoint:point];
}

+(void)showMenuViewWithTitleTextArray:(NSArray*)titleTextArray menuSelectedBlock:(menuListSelectedBlock)menuSelectedBlock menuDidCancelBlock:(menuDidCancelBlock)menuDidCancelBlock onView:(UIView *)view atPoint:(CGPoint)point{
    if (titleTextArray == nil
        || ![titleTextArray isKindOfClass:[NSArray class]]
        || [titleTextArray count] == 0) {
        EHLogError(@"-----> can not show menu view because it has no titleTextArray");
        return;
    }
    HSPopMenuListView* menuListView = [HSPopMenuListView new];
    
    NSMutableArray* menuArray = [NSMutableArray array];
    for (NSString* titleText in titleTextArray) {
        if (![titleText isKindOfClass:[NSString class]]) {
            continue;
        }
        EHPopMenuModel* menu = [[EHPopMenuModel alloc] initWithTitleText:titleText];
        [menuArray addObject:menu];
    }
    
    [menuListView refreshMenuWithModelArray:menuArray];
    [menuListView setMenuListSelectedBlock:menuSelectedBlock];
    [menuListView showMenuOnView:view atPoint:point];
    [menuListView setMenuDidCancelBlock:menuDidCancelBlock];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - init method
-(void)setupView{
    [super setupView];
    self.menuCellSize = CGSizeMake(128, 45);
    [self addSubview:self.bgCancelBtn];
    [self addSubview:self.tableViewBgImageView];
    [self addSubview:self.tableViewCtl.scrollView];
    _tableViewBgImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_tableViewBgImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.tableViewCtl.scrollView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_tableViewBgImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.tableViewCtl.scrollView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:5]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_tableViewBgImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.tableViewCtl.scrollView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_tableViewBgImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.tableViewCtl.scrollView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
}

-(void)dealloc{
    _tableViewCtl = nil;
    _dataSourceRead = nil;
    _dataSourceWrite = nil;
}

-(UIButton *)bgCancelBtn{
    if (_bgCancelBtn == nil) {
        _bgCancelBtn = [[UIButton alloc] initWithFrame:self.bounds];
        _bgCancelBtn.backgroundColor = [UIColor clearColor];
        [_bgCancelBtn addTarget:self action:@selector(bgCancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgCancelBtn;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.bgCancelBtn setFrame:self.bounds];
}

-(void)setMenuCellSize:(CGSize)menuCellSize{
    _menuCellSize = menuCellSize;
    if (_tableViewCtl) {
        KSCollectionViewConfigObject* configObject = (KSCollectionViewConfigObject*)_tableViewCtl.configObject;
        configObject.collectionCellSize = menuCellSize;
        [_tableViewCtl setFrame:CGRectMake(_tableViewCtl.frame.origin.x, _tableViewCtl.frame.origin.y, menuCellSize.width, _tableViewCtl.frame.size.height)];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - tableViewCtl init
-(KSTableViewController *)tableViewCtl{
    if (_tableViewCtl == nil) {
        KSCollectionViewConfigObject* configObject = [[KSCollectionViewConfigObject alloc] init];
        CGRect frame = self.bounds;
        frame.size.width = self.menuCellSize.width;
        configObject.collectionCellSize = self.menuCellSize;
        configObject.autoAdjustFrameSize = YES;
        _tableViewCtl = [[KSTableViewController alloc] initWithFrame:frame withConfigObject:configObject];
        [_tableViewCtl.scrollView setBackgroundColor:[UIColor clearColor]];
        _tableViewCtl.scrollView.scrollEnabled = NO;
        _tableViewCtl.scrollView.layer.cornerRadius = 6;
        _tableViewCtl.scrollView.layer.masksToBounds = YES;
        [_tableViewCtl registerClass:[EHPopMenuCell class]];
        [_tableViewCtl setDataSourceRead:self.dataSourceRead];
        [_tableViewCtl setDataSourceWrite:self.dataSourceWrite];
        //添加分割线
        _tableViewCtl.viewCellConfigBlock = ^(KSViewCell* viewCell, WeAppComponentBaseItem *componentItem, KSCellModelInfoItem* modelInfoItem, NSIndexPath* indexPath,KSDataSource* dataSource){
            if (indexPath.row != 0) {
                UIView *separateView = [[UIView alloc]initWithFrame:CGRectMake(5, 0, viewCell.width - 10, 0.5)];
                separateView.backgroundColor = EH_cor13;
                [viewCell addSubview:separateView];
            }
            if (indexPath.row % 2 == 1) {
                viewCell.backgroundColor = RGB(0xee, 0xee, 0xee);
            }else{
                viewCell.backgroundColor = [UIColor whiteColor];
            }
        };
        WEAKSELF
        _tableViewCtl.tableViewDidSelectedBlock = ^(UITableView* tableView,NSIndexPath* indexPath,KSDataSource* dataSource,KSCollectionViewConfigObject* configObject){
            STRONGSELF
            NSUInteger index = [indexPath row];
            EHPopMenuModel* componentItem = (EHPopMenuModel*)[dataSource getComponentItemWithIndex:[indexPath row]];
            [strongSelf dissMissPopMenuAnimated];
            if (strongSelf.menuListSelectedBlock) {
                strongSelf.menuListSelectedBlock(index,componentItem);
            }
        };
    }
    return _tableViewCtl;
}

-(UIImageView *)tableViewBgImageView{
    if (_tableViewBgImageView == nil) {
        _tableViewBgImageView = [[UIImageView alloc] init];
        [_tableViewBgImageView setImage:[[UIImage imageNamed:@"public_bg_dropdown_n01"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 20, 10, 20) resizingMode:UIImageResizingModeStretch]];
    }
    return _tableViewBgImageView;
}

-(KSDataSource *)dataSourceRead {
    if (!_dataSourceRead) {
        _dataSourceRead = [[KSDataSource alloc] init];
    }
    return _dataSourceRead;
}

-(KSDataSource *)dataSourceWrite {
    if (!_dataSourceWrite) {
        _dataSourceWrite = [[KSDataSource alloc] init];
    }
    return _dataSourceWrite;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - btn action
-(void)bgCancelBtnClicked:(id)sender{
    [self dissMissPopMenuAnimated];
    if (self.menuDidCancelBlock) {
        self.menuDidCancelBlock();
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public method animation
- (void)showMenu{
    [self showMenuAtPoint:CGPointZero];
}

- (void)showMenuAtPoint:(CGPoint)point {
    [self showMenuOnView:[[UIApplication sharedApplication] keyWindow] atPoint:point];
}

- (void)showMenuOnView:(UIView *)view atPoint:(CGPoint)point {
    if (CGRectEqualToRect(self.frame, CGRectZero)) {
        [self setFrame:view.bounds];
        [self.tableViewCtl sizeToFit];
    }
    self.currentSuperView = view;
    self.targetPoint = point;
    [self setMenuTableViewPoint:self.targetPoint];
    if (![self.currentSuperView.subviews containsObject:self]) {
        self.alpha = 0.0;
        [self.currentSuperView addSubview:self];
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
    }else{
        self.alpha = 0.0;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 设置数据
-(void)refreshMenuWithModelArray:(NSArray*)popMenuModelArray{
    [self.dataSourceRead setDataWithPageList:popMenuModelArray extraDataSource:nil];
    [self.tableViewCtl refreshData];
}

-(void)setPopMenuCellSize:(CGSize)menuCellSize{
    _menuCellSize = menuCellSize;
    [((KSCollectionViewConfigObject*)self.tableViewCtl.configObject) setCollectionCellSize:menuCellSize];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - private method
-(void)setMenuTableViewPoint:(CGPoint)targetPoint{
    CGFloat startX = targetPoint.x > 0 ? targetPoint.x : CGRectGetWidth(self.bounds) - self.tableViewCtl.frame.size.width - 15;
    CGFloat startY = targetPoint.y > 0 ? targetPoint.y : 70;
    [self.tableViewCtl.scrollView setOrigin:CGPointMake(startX, startY)];
}

-(void)dissMissPopMenuAnimated {
    [self dissMissPopMenuWithAnimated:YES];
}

-(void)dissMissPopMenuWithAnimated:(BOOL)animated{
    if (animated) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }else{
        self.alpha = 0.0;
        [self removeFromSuperview];
    }
}

@end
