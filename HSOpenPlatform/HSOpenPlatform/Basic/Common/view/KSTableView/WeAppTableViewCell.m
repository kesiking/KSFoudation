//
//  WeAppTableViewCell.m
//  basicFoundation
//
//  Created by 逸行 on 15-5-1.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "WeAppTableViewCell.h"

@interface WeAppTableViewCell ()

@property (nonatomic, assign) CGRect      cellViewFrame;

@end

@implementation WeAppTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(id)createCell {
    id cellObj = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self reuseIdentifier]];
    if (cellObj) {
        [(WeAppTableViewCell*)cellObj setupCellView];
        return cellObj;
    }
    return nil;
}

+(NSString*)reuseIdentifier{
    return @"KSTableViewCellReUserId";
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

-(void)layoutSubviews{
    [super layoutSubviews];
    if (!CGRectEqualToRect(self.cellView.frame, self.cellViewFrame)) {
        [self.cellView setFrame:self.cellViewFrame];
    }
}

-(KSViewCell *)cellView{
    if (_cellView == nil) {
        if (self.viewCellClass && [self.viewCellClass isSubclassOfClass:[KSViewCell class]]) {
            if (!CGRectEqualToRect(CGRectZero, self.cellViewFrame)) {
                _cellView = [[self.viewCellClass alloc] initWithFrame:self.cellViewFrame];
            }else{
                _cellView = [[self.viewCellClass alloc] initWithFrame:self.bounds];
            }
        }else{
            if (!CGRectEqualToRect(CGRectZero, self.cellViewFrame)) {
                _cellView = [[KSViewCell alloc] initWithFrame:self.cellViewFrame];
            }else{
                _cellView = [[KSViewCell alloc] initWithFrame:self.bounds];
            }
        }
        _cellView.scrollViewCtl = self.scrollViewCtl;
        _cellView.scrollViewControllerContext = self.scrollViewCtl.scrollViewControllerContext;
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
    if (self.cellView && self.cellView.superview == nil) {
        [self addSubview:self.cellView];
    }else if(self.cellView && self.cellView.superview != self){
        [self.cellView removeFromSuperview];
        [self addSubview:self.cellView];
    }
}

- (void)refreshCellImagesWithComponentItem:(WeAppComponentBaseItem *)componentItem extroParams:(id)extroParams{
    [self.cellView refreshCellImagesWithComponentItem:componentItem extroParams:extroParams];
}

-(void)didSelectItemWithComponentItem:(WeAppComponentBaseItem *)componentItem extroParams:(id)extroParams{
    [self.cellView didSelectCellWithCellView:self componentItem:componentItem extroParams:extroParams];
    [KSTouchEvent touchWithView:self.cellView eventAttributes:@{@"indexPath":self.cellView.indexPath?:@""}];
}

-(void)configDeleteCellAtIndexPath:(NSIndexPath *)indexPath componentItem:(WeAppComponentBaseItem *)componentItem extroParams:(id)extroParams{
    [self.cellView configDeleteCellWithCellView:self atIndexPath:indexPath componentItem:componentItem extroParams:extroParams];
}

-(void)dealloc{
    _cellView = nil;
}

@end
