//
//  ReyXMLParser_GODLogin.m
//  ReyCore
//
//  Created by rey liang on 11-12-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ReyXMLParser_GODLogin.h"

@implementation ReyXMLParser_GODLogin

#define CONTAINITEM  @"status", @"gsip", @"gsport", @"uid", @"center_url", nil
#define ITEM @"set"


-(void)initContainArray
{
	containArray = [[NSArray alloc] initWithObjects:CONTAINITEM];
    
}

-(void)writeToPath
{

	if (!isCheckUpdate) {//如果是检测模式,就不写入本地
		NSString * comPath = [NSString stringWithFormat:@"Documents/%@",plistName];
		NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:comPath];
		if ([[NSFileManager defaultManager] fileExistsAtPath:path] ) {
			NSError * error;
			if (![[NSFileManager defaultManager] removeItemAtPath:path error:&error]) {
				//NSLog(@"%@",[error description]);
				abort();
			}
		}
		if (![objectArray writeToFile:path atomically:NO]) {
			//NSLog(@"Plist文件保存出错");
			abort();
		}
		[objectArray release];
        objectArray = nil;
		
		//NSLog(@"%@ is finished",plistName);
	}
    
}

-(void)dealloc
{
    [super dealloc];
}

@end
