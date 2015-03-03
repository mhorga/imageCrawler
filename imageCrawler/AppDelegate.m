//
//  AppDelegate.m
//  imageCrawler
//
//  Created by Marius Horga on 2/28/15.
//  Copyright (c) 2015 Marius Horga. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    UINavigationBar *navigationBar = navigationController.navigationBar;
    navigationBar.barTintColor = [UIColor brownColor];
    navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.window.rootViewController = navigationController;
    
    return YES;
}

@end
