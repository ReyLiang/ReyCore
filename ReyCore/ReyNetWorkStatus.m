//
//  ReyNetWorkStatus.m
//  ReyCore
//
//  Created by rey liang on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReyNetWorkStatus.h"
#import <arpa/inet.h>



#define NETWORKIMG_WIDTH 32
#define NETWORKIMG_HEIGHT 32


@interface ReyNetWorkStatus()

@property (nonatomic) NetworkStatus lastNetStatus;
- (void)showErrorView:(NetworkStatus) netStatus;
- (void)addNetWorkImg;

@end

@implementation ReyNetWorkStatus

@synthesize m_reach;
@synthesize netWorkImgView;
@synthesize lastNetStatus;


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [netWorkImgView removeFromSuperview];
    [netWorkImgView release];
    
    [m_reach release];
    
    [super dealloc];
    
}


- (id)initWithHostName:(NSString *)hostname
{
    self = [super init];
    
    if (self) {
        
        lastNetStatus = -1;
        
        m_reach = [[Reachability reachabilityWithHostName:hostname]retain];
        [m_reach startNotifier];
        [[NSNotificationCenter defaultCenter] addObserver: self 
                                                 selector: @selector(reachabilityChanged:) 
                                                     name: kReachabilityChangedNotification 
                                                   object: nil];
       

        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(restituteImage) 
                                                     name: @"NotificationForRestitute" 
                                                   object:nil];
        
        netWorkImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RNS_Airport"]];
        netWorkImgView.frame = CGRectMake(0, 0, netWorkImgView.image.size.width,netWorkImgView.image.size.height);
        [self addNetWorkImg];
    }
    
    return self;
}

- (id)initWithIP: (NSString *) ipStr
{
    self = [super init];
    if (self) {
        
        lastNetStatus = -1;
        
        struct sockaddr_in hostAddress;
        bzero(&hostAddress, sizeof(hostAddress));
        hostAddress.sin_len = sizeof(hostAddress);
        hostAddress.sin_family = AF_INET;
        hostAddress.sin_addr.s_addr = inet_addr([ipStr UTF8String]);
        
        
        m_reach = [[Reachability reachabilityWithAddress:&hostAddress]retain];
        [m_reach startNotifier];
        [[NSNotificationCenter defaultCenter] addObserver: self 
                                                 selector: @selector(reachabilityChanged:) 
                                                     name: kReachabilityChangedNotification 
                                                   object: nil];
        
//        netWorkImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RNS_Airport"]];
//        netWorkImgView.frame = CGRectMake(0, netWorkImgView.image.size.width-25, 
//                                          netWorkImgView.image.size.width,
//                                          netWorkImgView.image.size.height);

        [self addNetWorkImg];
    }

    return self;
}

//添加网络标示图片
- (void)addNetWorkImg
{

    self.hidden = NO;
    NSArray * windowsArry = [[UIApplication sharedApplication] windows];
    UIView * window = [windowsArry objectAtIndex:0];
    [window addSubview:self];

    [self addSubview:netWorkImgView];

}

- (void)exchangeFrame:(UIInterfaceOrientation)orientation
{    
    if (lastOrientation == orientation) {
        return;
    }
    lastOrientation = orientation;
    
    NSArray * windowsArry = [[UIApplication sharedApplication] windows];
    UIView * window = [windowsArry objectAtIndex:0];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    switch (orientation) {
        case UIDeviceOrientationLandscapeRight:
        {
            //旋转imgview
            self.transform = CGAffineTransformMakeRotation(-M_PI_2);
            self.frame = CGRectMake(0, 
                                    window.frame.size.height-NETWORKIMG_HEIGHT,
                                    NETWORKIMG_WIDTH,
                                    NETWORKIMG_HEIGHT);
        }  
             break;
        case UIDeviceOrientationLandscapeLeft:
        {
            //旋转imgview
            self.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.frame = CGRectMake(window.frame.size.width - NETWORKIMG_WIDTH, 
                                    0,
                                    NETWORKIMG_WIDTH,
                                    NETWORKIMG_HEIGHT);
        } 
            break;
        case UIInterfaceOrientationPortrait:
        {
            self.transform = CGAffineTransformMakeRotation(0);
            self.frame = CGRectMake(0, 
                                    0,
                                    NETWORKIMG_WIDTH,
                                    NETWORKIMG_HEIGHT);
        }
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            self.transform = CGAffineTransformMakeRotation(M_PI);
            self.frame = CGRectMake(window.frame.size.width - NETWORKIMG_WIDTH, 
                                    window.frame.size.height-NETWORKIMG_HEIGHT,
                                    NETWORKIMG_WIDTH,
                                    NETWORKIMG_HEIGHT);
        }
            break;
    }
    
    [UIView commitAnimations];
}
#pragma mark - SelectorForNotification
- (void)restituteImage
{
    self.netWorkImgView.frame = CGRectMake(0, 0, 25, 25);
}

- (void)reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    
    [self showErrorView:netStatus];
}


-(void)showErrorView:(NetworkStatus) netStatus
{
    
    if (netStatus == lastNetStatus) {
        return;
    }
    
    switch ((int)netStatus) {
        case NotReachable://网络链接失败
      {
        netWorkImgView.image = [UIImage imageNamed:@"RNS_stop"];

        break;
      }     
        case ReachableViaWiFi://wifi网络链接
      {
        netWorkImgView.image = [UIImage imageNamed:@"RNS_Airport"];

        break;
      }
        case ReachableViaWWAN://gprs/3g网络链接
      {
        netWorkImgView.image = [UIImage imageNamed:@"RNS_WWAN5"];

        break;
      }    
    }
    
    lastNetStatus = netStatus;
}


@end
