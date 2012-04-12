//
//  BKChunkDataContainer.m
//  BKSessionController
//
//  Created by boreal-kiss.com on 10/09/15.
//  Copyright 2010 boreal-kiss.com. All rights reserved.
//

#import "BKChunkDataContainer.h"

//Private
static NSUInteger DefaultChunkLength = 12800;
static NSUInteger MaximumChunkLength = 87000;

//Private
@interface BKChunkDataContainer ()
-(void)_setup;
-(void)_createChunkData;
@end

@implementation BKChunkDataContainer
@synthesize chunkLength = _chunkLength;
@synthesize data = _data;
@synthesize chunkDataContainer = _chunkDataContainer;

+(id)chunkDataContainerWithData:(NSData *)data{
	return [[[[self class] alloc] initWithData:data] autorelease];
}

+(id)chunkDataContainerWithData:(NSData *)data chunkLength:(NSUInteger)length{
	return [[[[self class] alloc] initWithData:data chunkLength:length] autorelease];
}

-(id)initWithData:(NSData *)data{
	return [self initWithData:data chunkLength:DefaultChunkLength];
}

-(id)initWithData:(NSData *)data chunkLength:(NSUInteger)length{
	if (self = [super init]){
		self.data = data;
		_chunkLength = length;
		
		//The chunk size is too large.
		if (_chunkLength > MaximumChunkLength){
			NSLog(@"%s Chunk data size larger than %d bytes. Use smaller one or default value.", __FUNCTION__, _chunkLength);
		}
		
		[self _setup];
	}
	return self;
}

-(NSData *)chunkDataAtIndex:(NSUInteger)index{
	return (NSData *)[_chunkDataContainer objectAtIndex:index];
}

-(NSUInteger)count{
	return [_chunkDataContainer count];
}
		
-(void)dealloc{
	self.data = nil;
	self.chunkDataContainer = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark Private

-(void)_setup{
	[self _createChunkData];
}

-(void)_createChunkData{
	//NSLog(@"%s", __FUNCTION__);
	
	int numItems = ceil((double)_data.length / _chunkLength);
	_chunkDataContainer = [[NSMutableArray alloc] initWithCapacity:numItems];
	
	for (int i=0; i<numItems; i++){
		NSUInteger start = i * _chunkLength;
		NSUInteger length = _chunkLength;
		NSUInteger end = start + length;
		
		//The chunk position exceeds the range of the source data.
		if (end > _data.length){
			length = _data.length % _chunkLength;
		}
		
		NSRange range = {start, length};
		NSData *chunkData = [_data subdataWithRange:range];
		
		[_chunkDataContainer addObject:chunkData];
	}
}

@end
