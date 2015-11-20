//
//  HSMyMessageInfoCell.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/19.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSMyMessageInfoCell.h"
#import "HSMyMessageModel.h"
#import "HSMessageCellModelInfoItem.h"
#import "KSTableViewController.h"

@interface HSMyMessageInfoCell()<TTTAttributedLabelDelegate>

@property (nonatomic, assign) CGSize             messageInfoDescSize;
@property (nonatomic, strong) UIButton          *messageDeleteButton;


@end

@implementation HSMyMessageInfoCell

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - override method

+ (BOOL)isViewCellInstanceFromNib{
    return YES;
}

-(void)setupView{
    [super setupView];
    self.backgroundColor = EHBgcor1;
    self.ks_contentView.backgroundColor = self.backgroundColor;
    [self setupMessageBackgroundImageView];
    [self setupMessageInfoButton];
    [self setupMessageDeleteButton];
    [self setupMessageInfoLabel];
    [self setupMessageTimeLabel];
}

-(void)setupMessageBackgroundImageView{
    UIImage* message_list_info_background = [UIImage imageNamed:@"message_list_info_background"];
    message_list_info_background = [message_list_info_background resizableImageWithCapInsets:UIEdgeInsetsMake(message_list_info_background.size.height/(4*[UIScreen mainScreen].scale), message_list_info_background.size.width/(4*[UIScreen mainScreen].scale), message_list_info_background.size.height*3/(4*[UIScreen mainScreen].scale), message_list_info_background.size.width*3/(4*[UIScreen mainScreen].scale)) resizingMode:UIImageResizingModeStretch];
    [self.messageBackgroundImageView setImage:message_list_info_background];
}

-(void)setupMessageInfoButton{
    [self.messageCheckDetailInfoButton setTitleColor:EHCor3 forState:UIControlStateNormal];
    [self.messageInfoButton.titleLabel setFont:[UIFont systemFontOfSize:EHSiz2]];
    [self.messageInfoButton setTitleColor:EHCor6 forState:UIControlStateNormal];
    [self.messageInfoButton setBackgroundColor:RGB(0xf4, 0xf4, 0xf9)];
    [self.messageInfoButton addTarget:self action:@selector(messageInfoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self setupMessageInfoButtonLayerPath];
}

-(void)setupMessageDeleteButton{
    _messageDeleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [_messageDeleteButton setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 10)];
    _messageDeleteButton.userInteractionEnabled = NO;
    self.ks_deleteView = _messageDeleteButton;
}

-(void)setupMessageTimeLabel{
    self.messageTimeLabel.textColor = EHCor3;
    [self.messageTimeLabel setFont:[UIFont boldSystemFontOfSize:EHSiz6]];
}

