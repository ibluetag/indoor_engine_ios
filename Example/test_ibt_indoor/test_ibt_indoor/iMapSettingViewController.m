//
//  iMapSettingViewController.m
//  iIndoorMapView
//
//  Created by wuzhiji37 on 15/7/22.
//  Copyright (c) 2015年 __ibluetag__. All rights reserved.
//

#import "iMapSettingViewController.h"
#import <ibt_indoor/iIndoorMapData.h>

@interface iMapSettingViewController () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, iIndoorMapDataDelegate>
{
    UIScrollView    *_scrollView;
    UITextField     *_mapServerTF;
    UITextField     *_mapSubjectIdTF;
    UITextField     *_locateTargetTF;
    UITextField     *_routeAttachThresholdTF;
    UITextField     *_routeDeviateThresholdTF;
    UITextField     *_routeRuleTF;
    UIPickerView    *_routeRulePicker;
    UIToolbar       *_routeRuleInputAccessoryView;
    NSArray         *_routeRuleData;
    NSInteger       _currentRouteRule;
    UISwitch        *_routeSmootherSwitch;

    UIButton		*_testButton1;
    UIButton		*_testButton2;
    UIButton		*_testButton3;
    UIButton		*_testButton4;
    UIButton		*_testButton5;
}
@end

@implementation iMapSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.title = @"设置";
    
    NSArray *dataArray = [[NSArray alloc]initWithObjects:@"电梯优先", @"扶梯优先", @"楼梯优先", nil];
    _routeRuleData = dataArray;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    [self addMapServerView];
    [self addMapSubjectIdView];
    [self addLocateTargetView];
    [self addRouteSettingView];
    [self addTestButtons];
    [self loadUserDefaults];
}

- (void)addMapServerView {
    UIView *setServerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width, 50)];
    [_scrollView addSubview:setServerView];
    UILabel *setServerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, UI_SETTING_LABEL_WIDTH, 50)];
    setServerLabel.text = @"地图服务器";
    [setServerView addSubview:setServerLabel];
    
    _mapServerTF = [[UITextField alloc] initWithFrame:CGRectMake(UI_SETTING_LABEL_WIDTH + 20, 10, setServerView.frame.size.width - UI_SETTING_LABEL_WIDTH - 20 - 10, 30)];
    _mapServerTF.borderStyle = UITextBorderStyleRoundedRect;
    _mapServerTF.clearButtonMode = UITextFieldViewModeAlways;
    _mapServerTF.delegate = self;
    [setServerView addSubview:_mapServerTF];
}

- (void)addMapSubjectIdView {
    UIView *setMapIDView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 50)];
    [_scrollView addSubview:setMapIDView];
    UILabel *setMapIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, UI_SETTING_LABEL_WIDTH, 50)];
    setMapIDLabel.text = @"地图主体ID";
    [setMapIDView addSubview:setMapIDLabel];
    
    _mapSubjectIdTF = [[UITextField alloc] initWithFrame:CGRectMake(UI_SETTING_LABEL_WIDTH + 20, 10, setMapIDView.frame.size.width - UI_SETTING_LABEL_WIDTH - 20 - 10, 30)];
    _mapSubjectIdTF.borderStyle = UITextBorderStyleRoundedRect;
    _mapSubjectIdTF.clearButtonMode = UITextFieldViewModeAlways;
    _mapSubjectIdTF.keyboardType = UIKeyboardTypeNumberPad;
    _mapSubjectIdTF.delegate = self;
    [setMapIDView addSubview:_mapSubjectIdTF];
}

