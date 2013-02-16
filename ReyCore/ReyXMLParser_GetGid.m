//
//  ReyXMLParser_GetGid.m
//  ReyCore
//
//  Created by rey liang on 11-12-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ReyXMLParser_GetGid.h"

@implementation ReyXMLParser_GetGid

#define CONTAINITEM  @"gameid", nil
#define ITEM @"set"


-(void)initContainArray
{
	containArray = [[NSArray alloc] initWithObjects:CONTAINITEM];
    
}


@end
