/************************************************* 
 
 Copyright (C), 2010-2015, Rey mail=>rey0@qq.com. 
 
 File name:	ReyScrollView.h	
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2010/12/21 
 
 Description: 
 
 用于显示带放大效果的滚动视图
 
 Others: 
 
 
 
 forShort：
 
 
 History:  
 
 2012-11-20 By Rey      添加双击放大,缩小动画.并添加m_isZoomingView以确保动画流畅.

 
 *************************************************/ 
#import <UIKit/UIKit.h>


/**************************************************
 name:	ScrollViewZoomMode
 
 description:  用于保存滚动视图的模式
 
 values: UIImage
 
 calledby:  
 
 1.initWithFrame: URL:
 
 2.drawRect:
 
 3.DownloadImageFinished:
 
 **************************************************/

typedef enum {
	ScrollViewZoomModeNotInitialized = 0,           // view has just been loaded
	ScrollViewZoomModePaging = 1,                   // fully zoomed out, swiping enabled
	ScrollViewZoomModeZooming = 2,                  // zoomed in, panning enabled
} ScrollViewZoomMode;


@protocol ReyScrollViewDataSource;

@protocol ReyScrollViewDelegate;


@interface ReyScrollView : UIView
	<UIScrollViewDelegate>
{
    
    
	/**************************************************
	 name:	m_isZoomingView
	 
	 description:  放大模式中的view.
	 
	 calledby:
	 
	 
	 **************************************************/
    UIView * m_isZoomingView;

	/**************************************************
	 name:	ScrollView
	 
	 description:  视图中主要的scrollview,所有操作都在其上进行
	 
	 calledby:  
	 
	 
	 **************************************************/
	UIScrollView * ScrollView;
    
    
    /**************************************************
	 name:	datasource
	 
	 description:  委托
	 
	 calledby:
	 
	 
	 **************************************************/
    id<ReyScrollViewDataSource> datasource;
    
    
    /**************************************************
	 name:	delegate
	 
	 description:  委托
	 
	 calledby:
	 
	 
	 **************************************************/
    id<ReyScrollViewDelegate> delegate;
    
    /**************************************************
	 name:	m_detailViewCount
	 
	 description:  scrollview上加载子view的个数
	 
	 calledby:
	 
	 
	 **************************************************/
    int m_detailViewCount;
	
	
	
	/**************************************************
	 name:	infoArray
	 
	 description:  加载视图的数组,主要用于delay模式的加载
	 
	 calledby:  
	 
	 
	 **************************************************/
	NSMutableArray * infoArray ;
	/**************************************************
	 name:	startPoint
	 
	 description:  scroll动作的开始点,用于判断是否加载下一视图,并删除相反方向的视图
	 
	 calledby:  
	 
	 
	 **************************************************/
	CGPoint startPoint ;
	/**************************************************
	 name:	Min
	 
	 description:  infoArray中最左边视图,在所有视图数组中它对应的下标.主要用于判断是否要加载左边的视图,如果min=0,则不需要加载
	 
	 calledby:  
	 
	 
	 **************************************************/
	int	Min ;
	/**************************************************
	 name:	Max
	 
	 description:  infoArray中最右边视图,在所有视图数组中它对应的下标.主要用于判断是否要加载右边的视图,如果max=total,则不需要加载
	 
	 calledby:  
	 
	 
	 **************************************************/
	int Max ;
	/**************************************************
	 name:	total
	 
	 description:  所有需要加载视图的总个数.
	 
	 calledby:  
	 
	 
	 **************************************************/
	int total;
	


	/**************************************************
	 name:	currectPage
	 
	 description:  保存当前显示的视图下标.
	 
	 calledby:  
	 
	 
	 **************************************************/
	int currectPage;
	/**************************************************
	 name:	lastPage
	 
	 description:  上次操作前的页面视图下标.
	 
	 calledby:  
	 
	 
	 **************************************************/
	int lastPage;
	/**************************************************
	 name:	scrollViewMode
	 
	 description:  scrollview所处的状态.
	 
	 calledby:  
	 
	 
	 **************************************************/
	ScrollViewZoomMode scrollViewMode;
	/**************************************************
	 name:	pendingOffsetDelta
	 
	 description:  改变状态前的contentOffset.x
	 
	 calledby:  
	 
	 
	 **************************************************/
	CGFloat pendingOffsetDelta;
	
	
	/**************************************************
	 name:	isZooming
	 
	 description:  当前状态是否为放大
	 
	 calledby:  
	 
	 
	 **************************************************/
	bool isZooming;//是否放大
	/**************************************************
	 name:	infoArrayCount
	 
	 description:  规定infoArray的个数,必须为奇数.目前设定为5
	 
	 calledby:  
	 
	 
	 **************************************************/
	int infoArrayCount; //infoArray的个数
	
	/**************************************************
	 name:	isMax
	 
	 description:  page是否移到最右端,不用再加载页面.Max == total - 1 
	 
	 calledby:  
	 
	 
	 **************************************************/
	bool isMax;//page移到最右端,不用再加载页面
	/**************************************************
	 name:	isMin
	 
	 description:  page是否移到最左端,不用再加载页面.Min == 0
	 
	 calledby:  
	 
	 
	 **************************************************/
	bool isMin;//page移到最左端,不用再加载页面
}


