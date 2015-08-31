//
//  iIndoorMapDelegate.h
//  testIndoorEngine
//
//  Created by admin on 8/2/15.
//  Copyright (c) 2015 imapview. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iIndoorMapBuilding.h"
#import "iIndoorMapFloor.h"
#import "iIndoorMapRouteResult.h"
#import "iIndoorMapPOI.h"

/** 协议
 *
 *  地图相关的事件回调。
 */
@protocol iIndoorMapDelegate <NSObject>

/**
 * @brief 地图加载成功后回调
 *
 * @param exhibitID 加载的地图主体id;
 *        floorID 加载的地图当前的floor ID
 *
 * @return 无
 */
@optional - (void)mapLoadFinishedWithExhibit:(int) exhibitID Floor: (int) floorID;

/**
 * @brief 地图加载失败后回调
 *
 * @param exhibitID 加载的地图主体id;
 *        errCode 错误代码
 *
 * @return 无
 */
@optional - (void)mapLoadErrorWithExhibit:(int) exhibitID Err: (int) errCode;

/**
 * @brief 事件: 切换到某一个building
 *
 * @param id building的id
 *
 * @return 无
 */
@optional - (void)buildingSwitchWithID: (int)id;
/**
 * @brief 事件: 切换到某一个building
 *
 * @param building iIndoorMapBuilding 对象
 *
 * @return 无
 */
@optional - (void)buildingSwitchWithObject: (iIndoorMapBuilding *)building;

/**
 * @brief 事件: 切换到某一层
 *
 * @param id floor的id
 *
 * @return 无
 */
@optional - (void)floorSwitchWithID: (int)id;
/**
 * @brief 事件: 切换到某一层
 *
 * @param floor iIndoorMapFloor 对象
 *
 * @return 无
 */
@optional - (void)floorSwitchWithObject: (iIndoorMapFloor *)floor;

/**
 * @brief 事件: 某个poi被选中
 *
 * @param poi POI对象
 *
 * @return 无
 */
@optional - (void)POISelected: (iIndoorMapPOI *)poi;


/**
 * @brief 事件: 当前缩放比例更新
 *
 * @param ratio 当前缩放比例
 *
 * @return 无
 */
@optional - (void)updateCurrentZoomRatio: (float)ratio;
/**
 ************************************
            导航相关回调
 ************************************
 */
/**
 * @brief 事件:导航完成
 *
 * @param result 保存导航结果,为nil表示导航失败
 *
 * @return
 */
@optional - (void)routeFinished: (iIndoorMapRouteResult *)result;

/**
 * @brief 事件:定位点偏离导航路线
 *
 * @param 无
 *
 * @return 无
 */
@optional - (void)routeOutOfPath;

/**
 * @brief 事件:进入导航结果展示模式
 *
 * @param  无
 *
 * @return 无
 */
@optional - (void)routeShowModeEnter;
/**
 * @brief 事件:退出导航结果展示模式
 *
 * @param 无
 *
 * @return 无
 */
@optional - (void)routeShowModeExit;
/**
 * @brief 事件:在导航结果展示模式下,前进到导航路径当前地图的下一层地图
 *
 * @param 无
 *
 * @return 无
 */
@optional - (void)routeShowModeForward;
/**
 * @brief 事件:在导航结果展示模式下,后退到导航路径当前梯度的上一层地图
 *
 * @param 无
 *
 * @return 无
 */
@optional - (void)routeShowModeBackward;
@end
