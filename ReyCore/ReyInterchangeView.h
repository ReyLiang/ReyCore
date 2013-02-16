/************************************************* 
 
 Copyright (C), 2011-2015, yunlian Tech. Co., Ltd. 
 
 File name:	ReyInterchangeView.h	
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2012/2/4 
 
 Description: 
 
 实现items的拖拽互换
 支持4个item的互换
 
 
 Others: 
 
 
 
 forShort：
 
 
 History:  
 
 
 
 
 *************************************************/ 


//NSArray * rectArry = [NSArray arrayWithObjects:@"{{0,0},{50,50}}",@"{{60,0},{50,50}}",@"{{200,0},{50,50}}",
//                      @"{{0,100},{50,50}}",@"{{60,100},{50,50}}",@"{{200,100},{50,50}}",
//                      nil];
//NSArray * imgsArry = [NSArray arrayWithObjects:[UIImage imageNamed:@"setting"],
//                      [UIImage imageNamed:@"setting"],
//                      [UIImage imageNamed:@"setting"],
//                      [UIImage imageNamed:@"setting"],
//                      [UIImage imageNamed:@"setting"],
//                      [UIImage imageNamed:@"settingH"], nil];
//
//NSArray * highImgsArry = [NSArray arrayWithObjects:[UIImage imageNamed:@"settingH"],
//                          [UIImage imageNamed:@"settingH"],
//                          [UIImage imageNamed:@"settingH"],
//                          [UIImage imageNamed:@"settingH"],
//                          [UIImage imageNamed:@"settingH"],
//                          [UIImage imageNamed:@"setting"], nil];
//
//ReyInterchangeView * test = [[ReyInterchangeView alloc] initWithFrame:CGRectMake(0, 0, 320, 320) 
//                                                            rectsArry:rectArry 
//                                                             imgsArry:imgsArry
//                                                         highImgsArry:highImgsArry];
//[self.view addSubview:test];



#import <UIKit/UIKit.h>
#import "ReyInterchangeView_moveItem.h"

@protocol ReyInterchangeViewDelegate;

typedef enum {
    ReyInterchangeViewStateNomal = 0,
    ReyInterchangeViewStateInterchange
}ReyInterchangeViewState;

@interface ReyInterchangeView : UIView
    <ReyInterchangeView_moveItemDelegate>
{
    //存放item的rect信息
    NSArray * itemsRectArry;
    
    NSMutableArray * itemsArry;
    
    id<ReyInterchangeViewDelegate> delegate;
    
    ReyInterchangeViewState viewState;
}

@property (nonatomic , retain) NSArray * itemsRectArry;
@property (nonatomic , retain) NSMutableArray * itemsArry;

@property (nonatomic , assign) id<ReyInterchangeViewDelegate> delegate;

@property (nonatomic) ReyInterchangeViewState viewState;

-(void)changeState;

- (id)initWithFrame:(CGRect)frame 
          rectsArry:(NSArray *)rectsArry 
           imgsArry:(NSArray *)imgsArry 
       highImgsArry:(NSArray *)highImgsArry;

@end

@protocol ReyInterchangeViewDelegate <NSObject>

-(void)itemsClickUp:(ReyInterchangeView *)view item:(ReyInterchangeView_moveItem *)item;
-(void)itemsClickDown:(ReyInterchangeView *)view item:(ReyInterchangeView_moveItem *)item;

@end


