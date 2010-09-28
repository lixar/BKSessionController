//
//  BKSessionControllerDelegate.h
//  BKSessionController
//
//  Created by boreal-kiss.com on 10/09/15.
//  Copyright 2010 boreal-kiss.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A protocol controlling the behaviour of a BKSessionController objetc.
 */
@protocol BKSessionControllerDelegate <NSObject>

@optional

/**
 * Sent to the delegate before the peer (data sender) send data to the receiver.
 * A related BKSessionController object can be retrieved by the object property of the notification object.
 */
-(void)sessionControllerSenderWillStartSendingData:(NSNotification *)aNotification;

/**
 * Sent to the delegate after the peer (data sender) complete sending data.
 */
-(void)sessionControllerSenderDidFinishSendingData:(NSNotification *)aNotification;

/**
 * Sent to the delegate before the peer (data receiver) will start to receive data.
 * A related BKSessionController object can be retrieved by the object property of the notification object.
 */
-(void)sessionControllerReceiverWillStartReceivingData:(NSNotification *)aNotification;

/**
 * Sent to the delegate before the peer (data receiver) complete receiving data.
 * A related BKSessionController object can be retrieved by the object property of the notification object.
 */
-(void)sessionControllerReceiverDidFinishReceivingData:(NSNotification *)aNotification;

/**
 * Sent to the delegate when the peer (data receiver) receives a portion of the data.
 * A related BKSessionController object can be retrieved by the object property of the notification object.
 */
-(void)sessionControllerReceiverDidReceiveData:(NSNotification *)aNotification;

/**
 * Sent to the delegate when the peer connects to other peers.
 * A related BKSessionController object can be retrieved by the object property of the notification object.
 */
-(void)sessionControllerPeerDidConnect:(NSNotification *)aNotification;

/**
 * Sent to the delegate when the peer disconnects to other peers.
 * A related BKSessionController object can be retrieved by the object property of the notification object.
 */
-(void)sessionControllerPeerDidDisconnect:(NSNotification *)aNotification;
@end
