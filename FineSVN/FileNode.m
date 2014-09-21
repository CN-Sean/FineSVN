//
//  FileNode.m
//  FineSVN
//
//  Created by 邵文武 on 14/9/21.
//  Copyright (c) 2014年 FineReport. All rights reserved.
//

#import "FileNode.h"

#define fPROPERTIES @[@"NSURLFileSizeKey",@"NSURLNameKey",@"NSURLEffectiveIconKey", @"NSURLCreationDateKey", @"NSURLContentModificationDateKey", @"NSURLIsDirectoryKey",@"NSURLIsHiddenKey"]

@implementation FileNode

- (id)initWithURL: (NSURL *)url{
    self = [self init];
    if(self){
        self.urlPath = url;
        self.stringPath = [url path];
        NSDictionary *options = [url resourceValuesForKeys:fPROPERTIES error:nil];
        self.name = options[@"NSURLNameKey"];
        self.icon = options[@"NSURLEffectiveIconKey"];
        self.creationDate = options[@"NSURLCreationDateKey"];
        self.modificationDate = options[@"NSURLContentModificationDateKey"];
        self.isDirectory = [options[@"NSURLIsDirectoryKey"] boolValue];
        self.isHidden = [options[@"NSURLIsHiddenKey"] boolValue];
        if(options[@"NSURLFileSizeKey"]){
            self.size = [options[@"NSURLFileSizeKey"] stringValue];
        }
    }
    return self;
}

- (void)loadChildNodes
{
    NSMutableArray *children = [NSMutableArray array];
    NSFileManager *fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:self.stringPath]){
        NSArray *childUrls = [fm contentsOfDirectoryAtURL:self.urlPath includingPropertiesForKeys:fPROPERTIES options:NSDirectoryEnumerationSkipsSubdirectoryDescendants error:nil];
        if(childUrls){
            for(NSURL *url in childUrls){
                if([fm fileExistsAtPath:[url path]]){
                    FileNode *node = [[FileNode alloc] initWithURL:url];
                    [children addObject:node];
                }
            }
        }
    }
    self.children = children;
}

@end
