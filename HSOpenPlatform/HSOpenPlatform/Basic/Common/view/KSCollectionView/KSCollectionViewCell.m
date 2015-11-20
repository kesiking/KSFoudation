//
//  WeAppCollectionViewCell.m
//  WeAppSDK
//
//  Created by 逸行 on 14-10-31.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import "KSCollectionViewCell.h"

@interface KSCollectionViewCell ()

@end

@implementation KSCollectionViewCell

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        [self setupCellView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCellView];
    }
    return self;
}

-(void)awakeFromNib{
    [self setupCellView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected];
    // Configure the view for the selected state
}

+(id)createCell {
    id cellObj = [[KSCollectionViewCell alloc] init];
    if (cellObj) {
        [cellObj setupCellView];
        return cellObj;
    }
    return nil;
}

+(NSString*)reuseIdentifier{
    return @"KSCollectionViewCell";
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

-(KSViewCell *)cellView{
    if (_cellView == nil) {
        if (self.viewCellClass && [self.viewCellClass isSubclassOfClass:[KSViewCell class]]) {
            _cellView = [[self.viewCellClass alloc] initWithFrame:self.bounds];
        }else{
            _cellView = [[KSViewCell alloc] initWithFrame:self.bounds];
        }
        _cellView.scrollViewCtl = self.scrollViewCtl;
        _cellView.scrollViewControllerContext = self.scrollViewCtl.scrollViewControllerContext;
    }
    return _cellView;
}

- (void)configCellWithFrame:(CGRect)rect componentItem:(WeAppComponentBaseItem *)componentItem extroParams:(id)extroParams{
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
