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

-(void)_receiverDidFinishReceivingData:(NSString *)peerID{
	NSLog(@"%s", __FUNCTION__);
	
	NSNotification *aNotification = [NSNotification notificationWithName:BKSessionControllerReceiverDidFinishReceivingDataNotification object:self];
	[[NSNotificationCenter defaultCenter] postNotification:aNotification];
	
	if ([_delegate respondsToSelector:@selector(sessionControllerReceiverDidFinishReceivingData:peerID:)]){
		[_delegate sessionControllerReceiverDidFinishReceivingData:aNotification peerID:peerID];
	}
  [self.receivedDataFromPeer removeObjectForKey:peerID];
}

-(void)_receiverDidReceiveData:(NSString *)peerID{
	NSLog(@"%s", __FUNCTION__);
	
	NSNotification *aNotification = [NSNotification notificationWithName:BKSessionControllerReceiverDidReceiveDataNotification object:self];
	[[NSNotificationCenter defaultCenter] postNotification:aNotification];
	
	if ([_delegate respondsToSelector:@selector(sessionControllerReceiverDidReceiveData:peerID:)]){
		[_delegate sessionControllerReceiverDidReceiveData:aNotification peerID:peerID];
	}
}

-(void)_peerDidConnect:(NSString *)peerId{
	NSLog(@"%s", __FUNCTION__);
	
	NSNotification *aNotification = [NSNotification notificationWithName:BKSessionControllerPeerDidConnectNotification object:self];
	[[NSNotificationCenter defaultCenter] postNotification:aNotification];
	
	if ([_delegate respondsToSelector:@selector(sessionControllerPeerDidConnect:peerID:)]){
		[_delegate sessionControllerPeerDidConnect:aNotification peerID:peerId];
	}
}

-(void)_peerAvailable:(NSString *)peerId
{
  NSNotification *aNotification = [NSNotification notificationWithName:BKSessionControllerPeerIsAvailable object:self];
  
  [[NSNotificationCenter defaultCenter] postNotification:aNotification];
  
  if ([_delegate respondsToSelector:@selector(sessionControllerPeerIsAvailable:peerID:)])
  {
    [_delegate sessionControllerPeerIsAvailable:aNotification peerID:peerId];
  }
}

- (void)_peerConnectionRequest:(NSString *)peerId
{
  NSNotification *aNotification = [NSNotification notificationWithName:BKSessionControllerPeerRequestConnectionNotification object:self];
  
  [[NSNotificationCenter defaultCenter] postNotification:aNotification];
  
  if ([_delegate respondsToSelector:@selector(sessionControllerPeerRequestConnection:peerID:)])
  {
    [_delegate sessionControllerPeerRequestConnection:aNotification peerID:peerId];
  }
}

- (void)_peerConnection:(NSString *)peerId failedWithError:(NSError *)error
{
  NSNotification *aNotification = [NSNotification notificationWithName:BKSessionControllerPeerConnectionFailedNotification object:self];
  [[NSNotificationCenter defaultCenter] postNotification:aNotification];
  
  if ([_delegate respondsToSelector:@selector(sessionControllerPeerConnectionFailed:peerID:error:)])
  {
    [_delegate sessionControllerPeerConnectionFailed:aNotification peerID:peerId error:error];
  }
}

-(void)_peerDidDisconnect:(NSString *)peerId{
	NSLog(@"%s", __FUNCTION__);
	
	NSNotification *aNotification = [NSNotification notificationWithName:BKSessionControllerPeerDidDisconnectNotification object:self];
	[[NSNotificationCenter defaultCenter] postNotification:aNotification];
	
	if ([_delegate respondsToSelector:@selector(sessionControllerPeerDidDisconnect:peerID:)]){
		[_delegate sessionControllerPeerDidDisconnect:aNotification peerID:peerId];
	}
}

@end
