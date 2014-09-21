//
//  AppDelegate.h
//  FineSVN
//
//  Created by 邵文武 on 14/9/20.
//  Copyright (c) 2014年 FineReport. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FileNode.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSOutlineViewDelegate, NSOutlineViewDataSource, NSTableViewDataSource, NSTableViewDelegate>{
    IBOutlet NSButton *addDirPathBtn;
    IBOutlet NSTableView *dirSourceListView;
    IBOutlet NSOutlineView *dirDetailView;
    NSMutableArray *dirList;
    FileNode *rootNode;
    IBOutlet NSButton *updateBtn;
    IBOutlet NSTextField *logTextView;
}

@end

