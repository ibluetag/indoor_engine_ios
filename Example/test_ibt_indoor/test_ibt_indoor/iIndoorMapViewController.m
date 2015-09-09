//
//  iIndoorMapViewController.m
//  iIndoorMapView
//
//  Created by wuzhiji37 on 15/7/20.
//  Copyright (c) 2015年 __ibluetag__. All rights reserved.
//

#import "iIndoorMapViewController.h"
#import <ibt_indoor/iIndoorMapView.h>
#import "AppDelegate.h"
#import "iMapSettingViewController.h"
#import <ibt_indoor/iIndoorMapBitmapOverlay.h>
#import <ibt_indoor/iIndoorMapInfoWindow.h>
@interface iIndoorMapViewController () <UISearchBarDelegate, iIndoorMapDelegate>
{
    iIndoorMapView *_mapview;
    UISearchBar *_searchBar;
    int mapid;
    NSString* targetMac;

    UIButton		*_addOverlayBtn;
    UIButton		*_removeOverlayBtn;
    
    UIButton        *_southAreaBtn;
    UIButton        *_allAreaBtn;
    UIButton        *_northAreaBtn;
}
@property (nonatomic, strong) iIndoorMapBitmapOverlay *overlay1;
@property (nonatomic, strong) iIndoorMapBitmapOverlay *overlay2;
@property (nonatomic, strong) iIndoorMapInfoWindow	  *infoWindow;
@property (nonatomic, assign) long                    curFloorId;
@property (nonatomic, assign) int                     curArea;
@property (nonatomic, copy)   NSString                *curMapLoadMode;
@property (nonatomic, assign) long                    mapLoadInitFloorId;
@end