- (void)addLocateTargetView {
    UIView *setLocateTargetView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 50)];
    [_scrollView addSubview:setLocateTargetView];
    UILabel *setLocateTargetLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, UI_SETTING_LABEL_WIDTH, 50)];
    setLocateTargetLabel.text = @"定位目标MAC";
    [setLocateTargetView addSubview:setLocateTargetLabel];
    
    _locateTargetTF = [[UITextField alloc] initWithFrame:CGRectMake(UI_SETTING_LABEL_WIDTH + 20, 10, setLocateTargetView.frame.size.width - UI_SETTING_LABEL_WIDTH - 20 - 10, 30)];
    _locateTargetTF.borderStyle = UITextBorderStyleRoundedRect;
    _locateTargetTF.clearButtonMode = UITextFieldViewModeAlways;
    _locateTargetTF.delegate = self;
    [setLocateTargetView addSubview:_locateTargetTF];
}

- (void)addRouteSettingView {
    // route attach threahold
    UIView *routeAttachThresholdView = [[UIView alloc] initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, 50)];
    [_scrollView addSubview:routeAttachThresholdView];
    UILabel *routeAttachThresholdLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, UI_SETTING_LABEL_WIDTH_LARGE, 50)];
    routeAttachThresholdLabel.text = @"路径吸附阈值（米）";
    [routeAttachThresholdView addSubview:routeAttachThresholdLabel];
    
    _routeAttachThresholdTF = [[UITextField alloc] initWithFrame:CGRectMake(UI_SETTING_LABEL_WIDTH_LARGE + 20, 10, routeAttachThresholdView.frame.size.width - UI_SETTING_LABEL_WIDTH_LARGE - 20 - 10, 30)];
    _routeAttachThresholdTF.borderStyle = UITextBorderStyleRoundedRect;
    _routeAttachThresholdTF.clearButtonMode = UITextFieldViewModeAlways;
    _routeAttachThresholdTF.keyboardType = UIKeyboardTypeNumberPad;
    _routeAttachThresholdTF.delegate = self;
    [routeAttachThresholdView addSubview:_routeAttachThresholdTF];
    
    // route deviate threahold
    UIView *routeDeviateThresholdView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 50)];
    [_scrollView addSubview:routeDeviateThresholdView];
    UILabel *routeDeviateThresholdLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, UI_SETTING_LABEL_WIDTH_LARGE, 50)];
    routeDeviateThresholdLabel.text = @"导航偏移判定阈值（米）";
    [routeDeviateThresholdView addSubview:routeDeviateThresholdLabel];
    
    _routeDeviateThresholdTF = [[UITextField alloc] initWithFrame:CGRectMake(UI_SETTING_LABEL_WIDTH_LARGE + 20, 10, routeDeviateThresholdView.frame.size.width - UI_SETTING_LABEL_WIDTH_LARGE - 20 - 10, 30)];
    _routeDeviateThresholdTF.borderStyle = UITextBorderStyleRoundedRect;
    _routeDeviateThresholdTF.clearButtonMode = UITextFieldViewModeAlways;
    _routeDeviateThresholdTF.keyboardType = UIKeyboardTypeNumberPad;
    _routeDeviateThresholdTF.delegate = self;
    [routeDeviateThresholdView addSubview:_routeDeviateThresholdTF];
    
    // route rule
    UIView *routeRuleView = [[UIView alloc] initWithFrame:CGRectMake(0, 250, self.view.frame.size.width, 50)];
    [_scrollView addSubview:routeRuleView];
    UILabel *routeRuleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, UI_SETTING_LABEL_WIDTH_LARGE, 50)];
    routeRuleLabel.text = @"导航路径规则";
    [routeRuleView addSubview:routeRuleLabel];
    _routeRuleTF = [[UITextField alloc] initWithFrame:CGRectMake(UI_SETTING_LABEL_WIDTH_LARGE + 20, 10, routeRuleView.frame.size.width - UI_SETTING_LABEL_WIDTH_LARGE - 20 - 10, 30)];
    _routeRuleTF.borderStyle = UITextBorderStyleRoundedRect;
    _routeRulePicker = [[UIPickerView alloc] init];
    _routeRulePicker.delegate = self;
    _routeRulePicker.dataSource = self;
    _routeRuleTF.inputView = _routeRulePicker;
    _routeRuleInputAccessoryView = [[UIToolbar alloc] init];
    _routeRuleInputAccessoryView.frame = CGRectMake(0, 0, self.view.frame.size.width, 38);
    _routeRuleInputAccessoryView.backgroundColor = [UIColor grayColor];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(onRouteRuleConfirm)];
    [doneBtn setTintColor:[UIColor blueColor]];
    _routeRuleInputAccessoryView.items = [NSArray arrayWithObject:doneBtn];
    _routeRuleTF.inputAccessoryView = _routeRuleInputAccessoryView;
    [routeRuleView addSubview:_routeRuleTF];
    
    // route smoother
    UIView *routeSmootherView = [[UIView alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 50)];
    [_scrollView addSubview:routeSmootherView];
    UILabel *routeSmootherLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, UI_SETTING_LABEL_WIDTH_LARGE, 50)];
    routeSmootherLabel.text = @"开启导航模式平滑移动";
    [routeSmootherView addSubview:routeSmootherLabel];
    _routeSmootherSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(UI_SETTING_LABEL_WIDTH_LARGE + 20, 10, routeSmootherView.frame.size.width - UI_SETTING_LABEL_WIDTH_LARGE - 20 - 10, 30)];
    [_routeSmootherSwitch setOn:NO];
    [_routeSmootherSwitch addTarget:self action:nil forControlEvents:UIControlEventValueChanged];
    [routeSmootherView addSubview:_routeSmootherSwitch];
}

