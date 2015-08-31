//
//  iIndoorMapInfoWindow.h
//  iIndoorMapView
//
//  Created by admin on 8/6/15.
//  Copyright (c) 2015 imapview. All rights reserved.
//
#import <UIKit/UIKit.h>

/**
 *  类
 *
 *  信息窗口类, 可用于在地图中的某个位置添加包含UIView的信息窗口(该UIView可以点击)
 */
@interface iIndoorMapInfoWindow : NSObject
/**
 *  该window包含的UIView
 */
@property (nonatomic, strong) UIView *view;
/**
 *  该UIView所依附到的floor的id
 */
@property (nonatomic, assign) int floorID;
/**
 *  z方向坐标,越大越在上方
 */
@property (nonatomic, assign) int zOrder;

/**
 *  该UIView所在地图的X轴方向的坐标(与该位置中间对齐)
 */
@property (nonatomic, assign) float x;
/**
 *  该UIView所在地图的Y轴方向的坐标(与该位置底部对齐)
 */
@property (nonatomic, assign) float y;

/**
 *  该UIView在屏幕上X轴方向的坐标(与该位置中间对齐)
 */
@property (nonatomic, assign) float screenX;
/**
 *  该UIView在屏幕上Y轴方向的坐标(与该位置底部对齐)
 */
@property (nonatomic, assign) float screenY;

/**
 * @brief 初始化
 *
 * @param view 地图加载所在的view
 *        zorder 该infowindow在z方向上的值
 *        x  x轴方向的坐标
 *        y  y轴方向的坐标
 *
 * @return iIndoorMapBitmapOverlay对象
 */
- (id) initWithView: (UIView *)view Zorder:(int)zorder X:(float)x AndY:(float)y;

@end