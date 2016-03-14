//
//  BookmarkListViewController.h
//  EBFexplorer
//
//  Created by Béchir Arfaoui on 25/01/13.
//  Copyright (c) 2013 EBF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLManager.h"
#import "LoadPageFromBookmarkProtocol.h"

@interface BookmarkListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView*table;
    NSMutableArray*datasource;
    SQLManager* BookmarksManager;
    UIBarButtonItem*editbtn;
    
     id <LoadPageFromBookmarkProtocol> delegate;
}


@property(nonatomic,retain) id <LoadPageFromBookmarkProtocol> delegate;

@property(nonatomic,retain) IBOutlet UITableView*table;
@property(nonatomic,retain) NSMutableArray*datasource;
@property(nonatomic,retain) IBOutlet UIBarButtonItem*editbtn;
-(IBAction)StartEditing:(id)sender;

@end
