//
//  AzDG.h
//  ReyCore
//
//  Created by Rey on 12-9-7.
//
//


#import <Foundation/Foundation.h>
@interface AzDG : NSObject
{
    
}

-(id) initWithCipher : (NSString*) input;

-(NSString*) getCipher;
-(NSData*) cipherCrypt:(NSData*) inputData;
-(NSData *) encode:(NSString*) input;
-(NSData *) decode:(NSString*) input;

@end