@implementation iIndoorMapViewController
- (AppDelegate *)delegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SettingFinish:) name:@"SettingFinish" object:nil];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    mapid = 1;

    _curFloorId = -1;
    _curMapLoadMode = nil;
    _mapLoadInitFloorId = -1;

    _mapview = [[iIndoorMapView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    [_mapview registerEventListener:self];

    [self.view addSubview:_mapview];
    [self reloadMap];

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"设置"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(settingClick)];
    self.navigationItem.leftBarButtonItem = leftItem;

    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0.0f,0.0f,255.0f,25.0f)];
    _searchBar.delegate = self;
    _searchBar.backgroundColor = [UIColor clearColor];
    [_searchBar setTintColor:[UIColor lightTextColor]];
    _searchBar.placeholder= @"请输入店铺或展台名称";
    _searchBar.layer.cornerRadius = 5;
    _searchBar.layer.masksToBounds = YES;

    //将搜索条放在一个UIView上
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 255, 25)];
    searchView.backgroundColor = [UIColor clearColor];
    [searchView addSubview:_searchBar];
    self.navigationItem.titleView = searchView;

    [self addOverlayButtons];
    [self addAreaButtons];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar becomeFirstResponder];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(cancelClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_searchBar resignFirstResponder];
    [_mapview searchByName:_searchBar.text];
}
- (void)cancelClick {
    _searchBar.text = @"";
    [_searchBar resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil;
    [_mapview searchClear];
}

- (void)settingClick {
    iMapSettingViewController *VC = [[iMapSettingViewController alloc] init];
    VC.mapid = mapid;
    VC.targetMac = targetMac;
    VC.mapView = _mapview;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)SettingFinish:(NSNotification *)noti {
    NSDictionary *userInfo = [noti userInfo];
    if (userInfo != nil) {
        _curMapLoadMode = [userInfo objectForKey:@"mapLoadMode"];
        NSNumber *initalFloor = (NSNumber*)[userInfo objectForKey:@"mapLoadInitFloorId"];
        if (initalFloor != nil) {
            _mapLoadInitFloorId = [initalFloor intValue];
        } else {
            _mapLoadInitFloorId = -1;
        }
    }
    NSLog(@"%s, load mode: %@, init floor: %ld", __FUNCTION__, _curMapLoadMode, _mapLoadInitFloorId);
    if (_curMapLoadMode != nil && ([_curMapLoadMode isEqualToString:MAP_LOAD_MODE_POI_SELECT] || [_curMapLoadMode isEqualToString:MAP_LOAD_MODE_POI_ROUTE])) {
        // map loaded from settings
        return;
    }
    [self reloadMap];
}

- (void)reloadMap {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    NSString *mapServer = [userDefaultes stringForKey:@"mapServer"];
    NSInteger mapSubjectId = [userDefaultes integerForKey:@"mapSubjectId"];
    NSString *locateTarget = [userDefaultes stringForKey:@"locateTarget"];
    NSLog(@"reloadMap, server: %@ subjectId: %ld target: %@", mapServer, (long)mapSubjectId, locateTarget);
    
    float routeAttachThreshold = [userDefaultes floatForKey:@"routeAttachThreshold"];
    float routeDeviateThreshold = [userDefaultes floatForKey:@"routeDeviateThreshold"];
    NSInteger routeRule = [userDefaultes integerForKey:@"routeRule"];
    BOOL routeSmooth = [userDefaultes integerForKey:@"routeSmooth"];

    [_mapview setMapServer:mapServer];
    [_mapview setLocateTarget:locateTarget];
    [_mapview setRouteAttachDistance:routeAttachThreshold];
    [_mapview setRouteDeviateDistance:routeDeviateThreshold];
    [_mapview setRouteRule:routeRule];
    [_mapview enableSmoothRoute:routeSmooth];
    [_mapview loadMap:(int)mapSubjectId];
}


-(void) addOverlayButtons
{
    if (_addOverlayBtn == nil) {
        _addOverlayBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-64, 64, 64, UI_OVERLAY_BUTTON_HEIGHT)];
        [_addOverlayBtn setTitle:@"添加覆盖物" forState:UIControlStateNormal];
        _addOverlayBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [_addOverlayBtn setTitleColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateDisabled];
        [_addOverlayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _addOverlayBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _addOverlayBtn.layer.borderWidth = 1.0f;
        _addOverlayBtn.backgroundColor = [UIColor whiteColor];
        [_addOverlayBtn addTarget:self action:@selector(addOverlay) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_addOverlayBtn];
    }

    if (_removeOverlayBtn == nil) {
        _removeOverlayBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width -64, 64 + UI_OVERLAY_BUTTON_HEIGHT, 64, UI_OVERLAY_BUTTON_HEIGHT)];
        [_removeOverlayBtn setTitle:@"移除覆盖物" forState:UIControlStateNormal];
        _removeOverlayBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [_removeOverlayBtn setTitleColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateDisabled];
        [_removeOverlayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _removeOverlayBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _removeOverlayBtn.layer.borderWidth = 1.0f;
        _removeOverlayBtn.backgroundColor = [UIColor whiteColor];
        [_removeOverlayBtn addTarget:self action:@selector(removeOverlay) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_removeOverlayBtn];
    }
}

- (void)addOverlay
{
    UIImage *image1 = [UIImage imageNamed:@"ibt_indoor.framework/asserts_overlay1.png"];
    _overlay1 = [[iIndoorMapBitmapOverlay alloc] initWithMapView:_mapview AndBitmap:image1];
    [_overlay1 setX:200.0 AndY:200.0];
    [_overlay1 attachToMap];

    UIImage *image2 = [UIImage imageNamed:@"ibt_indoor.framework/asserts_overlay2.png"];
    _overlay2 = [[iIndoorMapBitmapOverlay alloc] initWithMapView:_mapview AndBitmap:image2];
    [_overlay2 setX:800.0 AndY:300.0];
    [_overlay2 attachToMap];

    if (_infoWindow != nil)
        [_mapview removeMapInfoWindow:_infoWindow];
    
    UIButton *button = nil;
    {
        button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 128, 64)];
        [button setTitle:@"点击隐藏" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateDisabled];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"ibt_indoor.framework/asserts_overlay3.png"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:24];
        //[button setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 5)];
        //[button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        button.layer.borderColor = [UIColor clearColor].CGColor;
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(clickHide) forControlEvents:UIControlEventTouchUpInside];
    }

    _infoWindow = [[iIndoorMapInfoWindow alloc]initWithView:button Zorder:1 X:600.0 AndY:600.0];
    [_mapview addMapInfoWindow:_infoWindow];
}

