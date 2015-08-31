//
//  AppDelegate.m
//  iIndoorMapView
//
//  Created by wuzhiji37 on 15/7/20.
//  Copyright (c) 2015年 __ibluetag__. All rights reserved.
//

#import "AppDelegate.h"
#import "iIndoorMapViewController.h"
#import "iMapSettingViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    iIndoorMapViewController *mapVC = [[iIndoorMapViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:mapVC];
    [self.window setRootViewController:nvc];
    [self.window makeKeyAndVisible];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
    [defaultValues setObject:DEFAULT_MAP_SERVER forKey:@"mapServer"];
    [defaultValues setObject:[NSNumber numberWithInt:DEFAULT_MAP_SUBJECT_ID] forKey:@"mapSubjectId"];
    [defaultValues setObject:DEFAULT_LOCATE_TARGET forKey:@"locateTarget"];
    [defaultValues setObject:[NSNumber numberWithFloat:DEFAULT_ROUTE_ATTACH_THRESHOLD] forKey:@"routeAttachThreshold"];
    [defaultValues setObject:[NSNumber numberWithFloat:DEFAULT_ROUTE_DEVIATE_THRESHOLD] forKey:@"routeDeviateThreshold"];
    [defaultValues setObject:[NSNumber numberWithInt:DEFAULT_ROUTE_RULE] forKey:@"routeRule"];
    [defaultValues setObject:[NSNumber numberWithInt:DEFAULT_ROUTE_SMOOTH] forKey:@"routeSmooth"];
    [defaultValues setObject:[NSNumber numberWithInt:AREA_ALL] forKey:@"initialArea"];
    [userDefaults registerDefaults:defaultValues];
    [userDefaults synchronize];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//禁止横屏
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskPortrait;
}

@end
