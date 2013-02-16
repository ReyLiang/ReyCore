/************************************************* 
 
 Copyright (C), 2010-2012, Rey. 
 
 File name:	I_ReyAnnotationView.h	
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2012/5/31
 
 Description: 
 
 地图中注解的基础类的一些继承需要重载的接口.
 委托.
 
 Others: 
 
 
 
 forShort：
 
 
 History:  
 
 
 
 *************************************************/ 

//TODO: 继承类需要实现的接口
@interface MKAnnotationView(ReyInterfaceDeclare)

//TODO: 继承类初始化其view
-(void)initSubviews;

@end


//TODO: 委托接口
@protocol ReyAnnotationViewDelegate <NSObject>


@end
