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
@property (assign) CGFloat width;
@property (assign) CGFloat height;


- (IBAction)cancelButton:(id)sender;
- (IBAction)okButton:(id)sender;

@end
