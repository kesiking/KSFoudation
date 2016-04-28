//
//  HSServicLocationCalloutView.h
//  HSOpenPlatform
//
//  Created by xtq on 15/10/19.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "KSView.h"

#define kCalloutWidth       262
#define kCalloutHeight      64

typedef void(^NavigateButtonClickBlock)(void);

@interface HSServicLocationCalloutView : KSView

@property (nonatomic, strong)NSString *name;

@property (nonatomic, assign)NSInteger distance;

@property (nonatomic, strong)NSString *address;

@property (nonatomic, strong)NavigateButtonClickBlock navigateButtonClickBlock;

@end
