//
//  BKSessionController-Utilities.h
//  BKSessionController
//
//  Created by boreal-kiss.com on 10/09/28.
//  Copyright 2010 boreal-kiss.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BKSessionController.h"

/**
 * Private category.
 */
@interface BKSessionController (_Utilities)

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
