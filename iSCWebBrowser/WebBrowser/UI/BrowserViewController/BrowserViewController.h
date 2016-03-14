//
//  ViewController.h
//  EBFexplorer
//
//  Created by Kenneth on 04/04/15.
//  Copyright (c) 2014 PTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "LoadPageFromBookmarkProtocol.h"
#import "NJKWebViewProgress.h"

@class SocialUtilitisies;
@class AddBookmarkViewController;


@interface BrowserViewController : UIViewController<UIWebViewDelegate, NJKWebViewProgressDelegate, MFMailComposeViewControllerDelegate,LoadPageFromBookmarkProtocol, UITextFieldDelegate>
{
     UIWebView*webview;         //current web view
     UILabel* pageTitle;        //current title
     UITextField* addressField; // current url
    
    UIToolbar*mytoolbar;        //main toolbar
    SocialUtilitisies*Share;    //share object
}

@property(nonatomic,retain) IBOutlet UIWebView*webview;             //main webview
@property (nonatomic, retain) IBOutlet UITextField* addressField;   //main addressbar
@property(nonatomic,retain) IBOutlet UIToolbar*mytoolbar;           //mian toolbar
@property (nonatomic, retain) IBOutlet UIBarButtonItem* back;       //history back button
@property (nonatomic, retain) IBOutlet UIBarButtonItem* forward;    //history forward button
@property (nonatomic, retain) IBOutlet UIBarButtonItem* refresh;    //history refresh button, that is used to stop too
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menu;         //menu button
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancel;     //cancel button in top bar
@property (strong, nonatomic) IBOutlet UIButton *stop;              //stop button
@property (strong, nonatomic) IBOutlet UIButton *bookmark;          //bookmark button
@property (weak, nonatomic) IBOutlet UIProgressView *loadProgress;  //loading progress


- (void)updateButtons;                          //update button's state
- (void)updateTitle:(UIWebView*)aWebView;       //update button's title with webview
- (void)updateAddress:(NSURLRequest*)request;   //update address by current request
- (void)informError:(NSError*)error;            //display error
- (void)Load:(NSString *)url;                   //load url
- (IBAction)addBookMark:(id)sender;             //add bookmark when press addbookmark button
- (IBAction)toggleRefresh:(id)sender;           //when pressed the refresh
- (IBAction)cancelEditing:(id)sender;           //when pressed the cancel
- (IBAction)shareoptions:(id)sender;            //when pressed the menu
- (void)ShowBookmark;                           //show bookmark
@end
