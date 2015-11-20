//
//  HSBusinessHallListView.m
//  HSOpenPlatform
//
//  Created by xtq on 15/10/16.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSBusinessHallListView.h"
#import "HSMapViewManager.h"
#import "HSAMapPoiSearchService.h"

#define kHSSearchKeyWord @"移动营业厅"

@interface HSBusinessHallListView ()

@property (nonatomic, strong)HSAMapPoiSearchService *poiSearchService;

@end

@implementation HSBusinessHallListView

#pragma mark - Common Methods
/**
 *  下拉刷新
 */
- (void)refreshData {
    self.currentPage = 1;
    [self.poiSearchService searchPoiWithPageNumber:self.currentPage];
}

/**
 *  上拉加载
 */
- (void)loadMoreData {
    self.currentPage++;
    [self.poiSearchService searchPoiWithPageNumber:self.currentPage];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:self.dataArray forKey:@"poiList"];
    [params setObject:@(indexPath.section) forKey:@"selectedIndex"];
    TBOpenURLFromSourceAndParams(internalURL(@"HSBusinessHallMapViewController"), self, params);
}

- (HSAMapPoiSearchService *)poiSearchService {
    if (!_poiSearchService) {
        _poiSearchService = [[HSAMapPoiSearchService alloc]init];
        _poiSearchService.offset = self.offset;
        WEAKSELF
        _poiSearchService.searchFinishedBlock = ^(NSArray *poiList){
            STRONGSELF
            if (strongSelf.currentPage == 1) {
                [strongSelf.dataArray removeAllObjects];
            }
            for (id object in poiList) {
                [strongSelf.dataArray addObject:object];
            }
            [strongSelf reloadData];
        };
        _poiSearchService.searchFailedBlock = ^(){
            STRONGSELF
            [strongSelf reloadFail];
        };
    }
    return _poiSearchService;
}
@end
