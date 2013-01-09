//
//  BKSessionController-DelegateSupport.h
//  BKSessionController
//
//  Created by boreal-kiss.com on 10/09/15.
//  Copyright 2010 boreal-kiss.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BKSessionController.h"

/**
 * Private category.
 */
@interface BKSessionController (_DelegateSupport)
-(void)_senderWillStartSendingData;
-(void)_senderDidFinishSendingData;
-(void)_receiverWillStartReceivingData;
-(void)_receiverDidFinishReceivingData:(NSString *)peerID;
-(void)_receiverDidReceiveData:(NSString *)peerID;
-(void)_peerAvailable:(NSString *)peerId;
-(void)_peerDidConnect:(NSString *)peerId;
-(void)_peerDidDisconnect:(NSString *)peerId;
-(void)_peerConnection:(NSString *)peerId failedWithError:(NSError *)error;
-(void)_peerConnectionRequest:(NSString *)peerId;
@end
