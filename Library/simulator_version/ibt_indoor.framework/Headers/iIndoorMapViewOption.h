//
//  iIndoorMapViewOption.h
//  testIndoorEngine
//
//  Created by admin on 8/5/15.
//  Copyright (c) 2015 imapview. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  类
 *
 *  iIndoorMapViewOption类,用于设置iIndoorMapView中的控件是否可见
 */
@interface iIndoorMapViewOption : NSObject
/**
 *  标志: 是否打开sdk自带的楼层切换控件
 */
@property (nonatomic, assign) BOOL enableFloorSelectView;
/**
 *  标志: 是否打开sdk自带的导航结果展示控件
 */
@property (nonatomic, assign) BOOL enableRouteSelectView;
/**
 *  标志: 是否打开sdk自带的导航起点/终点选择控件
 */
@property (nonatomic, assign) BOOL enableStartAndEndView;
/**
 *  标志: 是否打开sdk自带的缩放&标尺控件
 */
@property (nonatomic, assign) BOOL enableScaleView;
@end
