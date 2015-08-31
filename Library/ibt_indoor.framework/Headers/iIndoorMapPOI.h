//
//  iIndoorMapPOI.h
//  iIndoorMapView
//
//  Created by admin on 8/6/15.
//  Copyright (c) 2015 imapview. All rights reserved.
//
/**
 *  类
 *
 *  POI类, 表示地图中的POI
 */
@interface iIndoorMapPOI : NSObject
/**
 *  该POI的id,在当层floor中唯一
 *  (如果大于0,则全局唯一;如果小于0,则仅仅在当层floor中唯一,如果等于0,则是一个无效的id)
 */
@property (nonatomic, assign) int64_t poiID;
/**
 *  该POI所在floor的id
 */
@property (nonatomic, assign) int floorID;
/**
 *  该POI的名称
 */
@property (nonatomic, strong) NSString *poiName;
/**
 *  该POI的LABEL,在building中唯一
 */
@property (nonatomic, strong) NSString *poiLabel;
/**
 *  该POI所在地图的X轴方向的坐标
 */
@property (nonatomic, assign) float x;
/**
 *  该POI所在地图的Y轴方向的坐标
 */
@property (nonatomic, assign) float y;

@end