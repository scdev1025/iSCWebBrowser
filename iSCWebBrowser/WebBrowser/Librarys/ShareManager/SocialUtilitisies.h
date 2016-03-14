//
//  SocielUtilitisies.h
//  EBFexplorer
//
//  Created by Béchir Arfaoui on 24/01/13.
//  Copyright (c) 2013 EBF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SocialUtilitisies : NSObject

-(void)ShareOnFacebook:(NSString*)message WithLink:(NSString*)url showSharingUIAt:(UIViewController*)destination;
-(void)ShareOnTwitter:(NSString*)message WithLink:(NSString*)url showSharingUIAt:(UIViewController*)destination;
-(void)ShareUsingMail:(NSString*)message WithLink:(NSString*)url showSharingUIAt:(UIViewController*)destination;

@end