@property (nonatomic , retain) UIScrollView * ScrollView;
@property (nonatomic , assign) id<ReyScrollViewDataSource> datasource;
@property (nonatomic , assign) id<ReyScrollViewDelegate> delegate;



@property (nonatomic) bool isMin;
@property (nonatomic) bool isMax;

@property (nonatomic) int Min ;
@property (nonatomic) int Max ;
@property (nonatomic) int total;
@property (nonatomic) CGPoint startPoint ;
@property (nonatomic,retain) NSMutableArray * infoArray ;


@property (nonatomic) int currectPage;
@property (nonatomic) int lastPage;

@property bool isZooming;
@property int infoArrayCount;
@property (nonatomic) ScrollViewZoomMode scrollViewMode;

@property (nonatomic,retain) UIView * m_isZoomingView;


/************************************************* 
 
 Function: pageSize
 
 Description: 获得scrollview当前大小
 
 Input: 
 
 Output:  
 
 Return: 
 
 Others: 
 
 *************************************************/
- (CGSize)pageSize ;

/************************************************* 
 
 Function: setCurrentPage:
 
 Description: 设定当前页currectPage
 
 Input: 
 
 page:		ScrollView.contentOffset.x / [self pageSize].width的四舍五入结果
 
 Output:  
 
 Return: 
 
 Others: 
 
 *************************************************/
- (void)setCurrentPage:(NSUInteger)page ;

/************************************************* 
 
 Function: setPagingMode
 
 Description: 设置当前scrollview模式为翻页模式
 
 Input: 
 
 Output:  
 
 Return: 
 
 Others: 
 
 *************************************************/
- (void)setPagingMode;

/************************************************* 
 
 Function: setZoomingMode
 
 Description: 设置当前scrollview模式为缩放模式
 
 Input: 
 
 Output:  
 
 Return: 
 
 Others: 
 
 *************************************************/
- (void)setZoomingMode ;


/************************************************* 
 
 Function: CreatDetail
 
 Description: 初始化scrollview
 
 Input: 
 
 Output:  
 
 Return: 
 
 Others: 
 
 *************************************************/
-(void)CreatDetail;

/************************************************* 
 
 Function: AddViewForScrollView: array: myView:
 
 Description: 读取图片信息,如果需要改读取数据问题请重载这个函数
 
 Input: 
 
 i:				要加载DicAllPages中第i个view
 
 array:			第i个view对应的image和text的数据数组
 
 Mysubview:		要把第i个view的superview
 
 Output:  
 
 Return: 
 
 Others: 
 
 *************************************************/
-(void)AddViewForScrollView:(int)i myView:(UIView*)Mysubview;

