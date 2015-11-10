//
//  GroupedTableView.m
//  GroupedTableView
//
//  Created by Benoit Layer on 28/02/14.
//  Copyright (c) 2014 Benoit Layer. All rights reserved.
//

#import "GroupedTableView.h"

typedef NS_ENUM(NSUInteger, EHCellType) {
    EHCellTypeSingleRow,
    EHCellTypeFirstRow,
    EHCellTypeLastRow,
    EHCellTypeMiddleRow
};

@implementation GroupedTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{

    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}

- (void)drawCellBorder:(UITableViewCell*)cell cellType:(EHCellType)celltype
{
    if (cell == nil)
        return;
    
    CGFloat cornerRadius = 5.f;
    cell.backgroundColor = UIColor.clearColor;
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGRect bounds = CGRectInset(cell.bounds, 1, 0);
    switch (celltype) {
        case EHCellTypeSingleRow:
        {
            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
        }
            break;
        case EHCellTypeFirstRow:
        {
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
        }
            break;
        case EHCellTypeLastRow:
        {
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
        }
            break;
        case EHCellTypeMiddleRow:
        {
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
        }
            break;
        default:
            break;
    }
    
    layer.path = pathRef;
    CFRelease(pathRef);
    layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
    layer.strokeColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8].CGColor;
    layer.lineWidth = 0.5;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:bounds];
    [backgroundView.layer insertSublayer:layer atIndex:0];
    backgroundView.backgroundColor = UIColor.clearColor;
    cell.backgroundView = backgroundView;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Apply our modification only on iOS7 and above
    //if (self.style == UITableViewStyleGrouped && IS_IOS7_AND_UP())
    {

        
        // For each section, we round the first and last cell
        NSInteger numberOfSections = 1;
        
        if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
            numberOfSections = [self.dataSource numberOfSectionsInTableView:self];
        }
        
        for (int i = 0 ; i < numberOfSections ; i++)
        {
            
            // Get first and last cell
            NSInteger numberOfRows = [self.dataSource tableView:self numberOfRowsInSection:i];
            UITableViewCell *topCell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
            UITableViewCell *bottomCell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:numberOfRows-1 inSection:i]];
            // If there is a single row, we round the cell by each corner
            if (topCell == bottomCell)
            {
                [self drawCellBorder:topCell cellType:EHCellTypeSingleRow];
            }
            else
            {
                [self drawCellBorder:topCell cellType:EHCellTypeFirstRow];
                [self drawCellBorder:bottomCell cellType:EHCellTypeLastRow];
                
            }
            for (int j = 1 ; j < numberOfRows-1 ; j++)
            {
                UITableViewCell *cell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
                [self drawCellBorder:cell cellType:EHCellTypeMiddleRow];
            }
        }
    }
}


@end
