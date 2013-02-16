//
//  ReyIPAddress.m
//  ReyCore
//
//  Created by Rey on 12-12-6.
//
//

#import "ReyIPAddress.h"
#import "IPAdress.h"

@implementation ReyIPAddress
+(NSString *)getLocalIPAddress
{
    InitAddresses();
    GetIPAddresses();
    GetHWAddresses();
    return [NSString stringWithFormat:@"%s", ip_names[1]];
}
@end
