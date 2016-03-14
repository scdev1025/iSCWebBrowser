//
//  SearchViewController.h
//  WebBrowser
//
//  Created by common on 4/4/15.
//  Copyright (c) 2015 ptc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadPageFromBookmarkProtocol.h"

@interface SearchViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UIButton *history;
    IBOutlet UIButton *bookmarks;
    IBOutlet UIView *markView;
    BOOL isHistory;
    IBOutlet UITableView *dataTableView;
}
@property(nonatomic,retain) id <LoadPageFromBookmarkProtocol> delegate;
- (void) reloadData;
@end
