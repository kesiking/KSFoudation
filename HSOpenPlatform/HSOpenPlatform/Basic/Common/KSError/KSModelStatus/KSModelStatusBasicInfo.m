//
//  TBModelStatusInfoB.m
//  Taobao2013
//
//  Created by 香象 on 28/2/13.
//  Copyright (c) 2013 Taobao.com. All rights reserved.
//

#import "KSModelStatusBasicInfo.h"

@implementation KSModelStatusBasicInfo

- (NSString *)titleForEmpty {
    if (self.titleForEmptyBlock) {
        return self.titleForEmptyBlock();
    }
    return [super titleForEmpty];
}

- (NSString *)subTitleForEmpty {
    if (self.subTitleForEmptyBlock) {
        return self.subTitleForEmptyBlock();
    }
    return [super subTitleForEmpty];
}

- (NSString *)actionButtonTitleForEmpty {
    if (self.actionButtonTitleForEmptyBlock) {
        return self.actionButtonTitleForEmptyBlock();
    }
    return [super actionButtonTitleForEmpty];
}

- (NSString *)titleForError:(NSError *)error {
    if (self.titleForErrorBlock) {
        return self.titleForErrorBlock(error);
    }
    return [super titleForError:error];
}

- (NSString *)subTitleForError:(NSError *)error {
    if (self.subTitleForErrorBlock) {
        return self.subTitleForErrorBlock(error);
    }
    return [super subTitleForError:error];
}

- (NSString *)actionButtonTitleForError:(NSError *)error {
    if (self.actionButtonTitleForErrorBlock) {
        return self.actionButtonTitleForErrorBlock(error);
    }
    return [super actionButtonTitleForError:error];
}

- (UIImage *)imageForEmpty {
    if (self.imageForEmptyBlock) {
        return self.imageForEmptyBlock();
    }
    return [super imageForEmpty];
}

- (UIImage *)imageForError:(NSError *)error {
    if (self.imageForErrorBlock) {
        return self.imageForErrorBlock(error);
    }
    return [super imageForError:error];
}

@end
