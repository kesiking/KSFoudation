//
//  HSFamilyAppIntroViewControllerCustomViewController.m
//  HSOpenPlatform
//
//  Created by jinmiao on 16/2/22.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import "HSFamilyAppIntroCustomViewController.h"
//#import "HSAppDetailsTableViewCell.h"
#import "HSProductHeaderCell.h"
#import "HSProductIntroductionCell.h"
#import "HSCommonAppListCollectionView.h"
#import "HSAppDetailsCollectionViewCell.h"
#import "HSAppVersionTableViewCell.h"
#import "HSAppPreviewModel.h"
#import "HSApplicationIntroModel.h"
#import "NSString+StringSize.h"
#import "HSAppSystemModel.h"

@interface HSFamilyAppIntroCustomViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) UITableView *tableView;

@property (strong,nonatomic) HSApplicationIntroModel *applicationIntroModel;

@end

@implementation HSFamilyAppIntroCustomViewController



#pragma mark - Life Cycle
- (instancetype)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query nativeParams:(NSDictionary *)nativeParams {
    self = [super init];
    if (self) {
        self.applicationIntroModel = [nativeParams objectForKey:@"appIntro"];
        self.title = self.applicationIntroModel.appName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

#pragma - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    switch (indexPath.row) {
        case 0: {
            HSProductHeaderCell *cell = [[HSProductHeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.separatorInset = UIEdgeInsetsMake(0, self.view.size.width, 0, 0);
            
            [cell configWithName:self.applicationIntroModel.appName title:@"中移（杭州）信息技术有限公司" iconUrl:self.applicationIntroModel.appLogo price:nil];
//            [cell configWithProductModel:self.model];
            return cell;
        }
            break;
        case 1:{
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
            flowLayout.minimumLineSpacing = 15*SCREEN_SCALE;
            [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
            HSCommonAppListCollectionView *appDetailsCollectionView = [[HSCommonAppListCollectionView alloc]initWithFrame:CGRectMake(15*SCREEN_SCALE, 20*SCREEN_SCALE, SCREEN_WIDTH - 15*SCREEN_SCALE, 210*SCREEN_SCALE) collectionViewLayout:flowLayout cellClass:[HSAppDetailsCollectionViewCell class]];
            appDetailsCollectionView.cellHeight = 210*SCREEN_SCALE;
            appDetailsCollectionView.cellWidth = 118*SCREEN_SCALE;
            
//            NSArray *nameArray = @[@"1.1.1最新活动",@"发现1-",@"个人信息-拷贝"];
//            NSMutableArray *modelArray = [[NSMutableArray alloc]init];
//            for (NSInteger i =0; i<3; i++) {
//                HSAppPreviewModel *model = [[HSAppPreviewModel alloc]init];
//                model.appDetailPicName = nameArray[i];
//                [modelArray addObject:model];
//            }
            appDetailsCollectionView.dataArray = self.applicationIntroModel.appImages;
            [cell.contentView addSubview:appDetailsCollectionView];
//            HSAppDetailsTableViewCell *cell = [[HSAppDetailsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            return cell;
        }
            break;
        case 2:{
            HSProductIntroductionCell *cell = [[HSProductIntroductionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell setTitle:@"关联产品" Content:self.applicationIntroModel.productInfo];
            
            return cell;
        }
            break;
        case 3:{
            HSProductIntroductionCell *cell = [[HSProductIntroductionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setTitle:@"内容摘要" Content:self.applicationIntroModel.appInfo];
            return cell;
        }
            break;
        default:{
            HSAppVersionTableViewCell *cell = [[HSAppVersionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
            NSArray *appSysArray = self.applicationIntroModel.appSys;
            HSAppSystemModel *appSystemModel = appSysArray[0];
        
            cell.buttonClickedBlock = ^{
                if (![[[UIDevice currentDevice] systemVersion] isEqualToString:@"9.3"]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appSystemModel.downUrl]];
                }
                
            };

            [cell setAppVersion:appSystemModel.appVersion appSize:appSystemModel.appSize appLanguage:appSystemModel.language compatibility:appSystemModel.appCompatible];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;

    }
}



//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 2;
//}

#pragma - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return 70;
            break;
        case 1:
            return 255;
            break;
        case 2:
            //return 71;
            return 15+15+15+15+[self.applicationIntroModel.productInfo sizeWithFontSize:EHSiz5 Width:SCREEN_WIDTH - 30].height;
            break;
        case 3:
            //return 93;
            return 15+15+15+15+[self.applicationIntroModel.productInfo sizeWithFontSize:EHSiz5 Width:SCREEN_WIDTH - 30].height;
            break;
        default:
            return 105;
            break;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma - getter and setter

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        CALayer *seperatorLine = [CALayer layer];
        [seperatorLine setFrame:CGRectMake(0, 70, self.view.frame.size.width,0.5 )];
        seperatorLine.backgroundColor = EHLinecor1.CGColor;
        [_tableView.layer addSublayer:seperatorLine];
        
        //_tableView.separatorStyle =
    }
    return _tableView;
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
