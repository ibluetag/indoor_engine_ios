//
//  iMapSettingViewController.h
//  iIndoorMapView
//
//  Created by wuzhiji37 on 15/7/22.
//  Copyright (c) 2015年 __ibluetag__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ibt_indoor/iIndoorMapView.h>

#define UI_SETTING_LABEL_WIDTH 120
#define UI_SETTING_LABEL_WIDTH_LARGE 200

#define UI_TEST_BUTTON_WIDTH	72
#define UI_TEST_BUTTON_HEIGHT	32

#define DEFAULT_MAP_SERVER @"http://a.imapview.com/"
#define DEFAULT_MAP_SUBJECT_ID 6
#define DEFAULT_LOCATE_TARGET @"80:71:7A:8C:17:93"
#define DEFAULT_ROUTE_ATTACH_THRESHOLD 5.0f
#define DEFAULT_ROUTE_DEVIATE_THRESHOLD 10.0f
#define DEFAULT_ROUTE_RULE 3
#define DEFAULT_ROUTE_SMOOTH 0

#define MAP_LOAD_MODE_NORMAL @"normal"
#define MAP_LOAD_MODE_POI_SELECT @"poi_selected"
#define MAP_LOAD_MODE_POI_ROUTE @"poi_route"

@interface iMapSettingViewController : UIViewController

@property int mapid;
@property NSString* targetMac;

@property iIndoorMapView* mapView;

@end
