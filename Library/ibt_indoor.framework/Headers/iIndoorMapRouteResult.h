//
//  iIndoorMapRouteResult.h
//  iIndoorMapView
//
//  Created by admin on 8/5/15.
//  Copyright (c) 2015 imapview. All rights reserved.
//

/**
 *  类
 *
 *  导航路段类
 *     表示导航结果中的一段
 *     该路段位于同一楼层 
 */
@interface iIndoorMapRouteStep : NSObject

/**
 *  该导航路段的长度(以米为单位)
 */
@property (nonatomic, assign) float distance;
/**
 *  该导航路段所在的楼层名字
 */
@property (nonatomic, strong) NSString *floorName;
/**
 *  该导航路段所在的楼层id
 */
@property (nonatomic, assign) int floorID;

@end


/**
 *  类
 *
 *  导航结果类, 可能包括1到多个导航路段
 */
@interface iIndoorMapRouteResult : NSObject

/**
 *  本次导航结果中包含的导航路段数目
 */
@property (nonatomic, assign) int stepCount;
/**
 *  本次导航结果中包含的导航路段列表
 */
@property (nonatomic, strong) NSMutableArray *routeSteps;
/**
 *  本次导航结果中总共经过的距离
 */
@property (nonatomic, assign) float totalDistance;

@end
