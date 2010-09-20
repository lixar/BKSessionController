//
//  TestVC.m
//  BKSessionController
//
//  Created by boreal-kiss.com on 10/09/15.
//  Copyright 2010 boreal-kiss.com. All rights reserved.
//

#import "TestVC.h"
#import "TestVC-UIImagePickerControllerDelegate.h"
#import "TestVC-GKPeerPickerControllerDelegate.h"
#import "TestVC-BKSessionControllerDelegate.h"
#import "TestVC-Animation.h"
#import "BKSessionController.h"

//Private
@interface TestVC ()
-(void)_image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
@end

@implementation TestVC
@synthesize sessionController = _sessionController;
@synthesize indicator = _indicator;
@synthesize label = _label;
@synthesize progressView = _progressView;
@synthesize connectionStateImageView = _connectionStateImageView;

-(void)viewDidLoad{
	_label.text = @"";
	_label.textColor = [UIColor whiteColor];
	_indicator.hidesWhenStopped = YES;
	_progressView.hidden = YES;
	
	//_connectionStateImageView.hidden = YES;
	_connectionStateImageView.alpha = 0.0;
}

-(IBAction)findPeer:(id)sender{	
	GKPeerPickerController *peerPicker = [[GKPeerPickerController alloc] init];
	[peerPicker autorelease];
	peerPicker.delegate = self;
	peerPicker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
	[peerPicker show];
}

-(IBAction)selectImage:(id)sender{
	UIImagePickerController *imagePicker = [[[UIImagePickerController alloc] init] autorelease];
	imagePicker.delegate = self;
	imagePicker.allowsEditing = NO;
	imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	[self presentModalViewController:imagePicker animated:YES];
}

-(void)createSession:(GKSession *)session{
	self.sessionController = [BKSessionController sessionControllerWithSession:session];
	_sessionController.delegate = self;
}

-(void)sendImage:(UIImage *)image{
	NSLog(@"%s", __FUNCTION__);
	
	if (_sessionController == nil){
		return;
	}
	
	NSData *imageData = UIImagePNGRepresentation(image);
	[_sessionController sendDataToAllPeers:imageData];
}
 
-(void)saveImage{
	UIImage *image = [UIImage imageWithData:_sessionController.receivedData];
	UIImageWriteToSavedPhotosAlbum(image, self, @selector(_image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)dealloc {
	self.sessionController = nil;
	self.indicator = nil;
	self.label = nil;
	self.progressView = nil;
	self.connectionStateImageView = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Private

/**
 * Call back.
 */
-(void)_image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
	[self _setLabelText:@"Image saved."];
}

@end
