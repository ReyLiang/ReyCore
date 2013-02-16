//
//  ReyImageView_down.h
//  ReyCore
//
//  Created by Rey on 12-9-10.
//
//

#import <UIKit/UIKit.h>
#import "ReyLoadView.h"

@class ReyDownload;

@interface ReyImageView_down : UIImageView

{
    ReyLoadView * m_activityView;
    
    NSString * m_imageName;
    NSString * m_defualtImgName;
    NSString * m_faildImgName;
    
    ReyDownload * m_download;
}

@property (nonatomic , retain) ReyLoadView * m_activityView;
@property (nonatomic , retain) NSString * m_imageName;
@property (nonatomic , retain) NSString * m_defualtImgName;
@property (nonatomic , retain) NSString * m_faildImgName;

@property (nonatomic , retain) ReyDownload * m_download;

-(NSString *)getCachePath:(NSString *)imageName;
-(NSURL *)getImageURL:(NSString *)imageName;
-(NSString *)getImageNameFromUrl:(NSString *)imageName;

//重新加载image用
-(void)setLoadImage:(NSString *)imageName;

- (id)initWithFrame:(CGRect)frame
          imageName:(NSString *)imageName
     defualtImgName:(NSString *)defualtName
       faildImgName:(NSString *)faildName;

@end
