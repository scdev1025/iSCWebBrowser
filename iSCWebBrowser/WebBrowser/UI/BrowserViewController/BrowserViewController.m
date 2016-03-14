//
//  ViewController.m
//  EBFexplorer
//
//  Created by Béchir Arfaoui on 24/01/13.
//  Copyright (c) 2013 EBF. All rights reserved.
//
#import "SocialUtilitisies.h"
#import "BrowserViewController.h"
#import "BookmarkListViewController.h"
#import "AddBookmarkViewController.h"
#import "SettingTableViewController.h"
#import "DOPScrollableActionSheet.h"
#import "TabsViewController.h"
#import "DBController.h"
#import "SettingManager.h"
#import "HistoryTableViewController.h"
#import "SearchViewController.h"

#define HOME_URL @"http://www.bing.com"

@interface BrowserViewController()
{
    NJKWebViewProgress *_progressProxy;     //for show the progress that loading in webview
    bool interactive;                       //state whether loading
    NSString *currentUrl;                   //currenturl
    NSString *currentTitle;
    UIWebView *currentWebview;
    DBController *db;                       //db for bookmark management
    NSMutableArray *webviewlist;            //tablist
    SearchViewController *searchVC;         //searchvc
    IBOutlet UIScrollView *mainScrollView;  //main scrollview include main webview and hint view
    __weak IBOutlet UIImageView *nightView; //view for night view
}
@property (strong, nonatomic) IBOutlet UIView *addressHintView;
@property (weak, nonatomic) IBOutlet UIButton *tabButton;

@end

@implementation BrowserViewController
@synthesize webview,addressField,mytoolbar;
@synthesize back,forward,refresh;
@synthesize bookmark, cancel, stop;
@synthesize loadProgress;
@synthesize addressHintView;
@synthesize tabButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    Share=[[SocialUtilitisies alloc]init];
    
    // adding a navigation bar ! it will contain the window title and the address text field !
    
    //init load the home_url
    [self newTabWithURL:HOME_URL];
    
    //configure the addressfield that insert the bookmark, stop button
    addressField.leftView = bookmark;
    addressField.leftViewMode = UITextFieldViewModeUnlessEditing;
    addressField.rightView = stop;
    addressField.rightViewMode = UITextFieldViewModeUnlessEditing;
    addressField.layer.cornerRadius = 3;
    bookmark.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    bookmark.layer.shadowOffset = CGSizeMake(1, 0);
    bookmark.layer.shadowOpacity = 1;
    bookmark.layer.shadowRadius = 1;
    
    stop.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    stop.layer.shadowOffset = CGSizeMake(-1, 0);
    stop.layer.shadowOpacity = 1;
    stop.layer.shadowRadius = 1;
    [stop setImage:[UIImage imageNamed:@"ic_stop"] forState:UIControlStateSelected|UIControlStateHighlighted];
    
    //for progress
    _progressProxy = [[NJKWebViewProgress alloc] init];
    webview.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    loadProgress.alpha = 0;
    
    //for history
    db = [[DBController alloc] init];
    [db initDatabase];
    
    //for tabs
    webviewlist = [NSMutableArray new];
    [webviewlist addObject:webview];
}

//set the content of webview when appear viewcontroller
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUInteger index = [webviewlist indexOfObject:webview];
    if (index == NSNotFound) {
        index = [webviewlist indexOfObject:currentWebview];
        if (index == NSNotFound) {//if remove prevwebview
            [webviewlist addObject:webview];
            self.addressField.text = @"http://";
            [self.addressField becomeFirstResponder];
            [webview reload];
        }else{
            [self showWebView:currentWebview];
        }
    }
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    SettingManager *man = [SettingManager shareInstance];
    [nightView setHidden:![man isNightMode]];
    [tabButton setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)webviewlist.count] forState:UIControlStateNormal];
}

//add new tab
- (void) newTab
{
    UIWebView *web = [[UIWebView alloc] initWithFrame:webview.frame];
    [webview.superview addSubview:web];
    [webview removeFromSuperview];
    webview.delegate = nil;
    webview = web;
    webview.delegate = _progressProxy;
    web.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [webviewlist addObject:web];
    
    //set current tab count
    [tabButton setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)webviewlist.count] forState:UIControlStateNormal];
    addressField.text = @"";
    currentTitle = @"";
    currentUrl = @"";
    [addressField becomeFirstResponder];
}


// add new tab with url
- (void) newTabWithURL:(NSString*) url
{
    UIWebView *web = [[UIWebView alloc] initWithFrame:webview.frame];
    [webview.superview addSubview:web];
    [webview removeFromSuperview];
    webview.delegate = nil;
    webview = web;
    web.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webview.delegate = _progressProxy;
    [webviewlist addObject:web];
    
    //set current tab count
    [tabButton setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)webviewlist.count] forState:UIControlStateNormal];
    [self loadurl:url];
}

