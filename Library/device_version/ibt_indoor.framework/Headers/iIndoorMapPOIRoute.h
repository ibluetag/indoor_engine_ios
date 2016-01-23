//
//  iIndoorMapPOIRoute.h
//  iIndoorMapView
//
//  Created by admin on 8/6/15.
//  Copyright (c) 2015 imapview. All rights reserved.
//
#import "iIndoorMapView.h"

/**
 *  类
 *
 *  POI导航类, 用于设置POI导航的参数以及发起导航
 */
@interface iIndoorMapPOIRoute : NSObject
/**
 *  导航时的规则
 *      0: 电梯优先;
 *      1: 扶梯优先
 *      2: 楼梯优先
 */
@property (nonatomic, assign) int routeRule;

/**
 *  地图加载时构建的iIndoorMapView
 */
@property (nonatomic, weak) iIndoorMapView *map_view;

/**
 * @brief 初始化
 *
 * @param view 已加载了地图的iIndoorMapView
 *
 * @return iIndoorMapPOIRoute对象
 */
- (id) initWithMapView:(iIndoorMapView *)view;

/**
 * @brief 在当前地图中设置导航起点POI
 *
 * @param id 起点POI的id
 *
 * @return 无
 */
- (void) setRouteStartPOI:(int64_t)id;

/**
 * @brief 在当前地图中设置导航终点POI
 *
 * @param id 终点POI的id
 *
 * @return 无
 */
- (void) setRouteEndPOI:(int64_t)id;

/**
 * @brief 在当前地图中设置导航起点位置
 *
 * @param x 起点的x坐标
 *        y 起点的y坐标
 *
 * @return 无
 */
- (void) setRouteStartPositionX:(float)x AndY: (float) y;

/**
 * @brief 在当前地图中设置导航终点位置
 *
 * @param x 终点的x坐标
 *        y 终点的y坐标
 *
 * @return 无
 */
- (void) setRouteEndPositionX:(float)x AndY: (float) y;

/**
 * @brief 计算导航路径
 *
 * @param 无
 *
 * @return 无
 */
- (void) calc;

/**
 * @brief 清除导航路径
 *
 * @param 无
 *
 * @return 无
 */
- (void) clear;

//set locating bitmap
- (void) setLocationAngleBitmap: (bool) angle;

//get the bitmap of locating
- (bool) getLocationAngleBitmap;

@end
