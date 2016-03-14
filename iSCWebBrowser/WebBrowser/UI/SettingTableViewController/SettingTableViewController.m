//
//  SettingTableViewController.m
//  WebBrowser
//
//  Created by common on 4/5/15.
//  Copyright (c) 2015 ptc. All rights reserved.
//

#import "SettingTableViewController.h"

@interface SettingTableViewController ()
{
    NSMutableArray __strong *settingArr;
}

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    settingArr = [NSMutableArray new];
    [settingArr addObject:[NSArray arrayWithObjects:@"  Settings", @"Delete Browsind Data", @"Block Pop-ups", @"Accept Notification", nil]];
    [settingArr addObject:[NSArray arrayWithObjects:@"  More", @"About zBrowser", nil]];
    
    self.navigationController.title = @"Setting";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return settingArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSArray *sectiondata = [settingArr objectAtIndex:section];
    return sectiondata.count - 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    NSInteger section = indexPath.section;
    NSArray *sectiondata = (NSArray*)[settingArr objectAtIndex:section];
    cell = [tableView dequeueReusableCellWithIdentifier:@"setting_solo" forIndexPath:indexPath];
    if (sectiondata.count == 2) {
        [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_setting_more"]]];
        [cell setSelectedBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_setting_more"]]];
    }else{
        if (indexPath.row == 0) {
            [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_setting_top"]]];
            [cell setSelectedBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_setting_top"]]];
        }else if (indexPath.row == sectiondata.count - 2) {
            [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_setting_bottom"]]];
            [cell setSelectedBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_setting_bottom"]]];
        }else{
            [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_setting_mid"]]];
            [cell setSelectedBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_setting_mid"]]];
        }
    }
    // Configure the cell...
    cell.textLabel.text = sectiondata[indexPath.row + 1];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            case 1:
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 2:
            {
                UISwitch *accepnoti = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
                cell.accessoryView = accepnoti;
            }
                break;
            default:
                break;
        }
    }
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, tableView.bounds.size.width - 40, 20)];
    [label setTextColor:[UIColor blackColor]];
    [label setFont:[UIFont systemFontOfSize:15]];
    NSArray *sectiondata = settingArr[section];
    NSString *title = sectiondata[0];
    if (title.length == 0) {
        [label setText:@""];
    }
    [label setText:title];
    return label;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSArray *sectiondata = settingArr[section];
    NSString *title = sectiondata[0];
    if (title.length == 0) {
        return 0;
    }
    return 40;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