- (void)clickHide
{
    if (_infoWindow != nil) {
        [_mapview removeMapInfoWindow:_infoWindow];
        _infoWindow = nil;
    }
}

- (void)removeOverlay
{
    if (_overlay1 != nil) {
        [_overlay1 deAttachFromMap];
        _overlay1 = nil;
    }

    if (_overlay2 != nil) {
        [_overlay2 deAttachFromMap];
        _overlay2 = nil;
    }

    if (_infoWindow != nil) {
        [_mapview removeMapInfoWindow:_infoWindow];
        _infoWindow = nil;
    }
}

- (void)addAreaButtons {
    if (_southAreaBtn == nil) {
        _southAreaBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 3 * UI_AREA_BTN_WIDTH) / 2, 64, UI_AREA_BTN_WIDTH, UI_AREA_BTN_HEIGHT)];
        [_southAreaBtn setTitle:@"南馆" forState:UIControlStateNormal];
        _southAreaBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_southAreaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _southAreaBtn.tag = AREA_SOUTH;
        [self setButton:_southAreaBtn BackgroundColor:GetColorFromHex(0x99cccccc) forState:UIControlStateNormal];
        [self setButton:_southAreaBtn BackgroundColor:GetColorFromHex(0x99555555) forState:UIControlStateSelected];
        [_southAreaBtn addTarget:self action:@selector(onAreaClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_southAreaBtn];
    }
    
    if (_allAreaBtn == nil) {
        _allAreaBtn = [[UIButton alloc] initWithFrame:CGRectMake(_southAreaBtn.frame.origin.x + UI_AREA_BTN_WIDTH + 1, 64, UI_AREA_BTN_WIDTH, UI_AREA_BTN_HEIGHT)];
        [_allAreaBtn setTitle:@"全馆" forState:UIControlStateNormal];
        _allAreaBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_allAreaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _allAreaBtn.tag = AREA_ALL;
        [self setButton:_allAreaBtn BackgroundColor:GetColorFromHex(0x99cccccc) forState:UIControlStateNormal];
        [self setButton:_allAreaBtn BackgroundColor:GetColorFromHex(0x99555555) forState:UIControlStateSelected];
        [_allAreaBtn addTarget:self action:@selector(onAreaClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_allAreaBtn];
    }
    
    if (_northAreaBtn == nil) {
        _northAreaBtn = [[UIButton alloc] initWithFrame:CGRectMake(_allAreaBtn.frame.origin.x + UI_AREA_BTN_WIDTH + 1, 64, UI_AREA_BTN_WIDTH, UI_AREA_BTN_HEIGHT)];
        [_northAreaBtn setTitle:@"北馆" forState:UIControlStateNormal];
        _northAreaBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_northAreaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _northAreaBtn.tag = AREA_NORTH;
        [self setButton:_northAreaBtn BackgroundColor:GetColorFromHex(0x99cccccc) forState:UIControlStateNormal];
        [self setButton:_northAreaBtn BackgroundColor:GetColorFromHex(0x99555555) forState:UIControlStateSelected];
        [_northAreaBtn addTarget:self action:@selector(onAreaClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_northAreaBtn];
    }
    
    [_southAreaBtn setHidden:YES];
    [_allAreaBtn setHidden:YES];
    [_northAreaBtn setHidden:YES];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _curArea = (int)[userDefaults integerForKey:@"initialArea"];
    [self updateAreaBtns];
}

- (void)setButton:(UIButton *)botton BackgroundColor:(UIColor *)color forState:(UIControlState)state {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [botton setBackgroundImage:image forState:state];
}

- (void)onAreaClick:(UIButton *)clickedBtn {
    _curArea = (int)clickedBtn.tag;
    [self updateAreaBtns];
    [self updateAreaDisplay];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:_curArea forKey:@"initialArea"];
}

