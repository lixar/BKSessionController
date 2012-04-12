//
//  TestVC-BKSessionControllerDelegate.m
//  BKSessionController
//
//  Created by boreal-kiss.com on 10/09/16.
//  Copyright 2010 boreal-kiss.com. All rights reserved.
//

#import "TestVC-BKSessionControllerDelegate.h"
#import "TestVC-Animation.h"
#import "BKSessionController.h"

@implementation TestVC (_BKSessionControllerDelegate)

-(void)sessionControllerSenderWillStartSendingData:(NSNotification *)aNotification{
	[self _setLabelText:@"Data sending..."];
	[_indicator startAnimating];
}

-(void)sessionControllerSenderDidFinishSendingData:(NSNotification *)aNotification{
	[self _setLabelText:@"Data sent."];
	[_indicator stopAnimating];
}

-(void)sessionControllerReceiverWillStartReceivingData:(NSNotification *)aNotification{
	[self _setLabelText:@"Data receiving..."];
	_progressView.hidden = NO;
	_progressView.progress = 0.0;
	[_indicator startAnimating];
}

-(void)sessionControllerReceiverDidFinishReceivingData:(NSNotification *)aNotification{
	[self _setLabelText:@"Data received."];
	_progressView.hidden = YES;
	[self saveImage];
	[_indicator stopAnimating];
}

-(void)sessionControllerReceiverDidReceiveData:(NSNotification *)aNotification{
	_progressView.progress = _sessionController.progress;
}

-(void)sessionControllerPeerDidConnect:(NSNotification *)aNotification{
	[self _setLabelText:@"Peer connected."];
	
	//[self _showConnectionStateImageView];
	_connectionStateImageView.image = [[self class] sessionEnabledImage];
}

-(void)sessionControllerPeerDidDisconnect:(NSNotification *)aNotification{
	[self _setLabelText:@"Peer disconnected."];
	
	//[self _hideConnectionStateImageView];
	_connectionStateImageView.image = [[self class] sessionDisabledImage];
}

@end