//
//  TestVC-Animation.h
//  BKSessionController
//
//  Created by boreal-kiss.com on 10/09/20.
//  Copyright 2010 boreal-kiss.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestVC.h"

/**
 * Private category.
 */
@interface TestVC (Animation)

-(void)_showView:(UIView *)aView animationID:(NSString *)animationID;
-(void)_hideView:(UIView *)aView;
-(void)_hideView:(UIView *)aView afterDelay:(NSTimeInterval)delay;
-(void)_setLabelText:(NSString *)text;
-(void)_showLabel;
-(void)_showConnectionStateImageView;
-(void)_hideConnectionStateImageView;
-(void)_animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
@end
