//
//  BKSessionControllerDelegate.h
//  P2PTest
//
//  Created by boreal-kiss.com on 10/09/15.
//  Copyright 2010 boreal-kiss.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BKSessionControllerDelegate <NSObject>

@optional

/**
 * Sent to the delegate before the peer send the data to the receiver.
 */
-(void)sessionControllerSenderWillStartSendingData:(NSNotification *)aNotification;

/**
 * Sent to the delegate after the peer complete the data transmit.
 */
-(void)sessionControllerSenderDidFinishSendingData:(NSNotification *)aNotification;

-(void)sessionControllerReceiverWillStartReceivingData:(NSNotification *)aNotification;
-(void)sessionControllerReceiverDidFinishReceivingData:(NSNotification *)aNotification;

/**
 * Sent to the delegate when the peer receives a portion of the data.
 */
-(void)sessionControllerReceiverDidReceiveData:(NSNotification *)aNotification;

-(void)sessionControllerPeerDidConnect:(NSNotification *)aNotification;
-(void)sessionControllerPeerDidDisconnect:(NSNotification *)aNotification;
@end
