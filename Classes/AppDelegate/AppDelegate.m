//
//  AppDelegate.m
//  BKSessionController
//
//  Created by boreal-kiss.com on 10/09/15.
//  Copyright boreal-kiss.com 2010. All rights reserved.
//

#import "AppDelegate.h"
#import "TestVC.h"

@implementation AppDelegate
@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	_window.backgroundColor = [UIColor whiteColor];
	_viewController = [[TestVC alloc] init];
	[_window addSubview:_viewController.view];
    [_window makeKeyAndVisible];

	return YES;
}

- (void)applicationWillTerminate:(UIApplication *) application{
	NSLog(@"%s", __FUNCTION__);
}

- (void)dealloc {
	self.viewController = nil;
	self.window = nil;
    [super dealloc];
}


@end
