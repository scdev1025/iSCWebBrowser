//
//  LoadPageFromBookmarkProtocol.h
//  EBFexplorer
//
//  Created by Kenneth on 04/04/15
//  Copyright (c) 2013 EBF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//when the url must be open in other view controller
@protocol LoadPageFromBookmarkProtocol <NSObject>
- (void) Load:(NSString*)url;
- (void) showWebView:(UIWebView*) web;
@end
