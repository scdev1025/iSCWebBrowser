//
//  AddBookmarkViewController.m
//  EBFexplorer
//
//  Created by Béchir Arfaoui on 27/01/13.
//  Copyright (c) 2013 EBF. All rights reserved.
//

#import "AddBookmarkViewController.h"
#import "BookmarkItem.h"
#import "SQLManager.h"

@implementation AddBookmarkViewController
@synthesize table,windowTitle,link;


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    mySQLmanager=[SQLManager sharedInstance];
      [mySQLmanager initDB];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
	 UITableViewCell *cell;
	cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
	}
	
	cell.accessoryView=nil;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleBlue;

    
    if (indexPath.row==0)
    {
        
        
        label = [[UITextField alloc] initWithFrame:CGRectMake(0,10,230,25)];
        label.adjustsFontSizeToFitWidth = NO;
        label.backgroundColor = [UIColor clearColor];
        label.autocorrectionType = UITextAutocorrectionTypeNo;
        label.autocapitalizationType = UITextAutocapitalizationTypeWords;
        label.textAlignment = 1;
        label.keyboardType = UIKeyboardTypeDefault;
        label.returnKeyType = UIReturnKeyDone;
        label.clearButtonMode = UITextFieldViewModeWhileEditing;
        label.returnKeyType = UIReturnKeyDone;
        label.text=windowTitle;
        cell.accessoryView = label;
        cell.textLabel.text=@"Title";
       // [cell.contentView addSubview:label];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
    }
    if (indexPath.row==1)
    {
        UITextField* urlfield = [[UITextField alloc] initWithFrame:CGRectMake(0,10,230,25)];
        urlfield.adjustsFontSizeToFitWidth = NO;
        urlfield.backgroundColor = [UIColor clearColor];
        urlfield.userInteractionEnabled=FALSE;
        urlfield.textAlignment = 1;
        urlfield.returnKeyType = UIReturnKeyDone;
        urlfield.text=link;
        cell.accessoryView = urlfield;
        //[cell.contentView addSubview:urlfield];
         cell.textLabel.text=@"URL";
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
    }
       return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}


-(IBAction)close:(id)sender
{
     [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)saveBookmark:(id)sender
{
    BookmarkItem*item=[[BookmarkItem alloc]init];
    item.label=label.text;
    item.link=link;
    if ([label.text length]>0) {
        [mySQLmanager AddBookmark:item];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        UIAlertView *notextAlert = [[UIAlertView alloc] initWithTitle:@"EBF explorer" message:@"There is no text in the title text field"
                                              delegate:self cancelButtonTitle:@"OK"
                                              
                                                              otherButtonTitles:nil];
        
        [notextAlert show];    }
 
}

@end
