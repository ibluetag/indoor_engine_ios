//
//  iIndoorMapView.h
//  iIndoorMapView
//
//  Created by wuzhiji37 on 15/7/20.
//  Copyright (c) 2015年 __ibluetag__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iIndoorMapDelegate.h"
#import "iIndoorMapViewOption.h"
#import "iIndoorMapInfoWindow.h"

/** 类
 *
 *  iIndoorMapView类，包括地图以及基础控件。
 */
@interface iIndoorMapView : UIView

@property (nonatomic, assign) iIndoorMapViewOption *mapViewOption;

/**
 * @brief 初始化方法
 *
 * @param frame iIndoorMapView的大小
 *
 * @return iIndoorMapView实例
 */
- (instancetype)initWithFrame:(CGRect)frame;
/**
 * @brief 设置地图服务器网址
 *
 * @param mapServer 地图服务器网址
 *
 * @return 无
 */
- (void)setMapServer:(NSString *)mapServer;
/**
 * @brief 销毁地图
 *
 * @param 无
 *
 * @return 无
 */
- (void)destroyMap;
/**
 * @brief 加载某个展会的地图
 *
 * @param mapID 展会id
 *
 * @return 无
 */
- (void)loadMap:(int)mapID;
/**
 * @brief 暂停地图，用于地图在后台的情况
 *
 * @param 无
 *
 * @return 无
 */
- (void)pauseMap;
/**
 * @brief 获取当前正在显示的地图大小
 *
 * @param 无
 *
 * @return 一个二元数组，表示长与宽
 */
- (NSMutableArray *)getCurrentMapSize;
/**
 * @brief 切换至某一层的地图
 *
 * @param floorIndex 层数(0位底层)
 *
 * @return 返回0为成功，否则失败
 */
- (int) gotoFloorByIndex:(int)floorIndex;
/**
 * @brief 切换至某一层的地图
 *
 * @param floorID 楼层id
 *
 * @return 返回0为成功，否则失败
 */
- (int) gotoFloorByID:(int)floorID;
/**
 * @brief 获取某个building里面的所有层的名字
 *
 * @param 无
 *
 * @return 一个数组，含有所有层的名字
 */
- (NSMutableArray *)getFloorNames;
/**
 * @brief 获取某个building里面的所有层的id
 *
 * @param 无
 *
 * @return 一个数组，含有所有层的id
 */
- (NSMutableArray *)getFloorIDs;
/**
 * @brief 获取当前显示地图的id
 *
 * @param 无
 *
 * @return 当前显示地图的id
 */
- (int)getCurrentFloorID;
/**
 * @brief 获取展会或者商场的名字
 *
 * @param 无
 *
 * @return 展会或者商场的名字
 */
- (NSString *)getExhibitName;
/**
 * @brief 获取当前地图的状态
 *
 * @param 无
 *
 * @return 2表示outdoor,3表示indoor,0/1均表示没有地图
 */
- (int) getExhibitState;
/**
 * @brief 获取当前building的名字
 *
 * @param 无
 *
 * @return 当前building的名字
 */
- (NSString *)getCurBuildingName;
/**
 * @brief 获取某个unit的名字
 *
 * @param unitID unitID
 *
 * @return 某个unit的名字
 */
- (NSString *)getUnitName:(NSInteger)unitID;
/**
 * @brief 获取某个unit的描述
 *
 * @param unitID unitID
 *
 * @return 某个unit的描述
 */
- (NSString *)getUnitDescription:(NSInteger)unitID;
/**
 * @brief 获取某个unit的中心位置
 *
 * @param unitID unitID
 *
 * @return 某个unit的中心位置
 */
- (NSMutableArray *)getUnitPosition:(NSInteger)unitID;
/**
 * @brief 获取当前缩放比例
 *
 * @param 无
 *
 * @return 当前缩放比例
 */
- (float)getCurrentZoomRatio;
/**
 * @brief 获取当前标尺比例, 1 个pixel对应多少米
 *
 * @param 无
 *
 * @return 当前标尺比例
 */
- (float)getCurrentProportion;
/**
 * @brief 获取当前已经旋转的角度
 *
 * @param 无
 *
 * @return 当前已经旋转的角度
 */
- (float)getCurrentRotateAngle;
/**
 * @brief 放大/缩小当前地图
 *
 * @param step 大于0放大，小于0缩小
 *
 * @return 返回0为成功，否则失败
 */
- (int)scaleMap:(int)step;
/**
 * @brief 旋转当前地图
 *
 * @param angle 地图向顺时针旋转angle弧度
 *
 * @return 返回0为成功，否则失败
 */
- (int)rotateMap:(float)angle;
/**
 * @brief 当前地图内查找
 *
 * @param name 查找的内容
 *
 * @return 返回寻找到的个数
 */
- (int)searchByName:(NSString *)name;
/**
 * @brief 清楚查找痕迹
 *
 * @param 无
 *
 * @return 返回0为成功，否则失败
 */
- (int)searchClear;
/**
 * @brief 设置定位目标
 *
 * @param mac 定位目标mac地址
 *
 * @return 无
 */
- (void)setLocateTarget:(NSString *)mac;
/**
 * @brief 设置路径吸附距离阈值。
 *
 * @param distance 路径吸附距离阈值，单位为米
 *
 * @return 无
 */
- (void)setRouteAttachDistance:(float)distance;
/**
 * @brief 设置导航偏离判定距离阈值。
 *
 * @param distance 导航偏离判定距离阈值，单位为米
 *
 * @return 无
 */
- (void)setRouteDeviateDistance:(float)distance;
/**
 * @brief 设置导航路径规则，0为电梯优先，1为扶梯优先，2为楼梯优先。
 *
 * @param rule 导航路径规则
 *
 * @return 无
 */
- (void)setRouteRule:(int)rule;
/**
 * @brief 获取native map view
 *
 * @param 无
 *
 * @return native map view指针
 */
- (void *)getNativeMapView;

/**
 * @brief 添加infowindow到当前地图
 *
 * @param window 待添加的info window
 *
 * @return 0表示成功,其他表示失败
 */
- (int)addMapInfoWindow:(iIndoorMapInfoWindow*)window;

/**
 * @brief 从当前地图移除infowindow
 *
 * @param window 待移除的info window
 *
 * @return 无
 */
- (void)removeMapInfoWindow:(iIndoorMapInfoWindow*)window;

/*
 ************************************************
           注册监听者/取消注册 相关接口
 ************************************************
 */
/**
 * @brief 注册zoom event监听者
 *
 * @param delegate 监听者对象
 *
 * @return 0表示成功, -1表示失败
 */

-(int) registerEventListener:(NSObject<iIndoorMapDelegate> *)delegate;

/**
 * @brief 取消注册zoom event监听者
 *
 * @param delegate 监听者对象
 *
 * @return 0表示成功, -1表示失败
 */
-(int) unregisterEventListener:(NSObject<iIndoorMapDelegate> *)delegate;

@end
