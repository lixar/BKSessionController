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
#import "BKSessionController-Utilities.h"
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
@property (nonatomic, retain, readwrite) NSMutableData *receivedData;
-(void)_senderReceiveData:(NSData *)data fromPeer:(NSString *)peer;
-(void)_receiverReceiveData:(NSData *)data fromPeer:(NSString *)peer;
@end

@implementation BKSessionController
@synthesize session = _session;
@synthesize delegate = _delegate;
@synthesize receivedData = _receivedData;
@synthesize progress = _progress;


//New
@synthesize isSender = _isSender;

+(id)sessionControllerWithSession:(GKSession *)session{
	return [[[[self class] alloc] initWithSession:session] autorelease];
}

/*
-(id)initWithSession:(GKSession *)session{
	if (self = [super init]){
		self.session = session;
		_session.delegate = self;
		[_session setDataReceiveHandler:self withContext:nil];
	}
	return self;
}
 */

-(id)initWithSession:(GKSession *)session{
	if (self = [super init]){
		self.session = session;
		_session.delegate = self;
		
		//New
		self.isSender = NO;
	}
	return self;
}

-(void)sendData:(NSData *)data toPeers:(NSArray *)peers{
	//New
	self.isSender = YES;
	
	//Sends header data.
	[self _sendDataHeaderToPeers:peers];
	
	//Creates chunk data.
	BKChunkDataContainer *dataContainer = [BKChunkDataContainer chunkDataContainerWithData:data];
	int iMax = [dataContainer count];
	
	//Sends count data.
	[self _sendChunkDataCount:iMax toPeers:peers];
	
	//Sends actual data.
	for (int i=0; i<iMax; i++){
		[self _sendChunkData:[dataContainer chunkDataAtIndex:i] toPeers:peers];
	}
	
	//Sends footer data.
	[self _sendDataFooterToPeers:peers];
}

-(void)sendDataToAllPeers:(NSData *)data{
	//New
	self.isSender = YES;
	
	//Sends header data.
	[self _sendDataHeaderToAllPeers];
	
	//Creates chunk data.
	BKChunkDataContainer *dataContainer = [BKChunkDataContainer chunkDataContainerWithData:data];
	int iMax = [dataContainer count];
	
	//Sends count data.
	[self _sendChunkDataCountToAllPeers:iMax];
	
	//Sends actual data.
	for (int i=0; i<iMax; i++){
		[self _sendChunkDataToAllPeers:[dataContainer chunkDataAtIndex:i]];
	}
	
	//Sends footer data.
	[self _sendDataFooterToAllPeers];
}

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context{
	NSLog(@"%s", __FUNCTION__);
	
	//NSLog(@"isSender: %d", context);
	//NSLog(@"context: %@", context);
	
	NSString *str = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	
	//The receiver receives header data.
	if ([str isEqualToString:BKSessionControllerSenderWillStartSendingDataNotification]){
		self.isSender = NO;
	}
	
	if (_isSender){
		[self _senderReceiveData:data fromPeer:peer];
	}
	else{
		[self _receiverReceiveData:data fromPeer:peer];
	}
}

/*
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
 */

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

/**
 * Receives responses from the data receiver.
 */
-(void)_senderReceiveData:(NSData *)data fromPeer:(NSString *)peer{
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
}

/**
 * Receives data from the sender.
 */
-(void)_receiverReceiveData:(NSData *)data fromPeer:(NSString *)peer{
	static BOOL haveChunkDataCount = NO;
	static int totalChunkDataCount = 0;
	static int currentChunkDataCount = 0;
	
	NSString *str = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	
	//The receiver receives header data.
	if ([str isEqualToString:BKSessionControllerSenderWillStartSendingDataNotification]){
		_receivedData = [[NSMutableData alloc] init];
		_progress = 0.0;
		haveChunkDataCount = NO;
		
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

@end
