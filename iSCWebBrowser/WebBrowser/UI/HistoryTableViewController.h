//
//  HistoryTableViewController.h
//  WebBrowser
//
//  Created by common on 4/5/15.
//  Copyright (c) 2015 ptc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LoadPageFromBookmarkProtocol.h"

@interface HistoryTableViewController : UITableViewController
@property(nonatomic,retain) id <LoadPageFromBookmarkProtocol> delegate;
@end
