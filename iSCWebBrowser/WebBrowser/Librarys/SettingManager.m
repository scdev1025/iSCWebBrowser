//
//  SettingManager.m
//  WebBrowser
//
//  Created by common on 4/4/15.
//  Copyright (c) 2015 ptc. All rights reserved.
//

#import "SettingManager.h"

@implementation SettingManager

+ (id) shareInstance
{
    static SettingManager *man = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        man = [[self alloc] init];
    });
    return man;
}



@end