- (void) addTestButtons {
    if (_testButton1 == nil) {
        _testButton1 = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - UI_TEST_BUTTON_HEIGHT, UI_TEST_BUTTON_WIDTH, UI_TEST_BUTTON_HEIGHT)];
        [_testButton1 setTitle:@"测试选中店铺" forState:UIControlStateNormal];
        _testButton1.titleLabel.font = [UIFont systemFontOfSize:10];
        [_testButton1 setTitleColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateDisabled];
        [_testButton1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _testButton1.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _testButton1.layer.borderWidth = 1.0f;
        _testButton1.backgroundColor = [UIColor whiteColor];
        [_testButton1 addTarget:self action:@selector(buttonTest1) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_testButton1];
    }
    if (_testButton2 == nil) {
        _testButton2 = [[UIButton alloc] initWithFrame:CGRectMake(UI_TEST_BUTTON_WIDTH, self.view.frame.size.height - UI_TEST_BUTTON_HEIGHT, UI_TEST_BUTTON_WIDTH, UI_TEST_BUTTON_HEIGHT)];
        [_testButton2 setTitle:@"测试导航至店铺" forState:UIControlStateNormal];
        _testButton2.titleLabel.font = [UIFont systemFontOfSize:10];
        [_testButton2 setTitleColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateDisabled];
        [_testButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _testButton2.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _testButton2.layer.borderWidth = 1.0f;
        _testButton2.backgroundColor = [UIColor whiteColor];
        [_testButton2 addTarget:self action:@selector(buttonTest2) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_testButton2];
    }
    if (_testButton3 == nil) {
        _testButton3 = [[UIButton alloc] initWithFrame:CGRectMake(UI_TEST_BUTTON_WIDTH*2, self.view.frame.size.height - UI_TEST_BUTTON_HEIGHT, UI_TEST_BUTTON_WIDTH, UI_TEST_BUTTON_HEIGHT)];
        [_testButton3 setTitle:@"测试全部POI" forState:UIControlStateNormal];
        _testButton3.titleLabel.font = [UIFont systemFontOfSize:10];
        [_testButton3 setTitleColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateDisabled];
        [_testButton3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _testButton3.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _testButton3.layer.borderWidth = 1.0f;
        _testButton3.backgroundColor = [UIColor whiteColor];
        [_testButton3 addTarget:self action:@selector(buttonTest3) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_testButton3];
    }
    if (_testButton4 == nil) {
        _testButton4 = [[UIButton alloc] initWithFrame:CGRectMake(UI_TEST_BUTTON_WIDTH*3, self.view.frame.size.height - UI_TEST_BUTTON_HEIGHT, UI_TEST_BUTTON_WIDTH, UI_TEST_BUTTON_HEIGHT)];
        [_testButton4 setTitle:@"测试地图选项" forState:UIControlStateNormal];
        _testButton4.titleLabel.font = [UIFont systemFontOfSize:10];
        [_testButton4 setTitleColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateDisabled];
        [_testButton4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _testButton4.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _testButton4.layer.borderWidth = 1.0f;
        _testButton4.backgroundColor = [UIColor whiteColor];
        [_testButton4 addTarget:self action:@selector(buttonTest4) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_testButton4];
    }
    if (_testButton5 == nil) {
        _testButton5 = [[UIButton alloc] initWithFrame:CGRectMake(UI_TEST_BUTTON_WIDTH*4, self.view.frame.size.height - UI_TEST_BUTTON_HEIGHT, UI_TEST_BUTTON_WIDTH, UI_TEST_BUTTON_HEIGHT)];
        [_testButton5 setTitle:@"测试地图下载" forState:UIControlStateNormal];
        _testButton5.titleLabel.font = [UIFont systemFontOfSize:10];
        [_testButton5 setTitleColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateDisabled];
        [_testButton5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _testButton5.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _testButton5.layer.borderWidth = 1.0f;
        _testButton5.backgroundColor = [UIColor whiteColor];
        [_testButton5 addTarget:self action:@selector(buttonTest5) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_testButton5];
    }

}

-(void) buttonTest1
{
    int floorID = 42, eventID = 1;
    NSString *label = @"B8103";

    [self.mapView loadMap:eventID WithFloor:floorID POISelected:label];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:MAP_LOAD_MODE_POI_SELECT forKey:@"mapLoadMode"];
    [dict setObject:[NSNumber numberWithInt:floorID] forKey:@"mapLoadInitFloorId"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SettingFinish" object:nil userInfo:dict];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) buttonTest2
{
    
    int floorID = 10, eventID = 1;
    NSString *label = @"C8012";

    //[self.mapView doLoatingWithFloorID:41 X:100.0 Y:200.0];
    [self.mapView loadMap:eventID WithFloor:floorID POIRouting:label];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:MAP_LOAD_MODE_POI_ROUTE forKey:@"mapLoadMode"];
    [dict setObject:[NSNumber numberWithInt:floorID] forKey:@"mapLoadInitFloorId"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SettingFinish" object:nil userInfo:dict];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) buttonTest3
{
    //[iIndoorMapData getAllFloors:1 WithDelegate:self];
    [iIndoorMapData getAllPOIs:1 WithDelegate:self];
    //[self.mapView doLoatingWithFloorID:41 X:500 Y:400.0];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) onFloors:(NSArray *) floors
{
    if (floors !=nil){
        NSLog(@"%s: size=%d",__FUNCTION__, floors.count);
        for (int index=0; index < floors.count; index++)
        {
            iIndoorMapFloor *floor = [floors objectAtIndex:index];
            [floor print];
        }
    }
    else {
        NSLog(@"%s: no floor found", __FUNCTION__);
    }
}

-(void) onPOIs:(NSArray *) pois
{
    if (pois !=nil){
        NSLog(@"%s: poi size=%d",__FUNCTION__, pois.count);
        for (int index=0; index < pois.count; index++)
        {
            iIndoorMapPOI *poi = [pois objectAtIndex:index];
            //[poi print];
        }
    }
    else {
        NSLog(@"%s: no poi found", __FUNCTION__);
    }
}

-(void) buttonTest4
{
    iIndoorMapViewOption *option = [[iIndoorMapViewOption alloc]init];
    option.enableFloorSelectView = false;
    option.enableScaleView = false;

    [self.mapView setMapViewOption:option];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) buttonTest5
{
    iIndoorMapViewOption *option = [[iIndoorMapViewOption alloc]init];
    option.enableFloorSelectView = true;
    option.enableScaleView = true;
    [self.mapView setMapViewOption:option];

    [self.mapView downloadMap:5];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) onRouteRuleConfirm {
    _currentRouteRule = [_routeRulePicker selectedRowInComponent:0];
    _routeRuleTF.text = [_routeRuleData objectAtIndex:_currentRouteRule];
    [_routeRuleTF resignFirstResponder];
}

- (void)saveUserDefaults {
    NSLog(@"save user defaults...");
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *mapServer = _mapServerTF.text;
    if ([[mapServer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        mapServer = DEFAULT_MAP_SERVER;
    }
    
    NSString *mapSubjectId = _mapSubjectIdTF.text;
    if ([[mapSubjectId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        mapSubjectId = [NSString stringWithFormat:@"%d", DEFAULT_MAP_SUBJECT_ID];
    }
    
    NSString *locateTarget = _locateTargetTF.text;
    if ([[locateTarget stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        locateTarget = DEFAULT_LOCATE_TARGET;
    }
    
    NSString *routeAttachThreshold = _routeAttachThresholdTF.text;
    if ([[routeAttachThreshold stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        routeAttachThreshold = [NSString stringWithFormat:@"%f", DEFAULT_ROUTE_ATTACH_THRESHOLD];
    }
    
    NSString *routeDeviateThreshold = _routeDeviateThresholdTF.text;
    if ([[routeDeviateThreshold stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        routeDeviateThreshold = [NSString stringWithFormat:@"%f", DEFAULT_ROUTE_DEVIATE_THRESHOLD];
    }
    
    
    [userDefaults setObject:mapServer forKey:@"mapServer"];
    [userDefaults setInteger:[mapSubjectId intValue] forKey:@"mapSubjectId"];
    [userDefaults setObject:[locateTarget uppercaseString] forKey:@"locateTarget"];
    [userDefaults setFloat:[routeAttachThreshold floatValue] forKey:@"routeAttachThreshold"];
    [userDefaults setFloat:[routeDeviateThreshold floatValue] forKey:@"routeDeviateThreshold"];
    [userDefaults setInteger:_currentRouteRule forKey:@"routeRule"];
    [userDefaults setInteger:[_routeSmootherSwitch isOn] forKey:@"routeSmooth"];

    [userDefaults synchronize];
}

- (void)loadUserDefaults {
    NSLog(@"load user defaults...");
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    _mapServerTF.text = [userDefaultes stringForKey:@"mapServer"];
    _mapSubjectIdTF.text = [NSString stringWithFormat:@"%ld", (long)[userDefaultes integerForKey:@"mapSubjectId"]];
    _locateTargetTF.text = [userDefaultes stringForKey:@"locateTarget"];
    _routeAttachThresholdTF.text = [NSString stringWithFormat:@"%.1f", [userDefaultes floatForKey:@"routeAttachThreshold"]];
    _routeDeviateThresholdTF.text = [NSString stringWithFormat:@"%.1f", [userDefaultes floatForKey:@"routeDeviateThreshold"]];
    _currentRouteRule = [userDefaultes integerForKey:@"routeRule"];
    _routeRuleTF.text = [_routeRuleData objectAtIndex:_currentRouteRule];
    [_routeSmootherSwitch setOn:([userDefaultes integerForKey:@"routeSmooth"] != 0)];
}

- (void)backClick {
    [self saveUserDefaults];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:MAP_LOAD_MODE_NORMAL forKey:@"mapLoadMode"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SettingFinish" object:nil userInfo:dict];
    [self keyboardDisappear];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)keyboardDisappear {
    [_mapServerTF resignFirstResponder];
    [_mapSubjectIdTF resignFirstResponder];
    [_locateTargetTF resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self keyboardDisappear];
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Route Rule Picker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_routeRuleData count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_routeRuleData objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"select: %ld-%@", (long)row, [_routeRuleData objectAtIndex:row]);
}

@end
