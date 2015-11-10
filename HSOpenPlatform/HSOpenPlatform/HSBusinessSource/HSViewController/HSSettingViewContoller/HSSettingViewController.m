//
//  EHSettingViewController.m
//  eHome
//
//  Created by xtq on 15/6/10.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "HSSettingViewController.h"
#import "EHSwitch.h"

#define kEHShakeNoticeKey @"shakeNoticeKey"     //震动
#define kEHVoiceNoticeKey @"voiceNoticeKey"     //声音
#define kEHNoticeKey @"noticeKey"               //通知提醒
#define kCellHeight     50
#define kHeaderViewHeight 30
#define kSwitchTag 100

@interface HSSettingViewController ()<UITableViewDataSource,UITableViewDelegate>
@end

@implementation HSSettingViewController
{
    GroupedTableView *_tableView;
    NSMutableArray *_titleArray;
    NSMutableArray *_sliderStatueArray;
    UIView         *_footerView;
}

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
    _titleArray = [[NSMutableArray alloc]initWithObjects:@"接受信息通知", @"震动", @"声音", nil];
    _sliderStatueArray = [self arrayOfNotice];
    if(![_sliderStatueArray[0] boolValue]) {
        [_titleArray removeLastObject];
        [_titleArray removeLastObject];
    }
    
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    else {
        return _titleArray.count - 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }

    for (int i = 0; i < 3; i++) {
        if ([cell.contentView viewWithTag:kSwitchTag + i]) {
            [[cell.contentView viewWithTag:kSwitchTag + i] removeFromSuperview];
        }
    }
    cell.textLabel.text = _titleArray[indexPath.section + indexPath.row];
    cell.textLabel.font = EHFont2;
    cell.textLabel.textColor = EHCor5;
    
    if ((indexPath.section == 0)&&(indexPath.row == 0)) {
        [cell.contentView addSubview:[self switchWithTag:indexPath.section + indexPath.row]];
    }else
    {
        [cell.contentView addSubview:[self buttonWithTag:indexPath.section + indexPath.row]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        if (_footerView == nil) {
            UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tableView.frame), [self tableView: _tableView heightForFooterInSection:section])];
            NSString *text = @"关闭接受消息通知，您将无法接收通知信息。";
            
            CGFloat spaceX = tableView.separatorInset.left;
            
            UILabel *warnLabel = [[UILabel alloc]initWithFrame:CGRectMake(spaceX, 10, CGRectGetWidth(_tableView.frame) - spaceX * 2, 25)];
            warnLabel.text = text;
            warnLabel.textColor = EHCor3;
            warnLabel.font = EHFont5;
            warnLabel.textAlignment = NSTextAlignmentLeft;
            warnLabel.lineBreakMode = NSLineBreakByWordWrapping;
            warnLabel.numberOfLines = 0;
            [warnLabel sizeToFit];
            EHLogInfo(@"warnLabel height = %f",warnLabel.frame.size.height);
            [footerView addSubview:warnLabel];
            _footerView = footerView;
        }
        return _footerView;
    }
    else return nil;
    
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Events Response
- (void)switchChanged:(BOOL)switchON
{
    _sliderStatueArray[0] = [NSNumber numberWithBool:switchON];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i <= 1; i++) {
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:1];
        [array addObject:indexpath];
    }
    if (switchON) {
        [_titleArray addObject:@"震动"];
        [_titleArray addObject:@"声音"];
        
        [_tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
    }else  {
        [_titleArray removeObject:@"震动"];
        [_titleArray removeObject:@"声音"];
        
        [_tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
    }
    [self updateNotice:switchON];
}

- (void)ButtonClicked:(UIButton *)sender
{
    BOOL btnON = ![_sliderStatueArray[sender.tag - kSwitchTag] boolValue];
    _sliderStatueArray[sender.tag - kSwitchTag] = [NSNumber numberWithBool:btnON];
    if(btnON){
        [sender setImage:[UIImage imageNamed:@"public_radiobox_set_on"] forState:UIControlStateNormal];
    }else{
        [sender setImage:[UIImage imageNamed:@"public_radiobox_set_off"] forState:UIControlStateNormal];
    }
    if (sender.tag == kSwitchTag +1) {
        [self updateShakeNotice:btnON];
    }else if (sender.tag == kSwitchTag +2){
        [self updateVoiceNotice:btnON];
    }
}

#pragma mark - Common Methods
- (NSMutableArray *)arrayOfNotice{
    NSNumber *shakeNumber,*voiceNumber,*noticeNumber;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //通知提醒
    if ([userDefaults objectForKey:kEHNoticeKey]) {
        noticeNumber = [userDefaults objectForKey:kEHNoticeKey];
    }
    else{
        noticeNumber = @YES;
        [userDefaults setObject:noticeNumber forKey:kEHNoticeKey];
    }
    EHLogInfo(@"kEHNoticeKey = %@",noticeNumber);
    //震动
    if ([userDefaults objectForKey:kEHShakeNoticeKey]) {
        shakeNumber = [userDefaults objectForKey:kEHShakeNoticeKey];
    }
    else{
        shakeNumber = @YES;
        [userDefaults setObject:shakeNumber forKey:kEHShakeNoticeKey];
    }
    EHLogInfo(@"kEHShakeNoticeKey = %@",shakeNumber);
    //声音
    if ([userDefaults objectForKey:kEHVoiceNoticeKey]) {
        voiceNumber = [userDefaults objectForKey:kEHVoiceNoticeKey];
    }
    else{
        voiceNumber = @YES;
        [userDefaults setObject:voiceNumber forKey:kEHVoiceNoticeKey];
    }
    EHLogInfo(@"kEHVoiceNoticeKey = %@",voiceNumber);

    return [NSMutableArray arrayWithObjects:noticeNumber,shakeNumber,voiceNumber, nil];
}

/**
 *  通知提醒
 */
- (void)updateNotice:(BOOL)open{
    EHLogInfo(@"shake open? %d",open);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithBool:open] forKey:kEHNoticeKey];
    [userDefaults synchronize];
}

