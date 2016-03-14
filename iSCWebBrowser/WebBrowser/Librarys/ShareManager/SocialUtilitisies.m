//
//  SocielUtilitisies.m
//  EBFexplorer
//
//  Created by Béchir Arfaoui on 24/01/13.
//  Copyright (c) 2013 EBF. All rights reserved.
//

#import "SocialUtilitisies.h"
#import <MessageUI/MessageUI.h>
#import "social/Social.h"


@implementation SocialUtilitisies

-(void)ShareOnFacebook:(NSString*)message WithLink:(NSString*)url showSharingUIAt:(UIViewController*)destination;
{
    NSLog(@"process Facebook ... ");
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
                
                NSLog(@"Cancelled");
                
            } else
                
            {
                NSLog(@"Done");
            }
            
            [controller dismissViewControllerAnimated:YES completion:Nil];
        };
        controller.completionHandler =myBlock;
        
        //Adding the Text to the facebook post value from iOS
        [controller setInitialText:message];
        
        //Adding the URL to the facebook post value from iOS
        
        [controller addURL:[NSURL URLWithString:url]];
        
       
        
        [destination presentViewController:controller animated:YES completion:Nil];
        
    }
    else
    {
        UIAlertView*alertview= [[UIAlertView alloc]initWithTitle:@"iOS bug" message:@"your iOS device can't provide access to your facebook account, please check your Settings at Settings -> Facebook " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertview show];
    }

    
}
-(void)ShareOnTwitter:(NSString*)message WithLink:(NSString*)url showSharingUIAt:(UIViewController *)destination
{
    NSLog(@"Process twitter ... ");
    
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
                
                NSLog(@"Cancelled");
                
            } else
                
            {
                NSLog(@"Done");
            }
            
            [controller dismissViewControllerAnimated:YES completion:Nil];
        };
        controller.completionHandler =myBlock;
        
        //Adding the Text to the tweet post value from iOS
        [controller setInitialText:message];
        
        //Adding the URL to the tweet post value from iOS
        
        [controller addURL:[NSURL URLWithString:url]];
        
        
        
        [destination presentViewController:controller animated:YES completion:Nil];
        
    }


    
}
-(void)ShareUsingMail:(NSString*)message WithLink:(NSString*)url showSharingUIAt:(UIViewController *)destination
{
    NSLog(@"Process Mail");
    
    if ([MFMailComposeViewController canSendMail])
    {
        
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = destination;
        
        
        [controller setSubject:message];
        //[controller setMessageBody:@"ok" isHTML:NO];
        [controller setMessageBody:[NSString stringWithFormat:@"%@ %@",message,url] isHTML:NO];
         [destination presentViewController:controller animated:YES completion:Nil];
       
    }
}

@end
