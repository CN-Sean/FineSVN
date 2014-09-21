//
//  AppDelegate.m
//  FineSVN
//
//  Created by 邵文武 on 14/9/20.
//  Copyright (c) 2014年 FineReport. All rights reserved.
//

#import "AppDelegate.h"
#import "DateUtils.h"

#define fNAMECOL @"_filename_"  //文件名
#define fSIZECOL @"_filesize_"  //文件大小
#define fCREATIONDATECOL @"_creationdate_"  //创建日期
#define fMODIFICATIONDATECOL @"_modificationdate_"  //修改日期

@interface AppDelegate () {

}

@property(weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    dirList = [NSMutableArray array];

    NSTextField *titleLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, dirSourceListView.headerView.frame.size.width, dirSourceListView.headerView.frame.size.height)];
    titleLabel.selectable = NO;
    titleLabel.font = [NSFont systemFontOfSize:16];
    titleLabel.alignment = NSCenterTextAlignment;
    titleLabel.bordered = NO;
    titleLabel.stringValue = @"工作目录";
    [titleLabel setAutoresizingMask:NSViewWidthSizable];
    [dirSourceListView.headerView addSubview:titleLabel];
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

//svn目录添加按钮点击事件
- (IBAction)svnDirAddBtnClick:(id)sender {
    NSOpenPanel *openPanel = [[NSOpenPanel alloc] init];
    [openPanel setCanChooseFiles:NO];
    [openPanel setCanChooseDirectories:YES];
    [openPanel setAllowsMultipleSelection:YES];
    [openPanel beginSheetModalForWindow:self.window
                      completionHandler:^(NSInteger result) {
                          if (result == NSOKButton) {
                              NSArray *fileURLs = [openPanel URLs];
                              [self addDirPaths:fileURLs];
                              [dirSourceListView reloadData];
                              [dirSourceListView selectRowIndexes:[NSIndexSet indexSetWithIndex:[dirList count] - 1] byExtendingSelection:NO];
                          }
                      }];
}

- (void)addDirPaths:(NSArray *)fileURLs {
    for (int i = 0; i < [fileURLs count]; i++) {
        NSURL *path = fileURLs[i];
        if ([[NSFileManager defaultManager] fileExistsAtPath:[path path]]) {
            [dirList addObject:path];
        }
    }
}

//更新操作
- (IBAction)updateBtnClick:(id)sender {
    if (dirDetailView) {
        if (dirSourceListView.selectedRow > -1) {
            NSURL *url = dirList[dirSourceListView.selectedRow];
            NSTask *task = [[NSTask alloc] init];
            [task setLaunchPath:@"/usr/bin/svn"];

            NSPipe *checkoutPipe = [[NSPipe alloc] init];
            [task setArguments:[NSArray arrayWithObjects:@"up",[url path],nil]];
            [task setStandardOutput:checkoutPipe];
            [task launch];

            NSFileHandle *file = [checkoutPipe fileHandleForReading];
            NSData *data = [file readDataToEndOfFile];
            NSString *checkoutResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            logTextView.stringValue = checkoutResult;
        }
    }
}

#pragma mark - NSOutlineView Delegate and DataSource Methods

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    FileNode *node = item;
    if (node == nil) {
        node = rootNode;
    }
    if (node.children) {
        return [node.children count];
    }
    return 0;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    FileNode *node = item;
    if (node == nil) {
        node = rootNode;
    }
    return node.children[index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    FileNode *node = item;
    return node.isDirectory;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
    FileNode *node = item;
    if ([tableColumn.identifier isEqualToString:fNAMECOL]) {
        NSCell *cell = [tableColumn dataCell];
        [node.icon setSize:NSMakeSize(16, 16)];
        [cell setImage:node.icon];
        return node.name;
    } else if ([tableColumn.identifier isEqualToString:fCREATIONDATECOL]) {
        return [DateUtils stringFromDate:node.creationDate withFormat:@"yyyy-MM-dd HH:mm"];
    } else if ([tableColumn.identifier isEqualToString:fMODIFICATIONDATECOL]) {
        return [DateUtils stringFromDate:node.modificationDate withFormat:@"yyyy-MM-dd HH:mm"];
    } else if ([tableColumn.identifier isEqualToString:fSIZECOL]) {
        return node.size;
    } else {
        return @"";
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldExpandItem:(id)item {
    FileNode *node = item;
    if (node.children == nil) {
        [node loadChildNodes];
    }
    return YES;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldCollapseItem:(id)item {
    return YES;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    return NO;
}

#pragma mark - NSTableView Delegate and DataSource Methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [dirList count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSURL *url = dirList[row];
    NSArray *fileArray = [[url path] componentsSeparatedByString:@"/"];
    return [fileArray lastObject];
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
    return YES;
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
    rootNode = [[FileNode alloc] initWithURL:dirList[dirSourceListView.selectedRow]];
    [rootNode loadChildNodes];
    [dirDetailView reloadData];
}

- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    return NO;
}

@end
