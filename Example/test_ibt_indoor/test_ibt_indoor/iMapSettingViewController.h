//
//  iMapSettingViewController.h
//  iIndoorMapView
//
//  Created by wuzhiji37 on 15/7/22.
//  Copyright (c) 2015年 __ibluetag__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UI_SETTING_LABEL_WIDTH 120
#define UI_SETTING_LABEL_WIDTH_LARGE 200

#define DEFAULT_MAP_SERVER @"http://a.imapview.com/"
#define DEFAULT_MAP_SUBJECT_ID 1
#define DEFAULT_LOCATE_TARGET @"B0:8E:1A:50:3D:61"
#define DEFAULT_ROUTE_ATTACH_THRESHOLD 5.0f
#define DEFAULT_ROUTE_DEVIATE_THRESHOLD 10.0f
#define DEFAULT_ROUTE_RULE 0

@interface iMapSettingViewController : UIViewController

@property int mapid;
@property NSString* targetMac;

@end
