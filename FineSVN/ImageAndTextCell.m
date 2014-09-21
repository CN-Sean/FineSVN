//
// Created by 邵文武 on 14/9/21.
// Copyright (c) 2014 FineReport. All rights reserved.
//

#import "ImageAndTextCell.h"

#define kImageOriginXOffset     3
#define kImageOriginYOffset     1
#define kTextOriginXOffset      2
#define kTextOriginYOffset      2
#define kTextHeightAdjust       4

@interface ImageAndTextCell ()
@property (readwrite, strong) NSImage *image;
@end

#pragma mark -
@implementation ImageAndTextCell

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setFont:[NSFont systemFontOfSize:[NSFont smallSystemFontSize]]];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ImageAndTextCell *cell = (ImageAndTextCell *)[super copyWithZone:zone];
    cell.image = self.image;
    return cell;
}

- (BOOL)isGroupCell
{
    return ([self image] == nil && [[self title] length] > 0);
}

- (NSRect)titleRectForBounds:(NSRect)cellRect
{
    NSSize imageSize;
    NSRect imageFrame;

    imageSize = [self.image size];
    NSDivideRect(cellRect, &imageFrame, &cellRect, 3 + imageSize.width, NSMinXEdge);

    imageFrame.origin.x += kImageOriginXOffset;
    imageFrame.origin.y -= kImageOriginYOffset;
    imageFrame.size = imageSize;

    imageFrame.origin.y += ceil((cellRect.size.height - imageFrame.size.height) / 2);

    NSRect newFrame = cellRect;
    newFrame.origin.x += kTextOriginXOffset;
    newFrame.origin.y += kTextOriginYOffset;
    newFrame.size.height -= kTextHeightAdjust;

    return newFrame;
}

- (void)editWithFrame:(NSRect)aRect inView:(NSView*)controlView editor:(NSText*)textObj delegate:(id)anObject event:(NSEvent*)theEvent
{
    NSRect textFrame = [self titleRectForBounds:aRect];
    [super editWithFrame:textFrame inView:controlView editor:textObj delegate:anObject event:theEvent];
}

- (void)selectWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject start:(NSInteger)selStart length:(NSInteger)selLength
{
    NSRect textFrame = [self titleRectForBounds:aRect];
    [super selectWithFrame:textFrame inView:controlView editor:textObj delegate:anObject start:selStart length:selLength];
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    NSRect newCellFrame = cellFrame;

    if (self.image != nil)
    {
        NSSize	imageSize;
        NSRect	imageFrame;

        imageSize = [self.image size];
        NSDivideRect(newCellFrame, &imageFrame, &newCellFrame, imageSize.width, NSMinXEdge);
        if ([self drawsBackground])
        {
            [[self backgroundColor] set];
            NSRectFill(imageFrame);
        }

        imageFrame.origin.y += 1;
        imageFrame.size = imageSize;

        [self.image drawInRect:imageFrame
                      fromRect:NSZeroRect
                     operation:NSCompositeSourceOver
                      fraction:1.0
                respectFlipped:YES
                         hints:nil];
    }
    else
    {
        if ([self isGroupCell])
        {
            CGFloat yOffset = floor((NSHeight(newCellFrame) - [[self attributedStringValue] size].height) / 2.0);

            newCellFrame.origin.y += yOffset;
            newCellFrame.size.height -= (kTextOriginYOffset*yOffset);
        }
    }

    [super drawWithFrame:newCellFrame inView:controlView];
}

- (NSSize)cellSize
{
    NSSize cellSize = [super cellSize];
    cellSize.width += (self.image ? [self.image size].width : 0) + 3;
    return cellSize;
}

@end