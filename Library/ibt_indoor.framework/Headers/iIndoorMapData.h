//
//  iIndoorMapData.h
//  iIndoorMapView
//
//  Created by admin on 8/13/15.
//  Copyright (c) 2015 imapview. All rights reserved.
//

/** 协议
 *
 *  获取数据接口的相关回调。
 */
@protocol iIndoorMapDataDelegate <NSObject>
/**
 * @brief 事件:获取了某个主体的floor列表
 *
 * @param 无
 *
 * @return 包含iIndoorMapFloor的数组
 */
@optional - (void)onFloors:(NSArray *)floors;

/**
 * @brief 事件:获取了某个主体的poi列表
 *
 * @param 无
 *
 * @return 包含iIndoorMapPOI的数组
 */
@optional - (void)onPOIs: (NSArray *)pois;
@end

/**
 *  类
 *
 *  iIndoorMapData类
 *     用于获取某个主体中的POI信息和层信息
 */
@interface iIndoorMapData : NSObject

/**
 * @brief 获取某个主体的所有floor信息
 *
 * @param subjectID 主体ID
 *
 * @return 无
 */
+ (void) getAllFloors:(int)subjectID WithDelegate: (NSObject<iIndoorMapDataDelegate> *)delegate;

/**
 * @brief 获取某个主体的所有POI信息
 *
 * @param subjectID 主体ID
 *
 * @return 无
 */
+ (void) getAllPOIs:(int)subjectID WithDelegate: (NSObject<iIndoorMapDataDelegate> *)delegate;

/**
 * @brief 设置数据下载时的服务器地址
 *
 * @param url 服务器地址
 *
 * @return 无
 */
+ (void) setServerURL: (NSString *)url;

@end