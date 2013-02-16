//
//  ReyImageView_down.m
//  ReyCore
//
//  Created by Rey on 12-9-10.
//
//

#import "ReyImageView_down.h"
#import "ReyDownload.h"


@interface ReyImageView_down()
    <ReyDownloadDelegate>
-(void)LoadImage:(NSString *)imageName;

@end

@implementation ReyImageView_down

#define IMAGE_MAIN_URL @"http://photo1.cheeseyouth.com"

#define IMAGE_CACHE_PATH @"Library/Caches/CheeseYouth"


@synthesize m_activityView;
@synthesize m_imageName,m_defualtImgName,m_faildImgName;
@synthesize m_download;


//test data => build.jpg
- (id)initWithFrame:(CGRect)frame
          imageName:(NSString *)imageName
     defualtImgName:(NSString *)defualtName
       faildImgName:(NSString *)faildName
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        m_defualtImgName = [defualtName retain];
        m_faildImgName = [faildName retain];

        m_imageName = [[self getImageNameFromUrl:imageName] retain];
        [self LoadImage:m_imageName];
    }
    return self;
}

-(void)dealloc
{
    if (m_download) {
        [m_download connectCancel];
        [m_download release];
        m_download = nil;
    }
    
    [m_imageName release];
    [m_defualtImgName release];
    [m_faildImgName release];
    
    if (m_activityView) {
        [m_activityView endLoading];
        [m_activityView removeFromSuperview];
        [m_activityView release];
        m_activityView = nil;
    }
    [super dealloc];
}

//重新加载image用
-(void)setLoadImage:(NSString *)imageName
{
    [m_imageName release];
    m_imageName = [[self getImageNameFromUrl:imageName] retain];
    [self LoadImage:m_imageName];
}

-(void)LoadImage:(NSString *)imageName
{

    UIImage * loadImage = [UIImage imageWithContentsOfFile:[self getCachePath:imageName]];
    
    if (!loadImage) {
        
        if (!m_activityView) {
            m_activityView = [[ReyLoadView alloc] initWithFrame:CGRectMake(0, 0,
                                                                           self.frame.size.width,
                                                                           self.frame.size.height)
                                                   loadingImage:[UIImage imageNamed:@"Loading"]];
            [self addSubview:m_activityView];
        }
//        m_activityView.hidden = NO;
        [m_activityView startLoading:1];
        
        
        m_download = [[ReyDownload ReyDownloadWithURL:[self getImageURL:imageName] delegate:self] retain];
        
        self.image = [UIImage imageNamed:m_defualtImgName];
        
        
        
        
        
    }
    else
    {
        self.image = loadImage;
    }
}


//TODO: can overwrite
-(NSURL *)getImageURL:(NSString *)imageName
{
    NSString * urlPath = [NSString stringWithFormat:@"%@%@",IMAGE_MAIN_URL,imageName];
    
    return [NSURL URLWithString:urlPath];
}

//TODO: can overwrite
-(NSString *)getCachePath:(NSString *)imageName
{
    NSString * component = [NSString stringWithFormat:@"%@/%@",IMAGE_CACHE_PATH,imageName];
    NSString * path =[NSHomeDirectory() stringByAppendingPathComponent:component];
    
    return path;
}

//TODO: can overwrite
-(NSString *)getImageNameFromUrl:(NSString *)imageName
{
    NSRange range;
    range.length = imageName.length;
    range.location = 0;
    
    NSMutableString * str = [NSMutableString stringWithString:imageName];
    [str replaceOccurrencesOfString:IMAGE_MAIN_URL withString:@"" options:0 range:range];
    
    return [NSString stringWithString:str];
}

-(void)downImageFailed
{
    self.image = [UIImage imageNamed:m_faildImgName];
    [m_activityView endLoading];
//    m_activityView.hidden = YES;
}


-(void)DownloadFailed:(NSError *)error
{
    [self downImageFailed];
}

-(void)DownloadFinished:(id)downloaded
{
    
    
    if ([[NSFileManager defaultManager] createDirectoryAtPath:[self getCachePath:@".."] withIntermediateDirectories:YES attributes:nil error:nil]) {
        
        self.image = [UIImage imageWithData:downloaded];
            
        NSData * data = (NSData *)downloaded;
        
        [data writeToFile:[self getCachePath:m_imageName] atomically:NO];
        
        
    }
    else
    {
        [self downImageFailed];
    }
    
    [m_activityView endLoading];
//    m_activityView.hidden = YES;
    
    
    
}

@end