-(void)setupMessageInfoLabel{
    self.messageInfoLabel.textColor = EHCor5;
    [self.messageInfoLabel setFont:[UIFont systemFontOfSize:EHSiz2]];
    self.messageInfoLabel.delegate = self;
    NSMutableDictionary *mutableLinkAttributes = [NSMutableDictionary dictionary];
    [mutableLinkAttributes setObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    if ([NSMutableParagraphStyle class]) {
        [mutableLinkAttributes setObject:EH_cor9 forKey:(NSString *)kCTForegroundColorAttributeName];
    } else {
        [mutableLinkAttributes setObject:(__bridge id)[EH_cor9 CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
    }
    self.messageInfoLabel.linkAttributes = mutableLinkAttributes;
}

-(void)dealloc{

}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - config button method
-(void)setupMessageInfoButtonLayerPath{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.messageInfoButton.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
    if ([self.messageInfoButton.layer.mask isKindOfClass:[CAShapeLayer class]]) {
        ((CAShapeLayer*)self.messageInfoButton.layer.mask).path = maskPath.CGPath;
    }else{
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.path = maskPath.CGPath;
        self.messageInfoButton.layer.mask = maskLayer;
    }
    self.messageInfoButton.layer.mask.frame = self.messageInfoButton.bounds;
    
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsMake((self.messageInfoButton.height - 15)/2, self.messageInfoButton.width - 20 - 15, (self.messageInfoButton.height - 15)/2, 20);
    if (!UIEdgeInsetsEqualToEdgeInsets(self.messageInfoButton.imageEdgeInsets, imageEdgeInsets)) {
        [self.messageInfoButton setImageEdgeInsets:imageEdgeInsets];
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - override method
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.messageInfoLabel setSize:self.messageInfoDescSize];
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self layoutIfNeeded];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - private method

// setup activityLabel
-(void)configCellLabelWithCellView:(id<KSViewCellProtocol>)cell Frame:(CGRect)rect componentItem:(HSMyMessageModel*)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    if (![extroParams isKindOfClass:[HSMessageCellModelInfoItem class]]) {
        return;
    }
    
    HSMessageCellModelInfoItem* messageInfoCellModelInfoItem = (HSMessageCellModelInfoItem*)extroParams;
    
    self.messageInfoLabel.text = [NSString stringWithFormat:@"%@",messageInfoCellModelInfoItem.messageLinkModel.messageInfo];

    if ([HSMessageExtModel isMessageLinkValidWithMessageExtModel:messageInfoCellModelInfoItem.messageLinkModel MessageInfo:self.messageInfoLabel.text]) {
        [self.messageInfoLabel addLinkToURL:[NSURL URLWithString:messageInfoCellModelInfoItem.messageLinkModel.messageInfoLinkUrl] withRange:messageInfoCellModelInfoItem.messageLinkModel.messageInfoLinkRange];
    }
    self.messageTimeLabel.text = [NSString stringWithFormat:@"%@",messageInfoCellModelInfoItem.messageTime];
    self.messageInfoDescSize = messageInfoCellModelInfoItem.messageInfoSize;
    [self.messageInfoLabel setSize:self.messageInfoDescSize];
}

-(void)configCellButtonWithCellView:(id<KSViewCellProtocol>)cell Frame:(CGRect)rect componentItem:(HSMyMessageModel*)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    if (![extroParams isKindOfClass:[HSMessageCellModelInfoItem class]]) {
        return;
    }
    
    HSMessageCellModelInfoItem* messageInfoCellModelInfoItem = (HSMessageCellModelInfoItem*)extroParams;
    if ([HSMessageExtModel shouldMessageInfoBtnShowWithMessageExtModel:messageInfoCellModelInfoItem.messageLinkModel]) {
        [self.messageInfoButton setTitle:messageInfoCellModelInfoItem.messageLinkModel.messageInfoBtnStr forState:UIControlStateNormal];
        self.messageInfoButton.hidden = NO;
        [self setupMessageInfoButtonLayerPath];
    }else{
        self.messageInfoButton.hidden = YES;
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - KSDeleteBtnViewCell override method
-(void)configCellDeleteViewWithCellView:(id<KSViewCellProtocol>)cell Frame:(CGRect)rect componentItem:(WeAppComponentBaseItem*)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    [super configCellDeleteViewWithCellView:cell Frame:rect componentItem:componentItem extroParams:extroParams];
}

-(void)setupDeleteViewStatus:(BOOL)isSelect{
    [self setupDeleteButtonStatus:isSelect];
}

-(void)setupDeleteButtonStatus:(BOOL)isSelect{
    if (isSelect) {
        [self.messageDeleteButton setImage:[UIImage imageNamed:@"radiobox_set_on"] forState:UIControlStateNormal];
    }else{
        [self.messageDeleteButton setImage:[UIImage imageNamed:@"radiobox_set_off02"] forState:UIControlStateNormal];
    }
}

-(CGRect)getCustomDeleteViewFrameWithFrame:(CGRect)frame{
    CGRect rect = self.messageBackgroundImageView.frame;
    frame.origin.y = rect.origin.y + (rect.size.height - frame.size.height)/2;
    return frame;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - messageInfoButtonClicked method
- (void)messageInfoButtonClicked:(id)sender{
    HSMyMessageModel* messageModel = nil;
    HSMessageCellModelInfoItem* messageInfoCellModelInfoItem = nil;
    if (self.indexPath != nil && self.indexPath.row < self.scrollViewCtl.dataSourceRead.count) {
        messageModel = (HSMyMessageModel*)[self.scrollViewCtl.dataSourceRead getComponentItemWithIndex:self.indexPath.row];
        messageInfoCellModelInfoItem = (HSMessageCellModelInfoItem*)[self.scrollViewCtl.dataSourceRead getComponentModelInfoItemWithIndex:self.indexPath.row];
    }
    TBOpenURLFromSourceAndParams(messageInfoCellModelInfoItem.messageLinkModel.messageInfoBtnUrl, self, messageInfoCellModelInfoItem.messageLinkModel.messageInfoLinkParams);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - KSViewCellProtocol method

- (void)configCellWithCellView:(id<KSViewCellProtocol>)cell Frame:(CGRect)rect componentItem:(WeAppComponentBaseItem *)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    [super configCellWithCellView:cell Frame:rect componentItem:componentItem extroParams:extroParams];
    
    if (![componentItem isKindOfClass:[HSMyMessageModel class]]) {
        return;
    }
    
    HSMyMessageModel* activityInfoModel = (HSMyMessageModel*)componentItem;
    [self configCellLabelWithCellView:cell Frame:rect componentItem:activityInfoModel extroParams:extroParams];
    [self configCellButtonWithCellView:cell Frame:rect componentItem:activityInfoModel extroParams:extroParams];
}

- (void)didSelectCellWithCellView:(id<KSViewCellProtocol>)cell componentItem:(WeAppComponentBaseItem *)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    if (componentItem && [componentItem isKindOfClass:[HSMyMessageModel class]]) {
        HSMyMessageModel* messageInfoModel = (HSMyMessageModel*)componentItem;
        NSDictionary* params = @{@"messageInfoModel":messageInfoModel};
        // to do : go to different view controller
    }
}

-(void)configDeleteCellWithCellView:(id<KSViewCellProtocol>)cell atIndexPath:(NSIndexPath *)indexPath componentItem:(WeAppComponentBaseItem *)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    [super configDeleteCellWithCellView:cell atIndexPath:indexPath componentItem:componentItem extroParams:extroParams];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - TTTAttributedLabelDelegate method 

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url{
    HSMyMessageModel* messageModel = nil;
    HSMessageCellModelInfoItem* messageInfoCellModelInfoItem = nil;
    if (self.indexPath != nil && self.indexPath.row < self.scrollViewCtl.dataSourceRead.count) {
        messageModel = (HSMyMessageModel*)[self.scrollViewCtl.dataSourceRead getComponentItemWithIndex:self.indexPath.row];
        messageInfoCellModelInfoItem = (HSMessageCellModelInfoItem*)[self.scrollViewCtl.dataSourceRead getComponentModelInfoItemWithIndex:self.indexPath.row];
    }
    TBOpenURLFromSourceAndParams(url.absoluteString, self, messageInfoCellModelInfoItem.messageLinkModel.messageInfoLinkParams);
}

@end
