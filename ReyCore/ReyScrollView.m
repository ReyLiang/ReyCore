//
//  ReyScrollView.m
//  113001
//
//  Created by I Mac on 10-12-1.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ReyScrollView.h"


@implementation ReyScrollView

@synthesize ScrollView;

@synthesize infoArray ;
@synthesize startPoint ;
@synthesize Max ;
@synthesize Min ;
@synthesize total;

@synthesize m_isZoomingView;

@synthesize currectPage,lastPage;


@synthesize isMax;//page移到最右端,不用再加载页面
@synthesize isMin;//page移到最左端,不用再加载页面

@synthesize isZooming,infoArrayCount;

@synthesize scrollViewMode;

@synthesize datasource;
@synthesize delegate;

#define INFOARRAYCOUNT 3

//TODO: 不同plist格式的宏
/**************************************************
 name:	dictionaryPlist
 
 description:  使用不同plist格式的标识,如果是dictionary格式的就用这个宏
 
 **************************************************/
//#define dictionaryPlist

- (id)initWithFrame:(CGRect)frame datasource:(id<ReyScrollViewDataSource>)adataSource count:(int )count {
	
	return [self initWithFrame:frame datasource:adataSource count:count index:0];
	
}


- (id)initWithFrame:(CGRect)frame
         datasource:(id<ReyScrollViewDataSource>)adataSource
              count:(int )count
              index:(int)index{
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		self.backgroundColor = [UIColor clearColor];
		
        datasource = adataSource;
		
		ScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
		
		//为了和主色调协调而改为黑色
		ScrollView.backgroundColor = [UIColor blackColor];
		
		currectPage = index;
		lastPage = currectPage;
        
        m_detailViewCount = count;
		
		//初始化数据
        
		[self CreatDetail];
		
		scrollViewMode = ScrollViewZoomModePaging;
		
		//scrollview的设置
		ScrollView.delegate=self;
		ScrollView.pagingEnabled=YES;
		ScrollView.maximumZoomScale = 5;
		ScrollView.minimumZoomScale = 1;
		
		ScrollView.contentOffset = CGPointMake(frame.size.width*index, 0);
		
		//主要为index功能增加的
		[self setCurrectPage:currectPage];
		
		[self addSubview:ScrollView];
		
		
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


- (void)dealloc {
	[infoArray removeAllObjects];
	[infoArray release];
	
	[ScrollView release];
    [super dealloc];
}

#pragma mark -
#pragma mark InitData


//scrollView的基本设定
-(void)CreatDetail
{
	int count = m_detailViewCount;
	total = count;
	int i;
	
	//	if (!infoArray) {
	//		infoArray = [[NSMutableArray alloc] init] ;
	//	} 
	//	else {
	//		[infoArray removeAllObjects] ;
	//		infoArray = nil;
	//	}
	
	ScrollView.contentSize=CGSizeMake(ScrollView.frame.size.width*count, ScrollView.frame.size.height);
	
	if (!infoArray) {
		infoArray = [[NSMutableArray alloc] init] ;
	} 
	else {
		[infoArray removeAllObjects] ;
	}
	
	if (count > INFOARRAYCOUNT) {
		count = INFOARRAYCOUNT ;
		infoArrayCount = INFOARRAYCOUNT;
        
        [self subviewsMinAndMax];
	}
	else {
		infoArrayCount = count;
        
        Min = 0;
        Max = m_detailViewCount-1;
	}
	

	
	
	
	//加载初始view
	for (i=Min;i<=Max ; i++)
	{
		UIView * Mysubview = [[UIView alloc] initWithFrame:CGRectMake(ScrollView.frame.size.width*i, 
																	  0, 
																	  ScrollView.frame.size.width, 
																	  ScrollView.frame.size.height)] ;
		
		[self AddViewForScrollView:i myView:Mysubview] ;
		//添加到数组中
		[self AddViewToArray:(UIView*)Mysubview order:(BOOL)NO] ;
		[Mysubview release];
		Mysubview = nil ;
	}	
}

-(void)subviewsMinAndMax
{
    //根据currectPage来设定infoArray的数据
	if (currectPage) {
		
		int space = infoArrayCount/2;
		//设置min
		if (currectPage - space >0) {
			Min = currectPage-space;
		}
		else {
			Min = 0;
		}
		
		//设置max
		if (currectPage + space > total-1 ) {
			Max = total-1;
		}
		else {
			Max = currectPage + space;
		}
		
		
		//判断min和max是否正确
		int minSpace = currectPage - Min ;//距离min,max的间隔
		int maxSpace = Max - currectPage;
		
		if (minSpace > maxSpace ) {//max == total-1
			
			Min -= space - maxSpace;
			isMax =YES;
			
		}
		else {//min == 0
			Max += space -minSpace;
			isMin = YES;
		}
		
	}
	else {
		Min = 0 ;
		Max = m_detailViewCount-1 ;
	}
}
	

//-(void) addMySubviewToScrollView:(NSDictionary*)dic
//{
//	int index = [[dic objectForKey:@"index"] intValue];
//	NSArray * array = [dic objectForKey:@"array"];
//	
//	UIView * Mysubview = [[UIView alloc] initWithFrame:CGRectMake(ScrollView.frame.size.width*index, 
//																  0, 
//																  ScrollView.frame.size.width, 
//																  ScrollView.frame.size.height)] ;
//	
//	[self AddViewForScrollView:index array:array myView:Mysubview] ;
//	//添加到数组中
//	[self AddViewToArray:(UIView*)Mysubview order:(BOOL)NO] ;
//	[Mysubview release];
//	Mysubview = nil ;
//}

#pragma mark -
#pragma mark UIScrollViewZoom 's function

//TODO: UIScrollViewZoom_DetailView双击事件的响应
-(void )RestoreZooming:(CGPoint)location
{
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.4];
    
	//NSLog(@"RestoreZooming");
	if (scrollViewMode ==ScrollViewZoomModeZooming) {//从缩放回到翻页模式
		
//		ScrollView.zoomScale = ScrollView.minimumZoomScale;
        [ScrollView setZoomScale:ScrollView.minimumZoomScale animated:YES];
		[self setPagingMode];
	}
	else if(scrollViewMode == ScrollViewZoomModePaging){
		//viewForZoomingInScrollView被系统调用,所以要先修改模式
		scrollViewMode = ScrollViewZoomModeZooming;
		
		[ScrollView setZoomScale:ScrollView.maximumZoomScale animated:YES];
		
		[self setZoomingMode];
		
		//为了准确确定位置
		float halfWidth = ScrollView.frame.size.width/2;
		float halfHeight = ScrollView.frame.size.height/2;
		
		ScrollView.contentOffset = CGPointMake(location.x*5-halfWidth, location.y*5-halfHeight);
	}
    
//    [UIView commitAnimations];
	
}
-(void)AddViewForScrollView:(int)i myView:(UIView*)Mysubview
{
    
    if ([datasource respondsToSelector:@selector(ReyScrollViewDetailView:index:superView:)]) {
        UIView * subView = [datasource ReyScrollViewDetailView:self index:i superView:Mysubview];
        
        [Mysubview addSubview:subView];
    }
	
	[ScrollView addSubview:Mysubview];
}

