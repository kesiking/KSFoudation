//
//  UIImageView+KSWebCache.m
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/27.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "UIImageView+KSWebCache.h"
#import "objc/runtime.h"
#import "UIView+WebCacheOperation.h"
#import "KSImageListCache.h"

static char imageURLKey;

@implementation UIImageView (KSWebCache)

- (void)ks_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder didDownLoadBlock:(SDWebImageDidDownLoadCompletionBlock)downLoadBlock completed:(SDWebImageCompletionBlock)completedBlock{
    [self ks_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil didDownLoadBlock:downLoadBlock completed:completedBlock];
}

- (void)ks_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock didDownLoadBlock:(SDWebImageDidDownLoadCompletionBlock)downLoadBlock completed:(SDWebImageCompletionBlock)completedBlock{
    static dispatch_queue_t ioQueue = nil;
    if (ioQueue == nil) {
        ioQueue = dispatch_queue_create("com.hackemist.ksimageCache.SDWebImageCache", DISPATCH_QUEUE_SERIAL);
    }
    [self sd_cancelCurrentImageLoad];
    objc_setAssociatedObject(self, &imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (!(options & SDWebImageDelayPlaceholder)) {
        self.image = placeholder;
    }
    
    if (url) {
        __weak UIImageView *wself = self;

        UIImage* image = [[KSImageListCache sharedImageCache] imageFromMemoryCacheForKey:url.absoluteString];
        if (image) {
            dispatch_main_sync_safe(^{
                if (!wself) return;
                wself.image = image;
                [wself setNeedsLayout];
                if (completedBlock) {
                    completedBlock(image, nil, SDImageCacheTypeMemory, url);
                }
            });
            
            return;
        }
        
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            __block UIImage* imageBlock = image;
            dispatch_async(ioQueue, ^{
#ifdef DEBUG
                EHLogInfo(@"------> thread in ioqueue 1  befor downLoadBlock");
#endif
                if (downLoadBlock) {
                    imageBlock = downLoadBlock(imageBlock, error, cacheType, url);
                }
#ifdef DEBUG
                EHLogInfo(@"------> thread in ioqueue 2  after downLoadBlock");
#endif
                dispatch_main_sync_safe(^{
                    NSLog(@"------> thread in main 3  befor completedBlock");
                    if (!wself) return;
                    if (imageBlock) {
                        wself.image = imageBlock;
                        [wself setNeedsLayout];
                        [[KSImageListCache sharedImageCache] storeImage:imageBlock forKey:url.absoluteString];
                    } else {
                        if ((options & SDWebImageDelayPlaceholder)) {
                            wself.image = placeholder;
                            [wself setNeedsLayout];
                        }
                    }

                    if (completedBlock && finished) {
                        completedBlock(imageBlock, error, cacheType, url);
                    }
#ifdef DEBUG
                    EHLogInfo(@"------> thread in main 4  after completedBlock");
#endif
                });
            });
        }];
        [self sd_setImageLoadOperation:operation forKey:@"UIImageViewImageLoad"];
    } else {
        dispatch_main_async_safe(^{
            NSError *error = [NSError errorWithDomain:@"SDWebImageErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completedBlock) {
                completedBlock(nil, error, SDImageCacheTypeNone, url);
            }
        });
    }
}

@end
