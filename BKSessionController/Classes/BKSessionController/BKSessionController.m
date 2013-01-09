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

#define MAX_MESSAGE_SIZE 87000

//Public
NSString * const BKSessionControllerSenderWillStartSendingDataNotification		= @"BKSessionControllerSenderWillStartSendingData";
NSString * const BKSessionControllerSenderDidFinishSendingDataNotification		= @"BKSessionControllerSenderDidFinishSendingData";
NSString * const BKSessionControllerReceiverWillStartReceivingDataNotification	= @"BKSessionControllerReceiverWillStartReceivingData";
NSString * const BKSessionControllerReceiverDidFinishReceivingDataNotification	= @"BKSessionControllerReceiverDidFinishReceivingData";
NSString * const BKSessionControllerReceiverDidReceiveDataNotification			= @"BKSessionControllerReceiverDidReceiveData";
NSString * const BKSessionControllerPeerDidConnectNotification					= @"BKSessionControllerPeerDidConnect";
NSString * const BKSessionControllerPeerIsAvailable                     = @"BKSessionControllerPeerIsAvailable";
NSString * const BKSessionControllerPeerConnectionFailedNotification				= @"BKSessionControllerPeerConnectionFailedNotification";
NSString * const BKSessionControllerPeerDidDisconnectNotification				= @"BKSessionControllerPeerDidDisconnect";
NSString * const BKSessionControllerPeerRequestConnectionNotification   = @"BKSessionControllerPeerRequestConnectionNotification";

//Private
@interface BKSessionController ()
@property (nonatomic, retain, readwrite) NSMutableDictionary *receivedDataFromPeer;
-(void)_senderReceiveData:(NSData *)data fromPeer:(NSString *)peer;
-(void)_receiverReceiveData:(NSData *)data fromPeer:(NSString *)peer;

-(BOOL)_dataIsHeader:(NSData *)data;
-(BOOL)_dataIsFooter:(NSData *)data;
@end

@implementation BKSessionController
@synthesize session = _session;
@synthesize delegate = _delegate;
@synthesize progress = _progress;
@synthesize receivedDataFromPeer = _receivedDataFromPeer;

+(id)sessionControllerWithSession:(GKSession *)session{
	return [[[[self class] alloc] initWithSession:session] autorelease];
}

-(id)initWithSession:(GKSession *)session{
	if (self = [super init]){
		self.session = session;
		_session.delegate = self;
		[_session setDataReceiveHandler:self withContext:nil];
		_isSender = NO;
    _receivedDataFromPeer = [[NSMutableDictionary alloc] init];
    _isChunkDataFromPeer = [[NSMutableDictionary alloc] init];
	}
	return self;
}

-(void)sendData:(NSData *)data toPeers:(NSArray *)peers{
	_isSender = YES;
	
  if ([data length] < MAX_MESSAGE_SIZE)
  {
    [self _sendChunkData:data toPeers:peers];
    _isSender = NO;
    return;
  }
  
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
	_isSender = YES;
  
  if ([data length] < MAX_MESSAGE_SIZE)
  {
    [self.session sendDataToAllPeers:data withDataMode:GKSendDataReliable error:NULL];
    _isSender = NO;
    return;
  }  
	
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
	NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  
	if ([self _dataIsHeader:data]){
		_isSender = NO;
	}
	
	if (_isSender && ([dataString isEqualToString:BKSessionControllerSenderDidFinishSendingDataNotification] || [dataString isEqualToString:BKSessionControllerSenderWillStartSendingDataNotification])){
		[self _senderReceiveData:data fromPeer:peer];
	}
	else if (![dataString isEqualToString:BKSessionControllerReceiverDidFinishReceivingDataNotification]){
		[self _receiverReceiveData:data fromPeer:peer];
	}
  
  [dataString release];
}

