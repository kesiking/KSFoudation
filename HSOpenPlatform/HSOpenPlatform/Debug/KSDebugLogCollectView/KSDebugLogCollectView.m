//
//  KSDebugLogCollectView.m
//  KSNewPrograme
//
//  Created by 孟希羲 on 15/12/9.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "KSDebugLogCollectView.h"
#import "KSDebugOperationView.h"
#import "KSDebugDataCache.h"
#import "KSDebugUtils.h"
#import <QuickLook/QuickLook.h>

@interface KSDebugLogCollectView()<UITableViewDelegate, UITableViewDataSource, QLPreviewControllerDataSource,QLPreviewControllerDelegate,UIDocumentInteractionControllerDelegate>

@property(nonatomic, strong) UILabel                         *infoLabel;
@property(nonatomic, strong) UIButton                        *clearBtn;
@property(nonatomic, strong) UITableView                     *readTable;

@property(nonatomic, strong) NSMutableArray                  *dirArray;

@property(nonatomic, strong) UIDocumentInteractionController *docInteractionController;
@property(nonatomic, strong) NSString                        *diskCachePath;

@property(nonatomic, assign) NSUInteger                       fileIndex;

@end

@implementation KSDebugLogCollectView

+(void)load{
    NSMutableArray* array = [KSDebugOperationView getDebugViews];
    [array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"日志获取",@"title",NSStringFromClass([self class]), @"className", nil]];
}

-(void)setupView{
    [super setupView];
    [self initCustomView];
    [self initDirection];
}

