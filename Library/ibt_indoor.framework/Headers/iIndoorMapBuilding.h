//
//  iIndoorMapBuilding.h
//  iIndoorMapView
//
//  Created by admin on 8/5/15.
//  Copyright (c) 2015 imapview. All rights reserved.
//

/**
 *  类
 *
 *  建筑物类, 可以有多个楼层,每个楼层有一张对应的地图
 */
@interface iIndoorMapBuilding : NSObject

/**
 *  building的id,用于标识building
 */
@property (nonatomic, assign) int buildID;
/**
 *  building的名字
 */
@property (nonatomic, strong) NSString *buildingName;
/**
 *  building里面包含的楼层数目
 */
@property (nonatomic, assign) int floorCount;
/**
 *  building所在的地图主体的id
 */
@property (nonatomic, assign) int eventID;

/**
 *  building里面包含的所有楼层的id
 */
@property (nonatomic, strong) NSArray *floorIDs;
/**
 *  building里面包含的所有楼层的名字
 */
@property (nonatomic, strong) NSArray *floorNames;

/**
 * @brief 初始化building对象
 *
 * @param bId building ID
 *
 * @return building对象
 */
- (id) initWithID:(int)bId;
@end