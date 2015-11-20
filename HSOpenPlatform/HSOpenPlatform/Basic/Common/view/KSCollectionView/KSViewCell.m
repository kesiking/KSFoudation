//
//  KSViewCell.m
//  basicFoundation
//
//  Created by 逸行 on 15-4-24.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSViewCell.h"

@implementation KSViewCell

+(id)createView{
    if (![self isViewCellInstanceFromNib]) {
        return nil;
    }
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    if ([nibContents count] > 0) {
        id object = [nibContents objectAtIndex:0];
        if (object && [object isKindOfClass:[self class]])
        {
            return object;
        }
    }
    return nil;
}

+ (BOOL)isViewCellInstanceFromNib{
    return NO;
}

-(instancetype)init
{
    if ([[self class] isViewCellInstanceFromNib]) {
        self = [[self class] createView];
    }else{
        self = [super init];
    }
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([[self class] isViewCellInstanceFromNib]) {
        self = [[self class] createView];
        self.frame = frame;
    }else{
        self = [super initWithFrame:frame];
    }
    if (self) {
        [self setupView];
    }
    return self;
}

// override, do not need super class touch event log
-(BOOL)needTouchEventLog{
    return NO;
}

// 对于girdCell等不能变高的重定向为WeAppRefreshDataModelType_All
- (BOOL)checkCellLegalWithWithCellView:(id<KSViewCellProtocol>)cell componentItem:(WeAppComponentBaseItem *)componentItem{
    if (cell == nil || ![cell isKindOfClass:[UIView class]]) {
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
