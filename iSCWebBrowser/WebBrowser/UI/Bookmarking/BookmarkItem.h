//
//  BookmarkItem.h
//  EBFexplorer
//
//  Created by Béchir Arfaoui on 27/01/13.
//  Copyright (c) 2013 EBF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookmarkItem : NSObject
{
    NSString*id_bm;
    NSString*label;
    NSString*link;
}

@property (nonatomic,retain) NSString*id_bm;
@property (nonatomic,retain) NSString*label;
@property (nonatomic,retain) NSString*link;


@end
