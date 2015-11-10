//
//  EHUserPicFromPhotosViewController.m
//  eHome
//
//  Created by xtq on 15/6/18.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHUserPicFromPhotosViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "EHPhotoBrowserViewController.h"

@interface EHUserPicFromPhotosViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation EHUserPicFromPhotosViewController
{
    ALAssetsLibrary *_assetsLibrary;
    NSMutableArray *_groupArray;
    UITableView *_tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigationBar];
    _assetsLibrary = [[ALAssetsLibrary alloc]init];
    
    [self.view addSubview:[self tableView]];
    [self setGroupArray];
}

#pragma mark - Events Response
- (void)cancleBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _groupArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    ALAssetsGroup *group = _groupArray[indexPath.row];
    cell.imageView.image = [UIImage imageWithCGImage:[group posterImage]];
    cell.textLabel.text = [group valueForProperty:ALAssetsGroupPropertyName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld张",[group numberOfAssets]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EHPhotoBrowserViewController *pbvc = [[EHPhotoBrowserViewController alloc]init];
    pbvc.group = _groupArray[indexPath.row];
    pbvc.finishSelectedImageBlock = self.finishSelectedImageBlock;
    [self.navigationController pushViewController:pbvc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Getters And Setters
- (void)configNavigationBar{
    self.title = @"相册";
    
    UIBarButtonItem *cancleItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancleBtnClick:)];
    self.navigationItem.rightBarButtonItem = cancleItem;
}

/**
 *  懒加载相册列表
 */
- (void)setGroupArray{
    _groupArray = [[NSMutableArray alloc]init];
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        if (group != nil) {
//            NSLog(@"group = %@",group);
//            NSLog(@"相册名称:%@", [group valueForProperty:ALAssetsGroupPropertyName]);
//            NSLog(@"照片数量:%d", [group numberOfAssets]);
            [_groupArray addObject:group];
        }
        else {
            [_tableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"error = %@", error);
    }];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 80;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
