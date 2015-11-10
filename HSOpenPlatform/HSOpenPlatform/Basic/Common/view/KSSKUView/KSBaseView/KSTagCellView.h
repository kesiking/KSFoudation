//
//  KSTagCellView.h
//  basicFoundation
//
//  Created by 逸行 on 15-5-14.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSView.h"

@protocol KSTagListSelectProtocal <NSObject>

-(void)setSelected:(BOOL)selected;

@end

@interface KSTagCellView : KSView<KSTagListSelectProtocal>

@end
