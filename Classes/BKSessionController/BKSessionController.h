//
//  BKSessionController.h
//  P2PTest
//
//  Created by boreal-kiss.com on 10/09/15.
//  Copyright 2010 boreal-kiss.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "BKSessionController.h"
#import "BKSessionControllerDelegate.h"

extern NSString * const BKSessionControllerSenderWillStartSendingDataNotification;
extern NSString * const BKSessionControllerSenderDidFinishSendingDataNotification;
extern NSString * const BKSessionControllerReceiverWillStartReceivingDataNotification;
extern NSString * const BKSessionControllerReceiverDidFinishReceivingDataNotification;
extern NSString * const BKSessionControllerReceiverDidReceiveDataNotification;
extern NSString * const BKSessionControllerPeerDidConnectNotification;
extern NSString * const BKSessionControllerPeerDidDisconnectNotification;

/**
 * Deals with a large file transmittion via a GKSession object.
 */
@interface BKSessionController : NSObject {
	GKSession *_session;
	NSMutableData *_receivedData;
	id <BKSessionControllerDelegate> _delegate;
	CGFloat _progress;
}
@property (nonatomic, retain) GKSession *session;
@property (nonatomic, assign) id <BKSessionControllerDelegate> delegate;
@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, readonly) CGFloat progress;

/**
 * The convenience method.
 */
+(id)sessionControllerWithSession:(GKSession *)session;

/**
 * The designated initializer.
 */
-(id)initWithSession:(GKSession *)session;

/**
 * Sends data in any size to given peers.
 * This is the same interface/functionality as that found in a GKSession object.
 */
-(void)sendData:(NSData *)data toPeers:(NSArray *)peers;

/**
 * Sends data in any size to all peers.
 * This is the same interface/functionality as that found in a GKSession object.
 */
-(void)sendDataToAllPeers:(NSData *)data;

/**
 * A data receive handler.
 * This is the same interface/functionality as that required in a GKSession object's handler.
 */
-(void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context;

/**
 * Disconnects the session from all connected peers.
 */
-(void)disconnect;
@end
