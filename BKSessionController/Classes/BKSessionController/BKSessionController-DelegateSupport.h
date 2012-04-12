//
//  BKSessionController-DelegateSupport.h
//  BKSessionController
//
//  Created by boreal-kiss.com on 10/09/15.
//  Copyright 2010 boreal-kiss.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BKSessionController.h"

/**
 * Private category.
 */
@interface BKSessionController (_DelegateSupport)
-(void)_senderWillStartSendingData;
-(void)_senderDidFinishSendingData;
-(void)_receiverWillStartReceivingData;
-(void)_receiverDidFinishReceivingData;
-(void)_receiverDidReceiveData;
-(void)_peerDidConnect;
-(void)_peerDidDisconnect;
@end
