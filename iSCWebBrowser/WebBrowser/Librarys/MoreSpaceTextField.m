//
//  MoreSpaceTextField.m
//  WebBrowser
//
//  Created by common on 4/4/15.
//  Copyright (c) 2015 ptc. All rights reserved.
//

#import "MoreSpaceTextField.h"

@implementation MoreSpaceTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect rect = [super textRectForBounds:bounds];
    rect.origin.x += 5;
    rect.size.width -= 10;
    return rect;
}

- (CGRect) placeholderRectForBounds:(CGRect)bounds
{
    CGRect rect = [super placeholderRectForBounds:bounds];
    rect.origin.x += 5;
    rect.size.width -= 10;
    return rect;
}

- (CGRect) editingRectForBounds:(CGRect)bounds
{
    CGRect rect = [super editingRectForBounds:bounds];
    rect.origin.x += 5;
    rect.size.width -= 10;
    return rect;
}

@end
