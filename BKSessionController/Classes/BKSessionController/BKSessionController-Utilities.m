//
//  BKSessionController-Utilities.m
//  BKSessionController
//
//  Created by boreal-kiss.com on 10/09/28.
//  Copyright 2010 boreal-kiss.com. All rights reserved.
//

#import "BKSessionController-Utilities.h"


@implementation BKSessionController (_Utilities)

-(void)_sendDataHeaderToAllPeers{
	NSData *data = [BKSessionControllerSenderWillStartSendingDataNotification dataUsingEncoding:NSUTF8StringEncoding];
	[self _sendChunkDataToAllPeers:data];
}

-(void)_sendDataHeaderToPeers:(NSArray *)peers{
	NSData *data = [BKSessionControllerSenderWillStartSendingDataNotification dataUsingEncoding:NSUTF8StringEncoding];
	[self _sendChunkData:data toPeers:peers];
}

-(void)_sendChunkDataCountToAllPeers:(int)count{
	NSString *str = [NSString stringWithFormat:@"%d", count];
	NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
	[self _sendChunkDataToAllPeers:data];
}

-(void)_sendChunkDataCount:(int)count toPeers:(NSArray *)peers{
	NSString *str = [NSString stringWithFormat:@"%d", count];
	NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
	[self _sendChunkData:data toPeers:peers];
}

-(void)_sendDataFooterToAllPeers{
	NSData *data = [BKSessionControllerSenderDidFinishSendingDataNotification dataUsingEncoding:NSUTF8StringEncoding];
	[self _sendChunkDataToAllPeers:data];
}

-(void)_sendDataFooterToPeers:(NSArray *)peers{
	NSData *data = [BKSessionControllerSenderDidFinishSendingDataNotification dataUsingEncoding:NSUTF8StringEncoding];
	[self _sendChunkData:data toPeers:peers];
}

-(void)_sendChunkData:(NSData *)chunkData toPeers:(NSArray *)peers{
	NSError *error = nil;
	BOOL queued = [_session sendData:chunkData toPeers:peers withDataMode:GKSendDataReliable error:&error];
	
	if (!queued){
		NSLog(@"%s %@", __FUNCTION__, [error localizedDescription]);
	}
}

-(void)_sendChunkDataToAllPeers:(NSData *)chunkData{
	NSError *error = nil;
	BOOL queued = [_session sendDataToAllPeers:chunkData withDataMode:GKSendDataReliable error:&error];
	
	if (!queued){
		NSLog(@"%s %@", __FUNCTION__, [error localizedDescription]);
	}
}

-(void)_respondsToPeer:(NSString *)peer notificationName:(NSString *)notificationName{
	NSData *notificationData = [notificationName dataUsingEncoding:NSUTF8StringEncoding];
	NSArray *peers = [NSArray arrayWithObjects:peer, nil];
	[self _sendChunkData:notificationData toPeers:peers];
}

@end