// display previsou webview
- (void)showWebView:(UIWebView *)web
{
    web.frame = webview.frame;
    [webview.superview addSubview:web];
    [webview removeFromSuperview];
    [webviewlist removeObject:webview];
    webview.delegate = nil;
    webview = web;
    web.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    currentTitle = [webview stringByEvaluatingJavaScriptFromString:@"document.title"];
    addressField.text = currentTitle;
    currentUrl = [webview stringByEvaluatingJavaScriptFromString:@"window.location.href"];
    SQLManager *man = [SQLManager sharedInstance];
    if ([man bookmarkExistedWithURL:currentUrl]) {
        [bookmark setSelected:true];
    }else{
        [bookmark setSelected:false];
    }
    webview.delegate = _progressProxy;
    [tabButton setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)webviewlist.count] forState:UIControlStateNormal];
    [self updateButtons];
}

//process subviews when the orientation is changed.
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([addressField isEditing]) {
        CGRect rect = mainScrollView.bounds;
        [addressHintView setFrame:rect];
    }else{
        CGRect rect = mainScrollView.bounds;
        rect.origin.x += rect.size.width;
        [addressHintView setFrame:rect];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

//display menu.
- (void) showMenu
{
    DOPAction *history = [[DOPAction alloc] initWithName:@"History" iconName:@"ic_history" handler:^{
        [self performSegueWithIdentifier:@"history" sender:self];

    }];
    DOPAction *share = [[DOPAction alloc] initWithName:@"Share" iconName:@"ic_share" handler:^{
        NSArray *activityItems = [NSArray arrayWithObjects: currentUrl, [UIImage imageNamed:@"ic_favorite_on"] , nil];
        
        UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            [self presentViewController:activityController animated:YES completion:nil];
        }else{
            UIPopoverController *popc = [[UIPopoverController alloc] initWithContentViewController:activityController];
            [popc presentPopoverFromBarButtonItem:self.menu permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        
    }];
    DOPAction *bookmarks = [[DOPAction alloc] initWithName:@"BookMarks" iconName:@"ic_menu_favorite" handler:^{
        [self ShowBookmark];
    }];
    DOPAction *settings = [[DOPAction alloc] initWithName:@"About" iconName:@"ic_menu_setting" handler:^{
        [self performSegueWithIdentifier:@"about" sender:self];
    }];
    DOPAction *night;
    SettingManager *man = [SettingManager shareInstance];
    if ([man isNightMode]) {
        night = [[DOPAction alloc] initWithName:@"Normal Mode" iconName:@"ic_menu_night" handler:^{
            SettingManager *man = [SettingManager shareInstance];
            [man setNightMode:false];
            [nightView setHidden:true];
            [nightView.superview bringSubviewToFront:nightView];
        }];
    }else{
        night = [[DOPAction alloc] initWithName:@"Night Mode" iconName:@"ic_menu_night_off" handler:^{
            SettingManager *man = [SettingManager shareInstance];
            [man setNightMode:true];
            [nightView setHidden:false];
            [nightView.superview bringSubviewToFront:nightView];
        }];
    }
    
    DOPAction *private;
    if ([man isPrivateMode]) {
        private = [[DOPAction alloc] initWithName:@"Public Mode" iconName:@"ic_menu_private" handler:^{
            [man setPrivateMode:false];
        }];
    }else{
        private = [[DOPAction alloc] initWithName:@"Private Mode" iconName:@"ic_menu_private_on" handler:^{
            SettingManager *man = [SettingManager shareInstance];
            [man setPrivateMode:true];
        }];
    }
    
    NSArray *actions = @[@"",
                @[history, share, bookmarks],
                @"",
                @[settings, night, private]];

    DOPScrollableActionSheet *menu = [[DOPScrollableActionSheet alloc] initWithActionArray:actions];
    [menu show];
}

//update button state
- (void)updateButtons
{
    self.forward.enabled = self.webview.canGoForward;
    self.back.enabled = self.webview.canGoBack;
}

//update title
- (void)updateTitle:(UIWebView*)aWebView
{
    /** 
     here gettig the document title to update the title label in the navigation bar
     the user exprience is very important in all apps
     **/
    
    NSString* Title = [aWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    //updating the title on the UI
}

//update address by request
- (void)updateAddress:(NSURLRequest*)request
{
    NSURL* url = [request mainDocumentURL];
    NSString* absoluteString = [url absoluteString];
//    currentUrl = absoluteString;
//    NSString* Title = [webview stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.addressField.text = absoluteString;
}

//display error by using alert
- (void)informError:(NSError*)error
{
    NSString* localizedDescription = [error localizedDescription];
    UIAlertView* alertView = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:localizedDescription delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//webview delegate methods implementation

#pragma mark - webview delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [self updateAddress:request];
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self updateButtons];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
    [self updateTitle:webView];
    NSURLRequest* request = [webView request];
    [self updateAddress:request];
    
    NSURL* url = [request mainDocumentURL];
    SQLManager *man = [SQLManager sharedInstance];
    if ([man bookmarkExistedWithURL:[url absoluteString]]) {
        [bookmark setSelected:true];
    }else{
        [bookmark setSelected:false];
    }
    
    SettingManager *settingman = [SettingManager shareInstance];
    NSString* Title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if ([url absoluteString].length != 0 && ![settingman isPrivateMode] && ![db historyExistedWithURL:[url absoluteString]]) {
        [db insertHistory:Title url:[url absoluteString]];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
    if (error.code != NSURLErrorCancelled) {
        [self informError:error];
    }
    if (webview.isLoading) {
        [stop setSelected:true];
    }else{
        [stop setSelected:false];
    }
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    if (progress == 0.0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        loadProgress.progress = 0;
        [UIView animateWithDuration:0.27 animations:^{
            loadProgress.alpha = 1.0;
        }];
    }
    if (progress == 1.0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [UIView animateWithDuration:0.27 delay:progress - loadProgress.progress options:0 animations:^{
            loadProgress.alpha = 0.0;
        } completion:nil];
    }
    
    if (webview.isLoading) {
        [stop setSelected:true];
    }else{
        [stop setSelected:false];
    }
    
    [loadProgress setProgress:progress animated:NO];
}

#pragma mark - others

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"history"]) {
        HistoryTableViewController *hisVC = segue.destinationViewController;
        hisVC.delegate=self;
    }else if ([segue.identifier isEqualToString:@"bookmarks"]) {
        BookmarkListViewController *bookmarkVC = segue.destinationViewController;
        bookmarkVC.delegate=self;
    }else if ([segue.identifier isEqualToString:@"tabs"]) {
        TabsViewController *tabsVC = segue.destinationViewController;
        tabsVC.webViews = webviewlist;
        tabsVC.delegate=self;
    }else if ([segue.identifier isEqualToString:@"search"]) {
        searchVC = segue.destinationViewController;
    }
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)ShowBookmark
{
    [self performSegueWithIdentifier:@"bookmarks" sender:self];    
}

