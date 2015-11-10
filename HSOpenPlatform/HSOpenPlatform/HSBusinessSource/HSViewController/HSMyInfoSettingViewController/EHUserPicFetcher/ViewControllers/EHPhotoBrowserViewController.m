//
//  EHPhotoBrowserViewController.m
//  eHome
//
//  Created by xtq on 15/6/19.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHPhotoBrowserViewController.h"
#import "EHPhotoBrowserCell.h"
#import "EHPhotoPlayViewController.h"
#import "EHImageMagicMoveTransition.h"
@interface EHPhotoBrowserViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>

@end

@implementation EHPhotoBrowserViewController
{
    NSMutableArray *_photoArray;
    BOOL _scrollToEndTag;
}

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self.group valueForProperty:ALAssetsGroupPropertyName];
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    _scrollToEndTag = NO;
    _photoArray = [self photoArray];
    [self.view addSubview:[self tableView]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
}

//解决首次进来直接显示最近的照片
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!_scrollToEndTag) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:((_photoArray.count + kColumn - 1) / kColumn - 1) inSection:0];
            [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        _scrollToEndTag = YES;
    }
}

#pragma mark UINavigationControllerDelegate methods
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    // Check if we're transitioning from this view controller to a DSLSecondViewController
    if (fromVC == self && [toVC isKindOfClass:[EHPhotoPlayViewController class]]) {
        return [[EHImageMagicMoveTransition alloc] init];
    }
    else {
        return nil;
    }
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGRectGetWidth(tableView.frame) - kPhotoSpaceX * (kColumn - 1) - kCellSide * 2) / kColumn + kPhotoSpaceY;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (_photoArray.count + kColumn - 1) / kColumn;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    EHPhotoBrowserCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[EHPhotoBrowserCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSInteger location = indexPath.row * kColumn;
    NSInteger length = kColumn;
    
    if (location + length >= [_photoArray count]) {
        length = [_photoArray count] - location;
    }
    NSRange range = NSMakeRange(location, length);
    NSArray *array = [_photoArray subarrayWithRange:range];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsZero;
    [cell setRowPhotos:array];

    EHPhotoBrowserViewController *__weak weakSelf = self;
    //选择照片进行显示的回调
    cell.selectedBlock = ^(UIImage *bigImage){
        EHPhotoPlayViewController *ppvc = [[EHPhotoPlayViewController alloc]init];
        ppvc.bigImage = bigImage;
        ppvc.finishSelectedImageBlock = self.finishSelectedImageBlock;

        [weakSelf.navigationController pushViewController:ppvc animated:YES];
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    };
    return cell;

}

#pragma mark - Getters And Setters
/**
 *  一个相册里的照片资源
 */
- (NSMutableArray *)photoArray{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    [self.group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result != nil) {
            [array addObject:result];
        }
    }];
    return array;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        NSLog(@"tableView width  = %f",CGRectGetWidth(_tableView.frame));
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 80;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
