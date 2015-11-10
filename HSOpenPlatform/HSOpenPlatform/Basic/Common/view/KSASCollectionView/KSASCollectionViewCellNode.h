//
//  KSASCollectionViewCellNode.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/10.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "KSViewCellNode.h"

@interface KSASCollectionViewCellNode : ASCellNode<KSViewCellProtocol>

+(NSString*)reuseIdentifier;

+(id)createCell;

@property (nonatomic, strong) Class                viewCellClass;

@property (nonatomic, strong) KSViewCellNode*      cellView;

@property (nonatomic, weak)   KSScrollViewServiceController* scrollViewCtl;

@end
