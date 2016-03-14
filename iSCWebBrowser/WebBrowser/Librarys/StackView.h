//
//  StackView.h
//  StackedViewController
//
//  Created by common on 4/5/15.
//  Copyright (c) 2015 ptc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StackDelegate

- (void) didSelectedWebView:(UIWebView*)web;
- (void) didChangedWebViewCount:(NSInteger) count;

@end

typedef enum
{
    StackScrollVertical,
    StackScrollHorizontal
} StackScrollOrientation;

@interface StackView : UIScrollView<UIScrollViewDelegate>
@property (nonatomic, assign) StackScrollOrientation stackOrientation;
@property (nonatomic, weak) id<StackDelegate> stackdelegate;
- (void) setStackArray:(NSMutableArray*) stackArray;
- (void) reloadData;
- (void) removeStack:(UIView*) stack;
@end
