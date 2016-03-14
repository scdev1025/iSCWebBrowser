//
//  StackView.m
//  StackedViewController
//
//  Created by common on 4/5/15.
//  Copyright (c) 2015 ptc. All rights reserved.
//

#import "StackView.h"
#import "UIImageView+WebCache.h"

#define MIN_COUNT 3
#define SHOW_HEIGHT 200
#define HIDE_HEIGHT 150
#define HEADER_HEIGHT 50
#define randf() (rand() * 1.0f/ RAND_MAX)

@interface StackView()<UIGestureRecognizerDelegate>
{
    NSMutableArray *stacks;
    NSMutableArray __weak *webs;
    NSInteger rowCount;
    UIView *fixView;
    UIPanGestureRecognizer *pangesture;
    UISwipeGestureRecognizer *swipegesture;
    UITapGestureRecognizer *tapgesture;
    BOOL isMoving;
    UIView *movingView;
}

@end

@implementation StackView
@synthesize stackOrientation;

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        stacks = [NSMutableArray new];
        stackOrientation = StackScrollVertical;
        fixView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:fixView];
        [self reloadData];
        self.delegate = self;
        swipegesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeGesture:)];
        swipegesture.delegate = self;
        pangesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGestrue:)];
        pangesture.delegate = self;
        tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture:)];
        tapgesture.delegate = self;
        [self addGestureRecognizer:tapgesture];
        [self addGestureRecognizer:pangesture];
        [self addGestureRecognizer:swipegesture];
        isMoving = false;
        movingView = nil;
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        stacks = [NSMutableArray new];
        stackOrientation = StackScrollVertical;
        fixView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:fixView];
        [self reloadData];
        self.delegate = self;
        swipegesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeGesture:)];
        swipegesture.delegate = self;
        pangesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGestrue:)];
        pangesture.delegate = self;
        tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture:)];
        tapgesture.delegate = self;
        [self addGestureRecognizer:tapgesture];
        [self addGestureRecognizer:pangesture];
        [self addGestureRecognizer:swipegesture];
        isMoving = false;
        movingView = nil;
    }
    return self;
}

- (void)setStackArray:(NSMutableArray *)stackArray
{
    webs = stackArray;
}

- (void) makeStack
{
    [stacks removeAllObjects];
    if (!webs) return;
    for (UIWebView *web in webs) {
        UIView *view;
        CGRect rect = self.bounds;
        rect.origin.y = 10;
        rect.size.height = rect.size.height - 20;

        if (stackOrientation == StackScrollVertical) {
            view = [[[NSBundle mainBundle] loadNibNamed:@"WebStack" owner:nil options:nil] objectAtIndex:0];
        }else{
            view = [[[NSBundle mainBundle] loadNibNamed:@"WebStack" owner:nil options:nil] objectAtIndex:1];
            rect.size.width = MAX(300, rect.size.height / 1.5);
        }
        view.frame = rect;
        UILabel *title = (UILabel*)[view viewWithTag:2];
        UIImageView *icon = (UIImageView*)[view viewWithTag:1];
        NSString *iconURLStr = [web stringByEvaluatingJavaScriptFromString:@"(function() {var links = document.querySelectorAll('link'); for (var i=0; i<links.length; i++) {if (links[i].rel.substr(0, 16) == 'apple-touch-icon') return links[i].href;} return "";})();"];
        [icon sd_setImageWithURL:[NSURL URLWithString:iconURLStr]];
        
        UIImageView *contentView = (UIImageView*)[view viewWithTag:4];
        
//        UIGraphicsBeginImageContext([web sizeThatFits:[[UIScreen mainScreen] bounds].size]);
        UIGraphicsBeginImageContext(contentView.bounds.size);
        CGContextRef resizedContext = UIGraphicsGetCurrentContext();
        // crash
        [web.layer renderInContext:resizedContext]; // crash
        // crash
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [contentView setImage:image];
        
        UIButton *closeButton = (UIButton*) [view viewWithTag:3];
        [closeButton addTarget:self action:@selector(onClose:) forControlEvents:UIControlEventTouchUpInside];
        title.text = [web stringByEvaluatingJavaScriptFromString:@"document.title"];
        view.layer.cornerRadius = 5;
        view.layer.shadowColor = [UIColor blackColor].CGColor;
        view.layer.shadowRadius = 5;
        view.layer.shadowOpacity = 1;
        view.layer.shadowOffset = CGSizeMake(0, 0);
        [stacks addObject:view];
    }
}

- (void) onClose:(UIButton*) sender
{
    UIView *view = [sender superview];
    [self removeStack:view];
}

- (void) onTapGesture:(UITapGestureRecognizer*) sender
{
    CGPoint point = [sender locationInView:self];
    UIView *stack = [self getViewInPoint:point];
    UIWebView *web = [webs objectAtIndex:[stacks indexOfObject:stack]];
    if (self.stackdelegate) {
        [self.stackdelegate didSelectedWebView:web];
    }
}

