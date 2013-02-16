//
//  AzDG.m
//  ReyCore
//
//  Created by Rey on 12-9-7.
//
//

#import "AzDG.h"
#import "ReyMD5.h"
#import "GTMBase64.h"


@implementation AzDG

NSString* cipher = @"1234567890";

-(id) initWithCipher : (NSString*) input
{
    self = [super init];
    if (self != nil && input != nil && [input length] > 0)
    {
        cipher = input;
    }
    return self;
}

-(NSString*) getCipher{
    return cipher;
}

-(NSData*) cipherCrypt:(NSData*) inputData
{
    NSMutableData *outData = [[[NSMutableData alloc]init] autorelease];
    int loopCount = [inputData length];
    const unsigned char * inputChar = [inputData bytes];
    const unsigned char *cipherHash = [[[ReyMD5 getMD5WithString: [self getCipher]] dataUsingEncoding:NSASCIIStringEncoding] bytes];
    
    int i = 0;
    while (i < loopCount)
    {
        Byte b = (Byte)( inputChar[i] ^ cipherHash[i%32]);
        [outData appendBytes:&b length:sizeof(char)];
        i++;
    }
    return outData;
}



-(NSData *) encode:(NSString*) input
{
    NSData *inputData = [input dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *outData = [[NSMutableData alloc]init];
    int loopCount = [inputData length];
    const unsigned char *inputChar = [inputData bytes];
    const unsigned char *noiseChar = [[[ReyMD5 getMD5WithString:[NSString stringWithFormat:@"%@",[NSDate date]]]
                                       dataUsingEncoding:NSASCIIStringEncoding] bytes];
    
    int i = 0;
    while (i < loopCount)
    {
        [outData appendBytes:&noiseChar[i%32] length:sizeof(char)];
        Byte b = (Byte)(inputChar[i] ^ noiseChar[i%32]);
        [outData appendBytes:&b length:sizeof(char)];
        i++;
    }
    return [GTMBase64 encodeData:[self cipherCrypt:outData]];
    
}

-(NSData *) decode:(NSString*) input
{
    
    NSData* inputData = [self cipherCrypt:[GTMBase64 decodeString:input]];
    NSMutableData *outData = [[NSMutableData alloc] init];
    int loopCount = [inputData length];
    const unsigned char * inputChar = [inputData bytes];
    
    int i = 0;
    while (i < loopCount)
    {
        Byte b = (Byte)( inputChar[i] ^ inputChar[i+1]);
        [outData appendBytes:&b length:sizeof(char)];
        i = i + 2;
    }
    return outData;
}

@end


