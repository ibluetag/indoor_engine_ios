//
//  iIndoorMapViewController.h
//  iIndoorMapView
//
//  Created by wuzhiji37 on 15/7/20.
//  Copyright (c) 2015年 __ibluetag__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UI_OVERLAY_BUTTON_HEIGHT	32
#define UI_AREA_BTN_WIDTH 48
#define UI_AREA_BTN_HEIGHT 32
#define AREA_ALL 0
#define AREA_SOUTH 1
#define AREA_NORTH 2
#define GetColorFromHex(hexColor) \
    [UIColor colorWithRed:((hexColor >> 16) & 0xFF) / 255.0 \
    green:((hexColor >>  8) & 0xFF) / 255.0 \
    blue:((hexColor >>  0) & 0xFF) / 255.0 \
    alpha:((hexColor >> 24) & 0xFF) / 255.0]

@interface iIndoorMapViewController : UIViewController

-(void) enterBackgroundMode;
-(void) resumeFromBackgroundMode;
@end

