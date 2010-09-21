//
//  TestVC.h
//  BKSessionController
//
//  Created by boreal-kiss.com on 10/09/15.
//  Copyright 2010 boreal-kiss.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BKSessionController;
@class GKSession;

/**
 * The main view controller for UI.
 */
@interface TestVC : UIViewController {
	BKSessionController *_sessionController;
	
	//UI.
	IBOutlet UIActivityIndicatorView *_indicator;
	IBOutlet UILabel *_label;
	IBOutlet UIProgressView *_progressView;
	IBOutlet UIImageView *_connectionStateImageView;
}
@property (nonatomic, retain) BKSessionController *sessionController;
@property (nonatomic, assign) UILabel *label;
@property (nonatomic, assign) UIActivityIndicatorView *indicator;
@property (nonatomic, assign) UIProgressView *progressView;
@property (nonatomic, assign) UIImageView *connectionStateImageView;

/**
 * Finds other devices connected to via a GKSession object.
 */
-(IBAction)findPeer:(id)sender;

/**
 * Selects an image from the photo library.
 */
-(IBAction)selectImage:(id)sender;

/**
 * Configures a BKSessionController object from a GKSession object.
 */
-(void)createSession:(GKSession *)session;

/**
 * Sends an image to other device via a GKSession object.
 */
-(void)sendImage:(UIImage *)image;

/**
 * Save the received image from a remote peer to the photo library.
 */
-(void)saveImage;
@end
