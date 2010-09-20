//
//  AppDelegate.h
//  BKSessionController
//
//  Created by boreal-kiss.com on 10/09/15.
//  Copyright boreal-kiss.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *_window;
	UIViewController *_viewController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UIViewController *viewController;
@end

