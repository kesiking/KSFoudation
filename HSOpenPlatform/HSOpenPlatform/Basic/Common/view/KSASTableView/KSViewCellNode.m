//
//  KSViewCellNode.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/9.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//
#ifdef USE_AsyncDisplayKit

#import "KSViewCellNode.h"

@implementation KSViewCellNode

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.frame = frame;
        [self setupView];
    }
    return self;
}

-(void)setupView{
    self.shouldRasterizeDescendants = [self shouldViewCellNodeRasterizeDescendants];
}

- (BOOL)shouldViewCellNodeRasterizeDescendants{
    return NO;
}

-(void)resetIfImageUrlEqualToNetworkImageNodeWithASNetworkImageNode:(ASNetworkImageNode*)networkImageNode imageUrl:(NSString*)imageUrl{
    if (networkImageNode == nil) {
        return;
    }
    if ((networkImageNode.image == nil || networkImageNode.image == networkImageNode.defaultImage) && (networkImageNode.URL.absoluteString == imageUrl || [networkImageNode.URL.absoluteString isEqualToString:imageUrl])) {
        [networkImageNode setURL:nil];
    }
}

// perform expensive sizing operations on a background thread
- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize
{
    CGSize viewCellSize = CGSizeMake(SCREEN_WIDTH, 0);
    // size the cellView
    if (self.indexPath && self.scrollViewCtl && self.scrollViewCtl.dataSourceRead) {
        KSCellModelInfoItem* cellModelInfoItem = [self.scrollViewCtl.dataSourceRead getComponentModelInfoItemWithIndex:[self.indexPath row]];
        viewCellSize = cellModelInfoItem.frame.size;
    }else if (self.scrollViewCtl) {
        viewCellSize = CGSizeMake(self.scrollViewCtl.scrollView.frame.size.width, 0);
    }
    // make sure everything fits
    return viewCellSize;
}

-(void)layout{
    [self setFrame:(CGRect){CGPointZero, self.calculatedSize}];
}

// 对于girdCell等不能变高的重定向为WeAppRefreshDataModelType_All
- (BOOL)checkCellLegalWithWithCellView:(id<KSViewCellProtocol>)cell componentItem:(WeAppComponentBaseItem *)componentItem{
    if (cell == nil) {
        return NO;
    }
    
    if (![cell conformsToProtocol:@protocol(KSViewCellProtocol)]) {
        return NO;
    }
    return YES;
}

- (void)configCellWithCellView:(id<KSViewCellProtocol>)cell Frame:(CGRect)rect componentItem:(WeAppComponentBaseItem *)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    if ([extroParams isKindOfClass:[KSCellModelInfoItem class]]) {
        self.indexPath = extroParams.cellIndexPath;
    }
}

- (void)refreshCellImagesWithComponentItem:(WeAppComponentBaseItem *)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    
}

- (void)didSelectCellWithCellView:(id<KSViewCellProtocol>)cell componentItem:(WeAppComponentBaseItem *)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    
}

- (void)configDeleteCellWithCellView:(id<KSViewCellProtocol>)cell atIndexPath:(NSIndexPath*)indexPath componentItem:(WeAppComponentBaseItem *)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    
}

-(void)dealloc{
    
}

@end

#endif
