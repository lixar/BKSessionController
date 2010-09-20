//
//  BKSessionController-DelegateSupport.m
//  BKSessionController
//
//  Created by boreal-kiss.com on 10/09/15.
//  Copyright 2010 boreal-kiss.com. All rights reserved.
//

#import "BKSessionController-DelegateSupport.h"

@implementation BKSessionController (_DelegateSupport)

-(void)_senderWillStartSendingData{
	NSLog(@"%s", __FUNCTION__);
	
	NSNotification *aNotification = [NSNotification notificationWithName:BKSessionControllerSenderWillStartSendingDataNotification object:self];
	[[NSNotificationCenter defaultCenter] postNotification:aNotification];
	
	if ([_delegate respondsToSelector:@selector(sessionControllerSenderWillStartSendingData:)]){
		[_delegate sessionControllerSenderWillStartSendingData:aNotification];
	}
}

-(void)_senderDidFinishSendingData{
	NSLog(@"%s", __FUNCTION__);
	
	NSNotification *aNotification = [NSNotification notificationWithName:BKSessionControllerSenderDidFinishSendingDataNotification object:self];
	[[NSNotificationCenter defaultCenter] postNotification:aNotification];
	
	if ([_delegate respondsToSelector:@selector(sessionControllerSenderDidFinishSendingData:)]){
		[_delegate sessionControllerSenderDidFinishSendingData:aNotification];
	}
}

-(void)_receiverWillStartReceivingData{
	NSLog(@"%s", __FUNCTION__);
	
	NSNotification *aNotification = [NSNotification notificationWithName:BKSessionControllerReceiverWillStartReceivingDataNotification object:self];
	[[NSNotificationCenter defaultCenter] postNotification:aNotification];
	
	if ([_delegate respondsToSelector:@selector(sessionControllerReceiverWillStartReceivingData:)]){
		[_delegate sessionControllerReceiverWillStartReceivingData:aNotification];
	}
}

-(void)_receiverDidFinishReceivingData{
	NSLog(@"%s", __FUNCTION__);
	
	NSNotification *aNotification = [NSNotification notificationWithName:BKSessionControllerReceiverDidFinishReceivingDataNotification object:self];
	[[NSNotificationCenter defaultCenter] postNotification:aNotification];
	
	if ([_delegate respondsToSelector:@selector(sessionControllerReceiverDidFinishReceivingData:)]){
		[_delegate sessionControllerReceiverDidFinishReceivingData:aNotification];
	}
}

-(void)_receiverDidReceiveData{
	NSLog(@"%s", __FUNCTION__);
	
	NSNotification *aNotification = [NSNotification notificationWithName:BKSessionControllerReceiverDidReceiveDataNotification object:self];
	[[NSNotificationCenter defaultCenter] postNotification:aNotification];
	
	if ([_delegate respondsToSelector:@selector(sessionControllerReceiverDidReceiveData:)]){
		[_delegate sessionControllerReceiverDidReceiveData:aNotification];
	}
}

-(void)_peerDidConnect{
	NSLog(@"%s", __FUNCTION__);
	
	NSNotification *aNotification = [NSNotification notificationWithName:BKSessionControllerPeerDidConnectNotification object:self];
	[[NSNotificationCenter defaultCenter] postNotification:aNotification];
	
	if ([_delegate respondsToSelector:@selector(sessionControllerPeerDidConnect:)]){
		[_delegate sessionControllerPeerDidConnect:aNotification];
	}
}

-(void)_peerDidDisconnect{
	NSLog(@"%s", __FUNCTION__);
	
	NSNotification *aNotification = [NSNotification notificationWithName:BKSessionControllerPeerDidDisconnectNotification object:self];
	[[NSNotificationCenter defaultCenter] postNotification:aNotification];
	
	if ([_delegate respondsToSelector:@selector(sessionControllerPeerDidDisconnect:)]){
		[_delegate sessionControllerPeerDidDisconnect:aNotification];
	}
}

@end
