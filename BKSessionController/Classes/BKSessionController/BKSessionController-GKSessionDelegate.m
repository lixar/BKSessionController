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
  NSLog(@"PeerID: %@ | Error: %@", peerID, error);
  [self _peerConnection:peerID failedWithError:error];
}

- (void)session:(GKSession *) session didFailWithError:(NSError *) error{
  NSLog(@"Error: %@", error);
}

- (void)session:(GKSession *) session didReceiveConnectionRequestFromPeer:(NSString *) peerID{
  NSLog(@"PeerID: %@", peerID);
  [self _peerConnectionRequest:peerID];
}

- (void)session:(GKSession *) session peer:(NSString *) peerID didChangeState:(GKPeerConnectionState) state{
  NSLog(@"PeerID: %@ | State: %d", peerID, state);
  
  switch (state) {
    case GKPeerStateAvailable:
      [self _peerAvailable:peerID];
      break;
    case GKPeerStateConnected:
      [self _peerDidConnect:peerID];
      break;
    case GKPeerStateDisconnected:
      [self _peerDidDisconnect:peerID];
      break;	
    default:
      break;
  }
}

@end
