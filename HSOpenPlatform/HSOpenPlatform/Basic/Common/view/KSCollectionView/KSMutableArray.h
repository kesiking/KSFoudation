//
//  KSMutableArray.h
//  eHome
//
//  Created by 孟希羲 on 16/1/12.
//  Copyright © 2016年 com.cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define KSCollectionUserMutableArrayClass

#ifdef KSCollectionUserMutableArrayClass
    #define KSCollectionMutableArrayClass KSMutableArray
#else
    #define KSCollectionMutableArrayClass NSMutableArray
#endif

@interface KSMutableArray : WeAppItemList

@end
