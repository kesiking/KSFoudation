//
//  KSASTableViewCellNode.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/9.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//
#ifdef USE_AsyncDisplayKit

#import "KSASTableViewCellNode.h"
#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>

@interface KSASTableViewCellNode ()

@property (nonatomic, assign) CGRect      cellViewFrame;

@end

@implementation KSASTableViewCellNode

+(id)createCell {
    id cellObj = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self reuseIdentifier]];
    if (cellObj) {
        [(KSASTableViewCellNode*)cellObj setupCellView];
        return cellObj;
    }
    return nil;
}

- (instancetype)init
{
    if (!(self = [super init]))
        return nil;
    [self setupCellView];
    return self;
}

+(NSString*)reuseIdentifier{
    return @"KSASTableViewCellNodeReUserId";
}

-(void)setViewCellClass:(Class)viewCellClass{
    if (_viewCellClass != viewCellClass) {
        _viewCellClass = viewCellClass;
    }
}

-(void)setScrollViewCtl:(KSScrollViewServiceController *)scrollViewCtl{
    if (scrollViewCtl != _scrollViewCtl) {
        _scrollViewCtl = scrollViewCtl;
        _cellView.scrollViewCtl = scrollViewCtl;
    }
}

-(void)setupCellView{
    
}

// perform expensive sizing operations on a background thread
- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize
{
    // size the cellView
    CGSize viewCellSize = [self.cellView measure:constrainedSize];
//    // make sure everything fits
    return CGSizeMake(self.cellViewFrame.size.width, viewCellSize.height);
}

// do as little work as possible in main-thread layout
- (void)layout
{
    // layout the image using its cached size
    CGSize viewCellSize = CGSizeMake(self.cellViewFrame.size.width, self.cellView.calculatedSize.height);
    self.cellView.frame = (CGRect){ CGPointZero, viewCellSize };
}

-(KSViewCellNode *)cellView{
    if (_cellView == nil) {
        if (self.viewCellClass && [self.viewCellClass isSubclassOfClass:[KSViewCellNode class]]) {
            if (!CGRectEqualToRect(CGRectZero, self.cellViewFrame)) {
                _cellView = [[self.viewCellClass alloc] initWithFrame:self.cellViewFrame];
            }else{
                _cellView = [[self.viewCellClass alloc] initWithFrame:self.bounds];
            }
        }else{
            if (!CGRectEqualToRect(CGRectZero, self.cellViewFrame)) {
                _cellView = [[KSViewCellNode alloc] initWithFrame:self.cellViewFrame];
            }else{
                _cellView = [[KSViewCellNode alloc] initWithFrame:self.bounds];
            }
        }
        _cellView.scrollViewCtl = self.scrollViewCtl;
    }
    return _cellView;
}

- (void)configCellWithFrame:(CGRect)rect componentItem:(WeAppComponentBaseItem *)componentItem extroParams:(id)extroParams{
    self.cellViewFrame = rect;
    if (![self.cellView checkCellLegalWithWithCellView:self componentItem:componentItem]) {
        return;
    }
    if (!CGRectEqualToRect(self.cellView.frame, rect)) {
        self.cellView.frame = rect;
    }
    if ([extroParams isKindOfClass:[KSCellModelInfoItem class]]) {
        self.cellView.indexPath = [(KSCellModelInfoItem*)extroParams cellIndexPath];
    }
    [self.cellView configCellWithCellView:self Frame:rect componentItem:componentItem extroParams:extroParams];
    if (self.cellView && self.cellView.supernode == nil) {
        [self addSubnode:self.cellView];
    }else if(self.cellView && self.cellView.supernode != self){
        [self.cellView removeFromSupernode];
        [self addSubnode:self.cellView];
    }
    [self invalidateCalculatedLayout];
}

- (void)refreshCellImagesWithComponentItem:(WeAppComponentBaseItem *)componentItem extroParams:(id)extroParams{
    [self.cellView refreshCellImagesWithComponentItem:componentItem extroParams:extroParams];
}

-(void)didSelectItemWithComponentItem:(WeAppComponentBaseItem *)componentItem extroParams:(id)extroParams{
    [self.cellView didSelectCellWithCellView:self componentItem:componentItem extroParams:extroParams];
    [KSTouchEvent touchWithView:self.cellView.view eventAttributes:@{@"indexPath":self.cellView.indexPath?:@""}];
}

-(void)configDeleteCellAtIndexPath:(NSIndexPath *)indexPath componentItem:(WeAppComponentBaseItem *)componentItem extroParams:(id)extroParams{
    [self.cellView configDeleteCellWithCellView:self atIndexPath:indexPath componentItem:componentItem extroParams:extroParams];
}

-(void)dealloc{
    _cellView = nil;
}

//- (id<ASLayoutable>)layoutSpecThatFits:(ASSizeRange)constrainedSize
//{
//    static const CGFloat kHorizontalPadding = 15.0f;
//    static const CGFloat kVerticalPadding = 11.0f;
//    UIEdgeInsets insets = UIEdgeInsetsMake(kVerticalPadding, kHorizontalPadding, kVerticalPadding, kHorizontalPadding);
//    return [ASInsetLayoutSpec newWithInsets:insets child:_textNode];
//}
//

@end

#endif