/*
- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context{
	NSLog(@"%s", __FUNCTION__);
	
	NSString *str = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	
	//Receives header data.
	if ([str isEqualToString:BKSessionControllerSenderWillStartSendingDataNotification]){
		_isSender = NO;
	}
	
	if (_isSender){
		[self _senderReceiveData:data fromPeer:peer];
	}
	else{
		[self _receiverReceiveData:data fromPeer:peer];
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

-(void)disconnectPeerFromPeers:(NSString *)peerID
{
  [_session disconnectPeerFromAllPeers:peerID];
}

-(void)dealloc{
	self.delegate = nil;
	self.session = nil;
  self.receivedDataFromPeer = nil;
  [_isChunkDataFromPeer release];
  _isChunkDataFromPeer = nil;
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
#warning [RG] need to move these peer specific dictionaries so can know proper progress
	static int totalChunkDataCount = 0;
	static int currentChunkDataCount = 0;
	
	//The receiver receives header data.
	if ([self _dataIsHeader:data]){
    NSMutableData *inData = [[NSMutableData alloc] init];
    [self.receivedDataFromPeer setObject:inData forKey:peer];
    [inData release];
		_progress = 0.0;
    [_isChunkDataFromPeer setObject:[NSNumber numberWithBool:NO] forKey:peer];
		
		[self _respondsToPeer:peer notificationName:BKSessionControllerReceiverWillStartReceivingDataNotification];
		[self _receiverWillStartReceivingData];
		return;
	}
	
	//The receiver receives footer data.
	if ([self _dataIsFooter:data]){
		[self _respondsToPeer:peer notificationName:BKSessionControllerReceiverDidFinishReceivingDataNotification];
		[self _receiverDidFinishReceivingData:peer];
		return;
	}
	
  if (![self.receivedDataFromPeer objectForKey:peer])
  {
    [self.receivedDataFromPeer setObject:data forKey:peer];
    _isSender = YES;
		[self _respondsToPeer:peer notificationName:BKSessionControllerReceiverDidFinishReceivingDataNotification];
		[self _receiverDidFinishReceivingData:peer];
    return;
  }
  
	//The receiver receives chunk data count.
	if(NO == [[_isChunkDataFromPeer objectForKey:peer] boolValue]){
		NSString *str = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
		totalChunkDataCount = [str intValue];
		currentChunkDataCount = 0;
    [_isChunkDataFromPeer setObject:[NSNumber numberWithBool:YES] forKey:peer];
		return;
	}
	
	//The receiver receives actual data.
	if ([self.receivedDataFromPeer objectForKey:peer]){
    NSMutableData *inData = [self.receivedDataFromPeer objectForKey:peer];
    [inData appendData:data];
		currentChunkDataCount++;
		_progress = (float) currentChunkDataCount / totalChunkDataCount;
		
		[self _receiverDidReceiveData:peer];
	}
}
/*
-(void)_receiverReceiveData:(NSData *)data fromPeer:(NSString *)peer{
	static BOOL haveChunkDataCount = NO;
	static int totalChunkDataCount = 0;
	static int currentChunkDataCount = 0;
	
	NSString *str = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	
	//The receiver receives header data.
	if ([str isEqualToString:BKSessionControllerSenderWillStartSendingDataNotification]){
		self.receivedData = [[[NSMutableData alloc] init] autorelease];
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
	
	//The receiver receives actual data.
	if (_receivedData){
		[_receivedData appendData:data];
		currentChunkDataCount++;
		_progress = (float) currentChunkDataCount / totalChunkDataCount;
		
		[self _receiverDidReceiveData];
	}
}
 */

/**
 * Returns YES if the data is a header.
 */
-(BOOL)_dataIsHeader:(NSData *)data{
	NSString *str = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	return [str isEqualToString:BKSessionControllerSenderWillStartSendingDataNotification];
}

/**
 * Returns YES if the data is a footer.
 */
-(BOOL)_dataIsFooter:(NSData *)data{
	NSString *str = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	return [str isEqualToString:BKSessionControllerSenderDidFinishSendingDataNotification];
}

@end
