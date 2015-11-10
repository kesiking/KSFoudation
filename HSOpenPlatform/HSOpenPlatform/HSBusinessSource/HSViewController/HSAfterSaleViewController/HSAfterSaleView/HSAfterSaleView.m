//
//  HSAfterSaleView.m
//  HSOpenPlatform
//
//  Created by xtq on 15/11/6.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSAfterSaleView.h"
#import "HSHomeCustomerServiceCollectionView.h"
#import "HSNationalAfterSaleService.h"
#import "HSLocalAfterSaleService.h"
#import "HSHomeServicLocationCell.h"
#import "HSNationalAfterSaleCell.h"

#define kHSAfterSaleViewHeaderHeight    caculateNumber(31.0)
#define kHLocalAfterSaleCellHeight      caculateNumber(105)

@interface HSAfterSaleView ()

@property (nonatomic, strong) HSHomeCustomerServiceCollectionView *serviceCollectionView;

@property (nonatomic, strong) HSNationalAfterSaleService *nationalAfterSaleService;

@property (nonatomic, strong) HSLocalAfterSaleService *localAfterSaleService;

@property (nonatomic, strong) HSNationalAfterSaleModel *nationalAfterSaleModel;

@property (nonatomic, strong) HSApplicationModel *appModel;

@property (nonatomic, assign) NSInteger appIndex;

@property (nonatomic, strong) NSArray *imageStrArray;

@property (nonatomic, assign) BOOL isNationalAfterSaleLoaded;

@end

@implementation HSAfterSaleView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            [self setSeparatorInset: UIEdgeInsetsZero];
        }
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            [self setLayoutMargins: UIEdgeInsetsZero];
        }
    }
    return self;
}

/**
 *  下拉刷新
 */
- (void)refreshData {
    self.currentPage = 1;
    if (self.serviceCollectionView.dataArray.count == 0) {
        [self.serviceCollectionView refreshDataRequest];
    }
    else {
        if (!self.isNationalAfterSaleLoaded) {
            [self.nationalAfterSaleService getNationalAfterSaleWithAppId:self.appModel.appId];
        }
        
        [self.localAfterSaleService getLocalAfterSaleWithAppId:self.appModel.appId PageSize:self.offset CurrentPage:self.currentPage];
    }
}

/**
 *  上拉加载
 */
- (void)loadMoreData {
    self.currentPage++;
    [self.localAfterSaleService getLocalAfterSaleWithAppId:self.appModel.appId PageSize:self.offset CurrentPage:self.currentPage];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 2?self.dataArray.count:1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        if (self.serviceCollectionView) {
            [self.serviceCollectionView removeFromSuperview];
        }
        [cell.contentView addSubview:self.serviceCollectionView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section == 1) {
        HSNationalAfterSaleCell *cell = [[HSNationalAfterSaleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell setModel:self.nationalAfterSaleModel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        static NSString *cellID = @"cellID";
        HSHomeServicLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[HSHomeServicLocationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        HSMapPoiModel *poiModel = self.dataArray[indexPath.row];
        [cell setModel:poiModel];
        return cell;
    }
}



#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 2) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setObject:self.dataArray forKey:@"poiList"];
        [params setObject:@(indexPath.row) forKey:@"selectedIndex"];
        TBOpenURLFromSourceAndParams(@"HSBusinessHallMapViewController", self, params);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return self.serviceCollectionView.height;
            break;
        case 1:
            return 100;
            break;
        default:
            return kHLocalAfterSaleCellHeight;
            break;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return caculateNumber(15);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 0.1;
            break;
        default:
            return kHSAfterSaleViewHeaderHeight;
            break;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    else {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = EH_cor1;
        
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = EHLinecor1.CGColor;
        layer.frame = CGRectMake(0, 0, tableView.width, 0.5);
        [view.layer addSublayer:layer];
        
        UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(caculateNumber(20), 0, CGRectGetWidth(tableView.frame), kHSAfterSaleViewHeaderHeight)];
        titlelabel.font = EHFont2;
        titlelabel.textColor = EHCor6;
        
        if (section == 1) {
            titlelabel.text = @"全国统一售后中心";
        }
        else if (section == 2) {
            titlelabel.text = @"本地售后网点";
        }
        
        [view addSubview:titlelabel];
        return view;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - Config AppListView
- (HSHomeCustomerServiceCollectionView *)serviceCollectionView {
    if (!_serviceCollectionView) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];

        _serviceCollectionView = [[HSHomeCustomerServiceCollectionView alloc]initWithFrame:CGRectMake(0, 0, self.width, SCREEN_WIDTH/6.0) collectionViewLayout:flowLayout];
        
        WEAKSELF
        _serviceCollectionView.itemIndexBlock = ^(NSInteger itemIndex) {
            STRONGSELF
            strongSelf.appIndex = itemIndex;
            strongSelf.appModel = (HSApplicationModel *)strongSelf.serviceCollectionView.dataArray[itemIndex];
            strongSelf.isNationalAfterSaleLoaded = NO;
            [strongSelf refreshData];
        };
        _serviceCollectionView.serviceDidFailLoadBlock = ^(){
            STRONGSELF
            [strongSelf reloadFail];
        };
    }
    return _serviceCollectionView;
}

#pragma mark - Config Services
- (HSNationalAfterSaleService *)nationalAfterSaleService {
    if (!_nationalAfterSaleService) {
        _nationalAfterSaleService = [HSNationalAfterSaleService new];
        WEAKSELF
        _nationalAfterSaleService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service) {
            STRONGSELF
            strongSelf.nationalAfterSaleModel = (HSNationalAfterSaleModel *)service.item;
            strongSelf.nationalAfterSaleModel.appIconUrl = strongSelf.appModel.appIconUrl;
            strongSelf.nationalAfterSaleModel.placeholderImageStr = strongSelf.imageStrArray[strongSelf.appIndex];
            
            strongSelf.isNationalAfterSaleLoaded = YES;
            
            NSIndexSet * indexSet=[[NSIndexSet alloc]initWithIndex:1];
            [strongSelf reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        };
        _nationalAfterSaleService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            STRONGSELF
            strongSelf.isNationalAfterSaleLoaded = NO;
        };
    }
    return _nationalAfterSaleService;
}

- (HSLocalAfterSaleService *)localAfterSaleService {
    if (!_localAfterSaleService) {
        _localAfterSaleService = [HSLocalAfterSaleService new];
        WEAKSELF
        _localAfterSaleService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service) {
            STRONGSELF
            if (strongSelf.currentPage == 1) {
                [strongSelf.dataArray removeAllObjects];
            }
            for (HSLocalAfterSaleModel *localAfterSaleModel in service.dataList) {
                HSMapPoiModel *poiModel = [[HSMapPoiModel alloc]initWithLocalAfterSaleModel:localAfterSaleModel];
                [strongSelf.dataArray addObject:poiModel];
            }

            [strongSelf reloadData];
        };
        _localAfterSaleService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            STRONGSELF
            [strongSelf reloadFail];
        };
    }
    return _localAfterSaleService;
}

- (NSArray *)imageStrArray {
    if (!_imageStrArray) {
        _imageStrArray = @[@"icon_lushang",@"icon_heluyou",@"icon_hemu",@"icon_zhaota",@"icon_mobaihe",@"icon_migu"];
    }
    return _imageStrArray;
}

@end