- (void)updateAreaBtns {
    NSLog(@"%s, curArea: %d", __FUNCTION__, _curArea);
    if (_curArea == AREA_SOUTH) {
        [_southAreaBtn setSelected:YES];
        [_allAreaBtn setSelected:NO];
        [_northAreaBtn setSelected:NO];
    } else if (_curArea == AREA_ALL) {
        [_southAreaBtn setSelected:NO];
        [_allAreaBtn setSelected:YES];
        [_northAreaBtn setSelected:NO];
    } else if (_curArea == AREA_NORTH) {
        [_southAreaBtn setSelected:NO];
        [_allAreaBtn setSelected:NO];
        [_northAreaBtn setSelected:YES];
    } else {
        [_southAreaBtn setSelected:NO];
        [_allAreaBtn setSelected:NO];
        [_northAreaBtn setSelected:NO];
    }
}

- (void)checkAreaDisplay:(iIndoorMapFloor *)floor {
    if (floor == nil) {
        return;
    }
    if ([floor hasMultiAreas]) {
        [_southAreaBtn setHidden:NO];
        [_allAreaBtn setHidden:NO];
        [_northAreaBtn setHidden:NO];
        NSLog(@"%s, load mode: %@", __FUNCTION__, _curMapLoadMode);
        if (_curMapLoadMode == nil || [_curMapLoadMode isEqualToString:MAP_LOAD_MODE_NORMAL]) {
            // NOT show area when load with POI
            [self updateAreaDisplay];
        }
    } else {
        [_southAreaBtn setHidden:YES];
        [_allAreaBtn setHidden:YES];
        [_northAreaBtn setHidden:YES];
    }
    if (floor.floorID == _mapLoadInitFloorId) {
        // now ok to forget load mode, show areas for next floor switch if necessary
        _curMapLoadMode = nil;
        _mapLoadInitFloorId = -1;
    }
}

- (void)updateAreaDisplay {
    if (_mapview == nil) {
        return;
    }
    NSLog(@"%s, area: %d", __FUNCTION__, _curArea);
    switch (_curArea) {
        case AREA_SOUTH:
            [_mapview layoutMapPositionX:510.0f Y:910.0f WithScale:2.0f AndAngle:0.0f];
            break;
        case AREA_NORTH:
            [_mapview layoutMapPositionX:1670.0f Y:360.0f WithScale:2.0f AndAngle:0.0f];
            break;
        case AREA_ALL:
            [_mapview layoutMapPositionX:1080.0f Y:640.0f WithScale:1.0f AndAngle:-[_mapview getOriginalAngle]];
            break;
        default:
            break;
    }
}

#pragma mark callback tests
- (void)mapLoadFinishedWithID:(int) id Floor: (int) floorID {
    // 地图加载成功回调
    NSLog(@"%s, floor: %d", __FUNCTION__, floorID);
    NSLog(@"getExhibitName: %@", [_mapview getExhibitName]);
    NSLog(@"getCurrentFloorID: %d", [_mapview getCurrentFloorID]);
}

- (void)mapLoadErrorWithID:(int) id Err: (int) errCode {
    // 地图加载错误回调
    NSLog(@"%s, %d, err: %d", __FUNCTION__, id, errCode);
}

- (void)buildingSwitchWithObject: (iIndoorMapBuilding *)building {
    // 建筑物切换回调
    NSLog(@"%s, %d", __FUNCTION__, building.eventID);
    NSLog(@"getFloorIDs, total: %lu", [[_mapview getFloorIDs] count]);
    NSLog(@"getFloorNames, total: %lu", [[_mapview getFloorNames] count]);
}

- (void)floorSwitchWithObject: (iIndoorMapFloor *)floor {
    // 楼层切换回调
    if (_curFloorId == floor.floorID) {
        return;
    }
    NSLog(@"%s, %d[%@-%@], %dx%d", __FUNCTION__, floor.floorID, floor.buildingName, floor.floorName, (int)floor.pixelWidth, (int)floor.pixelHeight);
    _curFloorId = floor.floorID;
    [self checkAreaDisplay:floor];
}

-(void) enterBackgroundMode
{
    [_mapview pauseMap];
}

-(void) resumeFromBackgroundMode
{
    [_mapview resumeMap];
}
@end
