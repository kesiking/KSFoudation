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
@property(nonatomic, strong) UITableView                     *readTable;
@property(nonatomic, strong) NSMutableArray                  *dirArray;
@property(nonatomic, strong) UIDocumentInteractionController *docInteractionController;
@property(nonatomic, strong) NSString                        *diskCachePath;

@end

@implementation KSDebugLogCollectView

#ifdef KSDebugToolsEnable
+(void)load{
    NSMutableArray* array = [KSDebugOperationView getDebugViews];
    [array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"日志获取",@"title",NSStringFromClass([self class]), @"className", nil]];
}
#endif

-(void)setupView{
    [super setupView];
    
    self.needCancelBackgroundAction = YES;
    self.hidden = YES;
    [self.closeButton setHidden:NO];
    [self.closeButton setFrame:CGRectMake(self.readTable.frame.origin.x, CGRectGetMaxY(self.readTable.frame) + 2, CGRectGetWidth(self.readTable.frame), 40)];
    self.closeButton.backgroundColor = [UIColor blackColor];
    [self.closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    
    [self.infoLabel setText:@"日志获取"];
    [self initDirection];
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

-(void)moveFileDataToKSDebugLogCollectFilePath{
    [self.dirArray removeAllObjects];

    NSFileManager* fileManager = [NSFileManager defaultManager];

    NSArray* fileDirectorPathArray = [self getFileDirectorPathArray];
    for (NSString* fileDirectorPath in fileDirectorPathArray) {
        NSError* error = nil;
        NSArray *documentFileList = [fileManager contentsOfDirectoryAtPath:fileDirectorPath error:&error];
        
        for (NSString *file in documentFileList)
        {
            NSString *path = [fileDirectorPath stringByAppendingPathComponent:file];
            if ([file rangeOfString:@"."].location == NSNotFound) {
                NSString *newPath = [[self.diskCachePath stringByAppendingPathComponent:file] stringByAppendingString:@".txt"];
                if (![fileManager fileExistsAtPath:newPath] && [fileManager copyItemAtPath:path toPath:newPath error:NULL]) {
                    NSLog(@"----> copy successful");
                }
                path = newPath;
            }
            [self.dirArray addObject:path];
        }
    }
}

-(NSArray*)getFileDirectorPathArray{
    NSMutableArray* fileDirectorPathArray = [NSMutableArray new];
    if (self.debugEnviromeng.filePathArray) {
        [fileDirectorPathArray addObjectsFromArray:self.debugEnviromeng.filePathArray];
    }
    NSString* userTrackDiskCachePath = [[KSDebugDataCache sharedAudioDataCache] valueForKey:@"diskCachePath"];
    if (userTrackDiskCachePath) {
        [fileDirectorPathArray addObject:userTrackDiskCachePath];
    }
    return fileDirectorPathArray;
}

-(UITableView*)readTable{
    if (_readTable == nil) {
        _readTable = [[UITableView alloc] initWithFrame:CGRectMake(self.infoLabel.frame.origin.x, CGRectGetMaxY(self.infoLabel.frame) + 2, self.infoLabel.frame.size.width, self.frame.size.height - 20 * 2 - 40 * 2) style:UITableViewStylePlain];
        _readTable.layer.masksToBounds = YES;
        _readTable.layer.cornerRadius = 10;
        _readTable.rowHeight = 44;
        _readTable.dataSource = self;
        _readTable.delegate = self;
        _readTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_readTable];
    }
    return _readTable;
}

-(UILabel *)infoLabel{
    if (_infoLabel == nil) {
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, self.frame.size.width - 30 * 2, 30)];
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
    static NSString *CellName = @"CellName";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellName];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellName];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSString* path = [self.dirArray objectAtIndex:indexPath.row];
    NSURL *fileURL= [NSURL fileURLWithPath:path];
    
    NSArray* pathComponents = [[NSFileManager defaultManager] componentsToDisplayForPath:path];
    NSString* pathComponent = [pathComponents lastObject];
    
    [self setupDocumentControllerWithURL:fileURL];
    cell.textLabel.text = pathComponent;
    NSInteger iconCount = [self.docInteractionController.icons count];
    if (iconCount > 0)
    {
        cell.imageView.image = [self.docInteractionController.icons lastObject];
    }
    
    NSString *fileURLString = [self.docInteractionController.URL path];
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fileURLString error:nil];
    NSInteger fileSize = [[fileAttributes objectForKey:NSFileSize] intValue];
    NSString *fileSizeStr = [NSByteCountFormatter stringFromByteCount:fileSize
                                                           countStyle:NSByteCountFormatterCountStyleFile];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", fileSizeStr, self.docInteractionController.UTI];
    UITapGestureRecognizer *longPressGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapPress:)];
    [cell.imageView addGestureRecognizer:longPressGesture];
    cell.imageView.userInteractionEnabled = YES;    // this is by default NO, so we need to turn it on
    
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
    //	[self presentViewController:previewController animated:YES completion:nil];
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

- (void)handleTapPress:(UILongPressGestureRecognizer *)tapPressGesture
{
    if (tapPressGesture.state == UIGestureRecognizerStateBegan)
    {
        NSIndexPath *cellIndexPath = [self.readTable indexPathForRowAtPoint:[tapPressGesture locationInView:self.readTable]];
        
        NSURL *fileURL;
        if (cellIndexPath.section == 0)
        {
            // for section 0, we preview the docs built into our app
            NSString *path = [self.dirArray objectAtIndex:cellIndexPath.row];
            fileURL = [NSURL fileURLWithPath:path];
        }
        else
        {
            // for secton 1, we preview the docs found in the Documents folder
            NSString *path = [self.dirArray objectAtIndex:cellIndexPath.row];
            fileURL = [NSURL fileURLWithPath:path];
        }
        self.docInteractionController.URL = fileURL;
        
        [self.docInteractionController presentOptionsMenuFromRect:tapPressGesture.view.frame
                                                           inView:tapPressGesture.view
                                                         animated:YES];
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

    [previewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"click.png"] forBarMetrics:UIBarMetricsDefault];
    
    NSURL *fileURL = nil;
    NSString *path = [self.dirArray objectAtIndex:idx];
    fileURL = [NSURL fileURLWithPath:path];
    return fileURL;
}

@end
