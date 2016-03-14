//
//  SettingManager.h
//  WebBrowser
//
//  Created by common on 4/4/15.
//  Copyright (c) 2015 ptc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingManager : NSObject
{
}

@property (nonatomic, assign, getter=isPrivateMode) bool privateMode;
@property (nonatomic, assign, getter=isNightMode) bool nightMode;

+ (id) shareInstance;

@end
