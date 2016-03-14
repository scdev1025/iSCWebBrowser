//
//  BookmarkListViewController.m
//  EBFexplorer
//
//  Created by Béchir Arfaoui on 25/01/13.
//  Copyright (c) 2013 EBF. All rights reserved.
//

#import "BookmarkListViewController.h"
#import "SQLManager.h"

@implementation BookmarkListViewController

@synthesize table,datasource,editbtn,delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // using singleton Desing pattern we create a single instance class to communicate with the database 
    BookmarksManager=[SQLManager sharedInstance];
    [BookmarksManager initDB];

    // geeting records from the database
    datasource=[BookmarksManager GetBookmarks];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [datasource count];
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
	}
    
 
    cell.textLabel.text=[[datasource objectAtIndex:indexPath.row]label];
	cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    
        
        //deleting from the database
        [BookmarksManager RemoveBookmarkFromDB:[datasource objectAtIndex:indexPath.row]];
        
        //deleting from memory (RAM)
        [datasource removeObjectAtIndex:indexPath.row];
        
        //refreshing the tableview 
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //calling our delegate method to load the selected bookmark ;)
    [delegate Load:[[datasource objectAtIndex:indexPath.row]link]];
    
    //closing the current view
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(IBAction)StartEditing:(id)sender
{
   // editing button  
    
    if (self.table.editing)
    {
        [table setEditing:NO animated:YES];
        [self.editbtn setTitle:@"Edit"];
        self.editbtn.tintColor=[UIColor whiteColor];
       
    }
    else
    {

        [table setEditing:YES animated:YES];
        [self.editbtn setTitle:@"Done"];
        self.editbtn.tintColor=[UIColor whiteColor];
    }
}
@end