-(void)initCustomView{
    [self.infoLabel setText:@"日志获取"];
    [self.clearBtn setOpaque:YES];
    
    [self.closeButton setFrame:CGRectMake(self.readTable.frame.origin.x, CGRectGetMaxY(self.readTable.frame) + 2, CGRectGetWidth(self.readTable.frame), 40)];
    [self.closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [self.closeButton setBackgroundColor:[UIColor blackColor]];
    [self.closeButton setHidden:NO];
    
    self.needCancelBackgroundAction = YES;
    self.hidden = YES;
}

-(void)initDirection{
    _dirArray = [NSMutableArray array];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    _diskCachePath = [paths[0] stringByAppendingPathComponent:@"KSDebugLogCollectFile"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:_diskCachePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:_diskCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    [self moveFileDataToKSDebugLogCollectFilePath];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 懒加载
-(UILabel *)infoLabel{
    if (_infoLabel == nil) {
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, self.frame.size.width - 30 * 2, 40)];
        [_infoLabel setBackgroundColor:[UIColor blackColor]];
        [_infoLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [_infoLabel setTextColor:[UIColor whiteColor]];
        _infoLabel.layer.masksToBounds = YES;
        _infoLabel.layer.cornerRadius = 10;
        [_infoLabel setTextAlignment:NSTextAlignmentCenter];
        [_infoLabel setText:@"debug"];
        [self addSubview:_infoLabel];
    }
    return _infoLabel;
}

- (UIButton *)clearBtn {
    if (!_clearBtn) {
        _clearBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.infoLabel.frame.origin.x, self.infoLabel.frame.origin.y, 40, self.infoLabel.frame.size.height)];
        [_clearBtn setTitle:@"清除" forState:UIControlStateNormal];
        [_clearBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _clearBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_clearBtn addTarget:self action:@selector(clearBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_clearBtn];
    }
    return _clearBtn;
}


-(UITableView*)readTable{
    if (_readTable == nil) {
        _readTable = [[UITableView alloc] initWithFrame:CGRectMake(self.infoLabel.frame.origin.x, CGRectGetMaxY(self.infoLabel.frame) + 2, self.infoLabel.frame.size.width, self.frame.size.height - 20 * 2 - 40 * 2) style:UITableViewStylePlain];
        _readTable.layer.masksToBounds = YES;
        _readTable.layer.cornerRadius = 10;
        _readTable.dataSource = self;
        _readTable.delegate = self;
        _readTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        _readTable.rowHeight = 80;
        
        [self addSubview:_readTable];
    }
    return _readTable;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark public method
-(void)setDebugEnviromeng:(KSDebugEnviroment *)debugEnviromeng{
    [super setDebugEnviromeng:debugEnviromeng];
    [self moveFileDataToKSDebugLogCollectFilePath];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark private method
-(void)moveFileDataToKSDebugLogCollectFilePath{
    [self.dirArray removeAllObjects];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    NSArray* fileDirectorPathArray = [self getFileDirectorPathArray];
    for (id fileDirector in fileDirectorPathArray) {
        NSString* fileDirectorPath = nil;
        NSString* fileType = nil;
        if ([fileDirector isKindOfClass:[NSString class]]) {
            fileDirectorPath = fileDirector;
        }else if ([fileDirector isKindOfClass:[NSDictionary class]] && [(NSDictionary*)fileDirector objectForKey:@"filePath"]){
            fileDirectorPath = [(NSDictionary*)fileDirector objectForKey:@"filePath"];
            fileType = [(NSDictionary*)fileDirector objectForKey:@"fileType"];
        }else{
            continue;
        }
        NSError* error = nil;
        NSArray *documentFileList = [fileManager contentsOfDirectoryAtPath:fileDirectorPath error:&error];
        
        for (NSString *file in documentFileList)
        {
            NSString *path = [fileDirectorPath stringByAppendingPathComponent:file];
            if ([file rangeOfString:@"."].location == NSNotFound && fileType) {
                NSString *newPath = [[self.diskCachePath stringByAppendingPathComponent:file] stringByAppendingFormat:@".%@",fileType];
                if (![fileManager fileExistsAtPath:newPath] && [fileManager copyItemAtPath:path toPath:newPath error:NULL]) {
                    NSLog(@"----> copy successful");
                }
                path = newPath;
            }
            [self.dirArray addObject:path];
        }
    }
}

-(void)removeFileDirector{
    [self.dirArray removeAllObjects];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    NSArray* fileDirectorPathArray = [self getFileDirectorPathArray];
    for (id fileDirector in fileDirectorPathArray) {
        NSString* fileDirectorPath = nil;
        NSString* fileType = nil;
        if ([fileDirector isKindOfClass:[NSString class]]) {
            fileDirectorPath = fileDirector;
        }else if ([fileDirector isKindOfClass:[NSDictionary class]] && [(NSDictionary*)fileDirector objectForKey:@"filePath"]){
            fileDirectorPath = [(NSDictionary*)fileDirector objectForKey:@"filePath"];
            fileType = [(NSDictionary*)fileDirector objectForKey:@"fileType"];
        }else{
            continue;
        }
        NSError* error = nil;
        NSArray *documentFileList = [fileManager contentsOfDirectoryAtPath:fileDirectorPath error:&error];
        
        for (NSString *file in documentFileList)
        {
            NSString *path = [fileDirectorPath stringByAppendingPathComponent:file];
            if ([fileManager fileExistsAtPath:path] && [fileManager removeItemAtPath:path error:NULL]) {
                NSLog(@"----> remove successful");
            }
        }
    }
    
    if ([fileManager fileExistsAtPath:self.diskCachePath]) {
        NSError* error = nil;
        NSArray *documentFileList = [fileManager contentsOfDirectoryAtPath:self.diskCachePath  error:&error];
        for (NSString *file in documentFileList)
        {
            NSString *path = [self.diskCachePath stringByAppendingPathComponent:file];
            if ([fileManager fileExistsAtPath:path] && [fileManager removeItemAtPath:path error:NULL]) {
                NSLog(@"----> remove successful");
            }
        }
    }
    
    [self.readTable reloadData];
}

-(NSArray*)getFileDirectorPathArray{
    NSMutableArray* fileDirectorPathArray = [NSMutableArray new];
    NSString* userTrackDiskCachePath = [[KSDebugDataCache sharedAudioDataCache] valueForKey:@"diskCachePath"];
    if (userTrackDiskCachePath) {
        [fileDirectorPathArray addObject:userTrackDiskCachePath];
    }
    if (self.debugEnviromeng.filePathArray) {
        [fileDirectorPathArray addObjectsFromArray:self.debugEnviromeng.filePathArray];
    }
    return fileDirectorPathArray;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark gesture action method
- (void)handleTapPress:(UILongPressGestureRecognizer *)tapPressGesture
{
    if (tapPressGesture.state == UIGestureRecognizerStateEnded)
    {
        NSIndexPath *cellIndexPath = [self.readTable indexPathForRowAtPoint:[tapPressGesture locationInView:self.readTable]];
        
        if (cellIndexPath.row >= [self.dirArray count]) {
            return;
        }
        
        NSString *path = [self.dirArray objectAtIndex:cellIndexPath.row];
        self.docInteractionController.URL = [NSURL fileURLWithPath:path];
        
        [self.docInteractionController presentOptionsMenuFromRect:[KSDebugUtils getCurrentAppearedViewController].view.frame inView:[KSDebugUtils getCurrentAppearedViewController].view animated:YES];
    }
}

- (void)clearBtnClick {
    [self removeFileDirector];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 开始 结束 method
-(void)startDebug{
    [super startDebug];
    self.hidden = NO;
    
    [self moveFileDataToKSDebugLogCollectFilePath];
    
    [self.debugViewReference addSubview:self];
    [self.readTable reloadData];
    [self bringSubviewToFront:self.closeButton];
}

-(void)endDebug{
    [super endDebug];
    self.hidden = YES;
    [self removeFromSuperview];
    [[KSDebugUtils getCurrentAppearedViewController] dismissViewControllerAnimated:YES completion:nil];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark tableView delegate and dataSource method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dirArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *debugLogCollectionViewCellName = @"KSDebugLogCollectionViewCellName";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:debugLogCollectionViewCellName];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:debugLogCollectionViewCellName];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = KSDebugRGB(0x33, 0x33, 0x33);
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.numberOfLines = 2;
        cell.detailTextLabel.textColor = KSDebugRGB(0x99, 0x99, 0x99);
        cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
        cell.detailTextLabel.numberOfLines = 2;
        UITapGestureRecognizer *longPressGesture =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapPress:)];
        [cell.imageView addGestureRecognizer:longPressGesture];
        cell.imageView.userInteractionEnabled = YES;    // this is by default NO, so we need to turn it on
    }
    
    if (indexPath.row >= [self.dirArray count]) {
        return cell;
    }
    
    NSString* path = [self.dirArray objectAtIndex:indexPath.row];
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    NSInteger fileSize = [[fileAttributes objectForKey:NSFileSize] intValue];
    NSString* fileCreationDate = fileAttributes[@"NSFileCreationDate"];
    NSString *fileSizeStr = [NSByteCountFormatter stringFromByteCount:fileSize countStyle:NSByteCountFormatterCountStyleFile];
    
    [self setupDocumentControllerWithURL:[NSURL fileURLWithPath:path]];

    NSArray* pathComponents = [[NSFileManager defaultManager] componentsToDisplayForPath:path];
    NSString* pathComponent = [pathComponents lastObject];
    
    cell.imageView.image = [self.docInteractionController.icons count] > 0 ? [self.docInteractionController.icons lastObject] : nil;
    cell.textLabel.text = pathComponent;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"createTime:%@, fileSize:%@, fileType:%@",fileCreationDate, fileSizeStr, self.docInteractionController.UTI];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QLPreviewController *previewController = [[QLPreviewController alloc] init];
    previewController.dataSource = self;
    previewController.delegate = self;
    
    // start previewing the document at the current section index
    previewController.currentPreviewItemIndex = indexPath.row;
    [[KSDebugUtils getCurrentAppearedViewController] presentViewController:previewController animated:YES completion:nil];
}

