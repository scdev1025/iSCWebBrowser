//
//  SearchViewController.m
//  WebBrowser
//
//  Created by common on 4/4/15.
//  Copyright (c) 2015 ptc. All rights reserved.
//

#import "SearchViewController.h"
#import "BrowserViewController.h"
#import "DBController.h"
#import "SQLManager.h"
#import "BookmarkItem.h"
#import "Helper.h"

@interface SearchViewController ()
{
    NSMutableArray *historys;
    NSMutableArray *bookMarks;
}

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    markView.center = CGPointMake(history.center.x, markView.center.y);
    historys = [NSMutableArray new];
    bookMarks = [NSMutableArray new];
    [self reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    //relayout when the orientation is changed.
    if (isHistory) {
        markView.center = CGPointMake(history.center.x, markView.center.y);
    }else{
        markView.center = CGPointMake(bookmarks.center.x, bookmarks.center.y);
    }
}

//reload data to display in tableview
- (void) reloadData
{
    isHistory = true;
    //remove previous data
    [historys removeAllObjects];
    DBController *hisDb = [[DBController alloc] init];
    [hisDb initDatabase];
    NSArray *historylist = [hisDb allHistory:500];
    NSMutableArray *todays = [NSMutableArray new];
    [todays addObject:@"Today"];
    NSMutableArray *yesterdays = [NSMutableArray new];
    [yesterdays addObject:@"Yesterday"];
    NSMutableArray *others = [NSMutableArray new];
    [others addObject:@"Early"];
    NSInteger currentdiff = 0;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
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
    
    SQLManager *mookmarksManager=[SQLManager sharedInstance];
    [mookmarksManager initDB];
    
    // geeting records from the database
    [bookMarks removeAllObjects];
    [bookMarks addObjectsFromArray:[mookmarksManager GetBookmarks]];
    isHistory = true;
    markView.center = CGPointMake(history.center.x, markView.center.y);
    [dataTableView reloadData];
}

//load url in main webview
- (void) loadUrl:(NSString*) url
{
    if ([self.parentViewController isMemberOfClass:[BrowserViewController class]]) {
        BrowserViewController *parent = (BrowserViewController*)self.parentViewController;
        if ([parent respondsToSelector:@selector(Load:)]) {
            [parent performSelector:@selector(Load:) withObject:url];
        }
    }
}

#pragma mark - tableview delegate and datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"BaseItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    //set content;
    if (isHistory) {
        NSMutableArray *arr = historys[indexPath.section];
        cell.textLabel.text = arr[indexPath.row + 1][@"url"];
    }else{
        BookmarkItem *item = bookMarks[indexPath.row];
        cell.textLabel.text = item.link;
    }
    
    return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isHistory) {
        return historys.count;
    }else{
        return 1;
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isHistory) {
        NSMutableArray *arr = historys[section];
        return arr.count - 1;
    }else{
        return bookMarks.count;
    }
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
    if (historys == nil || historys.count == 0) {
        return 0;
    }
    NSArray *sectiondata = historys[section];
    NSString *title = sectiondata[0];
    if (title.length == 0) {
        return 0;
    }
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *url;
    if (isHistory) {
        NSMutableArray *arr = historys[indexPath.section];
        url = arr[indexPath.row + 1][@"url"];
    }else{
        BookmarkItem *item = bookMarks[indexPath.row];
        url = item.link;
    }
    [self loadUrl:url];
}

#pragma mark - actions

- (IBAction)onHistory:(id)sender {
    isHistory = true;
    markView.center = CGPointMake(history.center.x, markView.center.y);
    [dataTableView reloadData];
}

- (IBAction)onBookmarks:(id)sender {
    isHistory = false;
    markView.center = CGPointMake(bookmarks.center.x, markView.center.y);
    [dataTableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
