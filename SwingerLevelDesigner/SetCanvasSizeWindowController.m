//
//  SetCanvasSizeWindowController.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 5/28/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "SetCanvasSizeWindowController.h"

@interface SetCanvasSizeWindowController ()

@end

@implementation SetCanvasSizeWindowController

@synthesize heightField;
@synthesize widthField;
@synthesize height;
@synthesize width;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void) awakeFromNib {
    [widthField setFloatValue:width];    
    [heightField setFloatValue:height];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)cancelButton:(id)sender {
    [NSApp stopModalWithCode:0];
}

- (IBAction)okButton:(id)sender {
    height = [heightField floatValue];
    width = [widthField floatValue];
    
    [NSApp stopModalWithCode:1];
}


@end
