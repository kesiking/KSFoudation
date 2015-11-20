//
//  KSDeleteBtnViewCell.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/26.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSDeleteBtnViewCell.h"

@interface KSDeleteBtnViewCell()

@property (nonatomic, assign) BOOL                 isEditModel;

@end

@implementation KSDeleteBtnViewCell

-(void)setupView{
    [super setupView];
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
}

-(void)didMoveToSuperview{
    [super didMoveToSuperview];
    UIView *newSuperview = self.ks_contentView != self ? self : self.superview;
    if (self.ks_deleteView && self.ks_deleteView.superview != newSuperview) {
        [self.ks_deleteView removeFromSuperview];
        [newSuperview addSubview:self.ks_deleteView];
        newSuperview.backgroundColor = self.backgroundColor;
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect rect = self.ks_deleteView.frame;
    rect.origin.x = CGRectGetMaxX(self.ks_deleteView.superview.bounds) - rect.size.width;
    rect.origin.y = CGRectGetMinY(self.ks_deleteView.superview.bounds) + (CGRectGetHeight(self.ks_deleteView.superview.bounds) - rect.size.height)/2;
    rect = [self getCustomDeleteViewFrameWithFrame:rect];
    if (!CGRectEqualToRect(self.ks_deleteView.frame, rect)){
        [self.ks_deleteView setFrame:rect];
    }
    if ([self needMoveViewCellOringeXForShowDeleteView]) {
        CGFloat originX = [self getOriginXWithEditModex:self.isEditModel];
        CGRect frame = CGRectMake(originX, self.ks_contentView.origin.y, self.ks_contentView.width, self.ks_contentView.height);
        if (!CGRectEqualToRect(self.ks_contentView.frame, frame)){
            [self.ks_contentView setFrame:CGRectMake(originX, self.ks_contentView.origin.y, self.ks_contentView.width, self.ks_contentView.height)];
        }
    }
}

-(void)setKs_deleteView:(UIView *)ks_deleteView{
    if (_ks_deleteView != ks_deleteView) {
        [_ks_deleteView removeFromSuperview];
        _ks_deleteView = ks_deleteView;
        UIView *newSuperview = self.ks_contentView != self ? self : self.superview;
        [newSuperview addSubview:_ks_deleteView];
    }
}

-(void)configCellDeleteViewWithCellView:(id<KSViewCellProtocol>)cell Frame:(CGRect)rect componentItem:(WeAppComponentBaseItem*)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    if (extroParams.configObject && [extroParams.configObject isKindOfClass:[KSCollectionViewConfigObject class]]) {
        KSCollectionViewConfigObject* configObject = extroParams.configObject;
        self.isEditModel = configObject.isEditModel;
        [self setupDeleteViewShowStyle:configObject.isEditModel withAnimation:YES];
        if (configObject.isEditModel) {
            self.ks_deleteView.hidden = NO;
            NSMutableArray* collectionDeleteItems = [self getCollectionDeleteItems];
            BOOL isSelect = extroParams.cellIndexPath && [collectionDeleteItems containsObject:extroParams.cellIndexPath];
            // 改变
            CGRect ks_deleteView_rect = [self getCustomDeleteViewFrameWithFrame:self.ks_deleteView.frame];
            if (!CGRectEqualToRect(self.ks_deleteView.frame, ks_deleteView_rect)){
                [self.ks_deleteView setFrame:ks_deleteView_rect];
            }
            [self setupDeleteViewStatus:isSelect];
            return;
        }
    }
    self.ks_deleteView.hidden = YES;
}

-(void)setupDeleteViewShowStyle:(BOOL)isEditModel withAnimation:(BOOL)animation{
    if (![self needMoveViewCellOringeXForShowDeleteView]) {
        return;
    }
    CGFloat originX = [self getOriginXWithEditModex:isEditModel];
    CGRect frame = CGRectMake(originX, self.origin.y, self.width, self.height);
    if (!CGRectEqualToRect(self.ks_contentView.frame, frame)) {
        if (animation) {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                [self.ks_contentView setFrame:CGRectMake(originX, self.ks_contentView.origin.y, self.ks_contentView.width, self.ks_contentView.height)];
            } completion:^(BOOL finished) {
            }];
        }else{
            [self.ks_contentView setFrame:CGRectMake(originX, self.ks_contentView.origin.y, self.ks_contentView.width, self.ks_contentView.height)];
        }
    }
}

-(CGFloat)getOriginXWithEditModex:(BOOL)isEditMode{
    return (CGFloat)(isEditMode ? 0 - self.ks_deleteView.width : 0);
}

-(CGRect)getCustomDeleteViewFrameWithFrame:(CGRect)frame{
    return frame;
}

-(BOOL)needMoveViewCellOringeXForShowDeleteView{
    return YES && self.ks_contentView != nil;
}

-(void)setupDeleteViewStatus:(BOOL)isSelect{
    
}

-(NSMutableArray*)getCollectionDeleteItems{
    NSMutableArray* collectionDeleteItems = nil;
    if ([self.scrollViewCtl isKindOfClass:[KSTableViewController class]]) {
        KSTableViewController* tableViewCtl = ((KSTableViewController*)self.scrollViewCtl);
        collectionDeleteItems = tableViewCtl.collectionDeleteItems;
    }else if ([self.scrollViewCtl isKindOfClass:[KSCollectionViewController class]]){
        KSTableViewController* collectionViewCtl = ((KSTableViewController*)self.scrollViewCtl);
        collectionDeleteItems = collectionViewCtl.collectionDeleteItems;
    }
    return collectionDeleteItems;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - KSViewCellProtocol method

- (void)configCellWithCellView:(id<KSViewCellProtocol>)cell Frame:(CGRect)rect componentItem:(WeAppComponentBaseItem *)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    [super configCellWithCellView:cell Frame:rect componentItem:componentItem extroParams:extroParams];
    [self configCellDeleteViewWithCellView:cell Frame:rect componentItem:componentItem extroParams:extroParams];
}

-(void)configDeleteCellWithCellView:(id<KSViewCellProtocol>)cell atIndexPath:(NSIndexPath *)indexPath componentItem:(WeAppComponentBaseItem *)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    NSMutableArray* collectionDeleteItems = [self getCollectionDeleteItems];
    if (![collectionDeleteItems containsObject:indexPath]) {
        [collectionDeleteItems addObject:indexPath];
        [self setupDeleteViewStatus:YES];
    }else{
        [self setupDeleteViewStatus:NO];

        [collectionDeleteItems removeObject:indexPath];
    }
}

@end
