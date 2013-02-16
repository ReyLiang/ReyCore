//
//  ReyBreakLoadView.m
//  ReyBreakLoad
//
//  Created by Rey on 12-11-18.
//  Copyright (c) 2012年 Rey. All rights reserved.
//

#import "ReyBreakLoadView.h"
#import "Rey_BLV_item.h"
#import "AFUIImageReflection.h"

@interface ReyBreakLoadView()
    <Rey_BLV_itemDelegate>

@end

@implementation ReyBreakLoadView

@synthesize m_superImage;
@synthesize m_itemsArry;
@synthesize m_bgView;

//行数
#define ROW 3
//列数
#define COLUM 3

- (id)initWithFrame:(CGRect)frame
       loadingImage:(UIImage *)loadingImage
       superViewImg:(UIImage *)superViewImg
{
    self = [super initWithFrame:frame loadingImage:loadingImage];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.25];
        
        m_superImage = [superViewImg retain];
        
        [self initSubViews];
    }
    return self;
}


-(void)dealloc
{
    [m_bgView release];
    [m_itemsArry release];
    [m_superImage release];
    [super dealloc];
}


-(void)startLoading:(double)duration superImage:(UIImage *)superImage
{
    [m_superImage release];
    m_superImage = [superImage retain];
    
    [self resetItemsImage];
    
    [self startLoading:duration];
}


-(void)startLoading:(double)duration
{
    m_bgView.hidden = NO;
    m_loadImgView.hidden = NO;
    [self bringSubviewToFront:m_bgView];
    [self bringSubviewToFront:m_loadImgView];
    
    
    [super startLoading:duration];
}

-(void)endLoading
{
    m_bgView.hidden = YES;
    m_loadImgView.hidden = YES;
//    [m_loadImgView.layer removeAllAnimations];
    [self loadFinished];
}

-(void)initSubViews
{
    [self resetItemsImage];
    
    if (!m_bgView) {
        m_bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        m_bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
        [self addSubview:m_bgView];
        m_bgView.hidden = YES;
    }
    
    
}

-(void)resetItemsImage
{
    
    if (m_itemsArry) {
        [m_itemsArry removeAllObjects];
        [m_itemsArry release];
    }
    
    m_itemsArry = [[NSMutableArray alloc] init];
    
    
    float itemWidth = self.frame.size.width/COLUM;
    float itemHeight = self.frame.size.height/ROW;
    
    for (int i =ROW-1; i >= 0; i --) {
        for (int j = COLUM-1; j >= 0; j --) {
            
            CGRect itemRect = CGRectMake(itemWidth * j, itemHeight * i, itemWidth, itemHeight);
            
            UIImage * itemImg = [m_superImage getImageInRect:itemRect];
            
            Rey_BLV_item * item = [[Rey_BLV_item alloc] initWithFrame:itemRect superSize:self.frame.size];
            //            item.backgroundColor = [UIColor colorWithPatternImage:itemImg];
            [item setImage:itemImg];
            item.m_delegate = self;
            
            item.tag = i*COLUM + j;
            
            [m_itemsArry insertObject:item atIndex:0];
            
            [self addSubview:item];
            [item release];
            
        }
    }
}

-(void)loadFinished
{

    Rey_BLV_item * item = [m_itemsArry objectAtIndex:0];
    [item startAnimation];
}

-(void)Rey_BLV_itemAnimationFinished:(Rey_BLV_item *)item
{
    int tag = item.tag;
    
    if (tag + 1 == [m_itemsArry count]) {
        
        [super endLoading];
//        [self removeFromSuperview];
        return;
    }
    
    Rey_BLV_item * itemSub = [m_itemsArry objectAtIndex:tag+1];
    [itemSub startAnimation];
    
}

@end
