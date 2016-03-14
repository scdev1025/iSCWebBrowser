//
//  TabsViewController.h
//  WebBrowser
//
//  Created by common on 4/6/15.
//  Copyright (c) 2015 ptc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StackView.h"
#import "LoadPageFromBookmarkProtocol.h"

@interface TabsViewController : UIViewController<StackDelegate>
{
    IBOutlet StackView *stackview;//tab list view
}

@property (nonatomic, weak) NSMutableArray *webViews;
@property(nonatomic,retain) id <LoadPageFromBookmarkProtocol> delegate;
@end
