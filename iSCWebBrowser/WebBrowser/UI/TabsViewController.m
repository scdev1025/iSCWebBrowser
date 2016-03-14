//
//  TabsViewController.m
//  WebBrowser
//
//  Created by common on 4/6/15.
//  Copyright (c) 2015 ptc. All rights reserved.
//

#import "TabsViewController.h"

@interface TabsViewController ()
{
    __weak IBOutlet UIButton *tabbutton;
    
}

@end

@implementation TabsViewController
@synthesize webViews;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [stackview setStackArray:webViews];
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        stackview.stackOrientation = StackScrollHorizontal;
    }else{
        stackview.stackOrientation = StackScrollVertical;
    }
    stackview.stackdelegate = self;
    [stackview reloadData];
    [tabbutton setTitle:[NSString stringWithFormat:@"%ld", (long)webViews.count] forState:UIControlStateNormal];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//on selected tab in stack view.
- (void)didSelectedWebView:(UIWebView *)web
{
    if (self.delegate) {
        [self.delegate showWebView:web];
    }
    [self.navigationController popViewControllerAnimated:true];
}

//when removed a webpage in stack view.
- (void)didChangedWebViewCount:(NSInteger)count
{
    [tabbutton setTitle:[NSString stringWithFormat:@"%ld", (long)count] forState:UIControlStateNormal];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    //when orientataion is changed, stackview must be changed.
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        if (stackview.stackOrientation == StackScrollVertical) {
            stackview.stackOrientation = StackScrollHorizontal;
            [stackview reloadData];
        }
        
    }else{
        if (stackview.stackOrientation == StackScrollHorizontal) {
            stackview.stackOrientation = StackScrollVertical;
            [stackview reloadData];
        }
    }
}

//on pressed the right bottom button.
- (IBAction)onTab:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

//on pressed the new tab button
- (IBAction)newTab:(id)sender {
    if (self.delegate) {
        [self.delegate Load:@""];
    }
    [self.navigationController popViewControllerAnimated:true];
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
