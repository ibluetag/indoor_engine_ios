//
//  iIndoorMapBitmapOverlay.h
//  iIndoorMapView
//
//  Created by admin on 8/6/15.
//  Copyright (c) 2015 imapview. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "iIndoorMapView.h"

/**
 *  类
 *
 *  图片覆盖物类, 可用于在地图中的某个位置添加图片覆盖物
 */
@interface iIndoorMapBitmapOverlay : NSObject

/**
 *  覆盖物图片
 */
@property (nonatomic, strong) UIImage *overlayImage;
/**
 *  地图加载时构建的iIndoorMapView
 */
@property (nonatomic, weak) iIndoorMapView *map_view;

/**
 * @brief 初始化
 *
 * @param view 地图加载所在的view
 *
 * @return iIndoorMapBitmapOverlay对象
 */
- (id) initWithMapView:(iIndoorMapView *)view;

/**
 * @brief 初始化
 *
 * @param view 地图加载所在的view
 *        image UIImage对象
 *
 * @return iIndoorMapBitmapOverlay对象
 */
- (id) initWithMapView:(iIndoorMapView *)view AndBitmap: (UIImage *)image;

/**
 * @brief 设置overlay在地图里面的坐标
 *
 * @param x X轴方向的坐标
 *        y Y轴方向的坐标
 *
 * @return 无
 */
- (void) setX:(float) x AndY: (float) y;

/**
 * @brief 将图片覆盖物添加到当前地图
 *
 * @param 无
 *
 * @return 0表示成功,其他表示失败
 */
- (int) attachToMap;

/**
 * @brief 将图片覆盖物添加到某个building的某层地图
 *
 * @param buidingID  building的id
 *        floorID    楼层的id
 *
 * @return 0表示成功,其他表示失败
 */
- (int) attachToMapWithBuilding: (int)buildingID AndFloor:(int) floorID;

/**
 * @brief 将图片覆盖物从所依附的地图中移除
 *
 * @param 无
 *
 * @return 0表示成功,其他表示失败
 */
- (int) deAttachFromMap;

/**
 * @brief 获取图片覆盖物所依附的地图的id
 *
 * @param 无
 *
 * @return 0表示没有依附,其他表示所依附的地图id
 */
- (int) getFloorID;


@end