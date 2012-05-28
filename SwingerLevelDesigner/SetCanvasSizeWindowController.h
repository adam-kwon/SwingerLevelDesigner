//
//  SetCanvasSizeWindowController.h
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 5/28/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SetCanvasSizeWindowController : NSWindowController {
    
}

@property (assign) IBOutlet NSTextField *widthField;
@property (assign) IBOutlet NSTextField *heightField;
@property (assign) IBOutlet NSTextField *deviceWidthField;
@property (assign) IBOutlet NSTextField *deviceHeightField;
@property (assign) CGFloat width;
@property (assign) CGFloat height;
@property (assign) CGFloat deviceScreenWidth;
@property (assign) CGFloat deviceScreenHeight;


- (IBAction)cancelButton:(id)sender;
- (IBAction)okButton:(id)sender;

@end
