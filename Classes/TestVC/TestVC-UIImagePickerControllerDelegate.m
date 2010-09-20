//
//  TestVC-UIImagePickerControllerDelegate.m
//  BKSessionController
//
//  Created by boreal-kiss.com on 10/09/15.
//  Copyright 2010 boreal-kiss.com. All rights reserved.
//

#import "TestVC-UIImagePickerControllerDelegate.h"


@implementation TestVC (_UIImagePickerControllerDelegate)

- (void)imagePickerController:(UIImagePickerController *) picker didFinishPickingMediaWithInfo:(NSDictionary *) info{
	UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
	
	[self sendImage:image];
	
	[picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *) picker{
	[picker dismissModalViewControllerAnimated:YES];
}

@end
