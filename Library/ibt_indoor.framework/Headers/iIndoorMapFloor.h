//
//  iIndoorMapFloor.h
//  iIndoorMapView
//
//  Created by admin on 8/5/15.
//  Copyright (c) 2015 imapview. All rights reserved.
//

/**
 *  类
 *
 *  楼层类
 *     表示建筑物中的楼层,每个楼层有一张对应的地图
 */
@interface iIndoorMapFloor : NSObject

/**
 *  floor的唯一id,用于标识floor
 */
@property (nonatomic, assign) int floorID;
/**
 *  floor的名字
 */
@property (nonatomic, strong) NSString *floorName;
/**
 *  floor所在building的名字
 */
@property (nonatomic, strong) NSString *buildingName;
/**
 *  floor所在building的id
 */
@property (nonatomic, assign) int buildingID;

/**
 *  floor对应地图的宽度(用pixel数表示)
 */
@property (nonatomic, assign) float pixelWidth;
/**
 *  floor对应地图的高度(用pixel数表示)
 */
@property (nonatomic, assign) float pixelHeight;
/**
 *  floor对应地图的原始标尺比例(每个pixel对应多少米)
 */
@property (nonatomic, assign) float proportion;

/**
 * @brief 初始化floor对象
 *
 * @param fId 对应的地图ID
 *
 * @return floor对象
 */
- (id) initWithID:(int)fId;

/**
 * @brief 打印出floor对象的信息
 *
 * @param 无
 *
 * @return 无
 */
- (void) print;

/**
 * @brief 判断楼层是否有多区域。
 *
 * @param 无
 *
 * @return 有多区返回YES
 */
- (BOOL) hasMultiAreas;

@end
