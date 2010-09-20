//
//  TestVC-Animation.m
//  BKSessionController
//
//  Created by boreal-kiss.com on 10/09/20.
//  Copyright 2010 boreal-kiss.com. All rights reserved.
//

#import "TestVC-Animation.h"

//Private
static NSString * const ShowAnimationID	= @"ShowAnimationID";
static NSString * const HideAnimationID	= @"HideAnimationID";

@implementation TestVC (Animation)

-(void)_showView:(UIView *)aView animationID:(NSString *)animationID{
	[UIView beginAnimations:animationID context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(_animationDidStop:finished:context:)];
	aView.alpha = 1.0;
	[UIView commitAnimations];
}

-(void)_hideView:(UIView *)aView{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(_animationDidStop:finished:context:)];
	aView.alpha = 0.0;
	[UIView commitAnimations];
}

-(void)_hideView:(UIView *)aView afterDelay:(NSTimeInterval)delay{
	[self performSelector:@selector(_hideView:) withObject:aView afterDelay:delay];
}

-(void)_setLabelText:(NSString *)text{
	_label.text = text;
	[self _showLabel];
}

-(void)_showLabel{
	[self _showView:_label animationID:ShowAnimationID];
}

-(void)_showConnectionStateImageView{
	[self _showView:_connectionStateImageView animationID:nil];
}

-(void)_hideConnectionStateImageView{
	[self _hideView:_connectionStateImageView];
}

-(void)_animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
	static NSTimeInterval DefaultDelay = 5.0;
	
	if ([animationID isEqualToString:ShowAnimationID]){
		[self _hideView:_label afterDelay:DefaultDelay];
		return;
	}
}

/*
-(void)_showLabel{
	[UIView beginAnimations:ShowAnimationID context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(_animationDidStop:finished:context:)];
	_label.alpha = 1.0;
	[UIView commitAnimations];
}
 */

/*
-(void)_hideLabelAfterDelay:(NSTimeInterval)delay{
	[self performSelector:@selector(_hideLabel) withObject:nil afterDelay:delay];
}
 */

/*
-(void)_hideLabel{
	[UIView beginAnimations:HideAnimationID context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(_animationDidStop:finished:context:)];
	_label.alpha = 0.0;
	[UIView commitAnimations];
}
 */



@end
