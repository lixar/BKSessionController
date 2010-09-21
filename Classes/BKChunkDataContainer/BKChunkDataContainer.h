//
//  BKChunkDataContainer.h
//  BKSessionController
//
//  Created by boreal-kiss.com on 10/09/15.
//  Copyright 2010 boreal-kiss.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A private class splitting data into smaller chunks in a specified size and preserves them in an array.
 */
@interface BKChunkDataContainer : NSObject {
	NSUInteger _chunkLength;
	NSData *_data;
	NSMutableArray *_chunkDataContainer;
}

/**
 * Returns chunk length in bytes.
 */
@property (nonatomic, readonly) NSUInteger chunkLength;

/**
 * Data in bulk.
 */
@property (nonatomic, copy) NSData *data;

/**
 * The container for chunk data.
 */
@property (nonatomic, retain) NSMutableArray *chunkDataContainer;

/**
 * The convenience method. 
 */
+(id)chunkDataContainerWithData:(NSData *)data;

/**
 * The convenience method. 
 */
+(id)chunkDataContainerWithData:(NSData *)data chunkLength:(NSUInteger)length;

/**
 * The initializer splitting data in a default chunk length.
 */
-(id)initWithData:(NSData *)data;

/**
 * The designated initializer.
 */
-(id)initWithData:(NSData *)data chunkLength:(NSUInteger)length;

/**
 * Returns a chunk at a specific location.
 */
-(NSData *)chunkDataAtIndex:(NSUInteger)index;

/**
 * Returns a chunk data count.
 */
-(NSUInteger)count;
@end
