//
//  SQLManager.m
//  EBFexplorer
//
//  Created by Béchir Arfaoui on 27/01/13.
//  Copyright (c) 2013 EBF. All rights reserved.
//

#import "SQLManager.h"
#import <sqlite3.h>
#import "BookmarkItem.h"

@implementation SQLManager
@synthesize databaseName,databasePath;

static SQLManager *sharedInstance = nil;

+ (SQLManager *)sharedInstance
{
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}


-(void)initDB
{
    //NSLog(@"initDB");
    databaseName = @"bookmarks.sql";
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	
    
	databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
   // NSLog(@"%@",databasePath);
	[self checkAndCreateDatabase];
}

-(void) checkAndCreateDatabase
{
	 //NSLog(@"checkAndCreateDatabase");

	NSFileManager *fileManager = [NSFileManager defaultManager];

	if([fileManager fileExistsAtPath:databasePath] == FALSE)
	{
		NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
	//	NSLog(@"%@",databasePathFromApp);
        
		// On copie la BDD de l'application vers le fichier systeme de l'application
		[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
	}
    else
    {
        NSLog(@"File exist !");
    }
	
}

-(sqlite3*)OpenDatabase
{
	
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	
	NSString* databasePath2 = [documentsDir stringByAppendingPathComponent:databaseName];
    
	if(sqlite3_open([databasePath2 UTF8String], &database) == SQLITE_OK)
    {
       // NSLog(@"DB is OK at path %@",databasePath2);
        return database;
         
    }else {
        NSLog(@"DB problem");
        return nil;
    }
    
	
}

-(NSMutableArray*)GetBookmarks
{
    NSMutableArray*BookmarksList;
    BookmarksList=[[NSMutableArray alloc]init];
	database = [self OpenDatabase];
	
	if(database)
    {
		sqlite3_stmt *compiledStatement;
		const char *sqlStatement;
	

			sqlStatement = "Select * from bookmarks";
		
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
			
			while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                BookmarkItem*item=[[BookmarkItem alloc]init];
                item.id_bm = [self ReadStringFromDB:0 Statement:compiledStatement];
                item.label = [self ReadStringFromDB:1 Statement:compiledStatement];
                item.link = [self ReadStringFromDB:2 Statement:compiledStatement];
                [BookmarksList addObject:item];
            }

		}
        else
        {
            NSLog(@"erreur ...");
            NSLog(@"Error %s while preparing statement",sqlite3_errmsg(database));
        }
	}
    
	sqlite3_close(database);
    NSLog(@"BookmarksList count %i",[BookmarksList count]);
    return BookmarksList;
    
}

-(void)RemoveBookmarkFromDB:(BookmarkItem*)item
{
    database = [self OpenDatabase];
	
	if(database)
    {
		sqlite3_stmt *compiledStatement;
	
        
        NSString*sqlStat=[NSString stringWithFormat:@"delete from bookmarks where id_link=%@",item.id_bm];
  
        NSLog(@"%@",sqlStat);
		
        const char *sqlStatement = [sqlStat cStringUsingEncoding : [NSString defaultCStringEncoding]];

        
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
            NSLog(@"ok");
        else
             NSLog(@"Error %s while preparing statement",sqlite3_errmsg(database));
        
        sqlite3_step(compiledStatement);
        sqlite3_finalize(compiledStatement);
           
    }
    sqlite3_close(database);
           
}
-(void)AddBookmark:(BookmarkItem*)item
{
    database = [self OpenDatabase];
	
	if(database)
    {
		sqlite3_stmt *compiledStatement;
        
        NSString*sqlStat=[NSString stringWithFormat:@"insert into bookmarks (label,link) values (\"%s\",\"%s\")", [item.label UTF8String], [item.link UTF8String]];
        
        NSLog(@"%@",sqlStat);
		
        const char *sqlStatement = [sqlStat cStringUsingEncoding : [NSString defaultCStringEncoding]];
        
        
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
            NSLog(@"ok");
        else
            NSLog(@"Error %s while preparing statement",sqlite3_errmsg(database));
        
        sqlite3_step(compiledStatement);
        sqlite3_finalize(compiledStatement);
        
    }
    sqlite3_close(database);

}

-(NSString*)ReadStringFromDB:(NSInteger)index Statement:(sqlite3_stmt *)compiledStatement
{
	char * str;
	NSString* strvalue ;
	str = (char *)sqlite3_column_text(compiledStatement, index);
	if (str){
		strvalue = [NSString stringWithUTF8String:str];
	}
	else{
		// handle case when object is NULL, for example set result to empty string:
		strvalue = @"";
	}
	
	return strvalue;
}

- (BOOL)bookmarkExistedWithURL:(NSString *)url
{
    BOOL existed = NO;
    database = [self OpenDatabase];
    if(database)
    {
        sqlite3_stmt *compiledStatement;
        const char *sqlStatement;
        
        
        sqlStatement = [[NSString stringWithFormat:@"SELECT * FROM bookmarks WHERE link = \"%s\"", [url UTF8String]] cStringUsingEncoding : [NSString defaultCStringEncoding]];
        
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                existed = YES;
                break;
            }
        }
        else
        {
            NSLog(@"erreur ...");
            NSLog(@"Error %s while preparing statement",sqlite3_errmsg(database));
        }
    }
    
    sqlite3_close(database);
    return existed;
}


@end