- (void) onPanGestrue:(UIPanGestureRecognizer*) sender
{
    if (!stacks) return;
    if (sender != pangesture) {
        return;
    }
    CGPoint point = [sender locationInView:self];
    if (stackOrientation == StackScrollVertical) {
        switch (sender.state) {
            case UIGestureRecognizerStateBegan:
            {
                CGPoint move = [sender translationInView:self];
                if (ABS(move.x) > ABS(move.y * 3)) {
                    isMoving = true;
                    movingView = [self getViewInPoint:point];
                }
            }
            case UIGestureRecognizerStateChanged:
                if (isMoving) {
                    [movingView setTransform:CGAffineTransformTranslate(movingView.transform, [sender translationInView:self].x, 0)];
                    CGFloat alpha = 1 - ABS(movingView.transform.tx / self.bounds.size.width);
                    if (alpha < 0.5) {
                        alpha = alpha * 2;
                    }else{
                        alpha = 1;
                    }
                    [movingView setAlpha:alpha];
                }
                break;
            case UIGestureRecognizerStateEnded:
                if (isMoving) {
                    if (movingView.transform.tx > self.bounds.size.width / 2) {
                        [self removeStack:movingView];
                    }else{
                        [UIView animateWithDuration:0.3 animations:^{
                            [movingView setTransform:CGAffineTransformIdentity];
                            movingView.alpha = 1;
                        }];
                    }
                    isMoving = false;
                }
                break;
            default:
                isMoving = false;
                break;
        }
        [sender setTranslation:CGPointZero inView:self];
    }else{
        switch (sender.state) {
            case UIGestureRecognizerStateBegan:
            {
                CGPoint move = [sender translationInView:self];
                if (ABS(move.y) > ABS(move.x * 3)) {
                    isMoving = true;
                    movingView = [self getViewInPoint:point];
                }
            }
            case UIGestureRecognizerStateChanged:
                if (isMoving) {
                    [movingView setTransform:CGAffineTransformTranslate(movingView.transform, 0, [sender translationInView:self].y)];
                    
                    CGFloat alpha = 1 - ABS(movingView.transform.ty / self.bounds.size.height);
                    if (alpha < 0.5) {
                        alpha = alpha * 2;
                    }else{
                        alpha = 1;
                    }
                    [movingView setAlpha:alpha];
                }
                break;
            case UIGestureRecognizerStateEnded:
                if (isMoving) {
                    if (movingView.transform.ty > self.bounds.size.height / 2) {
                        [self removeStack:movingView];
                    }else{
                        [UIView animateWithDuration:0.3 animations:^{
                            [movingView setTransform:CGAffineTransformIdentity];
                            [movingView setAlpha:1];
                        }];
                    }
                    isMoving = false;
                }
                break;
            default:
                isMoving = false;
                break;
        }
        [sender setTranslation:CGPointZero inView:self];
    }
}

- (void) onSwipeGesture:(UISwipeGestureRecognizer*) sender
{
    CGPoint point = [sender locationInView:self];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self relayoutStacks];
}

- (UIView*) getViewInPoint:(CGPoint) point
{
    UIView *candi = nil;
    for (UIView *view in self.subviews) {
        if (CGRectContainsPoint(view.frame, point) && fixView != view) {
            candi = view;
        }
    }
    return candi;
}

