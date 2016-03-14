//
//  AddBookmarkViewController.h
//  
//
//  Created by Béchir Arfaoui on 27/01/13.
//  Copyright (c) 2013 EBF. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SQLManager;

@interface AddBookmarkViewController : UIViewController
{
    UITableView*table;
    NSString*link;
    NSString*windowTitle;
    SQLManager*mySQLmanager;
    UITextField* label;
}

@property(nonatomic,retain) IBOutlet UITableView*table;
@property(nonatomic,retain) NSString*link;
@property(nonatomic,retain) NSString*windowTitle;


-(IBAction)close:(id)sender;
-(IBAction)saveBookmark:(id)sender;
@end

