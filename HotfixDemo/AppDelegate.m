//
//  AppDelegate.m
//  BlueAdSDKDemo
//
//  Created by 谢镭 on 2020/3/20.
//  Copyright © 2020 Rey. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>


@interface AppDelegate () 

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [ViewController new];
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    
}

@end
