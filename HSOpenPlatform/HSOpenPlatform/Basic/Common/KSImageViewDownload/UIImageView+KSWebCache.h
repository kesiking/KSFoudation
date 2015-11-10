//
//  UIImageView+KSWebCache.h
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/27.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UIImage *(^SDWebImageDidDownLoadCompletionBlock) (UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL);

@interface UIImageView (KSWebCache)

- (void)ks_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder didDownLoadBlock:(SDWebImageDidDownLoadCompletionBlock)downLoadBlock completed:(SDWebImageCompletionBlock)completedBlock;

@end
