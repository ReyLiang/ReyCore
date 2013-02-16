//
//  ReyXMLParser_autoUpdate.h
//  ReyCore
//
//  Created by rey liang on 11-12-14.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReyXMLParser.h"

@interface ReyXMLParser_autoUpdate : ReyXMLParser
{
    NSMutableArray * currentArray;
}
@property (nonatomic , retain) NSMutableArray * currentArray;
@end