-(void)AddViewToArray:(UIView*)myView order:(BOOL)bLeft 
{
	if (!bLeft) {
		[infoArray addObject:myView] ;
	}
	else {
		[infoArray insertObject:myView atIndex:0];
	}
}

-(bool )isMidLastPages:(int)lastPageNO
{
	int mid = infoArrayCount/2;//count必须是奇数,从min到mid == 从mid到max
	return lastPageNO - Min ==mid ? YES:NO;
}
-(bool )isMidCurrectPages:(int)currectPageNO
{
	
	//int mid = infoArrayCount/2;//count必须是奇数,从min到mid == 从mid到max
	if ([self isMidLastPages:lastPage]) {
		
		return YES;
	}
	return NO;
	
	
}

-(void )addLeftView
{

	
	UIView * Mysubview = nil ;
	
	
	if (Min) {
		isMax = NO;
		Min -= 1 ;
		Max -=1 ;
	}
	else {
		isMin = YES;
		////////////////============================
		return;
		////////////////============================
	}
	
	Mysubview = [[UIView alloc] initWithFrame:CGRectMake(ScrollView.frame.size.width*Min, 0, ScrollView.frame.size.width, ScrollView.frame.size.height)] ;
	[self AddViewForScrollView:Min myView:Mysubview] ;
	//添加到数组中
	[self AddViewToArray:(UIView*)Mysubview order:(BOOL)YES] ;
	
	
	[[infoArray objectAtIndex:[infoArray count] -1] removeFromSuperview] ;
	[infoArray removeLastObject] ;
	
	if (Mysubview) {
		[Mysubview release];
		Mysubview = nil ;
	}
}

