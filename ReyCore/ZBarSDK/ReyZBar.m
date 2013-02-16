//
//  ReyZBar.m
//  ReyCore
//
//  Created by rey liang on 12-2-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReyZBar.h"

#import "ZBarSDK.h"

@interface ReyZBar()<ZBarReaderDelegate>


@end

@implementation ReyZBar

@synthesize delegate;
@synthesize m_viewController;




-(id)initWithDelegate:(id<ReyZBarDelegate>)Adelegate withViewController:(UIViewController *)viewController
{
    self = [super init];
    if (self) {
        delegate = Adelegate;
        m_viewController = [viewController retain];
        [self showReyZBar];
    }
    
    return self;
}

-(void)dealloc
{
    [m_viewController release];
    [super dealloc];
}

-(void)showReyZBar
{
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    [m_viewController presentModalViewController: reader
                                      animated: YES];
    [reader release];
}


-(void)readerControllerDidFailToRead:(ZBarReaderController *)reader withRetry:(BOOL)retry
{
    if (delegate && [delegate respondsToSelector:@selector(ReyZBarDidFaildToRead: withRetry:)])
    {
        [delegate ReyZBarDidFaildToRead:self withRetry:retry];
    }
    
}


- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    // EXAMPLE: do something useful with the barcode data
    NSString * str = symbol.data;
    
    if (delegate && [delegate respondsToSelector:@selector(ReyZBarDidFinished: text:)]) 
    {
        [delegate ReyZBarDidFinished:self text:str];
    }
    
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissModalViewControllerAnimated: YES];
    

}


@end