- (void)setupDocumentControllerWithURL:(NSURL *)url
{
    if (self.docInteractionController == nil)
    {
        self.docInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
        self.docInteractionController.delegate = self;
    }
    else
    {
        self.docInteractionController.URL = url;
    }
}

#pragma mark - UIDocumentInteractionControllerDelegate

- (NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)interactionController
{
    return [KSDebugUtils getCurrentAppearedViewController];
}

- (void)documentInteractionControllerWillPresentOptionsMenu:(UIDocumentInteractionController *)controller{
    self.hidden = YES;
}

- (void)documentInteractionControllerDidDismissOptionsMenu:(UIDocumentInteractionController *)controller{
    self.hidden = NO;
}

- (BOOL)documentInteractionController:(UIDocumentInteractionController *)controller canPerformAction:(SEL)action NS_DEPRECATED_IOS(3_2, 6_0){
    return YES;
}



#pragma mark - QLPreviewControllerDataSource

// Returns the number of items that the preview controller should preview
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController
{
    return [self.dirArray count];
}

- (BOOL)previewController:(QLPreviewController *)controller shouldOpenURL:(NSURL *)url forPreviewItem:(id <QLPreviewItem>)item{
    return YES;
}

- (void)previewControllerWillDismiss:(QLPreviewController *)controller
{
    // if the preview dismissed (done button touched), use this method to post-process previews
    self.hidden = NO;
}

// returns the item that the preview controller should preview
- (id)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx
{
    self.hidden = YES;

    [previewController.tabBarController.tabBar setTintColor:[UIColor blackColor]];
    [[previewController navigationController].navigationBar setTintColor: [UIColor blackColor]];
    
    self.fileIndex = idx;
    
    NSString *path = [self.dirArray objectAtIndex:idx];
    
    return [NSURL fileURLWithPath:path];
}

@end