-(void )addRightView
{
	
	UIView * Mysubview = nil ;
	
	
	if (Max + 1 < total) {
		isMin = NO;
		Min += 1 ;
		Max += 1 ;
	}
	else {
		isMax = YES;
		////////////////============================
		return;
		////////////////============================
	}
	
	Mysubview = [[UIView alloc] initWithFrame:CGRectMake(ScrollView.frame.size.width*self.Max, 0, ScrollView.frame.size.width, ScrollView.frame.size.height)] ;
	[self AddViewForScrollView:self.Max myView:Mysubview] ;
	//添加到数组中
	[self AddViewToArray:(UIView*)Mysubview order:(BOOL)NO] ;
	

	[[infoArray objectAtIndex:0] removeFromSuperview] ;
	[infoArray removeObjectAtIndex:0] ;
	
	
	if (Mysubview) {
		[Mysubview release];
		Mysubview = nil ;
	}
}

//TODO: 向左翻页的实现
-(void)leftPageDo
{
	int minSpace = currectPage - Min;
	int maxSpace = Max - currectPage;
	
	if (!Min) {
		[ScrollView setUserInteractionEnabled:YES] ;
		return ;
	}
	
	
	if (![self isMidCurrectPages:currectPage] ) {
		if (isMax && minSpace < maxSpace) {
			[self addLeftView];
		}
		[ScrollView setUserInteractionEnabled:YES] ;
		if (isMax) {
			isMax = NO;
		}
		return;
	}
	
	[self addLeftView];
}

//TODO: 向右翻页的实现
-(void)rightPageDo
{
	int minSpace = currectPage - Min;
	int maxSpace = Max - currectPage;
	
	if (isMax) {
		[ScrollView setUserInteractionEnabled:YES] ;
		return ;
	}
	
	if (![self isMidCurrectPages:currectPage] ) {
		if (isMin && minSpace > maxSpace) {
			[self addRightView];
		}
		[ScrollView setUserInteractionEnabled:YES] ;
		if (isMin) {
			isMin = NO;
		}
		return;
	}
	
	[self addRightView];
}



-(void)setScrollViewModeNotInitialized
{
	scrollViewMode = ScrollViewZoomModeNotInitialized;
}
-(void)setScrollViewModePaging
{
	scrollViewMode = ScrollViewZoomModePaging;
}

#pragma mark -


#pragma mark UIScrollViewDelegate
#pragma mark -





- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView   // called on finger up as we are moving
{
//	NSLog(@"scrollViewWillBeginDecelerating");
	[ScrollView setUserInteractionEnabled:YES] ;
	if (!isZooming) {
		startPoint = ScrollView.contentOffset ;
		[ScrollView setUserInteractionEnabled:NO];
		//		UIScrollViewZoom_DetailView * temp = [infoArray objectAtIndex:currectPage+arrayNo];
		//		CGSize imgsize = temp.frame.size;
		//		CGRect newrect = CGRectMake(CGRectGetWidth(self.frame)-imgsize.width/2 , CGRectGetHeight(self.frame)-imgsize.height/2, imgsize.width, imgsize.height);
		//		ScrollView.frame =newrect;
	}
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	
	if (scrollViewMode !=ScrollViewZoomModeZooming) {
		
		//在边界...
		if (scrollView.contentOffset.x >= scrollView.contentSize.width - scrollView.frame.size.width
            || scrollView.contentOffset.x <= 0) {
			[scrollView setUserInteractionEnabled:YES] ;
			return ;
		}
        
		
		
		if (startPoint.x > scrollView.contentOffset.x) {//左移
			
			[self leftPageDo];
			
		}
		else {//右移
			[self rightPageDo];
		}
	}
	//防止正在加载view时,拖动scrollview,造成未知错误
	[scrollView setUserInteractionEnabled:YES] ;
	return;
}


- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
	if (scrollViewMode == ScrollViewZoomModePaging)
	{
		float page = roundf(ScrollView.contentOffset.x / [self pageSize].width);
		//		if (!page && currectPage != 1) {
		//			return;
		//		}
		[self setCurrentPage:page];
		
	}
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
	//NSLog(@"scrollViewDidZoom");
	if (pendingOffsetDelta > 0) {
		[self setViewCenter];
	}
	
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)aScrollView {
	//NSLog(@"viewForZoomingInScrollView,%f,currectPage = %d, Min = %d", aScrollView.contentOffset.x, currectPage, Min);
	return [infoArray objectAtIndex:currectPage-Min];
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
	//NSLog(@"scrollViewWillBeginZooming");
	if (scrollViewMode != ScrollViewZoomModeZooming)
	{
		[self setZoomingMode];
		
	}
}

- (void)scrollViewDidEndZooming:(UIScrollView *)aScrollView withView:(UIView *)view atScale:(float)scale {
	    
	//NSLog(@"scrollViewDidEndZooming");
	if (ScrollView.zoomScale == ScrollView.minimumZoomScale)
	{
		
		[self setPagingMode];
		isZooming = NO;
	}
	
	else if (pendingOffsetDelta > 0) {
		
		[self setViewCenter];
		//NSLog(@"currectPage = %d, Min = $d,pendingOffsetDelta = %f,ScrollView.contentSize is %@",currectPage,Min,pendingOffsetDelta,NSStringFromCGSize(ScrollView.contentSize));
	}
	
}





- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	//NSLog(@"didRotateFromInterfaceOrientation");
	if (scrollViewMode == ScrollViewZoomModePaging) {
		scrollViewMode = ScrollViewZoomModeNotInitialized;
		[self setPagingMode];
	} else {
		[self setZoomingMode];
	}
}

- (void)setCurrentPage:(NSUInteger)page {
	
	if (page == currectPage)
		return;
	if (page >= total) {
		return;
	}
	int test = currectPage - page;
	//NSLog(@"fabs(currectPage - page) = %f,currectPage - page = %d",fabs((float)(test)),currectPage - page);
	//TODO: 解决currectpage为0问题
	if (fabs(test) > 1) {
		//NSLog(@"\n\n\n\n\n\n\n\n\n\n@@@@@@@@@@@@@@@@@@@ page = %d,currectPage = %d\n\n\n\n\n\n\n\n\n\n",page,currectPage);
		[self setPagingMode];
		return;
	}
	
	lastPage = currectPage;
	currectPage = page;
	
    
    if ([delegate respondsToSelector:@selector(ReyScrollViewDidChangedPage:page:)]) {
        [delegate ReyScrollViewDidChangedPage:self page:page];
    }
}
- (CGSize)pageSize {
	CGSize pageSize = ScrollView.frame.size;
	//NSLog(@"ScrollView.zoomScale = %f,pageSize is %@,ScrollView.contentSize is %@",ScrollView.zoomScale,NSStringFromCGSize(pageSize),NSStringFromCGSize(ScrollView.contentSize));
	return pageSize;
}

