//
//  HistoryTableViewController.m
//  WebBrowser
//
//  Created by common on 4/5/15.
//  Copyright (c) 2015 ptc. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "DBController.h"
#import "Helper.h"

@interface HistoryTableViewController ()
{
    NSMutableArray *historys;
}

@end

@implementation HistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    historys = [NSMutableArray new];
    [self loadData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//load data to display in tableview
- (void) loadData
{
    //remove previous data
    [historys removeAllObjects];
    //create history db controller
    DBController *hisDb = [[DBController alloc] init];
    [hisDb initDatabase];
    //read history
    NSArray *historylist = [hisDb allHistory:500];
    //insert title by first data to array
    NSMutableArray *todays = [NSMutableArray new];
    [todays addObject:@"Today"];
    NSMutableArray *yesterdays = [NSMutableArray new];
    [yesterdays addObject:@"Yesterday"];
    NSMutableArray *others = [NSMutableArray new];
    [others addObject:@"Early"];
    NSInteger currentdiff = 0;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
    
    //resort the history by day.
    for (NSDictionary *dic in historylist) {
        NSDate *hisDate = [dateFormatter dateFromString:dic[@"update_time"]];
        currentdiff = [Helper compareDate:hisDate];
        if (currentdiff == 0) {
            [todays addObject:dic];
        }else if (ABS(currentdiff) == 1) {
            [yesterdays addObject:dic];
        }else{
            [others addObject:dic];
        }
    }
    if (todays.count > 1) {
        [historys addObject:todays];
    }
    if (yesterdays.count > 1) {
        [historys addObject:yesterdays];
    }
    if (others.count > 1) {
        [historys addObject:others];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return historys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSMutableArray *arr = historys[section];
    return arr.count - 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellid = @"history_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    //set content;
    NSMutableArray *arr = historys[indexPath.section];
    cell.textLabel.text = arr[indexPath.row + 1][@"url"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //calling our delegate method to load the selected bookmark ;)
    NSMutableArray *arr = historys[indexPath.section];
    [_delegate Load:arr[indexPath.row + 1][@"url"]];    
    //closing the current view
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width - 40, 20)];
    view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, tableView.bounds.size.width - 40, 20)];
    [label setTextColor:[UIColor blackColor]];
    [label setFont:[UIFont systemFontOfSize:15]];
    NSArray *sectiondata = historys[section];
    NSString *title = sectiondata[0];
    if (title.length == 0) {
        [label setText:@""];
    }
    [label setText:title];
    [view addSubview:label];
    return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSArray *sectiondata = historys[section];
    NSString *title = sectiondata[0];
    if (title.length == 0) {
        return 0;
    }
    return 30;
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