/**
 *  震动
 */
- (void)updateShakeNotice:(BOOL)open{
    EHLogInfo(@"shake open? %d",open);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithBool:open] forKey:kEHShakeNoticeKey];
    [userDefaults synchronize];
}

/**
 *  声音
 */
- (void)updateVoiceNotice:(BOOL)open{
    EHLogInfo(@"voice open? %d",open);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithBool:open] forKey:kEHVoiceNoticeKey];
    [userDefaults synchronize];
}

#pragma mark - Getters And Setters
- (void)initTableView{
    _tableView = [[GroupedTableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStyleGrouped];
    _tableView.rowHeight = kCellHeight;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    self.view.backgroundColor = _tableView.backgroundColor;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    
    return;
}
- (EHSwitch *)switchWithTag:(NSInteger)tag{
    EHSwitch *swit = [[EHSwitch alloc]initWithFrame:CGRectMake(CGRectGetWidth(_tableView.frame) - 12 - 50, 12.5, 50, 25)];
    EHLogInfo(@"_sliderStatueArray.tag = %@",_sliderStatueArray[tag]);
    swit.on = [_sliderStatueArray[tag] boolValue];
    swit.tag = kSwitchTag + tag;
    WEAKSELF
    swit.switchChangedBlock = ^(BOOL on){
    STRONGSELF
        [strongSelf switchChanged:on];
    };
    return swit;
}
- (UIButton *)buttonWithTag:(NSInteger)tag{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(_tableView.frame) - 12- 44 + 11, 0, 44, 44)];
    button.imageEdgeInsets = UIEdgeInsetsMake(11, 11, 11, 11);
    button.tag = kSwitchTag + tag;
    [button addTarget:self action:@selector(ButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    if ([_sliderStatueArray[tag] boolValue]) {
        [button setImage:[UIImage imageNamed:@"public_radiobox_set_on"] forState:UIControlStateNormal];
    }else{
        [button setImage:[UIImage imageNamed:@"public_radiobox_set_off"] forState:UIControlStateNormal];
    }
    return button;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
