//
//  BKSessionController.m
//  P2PTest
//
//  Created by boreal-kiss.com on 10/09/15.
//  Copyright 2010 boreal-kiss.com. All rights reserved.
//

#import "BKSessionController.h"
#import "BKSessionController-GKSessionDelegate.h"
#import "BKSessionController-DelegateSupport.h"
#import "BKChunkDataContainer.h"

//Public
NSString * const BKSessionControllerSenderWillStartSendingDataNotification		= @"BKSessionControllerSenderWillStartSendingData";
NSString * const BKSessionControllerSenderDidFinishSendingDataNotification		= @"BKSessionControllerSenderDidFinishSendingData";
NSString * const BKSessionControllerReceiverWillStartReceivingDataNotification	= @"BKSessionControllerReceiverWillStartReceivingData";
NSString * const BKSessionControllerReceiverDidFinishReceivingDataNotification	= @"BKSessionControllerReceiverDidFinishReceivingData";
NSString * const BKSessionControllerReceiverDidReceiveDataNotification			= @"BKSessionControllerReceiverDidReceiveData";
NSString * const BKSessionControllerPeerDidConnectNotification					= @"BKSessionControllerPeerDidConnect";
NSString * const BKSessionControllerPeerDidDisconnectNotification				= @"BKSessionControllerPeerDidDisconnect";

//Private
@interface BKSessionController ()
-(void)_sendDataHeaderToAllPeers;
-(void)_sendDataHeaderToPeers:(NSArray *)peers;
-(void)_sendChunkDataCountToAllPeers:(int)count;
-(void)_sendChunkDataCount:(int)count toPeers:(NSArray *)peers;
-(void)_sendDataFooterToAllPeers;
-(void)_sendDataFooterToPeers:(NSArray *)peers;
-(void)_sendChunkData:(NSData *)chunkData toPeers:(NSArray *)peers;
-(void)_sendChunkDataToAllPeers:(NSData *)chunkData;
-(void)_respondsToPeer:(NSString *)peer notificationName:(NSString *)notificationName;
@end

@implementation BKSessionController
@synthesize session = _session;
@synthesize delegate = _delegate;
@synthesize receivedData = _receivedData;
@synthesize progress = _progress;

+(id)sessionControllerWithSession:(GKSession *)session{
	return [[[[self class] alloc] initWithSession:session] autorelease];
}

-(id)initWithSession:(GKSession *)session{
	if (self = [super init]){
		self.session = session;
		_session.delegate = self;
		[_session setDataReceiveHandler:self withContext:nil];
	}
	return self;
}

-(void)sendData:(NSData *)data toPeers:(NSArray *)peers{
	//Header data.
	[self _sendDataHeaderToPeers:peers];
	
	BKChunkDataContainer *dataContainer = [BKChunkDataContainer chunkDataContainerWithData:data];
	int iMax = [dataContainer count];
	
	//Count data.
	[self _sendChunkDataCount:iMax toPeers:peers];
	
	//Actual data.
	for (int i=0; i<iMax; i++){
		[self _sendChunkData:[dataContainer chunkDataAtIndex:i] toPeers:peers];
	}
	
	//Footer data.
	[self _sendDataFooterToPeers:peers];
}

-(void)sendDataToAllPeers:(NSData *)data{
	//Header data.
	[self _sendDataHeaderToAllPeers];
	
	BKChunkDataContainer *dataContainer = [BKChunkDataContainer chunkDataContainerWithData:data];
	int iMax = [dataContainer count];
	
	//Count data.
	[self _sendChunkDataCountToAllPeers:iMax];
	
	//Actual data.
	for (int i=0; i<iMax; i++){
		[self _sendChunkDataToAllPeers:[dataContainer chunkDataAtIndex:i]];
	}
	
	//Footer data.
	[self _sendDataFooterToAllPeers];
}

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context{
	NSLog(@"%s", __FUNCTION__);
	
	static BOOL haveChunkDataCount = YES;
	static int totalChunkDataCount = 0;
	static int currentChunkDataCount = 0;
	
	NSString *str = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	
	//The sender receives the first response from the receiver.
	if ([str isEqualToString:BKSessionControllerReceiverWillStartReceivingDataNotification]){
		[self _senderWillStartSendingData];
		return;
	}
	
	//The sender receives the last response from the receiver.
	if ([str isEqualToString:BKSessionControllerReceiverDidFinishReceivingDataNotification]){
		[self _senderDidFinishSendingData];
		return;
	}
	
	//The receiver receives header data.
	if ([str isEqualToString:BKSessionControllerSenderWillStartSendingDataNotification]){
		_receivedData = [[NSMutableData alloc] init];
		haveChunkDataCount = NO;
		_progress = 0.0;
		[self _respondsToPeer:peer notificationName:BKSessionControllerReceiverWillStartReceivingDataNotification];
		[self _receiverWillStartReceivingData];
		return;
	}
	
	//The receiver receives footer data.
	if ([str isEqualToString:BKSessionControllerSenderDidFinishSendingDataNotification]){
		[self _respondsToPeer:peer notificationName:BKSessionControllerReceiverDidFinishReceivingDataNotification];
		[self _receiverDidFinishReceivingData];
		return;
	}
	
	//The receiver receives chunk data count.
	if(!haveChunkDataCount){
		totalChunkDataCount = [str intValue];
		currentChunkDataCount = 0;
		haveChunkDataCount = YES;
		return;
	}
	
	//Data transmission in progress.
	if (_receivedData){
		[_receivedData appendData:data];
		
		currentChunkDataCount++;
		_progress = (float) currentChunkDataCount / totalChunkDataCount;
		[self _receiverDidReceiveData];
	}
}

-(void)disconnect{
	[_session disconnectFromAllPeers];
	_session.available = NO;
	[_session setDataReceiveHandler:nil withContext:nil];
	_session.delegate = nil;
	self.session = nil;
}

-(void)dealloc{
	self.delegate = nil;
	self.session = nil;
	self.receivedData = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark Private

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
