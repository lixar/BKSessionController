//
//  TestVC-GKPeerPickerControllerDelegate.m
//  BKSessionController
//
//  Created by boreal-kiss.com on 10/09/15.
//  Copyright 2010 boreal-kiss.com. All rights reserved.
//

#import "TestVC-GKPeerPickerControllerDelegate.h"


@implementation TestVC (_GKPeerPickerControllerDelegate)

- (void)peerPickerController:(GKPeerPickerController *) picker didConnectPeer:(NSString *) peerID toSession:(GKSession *) session{
	NSLog(@"%s", __FUNCTION__);
	
	[self createSession:session];
	
	//Cleanups
	picker.delegate = nil;
	[picker dismiss];
}

- (void)peerPickerControllerDidCancel:(GKPeerPickerController *) picker{
	NSLog(@"%s", __FUNCTION__);
	
	//Cleanups
	picker.delegate = nil;
}

@end