- (void) loadurl:(NSString*)url
{
    if (url == nil) {
        url = HOME_URL;
    }
    
    NSURL* Localurl = [NSURL URLWithString:url];
    NSURLRequest* request = [NSURLRequest requestWithURL:Localurl];
    currentUrl = [url copy];
    addressField.text = currentUrl;
    SQLManager *man = [SQLManager sharedInstance];
    if ([man bookmarkExistedWithURL:url]) {
        [bookmark setSelected:true];
    }else{
        [bookmark setSelected:false];
    }
    [addressField resignFirstResponder];
    [self.webview loadRequest:request];
}

- (void)Load:(NSString *)url
{
    [self newTabWithURL:url];
}


#pragma mark - Actions

- (IBAction)cancelEditing:(id)sender {
    [addressField resignFirstResponder];
}

- (IBAction)onHome:(id)sender {
    [self newTabWithURL:HOME_URL];
}

//show sharing + options
-(IBAction)shareoptions:(id)sender
{
    [self showMenu];
}

- (IBAction)addBookMark:(id)sender {
    if ([bookmark isSelected]) {
        return;
    }
    SQLManager *man = [SQLManager sharedInstance];
    
    BookmarkItem *newmark = [[BookmarkItem alloc] init];
    newmark.label = [webview stringByEvaluatingJavaScriptFromString:@"document.title"];
    newmark.link = [webview stringByEvaluatingJavaScriptFromString:@"window.location.href"];
    if ([man bookmarkExistedWithURL:newmark.link]) {
        return;
    }
    [man AddBookmark:newmark];
    [bookmark setSelected:true];
}

- (IBAction)toggleRefresh:(id)sender {
    if ([sender isSelected]) {
        [webview stopLoading];
    }else{
        [webview reload];
    }
}

- (IBAction)onTab:(id)sender {
    UIWebView *web = [[UIWebView alloc] initWithFrame:webview.frame];
    [webview.superview addSubview:web];
    currentWebview = webview;
    [webview removeFromSuperview];
    webview = web;
    [self performSegueWithIdentifier:@"tabs" sender:self];
}

- (IBAction)onBack:(id)sender {
    [webview stopLoading];
    [webview goBack];
    
}

- (IBAction)onForward:(id)sender {
    [webview stopLoading];
    [webview goForward];
}
#pragma mark - text field delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    currentTitle = textField.text;
//    textField.text =currentUrl;
    self.navigationItem.rightBarButtonItem = cancel;

    //[searchVC reloadData];
    [addressHintView.superview bringSubviewToFront:addressHintView];
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = addressHintView.frame;
        rect.origin.x = 0;
        addressHintView.frame = rect;
    } completion:^(BOOL finished) {
        [searchVC reloadData];
    }];//    [UIMenuController sharedMenuController].menuVisible = NO;
    return true;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField selectAll:nil];
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
//    textField.text = currentTitle;
    self.navigationItem.rightBarButtonItem = nil;
    [self.addressField setBounds:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = addressHintView.frame;
        rect.origin.x = rect.size.width;
        addressHintView.frame = rect;
    }];
    
    return true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString* urlString = textField.text;
    NSURL* url = [NSURL URLWithString:urlString];
    if(!url.scheme)
    {
        NSString* modifiedURLString = [NSString stringWithFormat:@"http://%@", urlString];
        url = [NSURL URLWithString:modifiedURLString];
    }
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.webview loadRequest:request];
    [textField resignFirstResponder];
    return true;
}

@end
