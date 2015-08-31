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
@interface iIndoorMapViewController () <UISearchBarDelegate>
{
    iIndoorMapView *_mapview;
    UISearchBar *_searchBar;
    int mapid;
    NSString* targetMac;

    UIButton		*_addOverlayBtn;
    UIButton		*_removeOverlayBtn;
}
@property (nonatomic, strong) iIndoorMapBitmapOverlay *overlay1;
@property (nonatomic, strong) iIndoorMapBitmapOverlay *overlay2;
@property (nonatomic, strong) iIndoorMapInfoWindow	*infoWindow;
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
    
    _mapview = [[iIndoorMapView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64)];

    [self.view addSubview:_mapview];
    [_mapview loadMap:mapid];
    
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
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)SettingFinish:(NSNotification *)noti {
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

    [_mapview setMapServer:mapServer];
    [_mapview setLocateTarget:locateTarget];
    [_mapview setRouteAttachDistance:routeAttachThreshold];
    [_mapview setRouteDeviateDistance:routeDeviateThreshold];
    [_mapview setRouteRule:routeRule];
    [_mapview loadMap:(int)mapSubjectId];
}


-(void) addOverlayButtons
{
    if (_addOverlayBtn == nil) {
        _addOverlayBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-128, 64, 64, UI_OVERLAY_BUTTON_HEIGHT)];
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
        _removeOverlayBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width -64, 64, 64, UI_OVERLAY_BUTTON_HEIGHT)];
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

@end