- (void) relayoutStacks
{
    if (!stacks) return;
    if (stackOrientation == StackScrollVertical) {
        CGFloat off = self.contentOffset.y;
        NSInteger startrow = off / HIDE_HEIGHT;
        CGRect rect;
        int i = 0;
        if (startrow >= MIN_COUNT) {
            CGFloat calcoff = off + MIN_COUNT * HEADER_HEIGHT;
            startrow = calcoff / SHOW_HEIGHT;
            for (i = 0; i<startrow - MIN_COUNT; i++) {
                if (i>=stacks.count) return;
                UIView *view = [stacks objectAtIndex:i];
                rect = view.frame;
                rect.origin.y = 0;
                view.frame = rect;
                [fixView addSubview:view];
            }
            int j = 0;
            
            CGFloat delta = calcoff - (startrow * SHOW_HEIGHT);
            if (delta < HIDE_HEIGHT) {
                for (; i<=startrow; i++) {
                    if (i>=stacks.count) return;
                    UIView *view = [stacks objectAtIndex:i];
                    rect = view.frame;
                    rect.origin.y = off + HEADER_HEIGHT * j;
                    [view setFrame:rect];
                    [self addSubview:view];
                    j++;
                }
            }else{
                if (i>=stacks.count) return;
                UIView *view = [stacks objectAtIndex:i];
                rect = view.frame;
                rect.origin.y = 0;
                view.frame = rect;
                [fixView addSubview:view];
                i++;
                for (; i<=startrow; i++) {
                    if (i>=stacks.count) return;
                    UIView *view = [stacks objectAtIndex:i];
                    rect = view.frame;
                    rect.origin.y = off + HEADER_HEIGHT * j + (SHOW_HEIGHT - delta);
                    [view setFrame:rect];
                    [self addSubview:view];
                    j++;
                }
            }
        }else{
            for (; i<=startrow; i++) {
                if (i>=stacks.count) return;
                UIView *view = [stacks objectAtIndex:i];
                rect = view.frame;
                rect.origin.y = off + HEADER_HEIGHT * i;
                [view setFrame:rect];
                [self addSubview:view];
            }
        }
        for (; i<stacks.count; i++) {
            UIView *view = [stacks objectAtIndex:i];
            rect = view.frame;
            rect.origin.y = SHOW_HEIGHT * i;
            [view setFrame:rect];
            [self addSubview:view];
        }
        rect = fixView.frame;
        rect.origin.y = off;
        [fixView setFrame:rect];
    }else{
        CGFloat off = self.contentOffset.x;
        NSInteger startrow = off / HIDE_HEIGHT;
        CGRect rect;
        int i = 0;
        if (startrow >= MIN_COUNT) {
            CGFloat calcoff = off + MIN_COUNT * HEADER_HEIGHT;
            startrow = calcoff / SHOW_HEIGHT;
            for (i = 0; i<startrow - MIN_COUNT; i++) {
                if (i>=stacks.count) return;
                UIView *view = [stacks objectAtIndex:i];
                rect = view.frame;
                rect.origin.x = 0;
                view.frame = rect;
                [fixView addSubview:view];
            }
            int j = 0;
            
            CGFloat delta = calcoff - (startrow * SHOW_HEIGHT);
            if (delta < HIDE_HEIGHT) {
                for (; i<=startrow; i++) {
                    if (i>=stacks.count) return;
                    UIView *view = [stacks objectAtIndex:i];
                    rect = view.frame;
                    rect.origin.x = off + HEADER_HEIGHT * j;
                    [view setFrame:rect];
                    [self addSubview:view];
                    j++;
                }
            }else{
                if (i>=stacks.count) return;
                UIView *view = [stacks objectAtIndex:i];
                rect = view.frame;
                rect.origin.x = 0;
                view.frame = rect;
                [fixView addSubview:view];
                i++;
                for (; i<=startrow; i++) {
                    if (i>=stacks.count) return;
                    UIView *view = [stacks objectAtIndex:i];
                    rect = view.frame;
                    rect.origin.x = off + HEADER_HEIGHT * j + (SHOW_HEIGHT - delta);
                    [view setFrame:rect];
                    [self addSubview:view];
                    j++;
                }
            }
        }else{
            for (; i<=startrow; i++) {
                if (i>=stacks.count) return;
                UIView *view = [stacks objectAtIndex:i];
                rect = view.frame;
                rect.origin.x = off + HEADER_HEIGHT * i;
                [view setFrame:rect];
                [self addSubview:view];
            }
        }
        for (; i<stacks.count; i++) {
            UIView *view = [stacks objectAtIndex:i];
            rect = view.frame;
            rect.origin.x = SHOW_HEIGHT * i;
            [view setFrame:rect];
            [self addSubview:view];
        }
        rect = fixView.frame;
        rect.origin.x = off;
        [fixView setFrame:rect];
    }
}

- (void) reloadData
{
    rowCount = 0;
    [self setContentSize:CGSizeMake(0, 0)];
    [self setContentOffset:CGPointMake(0, 0)];
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    [self makeStack];
    if (!stacks) return;
    rowCount = stacks.count;
    if (stackOrientation == StackScrollVertical) {
        [self setContentSize:CGSizeMake(0, SHOW_HEIGHT * rowCount + self.bounds.size.height - SHOW_HEIGHT)];
        CGFloat y = 0;
        
        for (int i = 0; i < stacks.count; i++) {
            UIView *view = [stacks objectAtIndex:i];
            [self addSubview:view];
            CGRect rect = view.frame;
            y = SHOW_HEIGHT * i;
            rect.origin.y = y;
            [view setFrame:rect];
        }
    }else{
        [self setContentSize:CGSizeMake(SHOW_HEIGHT * rowCount + self.bounds.size.width - SHOW_HEIGHT, 0)];
        CGFloat x = 0;
        if (!stacks) return;
        for (int i = 0; i < stacks.count; i++) {
            UIView *view = [stacks objectAtIndex:i];
            [self addSubview:view];
            CGRect rect = view.frame;
            x = SHOW_HEIGHT * i;
            rect.origin.x = x;
            [view setFrame:rect];
        }
    }
    
}

- (void) removeStack:(UIView*) stack
{
    if (!stacks) return;
    NSInteger index = [stacks indexOfObject:stack];
    [stacks removeObject:stack];
    
    [UIView animateWithDuration:0.3 animations:^{
        if (stackOrientation == StackScrollVertical) {
            CGRect rect = stack.frame;
            rect.origin.x = self.bounds.size.width;
            stack.frame = rect;
            [self relayoutStacks];
        }else{
            CGRect rect = stack.frame;
            rect.origin.y = self.bounds.size.height;
            stack.frame = rect;
            [self relayoutStacks];
        }
    } completion:^(BOOL finished) {
        [stack removeFromSuperview];
        [webs removeObjectAtIndex:index];
        if (self.stackdelegate) {
            [self.stackdelegate didChangedWebViewCount:stacks.count];
        }
    }];
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return !isMoving;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
