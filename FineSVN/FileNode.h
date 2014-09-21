//
//  FileNode.h
//  FineSVN
//
//  Created by 邵文武 on 14/9/21.
//  Copyright (c) 2014年 FineReport. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileNode : NSObject

- (id)initWithURL: (NSURL *)url;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSDate *modificationDate;
@property (nonatomic, strong) NSImage *icon;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, strong) NSMutableArray *children;
@property (nonatomic, strong) NSString *stringPath;
@property (nonatomic, strong) NSURL *urlPath;
@property (nonatomic) BOOL isHidden;
@property (nonatomic) BOOL isDirectory;

- (void)loadChildNodes;

@end