- (void)setPagingMode {
	// reposition pages side by side, add them back to the view
	//NSLog(@"setPagingMode");
	CGSize pageSize = [self pageSize];
	NSUInteger page = Min;
	for (UIView *view in infoArray) {
		if (!view.superview)
        {
            [ScrollView addSubview:view];
            [ScrollView bringSubviewToFront:m_isZoomingView];
        }
			
		view.frame = CGRectMake(pageSize.width * page++, 0, pageSize.width, pageSize.height);
		for (UIView * subView in view.subviews) {
			subView.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
			[subView setNeedsDisplay];
		}
	}
	isZooming = NO;
	ScrollView.pagingEnabled = YES;
	ScrollView.showsVerticalScrollIndicator =  NO;
	ScrollView.contentSize = CGSizeMake(pageSize.width * total, pageSize.height);
	ScrollView.contentOffset = CGPointMake(pageSize.width * currectPage, 0);
	
	scrollViewMode = ScrollViewZoomModePaging;
	//NSLog(@"pageSize = %@ , total = %d",NSStringFromCGSize(pageSize),total);
}

- (void)setZoomingMode {
	//NSLog(@"setZoomingMode");
	scrollViewMode = ScrollViewZoomModeZooming; // has to be set early, or else currentPage will be mistakenly reset by scrollViewDidScroll
	
	// hide all pages except the current one
	NSUInteger page = 0;
	//	CGSize pageSize = [self pageSize];
	for (UIView *view in infoArray)
	{
		//NSLog(@"setZoomingMode  %@",NSStringFromCGRect(view.frame));
		if (currectPage-Min != page++)
			[view removeFromSuperview];
		else {
            
            //释放之前的放大view
            if (m_isZoomingView) {
                [m_isZoomingView release];
            }
            
            m_isZoomingView = [view retain];
			view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
			for (UIView * subView in view.subviews) {
				subView.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
				[subView setNeedsDisplay];
			}
		}
		
	}
	
	
	isZooming = YES;
	ScrollView.pagingEnabled = NO;
	ScrollView.showsVerticalScrollIndicator = ScrollView.showsHorizontalScrollIndicator = YES;
	pendingOffsetDelta = ScrollView.contentOffset.x;
	ScrollView.bouncesZoom = YES;
	if (pendingOffsetDelta > 0) {
		
		[self setViewCenter];
	}
}

-(void )setViewCenter
{
	UIView *view = [infoArray objectAtIndex:currectPage-Min];
	view.center = CGPointMake(view.center.x - pendingOffsetDelta, view.center.y);
	CGSize pageSize = [self pageSize];
	ScrollView.contentOffset = CGPointMake(ScrollView.contentOffset.x - pendingOffsetDelta, ScrollView.contentOffset.y);
	ScrollView.contentSize = CGSizeMake(pageSize.width * ScrollView.zoomScale, pageSize.height * ScrollView.zoomScale);
	view.frame = CGRectMake(0, 0, pageSize.width * ScrollView.zoomScale, pageSize.height * ScrollView.zoomScale);
	pendingOffsetDelta = 0;
}

#pragma mark -

#pragma mark -
#pragma mark common function
-(UIImage*)getImageFormFileName:(NSString*)imgName
{
	NSRange hRange = [imgName rangeOfString:@"."] ;
	NSRange bRange = hRange ;
	hRange.length = hRange.location ;
	hRange.location = 0 ;
	
	bRange.length = [imgName length] - hRange.length - 1 ;
	bRange.location += 1 ;
	
	NSString *path= [[NSBundle mainBundle]pathForResource:imgName
												   ofType:nil];
	
	return [UIImage imageWithContentsOfFile:path] ;
}

- (UIImage*)scaleToSize:(UIImage*)img size:(CGSize)size  
{  
    // 创建一个bitmap的context  
    // 并把它设置成为当前正在使用的context  
    UIGraphicsBeginImageContext(size);  
    // 绘制改变大小的图片  
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];  
    // 从当前context中创建一个改变大小后的图片  
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();  
    // 使当前的context出堆栈  
    UIGraphicsEndImageContext();  
    // 返回新的改变大小后的图片  
    return scaledImage;  
} 
#pragma mark -
@end
