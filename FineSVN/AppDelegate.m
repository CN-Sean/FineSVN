//
//  AppDelegate.m
//  FineSVN
//
//  Created by 邵文武 on 14/9/20.
//  Copyright (c) 2014年 FineReport. All rights reserved.
//

#import "AppDelegate.h"
#import "DateUtils.h"

@interface AppDelegate ()
{
    
}

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    dirList = [NSMutableArray array];
    
    NSTextField *titleLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, dirSourceListView.headerView.frame.size.width,dirSourceListView.headerView.frame.size.height)];
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
                          if (result == NSOKButton)
                          {
                              NSArray *fileURLs = [openPanel URLs];
                              [self addDirPaths:fileURLs];
                              [dirSourceListView reloadData];
                          }
                      }];
}

- (void)addDirPaths:(NSArray*)fileURLs
{
    for (int i = 0; i < [fileURLs count]; i++)
    {
        NSURL* path = fileURLs[i];
        if ([[NSFileManager defaultManager] fileExistsAtPath:[path path]])
        {
            [dirList addObject:path];
        }
    }
}

#pragma mark - NSOutlineView Delegate and DataSource Methods
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if(rootNode){
        return [rootNode.children count];
    }
    return 0;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    FileNode *node = item;
    if(node == nil){
        node = rootNode;
    }
    return node.children[index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    FileNode *node = item;
    return node.isDirectory;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    FileNode *node = item;
    if([tableColumn.identifier isEqualToString:@"_filename_"]){
        return node.name;
    }else if([tableColumn.identifier isEqualToString:@"_creationdate_"]){
        return [DateUtils stringFromDate:node.creationDate withFormat:@"yyyy-MM-dd HH:mm"];
    }else if([tableColumn.identifier isEqualToString:@"_modificationdate_"]){
        return [DateUtils stringFromDate:node.modificationDate withFormat:@"yyyy-MM-dd HH:mm"];
    }else{
        return @"-empty-";
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    return NO;
}

#pragma mark - NSTableView Delegate and DataSource Methods
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [dirList count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSURL *url = dirList[row];
    NSArray *fileArray = [[url path] componentsSeparatedByString:@"/"];
    return [fileArray lastObject];
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    rootNode = [[FileNode alloc] initWithURL:dirList[row]];
    [rootNode loadChildNodes];
    [dirDetailView reloadData];
    return YES;
}

- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return NO;
}

@end