/************************************************* 
 
 Function: AddViewToArray: order: 
 
 Description: 把view添加到infoArray数组中
 
 Input: 
 
 myView:		要添加的view
 
 order:			要添加view在infoArray的左边还是右边
 
 Output:  
 
 Return: 
 
 Others: 
 
 *************************************************/
-(void)AddViewToArray:(UIView*)myView order:(BOOL)bLeft ;

/************************************************* 
 
 Function: isMidCurrectPages:  
 
 Description: 判断当前页数在infoArray中是不是在中间位置,infoArray的个数必须是奇数
 
 Input: 
 
 currectPageNO:	但前页数
 
 Output:  
 
 Return: 
 
 Others: 
 
 *************************************************/
-(bool )isMidCurrectPages:(int)currectPageNO;

/************************************************* 
 
 Function: initWithFrame:  plistName:  searchKey:
 
 Description: 初始化本类
 
 Input: 
 
 count:		子view个数
 
 Output:  
 
 Return: 
 
 Others: 
 
 *************************************************/
- (id)initWithFrame:(CGRect)frame
         datasource:(id<ReyScrollViewDataSource>)adataSource
              count:(int )count;

/************************************************* 
 
 Function: initWithFrame:  plistName:  searchKey:  index:
 
 Description: 初始化本类
 
 Input: 
 
 count:		子view个数

 index:			初始化currectPage的大小
 
 Output:  
 
 Return: 
 
 Others: 
 
 *************************************************/
- (id)initWithFrame:(CGRect)frame
         datasource:(id<ReyScrollViewDataSource>)adataSource
              count:(int )count
              index:(int)index;

/************************************************* 
 
 Function: setViewCenter  
 
 Description: ScrollViewZoomModeZooming模式中设定view的位置
 
 Input: 
 
 Output:  
 
 Return: 
 
 Others: 
 
 *************************************************/
-(void )setViewCenter;

/************************************************* 
 
 Function: RestoreZooming:  
 
 Description:	响应双击事件
 
 Input: 
 
 location:		双击事件中触点在view中的位置
 
 Output:  
 
 Return: 
 
 Others: 
 
 *************************************************/
-(void )RestoreZooming:(CGPoint)location;

/************************************************* 
 
 Function: addRightView  
 
 Description:	向右翻页动作时,添加视图
 
 Input: 
 
 Output:  
 
 Return: 
 
 Others: 
 
 *************************************************/
-(void )addRightView;

/************************************************* 
 
 Function: addLeftView  
 
 Description:	向左翻页动作时,添加视图
 
 Input: 
 
 Output:  
 
 Return: 
 
 Others: 
 
 *************************************************/
-(void )addLeftView;


/************************************************* 
 
 Function: leftPageDo  
 
 Description:	向左翻页的实现
 
 Input: 
 
 Output:  
 
 Return: 
 
 Others: 
 
 *************************************************/
-(void)leftPageDo;

/************************************************* 
 
 Function: rightPageDo  
 
 Description:	向右翻页的实现
 
 Input: 
 
 Output:  
 
 Return: 
 
 Others: 
 
 *************************************************/
-(void)rightPageDo;

/************************************************* 
 
 Function: setScrollViewModeNotInitialized  
 
 Description:	设定scrollviewmode为NotInitialized  
 
 Input: 
 
 Output:  
 
 Return: 
 
 Others: 
 
 *************************************************/
-(void)setScrollViewModeNotInitialized;

/************************************************* 
 
 Function: setScrollViewModePaging  
 
 Description:	设定scrollviewmode为Paging
 
 Input: 
 
 Output:  
 
 Return: 
 
 Others: 
 
 *************************************************/
-(void)setScrollViewModePaging;
@end


@protocol ReyScrollViewDelegate <NSObject>

-(void)ReyScrollViewDidChangedPage:(ReyScrollView *)sender page:(int)page;

@end

@protocol ReyScrollViewDataSource <NSObject>

-(UIView *)ReyScrollViewDetailView:(ReyScrollView *)sender index:(int)index superView:(UIView *)superView;

@end
