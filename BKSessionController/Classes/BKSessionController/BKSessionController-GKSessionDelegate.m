//
//  BKSessionController-GKSessionDelegate.m
//  P2PTest
//
//  Created by boreal-kiss.com on 10/09/15.
//  Copyright 2010 boreal-kiss.com. All rights reserved.
//

#import "BKSessionController-GKSessionDelegate.h"
#import "BKSessionController-DelegateSupport.h"

@implementation BKSessionController (_GKSessionDelegate)

- (void)session:(GKSession *) session connectionWithPeerFailed:(NSString *) peerID withError:(NSError *) error{
	NSLog(@"%s", __FUNCTION__);
	NSLog(@"Error: %@", [error localizedDescription]);
}

- (void)session:(GKSession *) session didFailWithError:(NSError *) error{
	NSLog(@"%s", __FUNCTION__);
}

- (void)session:(GKSession *) session didReceiveConnectionRequestFromPeer:(NSString *) peerID{
	NSLog(@"%s", __FUNCTION__);
}

- (void)session:(GKSession *) session peer:(NSString *) peerID didChangeState:(GKPeerConnectionState) state{
	NSLog(@"%s", __FUNCTION__);
	
	switch (state) {
		case GKPeerStateConnected:
			[self _peerDidConnect];
			break;
		case GKPeerStateDisconnected:
			[self disconnect];
			[self _peerDidDisconnect];
			break;	
		default:
			break;
	}
}

@end
