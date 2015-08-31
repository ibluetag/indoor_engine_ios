//
//  iMapSettingViewController.m
//  iIndoorMapView
//
//  Created by wuzhiji37 on 15/7/22.
//  Copyright (c) 2015年 __ibluetag__. All rights reserved.
//

#import "iMapSettingViewController.h"

@interface iMapSettingViewController () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
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
}

- (void)backClick {
    [self saveUserDefaults];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SettingFinish" object:nil userInfo:nil];
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
