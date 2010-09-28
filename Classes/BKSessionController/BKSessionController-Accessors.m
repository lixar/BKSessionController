//
//  BKSessionController-Accessors.m
//  BKSessionController
//
//  Created by boreal-kiss.com on 10/09/28.
//  Copyright 2010 boreal-kiss.com. All rights reserved.
//

#import "BKSessionController-Accessors.h"


@implementation BKSessionController (Accessors)

-(void)setIsSender:(BOOL)yn{
	_isSender = yn;
	[_session setDataReceiveHandler:self withContext:[NSNumber numberWithBool:_isSender]];
}

-(BOOL)isSender{
	return _isSender;
}

@end
